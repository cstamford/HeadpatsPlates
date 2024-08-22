-- HeadpatsPlatesLayout:CreateNameplate
function HeadpatsPlatesLayout:CreateNameplate(frame)
    local nameplate = HeadpatsLib:CreateFrame("Frame", "HeadpatsPlatesNameplate" .. frame:GetName(), UIParent)
    nameplate:SetFrameStrata(self.Strata)
    nameplate:SetPoint("CENTER", frame)

    -- Order of frames:
    -- * Background
    -- * * HealthBar
    -- * * * Text
    -- * * CastBar
    -- * * * Text
    -- * * * CastTargetText
    -- * * * CastTimeText
    -- * Selected
    -- * Hover
    -- * Aura
    -- * * Background
    -- * * Icon
    -- * * Selected
    -- * * Hover

    -- Background
    local custBg = self.Background
    local edgeInsets = HeadpatsLib:MakeInsets1(custBg.EdgeSize)
    nameplate.Background = HeadpatsLib:CreateBackdropFrame(custBg, nameplate)

    -- Background.HealthBar
    local custHb = self.HealthBar
    nameplate.HealthBar = HeadpatsLib:CreateStatusBar(custHb, nameplate.Background, edgeInsets)

    -- Background.HealthBar.Text
    nameplate.HealthBar.Text = HeadpatsLib:CreateText(custHb.Text, nameplate.HealthBar)

    -- Background.CastBar
    local custCb = self.CastBar
    nameplate.CastBar = HeadpatsLib:CreateStatusBar(custCb, nameplate.Background, edgeInsets)

    -- Background.CastBar.Text
    nameplate.CastBar.Text = HeadpatsLib:CreateText(custCb.Text, nameplate.CastBar)

    -- Background.CastBar.CastTargetText
    nameplate.CastBar.CastTargetText = HeadpatsLib:CreateText(custCb.CastTargetText, nameplate.CastBar)
    nameplate.CastBar.CastTargetText:ClearAllPoints()
    nameplate.CastBar.CastTargetText:SetPoint("LEFT", nameplate.CastBar, "RIGHT", 8, 0)

    -- Background.CastBar.CastTimeText
    nameplate.CastBar.CastTimeText = HeadpatsLib:CreateText(custCb.CastTimeText, nameplate.CastBar)
    nameplate.CastBar.CastTimeText:ClearAllPoints()
    nameplate.CastBar.CastTimeText:SetPoint("RIGHT", nameplate.CastBar, "LEFT", -8, 0)

    -- Selected
    local custSel = self.Selected
    nameplate.Selected = HeadpatsLib:CreateBackdropFrame(custSel, nameplate, edgeInsets)

    -- Hover
    local custHover = self.Hover
    nameplate.Hover = HeadpatsLib:CreateBackdropFrame(custHover, nameplate, edgeInsets)

    -- Aura
    local custAura = self.Aura
    nameplate.Aura = HeadpatsLib:CreateFrame("Frame", nil, nameplate, nil, nil, HeadpatsLib:MakeFrameInfoFromLayout(custAura))
    nameplate.Aura:SetPoint("CENTER")

    -- Aura.Background
    nameplate.Aura.Background = HeadpatsLib:CreateBackdropFrame(custBg, nameplate.Aura)

    -- Aura.Icon
    nameplate.Aura.Icon = HeadpatsLib:CreateIcon(custAura.Icon, nameplate.Aura, edgeInsets)

    -- Aura.Selected
    nameplate.Aura.Selected = HeadpatsLib:CreateBackdropFrame(custAura.Selected, nameplate.Aura, edgeInsets)

    -- Aura.Hover
    nameplate.Aura.Hover = HeadpatsLib:CreateBackdropFrame(custAura.Hover, nameplate.Aura, edgeInsets)

    return nameplate
end

-- HeadpatsPlatesLayout:CreateClickableArea
function HeadpatsPlatesLayout:CreateClickableArea(frame)
    local size = self.EmphasisSize
    local padding = self.ClickableAreaPadding
    local clickable = HeadpatsLib:CreateFrame("Frame", "HeadpatsPlatesClickable" .. frame:GetName(), UIParent)
    clickable:SetFrameStrata(self.ClickableStrata)
    clickable:SetPoint("CENTER", frame)
    clickable:SetSize(size.Width + padding.Width, size.Height + padding.Height)

    -- Background - covering the whole clickable area
    local custBg = self.ClickableArea
    clickable.Background = HeadpatsLib:CreateBackdropFrame(custBg, clickable)
    clickable.Background:Show()

    -- BackgroundInner - covering the maximum size bar we will show
    local custInner = self.ClickableAreaInner
    local bgInnerInsets = HeadpatsLib:MakeInsets2(padding.Width / 2, padding.Height / 2)
    clickable.BackgroundInner = HeadpatsLib:CreateBackdropFrame(custInner, clickable, bgInnerInsets)
    clickable.BackgroundInner:Show()

    return clickable
end
