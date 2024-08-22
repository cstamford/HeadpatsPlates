-- HeadpatsFrames:InitEvents
function HeadpatsFrames:InitEvents()
    self.DriverFrame:SetScript("OnUpdate", function (_, evt, ...) self:OnUpdate(...) end)
    self.DriverFrame:SetScript("OnEvent", function (_, evt, ...) self:OnEvent(evt, ...) end)
    self.DriverFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
    self.DriverFrame:RegisterEvent("PLAYER_LOGIN")
    self.DriverFrame:RegisterEvent("UPDATE_MOUSEOVER_UNIT")

    HeadpatsLib:InitUpdateTime(self)
    self:UpdateTimeTargets(HeadpatsLib:MsToSec(50), HeadpatsLib:MsToSec(100), HeadpatsLib:MsToSec(200))
end

-- HeadpatsFrames:OnEvent
function HeadpatsFrames:OnEvent(evt, ...)
    if (evt == "GROUP_ROSTER_UPDATE") then
        self:OnGroupRosterUpdate(...)
    elseif (evt == "PLAYER_LOGIN") then
        self:OnPlayerLogin(...)
    elseif (evt == "UPDATE_MOUSEOVER_UNIT") then
        self:OnUpdateMouseoverUnit(...)
    end
end

-- HeadpatsFrames:OnUpdate
function HeadpatsFrames:OnUpdate(...)
    self:UpdateTimeState(GetTime())

    -- UpdateTimeImportant: Use for things that require smooth updating, like animations.
    if (self.UpdateImportantReady) then
    end

    -- UpdateTimeNormal: Use for things that need to be responsive but not time critical.
    if (self.UpdateNormalReady) then

        -- Called once per update interval, used by classes to track shared state
        if (self.Class.HPF_Update) then
            self.Class:HPF_Update()
        end

        self:ForEachFrame(function(frame)
            -- Range visibility info, fades us out when we're out of dead or out of range
            frame:UpdateRange()
            frame:SetAlpha(frame.Dead and HeadpatsFrames.AlphaDead or
                frame.InRange and HeadpatsFramesLayout.AlphaInRange or
                HeadpatsFramesLayout.AlphaOutOfRange)

            -- Hover highlighting, indicates when we're hovering over the frame
            frame:UpdateHover()

            -- Update any auras we can dispel.
            frame:UpdateDispel()

            -- Update the health/bg colour - scaling based off missing HP + dispellable state.
            frame:UpdateHealthBarColour()
            frame:UpdateBackgroundColour()

            -- Update the spell hint(s) for each frame
            frame:UpdateSpellHints()

            -- Update the class-controlled side bars
            frame:UpdateSideBars()
        end)
    end

    -- UpdateTimeSlow: Use for things that are expensive and infrequent and can be updated slowly.
    if (self.UpdateSlowReady) then
        -- Redo layout if needed, might return true in which case we need to try again next time
        if (self.UpdateLayoutNeeded) then
            self.UpdateLayoutNeeded = self:UpdateLayout()
        end

        -- Update the persistent state - we use this to cache certain frames etc
        self:UpdatePersistentState()
    end
end

-- HeadpatsFrames:OnGroupRosterUpdate
function HeadpatsFrames:OnGroupRosterUpdate(...)
    self.UpdateLayoutNeeded = true -- do next update, prevent flickering when moving groups
end

-- HeadpatsFrames:OnPlayerLogin
function HeadpatsFrames:OnPlayerLogin(...)
    self.Loaded = true
    self.UpdateLayoutNeeded = self:UpdateLayout()
end

-- HeadpatsFrames:OnUpdateMouseoverUnit
function HeadpatsFrames:OnUpdateMouseoverUnit(...)
    -- Update each frame highlighting
    for i = 1, self.FrameCache:Count() do
        self.FrameCache[i]:UpdateHover()
    end
end

