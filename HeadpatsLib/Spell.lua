-- HeadpatsLib:MakeCastInfo
function HeadpatsLib:MakeCastInfo(name, text, startTime, endTime, interruptable, spellId)
    return
    {
        Name = name,
        Text = text,
        StartTime = startTime,
        EndTime = endTime,
        Interruptable = interruptable,
        SpellId = spellId
    }
end

-- HeadpatsLib:MakeCastInfoCast
function HeadpatsLib:MakeCastInfoCast(unit)
    local name, text, _, startTime, endTime, _, _, notInterruptible, spellId = UnitCastingInfo(unit)
    return name and self:MakeCastInfo(name, text, startTime, endTime, not notInterruptible, spellId) or nil
end

-- HeadpatsLib:MakeCastInfoChannel
function HeadpatsLib:MakeCastInfoChannel(unit)
    local name, text, _, startTime, endTime, _, notInterruptible, spellId = UnitChannelInfo(unit)
    return name and self:MakeCastInfo(name, text, startTime, endTime, not notInterruptible, spellId) or nil
end

-- HeadpatsLib:MakeCastInfoCastOrChannel
function HeadpatsLib:MakeCastInfoCastOrChannel(unit)
    return self:MakeCastInfoCast(unit) or self:MakeCastInfoChannel(unit)
end

-- HeadpatsLib:GetSpellIcon
function HeadpatsLib:GetSpellIcon(spell)
    if (not self.IconIdCache) then
        self.IconIdCache = { }
    end

    local cached = self.IconIdCache[spell]
    if (cached) then
        return cached
    end

    local icon = C_Spell.GetSpellInfo(spell).originalIconID
    if (icon) then 
        self.IconIdCache[spell] = icon
    end

    return icon  
end

-- HeadpatsLib:SpellReadyOrOnGCD
function HeadpatsLib:SpellReadyOrOnGCD(spell)
    local spellDur = C_Spell.GetSpellCooldown(spell).duration
    local gcdDur = C_Spell.GetSpellCooldown(61304).duration
    return spellDur == 0 or spellDur <= gcdDur
end

-- HeadpatsLib:SpellKnown
function HeadpatsLib:SpellKnown(spell)
    return C_Spell.GetSpellInfo(spell) ~= nil
end
