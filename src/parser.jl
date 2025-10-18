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

    # Split by division first (but not inside parentheses)
    parts = smart_split(unit_str, '/')

    numerator_components = Tuple{String, Rational{Int}}[]
    denominator_components = Tuple{String, Rational{Int}}[]

    # Parse numerator (everything before first /)
    if length(parts) >= 1 && !isempty(parts[1])
        numerator_components = parse_product(parts[1], 1)
    end

    # Parse denominator (each part after / is in denominator)
    # e.g., "kg/m/s^2" = kg * m^-1 * s^-2
    if length(parts) >= 2
        for i in 2:length(parts)
            if !isempty(parts[i])
                append!(denominator_components, parse_product(parts[i], -1))
            end
        end
    end

    # Combine numerator and denominator
    all_components = vcat(numerator_components, denominator_components)

    # Combine like units
    combined = combine_like_units(all_components)

    return UnitExpression(combined)
end

# Parse a product expression like "kg*m^2"
function parse_product(expr::AbstractString, sign::Int)::Vector{Tuple{String, Rational{Int}}}
    if isempty(expr)
        return Tuple{String, Rational{Int}}[]
    end

    components = Tuple{String, Rational{Int}}[]

    # Split by multiplication (but not inside parentheses)
    factors = smart_split(expr, '*')

    for factor in factors
        if isempty(factor)
            continue
        end

        # Strip parentheses from the factor
        factor_stripped = strip_outer_parentheses(String(factor))

        if isempty(factor_stripped)
            continue
        end

        # Check if this was a parenthesized expression (had outer parens that we removed)
        # If so, it might be a compound expression like (m^3/s) that needs recursive parsing
        if factor != factor_stripped && (occursin('/', factor_stripped) || occursin('*', factor_stripped))
            # Recursively parse the parenthesized expression
            sub_expr = parse_unit(factor_stripped)
            for (unit, exp) in sub_expr.components
                push!(components, (unit, sign * exp))
            end
        # Check for exponent
        elseif occursin('^', factor_stripped)
            parts = smart_split(factor_stripped, '^')
            if length(parts) != 2
                error("Invalid exponent syntax in: $factor_stripped")
            end

            unit_name = strip_outer_parentheses(String(parts[1]))
            exponent_str = String(parts[2])

            # Parse exponent (can be integer or rational like "1/2")
            exponent = parse_exponent(exponent_str)

            push!(components, (unit_name, sign * exponent))
        else
            # No exponent, default to 1
            push!(components, (String(factor_stripped), sign * (1//1)))
        end
    end

    return components
end

# Parse an exponent string (can be "2" or "-2" or "1/2")
function parse_exponent(exp_str::AbstractString)::Rational{Int}
    exp_str = strip(exp_str)

    # Check if it's a fraction
    if occursin('/', exp_str)
        parts = split(exp_str, '/')
        if length(parts) != 2
            error("Invalid fraction exponent: $exp_str")
        end
        numerator = parse(Int, strip(String(parts[1])))
        denominator = parse(Int, strip(String(parts[2])))
        return numerator // denominator
    else
        # Simple integer exponent
        return parse(Int, exp_str) // 1
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
    filter!(p -> p.second != 0//1, combined)

    # Convert back to vector of tuples and sort for consistency
    result = [(k, v) for (k, v) in combined]
    sort!(result, by=x->x[1])

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
            if exp == 1//1
                push!(numerator, unit)
            else
                push!(numerator, "$unit^$(exp)")
            end
        else
            if exp == -1//1
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
