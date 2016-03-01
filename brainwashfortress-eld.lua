--BRAINWASH the fortress. For when that one lost sheep haunts their thoughts FOREVER.
function brainwash()
local total_fixed = 0
local total_removed = 0

--From siren.lua
function add_thought(fnUnit, code)
    for _,v in ipairs(fnUnit.status.recent_events) do
        if v.type == code then
            v.age = 0
            return
        end
    end
    fnUnit.status.recent_events:insert('#', { new = true, type = code, severity = 150 }) --added a severity level.
end


for fnUnitCount,fnUnit in ipairs(df.global.world.units.all) do
    if fnUnit.race == df.global.ui.race_id then
        local listEvents = fnUnit.status.recent_events
        local found = 1
        local fixed = 0
        while found == 1 do
            local events = fnUnit.status.recent_events
            found = 0
            for k,v in pairs(events) do
                events:erase(k)
                found = 1
                total_removed = total_removed + 1
                fixed = 1
                break
            end
        end
        add_thought(fnUnit, df.unit_thought_type.Rescued)
        fnUnit.status.happiness = 4000
        if fixed == 1 then
            total_fixed = total_fixed + 1
            print(total_fixed, total_removed, dfhack.TranslateName(dfhack.units.getVisibleName(fnUnit)))
        end
    end
end
print("Total Fixed: "..total_fixed)
end
brainwash()
