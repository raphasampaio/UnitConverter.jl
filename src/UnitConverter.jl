module UnitConverter

using EnumX

# Export main conversion functions
export convert_unit

# Export custom exception types
export DimensionalMismatchError, UnknownUnitError, InvalidUnitSyntaxError

# Include submodules
include("errors.jl")
include("unit_registry.jl")
include("parser.jl")
include("dimensional_analysis.jl")
include("converter.jl")

end
