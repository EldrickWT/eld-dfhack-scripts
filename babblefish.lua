-- Get the selected unit's first name in the Target Language. 'babblefish ELF'
-- When all is said and done be able to enact that change. 'babblefish ELF do'
-- Or more specifically 'babblefish English do' for races with beautiful but hard to decrypt names.
-- /Currently doesn't remotely cover fake identities./
args = ...

--http://lua-users.org/wiki/StringRecipes ---------- and unit-info-viewer.lua
function str2FirstUpper(str)
    return str:gsub("^%l", string.upper)
end


unit = dfhack.gui.getSelectedUnit()
if unit.name.has_name==false then qerror("No selected unit OR unit has no name. Select a (different) unit.") end
targlang = args
for valuelangy,langy in ipairs(df.global.world.raws.language.translations) do
	if (string.lower(langy.name) == string.lower(targlang)) then
		worker1 = valuelangy
	end
end
for valuewordz,wordz in ipairs(df.global.world.raws.language.translations[unit.name.language].words) do
	if (wordz[0] == unit.name.first_name) then
		worker2 = valuewordz
	end
end
--These used to be /completely useless/ for loops... now they are simplified. Seriously massive work to get these /exact/ bits back.
workery1=unit.name.words[0]
workery2=unit.name.words[1]
workery3=unit.name.words[2]
workery4=unit.name.words[3]
workery5=unit.name.words[4]
workery6=unit.name.words[5]
workery7=unit.name.words[6]
--print(dfhack.TranslateName(unit.name,false,false).. "'s name becomes " ..df.global.world.raws.language.translations[worker1].words[worker2][0].. " in " ..string.lower(targlang).. " which is " ..string.lower(df.global.world.raws.language.words[worker2].word).. " in its rawest form.")
--"Remaining Name stuff goes here." It will be lazy code. Godawfully lazy code.
the_restA0=string.lower(df.global.world.raws.language.translations[worker1].words[worker2][0])
the_restB0=string.lower(df.global.world.raws.language.words[worker2].word) -- There are no parts of speech for first names. they're all nouns.
if not (unit.name.words[0] == -1) then the_restA1=string.lower(df.global.world.raws.language.translations[worker1].words[workery1][0]) the_restB1=string.lower(df.global.world.raws.language.words[workery1].forms[unit.name.parts_of_speech[0]]) else the_restA1="" the_restB1="" end
if not (unit.name.words[1] == -1) then the_restA2=string.lower(df.global.world.raws.language.translations[worker1].words[workery2][0]) the_restB2=string.lower(df.global.world.raws.language.words[workery2].forms[unit.name.parts_of_speech[1]]) else the_restA2="" the_restB2="" end
--Are the next three spaced?
if not (unit.name.words[2] == -1) then the_restA3=" "..string.lower(df.global.world.raws.language.translations[worker1].words[workery3][0]) the_restB3=" "..string.lower(df.global.world.raws.language.words[workery3].forms[unit.name.parts_of_speech[2]]) else the_restA3="" the_restB3="" end
if not (unit.name.words[3] == -1) then the_restA4=string.lower(df.global.world.raws.language.translations[worker1].words[workery4][0]) the_restB4=string.lower(df.global.world.raws.language.words[workery4].forms[unit.name.parts_of_speech[3]]) else the_restA4="" the_restB4="" end
if not (unit.name.words[4] == -1) then the_restA5=string.lower(df.global.world.raws.language.translations[worker1].words[workery5][0]) the_restB5=string.lower(df.global.world.raws.language.words[workery5].forms[unit.name.parts_of_speech[4]]) else the_restA5="" the_restB5="" end
--I'm not sure on the positioning of the /the/ and /of/ segments. Does it really fill them in in a funny order as you earn them? Wiki doesn't say, and some examples suggest it.
if not (unit.name.words[5] == -1) then the_restA6=" the "..string.lower(df.global.world.raws.language.translations[worker1].words[workery6][0]) the_restB6=" the "..string.lower(df.global.world.raws.language.words[workery6].forms[unit.name.parts_of_speech[5]]) else the_restA6="" the_restB6="" end
if not (unit.name.words[6] == -1) then the_restA7=" of "..string.lower(df.global.world.raws.language.translations[worker1].words[workery7][0]) the_restB7=" of "..string.lower(df.global.world.raws.language.words[workery7].forms[unit.name.parts_of_speech[6]]) else the_restA7="" the_restB7="" end

print(dfhack.TranslateName(unit.name,false,false).. "'s name becomes " ..str2FirstUpper(the_restA0).." "..str2FirstUpper(the_restA1)..the_restA2..the_restA3..the_restA4..the_restA5..the_restA6..the_restA7.. " in " ..str2FirstUpper(string.lower(targlang)))
print(dfhack.TranslateName(unit.name,false,false).. "'s name becomes " ..str2FirstUpper(the_restB0).." "..str2FirstUpper(the_restB1)..the_restB2..the_restB3..the_restB4..the_restB5..the_restB6..the_restB7.. " in the Trade Tongue.")