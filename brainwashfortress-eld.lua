--BRAINWASH the fortress. For when that one lost sheep haunts their thoughts FOREVER.
function brainwashfortress()

    --readapted From siren.lua on April 7 2015
    function add_thought(unit, emotion, thought)
        unit.status.current_soul.personality.emotions:resize(0)
        unit.status.current_soul.personality.emotions:insert('#', { new = true, type = emotion, unk2=1, strength=1, thought=thought, subthought=0, severity=0, flags=0, unk7=0, year=df.global.cur_year, year_tick=df.global.cur_year_tick})
        unit.status.happiness = 4000
    end

    --readapted From siren.lua and conscript.lua on April 7 2015
    for unitCount,unit in ipairs(df.global.world.units.active) do
        if not (unit.flags1.dead == true) then
            if unit.civ_id == df.global.ui.civ_id then
                add_thought(unit, df.emotion_type.Relief, df.unit_thought_type.Rescued)
                print(dfhack.TranslateName(dfhack.units.getVisibleName(unit)))
            end
        end
    end
end
brainwashfortress()
