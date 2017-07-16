-- Displays some species data in the console about a selected unit.
-- @.@ First REAL script.
unit=dfhack.gui.getSelectedUnit()
race_lookup=unit.race
racey=df.global.world.raws.creatures.all[race_lookup]
caste_lookup=unit.caste
castey=racey.caste[caste_lookup]
if unit.name.has_name == false then
    namey = 'This'
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