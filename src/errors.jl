# Custom Exception Types for UnitConverter.jl

"""
    DimensionalMismatchError

Exception thrown when attempting to convert between units with incompatible dimensions.

# Fields

  - `from_unit::String`: The source unit string
  - `to_unit::String`: The target unit string
  - `from_dimensions::String`: The dimensions of the source unit
  - `to_dimensions::String`: The dimensions of the target unit

# Example

```julia
try
    convert_unit("m", "kg")
catch e
    if e isa DimensionalMismatchError
        println("From: ", e.from_unit, " [", e.from_dimensions, "]")
        println("To: ", e.to_unit, " [", e.to_dimensions, "]")
    end
end
```
"""
struct DimensionalMismatchError <: Exception
    from_unit::String
    to_unit::String
    from_dimensions::String
    to_dimensions::String
end

function Base.showerror(io::IO, e::DimensionalMismatchError)
    print(io, "DimensionalMismatchError: Cannot convert between incompatible units: ")
    print(io, "'$(e.from_unit)' [$(e.from_dimensions)] and ")
    return print(io, "'$(e.to_unit)' [$(e.to_dimensions)]")
end

"""
    UnknownUnitError

Exception thrown when a unit is not found in the unit registry.

# Fields

  - `unit::String`: The unknown unit string

# Example

```julia
try
    convert_unit("xyz", "m")
catch e
    if e isa UnknownUnitError
        println("Unit not found: ", e.unit)
    end
end
```
"""
struct UnknownUnitError <: Exception
    unit::String
end

function Base.showerror(io::IO, e::UnknownUnitError)
    return print(io, "UnknownUnitError: Unknown unit: '$(e.unit)'")
end

"""
    InvalidUnitSyntaxError

Exception thrown when a unit string cannot be parsed due to invalid syntax.

# Fields

  - `unit_string::String`: The invalid unit string
  - `reason::String`: A description of why the syntax is invalid

# Example

```julia
try
    convert_unit("m^^2", "m")
catch e
    if e isa InvalidUnitSyntaxError
        println("Invalid: ", e.unit_string)
        println("Reason: ", e.reason)
    end
end
```
"""
struct InvalidUnitSyntaxError <: Exception
    unit_string::String
    reason::String
end

function Base.showerror(io::IO, e::InvalidUnitSyntaxError)
    return print(io, "InvalidUnitSyntaxError: Invalid unit syntax in '$(e.unit_string)': $(e.reason)")
end
