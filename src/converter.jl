# Main conversion function

"""
    convert_unit(from_unit::String, to_unit::String) -> Float64

Convert between two unit expressions and return the conversion factor.

# Examples
```julia
convert_unit("s", "minute")       # Returns 1/60 ≈ 0.01667
convert_unit("N", "kg*m/s^2")     # Returns 1.0
convert_unit("km", "m")           # Returns 1000.0
```

The function handles:
- Simple unit conversions: "m" to "km"
- Compound units: "N" to "kg*m/s^2"
- Complex expressions: "kg*m^2/s^2" to "J"

Throws an error if:
- Units are unknown
- Units are dimensionally incompatible
"""
function convert_unit(from_unit::String, to_unit::String)::Float64
    # Try simple graph-based lookup first (more efficient for simple conversions)
    graph_result = find_conversion_path(from_unit, to_unit)
    if graph_result !== nothing
        return graph_result
    end

    # Fall back to dimensional analysis for compound units
    return convert_unit_dimensional(from_unit, to_unit)
end

# Convert using dimensional analysis
function convert_unit_dimensional(from_unit::String, to_unit::String)::Float64
    # Parse and reduce both units to base SI units
    from_factor, from_dims = reduce_unit_string(from_unit)
    to_factor, to_dims = reduce_unit_string(to_unit)

    # Check dimensional compatibility
    if !dimensions_compatible(from_dims, to_dims)
        error("Cannot convert between incompatible units: " *
              "'$from_unit' [$(format_dimensions(from_dims))] and " *
              "'$to_unit' [$(format_dimensions(to_dims))]")
    end

    # Calculate conversion factor
    # If from_unit = k1 * base_units and to_unit = k2 * base_units
    # then from_unit = (k1/k2) * to_unit
    # So conversion factor is k1/k2
    return from_factor / to_factor
end
