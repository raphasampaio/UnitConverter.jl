function get_factor()
    a = run(`units.exe -1 --compact "km/h" "m/s"`)
    @show a
end
