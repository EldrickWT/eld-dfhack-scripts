-- Turns babies and children into adults, and assigns all labors to everyone in the fortress -also checks for messed up labors, and taming.
--I know it doesn't look it but I /am/ trying to not just tabulate every single creature in the objects directory. Really I swear.
--Lazy Variable Declarations... doesn't need all this readability
local debug=false
local mine=false
local fish=false
local hunt=false
local wood=false
local bees=false
local help=false
local did_something=false
--Lazy Argument Checking... extra lines for readability
for _,arg in ipairs({...}) do
    if string.lower(arg)=="debug" then debug=true end

    if string.lower(arg)=="mine" then mine=true end
    if string.lower(arg)=="fish" then fish=true end
    if string.lower(arg)=="hunt" then hunt=true end
    if string.lower(arg)=="wood" then wood=true end
    if string.lower(arg)=="bees" then bees=true end

    if string.lower(arg)=="nomine" then mine=false end
    if string.lower(arg)=="nofish" then fish=false end
    if string.lower(arg)=="nohunt" then hunt=false end
    if string.lower(arg)=="nowood" then wood=false end
    if string.lower(arg)=="nobees" then bees=false end

    if string.lower(arg)=="help" then help=true end
    if string.lower(arg)=="h" then help=true end
    if string.lower(arg)=="?" then help=true end
    if string.lower(arg)=="-help" then help=true end
    if string.lower(arg)=="-h" then help=true end
    if string.lower(arg)=="-?" then help=true end
    if string.lower(arg)=="--help" then help=true end
    if string.lower(arg)=="-h" then help=true end
    if string.lower(arg)=="--?" then help=true end
end
--Lazy Help Section
if help==true then
  print([[
Conscript.lua is by EldrickWT - Github profile http://github.com/EldrickWT
Bugs can be reported at - http://Github.com/EldrickWT/dfhack

    Conscript is for converting Civilization Babies, and Children into Functional Adults
first and foremost. It has no configuration in this regard.

    Everyone able will be set to all the -safe to toggle on- labors. Nothing that
directly precludes anything else. It also disables those labors that will interact with
each other. These labors are:
Mining
Woodcutting
Hunting

    Each of the above labors will turn the other labors off. While you could set all three on
The behaviour is unwise. At the very least, which labor will take precident is a tad
unpredictable. The unit might spam about having an axe instead of a mining pick, or
a ranged weapon instead of an axe.. or lastly no ammunition... because they refuse to go
hunting without a ranged weapon.

Additionally some slightly problematic labors are also disabled by Conscript:
Beekeeping
Fishing

Fishing - Intelligent Pets/Slaves will Fish. This can be problematic if they can't then
    DROP them anywhere (carrying capacity or item_thief).
    They also may fish the map empty. Thus have a care if you enable Fishing as Pet/slaves
    who can _will Fish_. Conversely, it can free other units for other endeavors...
    provided you keep the other units from heading to the watering hole. It is unknown
    if Toady One will ever patch away Intelligent Pet fishing...
    as it can keep them from starving.
Beekeeping - Formerly this was highly problematic. One Beekeeper would do a task and
    another would come along try to do the same... and stand out in the cold and wet
    doing little else but head back for food and drink before waiting to do whatever
    task that is now IMPOSSIBLE. It's still managed by Conscript as you also don't
    want a talented beekeeper costing you bees by dying with them in a grissly fashion
    that ends your bees. Being on Fire comes to mind. Magma is always a problem as well.
    Thus you should manage Beekeeping manually.

Command Data: - Said last so it's still on your screen -
Conscript (parameters/arguments):

(no arguments) - Active living units, are made adults by profession. Safe labors are toggled on
debug - turns on debug data allowing for some informative spam.
mine - Enables Mining and the Safe Labors.
wood - Enables Woodcutting and the Safe Labors.
hunt - Enables Hunting and the Safe Labors.
fish - Enables Fishing and the Safe Labors.
bees - Enables Beekeeping and the Safe Labors.

no prepended to mine, wood, etc hard disables it.
Conscript nomine - Disables Mining. Useful for command line edits primarily.

Conscript accepts many arguments at the same time:
Conscript debug mine bees - Enables Mining, Beekeeping, and the Safe Labors with Debug Spam.

]])
  return
end
-- Lazy Pre-Run Variable Check
--if (debug==true) then print('Debug is '..debug..' (duh) Mine is '..mine..'Fish is '..fish..'Hunt is '..hunt..'Wood is '..wood..'Bees is '..bees) end
-- /Lazy Code
for _,v in ipairs(df.global.world.units.active) do
  if not (v.flags1.dead==true) then
    if (v.flags1.diplomat==false) or (v.flags1.merchant==false) or (v.flags1.forest==false) then
      if (v.civ_id==df.global.ui.civ_id) then

        if (v.profession==103) then
          v.profession=102
          did_something=true
        end
        if (v.profession==104) then
          v.profession=102
          did_something=true
        end
        if (v.profession2==103) then
          v.profession2=102
          did_something=true
        end
        if (v.profession2==104) then
          v.profession2=102
          did_something=true
        end
        v.flags1.ridden=false
        v.flags1.rider=false
        v.relationship_ids.RiderMount=-1
        if (dfhack.TranslateName(v.name,true)=='') then --Moved up here after I took a longer look at TranslateName... I'm an idiot.
          namey='This one'
        else
          namey=dfhack.TranslateName(v.name,true)
        end
        if (did_something==true) then print(namey.. " is all grown up!") did_something=false end --Done with Children at this point.

        if not (v.following==nil) then print(namey.. " is following " ..dfhack.TranslateName(v.following.name,true)..". Is that okay?") end --We don't touch this, so pets and military assigns don't change.

        -- Training_level 9 is WildUntamed. df.global.ui.civ_id members are typically level 9 but have their tame flag set to false so it's a non-issue.
        -- Training_level 7 is Domesticated when the tame flag set to true. This -and tame flag set to true- is the default for embark pets/impaired slaves.
        -- Training_level 6 is MasterfullyTrained when the tame flag is set to true. This file is edittable if you don't like my defaults.
        if (df.creature_raw.find(v.race).creature_id=="DOWNTRODDEN")
          or (df.creature_raw.find(v.race).creature_id=="FABULOUSA")
          or (df.creature_raw.find(v.race).creature_id=="FOOCUBI")
          or (df.creature_raw.find(v.race).creature_id=="KOLCHA")
          or (df.creature_raw.find(v.race).creature_id=="MEWLI")
          or (df.creature_raw.find(v.race).creature_id=="MESSIANIC_FLUFFBALL")
          or (df.creature_raw.find(v.race).creature_id=="QUEEN_SUCCUBUS")
          or (df.creature_raw.find(v.race).creature_id=="TROLL")
          or (df.creature_raw.find(v.race).creature_id=="WRAITH") then
            if (debug==true) then print("Untaming a " ..df.creature_raw.find(v.race).creature_id.. " refered to as " ..namey) end
            v.flags1.tame=false
            v.training_level=9
        elseif (v.race==df.global.ui.race_id) then --Emancipating Slaves/Indentured Sevants.
          if (debug==true) then print("Race match for a " ..df.creature_raw.find(v.race).creature_id.. " refered to as " ..namey) end
          v.flags1.tame=false
          v.training_level=9
        elseif (df.creature_raw.find(v.race).flags.CASTE_CAN_SPEAK==false) or (df.creature_raw.find(v.race).flags.CASTE_CAN_LEARN==false) then
          if (debug==true) then print("Impairment detected: " ..df.creature_raw.find(v.race).creature_id.. " refered to as " ..namey) end --Mooing is not speech usually.
          v.flags1.tame=true
          v.training_level=7
--        elseif (v.#GROUPIDISMISSING==df.global.ui.group_id) then
--          if (debug==true) then print("Group match for a " ..df.creature_raw.find(v.race).creature_id.. " refered to as " ..namey) end
--          v.flags1.tame=false
--          v.training_level=9
        --Need to spell out the higher order/entity races in case of 'tweak makeown' and 'mercenaries'. Animalmen'll still be boned but they kinda should be. At current anyway.
        --In either event, we're talking about CIV members already anyway. Aaand we already covered 'pets' so now Mercenaries.
        --Could potentially be cleaned up to pull from the master entity list or the entity raws ... but this should be quick at least.
        elseif (df.creature_raw.find(v.race).creature_id=="ANGEL") --ANGEL_CIV
          or (df.creature_raw.find(v.race).creature_id=="SEPUTUS") --CULTIST
          or (df.creature_raw.find(v.race).creature_id=="DWARF") --MOUNTAIN
          or (df.creature_raw.find(v.race).creature_id=="ELF") --FOREST
          or (df.creature_raw.find(v.race).creature_id=="HUMAN") --PLAINS
          or (df.creature_raw.find(v.race).creature_id=="GOBLIN") --EVIL
          or (df.creature_raw.find(v.race).creature_id=="KOBOLD") --SKULKING...
          or (df.creature_raw.find(v.race).creature_id=="FABULOUSA") --FABULOUSA
          or (df.creature_raw.find(v.race).creature_id=="FALLEN") --FALLEN
          or (df.creature_raw.find(v.race).creature_id=="KAPA") --KAPA...
          or (df.creature_raw.find(v.race).creature_id=="KOLCHA") --KOLCHA
          or (df.creature_raw.find(v.race).creature_id=="LOLI") --LOLI_CIV
          or (df.creature_raw.find(v.race).creature_id=="MEWLI") --MEWLI
          or (df.creature_raw.find(v.race).creature_id=="MLA") --MLA_CIV
          or (df.creature_raw.find(v.race).creature_id=="PEDO") --PEDO ...
          or (df.creature_raw.find(v.race).creature_id=="FOOCUBI") --W_FOOCUBI_CIV
          or (df.creature_raw.find(v.race).creature_id=="PROUDHORN") --PROUDHORN_CIV
          or (df.creature_raw.find(v.race).creature_id=="VILEHORN") --VILEHORN_CIV
          or (df.creature_raw.find(v.race).creature_id=="GARDOHN") --GARDOHN
          or (df.creature_raw.find(v.race).creature_id=="WRAITH") --WRAITH
          or (df.creature_raw.find(v.race).creature_id=="YIFFIAN") --YIFFIAN_CIV
          or (df.creature_raw.find(v.race).creature_id=="EARTH_GOLEM") --Default SLOW_LEARNER, But they can learn, throw parties, and do work in 42.06 so...
          or (df.creature_raw.find(v.race).creature_id=="PUDDING_GOLEM") --Ditto
          or (df.creature_raw.find(v.race).creature_id=="FERALHORN") --'Tarzan like Jane. Tarzan smarter than dumb Kapa. Or Kobold.'
          or (df.creature_raw.find(v.race).creature_id=="GREMLIN") then --Can Learn, can speak, and will do work with 42.06 so...
            if (debug==true) then print("?Mercenary? Tinker Tailor Soldier Sailor? Scholar?? Bard?? " ..df.creature_raw.find(v.race).creature_id.. " refered to as " ..namey) end
            v.flags1.tame=false
            v.training_level=9
        --Spot open for Semi-megabeasts here...
        --Spot open for Megabeasts here...
        --Spot open for Powers here...
--        elseif not (v.race==df.global.ui.race_id) then
--            if (debug==true) then print("Race doesn't match for a " ..df.creature_raw.find(v.race).creature_id.. " refered to as " ..namey) end
--            v.flags1.tame=true
--            v.training_level=7 --Pulled out till I recall the situation when it is needed again.
        else --WTF?
            if (debug==true) then print("No criteria for a " ..df.creature_raw.find(v.race).creature_id.. " refered to as " ..named.. ", so taming them.") end
            v.flags1.tame=false
            v.training_level=9
        end
        --Lazy SELECT CASTE ALL knockoff applied to LUA
        v.flags1.on_ground=false
        if (v.mood==8) then
          v.mood=-1
        end
        if (v.counters.soldier_mood==2) then
          v.counters.soldier_mood_countdown=1
        end
        if (mine==true) then v.status.labors.MINE=true v.military.pickup_flags.update=true else v.status.labors.MINE=false end
        v.status.labors.HAUL_STONE=true
        v.status.labors.HAUL_WOOD=true
        v.status.labors.HAUL_BODY=true
        v.status.labors.HAUL_FOOD=true
        v.status.labors.HAUL_REFUSE=true
        v.status.labors.HAUL_ITEM=true
        v.status.labors.HAUL_FURNITURE=true
        v.status.labors.HAUL_ANIMALS=true
        v.status.labors.CLEAN=true
        if (wood==true) then v.status.labors.CUTWOOD=true v.military.pickup_flags.update=true else v.status.labors.CUTWOOD=false end
        v.status.labors.CARPENTER=true
        v.status.labors.DETAIL=true
        v.status.labors.MASON=true
        v.status.labors.ARCHITECT=true
        v.status.labors.ANIMALTRAIN=true
        v.status.labors.ANIMALCARE=true
        v.status.labors.DIAGNOSE=true
        v.status.labors.SURGERY=true
        v.status.labors.BONE_SETTING=true
        v.status.labors.SUTURING=true
        v.status.labors.DRESSING_WOUNDS=true
        v.status.labors.FEED_WATER_CIVILIANS=true
        v.status.labors.RECOVER_WOUNDED=true
        v.status.labors.BUTCHER=true
        v.status.labors.TRAPPER=true
        v.status.labors.DISSECT_VERMIN=true
        v.status.labors.LEATHER=true
        v.status.labors.TANNER=true
        v.status.labors.BREWER=true
        v.status.labors.ALCHEMIST=true
        v.status.labors.SOAP_MAKER=true
        v.status.labors.WEAVER=true
        v.status.labors.CLOTHESMAKER=true
        v.status.labors.MILLER=true
        v.status.labors.PROCESS_PLANT=true
        v.status.labors.MAKE_CHEESE=true
        v.status.labors.MILK=true
        v.status.labors.COOK=true
        v.status.labors.PLANT=true
        v.status.labors.HERBALIST=true
        if (fish==true) then v.status.labors.FISH=true else v.status.labors.FISH=false end
        v.status.labors.CLEAN_FISH=true
        v.status.labors.DISSECT_FISH=true
        if (hunt==true) then v.status.labors.HUNT=true v.military.pickup_flags.update=true else v.status.labors.HUNT=false end
        v.status.labors.SMELT=true
        v.status.labors.FORGE_WEAPON=true
        v.status.labors.FORGE_ARMOR=true
        v.status.labors.FORGE_FURNITURE=true
        v.status.labors.METAL_CRAFT=true
        v.status.labors.CUT_GEM=true
        v.status.labors.ENCRUST_GEM=true
        v.status.labors.WOOD_CRAFT=true
        v.status.labors.STONE_CRAFT=true
        v.status.labors.BONE_CARVE=true
        v.status.labors.GLASSMAKER=true
        v.status.labors.EXTRACT_STRAND=true
        v.status.labors.SIEGECRAFT=true
        v.status.labors.SIEGEOPERATE=true
        v.status.labors.BOWYER=true
        v.status.labors.MECHANIC=true
        v.status.labors.POTASH_MAKING=true
        v.status.labors.LYE_MAKING=true
        v.status.labors.DYER=true
        v.status.labors.BURN_WOOD=true
        v.status.labors.OPERATE_PUMP=true
        v.status.labors.SHEARER=true
        v.status.labors.SPINNER=true
        v.status.labors.POTTERY=true
        v.status.labors.GLAZING=true
        v.status.labors.PRESSING=true
        if (bees==true) then v.status.labors.BEEKEEPING=true else v.status.labors.BEEKEEPING=false end
        v.status.labors.WAX_WORKING=true
        v.status.labors.HANDLE_VEHICLES=true
        v.status.labors.HAUL_TRADE=true
        v.status.labors.PULL_LEVER=true
        v.status.labors.REMOVE_CONSTRUCTION=true
        v.status.labors.HAUL_WATER=true
        v.status.labors.GELD=true
        v.status.labors.BUILD_ROAD=true
        v.status.labors.BUILD_CONSTRUCTION=true
        v.status.labors.PAPERMAKING=true
        v.status.labors.BOOKBINDING=true
      end
      --/Old/ code for checking for mysterious extra labors. UPDATE: Spotted Geld, And the Two new Build Jobs. So not so old eh?
      if (v.civ_id==df.global.ui.civ_id) and not (v.status.labors[83]==false) then print(dfhack.TranslateName(v.name,true).." has a true value for status.labors.83") end
      if (v.civ_id==df.global.ui.civ_id) and not (v.status.labors[84]==false) then print(dfhack.TranslateName(v.name,true).." has a true value for status.labors.84") end
      if (v.civ_id==df.global.ui.civ_id) and not (v.status.labors[85]==false) then print(dfhack.TranslateName(v.name,true).." has a true value for status.labors.85") end
      if (v.civ_id==df.global.ui.civ_id) and not (v.status.labors[86]==false) then print(dfhack.TranslateName(v.name,true).." has a true value for status.labors.86") end
      if (v.civ_id==df.global.ui.civ_id) and not (v.status.labors[87]==false) then print(dfhack.TranslateName(v.name,true).." has a true value for status.labors.87") end
      if (v.civ_id==df.global.ui.civ_id) and not (v.status.labors[88]==false) then print(dfhack.TranslateName(v.name,true).." has a true value for status.labors.88") end
      if (v.civ_id==df.global.ui.civ_id) and not (v.status.labors[89]==false) then print(dfhack.TranslateName(v.name,true).." has a true value for status.labors.89") end
      if (v.civ_id==df.global.ui.civ_id) and not (v.status.labors[90]==false) then print(dfhack.TranslateName(v.name,true).." has a true value for status.labors.90") end
      if (v.civ_id==df.global.ui.civ_id) and not (v.status.labors[91]==false) then print(dfhack.TranslateName(v.name,true).." has a true value for status.labors.91") end
      if (v.civ_id==df.global.ui.civ_id) and not (v.status.labors[92]==false) then print(dfhack.TranslateName(v.name,true).." has a true value for status.labors.92") end
      if (v.civ_id==df.global.ui.civ_id) and not (v.status.labors[93]==false) then print(dfhack.TranslateName(v.name,true).." has a true value for status.labors.93") end
    end
  end
end --End For Loop