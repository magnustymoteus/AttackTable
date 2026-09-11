--[[ Dodge (TBC, mob melee vs player):

character sheet dodge - levelDiff*.04%
    the sheet value already includes defense, talents and buffs, and assumes an
    attacker of your own level

Only possible when facing the mob (you can't dodge attacks from behind). ]]
local Incoming = AttackTable.Incoming

function Incoming.GetDodgeChance()
	return Incoming.GetAvoidance(GetDodgeChance())
end
