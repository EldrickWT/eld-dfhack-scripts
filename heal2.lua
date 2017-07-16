--By Telgin and Kurik Amudnil from the DFHACK r3 thread.
function heal2()
	unit = dfhack.gui.getSelectedUnit()
	unit.flags1.dead = false
	unit.flags2.killed = false
	if unit.caste == 0 then
		unit.caste = 1
	else
		unit.caste = 0
	end
end
heal2()