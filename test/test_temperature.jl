module TestTemperature

using Test
using UnitConverter

@testset "Temperature" begin
        @test convert_unit("C", "F") ≈ 1.8
        @test convert_unit("F", "C") ≈ 1/1.8

        @test convert_unit("C", "K") ≈ 1
        @test convert_unit("K", "C") ≈ 1
end

end