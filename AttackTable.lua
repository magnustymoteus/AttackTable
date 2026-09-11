AttackTable = AttackTable or {}

local frame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
frame:SetSize(200, 228)
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
	local currX = 10
	local text
	for _, col in ipairs(cols) do
		text = CreateText(col, currX, currY, 10)
		currX = currX + 100
	end
	currY = currY - 20
	return text
end

-- Order of the one-roll attack table: earlier outcomes push later ones off
-- the table once the total reaches 100%. Hit takes whatever is left.
local outcomes = {
	{ "Miss", AttackTable.GetMissChance },
	{ "Dodge", AttackTable.GetDodgeChance },
	{ "Parry", AttackTable.GetParryChance },
	{ "Glancing Blow", AttackTable.GetGlancingChance },
	{ "Block", AttackTable.GetBlockChance },
	{ "Crit", AttackTable.GetCritChance },
	{ "Crushing Blow", AttackTable.GetCrushingChance },
}

local function GetTitle()
	local target = "target"
	local level = UnitLevel(target)
	local name = UnitName(target)
	if level <= 0 then
		level = "??"
	end
	return name .. " (" .. level .. ")"
end

local function GetHandChances(hand)
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
		local row = { key, rows[key] }
		local text
		if key == "Title" then
			row = { rows[key] }
			text = BuildRow(row)
			text:SetFontHeight(12.5)
			currY = currY - 10
		else
			text = BuildRow(row)
		end
		rows[key] = text
	end
end

local function UpdateField(key, value)
	rows[key]:SetText(value)
end
local function UpdateTable()
	UpdateField("Title", GetTitle())
	local handChances = {}
	for _, hand in ipairs(AttackTable.GetHands()) do
		table.insert(handChances, GetHandChances(hand))
	end
	for _, key in ipairs(rowOrder) do
		if key ~= "Title" then
			local values = {}
			for _, chances in ipairs(handChances) do
				table.insert(values, string.format("%.1f%%", chances[key] * 100))
			end
			UpdateField(key, table.concat(values, "/"))
		end
	end
end

InitTable()

-- Parry and block only happen when attacking from the front
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
-- Weapon swaps, buffs and talents change skill/hit/expertise/crit
frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
frame:RegisterUnitEvent("UNIT_AURA", "player")
frame:SetScript("OnEvent", OnEvent)
