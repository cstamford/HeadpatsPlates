HeadpatsPlatesClassDruid = {}

-- HeadpatsPlatesClassDruid:GetRangeCheckAbility
function HeadpatsPlatesClassDruid:GetRangeCheckAbility(np)
    return "Wrath"
end

-- HeadpatsPlatesClassDruid:ShouldRefreshDots
function HeadpatsPlatesClassDruid:ShouldRefreshDots(np)
    return np.HealthPercent >= (np.IsBoss and 5 or 25)
end

-- HeadpatsPlatesClassDruid:GetDotLayout
function HeadpatsPlatesClassDruid:GetDotLayout(np)
    local dotPos = np.IsTargetedByPlayer and "CENTER" or "LEFT"
    local dotRelTo = np.IsTargetedByPlayer and "CENTER" or "RIGHT"
    local dotFitBar = not np.IsTargetedByPlayer
    return nil, 0.75, nil, dotPos, dotRelTo, dotFitBar
end

-- HeadpatsPlatesClassDruid:SelectNextCatFinisher
function HeadpatsPlatesClassDruid:SelectNextCatFinisher(np, time, cp, energy)
    local rip = np:GetDebuff(1079)
    local ripReady = not rip or rip.expirationTime - time < 4.5
    local finisherReadyCol = HeadpatsLib:RGB(1, 1, 0)

    if (cp == 5 and ripReady) then
        local hasEnergy = energy >= 20
        return 1079, hasEnergy and finisherReadyCol or nil, hasEnergy and 0.75 or 0.25
    end

    if (cp == 5) then
        local hasEnergy = energy >= 50
        return 22568, hasEnergy and finisherReadyCol or nil, hasEnergy and 0.75 or 0.25
    end

    return 0
end

-- HeadpatsPlatesClassDruid:SelectNextCatAbility
function HeadpatsPlatesClassDruid:SelectNextCatAbility(np, time)
    local thrash = np:GetDebuff(106830)
    if (not thrash or thrash.expirationTime - time < 4.5) then
        return 106830, self:GetDotLayout(np)
    end

    local rake = np:GetDebuff(155722)
    if (not rake or rake.expirationTime - time < 4.5) then
        return 155722, self:GetDotLayout(np)
    end

    return 0
end

-- HeadpatsPlatesClassDruid:SelectNextCooldown
function HeadpatsPlatesClassDruid:SelectNextCooldown(np, time)   
    if (HeadpatsLib:SpellReadyOrOnGCD(319454)) then -- heart of the wild
        return 319454, nil, 0.75
    end

    if (HeadpatsLib:SpellReadyOrOnGCD(391528)) then -- convoke
        return 391528, nil, 0.75
    end

    if (HeadpatsLib:SpellReadyOrOnGCD(197626)) then -- starsurge
        return 197626, nil, 0.75
    end

    return 0
end

-- HeadpatsPlatesClassDruid:SelectNextBoomAbility
function HeadpatsPlatesClassDruid:SelectNextBoomAbility(np, time)
    local sunfire = np:GetDebuff(164815)
    if (not sunfire or sunfire.expirationTime - time < 5.4) then
        return 164815, self:GetDotLayout(np)
    end

    local moonfire = np:GetDebuff(164812)
    if (not moonfire or moonfire.expirationTime - time < 5.4) then
        return 164812, self:GetDotLayout(np)
    end

    return 0
end

-- HeadpatsPlatesClassDruid:GetNameplateAbility
function HeadpatsPlatesClassDruid:GetNameplateAbility(np)
    local time = GetTime()
    local cp = GetComboPoints("player", "target")
    local energy = UnitPower("player", Enum.PowerType.Energy)

    local catFinAbility, catFinGlow, catFinAlpha, catFinScale, catFinPos, catFinRelTo, catFinFit = self:SelectNextCatFinisher(np, time, cp, energy)

    if (HeadpatsLib:InRaidArea()) then
        if (np.IsTargetedByPlayer) then
            -- * Use starsurge on CD (flash it, big scale)
            if (HeadpatsLib:SpellReadyOrOnGCD(197626)) then
                return HeadpatsLib:GetSpellIcon(197626), HeadpatsLib:White(), 0.75, 1.5
            end
        end

        -- * Maintain moonfire
        local moonfire = np:GetDebuff(164812)
        if (not moonfire or moonfire.expirationTime - time < 5.4) then
            return HeadpatsLib:GetSpellIcon(164812), self:GetDotLayout(np)
        end

        if (np.IsTargetedByPlayer) then
            -- * Heart of the Wild
            if (HeadpatsLib:SpellReadyOrOnGCD(319454)) then
                return HeadpatsLib:GetSpellIcon(319454), nil, 0.75
            end

            -- * Normal cat finishers
            if (catFinAbility ~= 0) then
                return HeadpatsLib:GetSpellIcon(catFinAbility), catFinGlow, catFinAlpha, catFinScale, catFinPos, catFinRelTo, catFinFit
            end

            -- * Rake if no rake
            local rake = np:GetDebuff(155722)
            if (not rake or rake.expirationTime - time < 4.5) then
                return HeadpatsLib:GetSpellIcon(155722), self:GetDotLayout(np)
            end
        end
    else
        local sameFormCb = function(...) np.Aura.SameForm = true end
        local diffFormCb = function(...) np.Aura.SameForm = false end

        local formId = GetShapeshiftForm()
        local inBoomieForm = formId == 0 or formId == 4 
        local inCatForm = formId == 2

        local cdAbility, cdGlow, cdAlpha, cdScale, cdPos, cdRelTo, cdFit = self:SelectNextCooldown(np, time)
        local catAbility, catGlow, catAlpha, catScale, catPos, catRelTo, catFit = self:SelectNextCatAbility(np, time)
        local boomAbility, boomGlow, boomAlpha, boomScale, boomPos, boomRelTo, boomFit = self:SelectNextBoomAbility(np, time)

        -- * Cat finishers
        if (np.IsTargetedByPlayer and catFinAbility ~= 0) then 
            return HeadpatsLib:GetSpellIcon(catFinAbility), catFinGlow, catFinAlpha, catFinScale, catFinPos, catFinRelTo, catFinFit, sameFormCb
        end

        -- * In cat form and >= 30 energy, cat abilities
        if (inCatForm and energy >= 30 and catAbility ~= 0) then
            return HeadpatsLib:GetSpellIcon(catAbility), catGlow, catAlpha, catScale, catPos, catRelTo, catFit, sameFormCb
        end

        -- * Cooldowns
        if (np.IsTargetedByPlayer and cdAbility ~= 0) then
            return HeadpatsLib:GetSpellIcon(cdAbility), cdGlow, cdAlpha, cdScale, cdPos, cdRelTo, cdFit, sameFormCb
        end

        -- * In boomie form, boomie abilities
        if (inBoomieForm and boomAbility ~= 0) then
            return HeadpatsLib:GetSpellIcon(boomAbility), boomGlow, boomAlpha, boomScale, boomPos, boomRelTo, boomFit, sameFormCb
        end

        -- * In cat form, Cat abilities
        if (inCatForm and catAbility ~= 0) then
            return HeadpatsLib:GetSpellIcon(catAbility), catGlow, catAlpha, catScale, catPos, catRelTo, catFit, sameFormCb
        end

        local plateCountWithAurasShown = HeadpatsLib:CountWhere(HeadpatsPlates.Nameplates,
        function(otherNp)
            return otherNp:IsAssigned() and otherNp.Aura:IsShown() and otherNp.Aura.SameForm
        end)

        -- * If targeting directly, show other form abilities
        -- * In boomie form and no boomie abilities on nearby plates, cat abilities
        -- * In cat form and no cat abilities on nearby plates, boomie abilities
        if (np.IsTargetedByPlayer or plateCountWithAurasShown == 0) then
            if (inBoomieForm and catAbility ~= 0) then
                return HeadpatsLib:GetSpellIcon(catAbility), catGlow, catAlpha, catScale, catPos, catRelTo, catFit, diffFormCb
            end         
            if (inCatForm and boomAbility ~= 0) then
                return HeadpatsLib:GetSpellIcon(boomAbility), boomGlow, boomAlpha, boomScale, boomPos, boomRelTo, boomFit, diffFormCb
            end
        end
    end

    return nil
end
