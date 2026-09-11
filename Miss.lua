--[[ Miss: 

if |mob defense skill - player weapon skill| <= 10
5% + (Defense Skill - Weapon Skill)*.1%
    If dual-wielding, substitute 24% for 5% in this formula

If the difference between the mob's Defense Skill and your Weapon Skill is greater than 10, then the formula for calculating your base miss rate against that mob is:


if |mob defense skill - player weapon skill| > 10
6% + (Defense Skill - Weapon Skill - 10)*.4%
    If dual-wielding, substitute 25% for 6% in this formula

Mob's defense skill / attack rating: It is the Mob's level multiplied by 5.

For Skull Bosses, the formula is your level plus 3, multiplied by 5, with a minimum based on when the Boss was introduced (Bosses introduced in 1.x have a minimum level of 63, those introduced in 2.x have a minimum level of 73, and those introduced in 3.x have a minimum level of 83). ]]
AttackTable = AttackTable or {}

function AttackTable.GetMissChance(weaponSkill)
	local mob = UnitLevel("target") * 5
	local factor = 0.001
	local base = IsDualWielding() and 0.24 or 0.05
	if math.abs(mob - weaponSkill) > 10 then
		base = IsDualWielding() and 0.25 or 0.06
		factor = 0.004
	end
	return base + (mob - weaponSkill) * factor
end

function AttackTable.GetSkillRank(skillNameToFind)
	for i = 1, GetNumSkillLines() do
		local skillName, isHeader, _, skillRank, _, skillModifier = GetSkillLineInfo(i)
		if not isHeader and skillName == skillNameToFind then
			return skillRank + skillModifier
		end
	end
	return nil
end

function AttackTable.GetEquippedWeaponSkill(slot)
	local link = GetInventoryItemLink("player", slot)
	if not link then
		return nil
	end
	local _, _, _, _, _, _, itemSubType = GetItemInfo(link)
	if not itemSubType then
		return nil
	end
	return AttackTable.GetSkillRank(itemSubType)
end

function AttackTable.GetMissField()
	local missChances = {}
	local weaponSkills = { AttackTable.GetEquippedWeaponSkill(16), AttackTable.GetEquippedWeaponSkill(17) }
	for _, wSkill in ipairs(weaponSkills) do
		if wSkill ~= nil then
			table.insert(missChances, string.format("%.1f%%", AttackTable.GetMissChance(wSkill) * 100))
		end
	end
	return missChances
end
