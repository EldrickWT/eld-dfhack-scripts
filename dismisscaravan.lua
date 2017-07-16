--For when you want them to leave and they're still there for 2 seasons... dismiss that caravan. Selected unit's caravan leaves much sooner. (WIP)
k=0
while k < #df.global.ui.caravans do
	unit=dfhack.gui.getSelectedUnit()
	if unit.civ_id==df.global.ui.caravans[k].entity then
		df.global.ui.caravans[k].trade_state=3 --Leaving...
		df.global.ui.caravans[k].time_remaining=100 --soon
	end
	k=k+1
end