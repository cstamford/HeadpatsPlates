-- HeadpatsLib:InitLog
function HeadpatsLib:InitLog(obj, name)
    obj.LogName = name

    function obj:_Log(txt)
        print(HeadpatsLib:ColText("GOLD_FONT_COLOR", "[" .. self.LogName .. "]:") .. " " .. txt)
    end

    function obj:Log(txt)
        self:_Log(HeadpatsLib:ColText("BRIGHTBLUE_FONT_COLOR", txt))
    end

    function obj:LogWarn(txt)
        self:_Log(HeadpatsLib:ColText("DARKYELLOW_FONT_COLOR", txt))
    end

    function obj:LogError(txt)
        self:_Log(HeadpatsLib:ColText("ERROR_COLOR", txt))
    end

    function obj:LogDebug(txt)
        self:_Log(HeadpatsLib:ColText("DRAGONFLIGHT_GREEN_COLOR", txt))
    end
end
