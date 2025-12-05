module TestAll

using Test
using UnitConverter

include("util.jl")

@testset "All" begin
    test_convert_unit("km", "m", 1000)
    test_convert_unit("mile", "km", 1.609344)
    test_convert_unit("km/hour", "m/s", 0.27777778)
    test_convert_unit("hm3", "MWh * ((m3/s)/ MW) * ((hm3/hour)/(m3/s))", 1)
    test_convert_unit("k\$", "\$", 1000)
    test_convert_unit("m3/s", "hm3/hour", 0.0036)
    test_convert_unit("hm3", "MWh * ((m3/s)/ MW) * ((hm3/hour)/(m3/s))", 1)
    test_convert_unit("1/GWh", "1/MWh", 0.001)
    test_convert_unit("mi/hour", "m/s", 0.44704)
    test_convert_unit("(m3/s)*(hour)", "hm3", 0.0036)
    test_convert_unit("", "%", 100)
    test_convert_unit("(\$/MWh)/(\$/MWh)", "", 1)
    test_convert_unit("(gal/MWh)*(\$/gal)", "\$/MWh", 1)
    test_convert_unit("(GWh)*(\$/MWh)", "k\$", 1)
    test_convert_unit("\$/MWh", "\$/GWh", 1000)
    test_convert_unit("GWh", "MW * hour", 1000)
    test_convert_unit("kgal", "hm3", 3.7854118e-06)
    test_convert_unit("GWh / hour", "(m3/s)*(MW/(m3/s))", 1000)
    test_convert_unit("GWh", "MW * hour", 1000)
    test_convert_unit("GWh/MW/hour", "%", 100000)
end

end
