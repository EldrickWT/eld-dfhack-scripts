-- Divorces a creature from its spouse and / or lover.  Run this per creature in a relationship.

local args = {...}

function divorce (unit_id)

	local victim, historic_victim

	for key, value in pairs(df.global.world.units.all) do
		-- The arguments are strings, but the structs contain numbers
		if value.id == unit_id then
			victim = value
		end
	end

	if df.isnull(victim) then
		print('The unit was not found.')
		return
	end

	if victim.relations.spouse_id == -1 and victim.relations.lover_id == -1 then
		print('Warning: the unit has no lover or spouse, nothing to do.')
		return
	end

	print("Divorcing " .. victim.name.nickname)

	for key, value in pairs(df.global.world.history.figures) do
		if value.id == victim.hist_figure_id then
			historic_victim = value
		end
	end

	if df.isnull(historic_victim) then
		print('The historical figure for the unit was not found.')
		return
	end

	local link_count = #historic_victim.histfig_links

	-- Remove the spouse hf link, if it exists
	for key, value in pairs(historic_victim.histfig_links) do
		if df.histfig_hf_link_spousest:is_instance(value) then
			if key ~= link_count -1 then
				-- Moves the spouse entry to the end of the list, then resizes the list to size - 1, erasing it
				historic_victim.histfig_links[key] = historic_victim.histfig_links[link_count - 1]
			end

			historic_victim.histfig_links:resize(link_count - 1)
			link_count = link_count - 1
			value:delete()

			break
		end
	end

	-- Remove the lover hf link, if it exists
	for key, value in pairs(historic_victim.histfig_links) do
		if df.histfig_hf_link_loverst:is_instance(value) then
			if key ~= link_count -1 then
				-- Moves the lover entry to the end of the list, then resizes the list to size - 1, erasing it
				historic_victim.histfig_links[key] = historic_victim.histfig_links[link_count - 1]
			end

			historic_victim.histfig_links:resize(link_count - 1)
			link_count = link_count - 1
			value:delete()

			break
		end
	end

	victim.relations.spouse_id = -1
	victim.relations.lover_id = -1
end

if df.isnull(args[1]) then
	print('You must pass in a unit id.')
	return
end

dfhack.with_suspend(divorce, tonumber(args[1]))
