--cheerup the fortress. For when parties don't seem to be cutting it. awww.
--pieces of siren.lua and fixnaked.lua
--From siren.lua
function add_thought(unit, emotion, thought)
    unit.status.current_soul.personality.emotions:insert('#', { new = true,
    type = emotion,
    unk2=1,
    strength=1,
    thought=thought,
    subthought=0,
    severity=0,
    flags=nil,
    unk7=0,
    year=df.global.cur_year,
    year_tick=df.global.cur_year_tick})
end
for unitcount,unit in ipairs(df.global.world.units.active) do
    if unit.civ_id == df.global.ui.civ_id then
--  really wanna put this junk back in but I'm botching something somewhere. And while I'll run this 12 times... siren ... not so enjoyable for the fortress.
--        add_thought(unit, df.emotion_type.Admiration, df.unit_thought_type.Waterfall)
--        add_thought(unit, df.emotion_type.Admiration, df.unit_thought_type.Waterfall)
--        add_thought(unit, df.emotion_type.Admiration, df.unit_thought_type.Waterfall)
--        add_thought(unit, df.emotion_type.Relief, df.unit_thought_type.Rescued)
--  This have been moved or destroyed.
--        unit.status.happiness = 4000
        unit.status.current_soul.personality.stress_level = -40000
    end
end
announcement_flags = {
    D_DISPLAY = true,
    PAUSE = true,
}
--Weird having to format the announcement for my screen size... which will not match someone's out there. 1080p here.
dfhack.gui.showAnnouncement('What a sight those steam rockets were huh?!  Doesn\'t the mist just cheer you up? AAAAAND Boom! The rockets shred their weak selves.    No fuss no muss. What? You were worried about debris! Ha! ANOTHER VOLLEY! Come On!  Give us another volley!',COLOR_MAGENTA, true)
