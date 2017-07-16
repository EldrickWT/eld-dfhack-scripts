-- Sends units away into the wild
-- https://gist.github.com/IndigoFenix/8543616
args={...}

local targetUnit=dfhack.gui.getSelectedUnit()
if targetUnit == nil and args[2] ~= 'all' then
    local targetUnit = df.unit.find(tonumber(args[2]))
end

group = args[1]

if args[2] == 'all' then
    all = true
else
    all = false
end

function exile(u)
    if u then
        u.civ_id=-1
        u.flags1.tame=false
        u.animal.leave_countdown=2
        u.flags1.forest=true
        u.relations.following = nil
        u.flags1.active_invader = false
        u.flags1.hidden_in_ambush = false
        u.flags1.coward = false
        u.flags1.hidden_ambusher = false
        u.flags1.invades = false
    end
end

function isMember(u)
    if u.race == df.global.ui.race_id
      and u.civ_id == df.global.ui.civ_id
      and not dfhack.units.isOpposedToLife(u)
      and not u.flags1.merchant 
      and not u.flags1.diplomat then
        return true
    else
        return false
    end
end

function isPet(u)
    if u.flags1.tame
      and u.civ_id==df.global.ui.civ_id
      and not dfhack.units.isOpposedToLife(u)
      and not u.flags1.merchant 
      and not u.flags1.diplomat then
        return true
    else
        return false
    end
end

function isWild(u)
    unitRaw = df.global.world.raws.creatures.all[u.race]
    casteRaw = unitRaw.caste[u.caste]
    if u.flags2.roaming_wilderness_population_source
      and not u.flags1.tame
      and not dfhack.units.isOpposedToLife(u)
      and u.civ_id==-1
      and not u.flags1.merchant 
      and not u.flags1.diplomat then
        return true
    else
        return false
    end
end

function isInvader(u)
    if u.flags1.active_invader
      or u.flags1.hidden_in_ambush
      or u.flags1.coward
      or u.flags1.hidden_ambusher
      or u.flags1.invades then
        return true
    else
        return false
    end
end

function isMerchant(u)
    if u.flags1.merchant 
    then
        return true
    else
        return false
    end
end

function isDiplomat(u)
    if u.flags1.diplomat
    then
        return true
    else
        return false
    end
end


function exileUnit(u)
    if group == 'member' then
        if isMember(u) then exile(u) end
    end
    if group == 'pet' then
        if isPet(u) then exile(u) end
    end
    if group == 'wild' then
        if isWild(u) then exile(u) end
    end
    if group == 'invader' then
        if isInvader(u) then exile(u) end
    end
    if group == 'merchant' then
        if isMerchant(u) then exile(u) end
    end
    if group == 'diplomat' then
        if isDiplomat(u) then exile(u) end
    end
    if group == 'any' then exile(u) end
end

if all == true then
    allUnits = df.global.world.units.active
    local u
    for i=#allUnits-1,0,-1 do    -- search list in reverse
        u = allUnits[i]
        exileUnit(u)
    end
else
    local unit=targetUnit
    if unit == nil then
        print('Argument 1: Unit type - any, member, pet, wild, invader, merchant, diplomat')
        print('Argument 2: all (to exile all units of the selected type), leave blank for only the selected unit.')
        return
    else
        if group == nil then
            exile(unit)
        else
            exileUnit(unit)
        end
    end
end



