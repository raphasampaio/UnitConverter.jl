module TestSimple

using UnitConverter

# --- Example 1: Your original request, resolved recursively ---
# day -> 24 * hour -> 24 * (60 * minute) -> 24 * 60 * (60 * s)
val_days = 2
val_seconds = convert_units(val_days, "day", "s")
println("✅ $val_days days is $val_seconds seconds.")

# --- Example 2: Complex imperial units ---
val_miles = 1
val_meters = convert_units(val_miles, "mile", "m")
println("✅ $val_miles mile is $val_meters meters.")

# --- Example 3: Adding a new definition at runtime ---
println("\n--- Dynamically adding a 'fortnight' ---")
add_definition!("fortnight", "14 day")

val_years = 1
val_fortnights = convert_units(val_years, "year", "fortnight")
println("✅ $val_years year is approximately $val_fortnights fortnights.")

# --- Example 4: Pressure (Pascals to PSI) ---
psi = convert_units(101325, "N/m^2", "pound/inch^2")
println("✅ 101325 Pascals is approximately $psi PSI.")

end