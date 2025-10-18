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

# SI Prefixes with their scale factors
const SI_PREFIXES = Dict{String, Float64}(
    "T"  => 1e12,   # tera
    "G"  => 1e9,    # giga
    "M"  => 1e6,    # mega
    "k"  => 1e3,    # kilo
    "h"  => 1e2,    # hecto
    "da" => 1e1,    # deca
    "d"  => 1e-1,   # deci
    "c"  => 1e-2,   # centi
    "m"  => 1e-3,   # milli
    "μ"  => 1e-6,   # micro
    "n"  => 1e-9,   # nano
    "p"  => 1e-12,  # pico
)

# Helper function to generate SI-prefixed units
function generate_si_prefixed_units(base_unit::String, base_factor::Float64, base_dimension::String)
    units = Dict{String, BaseUnitDecomposition}()
    for (prefix, scale) in SI_PREFIXES
        prefixed_name = prefix * base_unit
        units[prefixed_name] = BaseUnitDecomposition(base_factor * scale, base_dimension, 1//1)
    end
    return units
end

# Helper function to generate SI-prefixed derived units
function generate_si_prefixed_derived_units(base_unit::String, base_dimensions::Dict{String, Rational{Int}})
    units = Dict{String, BaseUnitDecomposition}()
    for (prefix, scale) in SI_PREFIXES
        prefixed_name = prefix * base_unit
        units[prefixed_name] = BaseUnitDecomposition(scale, base_dimensions)
    end
    return units
end

# Build the unit registry programmatically
function build_unit_registry()
    registry = Dict{String, BaseUnitDecomposition}()

    # ========== SI Base Units ==========
    registry["m"]   = BaseUnitDecomposition(1.0, "m", 1//1)
    registry["kg"]  = BaseUnitDecomposition(1.0, "kg", 1//1)
    registry["s"]   = BaseUnitDecomposition(1.0, "s", 1//1)
    registry["A"]   = BaseUnitDecomposition(1.0, "A", 1//1)
    registry["K"]   = BaseUnitDecomposition(1.0, "K", 1//1)
    registry["mol"] = BaseUnitDecomposition(1.0, "mol", 1//1)
    registry["cd"]  = BaseUnitDecomposition(1.0, "cd", 1//1)

    # ========== Length Units ==========
    # Base meter and common names
    registry["meter"] = BaseUnitDecomposition(1.0, "m", 1//1)

    # SI prefixed meters (Tm, Gm, Mm, km, hm, dam, dm, cm, mm, μm, nm, pm)
    merge!(registry, generate_si_prefixed_units("m", 1.0, "m"))

    # Common length names with prefixes
    registry["kilometer"]  = BaseUnitDecomposition(1000.0, "m", 1//1)
    registry["centimeter"] = BaseUnitDecomposition(0.01, "m", 1//1)
    registry["millimeter"] = BaseUnitDecomposition(0.001, "m", 1//1)

    # Imperial/US length units
    registry["ft"]   = BaseUnitDecomposition(0.3048, "m", 1//1)
    registry["foot"] = BaseUnitDecomposition(0.3048, "m", 1//1)
    registry["feet"] = BaseUnitDecomposition(0.3048, "m", 1//1)
    registry["in"]   = BaseUnitDecomposition(0.0254, "m", 1//1)
    registry["inch"] = BaseUnitDecomposition(0.0254, "m", 1//1)
    registry["yd"]   = BaseUnitDecomposition(0.9144, "m", 1//1)
    registry["yard"] = BaseUnitDecomposition(0.9144, "m", 1//1)
    registry["mi"]   = BaseUnitDecomposition(1609.34, "m", 1//1)
    registry["mile"] = BaseUnitDecomposition(1609.34, "m", 1//1)

    # ========== Mass Units ==========
    # Base kilogram
    registry["kilogram"] = BaseUnitDecomposition(1.0, "kg", 1//1)

    # Gram and SI prefixed grams (note: base SI unit is kg, but we define g separately)
    registry["g"]    = BaseUnitDecomposition(0.001, "kg", 1//1)
    registry["gram"] = BaseUnitDecomposition(0.001, "kg", 1//1)

    # SI prefixed grams (Tg, Gg, Mg, kg, hg, dag, dg, cg, mg, μg, ng, pg)
    merge!(registry, generate_si_prefixed_units("g", 0.001, "kg"))

    # Imperial/US mass units
    registry["lb"]    = BaseUnitDecomposition(0.45359237, "kg", 1//1)
    registry["pound"] = BaseUnitDecomposition(0.45359237, "kg", 1//1)
    registry["oz"]    = BaseUnitDecomposition(0.028349523125, "kg", 1//1)
    registry["ounce"] = BaseUnitDecomposition(0.028349523125, "kg", 1//1)

    # ========== Time Units ==========
    # Base second and common names
    registry["second"] = BaseUnitDecomposition(1.0, "s", 1//1)

    # SI prefixed seconds (Ts, Gs, Ms, ks, hs, das, ds, cs, ms, μs, ns, ps)
    merge!(registry, generate_si_prefixed_units("s", 1.0, "s"))

    # Common time units
    registry["minute"] = BaseUnitDecomposition(60.0, "s", 1//1)
    registry["min"]    = BaseUnitDecomposition(60.0, "s", 1//1)
    registry["hour"]   = BaseUnitDecomposition(3600.0, "s", 1//1)
    registry["hr"]     = BaseUnitDecomposition(3600.0, "s", 1//1)
    registry["h"]      = BaseUnitDecomposition(3600.0, "s", 1//1)  # hour abbreviation
    registry["day"]    = BaseUnitDecomposition(86400.0, "s", 1//1)
    registry["das"]    = BaseUnitDecomposition(86400.0, "s", 1//1)  # Override: "das" = day (not decasecond)
    registry["week"]   = BaseUnitDecomposition(604800.0, "s", 1//1)

    # ========== Temperature Units ==========
    # Absolute temperature scales (with offset)
    registry["kelvin"]     = BaseUnitDecomposition(1.0, 0.0, "K", 1//1)
    registry["celsius"]    = BaseUnitDecomposition(1.0, 273.15, "K", 1//1)
    registry["fahrenheit"] = BaseUnitDecomposition(5.0/9.0, 459.67*5.0/9.0, "K", 1//1)
    registry["rankine"]    = BaseUnitDecomposition(5.0/9.0, 0.0, "K", 1//1)

    # Temperature intervals/differences (no offset)
    registry["degC"] = BaseUnitDecomposition(1.0, "K", 1//1)           # 1°C difference = 1 K
    registry["degF"] = BaseUnitDecomposition(5.0/9.0, "K", 1//1)       # 1°F difference = 5/9 K
    registry["degR"] = BaseUnitDecomposition(5.0/9.0, "K", 1//1)       # 1°R difference = 5/9 K

    # ========== Angle Units ==========
    registry["rad"]    = BaseUnitDecomposition(1.0)  # dimensionless base
    registry["radian"] = BaseUnitDecomposition(1.0)
    registry["deg"]    = BaseUnitDecomposition(π/180.0)
    registry["degree"] = BaseUnitDecomposition(π/180.0)

    # ========== Volume Units ==========
    # Liter (1 L = 0.001 m³)
    liter_dims = Dict("m" => 3//1)
    registry["L"]     = BaseUnitDecomposition(0.001, liter_dims)
    registry["l"]     = BaseUnitDecomposition(0.001, liter_dims)
    registry["liter"] = BaseUnitDecomposition(0.001, liter_dims)

    # SI prefixed liters (TL, GL, ML, kL, hL, daL, dL, cL, mL, μL, nL, pL)
    for (prefix, scale) in SI_PREFIXES
        prefixed_name = prefix * "L"
        registry[prefixed_name] = BaseUnitDecomposition(0.001 * scale, liter_dims)

        # Also add lowercase 'l' variants for common ones
        if prefix in ["m", "c", "d"]  # mL, cL, dL
            prefixed_name_lower = prefix * "l"
            registry[prefixed_name_lower] = BaseUnitDecomposition(0.001 * scale, liter_dims)
        end
    end

    # ========== Derived SI Units ==========
    # Force: Newton (kg⋅m/s²)
    newton_dims = Dict("kg" => 1//1, "m" => 1//1, "s" => -2//1)
    registry["N"]      = BaseUnitDecomposition(1.0, newton_dims)
    registry["newton"] = BaseUnitDecomposition(1.0, newton_dims)

    # Energy: Joule (kg⋅m²/s²)
    joule_dims = Dict("kg" => 1//1, "m" => 2//1, "s" => -2//1)
    registry["J"]     = BaseUnitDecomposition(1.0, joule_dims)
    registry["joule"] = BaseUnitDecomposition(1.0, joule_dims)
    merge!(registry, generate_si_prefixed_derived_units("J", joule_dims))

    # Power: Watt (kg⋅m²/s³)
    watt_dims = Dict("kg" => 1//1, "m" => 2//1, "s" => -3//1)
    registry["W"]    = BaseUnitDecomposition(1.0, watt_dims)
    registry["watt"] = BaseUnitDecomposition(1.0, watt_dims)
    merge!(registry, generate_si_prefixed_derived_units("W", watt_dims))

    # Pressure: Pascal (kg/(m⋅s²))
    pascal_dims = Dict("kg" => 1//1, "m" => -1//1, "s" => -2//1)
    registry["Pa"]     = BaseUnitDecomposition(1.0, pascal_dims)
    registry["pascal"] = BaseUnitDecomposition(1.0, pascal_dims)
    merge!(registry, generate_si_prefixed_derived_units("Pa", pascal_dims))

    # Frequency: Hertz (1/s)
    hertz_dims = Dict("s" => -1//1)
    registry["Hz"]    = BaseUnitDecomposition(1.0, hertz_dims)
    registry["hertz"] = BaseUnitDecomposition(1.0, hertz_dims)
    merge!(registry, generate_si_prefixed_derived_units("Hz", hertz_dims))

    # Electric charge: Coulomb (A⋅s)
    coulomb_dims = Dict("A" => 1//1, "s" => 1//1)
    registry["C"]       = BaseUnitDecomposition(1.0, coulomb_dims)
    registry["coulomb"] = BaseUnitDecomposition(1.0, coulomb_dims)

    # Electric potential: Volt (kg⋅m²/(A⋅s³))
    volt_dims = Dict("kg" => 1//1, "m" => 2//1, "s" => -3//1, "A" => -1//1)
    registry["V"]    = BaseUnitDecomposition(1.0, volt_dims)
    registry["volt"] = BaseUnitDecomposition(1.0, volt_dims)

    return registry
end

# Build the registry at compile time
const UNIT_REGISTRY = build_unit_registry()

# Check if a unit is registered
is_registered_unit(unit::String) = haskey(UNIT_REGISTRY, unit)

# Get the base unit decomposition for a unit
function get_base_decomposition(unit::String)::BaseUnitDecomposition
    if !haskey(UNIT_REGISTRY, unit)
        error("Unknown unit: $unit")
    end
    return UNIT_REGISTRY[unit]
end
