module TestAll

using Test
using UnitConverter

@testset "All" begin
    @test convert_unit("degC", "degF") ≈ 1.8
    @test convert_unit("degF", "degC") ≈ 0.55555556

    @test convert_unit("m", "cm") ≈ 100
    @test convert_unit("km", "m") ≈ 1000
    @test convert_unit("km", "cm") ≈ 100000

    @test convert_unit("m", "km") ≈ 0.001
    @test convert_unit("cm", "m") ≈ 0.01
    @test convert_unit("cm", "km") ≈ 1e-05

    @test convert_unit("in", "cm") ≈ 2.54
    @test convert_unit("cm", "in") ≈ 1 / 2.54

    @test convert_unit("ft", "m") ≈ 0.3048
    @test convert_unit("m", "ft") ≈ 1 / 0.3048

    @test convert_unit("yd", "m") ≈ 0.9144
    @test convert_unit("m", "yd") ≈ 1 / 0.9144

    @test convert_unit("mi", "km") ≈ 1.60934
    @test convert_unit("km", "mi") ≈ 1 / 1.60934

    @test convert_unit("kg", "g") ≈ 1000
    @test convert_unit("g", "kg") ≈ 0.001

    @test convert_unit("lb", "kg") ≈ 0.45359237
    @test convert_unit("oz", "g") ≈ 28.349523125

    @test convert_unit("kg", "lb") ≈ 1 / 0.45359237
    @test convert_unit("g", "oz") ≈ 1 / 28.349523125

    @test convert_unit("m/s", "km/h") ≈ 3.6
    @test convert_unit("km/h", "m/s") ≈ 1 / 3.6

    @test convert_unit("rad", "deg") ≈ 180 / pi
    @test convert_unit("deg", "rad") ≈ pi / 180

    @test convert_unit("L", "ml") ≈ 1000
    @test convert_unit("ml", "L") ≈ 0.001

    @test convert_unit("hr", "min") ≈ 60
    @test convert_unit("min", "hr") ≈ 1 / 60

    @test convert_unit("m^2", "cm^2") ≈ 10000
    @test convert_unit("cm^2", "m^2") ≈ 0.0001

    @test convert_unit("m^3", "cm^3") ≈ 1000000
    @test convert_unit("cm^3", "m^3") ≈ 1e-06

    @test convert_unit("Pa", "kPa") ≈ 0.001
    @test convert_unit("kPa", "Pa") ≈ 1000

    @test convert_unit("J", "kJ") ≈ 0.001
    @test convert_unit("kJ", "J") ≈ 1000

    @test convert_unit("W", "kW") ≈ 0.001
    @test convert_unit("kW", "W") ≈ 1000

    @test convert_unit("N", "kg*m/s^2") ≈ 1
    @test convert_unit("J", "N*m") ≈ 1
    @test convert_unit("W", "J/s") ≈ 1
    @test convert_unit("Pa", "N/m^2") ≈ 1

    @test convert_unit("mm", "km") ≈ 1e-06
    @test convert_unit("mg", "kg") ≈ 1e-06
    @test convert_unit("μs", "ms") ≈ 0.001
end

end