--[[ Block (TBC, mob melee vs player):

character sheet block - levelDiff*.04%
    the sheet value already includes defense, talents and buffs like Shield
    Block or Holy Shield, and is 0 without a shield

Only possible when facing the mob. ]]
local Incoming = AttackTable.Incoming

function Incoming.GetBlockChance()
	return Incoming.GetAvoidance(GetBlockChance())
end
