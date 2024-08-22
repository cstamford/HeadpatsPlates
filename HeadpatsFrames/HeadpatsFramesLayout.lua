-- HeadpatsFramesLayout:MakeUnitFrame
function HeadpatsFramesLayout:MakeUnitFrame(name)
    local frame = HeadpatsLib:CreateFrame("Button", name, UIParent, "SecureUnitButtonTemplate")
    frame:SetFrameStrata(self.Strata)

    local edgeInsets = HeadpatsLib:MakeInsets1(self.Background.EdgeSize)

    frame.Background = HeadpatsLib:CreateBackdropFrame(self.Background, frame)
    frame.HealthBar = HeadpatsLib:CreateStatusBar(self.HealthBar, frame.Background, edgeInsets)

    frame.LeftBar = HeadpatsLib:CreateBackdropFrame(self.LeftBar, frame.Background)
    frame.LeftBar:ClearAllPoints()
    frame.LeftBar:SetPoint("TOPLEFT")
    frame.LeftBar:SetPoint("BOTTOMLEFT")
    frame.LeftBar:SetWidth(HeadpatsFramesLayout.LeftBar.EdgeSize * 2 + HeadpatsFramesLayout.LeftBar.Width)
    frame.LeftBar.StatusBar = HeadpatsLib:CreateStatusBar(self.LeftBar, frame.LeftBar, HeadpatsLib:MakeInsets1(self.LeftBar.EdgeSize))
    frame.LeftBar.StatusBar:SetOrientation("VERTICAL")
    frame.LeftBar.StatusBar:SetRotatesTexture(true)

    frame.RightBar = HeadpatsLib:CreateBackdropFrame(self.RightBar, frame.Background)
    frame.RightBar:ClearAllPoints()
    frame.RightBar:SetPoint("TOPRIGHT")
    frame.RightBar:SetPoint("BOTTOMRIGHT")
    frame.RightBar:SetWidth(HeadpatsFramesLayout.RightBar.EdgeSize * 2 + HeadpatsFramesLayout.RightBar.Width)
    frame.RightBar.StatusBar = HeadpatsLib:CreateStatusBar(self.RightBar, frame.RightBar, HeadpatsLib:MakeInsets1(self.RightBar.EdgeSize))
    frame.RightBar.StatusBar:SetOrientation("VERTICAL")
    frame.RightBar.StatusBar:SetRotatesTexture(true)

    frame.SpellHints = {}
    for i = 1, self.MaxIcons do
        local hint = HeadpatsLib:CreateFrame("Frame", nil, frame, nil, nil, HeadpatsLib:MakeFrameInfoFromLayout(self.SpellHint))
        hint.Background = HeadpatsLib:CreateBackdropFrame(self.Background, hint)
        hint.Icon = HeadpatsLib:CreateIcon(self.SpellHint.Icon, hint, edgeInsets)
        table.insert(frame.SpellHints, hint)
    end

    frame.Hover = HeadpatsLib:CreateBackdropFrame(self.Hover, frame, edgeInsets)

    return frame
end
