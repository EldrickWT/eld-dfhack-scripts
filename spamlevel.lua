--The Point of this script is to spam a level with a command -in the default case
--creating strawberry plants in order to hopefully trick the map into grassing itself.
--This will be switched to grass should plant create be extended in that direction.
--Blame Eldrick Tobin for this.
local limit=192
while not ((df.global.cursor.y >= limit) and (df.global.cursor.x >= limit)) do
	dfhack.run_command "plant create BERRIES_STRAW"
	df.global.cursor.x=df.global.cursor.x+1
	if (df.global.cursor.x==limit and df.global.cursor.y < limit) then
		df.global.cursor.x=0
		df.global.cursor.y=df.global.cursor.y+1
	end
	if (df.global.cursor.y==limit) then
		df.global.cursor.x=limit
		df.global.cursor.y=limit
	end
end
