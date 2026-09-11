--[[ Miss (TBC, mob melee vs player):

5% + (player defense - mob attack skill)*.04%

Level 73 boss vs 350 defense: 4.4% ]]
local Incoming = AttackTable.Incoming

function Incoming.GetMissChance()
	return math.max(0, 0.05 + (Incoming.GetDefense() - Incoming.GetMobSkill()) * 0.0004)
end
