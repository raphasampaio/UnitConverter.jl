module TestTemperature

using Test
using UnitConverter

@testset "Temperature" begin
    @testset "Temperature Intervals (Scale Factors Only)" begin
        # These use convert_unit which returns only the scale factor
        @test convert_unit("degC", "degF") ≈ 1.8
        @test convert_unit("degF", "degC") ≈ 1/1.8

        @test convert_unit("degC", "K") ≈ 1
        @test convert_unit("K", "degC") ≈ 1

        # Using convert_value with interval units (no offset)
        @test convert_value(10, "degC", "degF") ≈ 18.0  # 10°C change = 18°F change
        @test convert_value(18, "degF", "degC") ≈ 10.0
    end

    @testset "Absolute Temperature Conversions" begin
        # Celsius to Fahrenheit
        @test convert_value(0, "celsius", "fahrenheit") ≈ 32.0
        @test convert_value(100, "celsius", "fahrenheit") ≈ 212.0
        @test convert_value(37, "celsius", "fahrenheit") ≈ 98.6
        @test convert_value(-40, "celsius", "fahrenheit") ≈ -40.0  # special point where C = F

        # Fahrenheit to Celsius
        @test convert_value(32, "fahrenheit", "celsius") ≈ 0.0
        @test convert_value(212, "fahrenheit", "celsius") ≈ 100.0
        @test convert_value(98.6, "fahrenheit", "celsius") ≈ 37.0

        # Celsius to Kelvin
        @test convert_value(0, "celsius", "kelvin") ≈ 273.15
        @test convert_value(100, "celsius", "kelvin") ≈ 373.15
        @test convert_value(-273.15, "celsius", "kelvin") ≈ 0.0  # absolute zero

        # Kelvin to Celsius
        @test convert_value(273.15, "kelvin", "celsius") ≈ 0.0
        @test convert_value(373.15, "kelvin", "celsius") ≈ 100.0
        @test convert_value(0, "kelvin", "celsius") ≈ -273.15

        # Fahrenheit to Kelvin
        @test convert_value(32, "fahrenheit", "kelvin") ≈ 273.15
        @test convert_value(212, "fahrenheit", "kelvin") ≈ 373.15

        # Kelvin to Fahrenheit
        @test convert_value(273.15, "kelvin", "fahrenheit") ≈ 32.0
        @test convert_value(373.15, "kelvin", "fahrenheit") ≈ 212.0

        # Rankine conversions
        @test convert_value(491.67, "rankine", "fahrenheit") ≈ 32.0
        @test convert_value(0, "rankine", "kelvin") ≈ 0.0
    end

    @testset "Non-Temperature Units Still Work" begin
        # Make sure convert_value works for regular linear units too
        @test convert_value(1000, "m", "km") ≈ 1.0
        @test convert_value(60, "s", "minute") ≈ 1.0
        @test convert_value(1, "kg", "g") ≈ 1000.0
    end
end

end