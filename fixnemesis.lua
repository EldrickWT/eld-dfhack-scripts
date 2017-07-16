function find_entity(id) 
  for ii = 0,#df.global.world.entities.all - 1 do
    if df.global.world.entities.all[ii].id == id then
      return ii
    end
  end
  return -1
end

function create_nemesis(unit)
	hist_fig = df.historical_figure.find(unit.hist_figure_id)
	civ_index = find_entity(df.global.ui.main.fortress_entity.entity_links[0].target)
	
	new_nemesis_id = df.global.nemesis_next_id
	new_nemesis = df.nemesis_record:new()
	new_nemesis.id = new_nemesis_id
	new_nemesis.figure = hist_fig
	new_nemesis.unit = unit
	new_nemesis.unit_id = unit.id
	new_nemesis.save_file_id = df.global.world.entities.all[civ_index].save_file_id
	new_nemesis.member_idx = df.global.world.entities.all[civ_index].next_member_idx
	--group_leader_id = -1
	new_nemesis.unk10, new_nemesis.unk11, new_nemesis.unk12 = -1, -1, -1

	df.global.world.entities.all[civ_index].next_member_idx = df.global.world.entities.all[civ_index].next_member_idx + 1

	df.global.world.nemesis.all:insert('#', new_nemesis)
	df.global.nemesis_next_id = df.global.nemesis_next_id + 1

	nemesis_link = df.general_ref_is_nemesisst:new()
	nemesis_link.nemesis_id = new_nemesis_id
	unit.general_refs:insert('#', nemesis_link)

	new_nemesis_loc = df.global.world.nemesis.all[#df.global.world.nemesis.all - 1]

	df.global.ui.main.fortress_entity.nemesis_ids:insert('#', new_nemesis_id)
	df.global.ui.main.fortress_entity.nemesis:insert('#', new_nemesis_loc)
	df.global.world.entities.all[civ_index].nemesis_ids:insert('#', new_nemesis_id)
	df.global.world.entities.all[civ_index].nemesis:insert('#', new_nemesis_loc)
end

count = 0
for _,unit in pairs(df.global.world.units.active) do
	if dfhack.units.isCitizen(unit) and unit.flags1.important_historical_figure then
		nemesis = false
		for _, ref in pairs (unit.general_refs) do
			if df.general_ref_is_nemesisst:is_instance(ref) then
				nemesis = true
			end
		end
		if not nemesis then
			create_nemesis(unit)
			count = count + 1
		end
	end
end
if count > 0 then
	print( string.format('fixed %i citizens without nemesis entries',count) )
end
