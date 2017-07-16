-- Civviesplode Lua Edition. Target will 'feel the touch of spring'. Does not work on Dead, Killed, Ghostly, Scuttled or units slated For trade

function civviesplode ()
	local v = dfhack.gui.getSelectedUnit()
	local victim = v
	local genes
	local a = 0
	local b = 0
	local c = 0
	if (victim == nil) then
		return
	end
	if (v.name.has_name == true) then
		print(dfhack.TranslateName(v.name,true).." is getting a magickal visit from the pregnancy titan.")
	end
	print("Magicking this particular "..df.global.world.raws.creatures.all[victim.race].creature_id.."'s womb...")
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
	print("Results: "..a.." accelerated pregnancies "..c.." total pregnancies.")
end
dfhack.with_suspend(civviesplode)
