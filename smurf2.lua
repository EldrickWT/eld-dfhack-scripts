-- Displays some species data in the console about all the active units.
for _,unit in ipairs(df.global.world.units.active) do
    race_lookup = unit.race
    racey = df.global.world.raws.creatures.all[race_lookup]
    caste_lookup = unit.caste
    castey = racey.caste[caste_lookup]
    
    if unit.name.has_name == false then
        namey = racey.name[0]
    else
        namey = dfhack.TranslateName(unit.name,true)
    end

    if castey.gender == 0 then
        print(namey.." is a Female " ..castey.caste_name[0].. " of the " ..racey.name[1])
    elseif castey.gender == 1 then
        print(namey.." is a Male " ..castey.caste_name[0].. " of the " ..racey.name[1])
    else
        print(namey.." is a " ..castey.caste_name[0].. " of the " ..racey.name[1])
    end
end