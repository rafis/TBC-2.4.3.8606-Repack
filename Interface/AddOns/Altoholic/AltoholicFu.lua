-- 07/04/2008 by Thaoky
-- FuBar support file. Initial version inspired by AtlasLootFu. Very early support.

local tablet = AceLibrary("Tablet-2.0");
local L = AceLibrary("AceLocale-2.2"):new("Altoholic")
local WHITE		= "|cFFFFFFFF"
local GREEN		= "|cFF00FF00"

AltoholicFu = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceDB-2.0", "FuBarPlugin-2.0");
AltoholicFu.hasIcon = "Interface\\Icons\\INV_Drink_05"
AltoholicFu.defaultPosition = "LEFT"
AltoholicFu.defaultMinimapPosition = 280

-- Activate menu options to hide icon/text (no point in having the colour option)
AltoholicFu.hasNoColor = true;
AltoholicFu:RegisterDB("AltoholicFuDB");

--Make sure the plugin is the rightt format when activated
function AltoholicFu:OnEnable()
	self:Update();
end

--Define text to display when the cursor mouses over the plugin
function AltoholicFu:OnTooltipUpdate()
	local cat = tablet:AddCategory()
	cat:AddLine("text", WHITE .. L["Left-click to"] .. " " .. GREEN ..L["open/close"] )
end

function AltoholicFu:OnClick(button)
	Altoholic:ToggleUI();
end
