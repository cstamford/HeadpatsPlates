-- HeadpatsLib:Init
function HeadpatsLib:Init()
    self.DriverFrame = CreateFrame("Frame")
    self.DriverFrame:SetScript("OnEvent",
        function (_, evt, ...)
            if (evt == "DISPLAY_SIZE_CHANGED") then
                self:UpdateSpaceTransforms()
            elseif (evt == "PLAYER_ENTERING_WORLD") then
                self.AreaId = select(8, GetInstanceInfo())
            end
        end)
    self.DriverFrame:RegisterEvent("DISPLAY_SIZE_CHANGED")
    self.DriverFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    self.DummyFrame = CreateFrame("Frame")
    self:UpdateSpaceTransforms()
end

-- HeadpatsLib:UpdateSpaceTransforms
function HeadpatsLib:UpdateSpaceTransforms()
    -- UI Space - height is 768
    -- Screen space - height is variable
    -- The factors below can be used to transform between the two.
    self.ScaleFactor = 768 / select(2, GetPhysicalScreenSize()) / UIParent:GetScale() -- UI to screen space
    self.ScaleFactorInverse = 1 / self.ScaleFactor -- Screen to UI space
end
