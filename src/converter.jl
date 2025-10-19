function convert_unit(from_unit::String, to_unit::String)::Float64
    return convert_unit(1.0, from_unit, to_unit)
end

function convert_unit(value::Real, from_unit::String, to_unit::String)::Float64
    # Parse and reduce both units to base SI units
    from_factor, from_offset, from_dims = reduce_unit_string(from_unit)
    to_factor, to_offset, to_dims = reduce_unit_string(to_unit)

    # Check dimensional compatibility
    if !dimensions_compatible(from_dims, to_dims)
        throw(DimensionalMismatchError(
            from_unit,
            to_unit,
            format_dimensions(from_dims),
            format_dimensions(to_dims),
        ))
    end

    # Affine transformation:
    # 1. Convert value to base unit: base_value = from_factor * value + from_offset
    # 2. Convert base unit to target: result = (base_value - to_offset) / to_factor
    #
    # Simplified: result = (from_factor * value + from_offset - to_offset) / to_factor

    base_value = from_factor * value + from_offset
    result = (base_value - to_offset) / to_factor

    return result
end
