--[[ Crushing Blow:

Only mobs can crush (against players, when the mob's attack skill is at least
15 above the player's defense). A player's attacks on a mob never crush, so this
is always 0% for the player -> mob table. ]]
local Outgoing = AttackTable.Outgoing

function Outgoing.GetCrushingChance(hand)
	return 0
end
