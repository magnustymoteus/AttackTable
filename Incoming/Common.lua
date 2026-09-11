--[[ Shared helpers for the mob -> player melee attack table (TBC).

Mob attack skill = mob level * 5
levelDiff = mob attack skill - player level * 5 ]]
local Incoming = AttackTable.Incoming

-- Mob attack skill is the same as its defense skill
function Incoming.GetMobSkill()
	return AttackTable.GetTargetDefense()
end

function Incoming.GetLevelSkillDiff()
	return Incoming.GetMobSkill() - UnitLevel("player") * 5
end

function Incoming.GetDefense()
	local base, modifier = UnitDefense("player")
	return base + modifier
end

-- Dodge/parry/block from a character sheet percentage. The sheet assumes an
-- attacker of your own level; none of them happen from behind.
function Incoming.GetAvoidance(sheetChance)
	if not AttackTable.config.attackFromFront then
		return 0
	end
	return math.max(0, sheetChance / 100 - Incoming.GetLevelSkillDiff() * 0.0004)
end
