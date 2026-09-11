--[[ Shared helpers for the player -> mob melee attack table (TBC).

Source for all mechanics: https://github.com/magey/tbc-warrior/wiki/Attack-table
(tested on TBC Classic; several values differ from vanilla). ]]
local Outgoing = AttackTable.Outgoing

-- Mob defense skill minus player weapon skill
function Outgoing.GetSkillDiff(weaponSkill)
	return AttackTable.GetTargetDefense() - weaponSkill
end

function Outgoing.IsDualWielding()
	local _, offhandSpeed = UnitAttackSpeed("player")
	return offhandSpeed ~= nil
end

-- One entry per hand: weapon skill (incl. modifiers) and expertise as a fraction
function Outgoing.GetHands()
	local mainBase, mainMod, offBase, offMod = UnitAttackBothHands("player")
	local mainExpertise, offExpertise = GetExpertisePercent()
	local hands = { { skill = mainBase + mainMod, expertise = mainExpertise / 100 } }
	if Outgoing.IsDualWielding() then
		table.insert(hands, { skill = offBase + offMod, expertise = offExpertise / 100 })
	end
	return hands
end

-- Hit chance from hit rating plus non-rating sources (talents like Precision)
function Outgoing.GetHitBonus()
	return (GetCombatRatingBonus(CR_HIT_MELEE) + GetHitModifier()) / 100
end
