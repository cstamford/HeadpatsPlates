local HeadpatsFramesClassDruid = HeadpatsLib.Class["DRUID"]
HeadpatsFramesClassDruid.HPF_RangeCheckSpell = "Rejuvenation"

-- HeadpatsFramesClassDruid:HPF_Update
-- This function is called once per update interval
function HeadpatsFramesClassDruid:HPF_Update()
    self.LifebloomCount = HeadpatsFrames:CountWhere(function(frame) return
        not self:_NeedsLifeBloom(frame.Auras)
    end)

    self.LowestHPFrame = HeadpatsFrames.FrameCache[HeadpatsFrames:LowestHealthFrame()]

    self.LowestHPNonTankFrame = HeadpatsFrames.FrameCache[HeadpatsFrames:LowestHealthFrameWhere(function(frame)
        return frame ~= HeadpatsFrames.TankFrame and frame.HealthPercent <= 75
    end)]

    self.LowHPPlayers = HeadpatsFrames:CountWhere(function(frame)
        return frame ~= HeadpatsFrames.TankFrame and frame.HealthPercent <= 75
    end)

    -- External swarm target is set by a WeakAura
    self.SwarmTarget = getglobal("HeadpatsFramesSwarmTarget")
end

-- HeadpatsFramesClassDruid:HPF_SelectFrameIcons
-- This function is called once per frame per update interval.
-- Returns { icon1, ... } as string names
function HeadpatsFramesClassDruid:HPF_SelectFrameIcons(frame)
    local ret = {}

    -- Don't show anything on ded ppl! 
    -- TODO: Show if CR is available
    if (frame.Dead) then
        return ret
    end

    -- * Dispel icon if it's ready
    if (frame.DispellableAura and HeadpatsLib:SpellReadyOrOnGCD(88423)) then
        table.insert(ret, "Nature's Cure")
    end

    -- * About to die, regrowth with NS
    local clearcasting = HeadpatsFrames.PlayerFrame.Auras:GetAuraBySpellId(16870)
    local regrowthLowNs = frame.HealthPercent <= 35 and (HeadpatsLib:SpellReadyOrOnGCD(132158) or clearcasting)

    if (regrowthLowNs) then
        table.insert(ret, "Regrowth")
    end

    -- * Adaptive swarm target
    if (self.SwarmTarget and UnitIsUnit(frame.Unit, self.SwarmTarget)) then
        table.insert(ret, "Adaptive Swarm")
    end

    -- * Role specific auras
    if (HeadpatsFrames.TankFrame == frame) then
        self:_GetTankIcons(frame, ret)
    else
        self:_GetNonTankIcons(frame, ret)
    end

    -- * Self only auras
    if (HeadpatsFrames.PlayerFrame == frame) then
        self:_GetSelfIcons(frame, ret)
    end

    return ret
end

-- HeadpatsFramesClassDruid:HPF_SetSecureAttributes
function HeadpatsFramesClassDruid:HPF_SetSecureAttributes(frame)
    -- Left click: Rejuvenation
    frame:SetAttribute("type-leftclick", "spell")
    frame:SetAttribute("spell-leftclick", "Rejuvenation")

    -- Shift left click: Regrowth
    frame:SetAttribute("shift-type-leftclick", "spell")
    frame:SetAttribute("shift-spell-leftclick", "Regrowth")

    -- Ctrl left click: Regrowth with NS
    frame:SetAttribute("ctrl-type-leftclick", "macro")
    frame:SetAttribute("ctrl-macrotext-leftclick", "/cast Nature's Swiftness\n/cast [@mouseover] Regrowth")

    -- Right click: Lifebloom
    frame:SetAttribute("type-rightclick", "spell")
    frame:SetAttribute("spell-rightclick", "Lifebloom")

    -- Shift right click: Cenarion ward
    frame:SetAttribute("shift-type-rightclick", "spell")
    frame:SetAttribute("shift-spell-rightclick", "Cenarion Ward")
end

-- HeadpatsFramesClassDruid:HPF_UpdateLeftBar
-- Show first rejuv
function HeadpatsFramesClassDruid:HPF_UpdateLeftBar(frame, bar)
    self:_UpdateBarLayout(frame, bar, 1, HeadpatsFramesLayout.LeftBar.StatusBar.Colour)
    local normalRejuv = self:_GetMyAura(frame.Auras, 774)
    local germRejuv = self:_GetMyAura(frame.Auras, 155777)
    local hot = (normalRejuv and germRejuv) and
        (normalRejuv.expirationTime > germRejuv.expirationTime and normalRejuv or germRejuv) or
        (normalRejuv or germRejuv)
    local value = hot and max((hot.expirationTime - HeadpatsFrames.UpdateTime) / hot.duration, 0) or 0
    bar.StatusBar:SetValue(value)
    return value ~= 0
end

-- HeadpatsFramesClassDruid:HPF_UpdateRightBar
-- Show second rejuv
function HeadpatsFramesClassDruid:HPF_UpdateRightBar(frame, bar)
    self:_UpdateBarLayout(frame, bar, -1, HeadpatsFramesLayout.RightBar.StatusBar.Colour)
    local normalRejuv = self:_GetMyAura(frame.Auras, 774)
    local germRejuv = self:_GetMyAura(frame.Auras, 155777)
    local hot = (normalRejuv and germRejuv) and
        (normalRejuv.expirationTime > germRejuv.expirationTime and germRejuv or normalRejuv)
    local value = hot and max((hot.expirationTime - HeadpatsFrames.UpdateTime) / hot.duration, 0) or 0
    bar.StatusBar:SetValue(value)
    return value ~= 0
end

-- HeadpatsFramesClassDruid:_GetTankIcons
function HeadpatsFramesClassDruid:_GetTankIcons(frame, icons)
    -- * Use cenarion ward on cd
    if (not HeadpatsLib:InRaidArea() and HeadpatsLib:SpellReadyOrOnGCD(102351)) then
        table.insert(icons, "Cenarion Ward")
    end

    -- * Maintain lifebloom
    if (self:_NeedsLifeBloom(frame.Auras)) then
        table.insert(icons, "Lifebloom")
    end

    -- * Maintain hots
    if (self:_NeedsRejuv(frame.Auras)) then
        table.insert(icons, "Rejuvenation")
    end
end

-- HeadpatsFramesClassDruid:_GetNonTankIcons
function HeadpatsFramesClassDruid:_GetNonTankIcons(frame, icons)
    -- * Second lifebloom target; player if boss or heavy group dmg, otherwise lowest hp non-tank
    if (not HeadpatsLib:InRaidArea() and self.LifebloomCount < 2) then
        local frameNeedsLb = self:_NeedsLifeBloom(frame.Auras)
        if (frameNeedsLb) then -- and not tankNeedsLb) then
            local playerNeedsLb = HeadpatsFrames.InBossFight or self.LowHPPlayers >= 2
            -- TODO or frame == self.LowestHPNonTankFrame
            if (playerNeedsLb and frame == HeadpatsFrames.PlayerFrame) then
                table.insert(icons, "Lifebloom")
            end
        end
    end
end

-- HeadpatsFramesClassDruid:_GetSelfIcons
function HeadpatsFramesClassDruid:_GetSelfIcons(frame, icons)
    -- TODO: Health stone, potion, shift+F thing
end

-- HeadpatsFramesClassDruid:_GetMyAura
function HeadpatsFramesClassDruid:_GetMyAura(auras, spellId)
    return auras:GetAuraBySpellIdUnit(spellId, "player")
end

-- HeadpatsFramesClassDruid:_NeedsRejuv
function HeadpatsFramesClassDruid:_NeedsRejuv(auras)
    local normalRejuv = self:_GetMyAura(auras, 774)
    local germRejuv = self:_GetMyAura(auras, 155777)

    if not germRejuv and not HeadpatsLib:SpellKnown(155675) then
        germRejuv = { expirationTime = math.huge }
    end

    return not normalRejuv or not germRejuv or
        (normalRejuv.expirationTime - HeadpatsFrames.UpdateTime < 5) or
        (germRejuv.expirationTime - HeadpatsFrames.UpdateTime < 5)
end

-- HeadpatsFramesClassDruid:_GetLifebloom
function HeadpatsFramesClassDruid:_GetLifebloom(auras)
    return self:_GetMyAura(auras, 33763) or self:_GetMyAura(auras, 188550)
end

-- HeadpatsFramesClassDruid:_NeedsLifeBloom
function HeadpatsFramesClassDruid:_NeedsLifeBloom(auras)
    local lb = self:_GetLifebloom(auras)
    return not lb or lb.expirationTime - HeadpatsFrames.UpdateTime < 5
end

-- HeadpatsFramesClassDruid:_GetSwiftmendHot
function HeadpatsFramesClassDruid:_GetSwiftmendHot(auras)
    return self:_GetMyAura(auras, 774) or self:_GetMyAura(auras, 155777) or self:_GetMyAura(auras, 8936)
end

-- HeadpatsFramesClassDruid:_UpdateBarLayout
-- Converts and positions bar from vertical to horizontal above ability icons
function HeadpatsFramesClassDruid:_UpdateBarLayout(frame, bar, ydir, colour)
    local gapSize = HeadpatsFrames.Config.IconWidth / 16

    local totalWidth = HeadpatsFrames.Config.IconWidth * HeadpatsFrames.Config.IconCount + gapSize * (HeadpatsFrames.Config.IconCount - 1)
    bar:SetSize(totalWidth, HeadpatsFramesLayout.LeftBar.Width)
    bar.StatusBar:SetOrientation("HORIZONTAL")
    bar.StatusBar:SetStatusBarColor(colour.R, colour.G, colour.B, colour.A)

    local yOffsetForIcons = frame.ActiveIconCount > 0 and HeadpatsFrames.Config.IconHeight / 2 or 0
    local yOffset = yOffsetForIcons + HeadpatsFramesLayout.LeftBar.Width / 2 + gapSize

    bar:ClearAllPoints()
    bar:SetPoint("CENTER", bar:GetParent(), "CENTER", 0, yOffset * ydir)
end
