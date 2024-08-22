-- HeadpatsLib:IsTraitEnabled
function HeadpatsLib:IsTraitEnabled(nodeId, configId)
    return self:GetTraitRanks(nodeId, configId) > 0
end

-- HeadpatsLib:GetTraitRanks
-- Note: configId is optional (will default to active config)
function HeadpatsLib:GetTraitRanks(nodeId, configId)
    return C_Traits.GetNodeInfo(configId or C_ClassTalents.GetActiveConfigID(), nodeId).ranksPurchased
end
