--[[ Block (TBC, melee vs mob):

5% + (mob defense skill - player weapon skill)*.1%, capped at 5%

Only possible when attacking from the front, and only for mobs that carry a
shield (most mobs, and nearly all bosses, can't block). ]]
local Outgoing = AttackTable.Outgoing

function Outgoing.GetBlockChance(hand)
	if not (AttackTable.config.attackFromFront and AttackTable.config.targetCanBlock) then
		return 0
	end
	local block = 0.05 + Outgoing.GetSkillDiff(hand.skill) * 0.001
	return math.max(0, math.min(0.05, block))
end
