--cheerup the fortress. For when parties don't seem to be cutting it. awww.
--pieces of siren.lua and fixnaked.lua
function cheerup()
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
    for fnUnitCount,fnUnit in ipairs(df.global.world.units.active) do
        if fnUnit.civ_id == df.global.ui.civ_id then
            add_thought(fnUnit, df.unit_thought_type.Waterfall)
            add_thought(fnUnit, df.unit_thought_type.Waterfall)
            add_thought(fnUnit, df.unit_thought_type.Waterfall)
            add_thought(fnUnit, df.unit_thought_type.Rescued)
            fnUnit.status.happiness = 4000
        end
    end
    print("What a sight those steam rockets were huh?! Doesn't the mist just cheer you up? EVERYONE DUCK THE ROCKETS ARE COMING DOWN!")
end
cheerup()
