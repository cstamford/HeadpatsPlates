function HeadpatsPlates:SetAreaDataShadowmoonBurialGround()
    -- BOSSES
    self.EmphasizeBoss[75509] = true -- aoe girl
    self.EmphasizeAware[75966] = true -- aoe girl soul
    self.EmphasizeBoss[75829] = true -- useless void boi
    self.EmphasizeBoss[75452] = true -- wormie
    self.CastAware[153804] = true -- wormie inhale
    self.EmphasizeBoss[76407] = true -- last boss

    -- FIRST BOSS AREA
    self.EmphasizeMob[75713] = true -- bone mender
    self.CastInterrupt[152818] = true -- shadow mend
    self.CastAware[164907] = true -- void slash tankbuster
    self.EmphasizeMob[75652] = true -- void spawn
    self.CastAware[152946] = true -- void pulse aoe dmg
    self.HiddenMob[77006] = true -- skitterlings

    -- SECOND BOSS AREA
    self.CastInterrupt[156776] = true -- voidlash
    self.EmphasizeMob[75979] = true -- summoned spirit
    self.CastInterrupt[156722] = true -- one shot void bolt

    -- THIRD BOSS AREA
    self.EmphasizeMob[76104] = true -- big ass spider
    self.CastInterrupt[153524] = true -- minor spits
end
