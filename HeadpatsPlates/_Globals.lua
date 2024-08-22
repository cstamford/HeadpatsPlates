-- Global classes
HeadpatsPlates = { }
HeadpatsLib:InitLog(HeadpatsPlates, "HeadpatsPlates")

-- Dev-only settings
HeadpatsPlates.DevMode = false
HeadpatsPlates.DevCastTest = true
HeadpatsPlates.DevCastSpellIds = { 381529, 315132, 398150, 398150, 398150, 398150, 398150, 398150, 398150, 398150, 398150, 398150  }
HeadpatsPlates.DevCastTargetPlayer = false
HeadpatsPlates.DevDrawClickable = false
HeadpatsPlates.DevMaxPlates = false
HeadpatsPlates.DevMaxActiveNameplatesCount = 1

-- Normal people settings
HeadpatsPlates.EnableProfiler = false -- enable to track CPU usage

-- Log output for settings that require explicit warning in chat.
if (HeadpatsPlates.DevMode) then
    HeadpatsPlates:Log("Developer mode active.")

    if (HeadpatsPlates.DevCastTest) then
        HeadpatsPlates:LogDebug("Developer cast test active: " .. table.concat(HeadpatsPlates.DevCastSpellIds, ' ') .. ".")
    end

    if (HeadpatsPlates.DevCastTargetPlayer) then
        HeadpatsPlates:LogDebug("Developer cast always targets player active.")
    end

    if (HeadpatsPlates.DevDrawClickable) then
        HeadpatsPlates:LogDebug("Developer draw clickable active.")
    end

    if (HeadpatsPlates.DevMaxPlates) then
        HeadpatsPlates:LogDebug("Developer plates limited to " .. HeadpatsPlates.DevMaxActiveNameplatesCount .. ".")
    end
end

if (HeadpatsPlates.EnableProfiler) then
    HeadpatsPlates:Log("Profiling enabled incurring a small performance cost.")
end

-- Layout for plates
HeadpatsPlatesLayout =
{
    -- The major customization settings are here - lower down are individual style settings
    Size = { Width = 128, Height = 20 },
    EmphasisSize = { Width = 256, Height = 40 },
    ClickableAreaPadding = { Width = 64, Height = 16 }, -- Extra padding (above emphasis size) for clickable area

    DrawNameText = false,
    DrawCastTarget = false,
    DrawCastTimer = false,

    RangeCheckFailAlpha = 0.25,

    SelectedScale = 1.5,
    EmphasizedSelectedScale = 1.2,

    -- NAMEPLATE style settings

    Strata = "BACKGROUND",

    Background =
    {
        Level = 0,
        Colour = HeadpatsLib:Greyscale(0.2),
        EdgeColour = HeadpatsLib:Black(),
        EdgeSize = 2,
        Texture = HeadpatsLib.Assets.DefaultBG
    },

    HealthBar =
    {
        Level = 1,
        AwareColour = HeadpatsLib:Green(),
        BossColour = HeadpatsLib:RGB(1, 0, 1),
        Colour = HeadpatsLib:Greyscale(0.6),
        MobColour = HeadpatsLib:RGB(0.576, 0.439, 0.859),
        Texture = HeadpatsLib.Assets.TexHealthBar,

        Text =
        {
            Colour = HeadpatsLib:Greyscale(0.8),
            Font = HeadpatsLib.Assets.FontTsuki,
            Size = 24
        }
    },

    CastBar =
    {
        Level = 2,
        AwareColour = HeadpatsLib:RGBA(0, 1, 1),
        Colour = HeadpatsLib:White(),
        InterruptColour = HeadpatsLib:Red(),
        Texture = HeadpatsLib.Assets.TexCastBar,

        Text =
        {
            Colour = HeadpatsLib:Greyscale(0.8),
            Font = HeadpatsLib.Assets.FontTsuki,
            Size = 24
        },

        CastTargetText =
        {
            Font = HeadpatsLib.Assets.FontFita,
            Size = 16
        },

        CastTimeText =
        {
            Font = HeadpatsLib.Assets.FontFita,
            Size = 16
        },
    },

    -- PixelGlow slots in at level 3!

    Selected =
    {
        Level = 4,
        BlendMode = "ADD",
        Colour = HeadpatsLib:White(0.25),
        Texture = HeadpatsLib.Assets.DefaultBG,
    },

    Hover =
    {
        Level = 5,
        BlendMode = "ADD",
        Colour = HeadpatsLib:White(0.25),
        Texture = HeadpatsLib.Assets.DefaultBG,
    },

    Aura =
    {
        Level = 6,

        Icon =
        {
            Level = 1,
            ZoomByPixels = 4,
        },

        Selected =
        {
            Level = 2,
            BlendMode = "ADD",
            Colour = HeadpatsLib:White(0.1),
            Texture = HeadpatsLib.Assets.DefaultBG,
        },

        Hover =
        {
            Level = 3,
            BlendMode = "ADD",
            Colour = HeadpatsLib:White(0.1),
            Texture = HeadpatsLib.Assets.DefaultBG,
        },
    },

    -- DEV ONLY: CLICKABLE AREA style settings

    ClickableStrata = "BACKGROUND",

    ClickableArea =
    {
        Colour = HeadpatsLib:Red(),
        Texture = HeadpatsLib.Assets.DefaultBG,
    },

    ClickableAreaInner =
    {
        Colour = HeadpatsLib:Green(),
        Texture = HeadpatsLib.Assets.DefaultBG,
    },
}
