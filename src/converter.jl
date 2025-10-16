# Main conversion function

"""
    convert_unit(from_unit::String, to_unit::String) -> Float64

Convert between two unit expressions and return the conversion scale factor.

This is equivalent to `convert_value(1, from_unit, to_unit)` and returns how many
`to_unit` units equal one `from_unit`.

# Examples
```julia
convert_unit("s", "minute")       # Returns 1/60 ≈ 0.01667 (1 second = 1/60 minute)
convert_unit("N", "kg*m/s^2")     # Returns 1.0
convert_unit("km", "m")           # Returns 1000.0 (1 km = 1000 m)
convert_unit("degC", "degF")      # Returns 1.8 (temperature intervals)
```

Note: For absolute temperature conversions with offsets (e.g., 0°C = 32°F),
use `convert_value` with the actual temperature value.

Throws an error if:
- Units are unknown
- Units are dimensionally incompatible
"""
function convert_unit(from_unit::String, to_unit::String)::Float64
    return convert_value(1.0, from_unit, to_unit)
end

"""
    convert_value(value::Real, from_unit::String, to_unit::String) -> Float64

Convert an actual value from one unit to another, properly handling affine transformations.

This function handles both linear conversions (simple multiplication) and affine
conversions (scale + offset), making it suitable for absolute temperature conversions.

# Affine transformation formula:
For converting value v from unit A to unit B:
1. Convert to base unit: base_value = factor_A * v + offset_A
2. Convert from base unit: result = (base_value - offset_B) / factor_B

# Examples
```julia
# Temperature conversions (absolute)
convert_value(0, "celsius", "fahrenheit")      # Returns 32.0
convert_value(100, "celsius", "fahrenheit")    # Returns 212.0
convert_value(0, "celsius", "kelvin")          # Returns 273.15

# Linear conversions work as well
convert_value(1000, "m", "km")                 # Returns 1.0
convert_value(60, "s", "minute")               # Returns 1.0

# Temperature intervals (use degC, degF for relative temperatures)
convert_value(10, "degC", "degF")              # Returns 18.0 (10°C change = 18°F change)
```

Throws an error if:
- Units are unknown
- Units are dimensionally incompatible
- Affine units are used in compound expressions
"""
function convert_value(value::Real, from_unit::String, to_unit::String)::Float64
    # Parse and reduce both units to base SI units
    from_factor, from_offset, from_dims = reduce_unit_string(from_unit)
    to_factor, to_offset, to_dims = reduce_unit_string(to_unit)

    # Check dimensional compatibility
    if !dimensions_compatible(from_dims, to_dims)
        error("Cannot convert between incompatible units: " *
              "'$from_unit' [$(format_dimensions(from_dims))] and " *
              "'$to_unit' [$(format_dimensions(to_dims))]")
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
