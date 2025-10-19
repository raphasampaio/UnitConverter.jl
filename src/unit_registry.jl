# Unit Registry - defines all known units and their relationships to base units
# All data structures are const (no __init__ needed)

# SI Base Units (dimensionally independent) as an enum for type safety
@enumx BaseUnit m kg s A K mol cd

# SI Base Units set (for validation)
const SI_BASE_UNITS = Set([
    BaseUnit.m,      # meter (length)
    BaseUnit.kg,     # kilogram (mass)
    BaseUnit.s,      # second (time)
    BaseUnit.A,      # ampere (electric current)
    BaseUnit.K,      # kelvin (temperature)
    BaseUnit.mol,    # mole (amount of substance)
    BaseUnit.cd      # candela (luminous intensity)
])

# Struct to represent a unit in terms of base units
# Supports affine transformations: base_value = factor * unit_value + offset
struct BaseUnitDecomposition
    factor::Float64                               # multiplicative scale factor
    offset::Float64                               # additive offset (for affine units like temperature)
    dimensions::Dict{BaseUnit.T, Rational{Int}}   # base unit -> exponent
end

# Helper constructors for simple units (no offset)
BaseUnitDecomposition(factor::Real) =
    BaseUnitDecomposition(Float64(factor), 0.0, Dict{BaseUnit.T, Rational{Int}}())
BaseUnitDecomposition(factor::Real, unit::BaseUnit.T, exp::Rational{Int}) =
    BaseUnitDecomposition(Float64(factor), 0.0, Dict(unit => exp))
BaseUnitDecomposition(factor::Real, dimensions::Dict{BaseUnit.T, Rational{Int}}) =
    BaseUnitDecomposition(Float64(factor), 0.0, dimensions)

# Helper constructors for affine units (with offset)
BaseUnitDecomposition(factor::Real, offset::Real, unit::BaseUnit.T, exp::Rational{Int}) =
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
function generate_si_prefixed_units(base_unit::String, base_factor::Float64, base_dimension::BaseUnit.T)
    units = Dict{String, BaseUnitDecomposition}()
    for (prefix, scale) in SI_PREFIXES
        prefixed_name = prefix * base_unit
        units[prefixed_name] = BaseUnitDecomposition(base_factor * scale, base_dimension, 1//1)
    end
    return units
end

# Helper function to generate SI-prefixed derived units
function generate_si_prefixed_derived_units(base_unit::String, base_dimensions::Dict{BaseUnit.T, Rational{Int}})
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
    registry["m"]   = BaseUnitDecomposition(1.0, BaseUnit.m, 1//1)
    registry["kg"]  = BaseUnitDecomposition(1.0, BaseUnit.kg, 1//1)
    registry["s"]   = BaseUnitDecomposition(1.0, BaseUnit.s, 1//1)
    registry["A"]   = BaseUnitDecomposition(1.0, BaseUnit.A, 1//1)
    registry["K"]   = BaseUnitDecomposition(1.0, BaseUnit.K, 1//1)
    registry["mol"] = BaseUnitDecomposition(1.0, BaseUnit.mol, 1//1)
    registry["cd"]  = BaseUnitDecomposition(1.0, BaseUnit.cd, 1//1)

    # ========== Length Units ==========
    # Base meter and common names
    registry["meter"] = BaseUnitDecomposition(1.0, BaseUnit.m, 1//1)

    # SI prefixed meters (Tm, Gm, Mm, km, hm, dam, dm, cm, mm, μm, nm, pm)
    merge!(registry, generate_si_prefixed_units("m", 1.0, BaseUnit.m))

    # Common length names with prefixes
    registry["kilometer"]  = BaseUnitDecomposition(1000.0, BaseUnit.m, 1//1)
    registry["centimeter"] = BaseUnitDecomposition(0.01, BaseUnit.m, 1//1)
    registry["millimeter"] = BaseUnitDecomposition(0.001, BaseUnit.m, 1//1)

    # Imperial/US length units
    registry["ft"]   = BaseUnitDecomposition(0.3048, BaseUnit.m, 1//1)
    registry["foot"] = BaseUnitDecomposition(0.3048, BaseUnit.m, 1//1)
    registry["feet"] = BaseUnitDecomposition(0.3048, BaseUnit.m, 1//1)
    registry["in"]   = BaseUnitDecomposition(0.0254, BaseUnit.m, 1//1)
    registry["inch"] = BaseUnitDecomposition(0.0254, BaseUnit.m, 1//1)
    registry["yd"]   = BaseUnitDecomposition(0.9144, BaseUnit.m, 1//1)
    registry["yard"] = BaseUnitDecomposition(0.9144, BaseUnit.m, 1//1)
    registry["mi"]   = BaseUnitDecomposition(1609.34, BaseUnit.m, 1//1)
    registry["mile"] = BaseUnitDecomposition(1609.34, BaseUnit.m, 1//1)

    # ========== Mass Units ==========
    # Base kilogram
    registry["kilogram"] = BaseUnitDecomposition(1.0, BaseUnit.kg, 1//1)

    # Gram and SI prefixed grams (note: base SI unit is kg, but we define g separately)
    registry["g"]    = BaseUnitDecomposition(0.001, BaseUnit.kg, 1//1)
    registry["gram"] = BaseUnitDecomposition(0.001, BaseUnit.kg, 1//1)

    # SI prefixed grams (Tg, Gg, Mg, kg, hg, dag, dg, cg, mg, μg, ng, pg)
    merge!(registry, generate_si_prefixed_units("g", 0.001, BaseUnit.kg))

    # Imperial/US mass units
    registry["lb"]    = BaseUnitDecomposition(0.45359237, BaseUnit.kg, 1//1)
    registry["pound"] = BaseUnitDecomposition(0.45359237, BaseUnit.kg, 1//1)
    registry["oz"]    = BaseUnitDecomposition(0.028349523125, BaseUnit.kg, 1//1)
    registry["ounce"] = BaseUnitDecomposition(0.028349523125, BaseUnit.kg, 1//1)

    # ========== Time Units ==========
    # Base second and common names
    registry["second"] = BaseUnitDecomposition(1.0, BaseUnit.s, 1//1)

    # SI prefixed seconds (Ts, Gs, Ms, ks, hs, das, ds, cs, ms, μs, ns, ps)
    merge!(registry, generate_si_prefixed_units("s", 1.0, BaseUnit.s))

    # Common time units
    registry["minute"] = BaseUnitDecomposition(60.0, BaseUnit.s, 1//1)
    registry["min"]    = BaseUnitDecomposition(60.0, BaseUnit.s, 1//1)
    registry["hour"]   = BaseUnitDecomposition(3600.0, BaseUnit.s, 1//1)
    registry["hr"]     = BaseUnitDecomposition(3600.0, BaseUnit.s, 1//1)
    registry["h"]      = BaseUnitDecomposition(3600.0, BaseUnit.s, 1//1)  # hour abbreviation
    registry["day"]    = BaseUnitDecomposition(86400.0, BaseUnit.s, 1//1)
    registry["das"]    = BaseUnitDecomposition(86400.0, BaseUnit.s, 1//1)  # Override: "das" = day (not decasecond)
    registry["week"]   = BaseUnitDecomposition(604800.0, BaseUnit.s, 1//1)

    # ========== Temperature Units ==========
    # Absolute temperature scales (with offset)
    registry["kelvin"]     = BaseUnitDecomposition(1.0, 0.0, BaseUnit.K, 1//1)
    registry["celsius"]    = BaseUnitDecomposition(1.0, 273.15, BaseUnit.K, 1//1)
    registry["fahrenheit"] = BaseUnitDecomposition(5.0/9.0, 459.67*5.0/9.0, BaseUnit.K, 1//1)
    registry["rankine"]    = BaseUnitDecomposition(5.0/9.0, 0.0, BaseUnit.K, 1//1)

    # Temperature intervals/differences (no offset)
    registry["degC"] = BaseUnitDecomposition(1.0, BaseUnit.K, 1//1)           # 1°C difference = 1 K
    registry["degF"] = BaseUnitDecomposition(5.0/9.0, BaseUnit.K, 1//1)       # 1°F difference = 5/9 K
    registry["degR"] = BaseUnitDecomposition(5.0/9.0, BaseUnit.K, 1//1)       # 1°R difference = 5/9 K

    # ========== Dimensionless Units ==========
    # Percent (1% = 0.01 = 1/100)
    registry["%"] = BaseUnitDecomposition(0.01)

    # Currency (dollar - dimensionless for unit analysis)
    registry["\$"] = BaseUnitDecomposition(1.0)

    # SI-prefixed dollars (T$, G$, M$, k$, etc.)
    for (prefix, scale) in SI_PREFIXES
        prefixed_name = prefix * "\$"
        registry[prefixed_name] = BaseUnitDecomposition(scale)
    end

    # ========== Angle Units ==========
    registry["rad"]    = BaseUnitDecomposition(1.0)  # dimensionless base
    registry["radian"] = BaseUnitDecomposition(1.0)
    registry["deg"]    = BaseUnitDecomposition(π/180.0)
    registry["degree"] = BaseUnitDecomposition(π/180.0)

    # ========== Volume Units ==========
    # Liter (1 L = 0.001 m³)
    liter_dims = Dict(BaseUnit.m => 3//1)
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

    # US Gallon (1 US gal = 3.785411784 L = 0.003785411784 m³)
    registry["gal"]    = BaseUnitDecomposition(0.003785411784, liter_dims)
    registry["gallon"] = BaseUnitDecomposition(0.003785411784, liter_dims)

    # SI prefixed gallons (Tgal, Ggal, Mgal, kgal, etc.)
    for (prefix, scale) in SI_PREFIXES
        prefixed_name = prefix * "gal"
        registry[prefixed_name] = BaseUnitDecomposition(0.003785411784 * scale, liter_dims)
    end

    # ========== Derived SI Units ==========
    # Force: Newton (kg⋅m/s²)
    newton_dims = Dict(BaseUnit.kg => 1//1, BaseUnit.m => 1//1, BaseUnit.s => -2//1)
    registry["N"]      = BaseUnitDecomposition(1.0, newton_dims)
    registry["newton"] = BaseUnitDecomposition(1.0, newton_dims)

    # Force: kilogram-force (kgf = 9.80665 N, force due to 1 kg mass in Earth's gravity)
    registry["kgf"] = BaseUnitDecomposition(9.80665, newton_dims)

    # Force: pound-force (lbf = 4.4482216 N)
    registry["lbf"] = BaseUnitDecomposition(4.4482216, newton_dims)

    # Energy: Joule (kg⋅m²/s²)
    joule_dims = Dict(BaseUnit.kg => 1//1, BaseUnit.m => 2//1, BaseUnit.s => -2//1)
    registry["J"]     = BaseUnitDecomposition(1.0, joule_dims)
    registry["joule"] = BaseUnitDecomposition(1.0, joule_dims)
    merge!(registry, generate_si_prefixed_derived_units("J", joule_dims))

    # Power: Watt (kg⋅m²/s³)
    watt_dims = Dict(BaseUnit.kg => 1//1, BaseUnit.m => 2//1, BaseUnit.s => -3//1)
    registry["W"]    = BaseUnitDecomposition(1.0, watt_dims)
    registry["watt"] = BaseUnitDecomposition(1.0, watt_dims)
    merge!(registry, generate_si_prefixed_derived_units("W", watt_dims))

    # Power: horsepower (hp = 745.69987 W)
    registry["hp"] = BaseUnitDecomposition(745.69987, watt_dims)

    # Pressure: Pascal (kg/(m⋅s²))
    pascal_dims = Dict(BaseUnit.kg => 1//1, BaseUnit.m => -1//1, BaseUnit.s => -2//1)
    registry["Pa"]     = BaseUnitDecomposition(1.0, pascal_dims)
    registry["pascal"] = BaseUnitDecomposition(1.0, pascal_dims)
    merge!(registry, generate_si_prefixed_derived_units("Pa", pascal_dims))

    # Pressure: atmosphere (atm = 101325 Pa)
    registry["atm"] = BaseUnitDecomposition(101325.0, pascal_dims)

    # Pressure: bar (bar = 100000 Pa)
    registry["bar"] = BaseUnitDecomposition(100000.0, pascal_dims)

    # Pressure: pounds per square inch (psi = lbf/in² = 6894.7573 Pa)
    registry["psi"] = BaseUnitDecomposition(6894.7573, pascal_dims)

    # Frequency: Hertz (1/s)
    hertz_dims = Dict(BaseUnit.s => -1//1)
    registry["Hz"]    = BaseUnitDecomposition(1.0, hertz_dims)
    registry["hertz"] = BaseUnitDecomposition(1.0, hertz_dims)
    merge!(registry, generate_si_prefixed_derived_units("Hz", hertz_dims))

    # Angular velocity: revolutions per minute
    # Note: rpm is an angular velocity unit that's compatible with deg/s
    # Since "deg" converts to radians with factor π/180, and 1 revolution = 2π radians:
    # 1 rpm = 1 rev/min = 2π rad/60 s = π/30 rad/s
    # This makes it compatible with deg/s which has factor π/180 rad/s
    registry["rpm"] = BaseUnitDecomposition(π/30.0, hertz_dims)

    # Electric charge: Coulomb (A⋅s)
    coulomb_dims = Dict(BaseUnit.A => 1//1, BaseUnit.s => 1//1)
    registry["C"]       = BaseUnitDecomposition(1.0, coulomb_dims)
    registry["coulomb"] = BaseUnitDecomposition(1.0, coulomb_dims)

    # Electric potential: Volt (kg⋅m²/(A⋅s³))
    volt_dims = Dict(BaseUnit.kg => 1//1, BaseUnit.m => 2//1, BaseUnit.s => -3//1, BaseUnit.A => -1//1)
    registry["V"]    = BaseUnitDecomposition(1.0, volt_dims)
    registry["volt"] = BaseUnitDecomposition(1.0, volt_dims)

    # ========== Common Energy Units (Watt-hours) ==========
    # Watt-hour: Wh (same dimensions as Joule: kg⋅m²/s²)
    # 1 Wh = 1 W * 1 h = 1 W * 3600 s = 3600 J
    wh_dims = Dict(BaseUnit.kg => 1//1, BaseUnit.m => 2//1, BaseUnit.s => -2//1)
    registry["Wh"] = BaseUnitDecomposition(3600.0, wh_dims)

    # SI prefixed Watt-hours (TWh, GWh, MWh, kWh, etc.)
    # Note: scale is applied to the power, not the energy
    # e.g., 1 kWh = 1000 W * 3600 s = 3,600,000 J
    for (prefix, scale) in SI_PREFIXES
        prefixed_name = prefix * "Wh"
        registry[prefixed_name] = BaseUnitDecomposition(3600.0 * scale, wh_dims)
    end

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
