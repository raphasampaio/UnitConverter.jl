# Unit Expression Parser
# Parses strings like "kg*m/s^2" into structured unit expressions

# Struct to represent a parsed unit expression
struct UnitExpression
    components::Vector{Tuple{String, Rational{Int}}}  # (unit_name, exponent)
end

# Helper to create empty unit expression
UnitExpression() = UnitExpression(Vector{Tuple{String, Rational{Int}}}())

# Helper to split a string by a delimiter, but only outside of parentheses
function smart_split(s::AbstractString, delim::Char)::Vector{String}
    parts = String[]
    depth = 0
    start_idx = 1

    for (i, c) in enumerate(s)
        if c == '('
            depth += 1
        elseif c == ')'
            depth -= 1
        elseif c == delim && depth == 0
            push!(parts, String(s[start_idx:i-1]))
            start_idx = i + 1
        end
    end

    # Add the last part
    if start_idx <= length(s)
        push!(parts, String(s[start_idx:end]))
    elseif start_idx == length(s) + 1
        # Empty part after final delimiter
        push!(parts, "")
    end

    return parts
end

# Helper to expand implicit exponents (e.g., "m3" -> "m^3", "hm3" -> "hm^3")
function expand_implicit_exponents(s::String)::String
    result = IOBuffer()
    chars = collect(s)  # Convert to array of characters (handles Unicode properly)
    i = 1
    while i <= length(chars)
        c = chars[i]

        # If we find a digit that's not preceded by '^', it's an implicit exponent
        if isdigit(c)
            # Check if it's preceded by '^' (explicit exponent)
            if i > 1 && chars[i-1] == '^'
                # This is an explicit exponent, keep it as is
                write(result, c)
                i += 1
            else
                # This is an implicit exponent - collect all consecutive digits
                write(result, '^')
                while i <= length(chars) && isdigit(chars[i])
                    write(result, chars[i])
                    i += 1
                end
                continue
            end
        else
            write(result, c)
            i += 1
        end
    end
    return String(take!(result))
end

# Helper to strip outer parentheses from a string
function strip_outer_parentheses(s::String)::String
    while !isempty(s) && s[1] == '(' && s[end] == ')'
        # Check if these are matching outer parentheses
        depth = 0
        all_wrapped = true
        for (i, c) in enumerate(s[2:end-1])
            if c == '('
                depth += 1
            elseif c == ')'
                depth -= 1
                if depth < 0
                    all_wrapped = false
                    break
                end
            end
        end
        if all_wrapped && depth == 0
            s = s[2:end-1]
        else
            break
        end
    end
    return s
end

# Parse a unit string into a UnitExpression
function parse_unit(unit_str::String)::UnitExpression
    # Remove whitespace
    unit_str = replace(unit_str, " " => "")

    # Convert implicit exponents (e.g., "m3" -> "m^3")
    unit_str = expand_implicit_exponents(unit_str)

    # Remove outer parentheses if they wrap the entire expression
    unit_str = strip_outer_parentheses(unit_str)

    # Empty string represents dimensionless (no units)
    if isempty(unit_str)
        return UnitExpression()
    end

    # Parse the expression as a sequence of * and / operations (left-to-right)
    all_components = parse_mul_div_sequence(unit_str)

    # Combine like units
    combined = combine_like_units(all_components)

    return UnitExpression(combined)
end

# Parse a sequence of multiplication and division operations (left-to-right)
# This handles operator precedence correctly: * and / have equal precedence
function parse_mul_div_sequence(expr::AbstractString)::Vector{Tuple{String, Rational{Int}}}
    if isempty(expr)
        return Tuple{String, Rational{Int}}[]
    end

    components = Tuple{String, Rational{Int}}[]

    # Split by both * and / (but not inside parentheses)
    # We need to track which operator was used
    tokens = String[]
    operators = Char[]

    depth = 0
    start_idx = 1

    for (i, c) in enumerate(expr)
        if c == '('
            depth += 1
        elseif c == ')'
            depth -= 1
        elseif (c == '*' || c == '/') && depth == 0
            push!(tokens, String(expr[start_idx:i-1]))
            push!(operators, c)
            start_idx = i + 1
        end
    end

    # Add the last token
    if start_idx <= length(expr)
        push!(tokens, String(expr[start_idx:end]))
    end

    # Process tokens left-to-right with their operators
    # We track the "current context": are we multiplying or dividing?
    # * means multiply the next term
    # / means divide by the next term (invert it)
    current_sign = 1  # Start with positive (numerator)

    for (i, token) in enumerate(tokens)
        if isempty(token)
            continue
        end

        # Parse this token as a single unit with exponent
        unit_components = parse_single_unit(token, current_sign)
        append!(components, unit_components)

        # Determine the sign for the NEXT token based on the operator that follows current token
        if i <= length(operators)
            if operators[i] == '*'
                # Multiplication: next term goes to numerator (positive)
                # a/b*c = (a/b)*c = (a*c)/b, so c is in numerator
                current_sign = 1
            elseif operators[i] == '/'
                # Division: next term goes to denominator (negative)
                # a*b/c = a*b*(1/c), so c is in denominator
                # a/b/c = (a/b)/c = a/(b*c), so both b and c are in denominator
                current_sign = -1
            end
        end
    end

    return components
end

# Parse a single unit (possibly with exponent) like "m^2" or "(m^3/s)"
function parse_single_unit(token::AbstractString, sign::Int)::Vector{Tuple{String, Rational{Int}}}
    if isempty(token)
        return Tuple{String, Rational{Int}}[]
    end

    token_stripped = strip_outer_parentheses(String(token))

    # Check if this is a compound expression (had outer parens and contains * or /)
    if token != token_stripped && (occursin('/', token_stripped) || occursin('*', token_stripped))
        # Recursively parse the parenthesized expression
        sub_expr = parse_unit(token_stripped)
        return [(unit, sign * exp) for (unit, exp) in sub_expr.components]
    end

    # Check for exponent
    if occursin('^', token_stripped)
        parts = smart_split(token_stripped, '^')
        if length(parts) != 2
            throw(
                InvalidUnitSyntaxError(
                    String(token_stripped),
                    "Exponent must have exactly one '^' character with unit and exponent on either side",
                ),
            )
        end

        unit_name = strip_outer_parentheses(String(parts[1]))
        exponent_str = String(parts[2])

        # Check if unit_name is a compound expression
        if occursin('/', unit_name) || occursin('*', unit_name)
            # Parse as compound, then apply exponent
            sub_expr = parse_unit(unit_name)
            exponent = parse_exponent(exponent_str)
            return [(unit, sign * exp * exponent) for (unit, exp) in sub_expr.components]
        end

        # Parse exponent (can be integer or rational like "1/2")
        exponent = parse_exponent(exponent_str)

        return [(unit_name, sign * exponent)]
    else
        # No exponent, default to 1
        return [(String(token_stripped), sign * (1 // 1))]
    end
end

# Parse an exponent string (can be "2" or "-2" or "1/2")
function parse_exponent(exp_str::AbstractString)::Rational{Int}
    exp_str = strip(exp_str)

    # Check for empty exponent
    if isempty(exp_str)
        throw(InvalidUnitSyntaxError(
            String(exp_str),
            "Exponent cannot be empty",
        ))
    end

    # Check if it's a fraction
    if occursin('/', exp_str)
        parts = split(exp_str, '/')
        if length(parts) != 2
            throw(
                InvalidUnitSyntaxError(
                    String(exp_str),
                    "Fraction exponent must have exactly one '/' with numerator and denominator",
                ),
            )
        end

        # Try to parse numerator and denominator, catching parse errors
        try
            numerator = parse(Int, strip(String(parts[1])))
            denominator = parse(Int, strip(String(parts[2])))
            return numerator // denominator
        catch e
            if e isa ArgumentError
                throw(InvalidUnitSyntaxError(
                    String(exp_str),
                    "Fraction exponent parts must be valid integers",
                ))
            else
                rethrow(e)
            end
        end
    else
        # Simple integer exponent
        try
            return parse(Int, exp_str) // 1
        catch e
            if e isa ArgumentError
                throw(InvalidUnitSyntaxError(
                    String(exp_str),
                    "Exponent must be a valid integer",
                ))
            else
                rethrow(e)
            end
        end
    end
end

# Combine like units in a component list
function combine_like_units(components::Vector{Tuple{String, Rational{Int}}})::Vector{Tuple{String, Rational{Int}}}
    combined = Dict{String, Rational{Int}}()

    for (unit, exp) in components
        if haskey(combined, unit)
            combined[unit] += exp
        else
            combined[unit] = exp
        end
    end

    # Remove units with zero exponent
    filter!(p -> p.second != 0 // 1, combined)

    # Convert back to vector of tuples and sort for consistency
    result = [(k, v) for (k, v) in combined]
    sort!(result, by = x -> x[1])

    return result
end

# Convert UnitExpression back to string (for debugging)
function Base.show(io::IO, expr::UnitExpression)
    if isempty(expr.components)
        print(io, "dimensionless")
        return
    end

    numerator = String[]
    denominator = String[]

    for (unit, exp) in expr.components
        if exp > 0
            if exp == 1 // 1
                push!(numerator, unit)
            else
                push!(numerator, "$unit^$(exp)")
            end
        else
            if exp == -1 // 1
                push!(denominator, unit)
            else
                push!(denominator, "$unit^$(abs(exp))")
            end
        end
    end

    if isempty(numerator)
        print(io, "1")
    else
        print(io, join(numerator, "*"))
    end

    if !isempty(denominator)
        print(io, "/", join(denominator, "*"))
    end
end
