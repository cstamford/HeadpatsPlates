-- HeadpatsLib:MakeCreatureGuid
function HeadpatsLib:MakeCreatureGuid(guid)
    -- [unitType]-0-[serverID]-[instanceID]-[zoneUID]-[ID]-[spawnUID]
    local unitType, _, serverId, intanceId, zoneUid, npcId, spawnUid = strsplit("-", guid);
    return
    {
        Guid = guid,
        UnitType = unitType,
        ServerId = tonumber(serverId),
        InstanceId = tonumber(intanceId),
        ZoneUid = tonumber(zoneUid),
        NpcId = tonumber(npcId),
        SpawnUid = tonumber(spawnUid)
    }
end

-- HeadpatsLib:MsToSec
function HeadpatsLib:MsToSec(ms)
    return ms / 1000
end

-- HeadpatsLib:SecToMs
function HeadpatsLib:SecToMs(ms)
    return ms * 1000
end

-- HeadpatsLib:ArrayContains
function HeadpatsLib:ArrayContains(arr, val)
    for i, v in ipairs(arr) do
        if v == val then
            return true
        end
    end

    return false
end

-- HeadpatsLib:Copy
function HeadpatsLib:Copy(table)
    local data = {}
    for k, v in pairs(table) do
        data[k] = table[k]
    end
    return data
end

-- HeadpatsLib:CountWhere
function HeadpatsLib:CountWhere(tbl, pred)
    local count = 0
    for i, v in ipairs(tbl) do
        if pred(v) then count = count + 1 end
    end
    return count
end

-- HeadpatsLib:FindOrMake
function HeadpatsLib:FindOrMake(tbl, key)
    local found = tbl[key]
    if (not found) then
        local new = {}
        tbl[key] = new
        return new
    end
    return found
end