module TestLength

using Test
using UnitConverter

@testset "Length" begin
    @testset "Metric" begin
        @test convert_unit("m", "cm") ≈ 100
        @test convert_unit("km", "m") ≈ 1000
        @test convert_unit("m", "km") ≈ 0.001
        @test convert_unit("cm", "m") ≈ 0.01
    end

    @testset "Imperial" begin
        @test convert_unit("in", "cm") ≈ 2.54
        @test convert_unit("cm", "in") ≈ 1 / 2.54

        @test convert_unit("ft", "m") ≈ 0.3048
        @test convert_unit("m", "ft") ≈ 1 / 0.3048

        @test convert_unit("yd", "m") ≈ 0.9144
        @test convert_unit("m", "yd") ≈ 1 / 0.9144

        @test convert_unit("mi", "km") ≈ 1.60934
        @test convert_unit("km", "mi") ≈ 1 / 1.60934
    end
end

end