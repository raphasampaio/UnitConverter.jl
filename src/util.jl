function get_factor()
    a = run(`units.exe -1 --compact "km/hour" "m/s"`)
    @show a
end
