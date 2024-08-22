-- HeadpatsLib:InitUpdateTime
function HeadpatsLib:InitUpdateTime(obj)

    obj.UpdateTime = GetTime()
    obj.UpdateTimeImportantLast = obj.UpdateTime + random(0.0, 0.1)
    obj.UpdateTimeNormalLast = obj.UpdateTime + random(0.0, 0.1)
    obj.UpdateTimeSlowLast = obj.UpdateTime + random(0.0, 0.1)

    -- obj:UpdateTimeTargets
    function obj:UpdateTimeTargets(important, normal, slow)
        self.UpdateTimeImportant = important
        self.UpdateTimeNormal = normal
        self.UpdateTimeSlow = slow
    end

    -- obj:UpdateTimeState
    function obj:UpdateTimeState(time)
        self.UpdateTime = time

        local timePassedImportant = self.UpdateTime - self.UpdateTimeImportantLast
        local timePassedNormal = self.UpdateTime - self.UpdateTimeNormalLast
        local timePassedSlow = self.UpdateTime - self.UpdateTimeSlowLast
    
        self.UpdateImportantReady = timePassedImportant >= self.UpdateTimeImportant
        self.UpdateNormalReady = timePassedNormal >= self.UpdateTimeNormal
        self.UpdateSlowReady = timePassedSlow >= self.UpdateTimeSlow

        if (self.UpdateImportantReady) then
            self.UpdateTimeImportantLast = self.UpdateTime
            self.UpdateImportantDt = timePassedImportant
        end

        if (self.UpdateNormalReady) then
            self.UpdateTimeNormalLast = self.UpdateTime
            self.UpdateNormalDt = timePassedNormal
        end

        if (self.UpdateSlowReady) then
            self.UpdateTimeSlowLast = self.UpdateTime
            self.UpdateSlowDt = timePassedSlow
        end
    end
end
