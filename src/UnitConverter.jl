module UnitConverter

# Export main conversion functions
export convert_unit, convert_unit

# Include submodules
include("unit_registry.jl")
include("parser.jl")
include("dimensional_analysis.jl")
include("converter.jl")

end
