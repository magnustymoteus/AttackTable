--[[ Crushing Blow (TBC, mob melee vs player):

if mob attack skill - player BASE defense >= 15
(mob attack skill - base defense)*2% - 15%
    defense from rating does not count

Level 73 boss vs 350 base defense: 15% ]]
local Incoming = AttackTable.Incoming

function Incoming.GetCrushingChance()
	local baseDefense = UnitDefense("player")
	local diff = Incoming.GetMobSkill() - baseDefense
	if diff < 15 then
		return 0
	end
	return diff * 0.02 - 0.15
end
