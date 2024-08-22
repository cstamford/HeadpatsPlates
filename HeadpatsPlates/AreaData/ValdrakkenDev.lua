-- HeadpatsPlates:SetAreaDataValdrakkenDev()
function HeadpatsPlates:SetAreaDataValdrakkenDev()
    if (HeadpatsPlates.DevCastTest) then
        self.CastInterrupt[HeadpatsPlates.DevCastSpellIds[1] or 0] = true
        self.CastAware[HeadpatsPlates.DevCastSpellIds[2] or 0] = true 
    end

    self.EmphasizeAware[197833] = true
    self.EmphasizeBoss[194643] = true
    self.EmphasizeMob[198594] = true
    self.HiddenMob[189632] = true
end
