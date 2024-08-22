function HeadpatsPlates:SetAreaDataRubyLifePools()
    -- BOSSES
    self.EmphasizeBoss[188252] = true -- chillworm
    self.CastAware[396044] = true -- hail
    self.CastAware[373046] = true -- whelps
    self.EmphasizeBoss[189232] = true -- pug destroyer
    self.CastAware[372107] = true -- boulder
    self.CastAware[372858] = true -- tankbuster
    self.EmphasizeBoss[190484] = true -- dragon
    self.CastAware[381525] = true -- dragon breath
    self.CastAware[381526] = true -- dragon breath
    self.EmphasizeBoss[190485] = true -- useless dude that howls
    self.CastAware[381516] = true -- howl

    -- FIRST BOSS AREA
    self.CastInterrupt[372735] = true -- aoe slam
    self.EmphasizeBoss[187897] = true -- miniboss dude
    self.CastAware[372087] = true -- miniboss dude rush

    -- SECOND BOSS AREA (death lol)
    self.EmphasizeBoss[197698] = true -- miniboss lightning drake
    self.CastAware[391726] = true -- lightning breath
    self.EmphasizeBoss[197697] = true -- miniboss fire drake
    self.CastAware[391723] = true -- fire breath
    self.EmphasizeAware[195119] = true -- avoid these things??
    self.CastAware[373692] = true -- inferno on elemental
    self.EmphasizeMob[190206] = true -- flame dancer
    self.CastInterrupt[385567] = true -- flame dance
    self.CastInterrupt[385536] = true -- flame dance

    -- LAST BOSS AREA
    self.EmphasizeMob[198047] = true -- lighting storm girl
    self.CastAware[392486] = true -- lightning storm
    self.EmphasizeMob[197985] = true -- flashfire girl
    self.CastAware[392452] = true -- flashfire
    self.EmphasizeBoss[197535] = true -- minbioss channeler
end
