-- Global classes
HeadpatsFrames = { }
HeadpatsLib:InitLog(HeadpatsFrames, "HeadpatsFrames") -- Setup logging

-- Dev-only settings
HeadpatsFrames.DevMode = false
HeadpatsFrames.DevPreviewFrames = HeadpatsFrames.DevMode and true
HeadpatsFrames.DevAuraDebug = HeadpatsFrames.DevMode and true
HeadpatsFrames.DevForceIdxAsTank = HeadpatsFrames.DevMode and true and 2
HeadpatsFrames.DevForceConfigIdx = HeadpatsFrames.DevMode and true and 3
HeadpatsFrames.DevAddAurasToAllUnits = HeadpatsFrames.DevMode and false and
{
    {
        auraInstanceID = -1,
        dispelName = "Magic",
        duration = 0,
        expirationTime = nil,
        icon = 132291,
        isFromPlayerOrPlayerPet = false,
        isHarmful = true,
        isHelpful = false,
        name = "Touch of Nothingness",
        sourceUnit = "boss1",
        spellId = 106113,
    },
}

-- Log output for settings that require explicit warning in chat.
if (HeadpatsFrames.DevMode) then
    HeadpatsFrames:Log("Developer mode is enabled!")

    if (HeadpatsFrames.DevPreviewFrames) then
        HeadpatsFrames:Log("Preview frames is enabled.")
    end

    if (HeadpatsFrames.DevAuraDebug) then
        HeadpatsFrames:Log("Aura debug is enabled.")
    end

    if (HeadpatsFrames.DevForceIdxAsTank) then
        HeadpatsFrames:Log("Index " .. HeadpatsFrames.DevForceIdxAsTank .. " is forced tank.")
    end

    if (HeadpatsFrames.DevForceIdxAsTank) then
        HeadpatsFrames:Log("Layout " .. HeadpatsFrames.DevForceConfigIdx .. " is forced.")
    end

    if (HeadpatsFrames.DevAddAurasToAllUnits) then
        HeadpatsFrames:Log("Adding test auras to all units")
    end
end

-- Layout for frames
HeadpatsFramesLayout =
{
    -- User settings
    Config =
    {
        { -- party
            Units = 5,
            Rows = 1,
            Gap = 20,
            Width = 256,
            Height = 196,
            X = 0,
            Y = -512,
            IconWidth = 48,
            IconHeight = 48,
            IconCount = 3,
        },

        { -- raid20
            Units = 20,
            Rows = 2,
            Gap = 4,
            Width = 128,
            Height = 128,
            X = 0,
            Y = -512,
            IconWidth = 32,
            IconHeight = 32,
            IconCount = 2,
        },

        { -- raid40
            Units = 40,
            Rows = 4,
            Gap = 4,
            Width = 128,
            Height = 96,
            X = 0,
            Y = -512,
            IconWidth = 32,
            IconHeight = 32,
            IconCount = 2,
        },
    },

    AlphaInRange = 1.0,
    AlphaOutOfRange = 0.1,
    AlphaDead = 0.05,

    -- Frame settings
    MaxIcons = 3,
    Strata = "LOW",

    Background =
    {
        Level = 0,
        Colour = HeadpatsLib:Greyscale(0.2),
        ColourLowHealth = HeadpatsLib:RGB(0.5, 0, 0),
        EdgeTexture = HeadpatsLib.Assets.BorderPixel,
        EdgeSize = 2,
        EdgeColour = HeadpatsLib:Black(),
        Texture = HeadpatsLib.Assets.DefaultBG
    },

    HealthBar =
    {
        Level = 1,
        Colour = HeadpatsLib:RGB(0.59, 0.93, 0.59),
        ColourLowHealth = HeadpatsLib:RGB(0.59, 0.93, 0.59),
        ColourDispel = HeadpatsLib:RGB(0.31, 0.52, 0.73),
        Texture = HeadpatsLib.Assets.TexStatusBarMinimalist,
    },

    LeftBar =
    {
        Level = 2,
        Colour = HeadpatsLib:Greyscale(0.4, 0.75),
        EdgeTexture = HeadpatsLib.Assets.BorderPixel,
        EdgeSize = 2,
        EdgeColour = HeadpatsLib:Black(),
        Texture = HeadpatsLib.Assets.DefaultBG,
        Width = 10,

        StatusBar =
        {
            Colour = HeadpatsLib:RGB(0.9, 0.55, 0.9),
            Texture = HeadpatsLib.Assets.DefaultStatusBar,
        },
    },

    RightBar =
    {
        Level = 2,
        Colour = HeadpatsLib:Greyscale(0.4, 0.75),
        EdgeTexture = HeadpatsLib.Assets.BorderPixel,
        EdgeSize = 2,
        EdgeColour = HeadpatsLib:Black(),
        Texture = HeadpatsLib.Assets.DefaultBG,
        Width = 10,

        StatusBar =
        {
            Colour = HeadpatsLib:RGB(0.9, 0.55, 0.9),
            Texture = HeadpatsLib.Assets.DefaultStatusBar,
        },
    },

    SpellHint =
    {
        Level = 2,

        Icon =
        {
            ZoomByPixels = 4,
        },
    },

    Hover =
    {
        Level = 4,
        BlendMode = "ADD",
        Colour = HeadpatsLib:White(0.25),
        Texture = HeadpatsLib.Assets.DefaultBG,
    }
}
