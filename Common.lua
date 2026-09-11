--[[ Shared helpers for the player -> mob melee attack table (TBC).

Source for all mechanics: https://github.com/magey/tbc-warrior/wiki/Attack-table
(tested on TBC Classic; several values differ from vanilla).

Mob defense skill = mob level * 5.
Skull (??) mobs are treated as player level + 3 (level 73 bosses at 70).

Chances are returned as fractions (0.05 = 5%). ]]
AttackTable = AttackTable or {}

AttackTable.config = {
	-- Parry and block only happen when attacking the mob from the front
	attackFromFront = true,
	-- Only mobs carrying a shield can block, which the API can't tell us
	targetCanBlock = false,
}

function AttackTable.GetTargetLevel()
	local level = UnitLevel("target")
	if level <= 0 then
		level = UnitLevel("player") + 3
	end
	return level
end

function AttackTable.GetTargetDefense()
	return AttackTable.GetTargetLevel() * 5
end

-- Mob defense skill minus player weapon skill
function AttackTable.GetSkillDiff(weaponSkill)
	return AttackTable.GetTargetDefense() - weaponSkill
end

function AttackTable.IsDualWielding()
	local _, offhandSpeed = UnitAttackSpeed("player")
	return offhandSpeed ~= nil
end

-- One entry per hand: weapon skill (incl. modifiers) and expertise as a fraction
function AttackTable.GetHands()
	local mainBase, mainMod, offBase, offMod = UnitAttackBothHands("player")
	local mainExpertise, offExpertise = GetExpertisePercent()
	local hands = { { skill = mainBase + mainMod, expertise = mainExpertise / 100 } }
	if AttackTable.IsDualWielding() then
		table.insert(hands, { skill = offBase + offMod, expertise = offExpertise / 100 })
	end
	return hands
end

-- Hit chance from hit rating plus non-rating sources (talents like Precision)
function AttackTable.GetHitBonus()
	local talentHit = GetHitModifier and GetHitModifier() or 0
	return (GetCombatRatingBonus(CR_HIT_MELEE) + talentHit) / 100
end
