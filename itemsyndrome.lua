-- Checks regularly if creature has an item equipped with a special syndrome and applies item's syndrome if it is.

local function getMaterial(item_inv)
	return dfhack.matinfo.decode(item_inv.item).material
end

local function getSyndrome(material)
	if material==nil then return nil end
	if #material.syndrome>0 then return material.syndrome[0]
	else return nil end
end

local function syndromeIsDfHackSyndrome(syndrome)
	for k,v in ipairs(syndrome.syn_class) do
		if v.value=="DFHACK_ITEM_SYNDROME" then return true end
	end
	return false
end

local function assignSyndrome(target,syn_id) --taken straight from here, but edited so I can understand it better: https://gist.github.com/warmist/4061959/
    if target==nil then
        qerror("Not a valid target") --this probably won't happen :V
    end
    local newSyndrome=df.unit_syndrome:new()
    local target_syndrome=df.syndrome.find(syn_id)
    newSyndrome.type=target_syndrome.id
    --newSyndrome.year=
    --newSyndrome.year_time=
    newSyndrome.ticks=1
    newSyndrome.unk1=1
    for k,v in ipairs(target_syndrome.ce) do
        local sympt=df.unit_syndrome.T_symptoms:new()
        sympt.ticks=1
        sympt.flags=2
        newSyndrome.symptoms:insert("#",sympt)
    end
    target.syndromes.active:insert("#",newSyndrome)
end

local function syndromeIsIndiscriminate(syndrome)
	if #syndrome.syn_affected_class==0 and #syndrome.syn_affected_creature_1==0 and #syndrome.syn_affected_creature_2==0 and #syndrome.syn_immune_class==0 and #syndrome.syn_immune_creature_1==0 and #syndrome.syn_immune_creature_2==0 then return true end
	return false
end

local function creatureIsAffected(unit,syndrome)
	if syndromeIsIndiscriminate(syndrome) then return true end
	local affected = false
	local unitraws = df.creature_raw.find(unit.race)
	local casteraws = unitraws.caste[unit.caste]
	local unitracename = unitraws.creature_id
	local castename = casteraws.caste_id
	local unitclasses = casteraws.creature_class
	for _,unitclass in ipairs(unitclasses) do
		for _,syndromeclass in ipairs(syndrome.syn_affected_class) do
			if unitclass.value==syndromeclass.value then affected = true end
		end
	end
	for caste,creature in ipairs(syndrome.syn_affected_creature_1) do
		local affected_creature = creature.value
		local affected_caste = syndrome.syn_affected_creature_2[caste].value --slightly evil, but oh well, hehe.
		if affected_creature == unitracename and affected_caste == castename then affected = true end
	end
	for _,unitclass in ipairs(unitclasses) do
		for _,syndromeclass in ipairs(syndrome.syn_immune_class) do
			if unitclass.value==syndromeclass.value then affected = false end
		end
	end
	for caste,creature in ipairs(syndrome.syn_immune_creature_1) do
		local immune_creature = creature.value
		local immune_caste = syndrome.syn_affected_creature_2[caste].value
		if immune_creature == unitracename and immune_caste == castename then affected = false end
	end
	return affected
end

local function itemAffectsHauler(item) --needs to be item because of where it's invoked
	local syndrome = getSyndrome(getMaterial(item))
	for k,v in ipairs(syndrome.syn_class) do
		if v.value=="DFHACK_AFFECTS_HAULER" then return true end
	end
	return false
end

local function itemAffectsStuckins(item)
	local syndrome = getSyndrome(getMaterial(item))
	for k,v in ipairs(syndrome.syn_class) do
		if v.value=="DFHACK_AFFECTS_STUCKIN" then return true end
	end
	return false
end

local function itemIsArmorOnly(item)
	local syndrome = getSyndrome(getMaterial(item))
	for k,v in ipairs(syndrome.syn_class) do
		if v.value=="DFHACK_ARMOR_ONLY" then return true end
	end
	return false
end
	

local function itemIsWeaponOnly(item)
	local syndrome = getSyndrome(getMaterial(item))
	for k,v in ipairs(syndrome.syn_class) do
		if v.value=="DFHACK_WIELDED_ONLY" then return true end
	end
	return false
end
	
local function itemIsInValidPosition(item_inv)
	if (item_inv.mode == 0 and not itemAffectsHauler(item_inv)) or (item_inv.mode == 7 and not itemAffectsStuckins(item_inv)) or (item_inv.mode ~= 2 and itemIsArmorOnly(item_inv)) or (item_inv.mode ~=1 and ItemIsWieldedOnly(item_inv)) then return false end
	return true
end


local function findItems()
	for _uid,unit in ipairs(df.global.world.units.all) do
		for itemid,item in ipairs(unit.inventory) do
			if getMaterial(item)~=nil and getSyndrome(getMaterial(item))~=nil then
				local syndrome = getSyndrome(getMaterial(item))
				if syndromeIsDfHackSyndrome(syndrome) and creatureIsAffected(unit,syndrome) and itemIsInValidPosition(item) then assignSyndrome(unit,syndrome.id) end
			end
		end
	end
end


dfhack.onStateChange.itemsyndrome = function(code) --Many thanks to Warmist for pointing this out to me!
	if code==SC_WORLD_LOADED then
		dfhack.timeout(150,'ticks',callback) --disables if map/world is unloaded automatically
	end
end

function callback()
	findItems()
	dfhack.timeout(150,'ticks',callback)
end

dfhack.onStateChange.itemsyndrome()

if ... == "force" then findItems() end