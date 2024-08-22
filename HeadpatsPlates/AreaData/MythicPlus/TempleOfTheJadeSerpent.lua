function HeadpatsPlates:SetAreaDataTempleOfTheJadeSerpent()
    -- BOSSES
    self.EmphasizeBoss[56448] = true -- mari girl
    self.CastAware[397783] = true -- spinny thing
    self.CastAware[397785] = true -- spinny thing
    self.EmphasizeBoss[59051] = true -- strife
    self.EmphasizeBoss[59726] = true -- peril
    self.EmphasizeBoss[56732] = true -- phase 1+2 girl
    self.CastAware[106824] = true -- kinda chill tankbuster
    self.CastAware[106841] = true -- less chill tankbuster
    self.EmphasizeBoss[71955] = true -- big ass dragon
    self.EmphasizeBoss[56439] = true -- o no
    self.CastAware[117665] = true -- transition
    self.EmphasizeAware[56792] = true -- adds

    -- FIRST BOSS AREA
    self.HiddenMob[62358] = true -- useless shits #1
    self.CastInterrupt[397889] = true -- tidal burst
    self.EmphasizeMob[59873] = true -- water elemental
    self.CastAware[397878] = true -- los thing

    -- SECOND BOSS AREA
    self.HiddenMob[58319] = true -- useless shits #2 (they explode lol)
    self.HiddenMob[200388] = true -- useless shits #3 (summoned)
    self.EmphasizeMob[59555] = true -- haunting sha
    self.CastInterrupt[395859] = true -- fear
    self.CastInterrupt[396073] = true -- nap
    self.CastAware[397931] = true -- tankbuster

    -- THIRD BOSS AREA
    self.EmphasizeMob[200387] = true -- infester
    self.CastAware[398300] = true -- frontal 
    self.CastAware[398301] = true -- frontal
    self.EmphasizeMob[200137] = true -- mistweaver
    self.CastInterrupt[397914] = true -- defiling mist
end
