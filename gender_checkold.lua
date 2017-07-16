--Gender check. Just a gender check for the ACTIVE units. OLD SPAMMY GENDER_CHECK.LUA WILL REPURPOSE LATER.
everyone = false
for _,arg in ipairs({...}) do
	if arg == "all" or arg == "ALL" then everyone = true
	else everyone = false
	end
end
function gender_check ()
	local unit, unit2, unit3, gendery, namey, spousey2, spousey3, namey2, namey3, happymarriage2, happymarriage3 = -1
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
					namey = df.global.world.raws.creatures.all[unit.race].name[0]
				else
					namey = dfhack.TranslateName(unit.name,false,false)
				end
				if unit.relations.spouse_id == -1 then
					spousey2 = "They are not married."
					namey2 = ""
					happymarriage2 = ""
				else
					spousey2 = "They are married to "
					for _,unit2 in ipairs(df.global.world.units.active) do
						if (unit.id == unit2.relations.spouse_id) and (unit2.relations.lover_id == -1) then
							namey2 = dfhack.TranslateName(unit2.name)
							happymarriage2 = "They're having a chaste time of it."
						elseif (unit.id == unit2.relations.spouse_id) and not (unit.id == unit2.relations.lover_id) then
							namey2 = dfhack.TranslateName(unit2.name)
							happymarriage2 = "Spoused without benefits."
						elseif not (unit.id == unit2.relations.spouse_id) and (unit.id == unit2.relations.lover_id) then
							namey2 = dfhack.TranslateName(unit2.name)
							happymarriage2 = "Illicit Affair Detected."
						elseif (unit.id == unit2.relations.spouse_id) and (unit.id == unit2.relations.lover_id) then
							namey2 = dfhack.TranslateName(unit2.name)
							happymarriage2 = "How happy for them in bed."
--						elseif not (unit.id == unit2.relations.spouse_id) and not (unit.id == unit2.relations.lover_id) then
--							namey2 = dfhack.TranslateName(unit2.name)
--							happymarriage2 = "How did you get here?"
						else
							happymarriage2 = "..."
						end
					end
				end
				if unit.relations.lover_id == -1 then
					spousey3 = "They are not busy Friday Night (wink)."
					namey3 = ""
					happymarriage3 = ""
				else
					spousey3 = "They are busy Friday Night (wink) with "
					for _,unit3 in ipairs(df.global.world.units.active) do
						if (unit.relations.spouse_id == -1) and (unit.id == unit3.relations.lover_id) then
							namey3 = dfhack.TranslateName(unit3.name)
							happymarriage3 = "They're enjoying benefits."
						elseif (unit.id == unit3.relations.spouse_id) and not (unit.id == unit3.relations.lover_id) then
							namey3 = dfhack.TranslateName(unit3.name)
							happymarriage3 = "Spoused without benefits."
						elseif not (unit.id == unit3.relations.spouse_id) and (unit.id == unit3.relations.lover_id) then
							namey3 = dfhack.TranslateName(unit3.name)
							happymarriage3 = "Illicit Affair Detected."
						elseif (unit.id == unit3.relations.spouse_id) and (unit.id == unit3.relations.lover_id) then
							namey3 = dfhack.TranslateName(unit3.name)
							happymarriage3 = "How happy for them in bed."
--						elseif not (unit.id == unit3.relations.spouse_id) and not (unit.id == unit3.relations.lover_id) then
--							namey3 = dfhack.TranslateName(unit3.name)
--							happymarriage3 = "How did you get here?"
						else
							happymarriage3 = "..."
						end
					end
				end
				if (everyone == true) then
					print(namey.. " is a " ..df.global.world.raws.creatures.all[unit.race].creature_id.. "(" ..df.global.world.raws.creatures.all[unit.race].caste[unit.caste].caste_name[0].. ") and their gender is " ..gendery..". " ..spousey2.. "" ..namey2.. " " ..happymarriage2.. " " ..spousey3.. "" ..namey3.. " " ..happymarriage3)
				else
					if not (namey2 == "") or not (namey3 == "") then
						print(namey.. " is a " ..df.global.world.raws.creatures.all[unit.race].creature_id.. "(" ..df.global.world.raws.creatures.all[unit.race].caste[unit.caste].caste_name[0].. ") and their gender is " ..gendery..". " ..spousey2.. "" ..namey2.. " " ..happymarriage2.. " " ..spousey3.. "" ..namey3.. " " ..happymarriage3)
					end
				end
			end
		end
	end
end
dfhack.with_suspend(gender_check)
