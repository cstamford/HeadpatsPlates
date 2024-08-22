-- HeadpatsPlates:SetAreaDataStormwindDev()
function HeadpatsPlates:SetAreaDataStormwindDev()
    if (HeadpatsPlates.DevCastTest) then
        self.CastInterrupt[HeadpatsPlates.DevCastSpellIds[1] or 0] = true
        self.CastAware[HeadpatsPlates.DevCastSpellIds[2] or 0] = true 
    end

    self.EmphasizeAware[114832] = true
    self.EmphasizeBoss[31146] = true
    self.EmphasizeMob[153292] = true
end
