--heal all units from all wounds and damage provided they are not dead or scuttled (no immortal /wagons/).
--by Warmist (healunit). cure4 by rpg nostalgia (Square Enix) and Eldrick Tobin
function healallunits(unit)
	for _,unit in ipairs(df.global.world.units.active) do
		victim=unit
		if victim.flags1.dead==false then
			if victim.flags3.scuttle==false then
				for i=#victim.body.wounds-1,0,-1 do
					victim.body.wounds[i]:delete()
				end
				victim.body.wounds:resize(0) 
				victim.body.blood_count=victim.body.blood_max
				--set flags for standing and grasping...
				victim.status2.limbs_stand_max=4
				victim.status2.limbs_stand_count=4
				victim.status2.limbs_grasp_max=4
				victim.status2.limbs_grasp_count=4
				--should also set temperatures, and flags for breath etc...
				victim.flags1.dead=false
				victim.flags2.calculated_bodyparts=false
				victim.flags2.calculated_nerves=false
				victim.flags2.circulatory_spray=false
				victim.flags2.vision_good=true
				victim.flags2.vision_damaged=false
				victim.flags2.vision_missing=false
				victim.counters.winded=0
				victim.counters.unconscious=0
				for k,v in pairs(victim.body.components) do
					for kk,vv in pairs(v) do
						if k == 'body_part_status' or k=='layer_status' then v[kk].whole = 0  else v[kk] = 0 end
					end
				end
				if victim.name.has_name == false then
					namey = 'This one'
				else
					namey = dfhack.TranslateName(victim.name,true)
				end
				print("Victim " ..namey.." should be fine now.")
			end
		end
	end
end
healallunits()