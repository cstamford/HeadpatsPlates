-- HeadpatsFrames:InitUnitFrame
function HeadpatsFrames:InitUnitFrame(frame)
    -- Make aura cache
    frame.Auras = {}
    HeadpatsLib:InitAuraCache(frame.Auras)

    -- In dev mode, we print debug info for applied auras.
    if (HeadpatsFrames.DevAuraDebug) then
        local logFn = function(txt) HeadpatsFrames:LogDebug(txt) end
        frame.Auras:SetAddedCallback(function(aura) frame.Auras:DebugPrintAura(frame.Unit, aura, "00FF00", logFn) end)
        frame.Auras:SetRemovedCallback(function(aura) frame.Auras:DebugPrintAura(frame.Unit, aura, "FF0000", logFn) end)
    end

    -- frame:Assign
    function frame:Assign(unit)
        self.Unit = unit
        self.IsHealer = UnitGroupRolesAssigned(unit) == "HEALER"
        self.IsPlayer = UnitIsUnit("player", unit)
        self.IsTank = UnitGroupRolesAssigned(unit) == "TANK"
        self.IsKat = UnitName(unit) == "Huntresh"

        self.Auras:Populate(self.Unit)

        self:InitEvents()
        self:SetSecureAttributes()
        self:SetSideBarVisibility()
        self:SetIconSizes()
        self:UpdateHealthBar()
        self:UpdateRange()
        self:UpdateHover()
        self:UpdateDispel()
        self:UpdateHealthBarColour()
        self:UpdateBackgroundColour()
    end

    -- frame:AssignIndex
    function frame:AssignIndex(index)
        self.Index = index
        self:SetFrameSize()
        self:SetFramePosition()
        self:SetFrameBorder()
    end

    -- frame:Reset
    function frame:Reset()
        self.Unit = nil
        self:ClearEvents()
    end

    -- frame:SetFrameSize
    function frame:SetFrameSize()
        self:SetScale(HeadpatsLib.ScaleFactor)
        self:SetSize(HeadpatsFrames.Config.Width, HeadpatsFrames.Config.Height)
    end

    -- frame:SetFramePosition
    function frame:SetFramePosition()
        local indexZeroBased = self.Index - 1
        local unitsPerRow = HeadpatsFrames.Config.Units / HeadpatsFrames.Config.Rows
        local rowId = math.floor(indexZeroBased / unitsPerRow)
        local columnId = indexZeroBased % unitsPerRow
        local totalWidthUsed = unitsPerRow * HeadpatsFrames.Config.Width + HeadpatsFrames.Config.Gap * (unitsPerRow - 1)

        local x = HeadpatsFrames.Config.X
            + columnId * HeadpatsFrames.Config.Width
            + columnId * HeadpatsFrames.Config.Gap
            + HeadpatsFrames.Config.Width / 2
            - totalWidthUsed / 2

        local y = HeadpatsFrames.Config.Y
            - rowId * HeadpatsFrames.Config.Height
            - rowId * HeadpatsFrames.Config.Gap
            - HeadpatsFrames.Config.Height / 2

        self:SetPoint("CENTER", x, y)
    end

    -- frame:self:SetFrameBorder
    function frame:SetFrameBorder()
        local col = HeadpatsFramesLayout.Background.EdgeColour
        if (not self.IsPlayer) then
            if (self.IsTank) then
                col = HeadpatsLib:RGB(1.0, 0, 0)
            elseif (self.IsHealer) then
                col = HeadpatsLib:RGB(0, 1.0, 0)
            elseif (self.IsKat) then
                col = HeadpatsLib:Magenta()
            end
        end
        self.Background:SetBackdropBorderColor(col.R, col.G, col.B, col.A)
    end
 
    -- frame:SetSecureAttributes
    function frame:SetSecureAttributes()
        self:RegisterForClicks("AnyDown");
        self:SetAttribute("unit", self.Unit);
        self:SetAttribute("*downbutton1", "leftclick");
        self:SetAttribute("*downbutton2", "rightclick");
        self:SetAttribute("*downbutton3", "middleclick");
        self:SetAttribute("type-middleclick", "target")
        self:SetAttribute("shift-type-middleclick", "togglemenu")

        if (HeadpatsFrames.Class.HPF_SetSecureAttributes) then
            HeadpatsFrames.Class:HPF_SetSecureAttributes(frame)
        end
    end

    -- frame:SetSideBarVisibility
    function frame:SetSideBarVisibility()
        frame.LeftBar.StatusBar:SetMinMaxValues(0, 1)
        frame.RightBar.StatusBar:SetMinMaxValues(0, 1)
        HeadpatsLib:ShowOrHide(frame.LeftBar, HeadpatsFrames.Class.HPF_UpdateLeftBar)
        HeadpatsLib:ShowOrHide(frame.RightBar, HeadpatsFrames.Class.HPF_UpdateRightBar)
    end

    -- frame:SetIconSizes()
    function frame:SetIconSizes()
        for _, v in ipairs(self.SpellHints) do
            v:SetSize(HeadpatsFrames.Config.IconWidth, HeadpatsFrames.Config.IconHeight)
        end
    end

    -- frame:UpdateHealthBar
    function frame:UpdateHealthBar()
        self.Health = UnitHealth(self.Unit)
        self.MaxHealth = UnitHealthMax(self.Unit)
        self.HealthPercent = self.Health / self.MaxHealth * 100
        self.Dead = UnitIsDead(self.Unit)
        self.HealthBar:SetMinMaxValues(0, self.MaxHealth)
        self.HealthBar:SetValue(self.Health)
    end

    -- frame:UpdateHealthBarColour
    function frame:UpdateHealthBarColour()
        local col = self.DispellableAura and
            HeadpatsFramesLayout.HealthBar.ColourDispel or
            HeadpatsLib:LerpColour(HeadpatsFramesLayout.HealthBar.Colour, HeadpatsFramesLayout.HealthBar.ColourLowHealth, 1.0 - self.Health / self.MaxHealth)
        self.HealthBar:SetStatusBarColor(col.R, col.G, col.B, col.A)
    end

    -- frame:UpdateBackgroundColour()
    function frame:UpdateBackgroundColour()
        local col = HeadpatsLib:LerpColour(HeadpatsFramesLayout.Background.Colour, HeadpatsFramesLayout.Background.ColourLowHealth, 1.0 - self.Health / self.MaxHealth)
        self.Background:SetBackdropColor(col.R, col.G, col.B, col.A)
    end

    -- frame:UpdateHover
    function frame:UpdateHover()
        HeadpatsLib:ShowOrHide(self.Hover, UnitIsUnit(self.Unit, "mouseover"))
    end

    -- frame:UpdateRange
    function frame:UpdateRange()
        local spell = HeadpatsFrames.Class.HPF_RangeCheckSpell or nil
        self.InRange = spell and C_Spell.IsSpellInRange(spell, self.Unit)
    end

    -- frame:UpdateSideBars
    function frame:UpdateSideBars()
        if (HeadpatsFrames.Class.HPF_UpdateLeftBar) then
            HeadpatsLib:ShowOrHide(frame.LeftBar, HeadpatsFrames.Class:HPF_UpdateLeftBar(self, self.LeftBar))
        end
        if (HeadpatsFrames.Class.HPF_UpdateRightBar) then
            HeadpatsLib:ShowOrHide(frame.RightBar, HeadpatsFrames.Class:HPF_UpdateRightBar(self, self.RightBar))
        end
    end

    -- frame:UpdateDispel
    function frame:UpdateDispel()
        self.DispellableAura = self.Auras.HarmfulAuraCount > 0 and self.Auras:GetFirstAuraWhere(function(aura)
            -- Scan all auras to find ones we can dispel
            return aura.isHarmful and (
                aura.dispelName == "Magic" or
                aura.dispelName == "Curse" or
                aura.dispelName == "Poison")
        end)
    end
    
    -- frame:UpdateSpellHints
    function frame:UpdateSpellHints()
        if (HeadpatsFrames.Class.HPF_SelectFrameIcons) then
            local icons = HeadpatsFrames.Class:HPF_SelectFrameIcons(self)
            local iconCount = min(HeadpatsFrames.Config.IconCount, #icons)

            local width = HeadpatsFrames.Config.IconWidth
            local gapSize = width / 16
            local halfWidth = width / 2
            local fullWidth = HeadpatsFrames.Config.IconWidth * iconCount + gapSize * (iconCount - 1)
            local halfFullWidth = fullWidth / 2

            for i = 1, iconCount do
                local hint = self.SpellHints[i]
                hint.Icon.Texture:SetTexture(HeadpatsLib:GetSpellIcon(icons[i]))
                hint:ClearAllPoints()
                hint:SetPoint("CENTER", -halfFullWidth + halfWidth + (i-1) * width + (i-1) * gapSize, 0)
                hint:Show()
            end

            for i = iconCount + 1, HeadpatsFramesLayout.MaxIcons do
                self.SpellHints[i]:Hide()
            end

            self.ActiveIconCount = iconCount
        end
    end
end
