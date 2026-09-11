--[[ Glancing Blow:

Only players land glancing blows, so a mob's attacks on you never glance. ]]
local Incoming = AttackTable.Incoming

function Incoming.GetGlancingChance()
	return 0
end
