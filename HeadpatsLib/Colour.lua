-- HeadpatsLib:RGB
function HeadpatsLib:RGB(r, g, b)
    return { R = r, G = g, B = b, A = 1 }
end

-- HeadpatsLib:RGBA
function HeadpatsLib:RGBA(r, g, b, a)
    return { R = r, G = g, B = b, A = a }
end

-- HeadpatsLib:White
function HeadpatsLib:White(alpha)
    return self:RGBA(1, 1, 1, alpha or 1)
end

-- HeadpatsLib:Black
function HeadpatsLib:Black(alpha)
    return self:RGBA(0, 0, 0, alpha or 1)
end

-- HeadpatsLib:Red
function HeadpatsLib:Red(alpha)
    return self:RGBA(1, 0, 0, alpha or 1)
end

-- HeadpatsLib:Green
function HeadpatsLib:Green(alpha)
    return self:RGBA(0, 1, 0, alpha or 1)
end

-- HeadpatsLib:Blue
function HeadpatsLib:Blue(alpha)
    return self:RGBA(0, 0, 1, alpha or 1)
end

-- HeadpatsLib:Yellow
function HeadpatsLib:Yellow(alpha)
    return self:RGBA(1, 1, 0, alpha or 1)
end

-- HeadpatsLib:Cyan
function HeadpatsLib:Cyan(alpha)
    return self:RGBA(0, 1, 1, alpha or 1)
end

-- HeadpatsLib:Magenta
function HeadpatsLib:Magenta(alpha)
    return self:RGBA(1, 0, 1, alpha or 1)
end

-- HeadpatsLib:Greyscale
function HeadpatsLib:Greyscale(num, alpha)
    return self:RGBA(num, num, num, alpha or 1)
end

-- HeadpatsLib:ColText
-- Uses https://wow.tools/dbc/?dbc=globalcolor
function HeadpatsLib:ColText(col, txt)
    return "\124cn" .. col .. ":" .. txt .. "\124r"
end 

-- HeadpatsLib:ColHexText
-- Uses hex codes
function HeadpatsLib:ColHexText(hex, txt)
    return "\124cFF" .. hex .. txt .. "\124r"
end

-- HeadpatsLib:LerpColour
-- This doesn't do proper interpolation, but it's "good enuff"
function HeadpatsLib:LerpColour(a, b, factor)
    return self:RGBA(Lerp(a.R, b.R, factor), Lerp(a.G, b.G, factor), Lerp(a.B, b.B, factor), Lerp(a.A, b.A, factor))
end