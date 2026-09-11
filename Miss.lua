--[[ Miss (TBC, white melee vs mob):

diff = mob defense skill - player weapon skill

if diff <= 10
5% + diff*.1%

if diff > 10
5% + diff*.2%
    plus hit suppression: the first (diff - 10)*.2% of your +hit does nothing

If dual-wielding, add 19% (white swings only; yellow attacks don't get this penalty)

Mobs below level 10: miss chance is multiplied by (mob level / 10)

Level 73 boss with 350 skill: 8% base miss, 9% of +hit needed to reach 0% ]]
AttackTable = AttackTable or {}

function AttackTable.GetMissChance(hand)
	local diff = AttackTable.GetSkillDiff(hand.skill)
	local miss = 0.05 + diff * 0.001
	local suppression = 0
	if diff > 10 then
		miss = 0.05 + diff * 0.002
		suppression = (diff - 10) * 0.002
	end
	if AttackTable.IsDualWielding() then
		miss = miss + 0.19
	end
	local level = AttackTable.GetTargetLevel()
	if level < 10 then
		miss = miss * level / 10
	end
	miss = miss - math.max(0, AttackTable.GetHitBonus() - suppression)
	return math.max(0, miss)
end
