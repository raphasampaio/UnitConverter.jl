# Dimensional Analysis - reduce units to base SI units
# This module handles the reduction of any unit expression to its base units

# Reduce a parsed UnitExpression to base SI units
# Returns (factor, base_dimensions) where base_dimensions is Dict{String, Rational{Int}}
function reduce_to_base(expr::UnitExpression)::Tuple{Float64, Dict{String, Rational{Int}}}
    total_factor = 1.0
    base_dimensions = Dict{String, Rational{Int}}()

    for (unit, exponent) in expr.components
        # Get the base decomposition for this unit
        decomp = get_base_decomposition(unit)

        # Multiply factor raised to the exponent
        total_factor *= decomp.factor ^ Float64(exponent)

        # Add dimensions (with exponent applied)
        for (base_unit, base_exp) in decomp.dimensions
            combined_exp = base_exp * exponent

            if haskey(base_dimensions, base_unit)
                base_dimensions[base_unit] += combined_exp
            else
                base_dimensions[base_unit] = combined_exp
            end
        end
    end

    # Remove dimensions with zero exponent
    filter!(p -> p.second != 0//1, base_dimensions)

    return (total_factor, base_dimensions)
end

# Reduce a unit string to base units
function reduce_unit_string(unit_str::String)::Tuple{Float64, Dict{String, Rational{Int}}}
    expr = parse_unit(unit_str)
    return reduce_to_base(expr)
end

# Check if two dimension dictionaries are compatible (same dimensions)
function dimensions_compatible(dim1::Dict{String, Rational{Int}}, dim2::Dict{String, Rational{Int}})::Bool
    # Get all unique base units
    all_units = union(keys(dim1), keys(dim2))

    for unit in all_units
        exp1 = get(dim1, unit, 0//1)
        exp2 = get(dim2, unit, 0//1)

        if exp1 != exp2
            return false
        end
    end

    return true
end

# Format dimensions as a string (for error messages)
function format_dimensions(dimensions::Dict{String, Rational{Int}})::String
    if isempty(dimensions)
        return "dimensionless"
    end

    numerator = String[]
    denominator = String[]

    for (unit, exp) in sort(collect(dimensions), by=x->x[1])
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

    result = ""
    if !isempty(numerator)
        result = join(numerator, "*")
    else
        result = "1"
    end

    if !isempty(denominator)
        result *= "/" * join(denominator, "*")
    end

    return result
end
