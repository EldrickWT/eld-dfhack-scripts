-- Marries two specified creatures.  Take care when using this on creatures that are already married!

local args = {...}

function marry (unit_id1, unit_id2)

	local victim1, historic_victim1
	local victim2, historic_victim2

	for key, value in pairs(df.global.world.units.all) do
		-- The arguments are strings, but the structs contain numbers
		if value.id == unit_id1 then
			victim1 = value
		end
		if value.id == unit_id2 then
			victim2 = value
		end
	end

	if df.isnull(victim1) then
		print('The first unit was not found.')
		return
	end
	if df.isnull(victim2) then
		print('The second unit was not found.')
		return
	end

	if victim1.relations.spouse_id ~= -1 then
		print('Warning: the first unit is already married.  Their marriage will be replaced.')
	end
	if victim2.relations.spouse_id ~= -1 then
		print('Warning: the second unit is already married.  Their marriage will be replaced.')
	end

	print("Marrying " .. dfhack.TranslateName(victim1.name,true) .. " and " .. dfhack.TranslateName(victim2.name,true))

	for key, value in pairs(df.global.world.history.figures) do
		if value.id == victim1.hist_figure_id then
			historic_victim1 = value
		end
		if value.id == victim2.hist_figure_id then
			historic_victim2 = value
		end
	end

	if df.isnull(historic_victim1) then
		print('The historical figure for the first unit was not found.')
		return
	end
	if df.isnull(historic_victim2) then
		print('The historical figure for the second unit was not found.')
		return
	end

	local new_link1 = df.histfig_hf_link_spousest:new()
	local new_link2 = df.histfig_hf_link_spousest:new()

	-- Not documented, but this is the historical figure id
	new_link1.target_hf = victim2.hist_figure_id
	new_link1.link_strength = 100

	new_link2.target_hf = victim1.hist_figure_id
	new_link2.link_strength = 100

	local link_count1 = #historic_victim1.histfig_links
	local link_count2 = #historic_victim2.histfig_links

	historic_victim1.histfig_links:resize(link_count1 + 1)
	historic_victim1.histfig_links[link_count1] = new_link1
	historic_victim2.histfig_links:resize(link_count2 + 1)
	historic_victim2.histfig_links[link_count2] = new_link2

	victim1.relations.spouse_id = victim2.id
	victim2.relations.spouse_id = victim1.id
end

if df.isnull(args[1]) or df.isnull(args[2]) then
	print('You must pass in two unit ids.')
	return
end

dfhack.with_suspend(marry, tonumber(args[1]), tonumber(args[2]))
