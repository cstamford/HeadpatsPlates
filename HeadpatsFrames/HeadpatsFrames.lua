-- HeadpatsFrames:Init
function HeadpatsFrames:Init()
    self.Class = HeadpatsLib.Class[select(2, UnitClass("player"))]
    self.DriverFrame = CreateFrame("Frame")

    self:InitEvents()
    self:InitFrameCache()
    self:HideBlizzardFrames()
end

-- HeadpatsFrames:InitFrameCache
function HeadpatsFrames:InitFrameCache()
    self.FrameCache = {}

    for i = 1, MAX_RAID_MEMBERS do
        local frame = HeadpatsFramesLayout:MakeUnitFrame("HeadpatsFramesUnitFrame" .. i)
        self:InitUnitFrame(frame)
        self:InitUnitFrameEvents(frame)
        table.insert(self.FrameCache, frame)
    end

    function self.FrameCache:Get()
        local frame = self[self.Index]
        self.Index = self.Index + 1
        return frame
    end

    function self.FrameCache:Count()
        return self.Index - 1
    end

    function self.FrameCache:Reset()
        self.Index = 1
    end
end

-- HeadpatsFrames:HideBlizzardFrames
function HeadpatsFrames:HideBlizzardFrames()
    -- Hide player/target frame
    HeadpatsLib:HideBlizzardFrame(PlayerFrame)
    --HeadpatsLib:HideBlizzardFrame(ComboPointDruidPlayerFrame)
    HeadpatsLib:HideBlizzardFrame(TargetFrame)
    HeadpatsLib:HideBlizzardFrame(FocusFrame)

    -- This is called by a ton of places, when roster updates etc
    hooksecurefunc("UpdateRaidAndPartyFrames", function(...)
        -- Regular party frames
        if (PartyFrame and not self.hiddenParty) then
            HeadpatsLib:HideBlizzardFrame(PartyFrame)
            for frame in PartyFrame.PartyMemberFramePool:EnumerateActive() do
                HeadpatsLib:HideBlizzardFrame(frame)
            end
            PartyFrame.PartyMemberFramePool:ReleaseAll()
            self.hiddenParty = true
        end

        -- Raid-style party frames
        if (CompactPartyFrame and not self.hiddenRaidParty) then
            HeadpatsLib:HideBlizzardFrame(CompactPartyFrame)
            for i = 1, MAX_PARTY_MEMBERS do
                HeadpatsLib:HideBlizzardFrame(_G["CompactPartyFrameMember" .. i])
            end
            self.hiddenRaidParty = true
        end

        -- Raid frames
        if (CompactRaidFrameManager and not self.hiddenRaid) then
            HeadpatsLib:HideBlizzardFrame(CompactRaidFrameManager)
            HeadpatsLib:HideBlizzardFrame(CompactRaidFrameManager.container)

            -- Every time we attempt to layout the raid frames again (usually on a system setting change), we iterate over
            -- all of the registered CompactUnitFrames and hide them. It's not strictly necessary to do this but it does
            -- allow us to suppress their events which is otherwise wasted performance.
            hooksecurefunc(CompactRaidFrameManager.container, "LayoutFrames", function (container)
                for i = 1, #container.flowFrames do
                    local entry = container.flowFrames[i]
                    if (type(entry) == "table") then -- can also have other types
                        HeadpatsLib:HideBlizzardFrame(entry)
                    end
                end
            end)

            self.hiddenRaid = true
        end
    end)

    -- This is called right after a loading screen
    hooksecurefunc("UpdateUIElementsForClientScene", function(...)
        HeadpatsLib:HideBlizzardFrame(PlayerFrame)
        HeadpatsLib:HideBlizzardFrame(TargetFrame)
    end)
end

-- HeadpatsFrames:UpdateLayout
-- Returns whether we need another update at a later time or not.
function HeadpatsFrames:UpdateLayout()
    -- If we're in combat lockdown, just bail; otherwise we'll taint the entire UI.
    -- This means that frames will remain in the same configuration even if someone leaves in combat.
    if (InCombatLockdown() or not self.Loaded) then
        return true
    end

    -- Find the most fitting config to apply
    local groupMembers = GetNumGroupMembers()
    for _, v in ipairs(HeadpatsFramesLayout.Config) do
        if (v.Units >= groupMembers) then
            self.Config = v
            break
        end
    end

    -- If we have forced a specific config, use it instead.
    if (HeadpatsFrames.DevForceConfigIdx) then
        self.Config = HeadpatsFramesLayout.Config[HeadpatsFrames.DevForceConfigIdx]
    end

    -- Reset the frame cache and every frame inside of it!
    self.FrameCache:Reset()
    for _, v in ipairs(self.FrameCache) do
        v:Reset()
        v:Hide()
    end

    self.FrameCache:Get():Assign("player")

    if (UnitInRaid("player")) then
        -- Units are raid1 to raid 40, possible gaps
        -- We have to check every possible slot here!
        for i = 1, MAX_RAID_MEMBERS do
            if (GetRaidRosterInfo(i)) then
                local name = "raid" .. i
                if (not UnitIsUnit("player", name)) then
                    self.FrameCache:Get():Assign(name)
                end
            end
        end
    else
        -- Units are party1 to party4, no gaps
        for i = 1, groupMembers - 1 do
            local name = "party" .. i
            self.FrameCache:Get():Assign(name)
        end
    end

    -- Force index to be a tank for developer testing
    if (HeadpatsFrames.DevForceIdxAsTank) then
        self.FrameCache[HeadpatsFrames.DevForceIdxAsTank].IsTank = true
    end

    -- In preview mode, we just assign all remaining units to random group members
    if (HeadpatsFrames.DevPreviewFrames) then
        local unitCount = self.FrameCache:Count()
        for i = self.FrameCache:Count() + 1, self.Config.Units do
            self.FrameCache:Get():Assign(self.FrameCache[random(unitCount)].Unit)
        end
    end

    -- Sort the frame cache in order of display
    table.sort(self.FrameCache,
        function(lhs, rhs)
            -- We're sorting the whole collection, which includes potentially unused frames.
            -- We handle them here as a special case: they should go right at the end.
            if (not lhs.Unit or not rhs.Unit) then
                return (not lhs.Unit and not rhs.Unit) and false or lhs.Unit
            end

            local calcWeight = function(frame)
                local weight = 0
                weight = weight + (frame.IsPlayer and 8 or 0)
                weight = weight + (frame.IsTank and 4 or 0)
                weight = weight + (frame.IsKat and 2 or 0)
                weight = weight + (frame.IsHealer and 1 or 0)
                return weight
            end

            local lhsWeight, rhsWeight = calcWeight(lhs), calcWeight(rhs)
            return lhsWeight == rhsWeight and
                lhs.MaxHealth < rhs.MaxHealth or
                lhsWeight > rhsWeight
        end)

    -- Wrap up each of our sorted, final frames
    for i = 1, self.FrameCache:Count() do
        local frame = self.FrameCache[i]

        -- Add auras for developer testing
        for _, v in ipairs(HeadpatsFrames.DevAddAurasToAllUnits or {}) do
            frame.Auras:AddAura(v)
        end

        frame:AssignIndex(i)
        frame:Show()
    end

    -- Update the state alongside the new layout
    self:UpdatePersistentState()

    return false
end

-- HeadpatsFrames:UpdateActiveTank
function HeadpatsFrames:UpdateActiveTank()
    -- First attempt; if we have a focus who is a tank, they will be forced to be primary tank always.
    local tankCandidate = self:FirstFrameWhere(function(frame)
        return frame.IsTank and self.InBossFight and UnitIsUnit(frame.Unit, "focus")
    end)

    if (not tankCandidate) then
        -- Second attempt; we select the target (who is a tank) who the current boss is targeting
        tankCandidate = self:FirstFrameWhere(function(frame)
            return frame.IsTank and self.InBossFight and UnitIsUnit(frame.Unit, "boss1target")
        end)
    end

    if (not tankCandidate) then
        -- Third attempt; we just select the first available tank
        tankCandidate = self:FirstFrameWhere(function(frame)
            return frame.IsTank
        end)
    end

    if (not tankCandidate) then
        -- Fallback; player is tank now lmao
        tankCandidate = self.PlayerFrame.Index
    end

    self.TankFrame = tankCandidate and self.FrameCache[tankCandidate] or self.PlayerFrame
end

-- HeadpatsFrames:UpdatePersistentState
function HeadpatsFrames:UpdatePersistentState()
    self.InBossFight = UnitExists("boss1")
    self.PlayerFrame = self.FrameCache[1] -- player is always first
    self:UpdateActiveTank()
end

-- Turns out Lua garbage collects anonymous functions. Whatever.
-- This produces a lot of garbage but is elegant.
-- Perf is fine so I'm leaving it until perf isn't fine.

-- HeadpatsFrames:LowestHealthFrame
function HeadpatsFrames:LowestHealthFrame()
    return self:LowestHealthFrameWhere(function(...) return true end)
end

-- HeadpatsFrames:LowestHealthFrameWhere
function HeadpatsFrames:LowestHealthFrameWhere(fn)
    local lowestIdx = nil
    for i = 1, self.FrameCache:Count() do
        local thisFrame = self.FrameCache[i]
        local isCandidate = not lowestIdx or thisFrame.HealthPercent < self.FrameCache[lowestIdx].HealthPercent
        if (isCandidate and fn(thisFrame)) then
            lowestIdx = i
        end
    end
    return lowestIdx
end

-- HeadpatsFrames:FirstFrameWhere(fn)
function HeadpatsFrames:FirstFrameWhere(fn)
    for i = 1, self.FrameCache:Count() do
        local thisFrame = self.FrameCache[i]
        if (fn(thisFrame)) then
            return i
        end
    end
    return nil
end

-- HeadpatsFrames:ForEachFrame(fn)
function HeadpatsFrames:ForEachFrame(fn)
    for i = 1, self.FrameCache:Count() do
        fn(self.FrameCache[i])
    end
end

-- HeadpatsFrames:CountWhere(fn)
function HeadpatsFrames:CountWhere(fn)
    local count = 0
    self:ForEachFrame(function(frame)
        if (fn(frame)) then
            count = count + 1
        end
    end)
    return count
end
