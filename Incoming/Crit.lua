--[[ Crit (TBC, mob melee vs player):

5% + (mob attack skill - player defense)*.04% - resilience crit reduction

Level 73 boss: 5.6% at 350 defense, 0% at 490 defense ]]
local Incoming = AttackTable.Incoming

function Incoming.GetCritChance()
	local crit = 0.05 + (Incoming.GetMobSkill() - Incoming.GetDefense()) * 0.0004
	crit = crit - GetCombatRatingBonus(CR_RESILIENCE_CRIT_TAKEN) / 100
	return math.max(0, crit)
end
