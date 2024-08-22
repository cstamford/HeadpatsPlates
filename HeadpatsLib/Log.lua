-- HeadpatsLib:InitLog
function HeadpatsLib:InitLog(obj, name)
    obj.LogName = name

    local function safeFormat(txt, ...)
        local args = {...}
        for i = 1, select('#', ...) do
            if args[i] == nil then
                args[i] = "nil"
            else
                args[i] = tostring(args[i])
            end
        end
        return string.format(txt, unpack(args))
    end

    function obj:_Log(txt)
        print(HeadpatsLib:ColText("GOLD_FONT_COLOR", "[" .. self.LogName .. "]:") .. " " .. txt)
    end

    function obj:Log(txt, ...)
        self:_Log(HeadpatsLib:ColText("BRIGHTBLUE_FONT_COLOR", safeFormat(txt, ...)))
    end

    function obj:LogWarn(txt, ...)
        self:_Log(HeadpatsLib:ColText("DARKYELLOW_FONT_COLOR", safeFormat(txt, ...)))
    end

    function obj:LogError(txt, ...)
        self:_Log(HeadpatsLib:ColText("ERROR_COLOR", safeFormat(txt, ...)))
    end

    function obj:LogDebug(txt, ...)
        self:_Log(HeadpatsLib:ColText("DRAGONFLIGHT_GREEN_COLOR", safeFormat(txt, ...)))
    end
end