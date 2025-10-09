module TestTime

using UnitConverter
using Test

@testset "Time" begin
    @test get_conversion_factor("s", "minute") ≈ 1 / 60.0
    @test get_conversion_factor("minute", "s") ≈ 60.0

    @test get_conversion_factor("minute", "hour") ≈ 1 / 60.0
    @test get_conversion_factor("hour", "minute") ≈ 60.0

    @test get_conversion_factor("hour", "day") ≈ 1 / 24.0
    @test get_conversion_factor("day", "hour") ≈ 24.0

    @test get_conversion_factor("day", "week") ≈ 1 / 7.0
    @test get_conversion_factor("week", "day") ≈ 7.0
end
end