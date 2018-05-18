-- Get the selected unit's first name in the Target Language, and The Trade Tongue. ex 'babblefish ELF'

-- When all is said and done be able to enact that change. 'babblefish ELF do'
-- I even do a bit of the gruntwork within.
-- But more specifically 'babblefish English do' for races with beautiful but hard to decrypt names.
-- This is a bit messier what with the parts of speech... not that I've looked into it.
-- /Currently doesn't remotely cover fake identities./ You get the identity right of the unit, not the Hist Fig.
-- Part of why the 'do' does not get done. When that happens there will be a help segment.

args = ...
targlang = args
unit = dfhack.gui.getSelectedUnit()
worker0, worker1, fl_valuewordz, valuelangy = 0
fl_wordz, worker2 = ' '
langy = {}

--http://lua-users.org/wiki/StringRecipes ---------- and unit-info-viewer.lua
function str2FirstUpper(str)
    return str:gsub("^%l", string.upper)
end

if unit.name.has_name==false then qerror('No selected unit OR unit has no name -nicknames don\'t count. Select a (different) unit.') end
for fl_valuewordz,fl_wordz in ipairs(df.global.world.raws.language.translations[unit.name.language].words) do
	if (fl_wordz.value == unit.name.first_name) then
		worker0 = fl_valuewordz
		break
	end
end
for valuelangy,langy in ipairs(df.global.world.raws.language.translations) do
	if (string.lower(langy.name) == string.lower(targlang)) then
		worker1 = valuelangy
		break
	end
end
-- For posterity the above 'for' loop variables will maintain their names... even though I found out the hardway they're tossed out after the loop runs.
worker2 = df.global.world.raws.language.translations[worker1].words[worker0].value
print(string.lower(df.global.world.raws.language.translations[unit.name.language].name).. ': ' ..string.lower(df.global.world.raws.language.translations[unit.name.language].words[worker0].value))
print(string.lower(df.global.world.raws.language.translations[worker1].name).. ': ' ..worker2)
--"Remaining Name stuff goes here." It will be lazy code. Godawfully lazy code.
workery1,workery2,workery3,workery4,workery5,workery6 = ' '
--These used to be /completely useless/ 'for' loops... now they are simplified. Seriously massive work to get these /exact/ bits back.
print('Unit Name Bits -these are raw numbers.')
workery1=unit.name.words[0]
print('Unit Name Bits0:' ..workery1)
workery2=unit.name.words[1]
print('Unit Name Bits1:' ..workery2)
workery3=unit.name.words[2]
print('Unit Name Bits2:' ..workery3)
workery4=unit.name.words[3]
print('Unit Name Bits3:' ..workery4)
workery5=unit.name.words[4]
print('Unit Name Bits4:' ..workery5)
workery6=unit.name.words[5]
print('Unit Name Bits5:' ..workery6)
workery7=unit.name.words[6]
print('Unit Name Bits6:' ..workery7)
the_restA0=string.lower(worker2) -- There are no parts of speech for first names. they're all nouns.
the_restB0=string.lower(df.global.world.raws.language.words[worker0].word)

--I'm not sure of the spacing of most of the pieces.
--I'm also not sure on the positioning of the /the/ and /of/ segments. Does it really fill them in, in a funny order, as you earn them or what? Wiki doesn't say, and some examples suggest it.

if not (unit.name.words[0] == -1) then
	the_restA1=string.lower(df.global.world.raws.language.translations[worker1].words[workery1][0])
	the_restB1=string.lower(df.global.world.raws.language.words[workery1].forms[unit.name.parts_of_speech[0]])
else
	the_restA1=""
	the_restB1=""
end

if not (unit.name.words[1] == -1) then
	the_restA2=string.lower(df.global.world.raws.language.translations[worker1].words[workery2][0])
	the_restB2=string.lower(df.global.world.raws.language.words[workery2].forms[unit.name.parts_of_speech[1]])
else
	the_restA2=""
	the_restB2=""
end

if not (unit.name.words[2] == -1) then
	the_restA3=" "..string.lower(df.global.world.raws.language.translations[worker1].words[workery3][0])
	the_restB3=" "..string.lower(df.global.world.raws.language.words[workery3].forms[unit.name.parts_of_speech[2]])
else
	the_restA3=""
	the_restB3=""
end

if not (unit.name.words[3] == -1) then
	the_restA4=string.lower(df.global.world.raws.language.translations[worker1].words[workery4][0])
	the_restB4=string.lower(df.global.world.raws.language.words[workery4].forms[unit.name.parts_of_speech[3]])
else
	the_restA4=""
	the_restB4=""
end

if not (unit.name.words[4] == -1) then
	the_restA5=string.lower(df.global.world.raws.language.translations[worker1].words[workery5][0])
	the_restB5=string.lower(df.global.world.raws.language.words[workery5].forms[unit.name.parts_of_speech[4]])
else
	the_restA5=""
	the_restB5=""
end

if not (unit.name.words[5] == -1) then
	the_restA6=" the "..string.lower(df.global.world.raws.language.translations[worker1].words[workery6][0])
	the_restB6=" the "..string.lower(df.global.world.raws.language.words[workery6].forms[unit.name.parts_of_speech[5]])
else
	the_restA6=""
	the_restB6=""
end

if not (unit.name.words[6] == -1) then
	the_restA7=" of "..string.lower(df.global.world.raws.language.translations[worker1].words[workery7][0])
	the_restB7=" of "..string.lower(df.global.world.raws.language.words[workery7].forms[unit.name.parts_of_speech[6]])
else
	the_restA7=""
	the_restB7=""
end

print(dfhack.TranslateName(unit.name,false,false).. "'s name becomes " ..str2FirstUpper(the_restA0).." "..str2FirstUpper(the_restA1)..the_restA2..the_restA3..the_restA4..the_restA5..the_restA6..the_restA7.. " in " ..str2FirstUpper(string.lower(targlang)))
print(dfhack.TranslateName(unit.name,false,false).. "'s name becomes " ..str2FirstUpper(the_restB0).." "..str2FirstUpper(the_restB1)..the_restB2..the_restB3..the_restB4..the_restB5..the_restB6..the_restB7.. " in the Trade Tongue.")
print('Or you could change unit.name.language to one of the other numbers directly but where\'s the fun in that? And you can\'t get the Trade Tongue without a prior existing English file in any event.')