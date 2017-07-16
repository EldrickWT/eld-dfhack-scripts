-- magically dig all designations (use with caution)
-- does not currently propogate light, or reveal surrounding tiles, 
-- or clean up plants whose tiles become open air, and might not 
-- make empty open air tiles when channeling two or more tiles deep.

NO_DIRECTION = '--------'

function findTileType(shape, material, variant, special, dir)
	local tt_attrs
	for tt=0,698 do
		tt_attrs = df.tiletype.attrs[tt]
		if shape ~= df.tiletype_shape.NONE and shape ~= tt_attrs.shape then
			--continue
		elseif material ~= df.tiletype_material.NONE and material ~= tt_attrs.material then
			--continue
		-- Don't require variant to match if the destination tile doesn't even have one
		elseif variant ~= df.tiletype_variant.NONE and variant ~= tt_attrs.variant and 
				tt_attrs.variant ~= df.tiletype_variant.NONE then
			--continue
		-- Same for special
		elseif special ~= df.tiletype_special.NONE and special ~= tt_attrs.special and
				tt_attrs.special ~= df.tiletype_special.NONE then
			--continue
		elseif dir ~= NO_DIRECTION and dir ~= tt_attrs.direction then -- if (tdir && tdir != tileDirection(tt)), 
			--continue
		else
			--Match
			return tt
		end
	end
	return df.tiletype.Void
end

function paint(mb,mbx,mby, attrs)
	local shape, material, variant, special, direction
	shape = attrs.shape
	material = attrs.material
	variant = attrs.variant
	special = attrs.special
	direction = attrs.direction
	
	-- Remove direction from directionless tiles
	if	not (material == df.tiletype_material.RIVER or shape == df.tiletype_shape.BROOK_BED or shape == df.tiletype_shape.WALL and 
			(material == df.tiletype_material.CONSTRUCTION or special == df.tiletype_special.SMOOTH) ) then
		direction = NO_DIRECTION
	end
	local tt = findTileType(shape, material, variant, special, direction)
	-- hack for empty space
	-- this might not work when we are trying to create air by digging channels/ramps
	if shape == df.tiletype_shape.EMPTY and material == df.tiletype_material.AIR and 
			variant == df.tiletype_variant.VAR_1 and special == df.tiletype_special.NORMAL and 
			direction == NO_DIRECTION then
		tt = df.tiletype.OpenSpace	
	end
	if tt ~= df.tiletype.Void then
		mb.tiletype[mbx][mby] = tt
		
		mb.designation[mbx][mby].hidden = false		-- reveal?
		-- mb.designation[mbx][mby].light = true		-- light?
		-- mb.designation[mbx][mby].outside = true		-- outside?
		
		local d = mb.designation[mbx][mby]	-- this wont work if lua doesn't treat it as a pointer
		-- Remove liquid from walls, etc
		if tt and df.tiletype_shape.attrs[ df.tiletype.attrs[tt].shape ].passable_flow then
			d.flow_size = false
			--des.bits.liquid_type = DFHack::liquid_water;
			--des.bits.water_table = 0;
			d.flow_forbid = false
			--des.bits.liquid_static = 0;
			--des.bits.water_stagnant = 0;
			--des.bits.water_salt = 0;
		end
		-- clear dig designation
		d.dig = 0 -- or df.tile_dig_designation.No
	end
end


function do_dig_designations()
	local x_maxblock, y_maxblock, z_maxblock = dfhack.maps.getSize()
	local d, tt, tt_attrs, mb2, tt2, tt2_attrs
	for _,b in ipairs(df.global.world.map.map_blocks) do
		if b.flags.designated then
			for bx = 0,15 do
				for by = 0,15 do
					d = b.designation[bx][by].dig
					tt = b.tiletype[bx][by]
					if d > 0 then
						tt_attrs = copyall(df.tiletype.attrs[tt])
						if d == df.tile_dig_designation.Default then -- dig
							tt_attrs.shape = df.tiletype_shape.FLOOR
							tt_attrs.special = df.tiletype_special.NORMAL
							tt_attrs.variant = math.random(0,3)
						elseif d == df.tile_dig_designation.UpDownStair then
							tt_attrs.shape = df.tiletype_shape.STAIR_UPDOWN
						elseif d == df.tile_dig_designation.Channel then
							tt_attrs.shape = df.tiletype_shape.RAMP_TOP
							tt_attrs.material = df.tiletype_material.AIR
							-- change tile type to a ramp top and below tile to ramp
							b2 = dfhack.maps.getTileBlock(b.map_pos.x,b.map_pos.y,b.map_pos.z - 1)
							if b2 then
								tt2 = b2.tiletype[bx][by]
								tt2_attrs = copyall( df.tiletype.attrs[tt2] )
								tt2_attrs.shape = df.tiletype_shape.RAMP
								paint(b2,bx,by, tt2_attrs)
							end
						elseif d == df.tile_dig_designation.Ramp then
							tt_attrs.shape = df.tiletype_shape.RAMP
							-- change tile type to ramp and above tile to ramp top
							-- similar to channel but the other way around
							b2 = dfhack.maps.getTileBlock(b.map_pos.x,b.map_pos.y,b.map_pos.z + 1)
							if b2 then
								tt2 = b2.tiletype[bx][by]
								tt2_attrs = copyall( df.tiletype.attrs[tt] )
								tt2_attrs.shape = df.tiletype_shape.RAMP_TOP
								tt2_attrs.material = df.tiletype_material.AIR
								paint(b2,bx,by, tt2_attrs)
							end
						elseif d == df.tile_dig_designation.DownStair then
							tt_attrs.shape = df.tiletype_shape.STAIR_DOWN
						elseif d == df.tile_dig_designation.UpStair then
							tt_attrs.shape = df.tiletype_shape.STAIR_UP
						end
						paint(b,bx,by, tt_attrs)
					end
				end
			end
		end--if designated
	end
	-- Force the game to recompute its walkability cache
	df.global.world.reindex_pathfinding = true
end

if not dfhack.isMapLoaded() then
	printerr("map not loaded")
	return
end


--dfhack.with_suspend(f[,args...])
do_dig_designations()

