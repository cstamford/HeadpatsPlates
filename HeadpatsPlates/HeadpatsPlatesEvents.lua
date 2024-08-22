-- HeadpatsPlates:InitEvents
function HeadpatsPlates:InitEvents()
    self.DriverFrame:SetScript("OnEvent", function (_, evt, ...) self:OnEventAddon(evt, ...) end)

    -- Global events
    self.DriverFrame:RegisterEvent("NAME_PLATE_CREATED")
    self.DriverFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
    self.DriverFrame:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
    self.DriverFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    self.DriverFrame:RegisterEvent("VARIABLES_LOADED")

    -- Unit state
    self.DriverFrame:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
end

-- HeadpatsPlates:OnEventAddon
function HeadpatsPlates:OnEventAddon(evt, ...)
    -- Global events
    if (evt == "NAME_PLATE_CREATED") then
        self:OnNamePlateCreated(...)
    elseif (evt == "NAME_PLATE_UNIT_ADDED") then
        self:OnNamePlateUnitAssigned(...)
    elseif (evt == "NAME_PLATE_UNIT_REMOVED") then
        self:OnNamePlateUnitUnassigned(...)
    elseif (evt == "PLAYER_ENTERING_WORLD") then
        self:OnPlayerEnteringWorld(...)
    elseif (evt == "VARIABLES_LOADED") then
        self:OnVariablesLoaded(...)

    -- Unit state
    elseif (evt == "UNIT_POWER_UPDATE") then
        self:OnUnitPowerUpdate(...)
    end
end

-- HeadpatsPlates:OnNamePlateCreated
function HeadpatsPlates:OnNamePlateCreated(frame)
    frame.HeadpatsPlatesNameplate = HeadpatsPlatesLayout:CreateNameplate(frame)
    frame.HeadpatsPlatesNameplate:SetScale(HeadpatsLib.ScaleFactor)

    -- Setup funcs on this nameplate
    self:InitNameplateFuncs(frame.HeadpatsPlatesNameplate)
    self:InitNameplateEventFuncs(frame.HeadpatsPlatesNameplate)
    self:InitNameplateRotationFuncs(frame.HeadpatsPlatesNameplate)

    -- Register the nameplate with our internal tracker.
    self:RegisterNameplate(frame.HeadpatsPlatesNameplate)

    if (HeadpatsPlates.DevMode and HeadpatsPlates.DevDrawClickable) then
        frame.HeadpatsPlatesClickable = HeadpatsPlatesLayout:CreateClickableArea(frame)
        frame.HeadpatsPlatesClickable:SetScale(HeadpatsLib.ScaleFactor)
    end
end

-- HeadpatsPlates:OnNamePlateUnitAssigned
function HeadpatsPlates:OnNamePlateUnitAssigned(token, ...)
    if (not self:CanAssignNameplate(token)) then
        return
    end

    local frame = C_NamePlate.GetNamePlateForUnit(token)
    if (not frame) then return end

    frame.HeadpatsPlatesNameplate:Assign(token)
    if (HeadpatsPlates.DevMode and HeadpatsPlates.DevDrawClickable) then
        frame.HeadpatsPlatesClickable:Show()
    end

    HeadpatsLib:HideBlizzardFrame(frame.UnitFrame)
    self.ActiveNameplatesCount = self.ActiveNameplatesCount + 1
end

-- HeadpatsPlates:OnNamePlateUnitUnassigned
function HeadpatsPlates:OnNamePlateUnitUnassigned(token, ...)
    local frame = C_NamePlate.GetNamePlateForUnit(token)
    if (not frame) then return end

    local assigned = frame.HeadpatsPlatesNameplate:IsAssigned()

    frame.HeadpatsPlatesNameplate:Unassign()
    frame.HeadpatsPlatesNameplate:Hide()
    if (HeadpatsPlates.DevMode and HeadpatsPlates.DevDrawClickable) then
        frame.HeadpatsPlatesClickable:Hide()
    end

    self.ActiveNameplatesCount = self.ActiveNameplatesCount - (assigned and 1 or 0)
end

-- HeadpatsPlates:OnPlayerEnteringWorld
function HeadpatsPlates:OnPlayerEnteringWorld(...)
    HeadpatsPlates:SetAreaData(select(8, GetInstanceInfo()))
    self:UpdatePlayerMana()
end

-- HeadpatsPlates:OnVariablesLoaded
function HeadpatsPlates:OnVariablesLoaded(...)
    self:UpdateCVars()
end

-- HeadpatsPlates:OnUnitPowerUpdate
function HeadpatsPlates:OnUnitPowerUpdate(_, type, ...)
    if (type == "MANA") then
        self:UpdatePlayerMana()
    end
end
