function test_convert_unit(from_unit::String, to_unit::String, factor::Number)
    @testset "$from_unit and $to_unit" begin
        @test convert_unit(from_unit, to_unit) ≈ factor rtol = 1e-4
        @test convert_unit(to_unit, from_unit) ≈ 1 / factor rtol = 1e-4
    end
    return nothing
end