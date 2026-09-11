--[[ Crit (TBC, melee vs mob):

if weapon skill < mob defense skill
crit + (weapon skill - defense skill)*.2%

if weapon skill >= mob defense skill
crit + (weapon skill - defense skill)*.04%

Against +3 level mobs (bosses) there is an extra flat -1.8% suppression on crit
gained from auras (talents, crit rating on gear, buffs, consumables), not on crit
from agility.

Level 73 boss with 350 skill: -4.8% compared to the character sheet ]]
local Outgoing = AttackTable.Outgoing

function Outgoing.GetCritChance(hand)
	local sheetCrit = GetCritChance() / 100
	local skillDiff = hand.skill - AttackTable.GetTargetDefense()
	local factor = skillDiff < 0 and 0.002 or 0.0004
	local crit = sheetCrit + skillDiff * factor
	if AttackTable.GetTargetLevel() - UnitLevel("player") >= 3 then
		local auraCrit = sheetCrit - GetCritChanceFromAgility("player") / 100
		crit = crit - math.max(0, math.min(0.018, auraCrit))
	end
	return math.max(0, crit)
end
