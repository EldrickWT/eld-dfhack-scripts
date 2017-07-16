-- On map load writes information about the loaded region to gamelog.txt
-- By Kurik Amudnil and Warmist (http://www.bay12forums.com/smf/index.php?topic=91166.msg4467072#msg4467072) with tweaks from itemsyndrome... to make it work on EldrickTobin's system -.-;

local function write_gamelog(msg)
    local log = io.open("gamelog.txt", "a")
    log:write(msg.."\n")
    log:close()
end

local args = {...}
if args[1] == "disable" then
    dfhack.onStateChange.logregion = nil
else
    dfhack.onStateChange.logregion = function(op)
      if op==SC_WORLD_LOADED then
        dfhack.timeout(150,'ticks',callback) --disables if map/world is unloaded automatically
      end
    end
            if df.world_site.find(df.global.ui.site_id) ~= nil then -- added this check, now only attempts write in fort mode
                local site = df.world_site.find(df.global.ui.site_id)
                --local fort_ent = df.global.ui.main.fortress_entity
                --local civ_ent = df.historical_entity.find(df.global.ui.civ_id)
                local worldname = df.global.world.world_data.name
                -- site positions
                -- site  .pos.x  .pos.y
                -- site  .rgn_min_x  .rgn_min_y  .rgn_max_x  .rgn_max.y
                -- site  .global_min_x  .global_min_y  .global_max_x  .global_max_y
                --site.name
                --fort_ent.name
                --civ_ent.name
                --print("Loaded "..df.global.world.cur_savegame.save_dir..", "..dfhack.TranslateName(df.global.world.world_data.name).." ("..dfhack.TranslateName(df.global.world.world_data.name ,true)..") at coordinates ("..site.pos.x..","..site.pos.y..")"..NEWLINE.."Loaded the fortress "..dfhack.TranslateName(df.world_site.find(df.global.ui.site_id).name).." ("..dfhack.TranslateName(df.world_site.find(df.global.ui.site_id).name, true).."), colonized by the group "..dfhack.TranslateName(df.global.ui.main.fortress_entity.name).." ("..dfhack.TranslateName(df.global.ui.main.fortress_entity.name,true)..") of the civilization "..dfhack.TranslateName(df.historical_entity.find(df.global.ui.civ_id).name).." ("..dfhack.TranslateName(df.historical_entity.find(df.global.ui.civ_id).name,true)..")."..NEWLINE)
                write_gamelog(NEWLINE.."Loaded "..df.global.world.cur_savegame.save_dir..", "..dfhack.TranslateName(df.global.world.world_data.name).." ("..dfhack.TranslateName(df.global.world.world_data.name ,true)..") at coordinates ("..site.pos.x..","..site.pos.y..")"..NEWLINE.."Loaded the fortress "..dfhack.TranslateName(df.world_site.find(df.global.ui.site_id).name).." ("..dfhack.TranslateName(df.world_site.find(df.global.ui.site_id).name, true).."), colonized by the group "..dfhack.TranslateName(df.global.ui.main.fortress_entity.name).." ("..dfhack.TranslateName(df.global.ui.main.fortress_entity.name,true)..") of the civilization "..dfhack.TranslateName(df.historical_entity.find(df.global.ui.civ_id).name).." ("..dfhack.TranslateName(df.historical_entity.find(df.global.ui.civ_id).name,true)..")."..NEWLINE)
     end
end

function callback()
    dfhack.timeout(150,'ticks',callback)
end

dfhack.onStateChange.logregion()
