--[[ Shared by the outgoing (player -> mob) and incoming (mob -> player) tables (TBC).

Mob defense skill and attack skill = mob level * 5.
Skull (??) mobs are treated as player level + 3 (level 73 bosses at 70).

Chances are returned as fractions (0.05 = 5%). ]]
AttackTable = AttackTable or {}
AttackTable.Outgoing = AttackTable.Outgoing or {}
AttackTable.Incoming = AttackTable.Incoming or {}

AttackTable.config = {
	-- Parry and block only happen when facing each other (and, for players, dodge)
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
