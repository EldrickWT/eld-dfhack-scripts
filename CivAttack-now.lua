-- Force a CivAttack event in next 10 ticks.

df.global.timed_events:insert('#',{
    new = true,
    type = df.timed_event_type.CivAttack,
    season = df.global.cur_season,
    season_ticks = df.global.cur_season_tick+1,
    entity = df.historical_entity.find(df.global.world.entities.all[94].id)  --This Needs Automating to find someone you want trying to kill you.
})
