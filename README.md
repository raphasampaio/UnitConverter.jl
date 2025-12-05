# UnitConverter.jl

[![CI](https://github.com/raphasampaio/UnitConverter.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/raphasampaio/UnitConverter.jl/actions/workflows/CI.yml)
[![codecov](https://codecov.io/gh/raphasampaio/UnitConverter.jl/graph/badge.svg?token=p8txdpuTJP)](https://codecov.io/gh/raphasampaio/UnitConverter.jl)
[![Aqua](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)

## Introduction

UnitConverter.jl is a comprehensive Julia package for converting between different units of measurement. It supports a wide range of unit systems including SI, Imperial, US customary, and specialized scientific units. The package handles dimensional analysis automatically, ensuring that conversions are physically meaningful.

## Getting Started

### Installation

```julia
pkg> add UnitConverter
```

### Example 1: Basic Length Conversion

```julia
using UnitConverter

# Convert 5 kilometers to miles
result = convert_unit(5.0, "km", "mi")
println("5 km = $result miles")  # 5 km = 3.106855 miles

# Convert 100 meters to feet
result = convert_unit(100.0, "m", "ft")
println("100 m = $result feet")  # 100 m = 328.08399 feet
```

### Example 2: Temperature Conversion

```julia
using UnitConverter

# Convert Celsius to Fahrenheit
result = convert_unit(25.0, "degC", "degF")
println("25 °C = $result °F")  # 25 °C = 77.0 °F

# Convert Fahrenheit to Kelvin
result = convert_unit(98.6, "degF", "K")
println("98.6 °F = $result K")  # 98.6 °F = 310.15 K
```

### Example 3: Energy and Power Conversions

```julia
using UnitConverter

# Convert kilowatt-hours to joules
result = convert_unit(1.0, "kWh", "J")
println("1 kWh = $result J")  # 1 kWh = 3.6e6 J

# Convert horsepower to watts
result = convert_unit(100.0, "hp", "W")
println("100 hp = $result W")  # 100 hp = 74569.987 W

# Convert BTU per hour to watts
result = convert_unit(3412.0, "btu/hour", "W")
println("3412 BTU/hour ≈ $result W")  # ≈ 1000 W
```

### Example 4: Complex Unit Expressions

```julia
using UnitConverter

# Pressure conversion
result = convert_unit(1.0, "Pa", "psi")
println("1 Pa = $result psi")  # 1 Pa = 0.0001450377 psi

# Density conversion
result = convert_unit(1000.0, "kg/m^3", "lb/ft^3")
println("1000 kg/m³ = $result lb/ft³")  # 1000 kg/m³ = 62.42796 lb/ft³

# Specific energy conversion
result = convert_unit(1.0, "MJ/kg", "btu/lb")
println("1 MJ/kg = $result BTU/lb")  # 1 MJ/kg = 429.92261 BTU/lb

# Fuel economy conversion (gallons per 100 miles to liters per km)
result = convert_unit(1.0, "liter/km", "gal/100mi")
println("1 L/km = $result gal/100mi")  # 1 L/km = 42.514371 gal/100mi
```

### Example 5: Scientific Units

```julia
using UnitConverter

# CGS energy unit
result = convert_unit(1.0, "erg", "J")
println("1 erg = $result J")  # 1 erg = 1.0e-7 J

# Electron volt to joules
result = convert_unit(1.0, "eV", "J")
println("1 eV = $result J")  # 1 eV = 1.602176634e-19 J

# Atomic units
result = convert_unit(1.0, "hartree", "eV")
println("1 hartree = $result eV")  # 1 hartree = 27.211386 eV

# Angstrom to nanometers
result = convert_unit(10.0, "angstrom", "nm")
println("10 Å = $result nm")  # 10 Å = 1.0 nm
```

### Example 6: Specialized Units

```julia
using UnitConverter

# Solar radiation
result = convert_unit(1.0, "langley", "cal/cm^2")
println("1 langley = $result cal/cm²")  # 1 langley = 1.0 cal/cm²

# Cooling capacity
result = convert_unit(1.0, "tonrefrigeration", "kW")
println("1 ton refrigeration = $result kW")  # 1 ton refrigeration = 3.5168528 kW

# Permeability
result = convert_unit(1.0, "darcy", "m^2")
println("1 darcy = $result m²")  # 1 darcy = 9.8692327e-13 m²

# Wavenumber
result = convert_unit(1.0, "kayser", "1/cm")
println("1 kayser = $result cm⁻¹")  # 1 kayser = 1.0 cm⁻¹
```

## Contributing

Contributions, bug reports, and feature requests are welcome! Feel free to open an issue or submit a pull request.