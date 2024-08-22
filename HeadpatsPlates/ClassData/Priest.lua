HeadpatsPlatesClassPriest = {}

-- HeadpatsPlatesClassPriest:GetRangeCheckAbility
function HeadpatsPlatesClassPriest:GetRangeCheckAbility(np)
    return "Shadow Word: Pain"
end

-- HeadpatsPlatesClassPriest:GetNameplateAbility
function HeadpatsPlatesClassPriest:GetNameplateAbility(np)


    if (true) then -- Antics edition
        if (np.CastInfo and np.CastInfo.Interrupt) then
            if (HeadpatsLib:SpellReadyOrOnGCD(8122)) then 
                return HeadpatsLib:GetSpellIcon(8122), HeadpatsLib:White() -- fear
            end
        end

        if (np.HealthPercent <= 20) then
            if (HeadpatsLib:SpellReadyOrOnGCD(32379)) then
                local target = np.IsTargetedByPlayer
                return HeadpatsLib:GetSpellIcon(32379), target and HeadpatsLib:Red(), 0.75, 1.0, target and "CENTER" or "LEFT", target and "CENTER" or "LEFT", not target
            end
        end

        if (np.IsTargetedByPlayer) then
            if (HeadpatsLib:SpellReadyOrOnGCD(14914)) then
                return HeadpatsLib:GetSpellIcon(14914), nil, 0.75 -- Holy fire
            end
        end

        local shadowWordPainAura = np:GetDebuff(589)
        if (not shadowWordPainAura or shadowWordPainAura.expirationTime - GetTime() < 5.0) then
            return HeadpatsLib:GetSpellIcon(589), nil, 0.75, 1.0, np.IsTargetedByPlayer and "CENTER" or "LEFT", np.IsTargetedByPlayer and "CENTER" or "LEFT", not np.IsTargetedByPlayer
        end
    
        return nil
    end


    if (true) then -- RAID
        if (np.IsTargetedByPlayer and HeadpatsPlates.PlayerManaPercent <= 90 and HeadpatsLib:SpellReadyOrOnGCD(34433)) then
            return HeadpatsLib:GetSpellIcon(34433), nil, 0.75, 1.5 -- shadowfiend
        end

        local shadowWordPainAura = np:GetDebuff(589)
        if (not shadowWordPainAura or shadowWordPainAura.expirationTime - GetTime() < 5.0) then
            return HeadpatsLib:GetSpellIcon(589), nil, 0.75, 1.5, np.IsTargetedByPlayer and "CENTER" or "LEFT", np.IsTargetedByPlayer and "CENTER" or "LEFT", not np.IsTargetedByPlayer
        end

        if (np.IsTargetedByPlayer and HeadpatsLib:SpellReadyOrOnGCD(14914)) then
            return HeadpatsLib:GetSpellIcon(14914), nil, 0.75, 1.5 -- Holy fire
        end

        return nil
    end



    if (np.IsTargetedByPlayer) then
        if (HeadpatsPlates.PlayerManaPercent <= 90 and HeadpatsLib:SpellReadyOrOnGCD(34433)) then
            return HeadpatsLib:GetSpellIcon(34433), nil, 0.75 -- shadowfiend
        end

        local cdPercent = np.IsBoss and 10 or 35
        if (np.HealthPercent >= cdPercent) then
            local divineWordReady = not np.IsBoss and HeadpatsLib:SpellReadyOrOnGCD(372760)
            local divineWordBuff = AuraUtil.FindAuraByName("Divine Word", "player")
            if (divineWordReady) then
                return HeadpatsLib:GetSpellIcon(372760), nil, 0.75 -- divine word
            end
            if (divineWordBuff) then
                return HeadpatsLib:GetSpellIcon(88625), nil, 0.75 -- chastise
            end
        end

        if (np.HealthPercent >= 20 and HeadpatsLib:SpellReadyOrOnGCD(372616)) then
            return HeadpatsLib:GetSpellIcon(372616), nil, 0.75 -- empyreal blaze
        end
    end

    if (np.HealthPercent <= 20) then
        if (HeadpatsLib:SpellReadyOrOnGCD(32379)) then
            return HeadpatsLib:GetSpellIcon(32379), HeadpatsLib:Red(), nil, 0.5, np.IsTargetedByPlayer and "CENTER" or "LEFT" -- SW:D
        end
    end

    if (np.IsTargetedByPlayer) then
        if (HeadpatsLib:SpellReadyOrOnGCD(110744)) then
            return HeadpatsLib:GetSpellIcon(110744), nil, 0.75 -- divine star
        end 

        if (HeadpatsLib:SpellReadyOrOnGCD(14914)) then
            return HeadpatsLib:GetSpellIcon(14914), nil, 0.75 -- Holy fire
        end
    end

    local shadowWordPainAura = np:GetDebuff(589)
    if (not shadowWordPainAura or shadowWordPainAura.expirationTime - GetTime() < 5.0) then
        return HeadpatsLib:GetSpellIcon(589), nil, 0.75, 0.5, np.IsTargetedByPlayer and "CENTER" or "LEFT", np.IsTargetedByPlayer and "CENTER" or "LEFT", not np.IsTargetedByPlayer
    end

    return nil
end
