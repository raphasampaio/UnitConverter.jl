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
    BaseUnit.cd,      # candela (luminous intensity)
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
    "T" => 1e12,   # tera
    "G" => 1e9,    # giga
    "M" => 1e6,    # mega
    "k" => 1e3,    # kilo
    "h" => 1e2,    # hecto
    "da" => 1e1,    # deca
    "d" => 1e-1,   # deci
    "c" => 1e-2,   # centi
    "m" => 1e-3,   # milli
    "μ" => 1e-6,   # micro
    "n" => 1e-9,   # nano
    "p" => 1e-12,  # pico
)

# Helper function to generate SI-prefixed units
function generate_si_prefixed_units(base_unit::AbstractString, base_factor::Float64, base_dimension::BaseUnit.T)
    units = Dict{String, BaseUnitDecomposition}()
    for (prefix, scale) in SI_PREFIXES
        prefixed_name = prefix * base_unit
        units[prefixed_name] = BaseUnitDecomposition(base_factor * scale, base_dimension, 1 // 1)
    end
    return units
end

# Helper function to generate SI-prefixed derived units
function generate_si_prefixed_derived_units(base_unit::AbstractString, base_dimensions::Dict{BaseUnit.T, Rational{Int}})
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
    registry["m"] = BaseUnitDecomposition(1.0, BaseUnit.m, 1 // 1)
    registry["kg"] = BaseUnitDecomposition(1.0, BaseUnit.kg, 1 // 1)
    registry["s"] = BaseUnitDecomposition(1.0, BaseUnit.s, 1 // 1)
    registry["A"] = BaseUnitDecomposition(1.0, BaseUnit.A, 1 // 1)
    registry["ampere"] = BaseUnitDecomposition(1.0, BaseUnit.A, 1 // 1)
    merge!(registry, generate_si_prefixed_units("A", 1.0, BaseUnit.A))
    registry["K"] = BaseUnitDecomposition(1.0, BaseUnit.K, 1 // 1)
    registry["mol"] = BaseUnitDecomposition(1.0, BaseUnit.mol, 1 // 1)
    merge!(registry, generate_si_prefixed_units("mol", 1.0, BaseUnit.mol))
    registry["cd"] = BaseUnitDecomposition(1.0, BaseUnit.cd, 1 // 1)
    registry["candela"] = BaseUnitDecomposition(1.0, BaseUnit.cd, 1 // 1)

    # ========== Solid Angle ==========
    # Steradian (dimensionless in SI)
    registry["steradian"] = BaseUnitDecomposition(1.0)
    registry["sr"] = BaseUnitDecomposition(1.0)

    # ========== Luminous Units ==========
    # Lumen (luminous flux: cd⋅sr)
    lumen_dims = Dict(BaseUnit.cd => 1 // 1)
    registry["lumen"] = BaseUnitDecomposition(1.0, lumen_dims)
    registry["lm"] = BaseUnitDecomposition(1.0, lumen_dims)

    # Lux (illuminance: lm/m²)
    lux_dims = Dict(BaseUnit.cd => 1 // 1, BaseUnit.m => -2 // 1)
    registry["lux"] = BaseUnitDecomposition(1.0, lux_dims)
    registry["lx"] = BaseUnitDecomposition(1.0, lux_dims)

    # Footcandle (illuminance: lm/ft²)
    registry["footcandle"] = BaseUnitDecomposition(10.76391, lux_dims)  # 1 lm/ft² = 10.76391 lux

    # Phot (illuminance: lm/cm² = 10000 lux)
    registry["phot"] = BaseUnitDecomposition(10000.0, lux_dims)

    # Nit (luminance: cd/m²)
    nit_dims = Dict(BaseUnit.cd => 1 // 1, BaseUnit.m => -2 // 1)
    registry["nit"] = BaseUnitDecomposition(1.0, nit_dims)

    # ========== Length Units ==========
    # Base meter and common names
    registry["meter"] = BaseUnitDecomposition(1.0, BaseUnit.m, 1 // 1)

    # SI prefixed meters (Tm, Gm, Mm, km, hm, dam, dm, cm, mm, μm, nm, pm)
    merge!(registry, generate_si_prefixed_units("m", 1.0, BaseUnit.m))

    # Common length names with prefixes
    registry["kilometer"] = BaseUnitDecomposition(1000.0, BaseUnit.m, 1 // 1)
    registry["centimeter"] = BaseUnitDecomposition(0.01, BaseUnit.m, 1 // 1)
    registry["millimeter"] = BaseUnitDecomposition(0.001, BaseUnit.m, 1 // 1)

    # Imperial/US length units
    registry["ft"] = BaseUnitDecomposition(0.3048, BaseUnit.m, 1 // 1)
    registry["foot"] = BaseUnitDecomposition(0.3048, BaseUnit.m, 1 // 1)
    registry["feet"] = BaseUnitDecomposition(0.3048, BaseUnit.m, 1 // 1)
    registry["in"] = BaseUnitDecomposition(0.0254, BaseUnit.m, 1 // 1)
    registry["inch"] = BaseUnitDecomposition(0.0254, BaseUnit.m, 1 // 1)
    registry["yd"] = BaseUnitDecomposition(0.9144, BaseUnit.m, 1 // 1)
    registry["yard"] = BaseUnitDecomposition(0.9144, BaseUnit.m, 1 // 1)
    registry["mi"] = BaseUnitDecomposition(1609.34, BaseUnit.m, 1 // 1)
    registry["mile"] = BaseUnitDecomposition(1609.34, BaseUnit.m, 1 // 1)

    # Nautical and other length units
    registry["nauticalmile"] = BaseUnitDecomposition(1852.0, BaseUnit.m, 1 // 1)  # exactly 1852 m
    registry["nmi"] = BaseUnitDecomposition(1852.0, BaseUnit.m, 1 // 1)
    registry["fathom"] = BaseUnitDecomposition(1.8288, BaseUnit.m, 1 // 1)  # 6 feet
    registry["furlong"] = BaseUnitDecomposition(201.168, BaseUnit.m, 1 // 1)  # 1/8 mile
    registry["chain"] = BaseUnitDecomposition(20.1168, BaseUnit.m, 1 // 1)  # 66 feet
    registry["cable"] = BaseUnitDecomposition(219.456, BaseUnit.m, 1 // 1)  # cable length
    registry["league"] = BaseUnitDecomposition(4828.032, BaseUnit.m, 1 // 1)  # nautical league
    registry["angstrom"] = BaseUnitDecomposition(1.0e-10, BaseUnit.m, 1 // 1)  # 0.1 nm
    registry["micron"] = BaseUnitDecomposition(1.0e-6, BaseUnit.m, 1 // 1)  # micrometer

    # Astronomical length units
    registry["lightyear"] = BaseUnitDecomposition(9.4607305e15, BaseUnit.m, 1 // 1)
    registry["parsec"] = BaseUnitDecomposition(3.0856776e16, BaseUnit.m, 1 // 1)  # 3.2615638 lightyears

    # Typography units
    registry["point"] = BaseUnitDecomposition(0.0254 / 72.0, BaseUnit.m, 1 // 1)  # 1/72 inch = ~0.3528 mm
    registry["pica"] = BaseUnitDecomposition(0.0254 / 72.0 * 11.955168, BaseUnit.m, 1 // 1)  # traditional pica = 11.955168 points

    # ========== Mass Units ==========
    # Base kilogram
    registry["kilogram"] = BaseUnitDecomposition(1.0, BaseUnit.kg, 1 // 1)

    # Gram and SI prefixed grams (note: base SI unit is kg, but we define g separately)
    registry["g"] = BaseUnitDecomposition(0.001, BaseUnit.kg, 1 // 1)
    registry["gram"] = BaseUnitDecomposition(0.001, BaseUnit.kg, 1 // 1)

    # SI prefixed grams (Tg, Gg, Mg, kg, hg, dag, dg, cg, mg, μg, ng, pg)
    merge!(registry, generate_si_prefixed_units("g", 0.001, BaseUnit.kg))

    # Imperial/US mass units
    registry["lb"] = BaseUnitDecomposition(0.45359237, BaseUnit.kg, 1 // 1)
    registry["pound"] = BaseUnitDecomposition(0.45359237, BaseUnit.kg, 1 // 1)
    registry["oz"] = BaseUnitDecomposition(0.028349523125, BaseUnit.kg, 1 // 1)
    registry["ounce"] = BaseUnitDecomposition(0.028349523125, BaseUnit.kg, 1 // 1)
    registry["ton"] = BaseUnitDecomposition(907.18474, BaseUnit.kg, 1 // 1)  # US short ton (2000 lb)
    registry["shortton"] = BaseUnitDecomposition(907.18474, BaseUnit.kg, 1 // 1)  # same as ton
    registry["longton"] = BaseUnitDecomposition(1016.0469, BaseUnit.kg, 1 // 1)  # Imperial ton (2240 lb)
    registry["tonne"] = BaseUnitDecomposition(1000.0, BaseUnit.kg, 1 // 1)  # metric ton

    # Other mass units
    registry["carat"] = BaseUnitDecomposition(0.0002, BaseUnit.kg, 1 // 1)  # 0.2 g
    registry["grain"] = BaseUnitDecomposition(0.00006479891, BaseUnit.kg, 1 // 1)  # 64.79891 mg
    registry["slug"] = BaseUnitDecomposition(14.593903, BaseUnit.kg, 1 // 1)  # slug (imperial)

    # ========== Time Units ==========
    # Base second and common names
    registry["second"] = BaseUnitDecomposition(1.0, BaseUnit.s, 1 // 1)

    # SI prefixed seconds (Ts, Gs, Ms, ks, hs, das, ds, cs, ms, μs, ns, ps)
    merge!(registry, generate_si_prefixed_units("s", 1.0, BaseUnit.s))

    # Common time units
    registry["minute"] = BaseUnitDecomposition(60.0, BaseUnit.s, 1 // 1)
    registry["min"] = BaseUnitDecomposition(60.0, BaseUnit.s, 1 // 1)
    registry["hour"] = BaseUnitDecomposition(3600.0, BaseUnit.s, 1 // 1)
    registry["hr"] = BaseUnitDecomposition(3600.0, BaseUnit.s, 1 // 1)
    registry["h"] = BaseUnitDecomposition(3600.0, BaseUnit.s, 1 // 1)  # hour abbreviation
    registry["day"] = BaseUnitDecomposition(86400.0, BaseUnit.s, 1 // 1)
    registry["das"] = BaseUnitDecomposition(86400.0, BaseUnit.s, 1 // 1)  # Override: "das" = day (not decasecond)
    registry["week"] = BaseUnitDecomposition(604800.0, BaseUnit.s, 1 // 1)
    registry["fortnight"] = BaseUnitDecomposition(1209600.0, BaseUnit.s, 1 // 1)  # 14 days
    registry["year"] = BaseUnitDecomposition(86400.0 * 365.2422, BaseUnit.s, 1 // 1)  # mean tropical year
    registry["decade"] = BaseUnitDecomposition(86400.0 * 365.2422 * 10.0, BaseUnit.s, 1 // 1)  # 10 years
    registry["century"] = BaseUnitDecomposition(86400.0 * 365.2422 * 100.0, BaseUnit.s, 1 // 1)  # 100 years

    # Very short time units
    registry["microsecond"] = BaseUnitDecomposition(1.0e-6, BaseUnit.s, 1 // 1)
    registry["shake"] = BaseUnitDecomposition(1.0e-8, BaseUnit.s, 1 // 1)  # 10 nanoseconds
    registry["svedberg"] = BaseUnitDecomposition(1.0e-13, BaseUnit.s, 1 // 1)  # 100 femtoseconds

    # ========== Temperature Units ==========
    # Absolute temperature scales (with offset)
    registry["kelvin"] = BaseUnitDecomposition(1.0, 0.0, BaseUnit.K, 1 // 1)
    registry["celsius"] = BaseUnitDecomposition(1.0, 273.15, BaseUnit.K, 1 // 1)
    registry["fahrenheit"] = BaseUnitDecomposition(5.0 / 9.0, 459.67 * 5.0 / 9.0, BaseUnit.K, 1 // 1)
    registry["rankine"] = BaseUnitDecomposition(5.0 / 9.0, 0.0, BaseUnit.K, 1 // 1)

    # Temperature intervals/differences (no offset)
    registry["degC"] = BaseUnitDecomposition(1.0, BaseUnit.K, 1 // 1)           # 1°C difference = 1 K
    registry["degF"] = BaseUnitDecomposition(5.0 / 9.0, BaseUnit.K, 1 // 1)       # 1°F difference = 5/9 K
    registry["degR"] = BaseUnitDecomposition(5.0 / 9.0, BaseUnit.K, 1 // 1)       # 1°R difference = 5/9 K

    # ========== Dimensionless Units ==========
    # Percent (1% = 0.01 = 1/100)
    registry["%"] = BaseUnitDecomposition(0.01)
    registry["percent"] = BaseUnitDecomposition(0.01)

    # Parts per million (ppm = 10^-6)
    registry["ppm"] = BaseUnitDecomposition(1.0e-6)

    # Parts per billion (ppb = 10^-9)
    registry["ppb"] = BaseUnitDecomposition(1.0e-9)

    # Currency (dollar - dimensionless for unit analysis)
    registry["\$"] = BaseUnitDecomposition(1.0)

    # SI-prefixed dollars (T$, G$, M$, k$, etc.)
    for (prefix, scale) in SI_PREFIXES
        prefixed_name = prefix * "\$"
        registry[prefixed_name] = BaseUnitDecomposition(scale)
    end

    # Digital information units (dimensionless)
    registry["bit"] = BaseUnitDecomposition(1.0)
    registry["byte"] = BaseUnitDecomposition(8.0)  # 1 byte = 8 bits
    registry["B"] = BaseUnitDecomposition(8.0)     # Short form for byte

    # SI-prefixed bytes (TB, GB, MB, kB, etc.) - using decimal (SI) prefixes, not binary
    for (prefix, scale) in SI_PREFIXES
        prefixed_name = prefix * "B"
        registry[prefixed_name] = BaseUnitDecomposition(8.0 * scale)
    end

    # Word forms for byte units
    registry["kilobyte"] = BaseUnitDecomposition(8.0 * 1e3)
    registry["megabyte"] = BaseUnitDecomposition(8.0 * 1e6)
    registry["gigabyte"] = BaseUnitDecomposition(8.0 * 1e9)
    registry["terabyte"] = BaseUnitDecomposition(8.0 * 1e12)

    # Binary prefixes (IEC 60027-2)
    registry["kibibyte"] = BaseUnitDecomposition(8.0 * 1024.0)  # 1 KiB = 1024 bytes
    registry["mebibyte"] = BaseUnitDecomposition(8.0 * 1048576.0)  # 1 MiB = 1024^2 bytes

    # Information entropy units (dimensionless)
    registry["nat"] = BaseUnitDecomposition(1.4426950408889634)  # 1 nat = ln(2) bits ≈ 1.4427 bits
    registry["hartley"] = BaseUnitDecomposition(3.32192809488736)  # 1 hartley = log₂(10) bits ≈ 3.322 bits

    # Data rate units (bits per second) - dimensionless per second (1/s)
    data_rate_dims = Dict(BaseUnit.s => -1 // 1)
    registry["bps"] = BaseUnitDecomposition(1.0, data_rate_dims)  # bits per second
    registry["kbps"] = BaseUnitDecomposition(1e3, data_rate_dims)  # kilobits per second
    registry["Mbps"] = BaseUnitDecomposition(1e6, data_rate_dims)  # megabits per second
    registry["Gbps"] = BaseUnitDecomposition(1e9, data_rate_dims)  # gigabits per second

    # Wavenumber unit (1/length)
    wavenumber_dims = Dict(BaseUnit.m => -1 // 1)
    registry["kayser"] = BaseUnitDecomposition(100.0, wavenumber_dims)  # 1 kayser = 1/cm = 100/m

    # ========== Angle Units ==========
    registry["rad"] = BaseUnitDecomposition(1.0)  # dimensionless base
    registry["radian"] = BaseUnitDecomposition(1.0)
    registry["deg"] = BaseUnitDecomposition(π / 180.0)
    registry["degree"] = BaseUnitDecomposition(π / 180.0)
    registry["arcminute"] = BaseUnitDecomposition(π / 180.0 / 60.0)  # 1/60 degree
    registry["arcsecond"] = BaseUnitDecomposition(π / 180.0 / 3600.0)  # 1/3600 degree
    registry["revolution"] = BaseUnitDecomposition(2.0 * π)  # 1 revolution = 2π radians
    registry["revolutions"] = BaseUnitDecomposition(2.0 * π)  # plural form

    # ========== Volume Units ==========
    # Liter (1 L = 0.001 m³)
    liter_dims = Dict(BaseUnit.m => 3 // 1)
    registry["L"] = BaseUnitDecomposition(0.001, liter_dims)
    registry["l"] = BaseUnitDecomposition(0.001, liter_dims)
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
    registry["gal"] = BaseUnitDecomposition(0.003785411784, liter_dims)
    registry["gallon"] = BaseUnitDecomposition(0.003785411784, liter_dims)

    # SI prefixed gallons (Tgal, Ggal, Mgal, kgal, etc.)
    for (prefix, scale) in SI_PREFIXES
        prefixed_name = prefix * "gal"
        registry[prefixed_name] = BaseUnitDecomposition(0.003785411784 * scale, liter_dims)
    end

    # Barrel (oil barrel, 1 barrel = 42 US gallons)
    registry["barrel"] = BaseUnitDecomposition(0.003785411784 * 42.0, liter_dims)

    # Fluid ounce (US, 1 fl oz = 1/128 gallon)
    registry["floz"] = BaseUnitDecomposition(0.003785411784 / 128.0, liter_dims)
    registry["fluidounce"] = BaseUnitDecomposition(0.003785411784 / 128.0, liter_dims)

    # US cooking measurements
    registry["cup"] = BaseUnitDecomposition(0.0002365882365, liter_dims)  # 236.588 mL
    registry["tablespoon"] = BaseUnitDecomposition(0.000014786764781, liter_dims)  # ~14.787 mL
    registry["teaspoon"] = BaseUnitDecomposition(0.000004928921594, liter_dims)  # ~4.929 mL
    registry["pint"] = BaseUnitDecomposition(0.000473176473, liter_dims)  # 473.176 mL (US liquid pint)
    registry["quart"] = BaseUnitDecomposition(0.000946352946, liter_dims)  # 946.353 mL (US liquid quart)

    # Bushel (US dry bushel = 35.23907 L)
    registry["bushel"] = BaseUnitDecomposition(0.03523907, liter_dims)

    # Other volume units
    registry["peck"] = BaseUnitDecomposition(0.0088097675, liter_dims)  # 1 peck = 1/4 bushel
    registry["gill"] = BaseUnitDecomposition(0.00011829412, liter_dims)  # 1 gill = 1/4 cup (US)
    registry["hogshead"] = BaseUnitDecomposition(0.003785411784 * 63.0, liter_dims)  # 63 US gallons
    registry["cord"] = BaseUnitDecomposition(3.6245564, liter_dims)  # 128 ft³
    registry["boardfoot"] = BaseUnitDecomposition(0.0023597372, liter_dims)  # 1 board foot

    # ========== Area Units ==========
    # Hectare (1 hectare = 10,000 m²)
    area_dims = Dict(BaseUnit.m => 2 // 1)
    registry["hectare"] = BaseUnitDecomposition(10000.0, area_dims)

    # Are (1 are = 100 m²)
    registry["are"] = BaseUnitDecomposition(100.0, area_dims)

    # Acre (1 acre = 4046.8564224 m²)
    registry["acre"] = BaseUnitDecomposition(4046.8564224, area_dims)

    # Barn (nuclear cross-section, 1 barn = 10^-28 m²)
    registry["barn"] = BaseUnitDecomposition(1.0e-28, area_dims)

    # ========== Derived SI Units ==========
    # Force: Newton (kg⋅m/s²)
    newton_dims = Dict(BaseUnit.kg => 1 // 1, BaseUnit.m => 1 // 1, BaseUnit.s => -2 // 1)
    registry["N"] = BaseUnitDecomposition(1.0, newton_dims)
    registry["newton"] = BaseUnitDecomposition(1.0, newton_dims)
    merge!(registry, generate_si_prefixed_derived_units("N", newton_dims))

    # Force: kilogram-force (kgf = 9.80665 N, force due to 1 kg mass in Earth's gravity)
    registry["kgf"] = BaseUnitDecomposition(9.80665, newton_dims)

    # Force: pound-force (lbf = 4.4482216 N)
    registry["lbf"] = BaseUnitDecomposition(4.4482216, newton_dims)

    # Force: dyne (CGS unit, 1 dyne = 10^-5 N)
    registry["dyne"] = BaseUnitDecomposition(1.0e-5, newton_dims)

    # Energy: Joule (kg⋅m²/s²)
    joule_dims = Dict(BaseUnit.kg => 1 // 1, BaseUnit.m => 2 // 1, BaseUnit.s => -2 // 1)
    registry["J"] = BaseUnitDecomposition(1.0, joule_dims)
    registry["joule"] = BaseUnitDecomposition(1.0, joule_dims)
    merge!(registry, generate_si_prefixed_derived_units("J", joule_dims))

    # Energy: British thermal unit (btu = 1055.05585262 J, ISO standard)
    registry["btu"] = BaseUnitDecomposition(1055.05585262, joule_dims)

    # Energy: calorie (thermochemical calorie, 1 cal = 4.184 J)
    registry["cal"] = BaseUnitDecomposition(4.184, joule_dims)
    registry["kcal"] = BaseUnitDecomposition(4184.0, joule_dims)

    # Energy: electronvolt (eV, 1 eV = 1.602176634×10^-19 J)
    registry["eV"] = BaseUnitDecomposition(1.602176634e-19, joule_dims)

    # Energy: therm (1 therm = 99976.129 BTU, approximately 100,000 BTU thermal)
    registry["therm"] = BaseUnitDecomposition(1055.05585262 * 99976.129, joule_dims)

    # Power: Watt (kg⋅m²/s³)
    watt_dims = Dict(BaseUnit.kg => 1 // 1, BaseUnit.m => 2 // 1, BaseUnit.s => -3 // 1)
    registry["W"] = BaseUnitDecomposition(1.0, watt_dims)
    registry["watt"] = BaseUnitDecomposition(1.0, watt_dims)
    merge!(registry, generate_si_prefixed_derived_units("W", watt_dims))

    # Power: horsepower (hp = 745.69987 W)
    registry["hp"] = BaseUnitDecomposition(745.69987, watt_dims)
    registry["horsepower"] = BaseUnitDecomposition(745.69987, watt_dims)

    # Pressure: Pascal (kg/(m⋅s²))
    pascal_dims = Dict(BaseUnit.kg => 1 // 1, BaseUnit.m => -1 // 1, BaseUnit.s => -2 // 1)
    registry["Pa"] = BaseUnitDecomposition(1.0, pascal_dims)
    registry["pascal"] = BaseUnitDecomposition(1.0, pascal_dims)
    merge!(registry, generate_si_prefixed_derived_units("Pa", pascal_dims))

    # Pressure: atmosphere (atm = 101325 Pa)
    registry["atm"] = BaseUnitDecomposition(101325.0, pascal_dims)

    # Pressure: bar (bar = 100000 Pa)
    registry["bar"] = BaseUnitDecomposition(100000.0, pascal_dims)
    registry["millibar"] = BaseUnitDecomposition(100.0, pascal_dims)  # 1 millibar = 100 Pa
    registry["microbar"] = BaseUnitDecomposition(0.1, pascal_dims)  # 1 microbar = 0.1 Pa

    # Technical atmosphere (at = 1 kgf/cm² = 98066.5 Pa)
    registry["at"] = BaseUnitDecomposition(98066.5, pascal_dims)

    # Pressure: pounds per square inch (psi = lbf/in² = 6894.7573 Pa)
    registry["psi"] = BaseUnitDecomposition(6894.7573, pascal_dims)
    registry["ksi"] = BaseUnitDecomposition(6894757.3, pascal_dims)  # kilopound per square inch

    # Pressure: millimeters of mercury (mmHg = 133.322387415 Pa)
    registry["mmHg"] = BaseUnitDecomposition(133.322387415, pascal_dims)

    # Pressure: torr (1 torr ≈ 133.32237 Pa, essentially same as mmHg)
    registry["torr"] = BaseUnitDecomposition(133.32237, pascal_dims)

    # Pressure: inches of mercury (inHg = 3386.3886 Pa)
    registry["inHg"] = BaseUnitDecomposition(3386.3886, pascal_dims)

    # Dynamic viscosity: Poise (kg/(m⋅s), 1 poise = 0.1 Pa⋅s)
    poise_dims = Dict(BaseUnit.kg => 1 // 1, BaseUnit.m => -1 // 1, BaseUnit.s => -1 // 1)
    registry["poise"] = BaseUnitDecomposition(0.1, poise_dims)
    merge!(registry, generate_si_prefixed_derived_units("poise", poise_dims))

    # Also add explicit centipoise for clarity
    registry["centipoise"] = BaseUnitDecomposition(0.1 * 0.01, poise_dims)

    # Kinematic viscosity: Stokes (cm²/s, 1 stokes = 10^-4 m²/s)
    stokes_dims = Dict(BaseUnit.m => 2 // 1, BaseUnit.s => -1 // 1)
    registry["stokes"] = BaseUnitDecomposition(1.0e-4, stokes_dims)
    registry["centistokes"] = BaseUnitDecomposition(1.0e-6, stokes_dims)  # 1 centistokes = 0.01 stokes

    # Frequency: Hertz (1/s)
    hertz_dims = Dict(BaseUnit.s => -1 // 1)
    registry["Hz"] = BaseUnitDecomposition(1.0, hertz_dims)
    registry["hertz"] = BaseUnitDecomposition(1.0, hertz_dims)
    merge!(registry, generate_si_prefixed_derived_units("Hz", hertz_dims))

    # Angular velocity: revolutions per minute
    # Note: rpm is an angular velocity unit that's compatible with deg/s
    # Since "deg" converts to radians with factor π/180, and 1 revolution = 2π radians:
    # 1 rpm = 1 rev/min = 2π rad/60 s = π/30 rad/s
    # This makes it compatible with deg/s which has factor π/180 rad/s
    registry["rpm"] = BaseUnitDecomposition(π / 30.0, hertz_dims)

    # Velocity: knot (nautical mile per hour, 1 knot = 1.852 km/h = 0.514444 m/s)
    velocity_dims = Dict(BaseUnit.m => 1 // 1, BaseUnit.s => -1 // 1)
    registry["knot"] = BaseUnitDecomposition(0.514444, velocity_dims)

    # Velocity: mach (speed of sound at sea level, approximately 331.46 m/s)
    registry["mach"] = BaseUnitDecomposition(331.46, velocity_dims)

    # Acceleration: standard gravity (g = 9.80665 m/s²)
    acceleration_dims = Dict(BaseUnit.m => 1 // 1, BaseUnit.s => -2 // 1)
    registry["gravity"] = BaseUnitDecomposition(9.80665, acceleration_dims)

    # Electric charge: Coulomb (A⋅s)
    coulomb_dims = Dict(BaseUnit.A => 1 // 1, BaseUnit.s => 1 // 1)
    registry["C"] = BaseUnitDecomposition(1.0, coulomb_dims)
    registry["coulomb"] = BaseUnitDecomposition(1.0, coulomb_dims)
    merge!(registry, generate_si_prefixed_derived_units("C", coulomb_dims))

    # Ampere-hour (A⋅h, 1 Ah = 3600 C)
    registry["Ah"] = BaseUnitDecomposition(3600.0, coulomb_dims)
    for (prefix, scale) in SI_PREFIXES
        prefixed_name = prefix * "Ah"
        registry[prefixed_name] = BaseUnitDecomposition(3600.0 * scale, coulomb_dims)
    end

    # Electric potential: Volt (kg⋅m²/(A⋅s³))
    volt_dims = Dict(BaseUnit.kg => 1 // 1, BaseUnit.m => 2 // 1, BaseUnit.s => -3 // 1, BaseUnit.A => -1 // 1)
    registry["V"] = BaseUnitDecomposition(1.0, volt_dims)
    registry["volt"] = BaseUnitDecomposition(1.0, volt_dims)
    merge!(registry, generate_si_prefixed_derived_units("V", volt_dims))

    # Electric resistance: Ohm (kg⋅m²/(A²⋅s³))
    ohm_dims = Dict(BaseUnit.kg => 1 // 1, BaseUnit.m => 2 // 1, BaseUnit.s => -3 // 1, BaseUnit.A => -2 // 1)
    registry["Ω"] = BaseUnitDecomposition(1.0, ohm_dims)
    registry["ohm"] = BaseUnitDecomposition(1.0, ohm_dims)
    merge!(registry, generate_si_prefixed_derived_units("ohm", ohm_dims))
    registry["microohm"] = BaseUnitDecomposition(1.0e-6, ohm_dims)

    # Electric capacitance: Farad (A²⋅s⁴/(kg⋅m²))
    farad_dims = Dict(BaseUnit.A => 2 // 1, BaseUnit.s => 4 // 1, BaseUnit.kg => -1 // 1, BaseUnit.m => -2 // 1)
    registry["F"] = BaseUnitDecomposition(1.0, farad_dims)
    registry["farad"] = BaseUnitDecomposition(1.0, farad_dims)
    merge!(registry, generate_si_prefixed_derived_units("farad", farad_dims))
    registry["microfarad"] = BaseUnitDecomposition(1.0e-6, farad_dims)
    registry["picofarad"] = BaseUnitDecomposition(1.0e-12, farad_dims)

    # Electric inductance: Henry (kg⋅m²/(A²⋅s²))
    henry_dims = Dict(BaseUnit.kg => 1 // 1, BaseUnit.m => 2 // 1, BaseUnit.A => -2 // 1, BaseUnit.s => -2 // 1)
    registry["H"] = BaseUnitDecomposition(1.0, henry_dims)
    registry["henry"] = BaseUnitDecomposition(1.0, henry_dims)
    merge!(registry, generate_si_prefixed_derived_units("henry", henry_dims))
    registry["millihenry"] = BaseUnitDecomposition(1.0e-3, henry_dims)
    registry["microhenry"] = BaseUnitDecomposition(1.0e-6, henry_dims)

    # Electric conductance: Siemens (A²⋅s³/(kg⋅m²))
    siemens_dims = Dict(BaseUnit.A => 2 // 1, BaseUnit.s => 3 // 1, BaseUnit.kg => -1 // 1, BaseUnit.m => -2 // 1)
    registry["S"] = BaseUnitDecomposition(1.0, siemens_dims)
    registry["siemens"] = BaseUnitDecomposition(1.0, siemens_dims)
    registry["mho"] = BaseUnitDecomposition(1.0, siemens_dims)  # mho = inverse ohm = siemens

    # Magnetic flux: Weber (kg⋅m²/(A⋅s²))
    weber_dims = Dict(BaseUnit.kg => 1 // 1, BaseUnit.m => 2 // 1, BaseUnit.A => -1 // 1, BaseUnit.s => -2 // 1)
    registry["Wb"] = BaseUnitDecomposition(1.0, weber_dims)
    registry["weber"] = BaseUnitDecomposition(1.0, weber_dims)

    # Maxwell (CGS unit of magnetic flux, 1 maxwell = 10^-8 Wb)
    registry["maxwell"] = BaseUnitDecomposition(1.0e-8, weber_dims)

    # Magnetic flux density: Tesla (kg/(A⋅s²))
    tesla_dims = Dict(BaseUnit.kg => 1 // 1, BaseUnit.A => -1 // 1, BaseUnit.s => -2 // 1)
    registry["T"] = BaseUnitDecomposition(1.0, tesla_dims)
    registry["tesla"] = BaseUnitDecomposition(1.0, tesla_dims)

    # Gauss (CGS unit of magnetic flux density, 1 gauss = 10^-4 T)
    registry["gauss"] = BaseUnitDecomposition(1.0e-4, tesla_dims)

    # Oersted (CGS unit of magnetizing field, 1 Oe = 1000/(4π) A/m ≈ 79.577 A/m)
    oersted_dims = Dict(BaseUnit.A => 1 // 1, BaseUnit.m => -1 // 1)
    registry["oersted"] = BaseUnitDecomposition(1000.0 / (4.0 * π), oersted_dims)
    registry["Oe"] = BaseUnitDecomposition(1000.0 / (4.0 * π), oersted_dims)

    # Debye (electric dipole moment, 1 D ≈ 3.33564×10^-30 C·m)
    debye_dims = Dict(BaseUnit.A => 1 // 1, BaseUnit.s => 1 // 1, BaseUnit.m => 1 // 1)
    registry["debye"] = BaseUnitDecomposition(3.33564e-30, debye_dims)
    registry["D"] = BaseUnitDecomposition(3.33564e-30, debye_dims)

    # ========== Radiation Units ==========
    # Radioactivity: Becquerel (1/s)
    becquerel_dims = Dict(BaseUnit.s => -1 // 1)
    registry["Bq"] = BaseUnitDecomposition(1.0, becquerel_dims)
    registry["becquerel"] = BaseUnitDecomposition(1.0, becquerel_dims)

    # Curie (radioactivity, 1 Ci = 3.7×10^10 Bq)
    registry["Ci"] = BaseUnitDecomposition(3.7e10, becquerel_dims)
    registry["curie"] = BaseUnitDecomposition(3.7e10, becquerel_dims)

    # Absorbed dose: Gray (J/kg = m²/s²)
    gray_dims = Dict(BaseUnit.m => 2 // 1, BaseUnit.s => -2 // 1)
    registry["Gy"] = BaseUnitDecomposition(1.0, gray_dims)
    registry["gray"] = BaseUnitDecomposition(1.0, gray_dims)

    # Rad (absorbed dose, 1 rad = 0.01 Gy)
    registry["rad"] = BaseUnitDecomposition(0.01, gray_dims)

    # Equivalent dose: Sievert (J/kg = m²/s², same dimensions as Gray)
    sievert_dims = Dict(BaseUnit.m => 2 // 1, BaseUnit.s => -2 // 1)
    registry["Sv"] = BaseUnitDecomposition(1.0, sievert_dims)
    registry["sievert"] = BaseUnitDecomposition(1.0, sievert_dims)

    # Rem (equivalent dose, 1 rem = 0.01 Sv)
    registry["rem"] = BaseUnitDecomposition(0.01, sievert_dims)

    # Roentgen (exposure dose, 1 R = 2.58×10^-4 C/kg)
    roentgen_dims = Dict(BaseUnit.A => 1 // 1, BaseUnit.s => 1 // 1, BaseUnit.kg => -1 // 1)
    registry["roentgen"] = BaseUnitDecomposition(2.58e-4, roentgen_dims)
    registry["R"] = BaseUnitDecomposition(2.58e-4, roentgen_dims)

    # ========== Catalytic Activity ==========
    # Katal (catalytic activity: mol/s)
    katal_dims = Dict(BaseUnit.mol => 1 // 1, BaseUnit.s => -1 // 1)
    registry["kat"] = BaseUnitDecomposition(1.0, katal_dims)
    registry["katal"] = BaseUnitDecomposition(1.0, katal_dims)

    # ========== Textile Units (Linear Mass Density) ==========
    # Linear mass density: kg/m
    linear_density_dims = Dict(BaseUnit.kg => 1 // 1, BaseUnit.m => -1 // 1)

    # Tex (g/1000m = 10^-6 kg/m)
    registry["tex"] = BaseUnitDecomposition(1.0e-6, linear_density_dims)

    # Denier (g/9000m = 1/9 tex)
    registry["denier"] = BaseUnitDecomposition(1.0e-6 / 9.0, linear_density_dims)

    # ========== Permeability ==========
    # Darcy (permeability unit, 1 darcy ≈ 9.869233×10^-13 m²)
    permeability_dims = Dict(BaseUnit.m => 2 // 1)
    registry["darcy"] = BaseUnitDecomposition(9.8692327e-13, permeability_dims)

    # ========== Acoustic Impedance ==========
    # Rayl (acoustic impedance, 1 rayl = 1 Pa·s/m = 10 kg/(m²·s))
    acoustic_impedance_dims = Dict(BaseUnit.kg => 1 // 1, BaseUnit.m => -2 // 1, BaseUnit.s => -1 // 1)
    registry["rayl"] = BaseUnitDecomposition(10.0, acoustic_impedance_dims)

    # ========== Common Energy Units (Watt-hours) ==========
    # Watt-hour: Wh (same dimensions as Joule: kg⋅m²/s²)
    # 1 Wh = 1 W * 1 h = 1 W * 3600 s = 3600 J
    wh_dims = Dict(BaseUnit.kg => 1 // 1, BaseUnit.m => 2 // 1, BaseUnit.s => -2 // 1)
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
is_registered_unit(unit::AbstractString) = haskey(UNIT_REGISTRY, unit)

# Get the base unit decomposition for a unit
function get_base_decomposition(unit::AbstractString)::BaseUnitDecomposition
    if !haskey(UNIT_REGISTRY, unit)
        throw(UnknownUnitError(unit))
    end
    return UNIT_REGISTRY[unit]
end
