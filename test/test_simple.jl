module TestSimple

using UnitConverter
using Test

@test get_conversion_factor("km/h", "m/s") ≈ 0.2777777777777778

@test get_conversion_factor("m/s", "km/h") ≈ 3.6

@test get_conversion_factor("day", "minute") ≈ 1440.0

end