-- For when you need TOO MUCH identity information about a unit.
--Lazy Variable Declarations... doesn't need all this readability
unit=dfhack.gui.getSelectedUnit()
print("Constable Urist, here to investigate per the orders of the Sheriff. Please cooperate fully.")
print("We shall endevour to deduce if something is rotten with the individual under the crosshairs.")
print("All important records about them shall be scrutinized to the extent I have been mandated to perform.")
print("In this investigation we shall assume, One. That someone is under the crosshairs.")
print("... Else this will be a short process.")
print("Secondly, that the someone is of some important historical note.")
print("And... well, If not we shall have to burn that bridge when we get to it.")
print(" ")
print("*ahem*As we proceed we shall uncover any number and manner of assumed identities.")
print("I am reminded that such further scrutiny will be handled by another adjunct of the law, on the sheriff's order.")
print(" ")
print(dfhack.TranslateName(unit.name).. " is under scrutiny. Let the record show that this is their name on their unit. Overseer identification number: " ..unit.id.. ".")
print(dfhack.TranslateName(dfhack.units.getIdentity(unit).name).. " is their current identity as derived from their unit. The reference docket is: " ..dfhack.units.getIdentity(unit).id.. ".")
print(dfhack.TranslateName(df.historical_figure.find(unit.hist_figure_id).name).. " is the name on their historical figure record according to the heralds. The number of that record is: " ..unit.hist_figure_id.. ".")
print(" ")
print("I have it on Faith that their very soul -which could be lying- states they are: " ..dfhack.TranslateName(unit.status.current_soul.name).. ", Overseer ID Number: " ..unit.status.current_soul.id.. ".")

if ((#unit.status.souls) == 1) then
print("There is only one soul residing in our subject, for completeness THAT states they are: " ..dfhack.TranslateName(unit.status.souls[0].name).. ", Overseer ID Number: " ..unit.status.souls[0].id.. ".")
elseif  ((#unit.status.souls) == 2) then
print("The first soul residing in our subject, states they are: " ..dfhack.TranslateName(unit.status.souls[0].name).. ", Overseer ID Number: " ..unit.status.souls[0].id.. ".")
print("But the the second soul residing in our subject, states they are: " ..dfhack.TranslateName(unit.status.souls[1].name).. ", Overseer ID Number: " ..unit.status.souls[1].id.. ".")
else
print("I have been ordered to hand over the matter of too many souls in one individual to another and so we move on.")
end
if (#(df.historical_figure.find(unit.hist_figure_id).info.reputation.all_identities) == 1) then
print(" ")
print("Records from the heralds, list that this individual has gone under one identity.")
print(dfhack.TranslateName(df.historical_figure.find(unit.hist_figure_id).info.reputation.all_identities[0].name).." is the name, and the record is: " ..df.historical_figure.find(unit.hist_figure_id).info.reputation.all_identities[0].id.. ".")
elseif (#(df.historical_figure.find(unit.hist_figure_id).info.reputation.all_identities) == 2) then
print(" ")
print("Records from the heralds, list that this individual has gone under more than one identity.")
print(dfhack.TranslateName(df.identity.find(df.historical_figure.find(unit.hist_figure_id).info.reputation.all_identities[0]).name).." is the first record's name, and the record number is: " ..(df.identity.find(df.historical_figure.find(unit.hist_figure_id).info.reputation.all_identities[0]).id).. ".")
print(dfhack.TranslateName(df.identity.find(df.historical_figure.find(unit.hist_figure_id).info.reputation.all_identities[1]).name).." is the second record's name, and the record number is: " ..(df.identity.find(df.historical_figure.find(unit.hist_figure_id).info.reputation.all_identities[1]).id).. ".")
else
print(" ")
print("Records from the heralds, list that this individual has gone by more identities")
print("  than I am under the authority to investigate and so we shall move on.")
end
print(" ")
print("I have been told that is the extent of my work here, save to keep the crosshairs trained on the subject until further notice.")
print("[DF shows the identity in use on screen, DFHACK shows the Historical Figure or Unit, but not the identity via getVisibleName as of May 18th 2018. Because of this this lua was performed.]")
print("[Observe: Get Visible Name is: " ..dfhack.TranslateName(dfhack.units.getVisibleName(unit)).. "]")
print("[Observe: Get (current) Identity's Name is: " ..dfhack.TranslateName(dfhack.units.getIdentity(unit).name).. "]")
if ((dfhack.TranslateName(dfhack.units.getVisibleName(unit))) == (dfhack.TranslateName(dfhack.units.getIdentity(unit).name))) then print("[Matching]")
else print("[****Not Matching****]")
end