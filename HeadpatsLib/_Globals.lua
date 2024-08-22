-- Global classes
HeadpatsLib = { }
HeadpatsLib.Class =
{
    ["WARRIOR"] = {},
    ["PALADIN"] = {},
    ["HUNTER"] = {},
    ["ROGUE"] = {},
    ["PRIEST"] = {},
    ["DEATHKNIGHT"] = {},
    ["SHAMAN"] = {},
    ["MAGE"] = {},
    ["WARLOCK"] = {},
    ["MONK"] = {},
    ["DRUID"] = {},
    ["DEMONHUNTER"] = {},
    ["EVOKER"] = {},
}

-- Any external libraries we reference, load with LibStub now!
HeadpatsLib.LCG = LibStub("LibCustomGlow-1.0")

-- Asset paths
HeadpatsLib.Assets =
{
    DefaultBG = [[Interface\Tooltips\UI-Tooltip-Background]],
    DefaultBorder = [[Interface\Tooltips\UI-Tooltip-Border]],
    DefaultFont = [[Fonts\FRIZQT__.ttf]],
    DefaultStatusBar = [[Interface\TargetingFrame\UI-StatusBar]],
    FontFita = [[Interface\Addons\HeadpatsLib\Assets\FiraMono.ttf]],
    FontTsuki = [[Interface\Addons\HeadpatsLib\Assets\NineTsukiRegular.ttf]],
    TexCastBar = [[Interface\Addons\HeadpatsLib\Assets\CastBar.tga]],
    TexHealthBar = [[Interface\Addons\HeadpatsLib\Assets\HealthBar.tga]],
    TexStatusBarFlat = [[Interface\Addons\HeadpatsLib\Assets\StatusBarFlat.tga]],
    TexStatusBarMinimalist = [[Interface\Addons\HeadpatsLib\Assets\StatusBarMinimalist.tga]],
    TexStatusBarStriped = [[Interface\Addons\HeadpatsLib\Assets\StatusBarStriped.blp]],
    BorderPixel = [[Interface\Addons\HeadpatsLib\Assets\PixelBorder.blp]]
}
