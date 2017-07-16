-- Civviesplosion Lua Edition. On Map Members of the Target Species 'feel the touch of spring'. Does not work on Dead, Killed, Ghostly, Scuttled or units slated For trade

local args = {...}

function civviesplosion ()
	local victim = dfhack.gui.getSelectedUnit()
	local genes
	local a = 0
	local b = 0
	local c = 0
	if (victim == nil) then
		return
	end
	if (victim.name.has_name == true) then
		print(dfhack.TranslateName(victim.name,true).."'s race shall be used.")
	end
	print("Magicking all "..df.global.world.raws.creatures.all[victim.race].creature_id.." wombs...")
	for _,v in ipairs(df.global.world.units.active) do
		if (v.civ_id == df.global.ui.civ_id) then
			if (v.race == victim.race) and not (v.flags1.dead) and not (v.flags2.killed) and not (v.flags2.for_trade) and not (v.flags3.ghostly) and not (v.flags3.scuttle) then
				if (v.sex == 0) then
					if (v.pregnancy_timer > 0) then
						print('Already pregnant! Accelerating!')
						v.pregnancy_timer = 1
						a = a + 1
					end
					genes = v.appearance.genes:new()
					v.pregnancy_genes = genes;
					v.pregnancy_timer = 30;
					if (v.pregnancy_spouse == -1) and (v.relationship_ids.Spouse == -1) then
						v.pregnancy_caste = 0;
					else
						v.pregnancy_caste = 1;
					end
					c = c + 1
				elseif (v.sex == -1) then
					if (v.pregnancy_timer > 0) then
						print('Already pregnant! Accelerating!')
						v.pregnancy_timer = 1
						a = a + 1
					end
					genes = v.appearance.genes:new()
					v.pregnancy_genes = genes;
					v.pregnancy_timer = 30;
					v.pregnancy_caste = 1;
					c = c + 1
				end
			end
		end
	end
	print("Results: "..a.." accelerated pregnancies "..c.." total pregnancies.")
end
dfhack.with_suspend(civviesplosion)
