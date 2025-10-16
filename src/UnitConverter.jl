module UnitConverter

# Export main conversion function
export convert_unit

# Include submodules
include("unit_registry.jl")
include("parser.jl")
include("dimensional_analysis.jl")
include("converter.jl")

end
