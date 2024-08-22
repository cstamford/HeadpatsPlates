-- HeadpatsPlates:Init
function HeadpatsPlates:Init()
    self.DriverFrame = CreateFrame("Frame")
    self:RegisterFrameWithProfiler(self.DriverFrame)

    self.Nameplates = { }
    self.ActiveNameplatesCount = 0
    self.Version = 1 -- Increment the version to force all active nameplates to recreate

    -- These times are in milliseconds
    self.UpdateTimeImportant = HeadpatsLib:MsToSec(50)
    self.UpdateTimeNormal = HeadpatsLib:MsToSec(100)
    self.UpdateTimeSlow = HeadpatsLib:MsToSec(200)
    self.UpdateTimeHiddenMultiplier = 5
    self.UpdateTimeLowPriorityMultiplier = 2
    self.UpdateTimeHighPriorityMultiplier = 0.5 -- double rate

    self:InitEvents()
    self:InitClassTables()
    self:ClearAreaData()

    -- In UpdateNamePlateOptions CVars are read and two important options are set, clobbering ours.
    -- This is called from a whole bunch of place so we have three option:
    --
    -- 1. Subscribe to the same events and hope we get called after.
    -- 2. Force unsubscribe NamePlateDriverFrame (and we could never use Blizzard frames)
    -- 3. Hook UpdateNamePlateOptions() and write over their changes
    --
    -- This is option 3.
    hooksecurefunc(NamePlateDriverFrame, "UpdateNamePlateOptions", function(_)
        C_NamePlate.SetNamePlateFriendlySize(1, 1)
        local size = HeadpatsPlatesLayout.EmphasisSize
        local pad = HeadpatsPlatesLayout.ClickableAreaPadding
        local scale = HeadpatsLib.ScaleFactor * UIParent:GetScale() -- this area IGNORES UI scale
        C_NamePlate.SetNamePlateEnemySize(
            (size.Width + pad.Width) * scale,
            (size.Height + pad.Height) * scale)
    end)
end

-- HeadpatsPlates:InitClassTables
function HeadpatsPlates:InitClassTables()
    local classTableTable =
    {
        ["DRUID"] = HeadpatsPlatesClassDruid,
        ["PRIEST"] = HeadpatsPlatesClassPriest,
        ["PALADIN"] = HeadpatsPlatesClassPaladin,
    }

    local class = select(2, UnitClass("player"))
    self.ClassData = classTableTable[class] or 
    {
        GetRangeCheckAbility = function(...) return nil end,
        GetNameplateAbility = function(...) return nil end,
    }
end

-- HeadpatsPlates:UpdateCVars
function HeadpatsPlates:UpdateCVars()
    -- We derive our nameplates' alpha from the Blizzard frame so we can take advantage of 
    -- performant distance and occlusion checks (happens in-engine rather than Lua).
    SetCVar("nameplateMaxDistance", 60)
    SetCVar("nameplateMinAlpha", HeadpatsPlatesLayout.RangeCheckFailAlpha)
    SetCVar("nameplateMinAlphaDistance", 0)
    SetCVar("nameplateMaxAlpha", 1.0)
    SetCVar("nameplateMaxAlphaDistance", 60)
    SetCVar("nameplateOccludedAlphaMult", HeadpatsPlatesLayout.RangeCheckFailAlpha)
    SetCVar("nameplateSelectedScale", HeadpatsPlatesLayout.SelectedScale)

    -- Movement and overlap settings, since we set in Pixel size there's no reason not to.
    SetCVar("nameplateMotion", 1)
    SetCVar("nameplateMotionSpeed", 0.05)
    SetCVar("nameplateOverlapH", 1.2)
    SetCVar("nameplateOverlapV", 1.2)
    SetCVar("nameplateOtherAtBase", 1)

    -- Profiling mode
    if (HeadpatsPlates.EnableProfiler) then
        local scriptProfile = tonumber(GetCVar("scriptProfile"))
        if (scriptProfile ~= 1) then
            HeadpatsPlates:LogWarn("Script profiling requires a UI reload (/reload) to work!")
        end
    end   
end

-- HeadpatsPlates:CanAssignNameplate
function HeadpatsPlates:CanAssignNameplate(token)
    local player = UnitIsPlayer(token)
    local friendly = UnitIsFriend("player", token)
    local limit = HeadpatsPlates.DevMode and HeadpatsPlates.DevMaxPlates and self.ActiveNameplatesCount >= HeadpatsPlates.DevMaxActiveNameplatesCount
    return not player and not friendly and not limit
end

-- HeadpatsPlates:SetAreaData
function HeadpatsPlates:SetAreaData(areaId)
    self:ClearAreaData()

    local funcTable =
    {
        [2526] = self.SetAreaDataAlgetharAcademy,
        [1571] = self.SetAreaDataCourtOfStars, 
        [1477] = self.SetAreaDataHallsOfValor,
        [2521] = self.SetAreaDataRubyLifePools,
        [1176] = self.SetAreaDataShadowmoonBurialGround,
        [960] = self.SetAreaDataTempleOfTheJadeSerpent,
        [2515] = self.SetAreaDataAzureVault,
        [2516] = self.SetAreaDataTheNokhudOffensive,
        [1519] = self.DevMode and self.SetAreaDataStormwindDev or nil,
        [2444] = self.DevMode and self.SetAreaDataValdrakkenDev or nil,
    }

    for id, fn in pairs(funcTable) do
        if (self.DevMode or id == areaId) then
            fn(self)
        end
    end

    -- Update version so all nameplates recreate with updated area data.
    self.Version = self.Version + 1
end

-- HeadpatsPlates:ClearAreaData
function HeadpatsPlates:ClearAreaData()
    self.CastInterrupt = { }
    self.CastAware = { }
    self.EmphasizeMob = { }
    self.EmphasizeBoss = { }
    self.EmphasizeAware = { }
    self.HiddenMob = { }
end

-- HeadpatsPlates:UpdatePlayerMana
function HeadpatsPlates:UpdatePlayerMana()
    self.PlayerMana = UnitPower("player", Enum.PowerType.Mana)
    self.PlayerManaMax = UnitPowerMax("player", Enum.PowerType.Mana)
    self.PlayerManaPercent = self.PlayerMana / self.PlayerManaMax * 100
end

-- HeadpatsPlates:RegisterNameplate
-- Note: In WoW, frames cannot be destroyed, so there is no leak here.
function HeadpatsPlates:RegisterNameplate(nameplate)
    table.insert(self.Nameplates, nameplate)

    -- Register with the profiler (noop if profiler disabled)
    self:RegisterFrameWithProfiler(nameplate)
end
