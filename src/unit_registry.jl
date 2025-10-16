# Unit Registry - defines all known units and their relationships to base units
# All data structures are const (no __init__ needed)

# SI Base Units (dimensionally independent)
const SI_BASE_UNITS = Set([
    "m",      # meter (length)
    "kg",     # kilogram (mass)
    "s",      # second (time)
    "A",      # ampere (electric current)
    "K",      # kelvin (temperature)
    "mol",    # mole (amount of substance)
    "cd"      # candela (luminous intensity)
])

# Struct to represent a unit in terms of base units
# Supports affine transformations: base_value = factor * unit_value + offset
struct BaseUnitDecomposition
    factor::Float64                          # multiplicative scale factor
    offset::Float64                          # additive offset (for affine units like temperature)
    dimensions::Dict{String, Rational{Int}}  # base unit -> exponent
end

# Helper constructors for simple units (no offset)
BaseUnitDecomposition(factor::Real) =
    BaseUnitDecomposition(Float64(factor), 0.0, Dict{String, Rational{Int}}())
BaseUnitDecomposition(factor::Real, unit::String, exp::Rational{Int}) =
    BaseUnitDecomposition(Float64(factor), 0.0, Dict(unit => exp))
BaseUnitDecomposition(factor::Real, dimensions::Dict{String, Rational{Int}}) =
    BaseUnitDecomposition(Float64(factor), 0.0, dimensions)

# Helper constructors for affine units (with offset)
BaseUnitDecomposition(factor::Real, offset::Real, unit::String, exp::Rational{Int}) =
    BaseUnitDecomposition(Float64(factor), Float64(offset), Dict(unit => exp))

# Registry mapping unit names to their base unit decomposition
# This allows us to define derived units in terms of base units
const UNIT_REGISTRY = Dict{String, BaseUnitDecomposition}(
    # SI Base Units (identity)
    "m"   => BaseUnitDecomposition(1.0, "m", 1//1),
    "kg"  => BaseUnitDecomposition(1.0, "kg", 1//1),
    "s"   => BaseUnitDecomposition(1.0, "s", 1//1),
    "A"   => BaseUnitDecomposition(1.0, "A", 1//1),
    "K"   => BaseUnitDecomposition(1.0, "K", 1//1),
    "mol" => BaseUnitDecomposition(1.0, "mol", 1//1),
    "cd"  => BaseUnitDecomposition(1.0, "cd", 1//1),

    # Length units (base: meter)
    "meter"      => BaseUnitDecomposition(1.0, "m", 1//1),
    "km"         => BaseUnitDecomposition(1000.0, "m", 1//1),
    "kilometer"  => BaseUnitDecomposition(1000.0, "m", 1//1),
    "cm"         => BaseUnitDecomposition(0.01, "m", 1//1),
    "centimeter" => BaseUnitDecomposition(0.01, "m", 1//1),
    "mm"         => BaseUnitDecomposition(0.001, "m", 1//1),
    "millimeter" => BaseUnitDecomposition(0.001, "m", 1//1),
    "ft"         => BaseUnitDecomposition(0.3048, "m", 1//1),
    "foot"       => BaseUnitDecomposition(0.3048, "m", 1//1),
    "feet"       => BaseUnitDecomposition(0.3048, "m", 1//1),
    "in"         => BaseUnitDecomposition(0.0254, "m", 1//1),
    "inch"       => BaseUnitDecomposition(0.0254, "m", 1//1),
    "yd"         => BaseUnitDecomposition(0.9144, "m", 1//1),
    "yard"       => BaseUnitDecomposition(0.9144, "m", 1//1),
    "mi"         => BaseUnitDecomposition(1609.34, "m", 1//1),
    "mile"       => BaseUnitDecomposition(1609.34, "m", 1//1),

    # Mass units (base: kilogram)
    "kilogram" => BaseUnitDecomposition(1.0, "kg", 1//1),
    "g"        => BaseUnitDecomposition(0.001, "kg", 1//1),
    "gram"     => BaseUnitDecomposition(0.001, "kg", 1//1),
    "lb"       => BaseUnitDecomposition(0.45359237, "kg", 1//1),
    "pound"    => BaseUnitDecomposition(0.45359237, "kg", 1//1),
    "oz"       => BaseUnitDecomposition(0.028349523125, "kg", 1//1),
    "ounce"    => BaseUnitDecomposition(0.028349523125, "kg", 1//1),

    # Time units (base: second)
    "second"   => BaseUnitDecomposition(1.0, "s", 1//1),
    "minute"   => BaseUnitDecomposition(60.0, "s", 1//1),
    "min"      => BaseUnitDecomposition(60.0, "s", 1//1),
    "hour"     => BaseUnitDecomposition(3600.0, "s", 1//1),
    "hr"       => BaseUnitDecomposition(3600.0, "s", 1//1),
    "day"      => BaseUnitDecomposition(86400.0, "s", 1//1),
    "week"     => BaseUnitDecomposition(604800.0, "s", 1//1),

    # Temperature units
    # Two types: absolute (with offset) and intervals/differences (no offset)

    # Absolute temperature scales (use with convert_value for actual temperatures)
    # Conversion to Kelvin: K = factor * T + offset
    "kelvin"     => BaseUnitDecomposition(1.0, 0.0, "K", 1//1),        # K is the base
    "celsius"    => BaseUnitDecomposition(1.0, 273.15, "K", 1//1),     # K = °C + 273.15
    "fahrenheit" => BaseUnitDecomposition(5.0/9.0, 255.372222, "K", 1//1),  # K = (°F + 459.67) * 5/9
    "rankine"    => BaseUnitDecomposition(5.0/9.0, 0.0, "K", 1//1),    # K = °R * 5/9

    # Temperature intervals/differences (use with convert_unit for scale factors)
    # These represent ΔT, not absolute temperature - no offset applied
    "degC"       => BaseUnitDecomposition(1.0, "K", 1//1),             # 1°C interval = 1 K
    "degF"       => BaseUnitDecomposition(5.0/9.0, "K", 1//1),         # 1°F interval = 5/9 K
    "degR"       => BaseUnitDecomposition(5.0/9.0, "K", 1//1),         # 1°R interval = 5/9 K

    # Derived SI units
    "N"      => BaseUnitDecomposition(1.0, Dict("kg" => 1//1, "m" => 1//1, "s" => -2//1)),
    "newton" => BaseUnitDecomposition(1.0, Dict("kg" => 1//1, "m" => 1//1, "s" => -2//1)),
    "J"      => BaseUnitDecomposition(1.0, Dict("kg" => 1//1, "m" => 2//1, "s" => -2//1)),
    "joule"  => BaseUnitDecomposition(1.0, Dict("kg" => 1//1, "m" => 2//1, "s" => -2//1)),
    "W"      => BaseUnitDecomposition(1.0, Dict("kg" => 1//1, "m" => 2//1, "s" => -3//1)),
    "watt"   => BaseUnitDecomposition(1.0, Dict("kg" => 1//1, "m" => 2//1, "s" => -3//1)),
    "Pa"     => BaseUnitDecomposition(1.0, Dict("kg" => 1//1, "m" => -1//1, "s" => -2//1)),
    "pascal" => BaseUnitDecomposition(1.0, Dict("kg" => 1//1, "m" => -1//1, "s" => -2//1)),
    "Hz"     => BaseUnitDecomposition(1.0, Dict("s" => -1//1)),
    "hertz"  => BaseUnitDecomposition(1.0, Dict("s" => -1//1)),
    "C"      => BaseUnitDecomposition(1.0, Dict("A" => 1//1, "s" => 1//1)),
    "coulomb"=> BaseUnitDecomposition(1.0, Dict("A" => 1//1, "s" => 1//1)),
    "V"      => BaseUnitDecomposition(1.0, Dict("kg" => 1//1, "m" => 2//1, "s" => -3//1, "A" => -1//1)),
    "volt"   => BaseUnitDecomposition(1.0, Dict("kg" => 1//1, "m" => 2//1, "s" => -3//1, "A" => -1//1)),
)

# Check if a unit is registered
is_registered_unit(unit::String) = haskey(UNIT_REGISTRY, unit)

# Get the base unit decomposition for a unit
function get_base_decomposition(unit::String)::BaseUnitDecomposition
    if !haskey(UNIT_REGISTRY, unit)
        error("Unknown unit: $unit")
    end
    return UNIT_REGISTRY[unit]
end
