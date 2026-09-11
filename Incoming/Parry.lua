--[[ Parry (TBC, mob melee vs player):

character sheet parry - levelDiff*.04%
    the sheet value already includes defense, talents and buffs, and assumes an
    attacker of your own level; it is 0 for classes that can't parry

Only possible when facing the mob. ]]
local Incoming = AttackTable.Incoming

function Incoming.GetParryChance()
	return Incoming.GetAvoidance(GetParryChance())
end
