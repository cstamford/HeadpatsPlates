-- HeadpatsFrames:InitUnitFrameEvents
function HeadpatsFrames:InitUnitFrameEvents(frame)
    HeadpatsLib:InitUpdateTime(frame)
    frame:UpdateTimeTargets(HeadpatsLib:MsToSec(20), HeadpatsLib:MsToSec(50), HeadpatsLib:MsToSec(100))

    -- frame:InitEvents
    function frame:InitEvents()
        self:SetScript("OnEvent", function (_, evt, ...) self:OnEvent(evt, ...) end)
        self:SetScript("OnEnter", function(...) self:OnEnter() end)
        self:SetScript("OnLeave", function(...) self:OnLeave() end)
        self:RegisterUnitEvent("UNIT_AURA", self.Unit)
        self:RegisterUnitEvent("UNIT_HEALTH", self.Unit);
        self:RegisterUnitEvent("UNIT_MAXHEALTH", self.Unit);
    end

    -- frame:ClearEvents
    function frame:ClearEvents()
        self:SetScript("OnEvent", nil)
        self:UnregisterAllEvents();
    end

    -- frame:OnEvent
    function frame:OnEvent(evt, ...)
        if (evt == "UNIT_AURA") then
            self:OnUnitAura(...)
        elseif (evt == "UNIT_HEALTH") then
            self:OnUnitHealth(...)
        elseif (evt == "UNIT_MAXHEALTH") then
            self:OnUnitMaxHealth(...)
        end
    end

    -- frame:OnEnter
    function frame:OnEnter()
        GameTooltip_SetDefaultAnchor(GameTooltip, self)
        GameTooltip:SetUnit(self.Unit)
    end

    -- frame:OnLeave
    function frame:OnLeave()
        GameTooltip:FadeOut()
    end

    -- frame:OnUnitAura
    function frame:OnUnitAura(...)
        self.Auras:OnUnitAura(...)
    end

    -- frame:OnUnitHealth
    function frame:OnUnitHealth(...)
        self:UpdateHealthBar()
    end

    -- frame:OnUnitMaxHealth
    function frame:OnUnitMaxHealth(...)
        self:UpdateHealthBar()
    end
end
