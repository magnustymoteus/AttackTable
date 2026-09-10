local frame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
frame:SetSize(200, 200)
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

local function GetTitle()
	local target = "target"
	local level = UnitLevel(target)
	local name = UnitName(target)
	return name .. " (" .. level .. ")"
end

local function InitTable()
	for _, key in ipairs(rowOrder) do
		local row = { key, rows[key] }
		local text
		if key == "Title" then
			row = { rows[key] }
			text = BuildRow(row)
			currY = currY - 10
		else
			text = BuildRow(row)
		end
		rows[key] = text
	end
end

InitTable()

local function UpdateFrame()
	if UnitExists("target") and UnitCanAttack("player", "target") then
		rows["Title"]:SetText(GetTitle())
		frame:Show()
	else
		frame:Hide()
	end
end

frame:RegisterEvent("PLAYER_TARGET_CHANGED")
frame:SetScript("OnEvent", UpdateFrame)
