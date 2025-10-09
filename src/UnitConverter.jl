module UnitConverter

export get_conversion_factor, add_definition!

# --- 1. Core Data Structures ---

abstract type AbstractUnit end

struct ResolvedUnit <: AbstractUnit
    factor::Float64
    base_units::Dict{String, Rational{Int}}
end

struct FunctionalUnit <: AbstractUnit
    to_base::Function
    from_base::Function
    base_units::Dict{String, Rational{Int}}
end

ResolvedUnit() = ResolvedUnit(1.0, Dict{String, Rational{Int}}())

# --- 2. Dictionaries for Definitions and Caching ---

const UNIT_DEFINITIONS = Dict{String, Any}()
const RESOLVED_UNITS_CACHE = Dict{String, AbstractUnit}()

# --- 3. Initializing the Database ---

function initialize_database!()
    empty!(UNIT_DEFINITIONS)
    empty!(RESOLVED_UNITS_CACHE)

    # SI Base Units
    UNIT_DEFINITIONS["m"] = ResolvedUnit(1.0, Dict("m" => 1//1))
    UNIT_DEFINITIONS["s"] = ResolvedUnit(1.0, Dict("s" => 1//1))
    UNIT_DEFINITIONS["g"] = ResolvedUnit(1.0, Dict("g" => 1//1))
    UNIT_DEFINITIONS["K"] = ResolvedUnit(1.0, Dict("K" => 1//1))

    # Prefixes (stored with a special key)
    UNIT_DEFINITIONS["_prefix_k"] = ResolvedUnit(1000.0, Dict())
    UNIT_DEFINITIONS["_prefix_c"] = ResolvedUnit(0.01, Dict())
    UNIT_DEFINITIONS["_prefix_milli"] = ResolvedUnit(0.001, Dict())
    
    # Generic Definitions
    UNIT_DEFINITIONS["minute"] = "60 s"
    UNIT_DEFINITIONS["hour"]   = "60 minute"
    UNIT_DEFINITIONS["day"]    = "24 hour"
    UNIT_DEFINITIONS["inch"]   = "2.54 cm" # cm will be parsed as c + m
    UNIT_DEFINITIONS["foot"]   = "12 inch"
    UNIT_DEFINITIONS["mile"]   = "5280 foot"
    UNIT_DEFINITIONS["pound"]  = "453.59237 g"
    UNIT_DEFINITIONS["kg"]     = "k g" # Define kg in terms of the prefix 'k'
    
    # Non-linear units
    UNIT_DEFINITIONS["celsius"] = FunctionalUnit(val->val + 273.15, base->base - 273.15, Dict("K"=>1//1))
    UNIT_DEFINITIONS["h"] = "hour"
end

# --- 4. Core Resolution and Parsing Logic (Corrected) ---

import Base: *, /, ^, inv

# *** FIX 1: Define the inv() method for ResolvedUnit ***
function inv(a::ResolvedUnit)
    # The inverse has a reciprocal factor and negated powers
    new_factor = 1.0 / a.factor
    new_base = Dict(k => -v for (k, v) in a.base_units)
    ResolvedUnit(new_factor, new_base)
end

*(a::ResolvedUnit, b::ResolvedUnit) = ResolvedUnit(a.factor * b.factor, mergewith(+, a.base_units, b.base_units))
/(a::ResolvedUnit, b::ResolvedUnit) = a * inv(b) # Can now safely use inv()
^(a::ResolvedUnit, p::Real) = ResolvedUnit(a.factor^p, Dict(k => v * rationalize(p) for (k, v) in a.base_units))

# The pre-processor for handling implicit multiplication
function preprocess_expression(s::String)
    s_spaced = replace(s, r"([*/^()])" => s" \1 ")
    tokens = split(s_spaced, keepempty=false)
    processed_tokens = []
    last_token_was_value = false
    for token in tokens
        is_operator = token in ["*", "/", "^", "("]
        if last_token_was_value && !is_operator
            push!(processed_tokens, "*")
        end
        push!(processed_tokens, token)
        last_token_was_value = !(token in ["*", "/", "^", "("])
    end
    return join(processed_tokens, " ")
end

# The main resolution engine
function resolve_expression(s::String)::AbstractUnit
    s_processed = preprocess_expression(s)
    try
        julia_expr = Meta.parse(s_processed)
        return eval_unit_expr(julia_expr)
    catch e
        error("Failed to parse unit expression '$s' (processed as '$s_processed'). Reason: $e")
    end
end

# The recursive evaluator with prefix logic restored
function eval_unit_expr(expr)::AbstractUnit
    if isa(expr, Number); return ResolvedUnit(expr, Dict()); end
    
    if isa(expr, Symbol)
        name = string(expr)
        if haskey(RESOLVED_UNITS_CACHE, name); return RESOLVED_UNITS_CACHE[name]; end

        # First, try a direct lookup (e.g., "hour", "pound")
        if haskey(UNIT_DEFINITIONS, name)
            definition = UNIT_DEFINITIONS[name]
            resolved_unit = isa(definition, AbstractUnit) ? definition : resolve_expression(definition)
            RESOLVED_UNITS_CACHE[name] = resolved_unit
            return resolved_unit
        end

        # *** FIX 2: Restore prefix parsing logic ***
        # If no direct match, try parsing as "prefix + unit"
        for (key, prefix_unit) in filter(p -> startswith(p.first, "_prefix_"), UNIT_DEFINITIONS)
            prefix_name = replace(key, "_prefix_" => "")
            if startswith(name, prefix_name)
                base_unit_name = name[length(prefix_name)+1:end]
                if !isempty(base_unit_name) && haskey(UNIT_DEFINITIONS, base_unit_name)
                    resolved_base_unit = resolve_expression(base_unit_name)
                    resolved_unit = prefix_unit * resolved_base_unit
                    RESOLVED_UNITS_CACHE[name] = resolved_unit
                    return resolved_unit
                end
            end
        end

        # If still not found, treat as a new base unit
        return ResolvedUnit(1.0, Dict(name => 1//1))
    end
    
    if isa(expr, Expr) && expr.head == :call && length(expr.args) == 3
        op, a, b = expr.args
        return getfield(Base, op)(eval_unit_expr(a), eval_unit_expr(b))
    end
    error("Cannot evaluate unit expression component: $expr")
end

# --- 5. Public API Functions (Unchanged) ---

function get_conversion_factor(from_unit_str::String, to_unit_str::String)::Float64
    from_unit = resolve_expression(from_unit_str)
    to_unit = resolve_expression(to_unit_str)

    if isa(from_unit, FunctionalUnit) || isa(to_unit, FunctionalUnit)
        error("Cannot get a simple conversion factor for non-linear units like temperature.")
    end
    if from_unit.base_units != to_unit.base_units
        error("Incompatible units. '$from_unit_str' -> $(from_unit.base_units) vs '$to_unit_str' -> $(to_unit.base_units)")
    end
    
    return from_unit.factor / to_unit.factor
end

function add_definition!(name::String, definition::String)
    UNIT_DEFINITIONS[name] = definition
    empty!(RESOLVED_UNITS_CACHE)
    println("Added definition: '$name' = '$definition'")
end

# Initialize the database
initialize_database!()

end # End of Module