-- HeadpatsPlates:InitNameplateEventFuncs
function HeadpatsPlates:InitNameplateEventFuncs(nameplate)
    HeadpatsLib:InitUpdateTime(nameplate)

    -- nameplate:InitEvents
    function nameplate:InitEvents()
        self:SetScript("OnEvent", function (plate, ...) plate:OnEventNameplate(...) end)
        self:SetScript("OnUpdate", function (plate, ...) plate:OnUpdate(...) end)
    
        -- Global events
        self:RegisterEvent("PLAYER_TARGET_CHANGED")
        self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
    
        -- Unit state
        self:RegisterUnitEvent("UNIT_AURA", self.Unit)
        self:RegisterUnitEvent("UNIT_HEALTH", self.Unit);
        self:RegisterUnitEvent("UNIT_MAXHEALTH", self.Unit);
        self:RegisterUnitEvent("UNIT_NAME_UPDATE", self.Unit)
        self:RegisterUnitEvent("UNIT_THREAT_LIST_UPDATE", self.Unit);
        self:RegisterUnitEvent("UNIT_THREAT_SITUATION_UPDATE", self.Unit)
    
        -- Unit casting
        self:RegisterUnitEvent("UNIT_SPELLCAST_START", self.Unit)
        self:RegisterUnitEvent("UNIT_SPELLCAST_STOP", self.Unit)
        self:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", self.Unit)
        self:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", self.Unit)
    end

    -- nameplate:ClearNameplateEvents
    function nameplate:ClearNameplateEvents()
        self:SetScript("OnEvent", nil)
        self:SetScript("OnUpdate", nil)
        self:UnregisterAllEvents();
    end

    -- nameplate:OnEventNameplate
    function nameplate:OnEventNameplate(evt, ...)
        -- Global events
        if (evt == "PLAYER_TARGET_CHANGED") then
            self:OnPlayerTargetChanged(...)
        elseif (evt == "UPDATE_MOUSEOVER_UNIT") then
            self:OnUpdateMouseoverUnit(...)

        -- Unit state
        elseif (evt == "UNIT_AURA") then
            self:OnUnitAura(...)
        elseif (evt == "UNIT_HEALTH") then
            self:OnUnitHealth(...)
        elseif (evt == "UNIT_MAXHEALTH") then
            self:OnUnitMaxHealth(...)
        elseif (evt == "UNIT_NAME_UPDATE") then
            self:OnUnitNameUpdate(...)
        elseif (evt == "UNIT_THREAT_LIST_UPDATE") then
            self:OnUnitThreatUpdate(...)
        elseif (evt == "UNIT_THREAT_SITUATION_UPDATE") then
            self:OnUnitThreatUpdate(...)

        -- Unit casting
        elseif (evt == "UNIT_SPELLCAST_START") then
            self:OnUnitSpellcastStart(HeadpatsLib:MakeCastInfoCast(self.Unit), ...)
        elseif (evt == "UNIT_SPELLCAST_STOP") then
            self:OnUnitSpellcastStop(...)
        elseif (evt == "UNIT_SPELLCAST_CHANNEL_START") then
            self:OnUnitSpellcastChannelStart(HeadpatsLib:MakeCastInfoChannel(self.Unit), ...)
        elseif (evt == "UNIT_SPELLCAST_CHANNEL_STOP") then
            self:OnUnitSpellcastChannelStop(...)
        end
    end

    -- nameplate:OnUpdate
    function nameplate:OnUpdate(dt)
        -- Check if version mismatch - if there is we need to remake the nameplate!
        if (self.Version ~= HeadpatsPlates.Version) then
            self.Version = HeadpatsPlates.Version
            self:ResetToDefault()
        end

        -- Get the time and update the state (to know which updates we should do).
        self:UpdateTimeState(GetTime())

        -- UpdateTimeImportant: Use for things that require smooth updating, like animations.
        if (self.UpdateImportantReady) then
            -- Update the cast bar state - this is the smooth bar animation
            self:UpdateCastBar()
        end

        -- UpdateTimeNormal: Use for things that need to be responsive but not time critical.
        if (self.UpdateNormalReady) then
            -- If we're in range we use Blizzard's alpha for occlusion and other benefits.
            self:SetAlpha(self.InRange and self.BlizzFrame:GetAlpha() or HeadpatsPlatesLayout.RangeCheckFailAlpha)

            -- Update the special aura used for dispels and rotations.
            self:UpdateSpecialAura()

            -- We detour the pixel glow updates so we can manually tick them for perf reasons. We tick them here.
            HeadpatsLib:UpdatePixelGlow(self.CastBar, self.UpdateNormalDt)
            HeadpatsLib:UpdatePixelGlow(self.Aura.Icon, self.UpdateNormalDt)
        end

        -- UpdateTimeSlow: Use for things that are expensive and infrequent and can be updated slowly.
        if (self.UpdateSlowReady) then
            -- Update the highlight backdrop to be visible or not depending on highlighting.
            -- We do this here as well as the event because the event doesn't fire when we drop a highlight.
            -- This gets us immediate responsiveness from the event without sticky highlighting issues!
            self:UpdateHover()

            -- We can't use Blizzard's alpha value because it fades from camera to plate rather than character to plate.
            self:UpdateRange()

            if (self.CastInfo) then
                -- Update the cast bar text if we're casting - e.g. target, spell cast time, etc.
                self:UpdateCastBarText()
            end

            -- Update the unit's threat. We have to poll this because of a bug, see
            -- https://wowwiki-archive.fandom.com/wiki/API_UnitDetailedThreatSituation
            -- When mobs are socially pulled (ie they aggro indirectly, as a result of another nearby mob being pulled),
            -- 'status' often sets to 0 instead of 3, despite the player having aggro.
            local threatLast = self.HasThreat
            self:UpdateThreat()
            if (not threatLast and self.HasThreat) then
                -- Let's call the threat update function which "does the right thing".
                self:OnUnitThreatUpdate()
            end

            -- Update dev-only things to help with debugging.
            if (HeadpatsPlates.DevMode and HeadpatsPlates.DevCastTest) then
                self:UpdateDevCastTest()
            end
        end
    end

    -- nameplate:OnPlayerTargetChanged
    function nameplate:OnPlayerTargetChanged(...)
        self:SetTargetedByPlayer()
        self:SetDynamicSize()
        self:UpdateTimeIntervals()
        self:UpdateVisibility()
        self:UpdateDrawOrder()
        self:UpdateSpecialAura()
    end

    -- nameplate:OnUpdateMouseoverUnit
    function nameplate:OnUpdateMouseoverUnit(...)
        self:UpdateHover()
    end

    -- nameplate:OnUnitAura
    function nameplate:OnUnitAura(unitTarget, updateInfo, ...)
        self.Auras:OnUnitAura(unitTarget, updateInfo)
    end

    -- nameplate:OnUnitHealth
    function nameplate:OnUnitHealth(...)
        self:UpdateHealthBar()
    end

    -- nameplate:OnUnitMaxHealth
    function nameplate:OnUnitMaxHealth(...)
        self:UpdateHealthBar()
    end

    -- nameplate:OnUnitNameUpdate
    function nameplate:OnUnitNameUpdate(...)
        self:UpdateHealthBarText()
    end

    -- nameplate:OnUnitThreatUpdate
    function nameplate:OnUnitThreatUpdate(...)
        self:UpdateThreat()
        self:UpdateVisibility()
    end

    -- nameplate:OnUnitSpellcastStart
    function nameplate:OnUnitSpellcastStart(castInfo, ...)
        self.CastInfo = castInfo
    end

    -- nameplate:OnUnitSpellcastStop
    function nameplate:OnUnitSpellcastStop(...)
        self.CastInfo = nil
    end

    -- nameplate:OnUnitSpellcastChannelStart
    function nameplate:OnUnitSpellcastChannelStart(castInfo, ...)
        self.CastInfo = castInfo
    end

    -- nameplate:OnUnitSpellcastChannelStop
    function nameplate:OnUnitSpellcastChannelStop(...)
        self.CastInfo = nil
    end
end
