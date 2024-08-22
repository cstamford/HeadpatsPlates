-- HeadpatsLib:InitAuraCache
function HeadpatsLib:InitAuraCache(cache)
    -- cache:AddAura
    function cache:AddAura(aura)
        if (not self.FilterCallback(aura)) then
            return
        end

        if (aura.isHelpful) then
            self.HelpfulAuraCount = self.HelpfulAuraCount + 1
        end

        if (aura.isHarmful) then
            self.HarmfulAuraCount = self.HarmfulAuraCount + 1
        end

        local spellIdBucket = HeadpatsLib:FindOrMake(self.AurasSpellIdLookup, aura.spellId)
        table.insert(spellIdBucket, aura)

        self.Auras[aura.auraInstanceID] = aura
        self.AddedCallback(aura)
    end

    -- cache:RemoveAura
    function cache:RemoveAura(instanceId)
        local aura = self.Auras[instanceId]

        if (not aura) then
            -- This can happen due to the filter callback - if we filter out an aura then when
            -- it comes time to remove it, we won't know about it. Business as usual.
            return
        end

        if (aura.isHelpful) then
            self.HelpfulAuraCount = self.HelpfulAuraCount - 1
        end

        if (aura.isHarmful) then
            self.HarmfulAuraCount = self.HarmfulAuraCount - 1
        end

        local spellIdBucket = self.AurasSpellIdLookup[aura.spellId]

        for i, v in ipairs(spellIdBucket or {}) do
            if (v.auraInstanceID == instanceId) then
                table.remove(spellIdBucket, i)
            end
        end

        self.Auras[instanceId] = nil
        self.RemovedCallback(aura)
    end

    -- cache:GetAura
    function cache:GetAura(instanceId)
        return self.Auras[instanceId]
    end

    -- cache:GetFirstAuraWhere
    function cache:GetFirstAuraWhere(fn)
        for _, v in pairs(self.Auras) do
            if (fn(v)) then
                return v
            end
        end
        return nil
    end

    -- cache:GetAuraBySpellId
    function cache:GetAuraBySpellId(spellId)
        local spellIdBucket = self.AurasSpellIdLookup[spellId]
        return spellIdBucket and spellIdBucket[1] or nil
    end

    -- cache:GetAuraBySpellIdUnit
    function cache:GetAuraBySpellIdUnit(spellId, unit)
        return self:GetAuraBySpellIdWhere(spellId, function(aura)
            return aura.sourceUnit and UnitIsUnit(unit, aura.sourceUnit)
        end)
    end

    -- cache:GetAuraBySpellIdWhere
    function cache:GetAuraBySpellIdWhere(spellId, fn)
        local spellIdBucket = self.AurasSpellIdLookup[spellId]
        for _, v in ipairs(spellIdBucket or {}) do
            if (fn(v)) then
                return v
            end
        end
        return nil
    end

    -- cache:Populate
    function cache:Populate(unit)
        -- Remove all existing auras
        for k, _ in pairs(self.Auras) do
            self:RemoveAura(k)
        end

        -- Populate all relevant auras!
        self:_Populate(unit, "HELPFUL")
        self:_Populate(unit, "HARMFUL")
    end

    -- cache:_Populate
    -- Internal only!
    function cache:_Populate(unit, filter)
        local slots = { select(2, C_UnitAuras.GetAuraSlots(unit, filter)) }
        for _, v in ipairs(slots) do
            self:AddAura(C_UnitAuras.GetAuraDataBySlot(unit, v))
        end
    end

    -- cache:OnUnitAura
    -- Helper function to abstract the event away!
    function cache:OnUnitAura(unitTarget, updateInfo)
        -- Full update needs us to fetch every aura ourselves.
        if (updateInfo.isFullUpdate) then
            self:Populate(unitTarget)
        else
            -- Added - we get the whole aura.
            if (updateInfo.addedAuras) then
                for _, aura in ipairs(updateInfo.addedAuras) do
                    self:AddAura(aura)
                end
            end

            -- Updated - we get an instance ID which we can use to find the aura.
            -- Internally we handle this by removing the aura and adding it back again.
            if (updateInfo.updatedAuraInstanceIDs) then
                for _, id in ipairs(updateInfo.updatedAuraInstanceIDs) do
                    local aura = C_UnitAuras.GetAuraDataByAuraInstanceID(unitTarget, id)
                    if (aura) then
                        self:RemoveAura(id)
                        self:AddAura(aura)
                    end
                end
            end

            -- Removed - we get an instance ID which we can use to remove.
            if (updateInfo.removedAuraInstanceIDs) then
                for _, id in ipairs(updateInfo.removedAuraInstanceIDs) do
                    self:RemoveAura(id)
                end
            end
        end
    end

    -- cache:SetFilterCallback
    -- Callback should return true if the aura should be kept, false otherwise
    function cache:SetFilterCallback(cb)
        self.FilterCallback = cb
    end

    -- cache:SetAddedCallback
    function cache:SetAddedCallback(cb)
        self.AddedCallback = cb
    end

    -- cache:SetRemovedCallback
    function cache:SetRemovedCallback(cb)
        self.RemovedCallback = cb
    end

    -- cache:DebugPrintAura
    function cache:DebugPrintAura(unit, aura, hex, logFn)
        local name = GetClassColoredTextForUnit(unit, "<" .. UnitName(unit) .. ">")
        local spellId = " " .. aura.spellId .. " "
        local instanceId =  " [" .. aura.auraInstanceID .. "]"
        local dur = aura.duration > 0 and (" (" .. string.format("%.1f", aura.expirationTime - GetTime()) .. ")") or ""
        local dispelType = aura.dispelName and (" +" .. aura.dispelName .. "+") or ""
        logFn(HeadpatsLib:ColHexText(hex, name .. spellId .. aura.name .. dur .. instanceId .. dispelType))
    end

    cache.Auras = {}
    cache.AurasSpellIdLookup = {}
    cache.HarmfulAuraCount = 0
    cache.HelpfulAuraCount = 0

    cache:SetFilterCallback(function(...) return true end)
    cache:SetAddedCallback(function(...) end)
    cache:SetRemovedCallback(function(...) end)
end
