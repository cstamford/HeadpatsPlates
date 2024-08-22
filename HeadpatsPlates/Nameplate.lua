-- HeadpatsPlates:InitNameplateFuncs(nameplate)
function HeadpatsPlates:InitNameplateFuncs(nameplate)
    nameplate.Auras = {}
    HeadpatsLib:InitAuraCache(nameplate.Auras)

    -- we only allow debuffs applied by us
    nameplate.Auras:SetFilterCallback(function(aura)
        return aura.sourceUnit and aura.isHarmful and UnitIsUnit(aura.sourceUnit, "player") 
    end)

    -- In dev mode, we print debug info for applied auras.
    if (HeadpatsPlates.DevMode) then
        local logFn = function(txt) HeadpatsPlates:LogDebug(txt) end
        nameplate.Auras:SetAddedCallback(function(aura) nameplate.Auras:DebugPrintAura(nameplate.Unit, aura, "00FF00", logFn) end)
        nameplate.Auras:SetRemovedCallback(function(aura) nameplate.Auras:DebugPrintAura(nameplate.Unit, aura, "FF0000", logFn) end)
    end

    -- nameplate:Assign
    function nameplate:Assign(unit)
        local guid = HeadpatsLib:MakeCreatureGuid(UnitGUID(unit))

        self.BlizzFrame = C_NamePlate.GetNamePlateForUnit(unit)
        self.CastInfo = HeadpatsLib:MakeCastInfoCastOrChannel(unit)
        self.CastInfoValidLastTick = false
        self.IsMinion = UnitClassification(unit) == "minus"
        self.IsSpiteful = guid.NpcId == 174773
        self.Unit = unit
        self.UnitHidden = HeadpatsPlates.HiddenMob[guid.NpcId]
        self.UnitNameplateId = gsub(unit, "nameplate", "")
        self.UnitGuid = guid
        self.Version = HeadpatsPlates.Version

        self:InitEvents()
        self:ResetToDefault()
    end

    -- nameplate:Unassign
    function nameplate:Unassign()
        self.Unit = nil
        self:ClearNameplateEvents()
    end

    -- nameplate:ResetToDefault
    function nameplate:ResetToDefault()
        self:SetEmphasis()
        self:SetTargetedByPlayer()
        self:SetDynamicSize()
        self:SetDefaultVisibility()
        self:SetDefaultCastBarState()
        self:SetDefaultHealthBarState()
        self:SetDefaultAuras()
        self:SetDefaultAuraState()
        self:UpdateThreat()
        self:UpdateCastBar()
        self:UpdateHealthBar()
        self:UpdateHealthBarText()
        self:UpdateRange()
        self:UpdateTimeIntervals()
        self:UpdateVisibility()
        self:UpdateDrawOrder()
    end
    
    -- nameplate:SetDefaultCastBarState
    function nameplate:SetDefaultCastBarState()
        self.CastBar:SetMinMaxValues(0, 1)
        self.CastBar:SetValue(0)
        self.CastBar.Text:SetText(nil)
        self.CastBar.CastTargetText:SetText(nil)
        self.CastBar.CastTimeText:SetText(nil)

        HeadpatsLib:RestorePixelGlowHandler(self.CastBar)
        HeadpatsLib.LCG.PixelGlow_Stop(self.CastBar)
    end
 
    -- nameplate:SetDefaultHealthBarState
    function nameplate:SetDefaultHealthBarState()
        self.HealthBar:SetMinMaxValues(0, 1)
        self.HealthBar:SetValue(1)
        self.HealthBar.Text:SetText(nil)

        local col = self.HealthBar.Colour
        self.HealthBar:SetStatusBarColor(col.R, col.G, col.B, col.A)

        HeadpatsLib:ShowOrHide(self.HealthBar.Text, HeadpatsPlatesLayout.DrawNameText and self.IsEmphasized)
    end

    -- nameplate:SetDefaultAuras
    function nameplate:SetDefaultAuras()
        self.Auras:Populate(self.Unit)
    end

    -- nameplate:SetDefaultAuraState
    function nameplate:SetDefaultAuraState()
        self.SpecialAuraGlowIcon = nil
        HeadpatsLib:RestorePixelGlowHandler(self.Aura.Icon)
        HeadpatsLib.LCG.PixelGlow_Stop(self.Aura.Icon)
    end

    -- nameplate:SetDefaultVisibility
    function nameplate:SetDefaultVisibility()
        self:Show()
        self.Background:Show()
        self.HealthBar:Show()
        self.HealthBar.Text:Show()
        self.CastBar:Show()
        self.CastBar.Text:Show()
        self.CastBar.CastTargetText:Show()
        self.CastBar.CastTimeText:Show()
        self.Selected:Hide()
        self.Aura:Hide()
        self.Aura.Background:Show()
        self.Aura.Icon:Show()
        self.Aura.Hover:Hide()
        self.Aura.Selected:Hide()
    end

    -- nameplate:SetEmphasis
    function nameplate:SetEmphasis()
        local npcId = self.UnitGuid.NpcId
        local emAware = HeadpatsPlates.EmphasizeAware[npcId] or self.IsSpiteful
        local emBoss = HeadpatsPlates.EmphasizeBoss[npcId]
        local emMob = HeadpatsPlates.EmphasizeMob[npcId]

        self.IsBoss = emBoss
        self.IsEmphasized = emMob or emBoss or emAware
        self.HealthBar.Colour = not self.IsEmphasized and HeadpatsPlatesLayout.HealthBar.Colour or
            emAware and HeadpatsPlatesLayout.HealthBar.AwareColour or
            emBoss and HeadpatsPlatesLayout.HealthBar.BossColour or
            HeadpatsPlatesLayout.HealthBar.MobColour
    end

    -- nameplate:SetTargetedByPlayer
    function nameplate:SetTargetedByPlayer()
        self.IsTargetedByPlayer = UnitIsUnit(self.Unit, "target")
    end

    -- nameplate:SetDynamicSize
    function nameplate:SetDynamicSize()
        local size = self.IsEmphasized and HeadpatsPlatesLayout.EmphasisSize or HeadpatsPlatesLayout.Size

        if (self.IsTargetedByPlayer) then
            local scale = self.IsTargetedByPlayer and
                self.IsEmphasized and HeadpatsPlatesLayout.EmphasizedSelectedScale or HeadpatsPlatesLayout.SelectedScale
                or 1

            size = HeadpatsLib:Copy(size)
            size.Width = size.Width * scale
            size.Height = size.Height * scale
        end

        self:SetSize(size.Width, size.Height)
    end

    -- nameplate:UpdateDevCastTest
    -- Handle simulating casts (start and stop) for testing purposes!
    function nameplate:UpdateDevCastTest()
        local timeInMs = HeadpatsLib:SecToMs(GetTime())
        if (self.CastInfo) then
            if (timeInMs >= self.CastInfo.EndTime) then
                self:OnUnitSpellcastStop(self.CastInfo)
                self.DevNextFakeCast = timeInMs + random(1000)
            end
        elseif (self.DevNextFakeCast == nil or timeInMs >= self.DevNextFakeCast) then
            local spellId = HeadpatsPlates.DevCastSpellIds[random(#HeadpatsPlates.DevCastSpellIds)]
            local castName = C_Spell.GetSpellInfo(spellId).name
            local castTime = C_Spell.GetSpellInfo(spellId).castTime
            local castInfo = HeadpatsLib:MakeCastInfo(castName, castName, timeInMs, timeInMs + castTime, random(1) == 0, spellId)
            self:OnUnitSpellcastStart(castInfo)
        end
    end

    -- nameplate:UpdateRange
    function nameplate:UpdateRange()
        local spell = HeadpatsPlates.ClassData:GetRangeCheckAbility()
        self.InRange = spell and C_Spell.IsSpellInRange(spell, self.Unit)
    end

    -- nameplate:UpdateHover
    function nameplate:UpdateHover()
        local needHighlight = UnitIsUnit(self.Unit, "mouseover")
        HeadpatsLib:ShowOrHide(self.Hover, needHighlight)
        HeadpatsLib:ShowOrHide(self.Aura.Hover, needHighlight)
    end

    -- nameplate:UpdateHealthBar
    function nameplate:UpdateHealthBar()
        self.Health = UnitHealth(self.Unit)
        self.MaxHealth = UnitHealthMax(self.Unit)
        self.HealthPercent = self.Health / self.MaxHealth * 100
        self.HealthBar:SetMinMaxValues(0, self.MaxHealth)
        self.HealthBar:SetValue(self.Health)
    end

    -- nameplate:UpdateHealthBarCastingVisiblity
    function nameplate:UpdateHealthBarCastingVisiblity()
        HeadpatsLib:ShowOrHide(self.HealthBar, not self.CastInfo or not self.CastInfo.Important)
    end

    -- nameplate:UpdateHealthBarText
    function nameplate:UpdateHealthBarText()
        self.HealthBar.Text:SetText(UnitName(self.Unit))
    end

    -- nameplate:UpdateCastBar
    function nameplate:UpdateCastBar()
        local startedCasting = not self.CastInfoValidLastTick and self.CastInfo
        local stoppedCasting = self.CastInfoValidLastTick and not self.CastInfo

        if (startedCasting) then
            self:UpdateCastBarStartedCasting()
        elseif (stoppedCasting) then
            self:UpdateCastBarStoppedCasting()
        end

        if (self.CastInfo and self.CastInfo.Important) then
            self.CastBar:SetValue(min(HeadpatsLib:SecToMs(GetTime()), self.CastInfo.EndTime))
        end

        self.CastInfoValidLastTick = self.CastInfo ~= nil
    end

    -- nameplate:UpdateCastBarStartedCasting
    -- Note: Assumes there is a cast running, should only be called if there is.
    function nameplate:UpdateCastBarStartedCasting()
        self.CastInfo.Aware = HeadpatsPlates.CastAware[self.CastInfo.SpellId]
        self.CastInfo.Interrupt = HeadpatsPlates.CastInterrupt[self.CastInfo.SpellId]
        self.CastInfo.Important = self.IsBoss or self.CastInfo.Aware or self.CastInfo.Interrupt
    
        self.CastBar.Text:SetText(self.IsEmphasized and self.CastInfo.Important and self.CastInfo.Text or nil)
        self.CastBar:SetMinMaxValues(self.CastInfo.StartTime, self.CastInfo.EndTime)

        -- Bar colour depending on importance
        local col = self.CastInfo.Interrupt and HeadpatsPlatesLayout.CastBar.InterruptColour or 
        self.CastInfo.Aware and HeadpatsPlatesLayout.CastBar.AwareColour or
            HeadpatsPlatesLayout.CastBar.Colour

        self.CastBar:SetStatusBarColor(col.R, col.G, col.B, col.A)

        -- Glows for flagged spells
        if (self.CastInfo.Important) then
            local frameLevel = 1
            HeadpatsLib.LCG.PixelGlow_Start(self.CastBar, { col.R, col.G, col.B, col.A },
                nil, nil, nil, nil, nil, nil, nil, nil, frameLevel)
            HeadpatsLib:ClearPixelGlowHandler(self.CastBar)
        end

        -- Visibility for target/time
        HeadpatsLib:ShowOrHide(self.CastBar.CastTargetText, HeadpatsPlatesLayout.DrawCastTarget)
        HeadpatsLib:ShowOrHide(self.CastBar.CastTimeText, HeadpatsPlatesLayout.DrawCastTimer)

        self:UpdateCastBarText() 
        self:UpdateHealthBarCastingVisiblity() 
    end

    -- nameplate:UpdateCastBarStoppedCasting
    function nameplate:UpdateCastBarStoppedCasting()
        self:SetDefaultCastBarState()
        self:UpdateHealthBarCastingVisiblity()
    end

    -- nameplate:UpdateCastBarText
    -- Note: Assumes there is a cast running, should only be called if there is.
    function nameplate:UpdateCastBarText()
        local unitTargetId = (HeadpatsPlates.DevMode and HeadpatsPlates.DevCastTargetPlayer) and "player" or self.Unit .. "target"
        local unitTargetName = UnitIsPlayer(unitTargetId) and GetClassColoredTextForUnit(unitTargetId, UnitName(unitTargetId)) or nil
        self.CastBar.CastTargetText:SetText(self.CastInfo.Important and unitTargetName or nil)

        local spellTimeLeft = HeadpatsLib:MsToSec(select(2, self.CastBar:GetMinMaxValues()) - self.CastBar:GetValue())
        local spellTimeLeftRounded = floor(spellTimeLeft * 10) / 10 -- round to 1 decimal place
        self.CastBar.CastTimeText:SetText(self.CastInfo.Important and spellTimeLeftRounded or nil)
    end

    -- nameplate:UpdateTimeIntervals
    function nameplate:UpdateTimeIntervals()
        local multiplier = 1
    
        if (self.IsTargetedByPlayer or self.IsBoss) then
            multiplier = HeadpatsPlates.UpdateTimeHighPriorityMultiplier
        elseif (self.Hidden) then
            multiplier = HeadpatsPlates.UpdateTimeHiddenMultiplier
        elseif (not self.IsEmphasized) then
            multiplier = HeadpatsPlates.UpdateTimeLowPriorityMultiplier
        end

        self:UpdateTimeTargets(
            HeadpatsPlates.UpdateTimeImportant * multiplier,
            HeadpatsPlates.UpdateTimeNormal * multiplier,
            HeadpatsPlates.UpdateTimeSlow * multiplier)
    end

    -- nameplate:UpdateVisibility
    function nameplate:UpdateVisibility()
        self.Hidden = not self.HasThreat

        if (not self.IsSpiteful) then
            self.Hidden = self.Hidden and not self.IsTargetedByPlayer and (self.UnitHidden or self.IsMinion)
        end

        HeadpatsLib:ShowOrHide(self, not self.Hidden)
        HeadpatsLib:ShowOrHide(self.Selected, self.IsTargetedByPlayer)
        HeadpatsLib:ShowOrHide(self.Aura.Selected, self.IsTargetedByPlayer)
    end

    -- nameplate:UpdateThreat
    function nameplate:UpdateThreat()
        self.HasThreat = select(3, UnitDetailedThreatSituation("player", self.Unit)) == 100
    end

    -- nameplate:UpdateDrawOrder
    function nameplate:UpdateDrawOrder()
        -- To make sure the order of plates are "whole" between them, we use the ID to set a base frame level.
        -- We emphasize the current target to make sure they are always in front.
        -- TODO: "Max plates" is a veeery loose approximation, it will probably fail in cases where we have hidden plates of many tiny mobs
        local maxPlates = 20
        local maxLevelsPerPlate = 20
        local plateId = self.IsTargetedByPlayer and maxPlates + 1 or self.UnitNameplateId
        self:SetFrameLevel(plateId * maxLevelsPerPlate)
    end

    -- nameplate:UpdateSpecialAura
    function nameplate:UpdateSpecialAura()
        local spellIcon, glowColour, alpha, scale, placement, relToPlacement, fitBar = self:SelectSpecialAuraToShow()

        if (spellIcon) then
            self.Aura:Show()
            self.Aura:SetAlpha(alpha)
            self.Aura:SetScale(scale)
            local smallestDim = min(self:GetWidth(), self:GetHeight()) + (fitBar and 0 or 32)
            self.Aura:SetSize(smallestDim, smallestDim)
            self.Aura:ClearAllPoints()
            self.Aura:SetPoint(relToPlacement, self, placement, fitBar and 0 or 0, 0)
            self.Aura.Icon.Texture:SetTexture(spellIcon)

            if (glowColour and (not HeadpatsLib:HasOurPixelGlow(self.Aura.Icon) or self.SpecialAuraGlowIcon ~= spellIcon)) then
                local frameLevel = 1
                HeadpatsLib.LCG.PixelGlow_Start(self.Aura.Icon, 
                    { glowColour.R, glowColour.G, glowColour.B, glowColour.A },
                    nil, nil, nil, nil, nil, nil, nil, nil, frameLevel)
                HeadpatsLib:ClearPixelGlowHandler(self.Aura.Icon)
                self.SpecialAuraGlowIcon = spellIcon
            end
        else
            self.Aura:Hide()
        end

        if (not spellIcon or not glowColour) then
            self:SetDefaultAuraState()
        end
    end

    -- nameplate:IsAssigned
    function nameplate:IsAssigned()
        return self.Unit ~= nil
    end
end
