function HeadpatsPlates:SetAreaDataHallsOfValor()
    -- BOSSES
    self.EmphasizeBoss[94960] = true -- heimerdinger
    self.EmphasizeBoss[95833] = true -- healing girl
    self.CastAware[192018] = true -- shield of light (frontal)
    self.EmphasizeBoss[95674] = true -- wolf
    self.EmphasizeBoss[99868] = true -- wolf
    self.CastAware[196543] = true -- howl
    self.EmphasizeBoss[95675] = true -- fel dude
    self.CastAware[193659] = true -- felblaze rush
    self.EmphasizeBoss[95676] = true -- ODIN!

    -- FIRST BOSS AREA
    self.EmphasizeMob[95842] = true -- thundercaller
    self.CastInterrupt[215429] = true -- thunderstrike
    self.CastInterrupt[215430] = true -- thunderstrike
    self.EmphasizeMob[97068] = true -- storm drake
    self.CastAware[198888] = true -- breath

    -- SECOND/THIRD BOSS AREA
    self.CastAware[199050] = true -- mortal hew (frontal)
    self.CastAware[199805] = true -- crackle on sentinel
    self.EmphasizeMob[95834] = true -- mystic
    self.CastInterrupt[198934] = true -- rune of healing
    self.CastInterrupt[215433] = true -- holy radiance
    self.EmphasizeMob[101637] = true -- aspirant
    self.CastAware[191508] = true -- blast of light (frontal)
    self.EmphasizeBoss[97219] = true -- miniboss: lightning dude
    self.EmphasizeBoss[97202] = true -- miniboss: holy dude
    self.EmphasizeMob[97068] = true -- storm drake #2 (fenryr area)
end
