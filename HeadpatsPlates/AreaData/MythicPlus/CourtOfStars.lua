function HeadpatsPlates:SetAreaDataCourtOfStars()
    -- BOSSES
    self.EmphasizeBoss[104215] = true -- lockdown guy
    self.CastAware[207278] = true -- lockdown
    self.EmphasizeBoss[104217] = true -- imp girl
    self.CastAware[207881] = true -- summon imps boss
    self.EmphasizeBoss[104218] = true -- aoe dmg bro
    self.CastAware[209676] = true -- maelstrom
    self.CastAware[209678] = true -- maelstrom

    -- FIRST BOSS AREA
    self.EmphasizeAware[104251] = true -- sentry
    self.EmphasizeMob[104247] = true -- arcanist
    self.EmphasizeMob[105705] = true -- elemental
    self.CastInterrupt[209410] = true -- nightfall orb
    self.CastInterrupt[212031] = true -- charged blast
    self.CastAware[209027] = true -- quelling strike (frontal)
    self.CastAware[209495] = true -- charged smash (frontal)
    self.HiddenMob[105703] = true -- useless hidden things

    -- SECOND BOSS AREA
    self.EmphasizeMob[105715] = true -- inquisitor
    self.CastInterrupt[212784] = true -- eye storm
    self.CastAware[211464] = true -- fel detonation

    self.EmphasizeBoss[104278] = true -- miniboss fel enforcer
    self.EmphasizeBoss[104275] = true -- miniboss hot demon
    self.EmphasizeBoss[104274] = true -- miniboss beholder
    self.EmphasizeBoss[104273] = true -- miniboss manly demon
    self.CastAware[397892] = true -- aoe scream silence
    self.CastAware[207979] = true -- frontal

    -- LAST BOSS AREA
    self.EmphasizeBoss[107435] = true -- miniboxx vampire
    self.CastAware[214692] = true -- volley
    self.EmphasizeAware[190174] = true -- bat
    self.CastAware[373618] = true -- hypnosis cast
end
