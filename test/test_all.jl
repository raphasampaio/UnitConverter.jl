module TestAll

using Test
using UnitConverter

function test_convert_unit(from_unit::String, to_unit::String, factor::Number)
    @testset "$from_unit and $to_unit" begin
        @test convert_unit(from_unit, to_unit) ≈ factor
        @test convert_unit(to_unit, from_unit) ≈ 1 / factor
    end
    return nothing
end

@testset "All" begin
    test_convert_unit("(m3/s)*(hour)", "hm3", 0.003600)
    test_convert_unit("", "%", 100.0)
    test_convert_unit("(\$/MWh)/(\$/MWh)", "", 1.0)
    test_convert_unit("(gal/MWh)*(\$/gal)", "\$/MWh", 1.0)
    test_convert_unit("(GWh)*(\$/MWh)", "k\$", 1.0)
    test_convert_unit("\$/MWh", "\$/GWh", 1000.0)
    test_convert_unit("GWh", "MW * hour", 1000.0)
    test_convert_unit("kgal", "hm3", 3.7854118e-06)
    test_convert_unit("GWh / hour", "(m3/s)*(MW/(m3/s))", 1000.0)
    test_convert_unit("GWh", "MW * hour", 1000.0)
    test_convert_unit("GWh/MW/hour", "%", 100000.0)

    test_convert_unit("degC", "degF", 1.8)
    test_convert_unit("degF", "degC", 0.55555556)

    test_convert_unit("m", "cm", 100)
    test_convert_unit("km", "m", 1000)
    test_convert_unit("km", "cm", 100000)

    test_convert_unit("in", "cm", 2.54)

    test_convert_unit("ft", "m", 0.3048)

    test_convert_unit("yd", "m", 0.9144)

    test_convert_unit("mi", "km", 1.60934)

    test_convert_unit("kg", "g", 1000)

    test_convert_unit("lb", "kg", 0.45359237)
    test_convert_unit("oz", "g", 28.349523125)

    test_convert_unit("m/s", "km/h", 3.6)

    test_convert_unit("rad", "deg", 180 / pi)

    test_convert_unit("L", "ml", 1000)

    test_convert_unit("hr", "min", 60)

    test_convert_unit("m^2", "cm^2", 10000)

    test_convert_unit("m^3", "cm^3", 1000000)

    test_convert_unit("kPa", "Pa", 1000)

    test_convert_unit("kJ", "J", 1000)

    test_convert_unit("kW", "W", 1000)

    test_convert_unit("N", "kg*m/s^2", 1)
    test_convert_unit("J", "N*m", 1)
    test_convert_unit("W", "J/s", 1)
    test_convert_unit("Pa", "N/m^2", 1)

    test_convert_unit("mm", "km", 1e-06)
    test_convert_unit("mg", "kg", 1e-06)
    test_convert_unit("μs", "ms", 0.001)
    test_convert_unit("Tm", "Gm", 1000)
    test_convert_unit("Tm", "Mm", 1000000)
    test_convert_unit("Tm", "km", 1e+09)
    test_convert_unit("Tm", "hm", 1e+10)
    test_convert_unit("Tm", "dam", 1e+11)
    test_convert_unit("Tm", "dm", 1e+13)
    test_convert_unit("Tm", "cm", 1e+14)
    test_convert_unit("Tm", "mm", 1e+15)
    test_convert_unit("Tm", "μm", 1e+18)
    test_convert_unit("Tm", "nm", 1e+21)
    test_convert_unit("Tm", "pm", 1e+24)
    test_convert_unit("Gm", "Tm", 0.001)
    test_convert_unit("Gm", "Mm", 1000)
    test_convert_unit("Gm", "km", 1000000)
    test_convert_unit("Gm", "hm", 10000000)
    test_convert_unit("Gm", "dam", 1e+08)
    test_convert_unit("Gm", "dm", 1e+10)
    test_convert_unit("Gm", "cm", 1e+11)
    test_convert_unit("Gm", "mm", 1e+12)
    test_convert_unit("Gm", "μm", 1e+15)
    test_convert_unit("Gm", "nm", 1e+18)
    test_convert_unit("Gm", "pm", 1e+21)
    test_convert_unit("Mm", "Tm", 1e-06)
    test_convert_unit("Mm", "Gm", 0.001)
    test_convert_unit("Mm", "km", 1000)
    test_convert_unit("Mm", "hm", 10000)
    test_convert_unit("Mm", "dam", 100000)
    test_convert_unit("Mm", "dm", 10000000)
    test_convert_unit("Mm", "cm", 1e+08)
    test_convert_unit("Mm", "mm", 1e+09)
    test_convert_unit("Mm", "μm", 1e+12)
    test_convert_unit("Mm", "nm", 1e+15)
    test_convert_unit("Mm", "pm", 1e+18)
    test_convert_unit("km", "Tm", 1e-09)
    test_convert_unit("km", "Gm", 1e-06)
    test_convert_unit("km", "Mm", 0.001)
    test_convert_unit("km", "hm", 10)
    test_convert_unit("km", "dam", 100)
    test_convert_unit("km", "dm", 10000)
    test_convert_unit("km", "cm", 100000)
    test_convert_unit("km", "mm", 1000000)
    test_convert_unit("km", "μm", 1e+09)
    test_convert_unit("km", "nm", 1e+12)
    test_convert_unit("km", "pm", 1e+15)
    test_convert_unit("hm", "Tm", 1e-10)
    test_convert_unit("hm", "Gm", 1e-07)
    test_convert_unit("hm", "Mm", 0.0001)
    test_convert_unit("hm", "km", 0.1)
    test_convert_unit("hm", "dam", 10)
    test_convert_unit("hm", "dm", 1000)
    test_convert_unit("hm", "cm", 10000)
    test_convert_unit("hm", "mm", 100000)
    test_convert_unit("hm", "μm", 1e+08)
    test_convert_unit("hm", "nm", 1e+11)
    test_convert_unit("hm", "pm", 1e+14)
    test_convert_unit("dam", "Tm", 1e-11)
    test_convert_unit("dam", "Gm", 1e-08)
    test_convert_unit("dam", "Mm", 1e-05)
    test_convert_unit("dam", "km", 0.01)
    test_convert_unit("dam", "hm", 0.1)
    test_convert_unit("dam", "dm", 100)
    test_convert_unit("dam", "cm", 1000)
    test_convert_unit("dam", "mm", 10000)
    test_convert_unit("dam", "μm", 10000000)
    test_convert_unit("dam", "nm", 1e+10)
    test_convert_unit("dam", "pm", 1e+13)
    test_convert_unit("dm", "Tm", 1e-13)
    test_convert_unit("dm", "Gm", 1e-10)
    test_convert_unit("dm", "Mm", 1e-07)
    test_convert_unit("dm", "km", 0.0001)
    test_convert_unit("dm", "hm", 0.001)
    test_convert_unit("dm", "dam", 0.01)
    test_convert_unit("dm", "cm", 10)
    test_convert_unit("dm", "mm", 100)
    test_convert_unit("dm", "μm", 100000)
    test_convert_unit("dm", "nm", 1e+08)
    test_convert_unit("dm", "pm", 1e+11)
    test_convert_unit("cm", "Tm", 1e-14)
    test_convert_unit("cm", "Gm", 1e-11)
    test_convert_unit("cm", "Mm", 1e-08)
    test_convert_unit("cm", "km", 1e-05)
    test_convert_unit("cm", "hm", 0.0001)
    test_convert_unit("cm", "dam", 0.001)
    test_convert_unit("cm", "dm", 0.1)
    test_convert_unit("cm", "mm", 10)
    test_convert_unit("cm", "μm", 10000)
    test_convert_unit("cm", "nm", 10000000)
    test_convert_unit("cm", "pm", 1e+10)
    test_convert_unit("mm", "Tm", 1e-15)
    test_convert_unit("mm", "Gm", 1e-12)
    test_convert_unit("mm", "Mm", 1e-09)
    test_convert_unit("mm", "km", 1e-06)
    test_convert_unit("mm", "hm", 1e-05)
    test_convert_unit("mm", "dam", 0.0001)
    test_convert_unit("mm", "dm", 0.01)
    test_convert_unit("mm", "cm", 0.1)
    test_convert_unit("mm", "μm", 1000)
    test_convert_unit("mm", "nm", 1000000)
    test_convert_unit("mm", "pm", 1e+09)
    test_convert_unit("μm", "Tm", 1e-18)
    test_convert_unit("μm", "Gm", 1e-15)
    test_convert_unit("μm", "Mm", 1e-12)
    test_convert_unit("μm", "km", 1e-09)
    test_convert_unit("μm", "hm", 1e-08)
    test_convert_unit("μm", "dam", 1e-07)
    test_convert_unit("μm", "dm", 1e-05)
    test_convert_unit("μm", "cm", 0.0001)
    test_convert_unit("μm", "mm", 0.001)
    test_convert_unit("μm", "nm", 1000)
    test_convert_unit("μm", "pm", 1000000)
    test_convert_unit("nm", "Tm", 1e-21)
    test_convert_unit("nm", "Gm", 1e-18)
    test_convert_unit("nm", "Mm", 1e-15)
    test_convert_unit("nm", "km", 1e-12)
    test_convert_unit("nm", "hm", 1e-11)
    test_convert_unit("nm", "dam", 1e-10)
    test_convert_unit("nm", "dm", 1e-08)
    test_convert_unit("nm", "cm", 1e-07)
    test_convert_unit("nm", "mm", 1e-06)
    test_convert_unit("nm", "μm", 0.001)
    test_convert_unit("nm", "pm", 1000)
    test_convert_unit("pm", "Tm", 1e-24)
    test_convert_unit("pm", "Gm", 1e-21)
    test_convert_unit("pm", "Mm", 1e-18)
    test_convert_unit("pm", "km", 1e-15)
    test_convert_unit("pm", "hm", 1e-14)
    test_convert_unit("pm", "dam", 1e-13)
    test_convert_unit("pm", "dm", 1e-11)
    test_convert_unit("pm", "cm", 1e-10)
    test_convert_unit("pm", "mm", 1e-09)
    test_convert_unit("pm", "μm", 1e-06)
    test_convert_unit("pm", "nm", 0.001)
    test_convert_unit("Tg", "Gg", 1000)
    test_convert_unit("Tg", "Mg", 1000000)
    test_convert_unit("Tg", "kg", 1e+09)
    test_convert_unit("Tg", "dag", 1e+11)
    test_convert_unit("Tg", "dg", 1e+13)
    test_convert_unit("Tg", "cg", 1e+14)
    test_convert_unit("Tg", "mg", 1e+15)
    test_convert_unit("Tg", "μg", 1e+18)
    test_convert_unit("Tg", "ng", 1e+21)
    test_convert_unit("Tg", "pg", 1e+24)
    test_convert_unit("Gg", "Tg", 0.001)
    test_convert_unit("Gg", "Mg", 1000)
    test_convert_unit("Gg", "kg", 1000000)
    test_convert_unit("Gg", "dag", 1e+08)
    test_convert_unit("Gg", "dg", 1e+10)
    test_convert_unit("Gg", "cg", 1e+11)
    test_convert_unit("Gg", "mg", 1e+12)
    test_convert_unit("Gg", "μg", 1e+15)
    test_convert_unit("Gg", "ng", 1e+18)
    test_convert_unit("Gg", "pg", 1e+21)
    test_convert_unit("Mg", "Tg", 1e-06)
    test_convert_unit("Mg", "Gg", 0.001)
    test_convert_unit("Mg", "kg", 1000)
    test_convert_unit("Mg", "dag", 100000)
    test_convert_unit("Mg", "dg", 10000000)
    test_convert_unit("Mg", "cg", 1e+08)
    test_convert_unit("Mg", "mg", 1e+09)
    test_convert_unit("Mg", "μg", 1e+12)
    test_convert_unit("Mg", "ng", 1e+15)
    test_convert_unit("Mg", "pg", 1e+18)
    test_convert_unit("kg", "Tg", 1e-09)
    test_convert_unit("kg", "Gg", 1e-06)
    test_convert_unit("kg", "Mg", 0.001)
    test_convert_unit("kg", "dag", 100)
    test_convert_unit("kg", "dg", 10000)
    test_convert_unit("kg", "cg", 100000)
    test_convert_unit("kg", "mg", 1000000)
    test_convert_unit("kg", "μg", 1e+09)
    test_convert_unit("kg", "ng", 1e+12)
    test_convert_unit("kg", "pg", 1e+15)
    test_convert_unit("dag", "Tg", 1e-11)
    test_convert_unit("dag", "Gg", 1e-08)
    test_convert_unit("dag", "Mg", 1e-05)
    test_convert_unit("dag", "kg", 0.01)
    test_convert_unit("dag", "dg", 100)
    test_convert_unit("dag", "cg", 1000)
    test_convert_unit("dag", "mg", 10000)
    test_convert_unit("dag", "μg", 10000000)
    test_convert_unit("dag", "ng", 1e+10)
    test_convert_unit("dag", "pg", 1e+13)
    test_convert_unit("dg", "Tg", 1e-13)
    test_convert_unit("dg", "Gg", 1e-10)
    test_convert_unit("dg", "Mg", 1e-07)
    test_convert_unit("dg", "kg", 0.0001)
    test_convert_unit("dg", "dag", 0.01)
    test_convert_unit("dg", "cg", 10)
    test_convert_unit("dg", "mg", 100)
    test_convert_unit("dg", "μg", 100000)
    test_convert_unit("dg", "ng", 1e+08)
    test_convert_unit("dg", "pg", 1e+11)
    test_convert_unit("cg", "Tg", 1e-14)
    test_convert_unit("cg", "Gg", 1e-11)
    test_convert_unit("cg", "Mg", 1e-08)
    test_convert_unit("cg", "kg", 1e-05)
    test_convert_unit("cg", "dag", 0.001)
    test_convert_unit("cg", "dg", 0.1)
    test_convert_unit("cg", "mg", 10)
    test_convert_unit("cg", "μg", 10000)
    test_convert_unit("cg", "ng", 10000000)
    test_convert_unit("cg", "pg", 1e+10)
    test_convert_unit("mg", "Tg", 1e-15)
    test_convert_unit("mg", "Gg", 1e-12)
    test_convert_unit("mg", "Mg", 1e-09)
    test_convert_unit("mg", "kg", 1e-06)
    test_convert_unit("mg", "dag", 0.0001)
    test_convert_unit("mg", "dg", 0.01)
    test_convert_unit("mg", "cg", 0.1)
    test_convert_unit("mg", "μg", 1000)
    test_convert_unit("mg", "ng", 1000000)
    test_convert_unit("mg", "pg", 1e+09)
    test_convert_unit("μg", "Tg", 1e-18)
    test_convert_unit("μg", "Gg", 1e-15)
    test_convert_unit("μg", "Mg", 1e-12)
    test_convert_unit("μg", "kg", 1e-09)
    test_convert_unit("μg", "dag", 1e-07)
    test_convert_unit("μg", "dg", 1e-05)
    test_convert_unit("μg", "cg", 0.0001)
    test_convert_unit("μg", "mg", 0.001)
    test_convert_unit("μg", "ng", 1000)
    test_convert_unit("μg", "pg", 1000000)
    test_convert_unit("ng", "Tg", 1e-21)
    test_convert_unit("ng", "Gg", 1e-18)
    test_convert_unit("ng", "Mg", 1e-15)
    test_convert_unit("ng", "kg", 1e-12)
    test_convert_unit("ng", "dag", 1e-10)
    test_convert_unit("ng", "dg", 1e-08)
    test_convert_unit("ng", "cg", 1e-07)
    test_convert_unit("ng", "mg", 1e-06)
    test_convert_unit("ng", "μg", 0.001)
    test_convert_unit("ng", "pg", 1000)
    test_convert_unit("pg", "Tg", 1e-24)
    test_convert_unit("pg", "Gg", 1e-21)
    test_convert_unit("pg", "Mg", 1e-18)
    test_convert_unit("pg", "kg", 1e-15)
    test_convert_unit("pg", "dag", 1e-13)
    test_convert_unit("pg", "dg", 1e-11)
    test_convert_unit("pg", "cg", 1e-10)
    test_convert_unit("pg", "mg", 1e-09)
    test_convert_unit("pg", "μg", 1e-06)
    test_convert_unit("pg", "ng", 0.001)
    test_convert_unit("Ts", "Ms", 1000000)
    test_convert_unit("Ts", "ks", 1e+09)
    test_convert_unit("Ts", "hs", 1e+10)
    test_convert_unit("Ts", "das", 11574074)
    test_convert_unit("Ts", "ds", 1e+13)
    test_convert_unit("Ts", "cs", 1e+14)
    test_convert_unit("Ts", "ms", 1e+15)
    test_convert_unit("Ts", "μs", 1e+18)
    test_convert_unit("Ts", "ns", 1e+21)
    test_convert_unit("Ts", "ps", 1e+24)
    test_convert_unit("Ms", "Ts", 1e-06)
    test_convert_unit("Ms", "ks", 1000)
    test_convert_unit("Ms", "hs", 10000)
    test_convert_unit("Ms", "das", 11.574074)
    test_convert_unit("Ms", "ds", 10000000)
    test_convert_unit("Ms", "cs", 1e+08)
    test_convert_unit("Ms", "ms", 1e+09)
    test_convert_unit("Ms", "μs", 1e+12)
    test_convert_unit("Ms", "ns", 1e+15)
    test_convert_unit("Ms", "ps", 1e+18)
    test_convert_unit("ks", "Ts", 1e-09)
    test_convert_unit("ks", "Ms", 0.001)
    test_convert_unit("ks", "hs", 10)
    test_convert_unit("ks", "das", 0.011574074)
    test_convert_unit("ks", "ds", 10000)
    test_convert_unit("ks", "cs", 100000)
    test_convert_unit("ks", "ms", 1000000)
    test_convert_unit("ks", "μs", 1e+09)
    test_convert_unit("ks", "ns", 1e+12)
    test_convert_unit("ks", "ps", 1e+15)
    test_convert_unit("hs", "Ts", 1e-10)
    test_convert_unit("hs", "Ms", 0.0001)
    test_convert_unit("hs", "ks", 0.1)
    test_convert_unit("hs", "das", 0.0011574074)
    test_convert_unit("hs", "ds", 1000)
    test_convert_unit("hs", "cs", 10000)
    test_convert_unit("hs", "ms", 100000)
    test_convert_unit("hs", "μs", 1e+08)
    test_convert_unit("hs", "ns", 1e+11)
    test_convert_unit("hs", "ps", 1e+14)
    test_convert_unit("das", "Ts", 8.64e-08)
    test_convert_unit("das", "Ms", 0.0864)
    test_convert_unit("das", "ks", 86.4)
    test_convert_unit("das", "hs", 864)
    test_convert_unit("das", "ds", 864000)
    test_convert_unit("das", "cs", 8640000)
    test_convert_unit("das", "ms", 86400000)
    test_convert_unit("das", "μs", 8.64e+10)
    test_convert_unit("das", "ns", 8.64e+13)
    test_convert_unit("das", "ps", 8.64e+16)
    test_convert_unit("ds", "Ts", 1e-13)
    test_convert_unit("ds", "Ms", 1e-07)
    test_convert_unit("ds", "ks", 0.0001)
    test_convert_unit("ds", "hs", 0.001)
    test_convert_unit("ds", "das", 1.1574074e-06)
    test_convert_unit("ds", "cs", 10)
    test_convert_unit("ds", "ms", 100)
    test_convert_unit("ds", "μs", 100000)
    test_convert_unit("ds", "ns", 1e+08)
    test_convert_unit("ds", "ps", 1e+11)
    test_convert_unit("cs", "Ts", 1e-14)
    test_convert_unit("cs", "Ms", 1e-08)
    test_convert_unit("cs", "ks", 1e-05)
    test_convert_unit("cs", "hs", 0.0001)
    test_convert_unit("cs", "das", 1.1574074e-07)
    test_convert_unit("cs", "ds", 0.1)
    test_convert_unit("cs", "ms", 10)
    test_convert_unit("cs", "μs", 10000)
    test_convert_unit("cs", "ns", 10000000)
    test_convert_unit("cs", "ps", 1e+10)
    test_convert_unit("ms", "Ts", 1e-15)
    test_convert_unit("ms", "Ms", 1e-09)
    test_convert_unit("ms", "ks", 1e-06)
    test_convert_unit("ms", "hs", 1e-05)
    test_convert_unit("ms", "das", 1.1574074e-08)
    test_convert_unit("ms", "ds", 0.01)
    test_convert_unit("ms", "cs", 0.1)
    test_convert_unit("ms", "μs", 1000)
    test_convert_unit("ms", "ns", 1000000)
    test_convert_unit("ms", "ps", 1e+09)
    test_convert_unit("μs", "Ts", 1e-18)
    test_convert_unit("μs", "Ms", 1e-12)
    test_convert_unit("μs", "ks", 1e-09)
    test_convert_unit("μs", "hs", 1e-08)
    test_convert_unit("μs", "das", 1.1574074e-11)
    test_convert_unit("μs", "ds", 1e-05)
    test_convert_unit("μs", "cs", 0.0001)
    test_convert_unit("μs", "ms", 0.001)
    test_convert_unit("μs", "ns", 1000)
    test_convert_unit("μs", "ps", 1000000)
    test_convert_unit("ns", "Ts", 1e-21)
    test_convert_unit("ns", "Ms", 1e-15)
    test_convert_unit("ns", "ks", 1e-12)
    test_convert_unit("ns", "hs", 1e-11)
    test_convert_unit("ns", "das", 1.1574074e-14)
    test_convert_unit("ns", "ds", 1e-08)
    test_convert_unit("ns", "cs", 1e-07)
    test_convert_unit("ns", "ms", 1e-06)
    test_convert_unit("ns", "μs", 0.001)
    test_convert_unit("ns", "ps", 1000)
    test_convert_unit("ps", "Ts", 1e-24)
    test_convert_unit("ps", "Ms", 1e-18)
    test_convert_unit("ps", "ks", 1e-15)
    test_convert_unit("ps", "hs", 1e-14)
    test_convert_unit("ps", "das", 1.1574074e-17)
    test_convert_unit("ps", "ds", 1e-11)
    test_convert_unit("ps", "cs", 1e-10)
    test_convert_unit("ps", "ms", 1e-09)
    test_convert_unit("ps", "μs", 1e-06)
    test_convert_unit("ps", "ns", 0.001)
    test_convert_unit("TL", "GL", 1000)
    test_convert_unit("TL", "ML", 1000000)
    test_convert_unit("TL", "kL", 1e+09)
    test_convert_unit("TL", "hL", 1e+10)
    test_convert_unit("TL", "daL", 1e+11)
    test_convert_unit("TL", "dL", 1e+13)
    test_convert_unit("TL", "cL", 1e+14)
    test_convert_unit("TL", "mL", 1e+15)
    test_convert_unit("TL", "μL", 1e+18)
    test_convert_unit("TL", "nL", 1e+21)
    test_convert_unit("TL", "pL", 1e+24)
    test_convert_unit("GL", "TL", 0.001)
    test_convert_unit("GL", "ML", 1000)
    test_convert_unit("GL", "kL", 1000000)
    test_convert_unit("GL", "hL", 10000000)
    test_convert_unit("GL", "daL", 1e+08)
    test_convert_unit("GL", "dL", 1e+10)
    test_convert_unit("GL", "cL", 1e+11)
    test_convert_unit("GL", "mL", 1e+12)
    test_convert_unit("GL", "μL", 1e+15)
    test_convert_unit("GL", "nL", 1e+18)
    test_convert_unit("GL", "pL", 1e+21)
    test_convert_unit("ML", "TL", 1e-06)
    test_convert_unit("ML", "GL", 0.001)
    test_convert_unit("ML", "kL", 1000)
    test_convert_unit("ML", "hL", 10000)
    test_convert_unit("ML", "daL", 100000)
    test_convert_unit("ML", "dL", 10000000)
    test_convert_unit("ML", "cL", 1e+08)
    test_convert_unit("ML", "mL", 1e+09)
    test_convert_unit("ML", "μL", 1e+12)
    test_convert_unit("ML", "nL", 1e+15)
    test_convert_unit("ML", "pL", 1e+18)
    test_convert_unit("kL", "TL", 1e-09)
    test_convert_unit("kL", "GL", 1e-06)
    test_convert_unit("kL", "ML", 0.001)
    test_convert_unit("kL", "hL", 10)
    test_convert_unit("kL", "daL", 100)
    test_convert_unit("kL", "dL", 10000)
    test_convert_unit("kL", "cL", 100000)
    test_convert_unit("kL", "mL", 1000000)
    test_convert_unit("kL", "μL", 1e+09)
    test_convert_unit("kL", "nL", 1e+12)
    test_convert_unit("kL", "pL", 1e+15)
    test_convert_unit("hL", "TL", 1e-10)
    test_convert_unit("hL", "GL", 1e-07)
    test_convert_unit("hL", "ML", 0.0001)
    test_convert_unit("hL", "kL", 0.1)
    test_convert_unit("hL", "daL", 10)
    test_convert_unit("hL", "dL", 1000)
    test_convert_unit("hL", "cL", 10000)
    test_convert_unit("hL", "mL", 100000)
    test_convert_unit("hL", "μL", 1e+08)
    test_convert_unit("hL", "nL", 1e+11)
    test_convert_unit("hL", "pL", 1e+14)
    test_convert_unit("daL", "TL", 1e-11)
    test_convert_unit("daL", "GL", 1e-08)
    test_convert_unit("daL", "ML", 1e-05)
    test_convert_unit("daL", "kL", 0.01)
    test_convert_unit("daL", "hL", 0.1)
    test_convert_unit("daL", "dL", 100)
    test_convert_unit("daL", "cL", 1000)
    test_convert_unit("daL", "mL", 10000)
    test_convert_unit("daL", "μL", 10000000)
    test_convert_unit("daL", "nL", 1e+10)
    test_convert_unit("daL", "pL", 1e+13)
    test_convert_unit("dL", "TL", 1e-13)
    test_convert_unit("dL", "GL", 1e-10)
    test_convert_unit("dL", "ML", 1e-07)
    test_convert_unit("dL", "kL", 0.0001)
    test_convert_unit("dL", "hL", 0.001)
    test_convert_unit("dL", "daL", 0.01)
    test_convert_unit("dL", "cL", 10)
    test_convert_unit("dL", "mL", 100)
    test_convert_unit("dL", "μL", 100000)
    test_convert_unit("dL", "nL", 1e+08)
    test_convert_unit("dL", "pL", 1e+11)
    test_convert_unit("cL", "TL", 1e-14)
    test_convert_unit("cL", "GL", 1e-11)
    test_convert_unit("cL", "ML", 1e-08)
    test_convert_unit("cL", "kL", 1e-05)
    test_convert_unit("cL", "hL", 0.0001)
    test_convert_unit("cL", "daL", 0.001)
    test_convert_unit("cL", "dL", 0.1)
    test_convert_unit("cL", "mL", 10)
    test_convert_unit("cL", "μL", 10000)
    test_convert_unit("cL", "nL", 10000000)
    test_convert_unit("cL", "pL", 1e+10)
    test_convert_unit("mL", "TL", 1e-15)
    test_convert_unit("mL", "GL", 1e-12)
    test_convert_unit("mL", "ML", 1e-09)
    test_convert_unit("mL", "kL", 1e-06)
    test_convert_unit("mL", "hL", 1e-05)
    test_convert_unit("mL", "daL", 0.0001)
    test_convert_unit("mL", "dL", 0.01)
    test_convert_unit("mL", "cL", 0.1)
    test_convert_unit("mL", "μL", 1000)
    test_convert_unit("mL", "nL", 1000000)
    test_convert_unit("mL", "pL", 1e+09)
    test_convert_unit("μL", "TL", 1e-18)
    test_convert_unit("μL", "GL", 1e-15)
    test_convert_unit("μL", "ML", 1e-12)
    test_convert_unit("μL", "kL", 1e-09)
    test_convert_unit("μL", "hL", 1e-08)
    test_convert_unit("μL", "daL", 1e-07)
    test_convert_unit("μL", "dL", 1e-05)
    test_convert_unit("μL", "cL", 0.0001)
    test_convert_unit("μL", "mL", 0.001)
    test_convert_unit("μL", "nL", 1000)
    test_convert_unit("μL", "pL", 1000000)
    test_convert_unit("nL", "TL", 1e-21)
    test_convert_unit("nL", "GL", 1e-18)
    test_convert_unit("nL", "ML", 1e-15)
    test_convert_unit("nL", "kL", 1e-12)
    test_convert_unit("nL", "hL", 1e-11)
    test_convert_unit("nL", "daL", 1e-10)
    test_convert_unit("nL", "dL", 1e-08)
    test_convert_unit("nL", "cL", 1e-07)
    test_convert_unit("nL", "mL", 1e-06)
    test_convert_unit("nL", "μL", 0.001)
    test_convert_unit("nL", "pL", 1000)
    test_convert_unit("pL", "TL", 1e-24)
    test_convert_unit("pL", "GL", 1e-21)
    test_convert_unit("pL", "ML", 1e-18)
    test_convert_unit("pL", "kL", 1e-15)
    test_convert_unit("pL", "hL", 1e-14)
    test_convert_unit("pL", "daL", 1e-13)
    test_convert_unit("pL", "dL", 1e-11)
    test_convert_unit("pL", "cL", 1e-10)
    test_convert_unit("pL", "mL", 1e-09)
    test_convert_unit("pL", "μL", 1e-06)
    test_convert_unit("pL", "nL", 0.001)
    test_convert_unit("TJ", "GJ", 1000)
    test_convert_unit("TJ", "MJ", 1000000)
    test_convert_unit("TJ", "kJ", 1e+09)
    test_convert_unit("TJ", "hJ", 1e+10)
    test_convert_unit("TJ", "daJ", 1e+11)
    test_convert_unit("TJ", "dJ", 1e+13)
    test_convert_unit("TJ", "cJ", 1e+14)
    test_convert_unit("TJ", "mJ", 1e+15)
    test_convert_unit("TJ", "μJ", 1e+18)
    test_convert_unit("TJ", "nJ", 1e+21)
    test_convert_unit("TJ", "pJ", 1e+24)
    test_convert_unit("GJ", "TJ", 0.001)
    test_convert_unit("GJ", "MJ", 1000)
    test_convert_unit("GJ", "kJ", 1000000)
    test_convert_unit("GJ", "hJ", 10000000)
    test_convert_unit("GJ", "daJ", 1e+08)
    test_convert_unit("GJ", "dJ", 1e+10)
    test_convert_unit("GJ", "cJ", 1e+11)
    test_convert_unit("GJ", "mJ", 1e+12)
    test_convert_unit("GJ", "μJ", 1e+15)
    test_convert_unit("GJ", "nJ", 1e+18)
    test_convert_unit("GJ", "pJ", 1e+21)
    test_convert_unit("MJ", "TJ", 1e-06)
    test_convert_unit("MJ", "GJ", 0.001)
    test_convert_unit("MJ", "kJ", 1000)
    test_convert_unit("MJ", "hJ", 10000)
    test_convert_unit("MJ", "daJ", 100000)
    test_convert_unit("MJ", "dJ", 10000000)
    test_convert_unit("MJ", "cJ", 1e+08)
    test_convert_unit("MJ", "mJ", 1e+09)
    test_convert_unit("MJ", "μJ", 1e+12)
    test_convert_unit("MJ", "nJ", 1e+15)
    test_convert_unit("MJ", "pJ", 1e+18)
    test_convert_unit("kJ", "TJ", 1e-09)
    test_convert_unit("kJ", "GJ", 1e-06)
    test_convert_unit("kJ", "MJ", 0.001)
    test_convert_unit("kJ", "hJ", 10)
    test_convert_unit("kJ", "daJ", 100)
    test_convert_unit("kJ", "dJ", 10000)
    test_convert_unit("kJ", "cJ", 100000)
    test_convert_unit("kJ", "mJ", 1000000)
    test_convert_unit("kJ", "μJ", 1e+09)
    test_convert_unit("kJ", "nJ", 1e+12)
    test_convert_unit("kJ", "pJ", 1e+15)
    test_convert_unit("hJ", "TJ", 1e-10)
    test_convert_unit("hJ", "GJ", 1e-07)
    test_convert_unit("hJ", "MJ", 0.0001)
    test_convert_unit("hJ", "kJ", 0.1)
    test_convert_unit("hJ", "daJ", 10)
    test_convert_unit("hJ", "dJ", 1000)
    test_convert_unit("hJ", "cJ", 10000)
    test_convert_unit("hJ", "mJ", 100000)
    test_convert_unit("hJ", "μJ", 1e+08)
    test_convert_unit("hJ", "nJ", 1e+11)
    test_convert_unit("hJ", "pJ", 1e+14)
    test_convert_unit("daJ", "TJ", 1e-11)
    test_convert_unit("daJ", "GJ", 1e-08)
    test_convert_unit("daJ", "MJ", 1e-05)
    test_convert_unit("daJ", "kJ", 0.01)
    test_convert_unit("daJ", "hJ", 0.1)
    test_convert_unit("daJ", "dJ", 100)
    test_convert_unit("daJ", "cJ", 1000)
    test_convert_unit("daJ", "mJ", 10000)
    test_convert_unit("daJ", "μJ", 10000000)
    test_convert_unit("daJ", "nJ", 1e+10)
    test_convert_unit("daJ", "pJ", 1e+13)
    test_convert_unit("dJ", "TJ", 1e-13)
    test_convert_unit("dJ", "GJ", 1e-10)
    test_convert_unit("dJ", "MJ", 1e-07)
    test_convert_unit("dJ", "kJ", 0.0001)
    test_convert_unit("dJ", "hJ", 0.001)
    test_convert_unit("dJ", "daJ", 0.01)
    test_convert_unit("dJ", "cJ", 10)
    test_convert_unit("dJ", "mJ", 100)
    test_convert_unit("dJ", "μJ", 100000)
    test_convert_unit("dJ", "nJ", 1e+08)
    test_convert_unit("dJ", "pJ", 1e+11)
    test_convert_unit("cJ", "TJ", 1e-14)
    test_convert_unit("cJ", "GJ", 1e-11)
    test_convert_unit("cJ", "MJ", 1e-08)
    test_convert_unit("cJ", "kJ", 1e-05)
    test_convert_unit("cJ", "hJ", 0.0001)
    test_convert_unit("cJ", "daJ", 0.001)
    test_convert_unit("cJ", "dJ", 0.1)
    test_convert_unit("cJ", "mJ", 10)
    test_convert_unit("cJ", "μJ", 10000)
    test_convert_unit("cJ", "nJ", 10000000)
    test_convert_unit("cJ", "pJ", 1e+10)
    test_convert_unit("mJ", "TJ", 1e-15)
    test_convert_unit("mJ", "GJ", 1e-12)
    test_convert_unit("mJ", "MJ", 1e-09)
    test_convert_unit("mJ", "kJ", 1e-06)
    test_convert_unit("mJ", "hJ", 1e-05)
    test_convert_unit("mJ", "daJ", 0.0001)
    test_convert_unit("mJ", "dJ", 0.01)
    test_convert_unit("mJ", "cJ", 0.1)
    test_convert_unit("mJ", "μJ", 1000)
    test_convert_unit("mJ", "nJ", 1000000)
    test_convert_unit("mJ", "pJ", 1e+09)
    test_convert_unit("μJ", "TJ", 1e-18)
    test_convert_unit("μJ", "GJ", 1e-15)
    test_convert_unit("μJ", "MJ", 1e-12)
    test_convert_unit("μJ", "kJ", 1e-09)
    test_convert_unit("μJ", "hJ", 1e-08)
    test_convert_unit("μJ", "daJ", 1e-07)
    test_convert_unit("μJ", "dJ", 1e-05)
    test_convert_unit("μJ", "cJ", 0.0001)
    test_convert_unit("μJ", "mJ", 0.001)
    test_convert_unit("μJ", "nJ", 1000)
    test_convert_unit("μJ", "pJ", 1000000)
    test_convert_unit("nJ", "TJ", 1e-21)
    test_convert_unit("nJ", "GJ", 1e-18)
    test_convert_unit("nJ", "MJ", 1e-15)
    test_convert_unit("nJ", "kJ", 1e-12)
    test_convert_unit("nJ", "hJ", 1e-11)
    test_convert_unit("nJ", "daJ", 1e-10)
    test_convert_unit("nJ", "dJ", 1e-08)
    test_convert_unit("nJ", "cJ", 1e-07)
    test_convert_unit("nJ", "mJ", 1e-06)
    test_convert_unit("nJ", "μJ", 0.001)
    test_convert_unit("nJ", "pJ", 1000)
    test_convert_unit("pJ", "TJ", 1e-24)
    test_convert_unit("pJ", "GJ", 1e-21)
    test_convert_unit("pJ", "MJ", 1e-18)
    test_convert_unit("pJ", "kJ", 1e-15)
    test_convert_unit("pJ", "hJ", 1e-14)
    test_convert_unit("pJ", "daJ", 1e-13)
    test_convert_unit("pJ", "dJ", 1e-11)
    test_convert_unit("pJ", "cJ", 1e-10)
    test_convert_unit("pJ", "mJ", 1e-09)
    test_convert_unit("pJ", "μJ", 1e-06)
    test_convert_unit("pJ", "nJ", 0.001)
    test_convert_unit("TW", "GW", 1000)
    test_convert_unit("TW", "MW", 1000000)
    test_convert_unit("TW", "kW", 1e+09)
    test_convert_unit("TW", "hW", 1e+10)
    test_convert_unit("TW", "daW", 1e+11)
    test_convert_unit("TW", "dW", 1e+13)
    test_convert_unit("TW", "cW", 1e+14)
    test_convert_unit("TW", "mW", 1e+15)
    test_convert_unit("TW", "μW", 1e+18)
    test_convert_unit("TW", "nW", 1e+21)
    test_convert_unit("TW", "pW", 1e+24)
    test_convert_unit("GW", "TW", 0.001)
    test_convert_unit("GW", "MW", 1000)
    test_convert_unit("GW", "kW", 1000000)
    test_convert_unit("GW", "hW", 10000000)
    test_convert_unit("GW", "daW", 1e+08)
    test_convert_unit("GW", "dW", 1e+10)
    test_convert_unit("GW", "cW", 1e+11)
    test_convert_unit("GW", "mW", 1e+12)
    test_convert_unit("GW", "μW", 1e+15)
    test_convert_unit("GW", "nW", 1e+18)
    test_convert_unit("GW", "pW", 1e+21)
    test_convert_unit("MW", "TW", 1e-06)
    test_convert_unit("MW", "GW", 0.001)
    test_convert_unit("MW", "kW", 1000)
    test_convert_unit("MW", "hW", 10000)
    test_convert_unit("MW", "daW", 100000)
    test_convert_unit("MW", "dW", 10000000)
    test_convert_unit("MW", "cW", 1e+08)
    test_convert_unit("MW", "mW", 1e+09)
    test_convert_unit("MW", "μW", 1e+12)
    test_convert_unit("MW", "nW", 1e+15)
    test_convert_unit("MW", "pW", 1e+18)
    test_convert_unit("kW", "TW", 1e-09)
    test_convert_unit("kW", "GW", 1e-06)
    test_convert_unit("kW", "MW", 0.001)

    test_convert_unit("hm^3", "l", 1e+09)

    test_convert_unit("MW * h", "MWh", 1)
    test_convert_unit("MWh", "MW * h", 1)

    test_convert_unit("kW*h", "J", 3.6e6)

    test_convert_unit("N*m", "J", 1)
    test_convert_unit("J", "N*m", 1)

    test_convert_unit("kgf*m", "J", 9.80665)
    test_convert_unit("ft/s", "m/s", 0.3048)

    # test_convert_unit("lbf*ft", "J", 1.3558179483314 atol = 1e-6
    # test_convert_unit("J", "lbf*ft", 1 / 1.3558179483314 atol = 1e-6
    # test_convert_unit("m/s", "ft/s", 3.2808399 atol = 1e-6
    # test_convert_unit("km/h", "mi/h", 0.6213727366498069 atol = 1e-6
    # test_convert_unit("mi/h", "km/h", 1.609344 atol = 1e-5

    # test_convert_unit("m/s^2", "ft/s^2", 3.2808399 atol = 1e-6
    # test_convert_unit("ft/s^2", "m/s^2", 0.3048
    # test_convert_unit("kg/m^3", "lb/ft^3", 0.062427961 atol = 1e-8
    # test_convert_unit("kg/m^3", "g/cm^3", 0.001
    # test_convert_unit("lb/ft^3", "kg/m^3", 16.018463373960138 atol = 1e-6
    # test_convert_unit("lb/ft^3", "g/cm^3", 0.016018463373960138 atol = 1e-9
    # test_convert_unit("g/cm^3", "kg/m^3", 1000
    # test_convert_unit("g/cm^3", "lb/ft^3", 62.427961 atol = 1e-5
    # test_convert_unit("N/m^2", "lbf/in^2", 0.00014503774 atol = 1e-10
    # test_convert_unit("N/m^2", "atm", 9.8692327e-06 atol = 1e-12
    # test_convert_unit("N/m^2", "bar", 1e-05
    # test_convert_unit("N/m^2", "psi", 0.00014503774 atol = 1e-10
    # test_convert_unit("lbf/in^2", "N/m^2", 6894.7573
    # test_convert_unit("lbf/in^2", "atm", 0.068045964 atol = 1e-8
    # test_convert_unit("lbf/in^2", "bar", 0.068947573
    # test_convert_unit("lbf/in^2", "psi", 1
    # test_convert_unit("atm", "N/m^2", 101325
    # test_convert_unit("atm", "lbf/in^2", 14.695949 atol = 1e-5
    # test_convert_unit("atm", "bar", 1.01325
    # test_convert_unit("atm", "psi", 14.695949 atol = 1e-5
    # test_convert_unit("bar", "N/m^2", 100000
    # test_convert_unit("bar", "lbf/in^2", 14.503774 atol = 1e-5
    # test_convert_unit("bar", "atm", 0.98692327
    # test_convert_unit("bar", "psi", 14.503774 atol = 1e-5
    # test_convert_unit("psi", "N/m^2", 6894.7573
    # test_convert_unit("psi", "lbf/in^2", 1
    # test_convert_unit("psi", "atm", 0.068045964 atol = 1e-8
    # test_convert_unit("psi", "bar", 0.068947573
    # test_convert_unit("J/s", "hp", 0.0013410221 atol = 1e-9
    # test_convert_unit("J/s", "kW", 0.001
    # test_convert_unit("hp", "J/s", 745.69987
    # test_convert_unit("hp", "kW", 0.74569987
    # test_convert_unit("kW", "J/s", 1000
    # test_convert_unit("kW", "hp", 1.3410221 atol = 1e-6
    # test_convert_unit("N*s", "lbf*s", 0.2248089438709618 atol = 1e-8
    # test_convert_unit("lbf*s", "N*s", 4.4482216
    # test_convert_unit("deg/s", "rpm", 0.16666666666666669 atol = 1e-8
    # test_convert_unit("rpm", "deg/s", 6
end

@testset "Multiplication and Division Operations" begin
    # Basic multiplication tests
    @testset "Basic multiplications" begin
        # Force times distance = Energy
        @test convert_unit(1.0, "N*m", "J") ≈ 1.0
        @test convert_unit(1.0, "kg*m^2/s^2", "J") ≈ 1.0

        # Power times time = Energy
        @test convert_unit(1.0, "W*s", "J") ≈ 1.0
        @test convert_unit(1.0, "kW*h", "MJ") ≈ 3.6
        @test convert_unit(1.0, "MW*h", "GJ") ≈ 3.6

        # Density times volume = Mass
        @test convert_unit(1.0, "kg/m^3*m^3", "kg") ≈ 1.0
        @test convert_unit(1.0, "g/cm^3*cm^3", "g") ≈ 1.0

        # Velocity times time = Distance
        @test convert_unit(1.0, "m/s*s", "m") ≈ 1.0
        @test convert_unit(1.0, "km/h*h", "km") ≈ 1.0

        # Area times length = Volume
        @test convert_unit(1.0, "m^2*m", "m^3") ≈ 1.0
        @test convert_unit(1.0, "cm^2*cm", "cm^3") ≈ 1.0
    end

    @testset "Complex multiplications" begin
        # Pressure times area = Force
        @test convert_unit(1.0, "Pa*m^2", "N") ≈ 1.0
        @test convert_unit(1.0, "kPa*m^2", "N") ≈ 1000.0

        # Mass times acceleration = Force
        @test convert_unit(1.0, "kg*m/s^2", "N") ≈ 1.0

        # Flow rate times time = Volume
        @test convert_unit(1.0, "m^3/s*s", "m^3") ≈ 1.0
        @test convert_unit(1.0, "L/min*min", "L") ≈ 1.0

        # Power per unit area times area = Power
        @test convert_unit(1.0, "W/m^2*m^2", "W") ≈ 1.0

        # Specific energy times mass = Energy
        @test convert_unit(1.0, "J/kg*kg", "J") ≈ 1.0
    end

    @testset "Basic divisions" begin
        # Energy divided by time = Power
        @test convert_unit(1.0, "J/s", "W") ≈ 1.0
        @test convert_unit(1.0, "kJ/s", "kW") ≈ 1.0
        @test convert_unit(1.0, "MJ/h", "kW") ≈ 1000.0 / 3600.0

        # Distance divided by time = Velocity
        @test convert_unit(1.0, "m/s", "m/s") ≈ 1.0
        @test convert_unit(1.0, "km/h", "m/s") ≈ 1000.0 / 3600.0

        # Force divided by area = Pressure
        @test convert_unit(1.0, "N/m^2", "Pa") ≈ 1.0

        # Volume divided by area = Length
        @test convert_unit(1.0, "m^3/m^2", "m") ≈ 1.0
        @test convert_unit(1.0, "L/m^2", "mm") ≈ 1.0

        # Mass divided by volume = Density
        @test convert_unit(1.0, "kg/m^3", "kg/m^3") ≈ 1.0
        @test convert_unit(1.0, "g/cm^3", "kg/m^3") ≈ 1000.0
    end

    @testset "Complex divisions" begin
        # Energy per unit mass = Specific energy
        @test convert_unit(1.0, "J/kg", "J/kg") ≈ 1.0
        @test convert_unit(1.0, "kJ/kg", "J/g") ≈ 1.0

        # Power per unit area = Irradiance
        @test convert_unit(1.0, "W/m^2", "W/m^2") ≈ 1.0
        @test convert_unit(1.0, "kW/m^2", "W/cm^2") ≈ 0.1

        # Flow rate (volume per time)
        @test convert_unit(1.0, "m^3/s", "L/s") ≈ 1000.0
        @test convert_unit(1.0, "L/min", "m^3/h") ≈ 0.06

        # Angular velocity
        @test convert_unit(1.0, "rad/s", "deg/s") ≈ 180.0 / π

        # Acceleration
        @test convert_unit(1.0, "m/s^2", "m/s^2") ≈ 1.0
        @test convert_unit(1.0, "km/h^2", "m/s^2") ≈ (1000.0 / 3600.0^2)
    end

    @testset "Mixed multiplication and division" begin
        # Complex unit conversions with both operations
        @test convert_unit(1.0, "kg*m/s^2", "N") ≈ 1.0
        @test convert_unit(1.0, "N*m/s", "W") ≈ 1.0
        @test convert_unit(1.0, "J/m^3", "Pa") ≈ 1.0

        # Energy efficiency (dimensionless ratios)
        @test convert_unit(1.0, "J/J", "") ≈ 1.0
        @test convert_unit(1.0, "kWh/kWh", "%") ≈ 100.0

        # Flow coefficient
        @test convert_unit(1.0, "m^3/s/Pa", "m^3/s/kPa") ≈ 1000.0

        # Specific volume
        @test convert_unit(1.0, "m^3/kg", "L/g") ≈ 1.0

        # Momentum
        @test convert_unit(1.0, "kg*m/s", "kg*m/s") ≈ 1.0
        @test convert_unit(1.0, "kg*km/h", "kg*m/s") ≈ 1000.0 / 3600.0
    end

    @testset "Unit cancellation" begin
        # Units that should cancel out
        @test convert_unit(1.0, "m/m", "") ≈ 1.0
        @test convert_unit(1.0, "kg/kg", "") ≈ 1.0
        @test convert_unit(1.0, "s/s", "") ≈ 1.0

        # Partial cancellation
        @test convert_unit(1.0, "m^2/m", "m") ≈ 1.0
        @test convert_unit(1.0, "kg*m/kg", "m") ≈ 1.0
        @test convert_unit(1.0, "J*s/J", "s") ≈ 1.0
    end

    @testset "Practical engineering units" begin
        # Hydraulic flow with pressure drop
        @test convert_unit(1.0, "L/min", "m^3/h") ≈ 0.06
        @test convert_unit(1.0, "gal/min", "L/s") ≈ 3.7854118 / 60.0

        # Thermal power
        @test convert_unit(1.0, "kJ/s", "kW") ≈ 1.0
        @test convert_unit(1.0, "MJ/h", "kW") ≈ 1000.0 / 3600.0

        # Electrical units
        @test convert_unit(1.0, "W*h", "J") ≈ 3600.0
        @test convert_unit(1.0, "kW*h", "MJ") ≈ 3.6
        @test convert_unit(1.0, "MW*h", "GJ") ≈ 3.6

        # Fuel consumption
        @test convert_unit(1.0, "L/km", "L/km") ≈ 1.0
        @test convert_unit(1.0, "gal/mi", "L/km") ≈ 3.7854118 / 1.60934

        # Specific fuel consumption
        @test convert_unit(1.0, "g/kW/h", "kg/MW/h") ≈ 1.0
    end

    @testset "Dimensional consistency checks" begin
        # These should work (compatible dimensions)
        @test convert_unit(1.0, "N*m", "J") isa Float64
        @test convert_unit(1.0, "Pa*m^3", "J") isa Float64
        @test convert_unit(1.0, "W*s", "J") isa Float64

        # These should error (incompatible dimensions)
        @test_throws DimensionalMismatchError convert_unit(1.0, "m", "kg")
        @test_throws DimensionalMismatchError convert_unit(1.0, "J", "m")
        @test_throws DimensionalMismatchError convert_unit(1.0, "Pa", "kg")
        @test_throws DimensionalMismatchError convert_unit(1.0, "m*s", "kg")
    end
end

@testset "Custom Exception Types" begin
    @testset "DimensionalMismatchError" begin
        # Test that the exception is thrown
        @test_throws DimensionalMismatchError convert_unit(1.0, "m", "kg")

        # Test exception fields contain correct data
        try
            convert_unit(1.0, "m", "kg")
            @test false  # Should not reach here
        catch e
            @test e isa DimensionalMismatchError
            @test e.from_unit == "m"
            @test e.to_unit == "kg"
            @test e.from_dimensions == "m"
            @test e.to_dimensions == "kg"
        end

        # Test another dimensional mismatch
        try
            convert_unit(1.0, "J", "m^2")
            @test false
        catch e
            @test e isa DimensionalMismatchError
            @test e.from_unit == "J"
            @test e.to_unit == "m^2"
            @test occursin("kg", e.from_dimensions)
            @test occursin("m^2", e.to_dimensions)
        end

        # Test error message formatting
        try
            convert_unit(1.0, "Pa", "kg")
            @test false
        catch e
            msg = sprint(showerror, e)
            @test occursin("DimensionalMismatchError", msg)
            @test occursin("Cannot convert between incompatible units", msg)
            @test occursin("Pa", msg)
            @test occursin("kg", msg)
        end
    end

    @testset "UnknownUnitError" begin
        # Test that the exception is thrown for unknown units
        @test_throws UnknownUnitError convert_unit(1.0, "xyz", "m")
        @test_throws UnknownUnitError convert_unit(1.0, "m", "abc")

        # Test exception fields
        try
            convert_unit(1.0, "foobar", "m")
            @test false
        catch e
            @test e isa UnknownUnitError
            @test e.unit == "foobar"
        end

        # Test error message formatting
        try
            convert_unit(1.0, "unknownunit", "m")
            @test false
        catch e
            msg = sprint(showerror, e)
            @test occursin("UnknownUnitError", msg)
            @test occursin("Unknown unit", msg)
            @test occursin("unknownunit", msg)
        end

        # Test with compound expressions containing unknown units
        @test_throws UnknownUnitError convert_unit(1.0, "m*unknown", "m^2")
    end

    @testset "InvalidUnitSyntaxError" begin
        # Test invalid exponent syntax
        @test_throws InvalidUnitSyntaxError convert_unit(1.0, "m^^2", "m")
        @test_throws InvalidUnitSyntaxError convert_unit(1.0, "m^", "m")

        # Test exception fields for invalid exponent
        try
            convert_unit(1.0, "m^^3", "m")
            @test false
        catch e
            @test e isa InvalidUnitSyntaxError
            @test occursin("m^^3", e.unit_string)
            @test occursin("Exponent", e.reason)
        end

        # Test error message formatting
        try
            convert_unit(1.0, "kg^2^3", "kg")
            @test false
        catch e
            msg = sprint(showerror, e)
            @test occursin("InvalidUnitSyntaxError", msg)
            @test occursin("Invalid unit syntax", msg)
        end
    end

    @testset "Exception Hierarchy" begin
        # Verify all custom exceptions are subtypes of Exception
        @test DimensionalMismatchError <: Exception
        @test UnknownUnitError <: Exception
        @test InvalidUnitSyntaxError <: Exception
    end

    @testset "Programmatic Error Handling" begin
        # Test that specific exception types can be caught
        caught_dimensional = false
        try
            convert_unit(1.0, "m", "kg")
        catch e
            if e isa DimensionalMismatchError
                caught_dimensional = true
            end
        end
        @test caught_dimensional

        caught_unknown = false
        try
            convert_unit(1.0, "notaunit", "m")
        catch e
            if e isa UnknownUnitError
                caught_unknown = true
            end
        end
        @test caught_unknown

        caught_syntax = false
        try
            convert_unit(1.0, "m^^^2", "m")
        catch e
            if e isa InvalidUnitSyntaxError
                caught_syntax = true
            end
        end
        @test caught_syntax
    end
end

end
