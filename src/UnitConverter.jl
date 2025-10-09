module UnitConverter

export convert_units, add_definition!

# --- 1. Core Data Structures ---

abstract type AbstractUnit end

# Represents a fully resolved, standard unit.
# All generic definitions eventually resolve into this.
struct ResolvedUnit <: AbstractUnit
    factor::Float64
    base_units::Dict{String, Rational{Int}}
end

# Represents non-linear units like temperature.
struct FunctionalUnit <: AbstractUnit
    to_base::Function
    from_base::Function
    base_units::Dict{String, Rational{Int}}
end

# Constructor for an empty (identity) unit
ResolvedUnit() = ResolvedUnit(1.0, Dict{String, Rational{Int}}())

# --- 2. The Dictionaries for Definitions and Caching ---

# `UNIT_DEFINITIONS` stores the raw definitions, which can be either a
# string (like "24 * hour") or a pre-resolved unit.
const UNIT_DEFINITIONS = Dict{String, Any}()

# `RESOLVED_UNITS_CACHE` stores the result of resolving a definition string
# to speed up subsequent lookups.
const RESOLVED_UNITS_CACHE = Dict{String, AbstractUnit}()

# --- 3. Initializing the Database with Generic Definitions ---

function initialize_database!()
    # Clear any previous definitions
    empty!(UNIT_DEFINITIONS)
    empty!(RESOLVED_UNITS_CACHE)

    # SI Base Units (these are the fundamental building blocks)
    UNIT_DEFINITIONS["m"] = ResolvedUnit(1.0, Dict("m" => 1//1))
    UNIT_DEFINITIONS["s"] = ResolvedUnit(1.0, Dict("s" => 1//1))
    UNIT_DEFINITIONS["g"] = ResolvedUnit(1.0, Dict("g" => 1//1))
    UNIT_DEFINITIONS["K"] = ResolvedUnit(1.0, Dict("K" => 1//1))
    # ... other base units ...

    # Prefixes (defined as simple factors)
    UNIT_DEFINITIONS["k"] = "1000"
    UNIT_DEFINITIONS["c"] = "0.01"
    UNIT_DEFINITIONS["milli"] = "0.001"
    
    # Generic, human-readable definitions
    UNIT_DEFINITIONS["minute"] = "60 s"
    UNIT_DEFINITIONS["hour"]   = "60 minute"
    UNIT_DEFINITIONS["day"]    = "24 hour"
    UNIT_DEFINITIONS["year"]   = "365.25 day" # More precise

    # Imperial units defined generically
    UNIT_DEFINITIONS["inch"]   = "2.54 cm"
    UNIT_DEFINITIONS["foot"]   = "12 inch"
    UNIT_DEFINITIONS["yard"]   = "3 foot"
    UNIT_DEFINITIONS["mile"]   = "1760 yard"

    # Mass
    UNIT_DEFINITIONS["pound"]  = "453.59237 g"
    UNIT_DEFINITIONS["ounce"]  = "1/16 pound"

    # Force
    UNIT_DEFINITIONS["newton"] = "kg*m/s^2" # Alias for convenience

    # Non-linear temperature units
    UNIT_DEFINITIONS["celsius"] = FunctionalUnit(
        val -> val + 273.15,
        base -> base - 273.15,
        Dict("K" => 1//1)
    )
    UNIT_DEFINITIONS["fahrenheit"] = FunctionalUnit(
        val -> (val + 459.67) * 5/9,
        base -> base * 9/5 - 459.67,
        Dict("K" => 1//1)
    )
    
    # Aliases
    UNIT_DEFINITIONS["min"] = "minute"
    UNIT_DEFINITIONS["h"]   = "hour"
    UNIT_DEFINITIONS["N"]   = "newton"
end

# --- 4. The Core Resolution and Parsing Logic ---

import Base: *, /, ^

# Define operators for our resolved units
*(a::ResolvedUnit, b::ResolvedUnit) = ResolvedUnit(a.factor * b.factor, mergewith(+, a.base_units, b.base_units))
/(a::ResolvedUnit, b::ResolvedUnit) = a * (b^-1)
^(a::ResolvedUnit, p::Real) = ResolvedUnit(a.factor^p, Dict(k => v * rationalize(p) for (k, v) in a.base_units))

# The main resolution engine. Takes a unit name or expression string.
function resolve_expression(s::String)::AbstractUnit
    s_cleaned = replace(s, r"([0-9])([a-zA-Z])" => s"\1*\2") # Add implicit '*'
    try
        # Use Julia's own parser for safety and power
        julia_expr = Meta.parse(s_cleaned)
        return eval_unit_expr(julia_expr)
    catch e
        error("Failed to parse unit expression '$s'. Reason: $e")
    end
end

# Helper that recursively evaluates the parsed expression tree
function eval_unit_expr(expr)::AbstractUnit
    if isa(expr, Number)
        return ResolvedUnit(expr, Dict())
    end
    if isa(expr, Symbol) # A unit name like 'kg' or 'day'
        name = string(expr)
        
        # 1. Check the cache first for performance
        if haskey(RESOLVED_UNITS_CACHE, name)
            return RESOLVED_UNITS_CACHE[name]
        end

        # 2. Look up the definition
        if !haskey(UNIT_DEFINITIONS, name)
            # If completely unknown, treat it as a new base unit
            return ResolvedUnit(1.0, Dict(name => 1//1))
        end

        definition = UNIT_DEFINITIONS[name]
        
        # 3. Resolve the definition
        local resolved_unit
        if isa(definition, AbstractUnit) # Already a resolved or functional unit
            resolved_unit = definition
        elseif isa(definition, String) # A generic definition string to parse
            resolved_unit = resolve_expression(definition)
        else
            error("Invalid definition type for '$name'")
        end

        # 4. Cache the result and return
        RESOLVED_UNITS_CACHE[name] = resolved_unit
        return resolved_unit
    end
    if isa(expr, Expr) && expr.head == :call && length(expr.args) == 3 # An operation
        op, a, b = expr.args
        eval_a = eval_unit_expr(a)
        eval_b = eval_unit_expr(b)
        return getfield(Base, op)(eval_a, eval_b)
    end
    error("Cannot evaluate unit expression component: $expr")
end


# --- 5. Public API Functions ---

"""
    convert_units(value, from_unit, to_unit)

Converts a numerical value from one unit to another.
"""
function convert_units(from_value::Number, from_unit_str::String, to_unit_str::String)
    from_unit = resolve_expression(from_unit_str)
    to_unit = resolve_expression(to_unit_str)

    if from_unit.base_units != to_unit.base_units
        error("Incompatible units. '$from_unit_str' -> $(from_unit.base_units) vs '$to_unit_str' -> $(to_unit.base_units)")
    end

    if isa(from_unit, FunctionalUnit)
        base_value = from_unit.to_base(from_value)
        return to_unit.from_base(base_value)
    end

    conversion_factor = from_unit.factor / to_unit.factor
    return from_value * conversion_factor
end

"""
    add_definition!(name::String, definition::String)

Adds a new generic unit definition to the database.
"""
function add_definition!(name::String, definition::String)
    if haskey(UNIT_DEFINITIONS, name)
        @warn "Redefining existing unit '$name'."
    end
    UNIT_DEFINITIONS[name] = definition
    # Clear the cache in case this new definition affects existing resolved units
    empty!(RESOLVED_UNITS_CACHE)
    println("Added definition: '$name' = '$definition'")
end

# Initialize the database when the module is loaded
initialize_database!()

end # End of Module