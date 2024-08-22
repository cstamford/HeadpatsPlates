HeadpatsPlatesClassPaladin = {}

-- HeadpatsPlatesClassPaladin:GetRangeCheckAbility
function HeadpatsPlatesClassPaladin:GetRangeCheckAbility(np)
    return "Holy Shock"
end

-- HeadpatsPlatesClassPaladin:GetNameplateAbility
function HeadpatsPlatesClassPaladin:GetNameplateAbility(np)
    if (np.CastInfo and np.CastInfo.Interrupt and HeadpatsLib:SpellReadyOrOnGCD(853)) then
        return HeadpatsLib:GetSpellIcon(853), HeadpatsLib:White(), 1.0 -- hoj
    end

    if (np.IsTargetedByPlayer and HeadpatsLib:SpellReadyOrOnGCD(20271)) then
        return HeadpatsLib:GetSpellIcon(20271), nil, 0.75 -- judgement
    end

    if (np.IsTargetedByPlayer and HeadpatsLib:SpellReadyOrOnGCD(35395)) then
        return HeadpatsLib:GetSpellIcon(35395), nil, 0.75 -- crusader strike
    end

    return nil
end
