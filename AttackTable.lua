AttackTable = AttackTable or {}

local frame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
frame:SetSize(250, 248)
frame:SetBackdrop({ bgFile = "Interface/Tooltips/UI-Tooltip-Background" })
frame:SetBackdropColor(0, 0, 0, 0.8)
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
frame:SetPoint("CENTER")
frame:Hide()

local currY = -10
local columnX = { 10, 105, 185 }
-- Outgoing (your attacks on the mob) and incoming (the mob's attacks on you)
local COLUMN_HEADERS = { "", "Outgoing", "Incoming" }
local rowOrder = {
	"Title",
	"Miss",
	"Dodge",
	"Parry",
	"Glancing Blow",
	"Block",
	"Crit",
	"Crushing Blow",
	"Hit",
}
local rows = {
	["Title"] = "Title",
	["Miss"] = "X",
	["Dodge"] = "X",
	["Parry"] = "X",
	["Glancing Blow"] = "X",
	["Block"] = "X",
	["Crit"] = "X",
	["Crushing Blow"] = "X",
	["Hit"] = "X",
}

local function CreateText(str, posX, posY, fontHeight)
	local text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	text:SetPoint("TOPLEFT", frame, posX, posY)
	text:SetText(str)
	text:SetFontHeight(fontHeight)
	return text
end

local function BuildRow(cols)
	local texts = {}
	for i, col in ipairs(cols) do
		table.insert(texts, CreateText(col, columnX[i], currY, 10))
	end
	currY = currY - 20
	return texts
end

-- Order of the one-roll attack table: earlier outcomes push later ones off
-- the table once the total reaches 100%. Hit takes whatever is left.
local outcomeOrder = {
	{ "Miss", "GetMissChance" },
	{ "Dodge", "GetDodgeChance" },
	{ "Parry", "GetParryChance" },
	{ "Glancing Blow", "GetGlancingChance" },
	{ "Block", "GetBlockChance" },
	{ "Crit", "GetCritChance" },
	{ "Crushing Blow", "GetCrushingChance" },
}

-- side is AttackTable.Outgoing or AttackTable.Incoming
local function BuildOutcomes(side)
	local outcomes = {}
	for _, outcome in ipairs(outcomeOrder) do
		table.insert(outcomes, { outcome[1], side[outcome[2]] })
	end
	return outcomes
end

local outgoing = BuildOutcomes(AttackTable.Outgoing)
local incoming = BuildOutcomes(AttackTable.Incoming)

local function GetTitle()
	local target = "target"
	local level = UnitLevel(target)
	local name = UnitName(target)
	if level <= 0 then
		level = "??"
	end
	return name .. " (" .. level .. ")"
end

local function RollTable(outcomes, hand)
	local chances = {}
	local remaining = 1
	for _, outcome in ipairs(outcomes) do
		local key, getChance = outcome[1], outcome[2]
		chances[key] = math.min(getChance(hand), remaining)
		remaining = remaining - chances[key]
	end
	chances["Hit"] = remaining
	return chances
end

local function InitTable()
	for _, key in ipairs(rowOrder) do
		if key == "Title" then
			local text = BuildRow({ rows[key] })[1]
			text:SetFontHeight(12.5)
			currY = currY - 10
			rows[key] = text
			BuildRow(COLUMN_HEADERS)
		else
			local texts = BuildRow({ key, rows[key], rows[key] })
			rows[key] = { outgoing = texts[2], incoming = texts[3] }
		end
	end
end

local function FormatChance(chance)
	return string.format("%.1f%%", chance * 100)
end

local function UpdateTable()
	rows["Title"]:SetText(GetTitle())
	local handChances = {}
	for _, hand in ipairs(AttackTable.Outgoing.GetHands()) do
		table.insert(handChances, RollTable(outgoing, hand))
	end
	local incomingChances = RollTable(incoming)
	for _, key in ipairs(rowOrder) do
		if key ~= "Title" then
			local values = {}
			for _, chances in ipairs(handChances) do
				table.insert(values, FormatChance(chances[key]))
			end
			rows[key].outgoing:SetText(table.concat(values, "/"))
			rows[key].incoming:SetText(FormatChance(incomingChances[key]))
		end
	end
end

InitTable()

-- Applies both ways: mobs can't parry or block from behind, and you can't
-- dodge, parry or block attacks from behind
local toggle = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
toggle:SetSize(120, 20)
toggle:SetPoint("BOTTOM", frame, 0, 6)

local function UpdateToggleText()
	toggle:SetText(AttackTable.config.attackFromFront and "Position: Front" or "Position: Behind")
end

toggle:SetScript("OnClick", function()
	AttackTable.config.attackFromFront = not AttackTable.config.attackFromFront
	AttackTableDB.attackFromFront = AttackTable.config.attackFromFront
	UpdateToggleText()
	UpdateTable()
end)

local function UpdateFrame()
	if UnitExists("target") and UnitCanAttack("player", "target") then
		UpdateTable()
		frame:Show()
	else
		frame:Hide()
	end
end

local function OnEvent(self, event, addonName)
	if event == "ADDON_LOADED" then
		if addonName == "AttackTable" then
			AttackTableDB = AttackTableDB or {}
			if AttackTableDB.attackFromFront == nil then
				AttackTableDB.attackFromFront = true
			end
			AttackTable.config.attackFromFront = AttackTableDB.attackFromFront
			UpdateToggleText()
		end
		return
	end
	UpdateFrame()
end

-- Saved variables are only available once ADDON_LOADED fires
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_TARGET_CHANGED")
-- Weapon swaps, buffs and talents change skill/hit/expertise/crit/avoidance
frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
frame:RegisterUnitEvent("UNIT_AURA", "player")
frame:SetScript("OnEvent", OnEvent)
