--fix citizens missing historical figure and nemesis entries (acquired with 'tweak makeown')
function find_entity(id) 
  for ii = 0,#df.global.world.entities.all - 1 do
    if df.global.world.entities.all[ii].id == id then
      return ii
    end
  end
  return -1
end

function create_hist_fig(unit)
	if unit.flags1.important_historical_figure == true then
		print("Already a historical figure.")
		return
	end

	new_fig_id = df.global.hist_figure_next_id

	new_hist_fig = df.historical_figure:new()
	new_hist_fig.profession = unit.profession
	new_hist_fig.race = unit.race
	new_hist_fig.caste = unit.caste
	new_hist_fig.sex = unit.sex
	new_hist_fig.appeared_year = df.global.cur_year
	new_hist_fig.born_year = unit.relations.birth_year
	new_hist_fig.born_seconds = unit.relations.birth_time
	new_hist_fig.curse_year = unit.relations.curse_year
	new_hist_fig.curse_seconds = unit.relations.curse_time
	new_hist_fig.anon_1 = unit.relations.anon_2
	new_hist_fig.anon_2 = unit.relations.anon_3
	new_hist_fig.old_year = unit.relations.old_year
	new_hist_fig.old_seconds = unit.relations.old_time
	new_hist_fig.died_year = -1
	new_hist_fig.died_seconds = -1
	new_hist_fig.name:assign(unit.name)
	new_hist_fig.civ_id = unit.civ_id
	new_hist_fig.population_id  = unit.population_id
	new_hist_fig.breed_id = -1
	new_hist_fig.unit_id = unit.id
	new_hist_fig.id = new_fig_id

	civ_link = df.histfig_entity_link_memberst:new()
	civ_link.entity_id = df.global.ui.civ_id
	civ_link.link_strength =  100

	fort_link = df.histfig_entity_link_memberst:new()
	fort_link.entity_id = df.global.ui.group_id
	fort_link.link_strength =  100

	new_hist_fig.entity_links:insert('#', civ_link)
	new_hist_fig.entity_links:insert('#', fort_link)

	df.global.world.history.figures:insert('#', new_hist_fig)
	df.global.hist_figure_next_id = df.global.hist_figure_next_id + 1

	unit.flags1.important_historical_figure = true
	unit.flags2.important_historical_figure = true
	unit.hist_figure_id = new_fig_id
	unit.hist_figure_id2 = new_fig_id

	new_hf_loc = df.global.world.history.figures[#df.global.world.history.figures - 1]

	df.global.ui.main.fortress_entity.histfig_ids:insert('#', new_fig_id)
	df.global.ui.main.fortress_entity.hist_figures:insert('#', new_hf_loc)

	civ_index = find_entity(df.global.ui.main.fortress_entity.entity_links[0].target)
	df.historical_entity.find(civ_index).histfig_ids:insert('#', new_fig_id)
	df.historical_entity.find(civ_index).hist_figures:insert('#', new_hf_loc)

	new_nemesis_id = df.global.nemesis_next_id
	new_nemesis = df.nemesis_record:new()
	new_nemesis.id = new_nemesis_id
	new_nemesis.figure = new_hf_loc
	new_nemesis.unit = unit
	new_nemesis.unit_id = unit.id
	new_nemesis.save_file_id = df.historical_entity.find(civ_index).save_file_id
	new_nemesis.member_idx = df.historical_entity.find(civ_index).next_member_idx
	--group_leader_id = -1
	new_nemesis.unk10, new_nemesis.unk11, new_nemesis.unk12 = -1, -1, -1

	df.historical_entity.find(civ_index).next_member_idx = df.historical_entity.find(civ_index).next_member_idx + 1

	df.global.world.nemesis.all:insert('#', new_nemesis)
	df.global.nemesis_next_id = df.global.nemesis_next_id + 1

	nemesis_link = df.general_ref_is_nemesisst:new()
	nemesis_link.nemesis_id = new_nemesis_id
	unit.general_refs:insert('#', nemesis_link)

	new_nemesis_loc = df.global.world.nemesis.all[#df.global.world.nemesis.all - 1]

	df.global.ui.main.fortress_entity.nemesis_ids:insert('#', new_nemesis_id)
	df.global.ui.main.fortress_entity.nemesis:insert('#', new_nemesis_loc)
	df.historical_entity.find(civ_index).nemesis_ids:insert('#', new_nemesis_id)
	df.historical_entity.find(civ_index).nemesis:insert('#', new_nemesis_loc)
end

count = 0
for _,unit in pairs(df.global.world.units.active) do
	if dfhack.units.isCitizen(unit) and not unit.flags1.important_historical_figure then
		create_hist_fig(unit)
		count = count + 1
	end
end
if count > 0 then
	print( string.format('fixed %i citizens without historical figure and nemesis entries',count) )
end
