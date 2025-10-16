module TestTime

using UnitConverter
using Test

@testset "Time" begin
    @test convert_unit("s", "minute") ≈ 1 / 60.0
    @test convert_unit("minute", "s") ≈ 60.0

    @test convert_unit("minute", "hour") ≈ 1 / 60.0
    @test convert_unit("hour", "minute") ≈ 60.0

    @test convert_unit("hour", "day") ≈ 1 / 24.0
    @test convert_unit("day", "hour") ≈ 24.0

    @test convert_unit("day", "week") ≈ 1 / 7.0
    @test convert_unit("week", "day") ≈ 7.0
end
end