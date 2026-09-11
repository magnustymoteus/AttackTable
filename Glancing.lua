--[[ Glancing Blow (TBC, white melee vs mob):

6% + (mob defense skill - player weapon skill)*1.2%, minimum 0%
    weapon skill is capped at player level * 5

Only white (auto attack) swings can glance; yellow attacks never do.
Level 73 boss with 350 skill: 24% ]]
AttackTable = AttackTable or {}

function AttackTable.GetGlancingChance(hand)
	local skill = math.min(hand.skill, UnitLevel("player") * 5)
	return math.max(0, 0.06 + AttackTable.GetSkillDiff(skill) * 0.012)
end
