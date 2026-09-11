--[[ Dodge (TBC, melee vs mob):

5% + (mob defense skill - player weapon skill)*.1%
    minus .25% per expertise point

Possible from any direction.
Level 73 boss with 350 skill: 6.5%

The formula is the Beaza formula and has not been measured at level 70.
The only measurements (https://github.com/magey/tbc-warrior/issues/56, level 60
player on the TBC Classic beta, marked working as intended by Blizzard) show
lower dodge than the formula:
    vs level 60 mob: 4.04% (formula 5%)
    vs level 63 mob: 5.93% (formula 6.5%)
No formula for this is known, so it is not applied here. ]]
AttackTable = AttackTable or {}

function AttackTable.GetDodgeChance(hand)
	local dodge = 0.05 + AttackTable.GetSkillDiff(hand.skill) * 0.001
	return math.max(0, dodge - hand.expertise)
end
