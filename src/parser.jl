# Unit Expression Parser
# Parses strings like "kg*m/s^2" into structured unit expressions

# Struct to represent a parsed unit expression
struct UnitExpression
    components::Vector{Tuple{String, Rational{Int}}}  # (unit_name, exponent)
end

# Helper to create empty unit expression
UnitExpression() = UnitExpression(Vector{Tuple{String, Rational{Int}}}())

# Parse a unit string into a UnitExpression
function parse_unit(unit_str::String)::UnitExpression
    # Remove whitespace
    unit_str = replace(unit_str, " " => "")

    if isempty(unit_str)
        error("Empty unit string")
    end

    # Split by division first
    parts = split(unit_str, '/')

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

    # Split by multiplication
    factors = split(expr, '*')

    for factor in factors
        if isempty(factor)
            continue
        end

        # Check for exponent
        if occursin('^', factor)
            parts = split(factor, '^')
            if length(parts) != 2
                error("Invalid exponent syntax in: $factor")
            end

            unit_name = String(parts[1])
            exponent_str = String(parts[2])

            # Parse exponent (can be integer or rational like "1/2")
            exponent = parse_exponent(exponent_str)

            push!(components, (unit_name, sign * exponent))
        else
            # No exponent, default to 1
            push!(components, (String(factor), sign * (1//1)))
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
