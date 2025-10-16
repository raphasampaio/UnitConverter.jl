module TestTemperature

using Test
using UnitConverter

@testset "Temperature" begin
    @testset "Absolute Temperature Conversions" begin
        # Celsius to Fahrenheit
        @test convert_unit(0, "celsius", "fahrenheit") ≈ 32.0
        @test convert_unit(100, "celsius", "fahrenheit") ≈ 212.0
        @test convert_unit(37, "celsius", "fahrenheit") ≈ 98.6
        @test convert_unit(-40, "celsius", "fahrenheit") ≈ -40.0  # special point where C = F

        # Fahrenheit to Celsius
        @test convert_unit(32, "fahrenheit", "celsius") ≈ 0.0
        @test convert_unit(212, "fahrenheit", "celsius") ≈ 100.0
        @test convert_unit(98.6, "fahrenheit", "celsius") ≈ 37.0

        # Celsius to Kelvin
        @test convert_unit(0, "celsius", "kelvin") ≈ 273.15
        @test convert_unit(100, "celsius", "kelvin") ≈ 373.15
        @test convert_unit(-273.15, "celsius", "kelvin") ≈ 0.0  # absolute zero

        # Kelvin to Celsius
        @test convert_unit(273.15, "kelvin", "celsius") ≈ 0.0
        @test convert_unit(373.15, "kelvin", "celsius") ≈ 100.0
        @test convert_unit(0, "kelvin", "celsius") ≈ -273.15

        # Fahrenheit to Kelvin
        @test convert_unit(32, "fahrenheit", "kelvin") ≈ 273.15
        @test convert_unit(212, "fahrenheit", "kelvin") ≈ 373.15

        # Kelvin to Fahrenheit
        @test convert_unit(273.15, "kelvin", "fahrenheit") ≈ 32.0
        @test convert_unit(373.15, "kelvin", "fahrenheit") ≈ 212.0

        # Rankine conversions
        @test convert_unit(491.67, "rankine", "fahrenheit") ≈ 32.0
        @test convert_unit(0, "rankine", "kelvin") ≈ 0.0
    end

    @testset "Non-Temperature Units Still Work" begin
        # Make sure convert_unit works for regular linear units too
        @test convert_unit(1000, "m", "km") ≈ 1.0
        @test convert_unit(60, "s", "minute") ≈ 1.0
        @test convert_unit(1, "kg", "g") ≈ 1000.0
    end
end

end