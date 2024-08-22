-- HeadpatsPlates:InitNameplateRotationFuncs
function HeadpatsPlates:InitNameplateRotationFuncs(nameplate)
    -- nameplate:SelectSpecialAuraToShow
    -- A function that implements HeadpatsPlates.ClassRotation should return the following values:
    -- * spellIcon: The icon to display, or 0 if nothing to display.
    -- * [optional: glowColour]: The colour to glow the icon with, or nil if no glow required.
    -- * [optional: alpha]: The alpha of the icon
    -- * [optional: scale]: The scale of the icon
    -- * [optional: placement]: The placement of the icon to this FramePoint on the nameplate
    -- * [optional: relToPlacement]: The point at which placement is relative to on this icon
    -- * [optional: fitBar]: If true, will fit the icon to the bar (minus border)
    -- * [optional: cb]: Callback to be called if successfully added
    function nameplate:SelectSpecialAuraToShow()
        if (not self.InRange and not self.IsTargetedByPlayer) then
            return nil
        end

        local spellIcon, glowColour, alpha, scale, placement, relToPlacement, fitBar, cb = HeadpatsPlates.ClassData:GetNameplateAbility(self)

        if (not alpha) then
            alpha = 1
        end

        if (not scale) then
            scale = 1
        end

        if (not placement) then
            placement = "CENTER"
        end

        if (not relToPlacement) then
            relToPlacement = placement
        end

        if (not cb) then
            cb = function(...) end
        end

        if (self.CastInfo and self.CastInfo.Aware and not self.IsTargetedByPlayer) then
            -- If it's a cast that's important but not interrupt, we hide any icons on non-selections
            spellIcon = nil
        end

        if (placement == "CENTER" and not self.IsTargetedByPlayer and not self.IsEmphasized) then
            -- Icons on non-target non-emphasized mobs are smaller to reduce visual noise
            scale = scale * 0.5
        end

        -- Invoke user callback for success
        cb()

        return spellIcon, glowColour, alpha, scale, placement, relToPlacement, fitBar
    end

    -- nameplate:GetDebuff
    function nameplate:GetDebuff(spellId)
        return self.Auras:GetAuraBySpellId(spellId)
    end
end
