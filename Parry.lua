--[[ Parry (TBC, melee vs mob):

diff = mob defense skill - player weapon skill

if diff <= 10
5% + diff*.1%

if diff > 10
5% + diff*.6%

minus .25% per expertise point

Only possible when attacking from the front.
Level 73 boss with 350 skill: 14% ]]
AttackTable = AttackTable or {}

function AttackTable.GetParryChance(hand)
	if not AttackTable.config.attackFromFront then
		return 0
	end
	local diff = AttackTable.GetSkillDiff(hand.skill)
	local factor = diff > 10 and 0.006 or 0.001
	return math.max(0, 0.05 + diff * factor - hand.expertise)
end
