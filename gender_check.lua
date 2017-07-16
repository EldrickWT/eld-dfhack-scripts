--Gender check. Just a gender check for the ACTIVE units.
everyone = false
for _,arg in ipairs({...}) do
	if arg == "all" or arg == "ALL" then everyone = true
	else everyone = false
	end
end
function gender_check ()
	local unit, unit2, unit3, gendery, spousey2, spousey3, namey2, namey3, namey1done, namey2done, namey3done = ""
	for _,unit in ipairs(df.global.world.units.active) do
		if (unit.civ_id == df.global.ui.civ_id) then
			if not (unit.flags1.dead) then
				if (df.global.world.raws.creatures.all[unit.race].caste[unit.caste].gender == 0) then
					gendery = "Female [0]"
				elseif (df.global.world.raws.creatures.all[unit.race].caste[unit.caste].gender == 1) then
					gendery = "Male [1]"
				else
					gendery = "Other [cabbage]"
				end
				if unit.name.has_name == false then
					namey1done = df.global.world.raws.creatures.all[unit.race].name[0]
				else
					namey1done = dfhack.TranslateName(unit.name,false,false)
				end
				namey2done = " "
				namey3done = " "
				if unit.relations.spouse_id == -1 then
					spousey2 = "They are not married."
				else
					spousey2 = "They are married to "
					for _,unit2 in ipairs(df.global.world.units.active) do
						if (unit.id == unit2.relations.spouse_id) then
							namey2 = unit2.id
							if unit2.name.has_name == false then
								namey2done = df.global.world.raws.creatures.all[unit2.race].name[0]
							else
								namey2done = dfhack.TranslateName(unit2.name,false,false).."."
							end
						end
					end
				end
				if unit.relations.lover_id == -1 then
					spousey3 = "They are not busy Friday Night (wink)."
				else
					spousey3 = "They are busy Friday Night (wink) with "
					for _,unit3 in ipairs(df.global.world.units.active) do
						if (unit.id == unit3.relations.lover_id) then
							namey3 = unit3.id
							if unit3.name.has_name == false then
								namey3done = df.global.world.raws.creatures.all[unit3.race].name[0]
							else
								namey3done = dfhack.TranslateName(unit3.name,false,false).."."
							end
						end
					end
				end
				if (everyone == true) then
						if (namey2done == " ") then
							namey2done = ""
						end
						if (namey3done == " ") then
							namey3done = ""
						end
						print(namey1done.." is a "..df.global.world.raws.creatures.all[unit.race].creature_id.." ("..df.global.world.raws.creatures.all[unit.race].caste[unit.caste].caste_name[0]..") and their gender is "..gendery..". "..spousey2..""..namey2done.." "..spousey3..""..namey3done)
				else
					if not (namey2done == " ") or not (namey3done == " ") then
						if (namey2done == " ") then
							namey2done = ""
						end
						if (namey3done == " ") then
							namey3done = ""
						end
						print(namey1done.." is a "..df.global.world.raws.creatures.all[unit.race].creature_id.." ("..df.global.world.raws.creatures.all[unit.race].caste[unit.caste].caste_name[0]..") and their gender is "..gendery..". "..spousey2..""..namey2done.." "..spousey3..""..namey3done)
					end
				end
			end
		end
	end
end
dfhack.with_suspend(gender_check)
