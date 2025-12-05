function test_convert_unit(from_unit::String, to_unit::String, factor::Number)
    @testset "$from_unit and $to_unit" begin
        @test convert_unit(from_unit, to_unit) ≈ factor
        @test convert_unit(to_unit, from_unit) ≈ 1 / factor
    end
    return nothing
end