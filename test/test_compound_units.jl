module TestCompoundUnits

using UnitConverter
using Test

@testset "Compound Units" begin
    # Test Newton to base units
    @test convert_unit("N", "kg*m/s^2") ≈ 1.0
    @test convert_unit("kg*m/s^2", "N") ≈ 1.0

    # Test Joule to base units
    @test convert_unit("J", "kg*m^2/s^2") ≈ 1.0
    @test convert_unit("kg*m^2/s^2", "J") ≈ 1.0

    # Test Watt to base units
    @test convert_unit("W", "kg*m^2/s^3") ≈ 1.0
    @test convert_unit("kg*m^2/s^3", "W") ≈ 1.0

    # Test Pascal to base units
    @test convert_unit("Pa", "kg/m/s^2") ≈ 1.0
    @test convert_unit("kg*m^-1*s^-2", "Pa") ≈ 1.0

    # Test Hertz to base units
    @test convert_unit("Hz", "s^-1") ≈ 1.0
    @test convert_unit("s^-1", "Hz") ≈ 1.0

    # Test derived relationships
    @test convert_unit("J", "N*m") ≈ 1.0
    @test convert_unit("W", "J/s") ≈ 1.0

    # Test with different length units in compound expressions
    @test convert_unit("N", "g*km/s^2") ≈ 1.0
end

@testset "Dimensional Incompatibility" begin
    # These should throw errors
    @test_throws ErrorException convert_unit("m", "s")
    @test_throws ErrorException convert_unit("N", "kg")
    @test_throws ErrorException convert_unit("J", "N")
end

end
