-- HeadpatsLib:ClearPixelGlowHandler
function HeadpatsLib:ClearPixelGlowHandler(frame)
    local glowFrame = frame._PixelGlow
    if (glowFrame) then
        glowFrame.OriginalHandler = glowFrame:GetScript("OnUpdate")
        glowFrame:SetScript("OnUpdate", nil)
    end
end

-- HeadpatsLib:UpdatePixelGlow
function HeadpatsLib:UpdatePixelGlow(frame, dt)
    local glowFrame = frame._PixelGlow
    if (glowFrame) then
        glowFrame.OriginalHandler(glowFrame, dt)
    end
end

-- HeadpatsLib:RestorePixelGlowHandler
function HeadpatsLib:RestorePixelGlowHandler(frame)
    local glowFrame = frame._PixelGlow
    if (glowFrame) then    
        local handler = glowFrame.OriginalHandler
        if (handler) then
            glowFrame:SetScript("OnUpdate", handler)
            glowFrame.OriginalHandler = nil
        end
    end
end

-- HeadpatsLib:HasOurPixelGlow
function HeadpatsLib:HasOurPixelGlow(frame)
    return frame._PixelGlow and frame._PixelGlow.OriginalHandler
end
