-- HeadpatsLib:CreateFrame
function HeadpatsLib:CreateFrame(frameType, name, parent, template, id, info)
    local frame = CreateFrame(frameType, name, parent, template, id)
    if (info) then
        self:ApplyFrameInfo(frame, info)
    end
    return frame
end

-- HeadpatsLib:CreateBackdropFrame
function HeadpatsLib:CreateBackdropFrame(customization, parent, insets)
    local backdrop = self:CreateFrame("Frame", nil, parent, "BackdropTemplate", nil, self:MakeFrameInfoFromLayout(customization))

    backdrop:SetAllPoints(parent)
    backdrop:SetBackdrop(self:MakeBackdropInfo(customization, insets))

    if (customization.BlendMode) then
        self:SetBackdropBlendMode(backdrop, customization.BlendMode)
    end

    if (customization.Colour) then
        local col = customization.Colour
        backdrop:SetBackdropColor(col.R, col.G, col.B, col.A)
    end

    if (customization.EdgeColour) then
        local col = customization.EdgeColour
        backdrop:SetBackdropBorderColor(col.R, col.G, col.B, col.A)
    end

    return backdrop
end

-- HeadpatsLib:CreateIcon
function HeadpatsLib:CreateIcon(customization, parent, insets)
    local icon = self:CreateFrame("Frame", nil, parent, nil, nil, self:MakeFrameInfoFromLayout(customization))

    self:SetAllPointsWithInsets(icon, parent, insets)

    icon.Texture = icon:CreateTexture()
    icon.Texture:SetAllPoints()

    if (customization.ZoomByPixels) then
        local size = customization.Size or { Width = 64, Height = 64 }
        local uvOffsetX = 1.0 - ((size.Width - customization.ZoomByPixels) / size.Width)
        local uvOffsetY = 1.0 - ((size.Height - customization.ZoomByPixels) / size.Height)
        icon.Texture:SetTexCoord(uvOffsetX, 1.0 - uvOffsetX, uvOffsetY, 1.0 - uvOffsetY)
    end

    return icon
end

-- HeadpatsLib:CreateStatusBar
function HeadpatsLib:CreateStatusBar(customization, parent, insets)
    local bar = self:CreateFrame("StatusBar", nil, parent, nil, nil, self:MakeFrameInfoFromLayout(customization))

    if (insets) then
        self:SetAllPointsWithInsets(bar, parent, insets)
    end

    bar:SetStatusBarTexture(customization.Texture or HeadpatsLib.Assets.DefaultStatusBar)

    local col = customization.Colour or HeadpatsLib:White()
    bar:SetStatusBarColor(col.R, col.G, col.B, col.A)

    return bar
end

-- HeadpatsLib:CreateText
function HeadpatsLib:CreateText(customization, parent)
    local text = parent:CreateFontString()
    text:SetAllPoints(parent)

    text:SetFont(customization.Font or HeadpatsLib.Assets.DefaultFont, customization.Size, customization.Style or "OUTLINE")

    local col = customization.Colour or self:White()
    text:SetTextColor(col.R, col.G, col.B, col.A)

    local shadCol = customization.ShadowColor or self:Black()
    local shadOffset = customization.ShadowOffset or { X = 1, Y = -1 }
    text:SetShadowColor(shadCol.R, shadCol.G, shadCol.B, shadCol.A)
    text:SetShadowOffset(shadOffset.X, shadOffset.Y)

    return text
end

-- HeadpatsLib:SetBackdropBlendMode
function HeadpatsLib:SetBackdropBlendMode(frame, mode)
    local tl = frame["TopLeftCorner"]
    local tr = frame["TopRightCorner"]
    local bl = frame["BottomLeftCorner"]
    local br = frame["BottomRightCorner"]
    local te = frame["TopEdge"]
    local be = frame["BottomEdge"]
    local le = frame["LeftEdge"]
    local re = frame["RightEdge"]
    local ce = frame["Center"]

    if (tl) then tl:SetBlendMode(mode) end
    if (tr) then tr:SetBlendMode(mode) end
    if (bl) then bl:SetBlendMode(mode) end
    if (br) then br:SetBlendMode(mode) end
    if (te) then te:SetBlendMode(mode) end
    if (be) then be:SetBlendMode(mode) end
    if (le) then le:SetBlendMode(mode) end
    if (re) then re:SetBlendMode(mode) end
    if (ce) then ce:SetBlendMode(mode) end
end

-- HeadpatsLib:SetAllPointsWithInsets
function HeadpatsLib:SetAllPointsWithInsets(frame, parent, insets)
    -- Note for future: posx = left, posy = up
    frame:SetPoint("TOPLEFT", parent, "TOPLEFT", insets.left, -insets.top)
    frame:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -insets.right, insets.bottom)
end

-- HeadpatsLib:ApplyFrameInfo
function HeadpatsLib:ApplyFrameInfo(frame, info)
    if (info.Strata) then
        frame:SetFrameStrata(info.Strata)
    end

    if (info.Layer) then
        frame:SetDrawLayer(info.layer, info.SubLayer)
    end

    if (info.Level) then
        frame:SetFrameLevel(frame:GetParent():GetFrameLevel() + info.Level)
    end
end

-- HeadpatsLib:MakeFrameInfo
function HeadpatsLib:MakeFrameInfo(layer, subLayer, level, strata)
    return { Strata = strata, Level = level, Layer = layer, SubLayer = subLayer }
end

-- HeadpatsLib:MakeFrameInfoFromLayout
function HeadpatsLib:MakeFrameInfoFromLayout(customization)
    return { Strata = customization.Strata, Level = customization.Level, Layer = customization.Layer, SubLayer = customization.SubLayer }
end

-- HeadpatsLib:MakeInsets1
function HeadpatsLib:MakeInsets1(inset)
    return { left = inset, top = inset, right = inset, bottom = inset }
end

-- HeadpatsLib:MakeInsets2
function HeadpatsLib:MakeInsets2(leftRight, topBottom)
    return { left = leftRight, top = topBottom, right = leftRight, bottom = topBottom }
end

-- HeadpatsLib:MakeInsets4
function HeadpatsLib:MakeInsets4(left, top, right, bottom)
    return { left = left, top = top, right = right, bottom = bottom }
end

-- HeadpatsLib:MakeBackdropInfo
function HeadpatsLib:MakeBackdropInfo(customization, insets)
    local backdropInfo =
    {
        bgFile = customization.Texture,
        edgeSize = customization.EdgeSize,
        edgeFile = customization.EdgeTexture,
        tile = customization.Tile or false,
        insets = insets
    }

    return backdropInfo
end

-- HeadpatsLib:ShowOrHide
function HeadpatsLib:ShowOrHide(frame, b)
    if (b) then
        frame:Show()
    else
        frame:Hide()
    end
end

-- HeadpatsLib:HideBlizzardFrame
function HeadpatsLib:HideBlizzardFrame(frame)
    frame:Hide()
    frame:UnregisterAllEvents()

    -- Reparent it to a dummy (hidden) frame, so if some weird stuff happens,
    -- it's always guaranteed to be hidden.
    frame:SetParent(self.DummyFrame)

    -- Prevent secure frames from reappearing based on state changes
    if (not InCombatLockdown()) then
        UnregisterUnitWatch(frame)
    end
end
