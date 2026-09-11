--[[ Dodge (TBC, melee vs mob):

5% + (mob defense skill - player weapon skill)*.1%
    minus .25% per expertise point

Possible from any direction.
Level 73 boss with 350 skill: 6.5%

Mobs below level 70 have some extra reduction factor on dodge whose formula
is unknown, so values against them may be slightly too high. ]]
AttackTable = AttackTable or {}

function AttackTable.GetDodgeChance(hand)
	local dodge = 0.05 + AttackTable.GetSkillDiff(hand.skill) * 0.001
	return math.max(0, dodge - hand.expertise)
end
