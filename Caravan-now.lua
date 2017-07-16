-- Force a Caravan event in next 10 ticks.

df.global.timed_events:insert('#',{
    new = true,
    type = df.timed_event_type.Caravan,
    season = df.global.cur_season,
    season_ticks = df.global.cur_season_tick+1,
    entity = df.historical_entity.find(df.global.ui.civ_id)  --Currently Causes a Caravan from 'the mountainhomes'... could be adjusted...
})
