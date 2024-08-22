function HeadpatsPlates:SetAreaDataAlgetharAcademy()
    -- BOSSES
    self.EmphasizeBoss[196482] = true -- tree
    self.EmphasizeAware[196548] = true -- tree add
    self.CastInterrupt[396640] = true -- tree add heal
    self.CastAware[388923] = true -- burst forth dmg spike
    self.EmphasizeBoss[191736] = true -- bird
    self.EmphasizeBoss[194181] = true -- elemental 
    self.CastAware[385958] = true -- elemental breath
    self.EmphasizeBoss[190609] = true -- dragon
    self.CastAware[374361] = true -- dragon breath

    -- FIRST BOSS AREA
    self.EmphasizeMob[197406] = true -- skitterfly
    self.HiddenMob[197398] = true -- lashers

    -- SECOND BOSS AREA
    self.EmphasizeMob[192680] = true -- guardian sentry
    self.EmphasizeMob[192333] = true -- big boss trash
    self.CastInterrupt[377389] = true -- bird trash call
    self.CastAware[377838] = true -- bird gust (frontal)

    -- THIRD BOSS AREA
    self.EmphasizeMob[196671] = true -- ravager
    self.EmphasizeMob[196044] = true -- book
    self.CastAware[388976] = true -- ravager breath
    self.CastAware[388958] = true -- ravager breath
    self.CastInterrupt[396812] = true -- mystic blast
    self.CastInterrupt[388392] = true -- book lecture

    -- LAST BOSS AREA
    self.EmphasizeMob[196202] = true -- arcane missile bitch
    self.CastInterrupt[387975] = true -- arcane missiles
    self.CastInterrupt[387910] = true -- astral whirlwind
    self.CastInterrupt[387932] = true -- astral whirlwind
end
