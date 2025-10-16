module TestMass

using Test
using UnitConverter

@testset "Mass Conversions" begin
    @testset "Metric Conversions" begin
        @test convert_unit("kg", "g") ≈ 1000
        @test convert_unit("g", "kg") ≈ 0.001
    end

    @testset "Imperial to Metric" begin
        @test convert_unit("lb", "kg") ≈ 0.453592
        @test convert_unit("oz", "g") ≈ 28.3495
    end

    @testset "Metric to Imperial" begin
        @test convert_unit("kg", "lb") ≈ 1/0.453592
        @test convert_unit("g", "oz") ≈ 1/28.3495
    end
end

end