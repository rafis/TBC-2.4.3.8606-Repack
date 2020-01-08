local _G = getfenv(0);

-- Saved Data Tables
local cfg, cache;
Examiner_Config = { activePage = 3 }; -- Set activePage here as we do not want to revert to default value as this variable can be nil, but still want to be non-nil the first time Examiner is run.
Examiner_Cache = {};

local EX_DefaultConfig = {
	EnableCache = true,
	CachePvP = false,
	CombineAdditiveStats = true,
	RatingsInPercent = false,
	ActAsUIFrame = true,
	AutoInspect = true,
	AcceptAddonMsg = false,
	ScanUnknownItems = false,
	cacheSort = "class",
	cacheFilter = "",
	scale = 1,
	showBackground = true,
};

-- Working Vars
local u = {};
local ExStats = {};
local ExSets = {};
local ExCacheList = {};
local ExStatList = {};
local ExCompare;

-- Misc Constants
local EX_MagicSchools = { "FIRE", "NATURE", "ARCANE", "FROST", "SHADOW", "HOLY" };
local EX_Checks = {
	{ var = "EnableCache", label = "Enable Caching of Players", tip = "If enabled, everytime you inspect a player, their items will be cached so you can look them up later." },
	{ var = "CachePvP", label = "Cache Honor and Arena Details", tip = "In addition to normal item caching, this option will cache honor and arena team details as well when enabled. When normal caching is disabled, this option has no effect." },
	{ var = "CombineAdditiveStats", label = "Combine Additive Stats", tip = "This option makes sure that certain stats which stacks with others, gets combined at the stats page. This include Spell Damage to specific spell schools, AP to Feral AP and AP to Ranged AP." },
	{ var = "RatingsInPercent", label = "Show Ratings in Percentage", tip = "With this option enabled, ratings will be displayed in percent relative to the inspected person's level." },
	{ var = "ActAsUIFrame", label = "Act as UI Frame", tip = "Enabled, Examiner will act like a normal UI frame, like Talents, Quest Log and the Mailbox frame.\nIf you want to be able to move Examiner around, disable this option." },
	{ var = "AutoInspect", label = "Auto Inspect on Target Change", tip = "With this option turned on, Examiner will automatically inspect your target when you change it." },
	{ var = "AcceptAddonMsg", label = "Accept AddOn Messages", tip = "When this option is enabled, Examiner can accept inspection data from other people with Examiner." },
	{ var = "ScanUnknownItems", label = "Scan Unknown Cached Items", tip = "When loading from the cache, Examiner will normally ignore items that was not found in the local item cache, to avoid getting you DC'd. You can override that behavior with this option, at the risk of DC's." },
};

-- Texture Mapping
local EX_Backgrounds = {
	"DruidBalance",
	"DruidFeralCombat",
	"DruidRestoration",
	"HunterBeastMastery",
	"HunterMarksmanship",
	"HunterSurvival",
	"MageArcane",
	"MageFire",
	"MageFrost",
	"PaladinCombat",
	"PaladinHoly",
	"PaladinProtection",
	"PriestDiscipline",
	"PriestHoly",
	"PriestShadow",
	"RogueAssassination",
	"RogueCombat",
	"RogueSubtlety",
	"ShamanElementalCombat",
	"ShamanEnhancement",
	"ShamanRestoration",
	"WarlockCurses",
	"WarlockDestruction",
	"WarlockSummoning",
	"WarriorArms",
	"WarriorFury",
	"WarriorProtection",
};

-- RaceCoords. For females, add 0.5 to "top" and "bottom".
-- Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races
local EX_RaceCoord = {
	["Human"]		= { left = 0/8, right = 1/8, top = 0/4, bottom = 1/4 },
	["Dwarf"]		= { left = 1/8, right = 2/8, top = 0/4, bottom = 1/4 },
	["Gnome"]		= { left = 2/8, right = 3/8, top = 0/4, bottom = 1/4 },
	["NightElf"]	= { left = 3/8, right = 4/8, top = 0/4, bottom = 1/4 },
	["Draenei"]		= { left = 4/8, right = 5/8, top = 0/4, bottom = 1/4 },
	["Tauren"]		= { left = 0/8, right = 1/8, top = 1/4, bottom = 2/4 },
	["Scourge"]		= { left = 1/8, right = 2/8, top = 1/4, bottom = 2/4 },
	["Troll"]		= { left = 2/8, right = 3/8, top = 1/4, bottom = 2/4 },
	["Orc"]			= { left = 3/8, right = 4/8, top = 1/4, bottom = 2/4 },
	["BloodElf"]	= { left = 4/8, right = 5/8, top = 1/4, bottom = 2/4 },
};

-- Init Specific Mod Vars
local modName = "Examiner";
local ex;
local funcs = {};

--------------------------------------------------------------------------------------------------------
--                                         OnLoad & OnUpdate                                          --
--------------------------------------------------------------------------------------------------------

-- OnShow / OnHide
local function ExEvent_OnShow(self)
	ex:RegisterEvent("PLAYER_TARGET_CHANGED");
	ex:RegisterEvent("UNIT_MODEL_CHANGED");
	ex:RegisterEvent("UNIT_PORTRAIT_UPDATE");
	ex:RegisterEvent("UNIT_INVENTORY_CHANGED");
	ex:RegisterEvent("INSPECT_HONOR_UPDATE");
end

local function ExEvent_OnHide(self)
	ex.model.isRotating = nil;
	ex.model.isPanning = nil;
	ex:UnregisterEvent("PLAYER_TARGET_CHANGED");
	ex:UnregisterEvent("UNIT_MODEL_CHANGED");
	ex:UnregisterEvent("UNIT_PORTRAIT_UPDATE");
	ex:UnregisterEvent("UNIT_INVENTORY_CHANGED");
	ex:UnregisterEvent("INSPECT_HONOR_UPDATE");
end

-- OnUpdate
local function ExEvent_OnUpdate(self,elapsed)
	if (funcs.CheckLastUnit()) and (CheckInteractDistance(u.token,1)) then
		Examiner_InspectUnit(u.token);
	end
end

--------------------------------------------------------------------------------------------------------
--                                           Event Handling                                           --
--------------------------------------------------------------------------------------------------------

local function ExEvent_OnEvent(self,event)
	-- Variables Loaded
	if (event == "VARIABLES_LOADED") then
		cfg = Examiner_Config;
		cache = Examiner_Cache;
		-- Default Config
		for option, defValue in pairs(EX_DefaultConfig) do
			if (cfg[option] == nil) then
				cfg[option] = defValue;
			end
		end
		-- SET: Background Visibility | Scale | Frame Movability
		funcs.ShowBackground();
		self:SetScale(cfg.scale);
		self:SetMovable(not cfg.ActAsUIFrame);
		-- Build Cache List
		if (cfg.activePage == 2) then
			funcs.BuildCacheList();
		end
	-- AddOn Messages
	elseif (event == "CHAT_MSG_ADDON") and (cfg.AcceptAddonMsg) then
		if (arg3 == "WHISPER") and (arg2 ~= "") and (arg1:sub(1,8) == "EXAMINER") then
			-- Split
			local entryName, data = arg1:match("^EXAMINER#(.-)#(.+)$");
			data = { entryName, ("\\"):split(data) };
			-- Special Commands
			if (data[2] and data[2] == "CMD") then
				if (arg2 == "CLEAR") then
					cache[data[1]] = { Items = {}, Sets = {} };
				elseif (arg2 == "DONE") then
					AzMsg("|2Examiner|r Received inspection data for |1"..funcs.PlayerChatLink(data[1]).."|r from |1"..funcs.PlayerChatLink(arg4).."|r.");
					SendAddonMessage("EXAMINER#"..data[1].."#CMD","RECIEVED","WHISPER",arg4);
					if (cfg.activePage == 2) then
						funcs.BuildCacheList();
					end
				elseif (arg2 == "RECIEVED") then
					AzMsg("|2Examiner|r Your data of |1"..funcs.PlayerChatLink(data[1]).."|r was received by |1"..funcs.PlayerChatLink(arg4).."|r.");
				end
				return;
			end
			-- Fill out table
			local cacheTable = cache;
			for i = 1, #data - 1 do
				if (not cacheTable[data[i]]) then
					cacheTable[data[i]] = {};
				end
				cacheTable = cacheTable[data[i]];
			end
			-- Set Value
			cacheTable[data[#data]] = (tonumber(arg2) and tonumber(arg2) or arg2);
		end
	-----------------------------------------------------
	-- Events Which Happens Only When Examiner Is Open --
	-----------------------------------------------------
	-- Target Unit Changed
	elseif (event == "PLAYER_TARGET_CHANGED") then
		if (cfg.AutoInspect) and (UnitExists("target")) then
			Examiner_InspectUnit("target");
		elseif (u.token == "target") then
			u.token = nil;
			ex:SetScript("OnUpdate",nil);
		end
	-- Mouseover Unit Changed
	elseif (event == "UPDATE_MOUSEOVER_UNIT") then
		u.token = nil;
		ex:SetScript("OnUpdate",nil);
		self:UnregisterEvent("UPDATE_MOUSEOVER_UNIT");
	-- Model or Portrait Change
	elseif (event == "UNIT_MODEL_CHANGED" or event == "UNIT_PORTRAIT_UPDATE") then
		if (funcs.CheckLastUnit() and UnitIsUnit(arg1,u.token)) then
			ex.model:ClearModel();
			ex.model:SetUnit(u.token);
			SetPortraitTexture(ex.portrait,u.token);
		end
	-- Refresh on Item Change
	elseif (event == "UNIT_INVENTORY_CHANGED") then
		if (funcs.CheckLastUnit() and UnitIsUnit(arg1,u.token) and CheckInteractDistance(u.token,1)) then
			Examiner_InspectUnit(u.token);
		end
	-- Honor Update
	elseif (event == "INSPECT_HONOR_UPDATE") then
		funcs.PVPUpdate();
	-- Talent Update
	elseif (event == "INSPECT_TALENT_READY") then
		self:UnregisterEvent("INSPECT_TALENT_READY");
		if (ExaminerTalents:IsShown()) then
			funcs.TalentsTabs_Update();
			TalentFrame_Update(ex);
		end
		local a, b, c = select(3,GetTalentTabInfo(1,true)), select(3,GetTalentTabInfo(2,true)), select(3,GetTalentTabInfo(3,true));
		u.talents = a.."/"..b.."/"..c;
		-- Fancy level estimate since we can determine it from talents
 		if (u.level == -1) and (a + b + c > 0) then
			u.level = (a + b + c + 9);
			ex.details:SetText(funcs.UnitDetailString());
			funcs.BuildStatList();
		end
		if (cfg.EnableCache) then
			local cacheEntry = cache[funcs.GetEntryName()];
			if (cacheEntry) and (time() - cacheEntry.time <= 8) then
				cacheEntry.talents = u.talents;
				cacheEntry.level = u.level;
			end
		end
	end
end

--------------------------------------------------------------------------------------------------------
--                                           Slash Handling                                           --
--------------------------------------------------------------------------------------------------------
_G["SLASH_"..modName.."1"] = "/examiner";
_G["SLASH_"..modName.."2"] = "/ex";
SlashCmdList[modName] = function(cmd)
	-- Extract Parameters
	local param1, param2 = cmd:match("^([^%s]+)%s*(.*)$");
	param1 = (param1 and param1:lower() or cmd:lower());
	-- Inspect!
	if (param1 == "inspect" or param1 == "i") then
		Examiner_InspectUnit(param2 == "" and "target" or param2);
	-- Scan a Single Item
	elseif (param1 == "si") then
		if (param2 ~= "") then
			local itemStats = {};
			ExScanner:ScanItemLink(param2,itemStats);
			AzMsg("--- |2Scan Overview for "..param2.."|r ---");
			for stat in pairs(itemStats) do
				AzMsg((ExScanner.StatNames[stat] or stat).." = |1"..funcs.GetStatValue(stat,itemStats,nil,UnitLevel("player")).."|r.");
			end
		else
			AzMsg("No item link given.");
		end
	-- Compares two Items
	elseif (param1 == "compare") then
		if (param2 ~= "") then
			local item1, item2 = param2:match("(|c.+|r)%s+(|c.+|r)");
			if (item1 and item2) then
				local itemStats1, itemStats2 = {}, {};
				ExScanner:ScanItemLink(item1,itemStats1);
				ExScanner:ScanItemLink(item2,itemStats2);
				AzMsg("--- |2Compare of "..item1.."|2 to "..item2.."|r ---");
				for statToken, statName in pairs(ExScanner.StatNames) do
					if (itemStats1[statToken] or itemStats2[statToken]) then
						AzMsg(statName.." = |1"..funcs.GetStatValue(statToken,itemStats1,itemStats2,UnitLevel("player")).."|r.");
					end
				end
			else
				AzMsg("Could not parse item links.");
			end
		else
			AzMsg("No item links given.");
		end
	-- Arena Calculator
	elseif (param1 == "arena") then
		param2 = tonumber(param2);
		if (type(param2) == "number") then
			AzMsg(format("|2Arena Point Calculation|r |1%d|r Rating |2=|r 2v2: |1%.1f|r, 3v3: |1%.1f|r, 5v5: |1%.1f|r.",param2,funcs.CalculateArenaPoints(param2,2),funcs.CalculateArenaPoints(param2,3),funcs.CalculateArenaPoints(param2,5)));
		end
	-- Scale
	elseif (param1 == "scale") then
		param2 = tonumber(param2);
		if (type(param2) == "number") then
			cfg.scale = param2;
			ex:SetScale(param2);
		end
	-- Clear Cache
	elseif (param1 == "clearcache") then
		Examiner_Cache = {};
		cache = Examiner_Cache;
		if (ex.activePage == 2) then
			funcs.BuildCacheList();
		end
	-- Invalid or No Command
	else
		UpdateAddOnMemoryUsage();
		AzMsg(format("----- |2%s|r |1%s|r ----- |1%.2f |2kb|r -----",modName,GetAddOnMetadata(modName,"Version"),GetAddOnMemoryUsage(modName)));
		AzMsg("The following |2parameters|r are valid for this addon:");
		AzMsg(" |2inspect 'unit'|r = Inspects the given unit ('target' if no unit given)");
		AzMsg(" |2si 'itemlink'|r = Scans one item and shows the total sum of its stats combined");
		AzMsg(" |2compare 'itemlink1' 'itemlink2'|r = Compares two items by listing the stat differences");
		AzMsg(" |2arena 'rating'|r = Arena Point Calculator");
		AzMsg(" |2scale 'value'|r = Sets the scale of the Examiner window (Default is 1)");
		AzMsg(" |2clearcache|r = Clears the entire Examiner cache");
	end
end

--------------------------------------------------------------------------------------------------------
--                                Global Chat Message Function (Rev 3)                                --
--------------------------------------------------------------------------------------------------------
if (not AZMSG_REV or AZMSG_REV < 3) then
	AZMSG_REV = 3;
	function AzMsg(text)
		DEFAULT_CHAT_FRAME:AddMessage(tostring(text):gsub("|1","|cffffff80"):gsub("|2","|cffffffff"),128/255,192/255,255/255);
	end
end
--------------------------------------------------------------------------------------------------------
--                                            Model Frame                                             --
--------------------------------------------------------------------------------------------------------

local function ExEvent_Model_OnUpdate(self,elapsed)
	if (self.isRotating) then
		local endx, endy = GetCursorPosition();
		self.rotation = (endx - self.startx) / 34 + self:GetFacing();
		self:SetFacing(self.rotation);
		self.startx, self.starty = GetCursorPosition();
	elseif (self.isPanning) then
		local endx, endy = GetCursorPosition();
		local z, x, y = self:GetPosition(z,x,y);
		x = (endx - self.startx) / 45 + x;
		y = (endy - self.starty) / 45 + y;
		self:SetPosition(z,x,y);
		self.startx, self.starty = GetCursorPosition();
	end
end

local function ExEvent_Model_OnMouseWheel(self)
	local z, x, y = self:GetPosition();
	local scale = (IsControlKeyDown() and 2 or 0.7);
	z = (arg1 > 0 and z + scale or z - scale);
	self:SetPosition(z,x,y);
end

local function ExEvent_Model_OnMouseDown(self)
	self.startx, self.starty = GetCursorPosition();
	if (arg1 == "LeftButton") then
		self.isRotating = 1;
		if (IsControlKeyDown()) then
			funcs.SetBackgroundTexture(nil);
		end
	elseif (arg1 == "RightButton") then
		self.isPanning = 1;
		if (IsControlKeyDown()) then
			cfg.showBackground = (not cfg.showBackground);
			funcs.ShowBackground();
		end
	end
end

local function ExEvent_Model_OnMouseUp(self)
	if (arg1 == "LeftButton") then
		self.isRotating = nil;
	elseif (arg1 == "RightButton") then
		self.isPanning = nil;
	end
end

--------------------------------------------------------------------------------------------------------
--                                            Config Stuff                                            --
--------------------------------------------------------------------------------------------------------

-- Config Frame OnShow
local function ExEvent_Config_OnShow(self)
	for index, table in ipairs(EX_Checks) do
		ex.checks[index]:SetChecked(cfg[table.var]);
	end
end

-- CheckBoxes: OnClick
local function ExEvent_ConfigCheckBox_OnClick(self,button)
	local var = EX_Checks[self.id].var;
	cfg[var] = not cfg[var];
	if (var == "CombineAdditiveStats" or var == "RatingsInPercent") then
		funcs.BuildStatList();
	elseif (var == "ActAsUIFrame") then
		ex:SetMovable(not cfg.ActAsUIFrame);
		if (cfg.ActAsUIFrame) then
			ex:Hide();
			ShowUIPanel(ex);
		else
			HideUIPanel(ex);
			ex:Show();
		end
	end
end

--------------------------------------------------------------------------------------------------------
--                                             Item Slots                                             --
--------------------------------------------------------------------------------------------------------

-- OnEnter
local function ExEvent_ItemSlots_OnEnter(self)
	GameTooltip:SetOwner(self,"ANCHOR_RIGHT");
	if (funcs.CheckLastUnit() and CheckInteractDistance(u.token,1) and GameTooltip:SetInventoryItem(u.token,self.id)) then
	elseif (self.link) then
		GameTooltip:SetHyperlink(self.link);
	elseif (self.realLink) then
		GameTooltip:SetText(_G[self.slotName:upper()]);
		GameTooltip:AddLine("ItemID: "..self.realLink:match("item:(%d+)"),0,0.44,0.86);
		GameTooltip:AddLine("This item is unsafe, you can click to query\nthe server, but it may result in a disconnect.",1,1,1);
		GameTooltip:Show();
	else
		GameTooltip:SetText(_G[self.slotName:upper()]);
	end
end

-- OnLeave
local function ExEvent_ItemSlots_OnLeave(self)
	ResetCursor();
	GameTooltip:Hide();
	ex.statTooltip = nil;
end

-- OnDrag
local function ExEvent_ItemSlots_OnDrag(self)
	if (funcs.CheckLastUnit() and UnitIsUnit(u.token,"player")) then
		PickupInventoryItem(self.id);
	end
end

-- OnClick
local function ExEvent_ItemSlots_OnClick(self,button)
	if (self.link) then
		if (button == "RightButton") then
			local gemLink;
			AzMsg("---|2 Gem Overview for "..select(2,GetItemInfo(self.link)).." |r---");
			for i = 1, 3 do
				gemLink = select(2,GetItemGem(self.link,i));
				if (gemLink) then
					AzMsg(format("Gem |1%d|r = %s",i,gemLink));
				end
			end
		elseif (button == "LeftButton") then
			if (IsModifiedClick("DRESSUP")) then
				DressUpItemLink(self.link);
			elseif (IsModifiedClick("CHATLINK")) and (ChatFrameEditBox:IsVisible()) then
				ChatFrameEditBox:Insert(select(2,GetItemInfo(self.link)));
			else
				ExEvent_ItemSlots_OnDrag(self);
			end
		end
	elseif (self.realLink) then
		ExScannerTip:ClearLines();
		ExScannerTip:SetHyperlink(self.realLink);
		funcs.LoadPlayerFromCache(cache[funcs.GetEntryName()],3);
		ExEvent_ItemSlots_OnEnter(self);
	end
end

-- OnUpdate
local function ExEvent_ItemSlots_OnUpdate(self,elapsed)
	if (GameTooltip:IsOwned(self)) and (self.link) then
		-- Inspect Cursor
		if (IsModifiedClick("DRESSUP")) then
			ShowInspectCursor();
		else
			ResetCursor();
		end
		-- Hide the StatTip and Update the normal tip every frame to support Equip Compare...
		-- Az: this can make Wow lag, find alternative method
		if (not IsAltKeyDown()) then
			ex.statTooltip = nil;
			ExEvent_ItemSlots_OnEnter(self);
		-- StatTip Show
		elseif (IsAltKeyDown()) and (not ex.statTooltip) then
			ex.statTooltip = 1;
			GameTooltip:SetOwner(self,"ANCHOR_RIGHT");
			local itemStats1, itemStats2 = {};
			local itemName, _, itemRarity = GetItemInfo(self.link);
			GameTooltip:AddLine(itemName,GetItemQualityColor(itemRarity));
			ExScanner:ScanItemLink(self.link,itemStats1);
			if (ExCompare) then
				itemStats2 = {};
				ExScanner:ScanItemLink(ExCompare[self.slotName],itemStats2);
			end
			for statToken, statName in pairs(ExScanner.StatNames) do
				if (itemStats1[statToken]) or (itemStats2 and itemStats2[statToken]) then
					GameTooltip:AddDoubleLine(statName,funcs.GetStatValue(statToken,itemStats1,itemStats2),1,1,1);
				end
			end
			GameTooltip:Show();
		end
	end
end

-- UpdateSlot: Updates slot from "button.link"
function funcs.ItemSlots_UpdateItemSlot(button)
	if (button.link) then
		local _, _, itemRarity, _, _, _, _, _, _, itemTexture = GetItemInfo(button.link);
		button.texture:SetTexture(itemTexture or "Interface\\Icons\\INV_Misc_QuestionMark");
		local r,g,b = GetItemQualityColor(itemRarity and itemRarity > 0 and itemRarity or 0);
		button.border:SetVertexColor(r,g,b);
		button.border:Show();
	elseif (button.realLink) then
		button.texture:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark");
		button.border:Hide();
	else
		button.texture:SetTexture(button.bgTexture);
		button.border:Hide();
	end
end

--------------------------------------------------------------------------------------------------------
--                                            Unit Details                                            --
--------------------------------------------------------------------------------------------------------

-- Unit Detail String
function funcs.UnitDetailString()
	local info, color = {};
	-- Level
	color = GetDifficultyColor(u.level ~= -1 and u.level or 500);
	tinsert(info,LEVEL..(" |cff%.2x%.2x%.2x"):format(color.r*255,color.g*255,color.b*255)..(u.level ~= -1 and u.level or "??").."|r");
	-- Classification (non players only, so ok to use u.token)
	if (not u.raceFixed) then
		local classification = UnitClassification(u.token);
		if (ex.Classification[classification]) then
			tinsert(info,"("..ex.Classification[classification]..")");
		end
	end
	-- Race for Players / Family or Type for NPC's
	if (u.race) then
		tinsert(info,u.race ~= "Not specified" and u.race or "Unknown");
	end
	-- Players Only: Class (+ Realm)
	if (u.raceFixed) then
		if (u.class) then
			color = RAID_CLASS_COLORS[u.classFixed];
			tinsert(info,("|cff%.2x%.2x%.2x"):format(color.r*255,color.g*255,color.b*255)..u.class.."|r");
		end
		if (u.realm) then
			tinsert(info,"of "..u.realm);
		end
	end
	-- Return
	return table.concat(info," ");
end

-- Unit Guild String (Faction for NPC's)
function funcs.UnitGuildString()
	-- Players
	if (u.raceFixed) then
		if (u.guild and u.guildRank and u.guildIndex) then
			return u.guildRank.." ("..u.guildIndex..") of <"..u.guild..">";
		end
	-- NPC's only, so ok to use 'u.token' here
	else
		ExScannerTip:ClearLines();
		ExScannerTip:SetUnit(u.token);
		local line;
		for i = 2, ExScannerTip:NumLines() - 1 do
			line = _G["ExScannerTipTextLeft"..i]:GetText();
			if (line:find("^"..TOOLTIP_UNIT_LEVEL:gsub("%%s",".+"))) then
				line = _G["ExScannerTipTextLeft"..(i + 1)]:GetText();
				if (line ~= PVP_ENABLED) then
					return line;
				end
			end
		end
	end
	-- Else return empty
	return "";
end

-- Return name used for entires
function funcs.GetEntryName()
	return (u.realm and u.name.."-"..u.realm or u.name);
end

--------------------------------------------------------------------------------------------------------
--                                            Cache Stuff                                             --
--------------------------------------------------------------------------------------------------------

-- Format Time (sec)
local function FormatTime(time)
	local color = "|cffffff80";
	-- bugged?
	if (time < 0) then
		return "n/a";
	-- under a min
	elseif (time < 60) then
		return color..time.."|rs";
	-- less than 1 hour
	elseif (time < 60*60) then
		return format(color.."%d|rm"..color.."%.2d|rs",time/60,mod(time,60));
	-- less than 1 day
	elseif (time < 60*60*24) then
		time = (time/60);
		return format(color.."%d|rh"..color.."%.2d|rm",time/60,mod(time,60));
	-- above 1 day
	else
		time = (time/60/60);
		return format(color.."%d|rd"..color.."%.2d|rh",time/24,mod(time,24));
	end
end

-- CacheEntry: OnClick
local function ExEvent_CacheEntry_OnClick(self,button)
	if (button == "LeftButton") then
		if (IsModifiedClick("CHATLINK")) and (ChatFrameEditBox:IsVisible()) then
			ChatFrameEditBox:Insert(self.entryName);
		else
			PlaySound("igMainMenuOptionCheckBoxOn");
			funcs.LoadPlayerFromCache(cache[self.entryName],0);
		end
	elseif (button == "RightButton") and (IsShiftKeyDown()) then
		cache[self.entryName] = nil;
		funcs.BuildCacheList();
	end
end

-- CacheEntry: OnEnter
local function ExEvent_CacheEntry_OnEnter(self)
	local entry = cache[self.entryName];
	GameTooltip:SetOwner(self,"ANCHOR_RIGHT");
	-- Init Text & Colors
	local color = RAID_CLASS_COLORS[entry.classFixed];
	local classText = ("|cff%.2x%.2x%.2x%s|r"):format(color.r*255,color.g*255,color.b*255,entry.class);
	color = GetDifficultyColor(entry.level ~= -1 and entry.level or 500);
	local level = ("|cff%.2x%.2x%.2x%s|r"):format(color.r*255,color.g*255,color.b*255,entry.level ~= -1 and entry.level or "??");
	-- Add Lines & Show
	GameTooltip:AddLine(entry.pvpName..(entry.realm and " - "..entry.realm or ""),0.5,0.75,1.0);
	if (entry.guild) then
		GameTooltip:AddLine("<"..entry.guild..">",0.0,0.5,0.8);
	end
	GameTooltip:AddLine(level.." "..entry.race.." "..classText,1,1,1);
	GameTooltip:AddLine(entry.zone,1,1,1);
	GameTooltip:AddLine(" ");
	GameTooltip:AddDoubleLine("Cache Index:",FauxScrollFrame_GetOffset(ExaminerCacheScroll) + self.id);
	GameTooltip:AddDoubleLine("Last Inspected:",FormatTime(time()-entry.time));
	GameTooltip:AddLine("Shift + Right-Click to Delete",0.75,0.75,0.75);
	GameTooltip:Show();
end

-- Cache Player
local function CachePlayer(override)
	if (not override) and (not cfg.EnableCache) then
		return;
	end
	-- New Entry
	local entryName = funcs.GetEntryName();
	cache[entryName] = {};
	local entry = cache[entryName];
	for name, value in pairs(u) do
		if (name ~= "token") then
			entry[name] = value;
		end
	end
	-- Cache Items
	entry["Items"] = {};
	for _, button in ipairs(ex.slots) do
		entry["Items"][button.slotName] = button.link;
	end
	-- Cache Sets
	entry["Sets"] = {};
	local idx;
	for setName, setEntry in pairs(ExSets) do
		entry["Sets"][setName] = { count = setEntry.count, max = setEntry.max };
		idx = 1;
		while (setEntry["setBonus"..idx]) do
			entry["Sets"][setName]["setBonus"..idx] = setEntry["setBonus"..idx];
			idx = (idx + 1);
		end
	end
	-- Cache Complete
	return 1;
end

-- Load player from cache
function funcs.LoadPlayerFromCache(entry,loadLevel)
	-- loadLevel Information --
	-- 2 = Load no extra info from cache besides items/sets/pvp (Use when unit is in loading range but outside inspect range)
	-- 1 = Load just what we cannot get from being outside inspect range (Use when unit is outside loading and inspect range)
	-- 0 = Load everything (Use when you have no unit to get info from)
	if (loadLevel <= 2) then
		u.time = entry.time;
		u.zone = entry.zone;
		if (loadLevel > 0) and (u.level == -1) then
			u.level = entry.level;
		end
		if (loadLevel <= 1) then
			u.pvpName = entry.pvpName;
			u.guild, u.guildRank, u.guildIndex = entry.guild, entry.guildRank, entry.guildIndex;
			u.talents = entry.talents;
			if (loadLevel <= 0) then
				-- Clear last unit, as we don't have one for a cached player at level 0
				ClearInspectPlayer();
				u.token = nil;
				-- General Info
				u.name, u.realm = entry.name, entry.realm;
				u.level = entry.level;
				u.class, u.classFixed = entry.class, entry.classFixed;
				u.race, u.raceFixed = entry.race, entry.raceFixed;
				u.sex = entry.sex;
				-- Textures & Model
				ex.portrait:SetTexture("Interface\\CharacterFrame\\TemporaryPortrait-"..(u.sex == 3 and "Female" or "Male").."-"..u.raceFixed);
				ex.model:ClearModel();
				ex.model:SetUnit("");
				funcs.SetBackgroundTexture(u.raceFixed);
			end
		end
	end
	-- Title, Detail & Guild Text
	ex.title:SetText(u.pvpName);
	ex.details:SetText(funcs.UnitDetailString());
	ex.guild:SetText(funcs.UnitGuildString());
	-- Reset
	ExStats = {};
	ExSets = {};
	-- Item Slots
	local button;
	for index, slotName in ipairs(ExScanner.Slots) do
		button = ex.slots[index];
		button.link = entry["Items"][slotName];
		button.realLink = nil;
		-- Only scan the item if it's in the users local cache, to avoid DC's
		if (button.link) then
			if (GetItemInfo(button.link)) then
				ExScanner:ScanItemLink(button.link,ExStats);
			else
				if (cfg.ScanUnknownItems) then
					ExScannerTip:ClearLines();
					ExScannerTip:SetHyperlink(button.link);
				end
				button.realLink = button.link;
				button.link = nil;
			end
		end
		funcs.ItemSlots_UpdateItemSlot(button);
	end
	-- Sets + Set Bonuses
	local idx;
	for setName, setEntry in pairs(entry["Sets"]) do
		ExSets[setName] = { count = setEntry.count, max = setEntry.max };
		idx = 1;
		while (setEntry["setBonus"..idx]) do
			ExSets[setName]["setBonus"..idx] = setEntry["setBonus"..idx];
			ExScanner:ScanLineForPatterns(setEntry["setBonus"..idx],ExStats);
			idx = (idx + 1);
		end
	end
	-- Honor + Arena
	funcs.PVPClear();
	funcs.LoadHonorFromCache(entry["Honor"]);
	funcs.LoadArenaTeamsFromCache(entry);
	-- Update Stats
	funcs.BuildStatList();
	-- Finalize
	ex.iconCached:Show();
	ex.statsLoaded = 1;
	ex.unitType = 3; -- Force unitType to 3 to make things simple by having Examiner believe it's a same faction unit?
	ex.buttons[3]:Enable();
	ex.buttons[4]:Enable();
	ex.buttons[5]:Disable();
	-- Fix UI: Force page to Stats (but only if we are loading a person from the cache page)
	if (loadLevel == 0) then
		cfg.activePage = 3;
		ex.frames[2]:Hide();
		ex.frames[3]:Show();
		funcs.ShowItemSlotButtons();
	end
end

-- Cache List Sorting
local function CacheListSortFunc(a,b)
	if (cfg.cacheSort == "time") then
		return cache[a].time > cache[b].time;
	elseif (cache[a][cfg.cacheSort] == cache[b][cfg.cacheSort]) then
		return cache[a].name < cache[b].name;
	else
		return (cache[a][cfg.cacheSort] or "") < (cache[b][cfg.cacheSort] or "");
	end
end

-- Build the table used to display the cache (display table)
function funcs.BuildCacheList()
	-- Create Display Table
	for index in ipairs(ExCacheList) do
		ExCacheList[index] = nil;
	end
	local filter = cfg.cacheFilter:upper();
	for entryName, entryTable in pairs(cache) do
		if (cfg.cacheFilter == "") or (entryName:upper():find(filter)) or (entryTable.guild and entryTable.guild:upper():find(filter)) then
			tinsert(ExCacheList,entryName);
		end
	end
	sort(ExCacheList,CacheListSortFunc);
	-- Update
	ex.cacheHeader:SetText("Cached Players ("..#ExCacheList..")"..(cfg.cacheFilter ~= "" and " |cffffff00*" or ""));
	funcs.CacheList_Update();
end

-- ScrollBar: Cache list update
function funcs.CacheList_Update()
	FauxScrollFrame_Update(ExaminerCacheScroll,#ExCacheList,#ex.cache,30);
	local button, index, entryName, entry, color, coords, iconOffset;
	for i = 1, #ex.cache do
		index = (FauxScrollFrame_GetOffset(ExaminerCacheScroll) + i);
		button = ex.cache[i];
		if (ExCacheList[index]) then
			entryName = ExCacheList[index];
			entry = cache[entryName];
			color = RAID_CLASS_COLORS[entry.classFixed];

			button.entryName = entryName;
			button.name:SetText("|cffffffff"..(entry.level ~= -1 and entry.level or "??").."|r "..entryName);
			button.name:SetTextColor(color.r,color.g,color.b);

			coords = EX_RaceCoord[entry.raceFixed];
			iconOffset = (entry.sex == 3 and 0.5 or 0);
			button.race:SetTexCoord(coords.left,coords.right,coords.top+iconOffset,coords.bottom+iconOffset);

			button:SetWidth(#ExCacheList > #ex.cache and 200 or 214);
			button:Show();
		else
			button:Hide();
		end
	end
	-- Update Tooltip if we Scroll
	local mouseFocus = GetMouseFocus();
	if (mouseFocus) and (cache[mouseFocus.entryName]) and (GameTooltip:IsOwned(mouseFocus)) then
		ExEvent_CacheEntry_OnEnter(mouseFocus);
	end
end

--------------------------------------------------------------------------------------------------------
--                                            Stats Stuff                                             --
--------------------------------------------------------------------------------------------------------

-- Returns a modified and formatted stat from the given "statTable", which might be adjusted by certain options
-- If "compareTable" is set, it assumes compare mode and displays and colorizes the differences.
function funcs.GetStatValue(statToken,statTable,compareTable,level)
	local value = (statTable[statToken] or 0);
	local valuePct;
	-- Compare
	if (type(compareTable) == "table") then
		value = (value - funcs.GetStatValue(statToken,compareTable,true));
	end
	-- OPTION: Add additive stats which stack to each other
	if (cfg.CombineAdditiveStats) then
		if (statTable["SPELLDMG"]) then
			for _, schoolToken in ipairs(EX_MagicSchools) do
				if (statToken == schoolToken.."DMG") then
					value = (value + statTable["SPELLDMG"]);
					break;
				end
			end
		end
		if (statTable["AP"]) and (statToken == "RAP" or statToken == "APFERAL") then
			value = (value + statTable["AP"]);
		end
	end
	-- OPTION: Give Rating Values in Percent
	if (ExScanner:GetRatingInPercent(statToken,value,level or u.level)) then
		valuePct = tonumber(format("%.2f",ExScanner:GetRatingInPercent(statToken,value,level or u.level)));
	end
	-- Do not modify the value further if we are just getting the compare value (compareTable == true)
	if (type(compareTable) ~= "boolean") then
		-- If Compare, Add Colors
		if (type(compareTable) == "table") then
			local color = (value > 0 and "|cff80ff80+") or (value < 0 and "|cffff8080");
			if (value ~= 0) then
				value = color..value;
			end
			if (valuePct) and (valuePct ~= 0) then
				valuePct = color..valuePct;
			end
		end
		-- Add "%" to converted ratings (Exclude Defense and Expertise)
		if (ExScanner.StatRatingBaseTable[statToken]) and (statToken ~= "DEFENSE") and (statToken ~= "EXPERTISE") then
			valuePct = valuePct.."%";
		end
	end
	-- Return
	if (type(compareTable) == "boolean") then
		return value;
	elseif (cfg.RatingsInPercent) and (ExScanner.StatRatingBaseTable[statToken]) then
		return valuePct, value;
	else
		return value, valuePct;
	end
end

-- Show Resistances
function funcs.UpdateResistances()
	local statToken;
	for i = 1, 5 do
		statToken = (EX_MagicSchools[i].."RESIST");
		if (ExStats[statToken]) or (ExCompare and ExCompare[statToken]) then
			ex.resists[i].value:SetText(funcs.GetStatValue(statToken,ExStats,ExCompare));
		else
			ex.resists[i].value:SetText("");
		end
	end
end

-- Build Stat List
function funcs.BuildStatList()
	local lastHeader;
	local value, tip;
	-- Clear ExStatList
	for index in ipairs(ExStatList) do
		ExStatList[index] = nil;
	end
	-- Build display table
	for _, statCat in ipairs(ex.StatEntryOrder) do
		lastHeader = (#ExStatList + 1);
		for _, statToken in ipairs(statCat.stats) do
			if (ExStats[statToken]) or (ExCompare and ExCompare[statToken]) then
				value, tip = funcs.GetStatValue(statToken,ExStats,ExCompare);
				tinsert(ExStatList,{ name = ExScanner.StatNames[statToken], value = value, tip = tip });
			end
		end
		if (lastHeader <= #ExStatList) then
			tinsert(ExStatList,lastHeader,{ name = statCat.name });
		end
	end
	-- Add Sets + One Line of Padding
	lastHeader = (#ExStatList + 1);
	for setName, setEntry in pairs(ExSets) do
		tinsert(ExStatList,{ name = setName, value = setEntry.count.."/"..setEntry.max });
	end
	if (lastHeader <= #ExStatList) then
		tinsert(ExStatList,lastHeader,{});
		tinsert(ExStatList,lastHeader+1,{ name = "Sets" });
	end
	-- Update Resistances
	funcs.UpdateResistances();
	-- Update List
	tinsert(ExStatList,{});
	funcs.StatList_Update();
end

-- ScrollBar: Update Stat List
function funcs.StatList_Update()
	FauxScrollFrame_Update(ExaminerStatScroll,#ExStatList,#ex.entries,12);
	local index, entry;
	for i = 1, #ex.entries do
		index = (FauxScrollFrame_GetOffset(ExaminerStatScroll) + i);
		entry = ex.entries[i];
		if (ExStatList[index]) then
			if (ExStatList[index].value) then
				entry.left:SetTextColor(1,1,1);
				entry.left:SetText("  "..ExStatList[index].name);
				entry.right:SetText(ExStatList[index].value);
			elseif (ExStatList[index].name) then
				entry.left:SetTextColor(0.5,0.75,1.0);
				entry.left:SetText(ExStatList[index].name..":");
				entry.right:SetText("");
			else
				entry.left:SetText("");
				entry.right:SetText("");
			end

			if (ExStatList[index].tip) then
				entry.tip.tip = ExStatList[index].tip;
				entry.tip:SetWidth(entry.right:GetWidth());
				entry.tip:Show();
			else
				entry.tip:Hide();
			end

			entry:SetWidth(#ExStatList > #ex.entries and 200 or 214);
			entry:Show();
		else
			entry:Hide();
		end
	end
end

-- Entry Tip OnEnter
local function ExEvent_EntryTip_OnEnter(self)
	GameTooltip:SetOwner(self,"ANCHOR_RIGHT");
	GameTooltip:SetText(self.tip);
end

--------------------------------------------------------------------------------------------------------
--                                             PvP Stuff                                              --
--------------------------------------------------------------------------------------------------------

-- Update PvP Info
function funcs.PVPUpdate()
	if (HasInspectHonorData()) or (funcs.CheckLastUnit() and UnitIsUnit(u.token,"player")) then
		funcs.LoadHonorNormal();
		funcs.LoadArenaTeamsNormal();
	else
		RequestInspectHonorData();
	end
end

-- Load Honor Normal
function funcs.LoadHonorNormal()
	local unit = (u.token or "");
	local faction = UnitFactionGroup(unit);
	local todayHK, todayHonor, yesterdayHK, yesterdayHonor, lifetimeHK, lifetimeRank;
	-- Query
	if (UnitIsUnit(unit,"player")) then
		todayHK, todayHonor = GetPVPSessionStats();
		yesterdayHK, yesterdayHonor = GetPVPYesterdayStats();
		lifetimeHK, lifetimeRank = GetPVPLifetimeStats();
	else
		todayHK, todayHonor, yesterdayHK, yesterdayHonor, lifetimeHK, lifetimeRank = GetInspectHonorData();
	end
	-- Update
	funcs.UpdateHonor(todayHK, todayHonor, yesterdayHK, yesterdayHonor, lifetimeHK, lifetimeRank, faction);
	-- Show Honor Points for Player only
	if (UnitIsUnit(unit,"player")) then
		ex.pvpLabels[9]:SetText(GetHonorCurrency());
		ex.pvpLabels[9]:SetTextColor(0,1,0);
	end
	-- Cache
	if (cfg.EnableCache) and (cfg.CachePvP) then
		local cacheEntry = cache[funcs.GetEntryName()];
		if (cacheEntry) and (time() - cacheEntry.time <= 8) then
			cacheEntry["Honor"] = { todayHK = todayHK, todayHonor = todayHonor, yesterdayHK = yesterdayHK, yesterdayHonor = yesterdayHonor, lifetimeHK = lifetimeHK, lifetimeRank = lifetimeRank };
		end
	end
end

-- Load Honor From Cache (Az: faction is always given as the player's which is a bit wrong)
function funcs.LoadHonorFromCache(honorEntry)
	if (honorEntry) then
		funcs.UpdateHonor(honorEntry.todayHK, honorEntry.todayHonor, honorEntry.yesterdayHK, honorEntry.yesterdayHonor, honorEntry.lifetimeHK, honorEntry.lifetimeRank, UnitFactionGroup("player"));
	end
end

-- Honor Update
function funcs.UpdateHonor(todayHK, todayHonor, yesterdayHK, yesterdayHonor, lifetimeHK, lifetimeRank, faction)
	-- Show Rank
	if (lifetimeRank ~= 0) then
		ex.pvpRank:SetTexture("Interface\\PvPRankBadges\\PvPRank"..format("%.2d",lifetimeRank-4));
		ex.pvpRank:SetTexCoord(0,1,0,1);
		ex.pvpHeader:SetText(GetPVPRankInfo(lifetimeRank,u.token).." (Rank "..(lifetimeRank-4)..")");
	-- Az: This needs a little rework
	else
		if (faction) then
			ex.pvpRank:SetTexture("Interface\\TargetingFrame\\UI-PVP-"..faction);
			ex.pvpRank:SetTexCoord(0,0.59375,0,0.59375);
		else
			ex.pvpRank:SetTexture(nil);
		end
		ex.pvpHeader:SetText("No PvP Rank");
	end
	-- Show Kills/Honor
	ex.pvpLabels[4]:SetText(todayHK);
	ex.pvpLabels[5]:SetText(yesterdayHK);
	ex.pvpLabels[6]:SetText(lifetimeHK);
	ex.pvpLabels[7]:SetText(todayHonor);
	ex.pvpLabels[8]:SetText(yesterdayHonor);
	ex.pvpLabels[9]:SetText("---");
	ex.pvpLabels[9]:SetTextColor(1,1,0);
end

-- Load Arena Teams Normal
function funcs.LoadArenaTeamsNormal()
	local teamName, teamSize, teamRating, teamPlayed, teamWins, playerPlayed, playerRating, emblem, border;
	local seasonTeamPlayed, seasonTeamWins, seasonPlayerPlayed, teamRank;
	local backR, backG, backB, emblemR, emblemG, emblemB, borderR, borderG, borderB;
	local arenaFrame;
	local cacheEntry = cache[funcs.GetEntryName()];
	-- Loop
	for i = 1, MAX_ARENA_TEAMS do
		if (funcs.CheckLastUnit() and UnitIsUnit(u.token,"player")) then
			teamName, teamSize, teamRating, teamPlayed, teamWins, seasonTeamPlayed, seasonTeamWins, playerPlayed, seasonPlayerPlayed, teamRank, playerRating, backR, backG, backB, emblem, emblemR, emblemG, emblemB, border, borderR, borderG, borderB = GetArenaTeam(i);
			teamPlayed, teamWins, playerPlayed = seasonTeamPlayed, seasonTeamWins, seasonPlayerPlayed;
		else
			teamName, teamSize, teamRating, teamPlayed, teamWins, playerPlayed, playerRating, backR, backG, backB, emblem, emblemR, emblemG, emblemB, border, borderR, borderG, borderB = GetInspectArenaTeamData(i);
		end
		-- Update
		if (teamName) then
			funcs.ArenaTeamUpdate(teamName, teamSize, teamRating, teamPlayed, teamWins, playerPlayed, playerRating, backR, backG, backB, emblem, emblemR, emblemG, emblemB, border, borderR, borderG, borderB);
			-- Cache
			if (cfg.EnableCache) and (cfg.CachePvP) and (cacheEntry) and (time() - cacheEntry.time <= 8) then
				cacheEntry["Arena"..i] = { teamName = teamName, teamSize = teamSize, teamRating = teamRating, teamPlayed = teamPlayed, teamWins = teamWins, playerPlayed = playerPlayed, playerRating = playerRating, backR = backR, backG = backG, backB = backB, emblem = emblem, emblemR = emblemR, emblemG = emblemG, emblemB = emblemB, border = border, borderR = borderR, borderG = borderG, borderB = borderB };
			end
		end
	end
end

-- Load Arena Team From Cache
function funcs.LoadArenaTeamsFromCache(cacheEntry)
	local a;
	for i = 1, MAX_ARENA_TEAMS do
		if (cacheEntry["Arena"..i]) then
			a = cacheEntry["Arena"..i];
			funcs.ArenaTeamUpdate(a.teamName, a.teamSize, a.teamRating, a.teamPlayed, a.teamWins, a.playerPlayed, a.playerRating, a.backR, a.backG, a.backB, a.emblem, a.emblemR, a.emblemG, a.emblemB, a.border, a.borderR, a.borderG, a.borderB);
		end
	end
end

-- Arena Team Update
function funcs.ArenaTeamUpdate(teamName, teamSize, teamRating, teamPlayed, teamWins, playerPlayed, playerRating, backR, backG, backB, emblem, emblemR, emblemG, emblemB, border, borderR, borderG, borderB)
	local f = ex.arena[floor(teamSize / 2 + 0.9)];
	-- General
	f.name:SetText(teamName);
	f.rating:SetText(teamRating);
	-- Games/Played
	f.details[1].right:SetText("|cffffff80"..teamPlayed);
	f.details[2].right:SetText(funcs.PVPFormatNumbers(playerPlayed,teamPlayed));
	-- Wins/Loss
	f.details[3].right:SetText(funcs.PVPFormatNumbers(teamWins,teamPlayed));
	f.details[4].right:SetText(funcs.PVPFormatNumbers(teamPlayed-teamWins,teamPlayed));
	-- Estimated Points & Personal Rating
	f.details[5].right:SetFormattedText("|cffffff80%.1f",funcs.CalculateArenaPoints(teamRating,teamSize));
	f.details[6].right:SetText("|cffffff80"..tostring(playerRating));
	-- Banner
	f.banner:SetTexture("Interface\\PVPFrame\\PVP-Banner-"..teamSize);
	f.banner:SetVertexColor(backR,backG,backB);
	f.emblem:SetVertexColor(emblemR,emblemG,emblemB);
	f.border:SetVertexColor(borderR,borderG,borderB);
	f.border:SetTexture(border ~= -1 and "Interface\\PVPFrame\\PVP-Banner-"..teamSize.."-Border-"..border or nil);
	f.emblem:SetTexture(emblem ~= -1 and "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-"..emblem or nil);
	-- Show Frame
	f:Show();
end

-- Clear the PvP info
function funcs.PVPClear()
	-- Header
	ex.pvpRank:SetTexture(nil);
	ex.pvpHeader:SetText("No PvP Details");
	-- Clear Honor
	for i = 4, 9 do
		ex.pvpLabels[i]:SetText("---");
	end
	ex.pvpLabels[9]:SetTextColor(1,1,0);
	-- Hide Arena Teams
	for i = 1, #ex.arena do
		ex.arena[i]:Hide();
	end
end

-- Format Numbers
function funcs.PVPFormatNumbers(value,max)
	local color = (value == 0 and "|cffff8080" or "|cffffff80");
	if (max == 0) then
 		return color.."0|r ("..color.."0%|r)";
	else
		return color..value.."|r  ("..color..format("%.1f",value / max * 100).."%|r)";
	end
end

-- Calculate Arena Points (Updated Formula for 2.2)
function funcs.CalculateArenaPoints(teamRating,teamSize)
	local points;
	if (teamRating <= 1500) then
		points = (0.22 * teamRating + 14);
	else
		points = (1511.26 / (1 + 1639.28 * 2.71828 ^ (-0.00412 * teamRating)));
	end
	return (teamSize == 5 and points) or (teamSize == 3 and points * 0.88) or (teamSize == 2 and points * 0.76);
end

--------------------------------------------------------------------------------------------------------
--                                           Inspect Stuff                                            --
--------------------------------------------------------------------------------------------------------

-- Normal Open
function Examiner_Open(unit)
	if (not u.name) then
		Examiner_InspectUnit("player");
	elseif (ex:IsVisible()) then
		HideUIPanel(ex);
	elseif (cfg.ActAsUIFrame) then
		ShowUIPanel(ex);
	else
		ex:Show();
	end
end

-- Inspect Unit
function Examiner_InspectUnit(unit)
	ClearInspectPlayer();
	-- Check Unit
	if (not unit or not UnitExists(unit)) then
		unit = "player";
	end
	-- Convert "mouseover" unit to party/raid unit
	if (unit == "mouseover") then
		if (GetNumRaidMembers() > 0) then
			for i = 1, GetNumRaidMembers() do
				if (UnitIsUnit("mouseover","raid"..i)) then
					unit = "raid"..i;
					break;
				end
			end
		elseif (GetNumPartyMembers() > 0) then
			for i = 1, GetNumPartyMembers() do
				if (UnitIsUnit("mouseover","party"..i)) then
					unit = "party"..i;
					break;
				end
			end
		end
	end
	-- Mouseover Event
	if (unit == "mouseover") then
		ex:RegisterEvent("UPDATE_MOUSEOVER_UNIT");
	else
		ex:UnregisterEvent("UPDATE_MOUSEOVER_UNIT");
	end
	-- Get Unit Info
	u.token = unit;
	u.name, u.realm = UnitName(unit);
	if (u.realm == "") then
		u.realm = nil;
	end
	u.pvpName = UnitPVPName(unit);
	u.level = (UnitLevel(unit) or 0);
	u.sex = (UnitSex(unit) or 1);
	u.class, u.classFixed = UnitClass(unit);
	u.race, u.raceFixed = UnitRace(unit);
	if (not u.race) then
		u.race = UnitCreatureFamily(unit) or UnitCreatureType(unit);
	end
	u.guild, u.guildRank, u.guildIndex = GetGuildInfo(unit);
	u.time = time();
	u.zone = GetMinimapZoneText();
	if (GetRealZoneText() ~= u.zone) then
		u.zone = GetRealZoneText()..", "..u.zone;
	end
	u.talents = nil;
	-- Textures & Model
	ex.model:ClearModel();
	ex.model:SetUnit(unit);
	SetPortraitTexture(ex.portrait,unit);
	funcs.SetBackgroundTexture(u.raceFixed);
	-- Title, Detail & Guild Text
	ex.title:SetText(u.pvpName or u.name);
	ex.details:SetText(funcs.UnitDetailString());
	ex.guild:SetText(funcs.UnitGuildString());
	-- Reset
	ExStats = {};
	ExSets = {};
	ex:SetScript("OnUpdate",nil);
	ex.statsLoaded = nil;
	funcs.PVPClear();
	-- Unit Type (1 = npc, 2 = opposing faction, 3 = same faction)
	ex.unitType = (not UnitIsPlayer(unit) and 1) or (UnitCanCooperate("player",unit) and 3) or 2;
	-- NPC's
	if (ex.unitType == 1) then
		ex.frames[4]:Hide();
		ex.buttons[4]:Disable();
		ex.buttons[5]:Disable();
	-- Players we can Inspect
	elseif (CanInspect(unit)) then
		ex:RegisterEvent("INSPECT_TALENT_READY");
		NotifyInspect(unit);
		ex.unit = u.token;
		if (ExaminerTalents:IsShown()) then
			funcs.TalentsTabs_Update();
			TalentFrame_Update(ex);
		end
		funcs.PVPUpdate();
		ex.iconCached:Hide();
		ex.statsLoaded = 1;
		ExScanner:ScanUnitItems(unit,ExStats,ExSets);
		for _, button in ipairs(ex.slots) do
			button.link = (GetInventoryItemLink(unit,button.id) or ""):match(ExScanner.ItemLinkPattern);
			funcs.ItemSlots_UpdateItemSlot(button);
		end
		funcs.BuildStatList();
		if (CachePlayer()) and (cfg.activePage == 2) then
			funcs.BuildCacheList();
		end
		ex.buttons[3]:Enable();
		ex.buttons[4]:Enable();
		ex.buttons[5]:Enable();
	-- Players who are out of inspect range, or pvp enabled enemy faction
	else
		ex:SetScript("OnUpdate",ExEvent_OnUpdate);
		local entryName = funcs.GetEntryName();
		if (cache[entryName]) then
			funcs.LoadPlayerFromCache(cache[entryName],UnitIsVisible(unit) and 2 or 1);
		end
	end
	-- If Talents are Showing
	if (ExaminerTalents:IsShown()) and (not CanInspect(unit)) then
		funcs.TalentsVisible(false);
	end
	-- Fix UI Depending on Stats Being Loaded
	if (ex.statsLoaded) then
		if (cfg.activePage) then
			ex.frames[cfg.activePage]:Show();
		end
	else
		funcs.UIToggleExclusive(nil);
		ex.buttons[3]:Disable();
		ex.buttons[4]:Disable();
		ex.buttons[5]:Disable();
	end
	-- Item Buttons
	funcs.ShowItemSlotButtons();
	-- Show Examiner
	if (not ex:IsShown()) then
		if (cfg.ActAsUIFrame) then
			ShowUIPanel(ex);
		else
			ex:Show();
		end
	end
end

-- Hover over the CachedIcon
local function ExEvent_CacheIcon_OnEnter(self)
	GameTooltip:SetOwner(self,"ANCHOR_RIGHT");
	GameTooltip:AddLine("Cached Entry");
	GameTooltip:AddDoubleLine("Zone:",u.zone,1,1,1);
	GameTooltip:AddDoubleLine("Last Inspected:",FormatTime(time() - u.time),1,1,1);
	GameTooltip:AddDoubleLine("Date:",date("%A, %B %d, %Y",u.time),1,1,1);
	GameTooltip:AddDoubleLine("Time:",date("%H:%M:%S",u.time),1,1,1);
	GameTooltip:Show();
end

-- Hover over the InfoIcon
local function ExEvent_InfoIcon_OnEnter(self)
	-- Get Data that Requires a Loop Through items
	local iLvlTotal, iLvl = 0;
	local gemCount, gemRed, gemYellow, gemBlue = 0, 0, 0, 0;
	local link, gemLink, line, slotName;
	for index, button in ipairs(ex.slots) do
		link = button.link;
		slotName = button.slotName; -- Az: Can use: ExScanner.Slots[index]
		-- Count Gem Colors
		if (link) then
			for i = 1, 3 do
				gemLink = select(2,GetItemGem(link,i));
				if (gemLink) and (GetItemInfo(gemLink)) then
					gemCount = (gemCount + 1);
					ExScannerTip:ClearLines();
					ExScannerTip:SetHyperlink(gemLink);
					line = _G["ExScannerTipTextLeft"..ExScannerTip:NumLines()]:GetText():lower();
					if (line:find("^\".+\"$")) then
						if (line:find(RED_GEM:lower())) then
							gemRed = (gemRed + 1);
						end
						if (line:find(YELLOW_GEM:lower())) then
							gemYellow = (gemYellow + 1);
						end
						if (line:find(BLUE_GEM:lower())) then
							gemBlue = (gemBlue + 1);
						end
					end
				end
			end
		end
		-- Calculate Item Level Numbers
		if (slotName ~= "TabardSlot") and (slotName ~= "ShirtSlot") and (link) then
			iLvl = select(4,GetItemInfo(link));
			if (iLvl) then
				if (slotName == "MainHandSlot") and (not ex.slots[index + 1].link) then
					iLvl = (iLvl * 2);
				end
				iLvlTotal = (iLvlTotal + iLvl);
			end
		end
	end
	-- Generate Tooltip
	GameTooltip:SetOwner(self,"ANCHOR_RIGHT");
	GameTooltip:AddLine("Other Details");
	GameTooltip:AddDoubleLine("Unit Token",tostring(u.token),1,1,1);
	if (u.talents) then
		GameTooltip:AddDoubleLine("Talent Specialization",u.talents,1,1,1);
	end
	GameTooltip:AddDoubleLine("Combined Item Levels",iLvlTotal,1,1,1);
	GameTooltip:AddDoubleLine("Average Item Level",format("%.2f",iLvlTotal / (#ExScanner.Slots - 2)),1,1,1); -- Ignore Tabard + Shirt, hence minus 2
	GameTooltip:AddDoubleLine("Number of Gems",gemCount,1,1,1);
	GameTooltip:AddDoubleLine("Gem Color Matches",format("|cffff6060%d|r/|cffffff00%d|r/|cff6060ff%d",gemRed,gemYellow,gemBlue),1,1,1);
	GameTooltip:Show();
end

--------------------------------------------------------------------------------------------------------
--                                             UI Buttons                                             --
--------------------------------------------------------------------------------------------------------

-- Main UI Buttons: OnEnter
local function ExEvent_Buttons_OnEnter(self)
	GameTooltip:SetOwner(self,"ANCHOR_NONE");
	GameTooltip:SetPoint("BOTTOMLEFT",self,"TOPLEFT");
	GameTooltip:AddLine(self.header);
	GameTooltip:AddLine(self.tip,1,1,1);
	GameTooltip:Show();
end

-- Main UI Buttons: OnClick
local function ExEvent_Buttons_OnClick(self,button)
	local id = self.id;
	CloseDropDownMenus();
	-- Button = Left --
	if (button == "LeftButton") then
		-- Hide Talents if they are shown
		if (ExaminerTalents:IsShown()) then
			funcs.TalentsVisible(false);
			funcs.SetBackgroundTexture(u.raceFixed);
			if (id == 5) then
				id = nil;
				funcs.UIToggleExclusive(nil);
				if (cfg.activePage) and (cfg.activePage ~= 3 or ex.statsLoaded) then
					ex.frames[cfg.activePage]:Show();
				end
			end
		end
		-- Do stuff depending on button pressed
		if (id == 5) then
			funcs.TalentsVisible(true);
			funcs.TalentsTabs_Update();
			TalentFrame_Update(ex);
		elseif (id == 2) and (IsShiftKeyDown()) then
			AzDialog:New("Enter new cache filter...",cfg.cacheFilter,function(text) cfg.cacheFilter = text; funcs.BuildCacheList(); end);
		elseif (id == 3) and (IsShiftKeyDown()) and (ex.statsLoaded) then
			funcs.CacheStatsForCompare();
		elseif (id) then
			funcs.UIToggleExclusive(id);
		end
		-- Update Cache List if Visible
		if (ex.frames[2]:IsShown()) then
			funcs.BuildCacheList();
		end
		-- Set Item Buttons Visible State
		if (ex.model:IsShown()) then
			funcs.ShowItemSlotButtons();
		end
	-- Button = Right --
	elseif (button == "RightButton") then
		if (id == 2 or id == 3) then
			ToggleDropDownMenu(1,nil,ExaminerDropDown,self,0,0);
		end
	end
end

-- DropDown: OnClick
local function DropDown_SelectItem()
	-- Sort
	if (type(this.value) == "string") then
		cfg.cacheSort = this.value;
	-- Cache Filter
	elseif (this.value == 1) then
		AzDialog:New("Enter new cache filter...",cfg.cacheFilter,function(text) cfg.cacheFilter = text; funcs.BuildCacheList(); end);
	-- Clear Cache
	elseif (this.value == 2) then
		local entryCount = 0;
		table.foreach(cache,function() entryCount = (entryCount +1); end);
		AzDialog:New("Are you sure you want to clear "..entryCount.." entries?",nil,function() Examiner_Cache = {}; cache = Examiner_Cache; funcs.BuildCacheList(); end);
	-- Cache Player
	elseif (this.value == 11) then
		CachePlayer(1);
	-- Send To...
	elseif (this.value == 12) then
		local name, realm = UnitName("target");
		name = realm and format("%s-%s",name,realm:gsub(" ","")) or name or "";
		AzDialog:New("Enter name to send inspect data to...",name,funcs.SendPlayer);
	-- Mark for Compare & Clear Compare
	elseif (this.value == 13 or this.value == 14) then
		funcs.CacheStatsForCompare(this.value == 14);
	end

	-- Rebuild Cache List
	if (cfg.activePage == 2) and (type(this.value) == "string" or this.value == 2) then
		funcs.BuildCacheList();
	end
end

-- DropDown: Init
local info = { func = DropDown_SelectItem };
local EX_SortMethods = { "name", "realm", "level", "guild", "race", "class", "time" };
function funcs.DropDown_Initialize()
	if (not this) then
		return;
	end
	-- Cache
	if (this.id == 2) then
		-- title: sort
		info.isTitle = 1;
		info.text = "Sort Method";
		UIDropDownMenu_AddButton(info);
		info.isTitle, info.disabled = nil, nil;
		-- method
		for _, method in ipairs(EX_SortMethods) do
			info.text = "Sort by "..method;
			info.value = method;
			info.checked = (cfg.cacheSort == method);
			UIDropDownMenu_AddButton(info);
		end
		info.checked = nil;
		info.isTitle, info.disabled = nil, nil;
		-- title: filter
		info.isTitle = 1;
		info.text = "";
		UIDropDownMenu_AddButton(info);
		info.text = "Filter";
		UIDropDownMenu_AddButton(info);
		info.isTitle, info.disabled = nil, nil;
		-- set filter
		info.text = "Set Filter...";
		info.value = 1;
		UIDropDownMenu_AddButton(info);
		-- title: clear
		info.isTitle = 1;
		info.text = "";
		UIDropDownMenu_AddButton(info);
		info.text = "Cache";
		UIDropDownMenu_AddButton(info);
		info.isTitle, info.disabled = nil, nil;
		-- clear
		info.text = "Clear All Entries";
		info.value = 2;
		UIDropDownMenu_AddButton(info);
	-- Stats
	elseif (this.id == 3) then
		-- title: stats
		info.isTitle = 1;
		info.text = "Stats";
		UIDropDownMenu_AddButton(info);
		info.isTitle, info.disabled = nil, nil;
		-- items
		info.text = "Cache Player";
		info.value = 11;
		info.checked = (cache[funcs.GetEntryName()] ~= nil);
		UIDropDownMenu_AddButton(info);
		info.checked = nil;
		-- send to
		info.text = "Send To...";
		info.value = 12;
		UIDropDownMenu_AddButton(info);
		-- title: compare
		info.isTitle = 1;
		info.text = "";
		UIDropDownMenu_AddButton(info);
		info.text = "Compare";
		UIDropDownMenu_AddButton(info);
		info.isTitle, info.disabled = nil, nil;
		-- mark for compare
		info.text = "Mark for Compare";
		info.value = 13;
		info.checked = (ExCompare and ExCompare.entry == funcs.GetEntryName());
		UIDropDownMenu_AddButton(info);
		info.checked = nil;
		-- clear compare
		if (ExCompare) then
			info.text = "Clear Compare";
			info.value = 14;
			UIDropDownMenu_AddButton(info);
		end
	end
end

--------------------------------------------------------------------------------------------------------
--                                            Talent Stuff                                            --
--------------------------------------------------------------------------------------------------------

-- Select Tab
local function ExEvent_TalentsTab_OnClick(self,button)
	PanelTemplates_SetTab(ex,self.id);
	ex.currentSelectedTab = self.id;
	ex.pointsSpent = select(3,GetTalentTabInfo(self.id,true));
	TalentFrame_Update(ex);
end

-- Update Tabs
function funcs.TalentsTabs_Update()
	local numTabs = GetNumTalentTabs(true);
	local tab, tabName, pointsSpent;
	for i = 1, MAX_TALENT_TABS do
		tab = _G["ExaminerTab"..i];
		if (i <= numTabs) then
			tabName, _, pointsSpent = GetTalentTabInfo(i,true);
			if (i == ex.selectedTab) then
				ex.pointsSpent = pointsSpent;
			end
			tab:SetText(tabName.." |cff00ff00"..pointsSpent);
			tab:Show();
			PanelTemplates_TabResize(-18,tab);
		else
			tab:Hide();
		end
	end
end

--------------------------------------------------------------------------------------------------------
--                                 Send Player (AddOn Whisper Message)                                --
--------------------------------------------------------------------------------------------------------

-- Returns a clickable chat link for a player
function funcs.PlayerChatLink(name)
	return "|Hplayer:"..name.."|h["..name.."]|h";
end

-- Sends Table Recursive
function funcs.SendStatRecursive(target,root,table)
	for name, value in pairs(table) do
		if (type(value) == "table") then
			funcs.SendStatRecursive(target,root..name.."\\",value);
		elseif (name ~= "token") then
			SendAddonMessage(root..name,value,"WHISPER",target);
		end
	end
end

-- Sends the current inspected player to another person through SendAddonMessage()
function funcs.SendPlayer(target)
	-- Check if we can actually send data
	if (not ex.statsLoaded) then
		AzMsg("|2Examiner|r No inspect data to send!");
		return;
	end
	-- Check if we have someone to send to
	if (not target or target == "") then
		AzMsg("|2Examiner|r Need player name to send to.");
		return;
	end
	-- Send Data: Clear Old Record & Send Root Values
	local entryName = funcs.GetEntryName();
	SendAddonMessage("EXAMINER#"..entryName.."#CMD","CLEAR","WHISPER",target);
	funcs.SendStatRecursive(target,"EXAMINER#"..entryName.."#",u);
	-- Items
	for _, button in ipairs(ex.slots) do
		SendAddonMessage("EXAMINER#"..entryName.."#Items\\"..button.slotName,button.link,"WHISPER",target);
	end
	-- Sets
	funcs.SendStatRecursive(target,"EXAMINER#"..entryName.."#Sets\\",ExSets);
	-- Honor + Arena
		-- Az: bla bla bla, not yet!
	-- Done
	SendAddonMessage("EXAMINER#"..entryName.."#CMD","DONE","WHISPER",target);
	AzMsg("|2Examiner|r Inspected player |1"..funcs.PlayerChatLink(entryName).."|r sent to |1"..funcs.PlayerChatLink(target).."|r.");
end

--------------------------------------------------------------------------------------------------------
--                                          UI Helper Stuff                                           --
--------------------------------------------------------------------------------------------------------

-- Cache current stats for compare or clear previous marked one
function funcs.CacheStatsForCompare(unmark)
	if (unmark) then
		ExCompare = nil;
	else
		ExCompare = CopyTable(ExStats);
		ExCompare.entry = funcs.GetEntryName();
		for _, button in ipairs(ex.slots) do
			ExCompare[button.slotName] = button.link;
		end
	end
	funcs.BuildStatList();
end

-- Toggle given frame, hide all others (give nil to hide all)
function funcs.UIToggleExclusive(id)
	for index, frame in ipairs(ex.frames) do
		if (index == id) and (not frame:IsShown()) then
			frame:Show();
		else
			frame:Hide();
		end
		if (index == id) then
			cfg.activePage = (frame:IsShown() and id or nil);
		end
	end
end

-- Show/Hide Item Slot Buttons
function funcs.ShowItemSlotButtons(visible)
	if (not visible) then
		visible = (cfg.activePage ~= 4 and ex.statsLoaded);
	end
	for _, button in ipairs(ex.slots) do
		if (visible) then
			button:Show();
		else
			button:Hide();
		end
	end
end

-- Talents visible or not
function funcs.TalentsVisible(show)
	-- Show Talents
	if (show) then
		ex.model:Hide();
		ExaminerTalents:Show();
		ex.details:Hide();
		ex.guild:Hide();

		funcs.UIToggleExclusive(nil);
		funcs.ShowBackground(true);

		ExaminerBackgroundTopLeft:SetHeight(270);
		ExaminerBackgroundTopRight:SetHeight(270);
		ExaminerBackgroundBottomLeft:SetHeight(141);
		ExaminerBackgroundBottomRight:SetHeight(141);
		ExaminerBackgroundTopLeft:SetWidth(267);
		ExaminerBackgroundTopRight:SetWidth(74);
		ExaminerBackgroundBottomLeft:SetWidth(267);
		ExaminerBackgroundBottomRight:SetWidth(74);
	-- Hide Talents
	else
		ex.model:Show();
		ExaminerTalents:Hide();
		ex.details:Show();
		ex.guild:Show();
		for i = 1, MAX_TALENT_TABS do
			_G["ExaminerTab"..i]:Hide();
		end
		funcs.ShowBackground();
		funcs.SetBackgroundTexture(u.raceFixed);
	end
end

-- Toggle the Background
function funcs.ShowBackground(show)
	if (show == nil and cfg.showBackground or show) then
		ExaminerBackgroundTopLeft:Show();
		ExaminerBackgroundTopRight:Show();
		ExaminerBackgroundBottomLeft:Show();
		ExaminerBackgroundBottomRight:Show();
	else
		ExaminerBackgroundTopLeft:Hide();
		ExaminerBackgroundTopRight:Hide();
		ExaminerBackgroundBottomLeft:Hide();
		ExaminerBackgroundBottomRight:Hide();
	end
end

-- Background Texture
function funcs.SetBackgroundTexture(race)
	-- If watching talents, ignore this call
	if (ExaminerTalents:IsShown()) then
		return;
	end
	-- Find Texture
	local texture;
	if (not race) then
		texture = "Interface\\TalentFrame\\"..EX_Backgrounds[random(1,#EX_Backgrounds)].."-";
	else
		if (race == "Gnome") then
			race = "Dwarf";
		elseif (race == "Troll") then
			race = "Orc";
		end
		texture = "Interface\\DressUpFrame\\DressUpBackground-"..race;
	end
	local small = texture:find("DressUpFrame");
	-- Set Texture Width
	ExaminerBackgroundTopLeft:SetWidth(small and 256 or 267);
	ExaminerBackgroundTopRight:SetWidth(small and 64 or 74);
	ExaminerBackgroundBottomLeft:SetWidth(small and 256 or 267);
	ExaminerBackgroundBottomRight:SetWidth(small and 64 or 74);
	-- Set Texture Height
	ExaminerBackgroundTopLeft:SetHeight(270);
	ExaminerBackgroundTopRight:SetHeight(270);
	ExaminerBackgroundBottomLeft:SetHeight(141);
	ExaminerBackgroundBottomRight:SetHeight(141);
	-- Set Texture
	ExaminerBackgroundTopLeft:SetTexture(texture..(small and "1" or "TopLeft"));
	ExaminerBackgroundTopRight:SetTexture(texture..(small and "2" or "TopRight"));
	ExaminerBackgroundBottomLeft:SetTexture(texture..(small and "3" or "BottomLeft"));
	ExaminerBackgroundBottomRight:SetTexture(texture..(small and "4" or "BottomRight"));
end

-- Check Last Unit
function funcs.CheckLastUnit()
	if (u.token) and (UnitExists(u.token)) and (UnitName(u.token) == u.name) then
		return 1;
	else
		u.token = nil;
		ex:SetScript("OnUpdate",nil);
		return;
	end
end

--------------------------------------------------------------------------------------------------------
--                                            Init Examiner                                           --
--------------------------------------------------------------------------------------------------------

local function HideGTT()
	GameTooltip:Hide();
end

do
	-- Work Variables
	local t, d;
	local backdrop = { bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 4, right = 4, top = 4, bottom = 4 } };
	local function SetHeaderFont(fontstring)
		fontstring:SetFont("Fonts\\FRIZQT__.TTF",16,"THICKOUTLINE");
		fontstring:SetTextColor(0.5,0.75,1);
	end

	-- Hook Blizz Inspect
	InspectUnit = Examiner_InspectUnit;
	UnitPopupButtons["INSPECT"].dist = 0;
	--UnitPopupButtons["INSPECT"].text = "Examine";
	-- UIPanelWindow & UISpecialFrames Entry
	UIPanelWindows[modName] = { area = "left", pushable = 1, whileDead = 1 };
	tinsert(UISpecialFrames,modName);

	-------------------------
	-- Examiner Frame Init --
	-------------------------
	ex = CreateFrame("Frame","Examiner",UIParent);
	ex:SetWidth(384);
	ex:SetHeight(440);
	ex:SetPoint("CENTER");
	ex:SetToplevel(1);
	ex:EnableMouse(1);
	ex:Hide();
	ex:SetHitRectInsets(12,35,10,2);
	ex:SetScript("OnShow",ExEvent_OnShow);
	ex:SetScript("OnHide",ExEvent_OnHide);
	ex:SetScript("OnEvent",ExEvent_OnEvent);
	ex:SetScript("OnMouseDown",function() if (ex:IsMovable()) then ex:StartMoving(); end end);
	ex:SetScript("OnMouseUp",function() if (ex:IsMovable()) then ex:StopMovingOrSizing(); end end);
	-- Events
	ex:RegisterEvent("VARIABLES_LOADED");
	ex:RegisterEvent("CHAT_MSG_ADDON");
	-- Az: Is SHOW_COMPARE_TOOLTIP even used?
--	ex:RegisterEvent("SHOW_COMPARE_TOOLTIP");
	-- Close Button
	CreateFrame("Button",nil,ex,"UIPanelCloseButton"):SetPoint("TOPRIGHT",-30,-8);
	-- Portrait
	ex.portrait = ex:CreateTexture(nil,"BACKGROUND");
	ex.portrait:SetWidth(60);
	ex.portrait:SetHeight(60);
	ex.portrait:SetPoint("TOPLEFT",7,-6);
	-- FontStrings
	ex.title = ex:CreateFontString(nil,"ARTWORK","GameFontNormal");
	ex.title:SetPoint("TOP",5,-17);
	ex.details = ex:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall");
	ex.details:SetPoint("TOP",5,-44);
	ex.guild = ex:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall");
	ex.guild:SetPoint("TOP",ex.details,"BOTTOM",0,-2);
	-- Dialog Textures
	t = ex:CreateTexture(nil,"ARTWORK");
	t:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-TopLeft");
	t:SetPoint("TOPLEFT");
	t:SetWidth(256);
	t:SetHeight(256);
	t = ex:CreateTexture(nil,"ARTWORK");
	t:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-TopRight");
	t:SetPoint("TOPRIGHT");
	t:SetWidth(128);
	t:SetHeight(256);
	t = ex:CreateTexture(nil,"ARTWORK");
	t:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-BottomLeft");
	t:SetPoint("TOPLEFT",0,-256);
	t:SetWidth(256);
	t:SetHeight(256);
	t = ex:CreateTexture(nil,"ARTWORK");
	t:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-BottomRight");
	t:SetPoint("TOPRIGHT",0,-256);
	t:SetWidth(128);
	t:SetHeight(256);
	-- Background Textures
	t = ex:CreateTexture("ExaminerBackgroundTopLeft","OVERLAY");
	t:SetPoint("TOPLEFT",22,-76);
	t = ex:CreateTexture("ExaminerBackgroundTopRight","OVERLAY");
	t:SetPoint("LEFT",ExaminerBackgroundTopLeft,"RIGHT");
	t = ex:CreateTexture("ExaminerBackgroundBottomLeft","OVERLAY");
	t:SetPoint("TOP",ExaminerBackgroundTopLeft,"BOTTOM");
	t = ex:CreateTexture("ExaminerBackgroundBottomRight","OVERLAY");
	t:SetPoint("LEFT",ExaminerBackgroundBottomLeft,"RIGHT");
	-- Buttons
	ex.buttons = {};
	local EX_Buttons = {
		{ label = "Config", header = "Configurations", tip = "Examiner Settings" },
		{ label = "Cache", header = "Cached Players", tip = "Right Click for extended menu" },
		{ label = "Stats", header = "Gear Statistics", tip = "Right Click for extended menu" },
		{ label = "PvP", header = "Player vs. Player", tip = "Honor & Arena Details" },
		{ label = "Talents", header = "Show Talents", tip = "The Inspected Player's Talent Specialization" },
	};
	for index, table in ipairs(EX_Buttons) do
		t = CreateFrame("Button",nil,ex,"UIPanelButtonGrayTemplate");
		t:SetWidth(60);
		t:SetHeight(21);
		t:SetFrameLevel(t:GetFrameLevel() + 1);
		t:RegisterForClicks("LeftButtonUp","RightButtonUp");

		t:SetText(table.label);
		t.header = table.header;
		t.tip = table.tip;
		t.id = index;

		t:SetScript("OnClick",ExEvent_Buttons_OnClick);
		t:SetScript("OnEnter",ExEvent_Buttons_OnEnter);
		t:SetScript("OnLeave",HideGTT);

		if (index == 1) then
			t:SetPoint("BOTTOMLEFT",25,13);
		else
			t:SetPoint("LEFT",ex.buttons[index - 1],"RIGHT",3,0);
		end

		tinsert(ex.buttons,t);
	end
	-- DropDown
	CreateFrame("Frame","ExaminerDropDown",nil,"UIDropDownMenuTemplate");
	UIDropDownMenu_Initialize(ExaminerDropDown,funcs.DropDown_Initialize,"MENU");
	-----------
	-- Model --
	-----------
	ex.model = CreateFrame("PlayerModel",nil,ex);
	ex.model:SetWidth(320);
	ex.model:SetHeight(354);
	ex.model:SetPoint("BOTTOM",-11,10);
	ex.model:EnableMouse(1);
	ex.model:EnableMouseWheel(1);
	ex.model:SetScript("OnUpdate",ExEvent_Model_OnUpdate);
	ex.model:SetScript("OnMouseDown",ExEvent_Model_OnMouseDown);
	ex.model:SetScript("OnMouseUp",ExEvent_Model_OnMouseUp);
	ex.model:SetScript("OnMouseWheel",ExEvent_Model_OnMouseWheel);
	-- Main Frames
	ex.frames = {};
	for i = 1, 4 do
		t = CreateFrame("Frame",nil,ex.model);
		t:SetWidth(i ~= 4 and 235 or 320);
		t:SetHeight(i ~= 4 and 288 or 330);
		t:SetPoint("TOP");
		t:SetBackdrop(backdrop);
		t:SetBackdropColor(0.1,0.22,0.35,1);
		t:SetBackdropBorderColor(0.7,0.7,0.8,1);
		t:Hide();

		tinsert(ex.frames,t);
	end
	ex.frames[1]:SetScript("OnShow",ExEvent_Config_OnShow);
	-- Item Slots
	ex.slots = {};
	for index, slot in ipairs(ExScanner.Slots) do
		t = CreateFrame("Button","ExaminerItemButton"..slot,ex.model); -- Some other mods bug if you create this nameless :/
		t:SetWidth(37);
		t:SetHeight(37);
		t:RegisterForClicks("LeftButtonUp","RightButtonUp");
		t:RegisterForDrag("LeftButton");

		t:SetScript("OnUpdate",ExEvent_ItemSlots_OnUpdate);
		t:SetScript("OnClick",ExEvent_ItemSlots_OnClick);
		t:SetScript("OnEnter",ExEvent_ItemSlots_OnEnter);
		t:SetScript("OnLeave",ExEvent_ItemSlots_OnLeave);
		t:SetScript("OnDragStart",ExEvent_ItemSlots_OnDrag);
		t:SetScript("OnReceiveDrag",ExEvent_ItemSlots_OnDrag);

		t.id, t.bgTexture = GetInventorySlotInfo(slot);
		t.slotName = slot;

		t.texture = t:CreateTexture(nil,"BACKGROUND");
		t.texture:SetAllPoints();

		t.border = t:CreateTexture(nil,"OVERLAY");
		t.border:SetTexture("Interface\\Addons\\Examiner\\Textures\\Border");
		t.border:SetWidth(41);
		t.border:SetHeight(41);
		t.border:SetPoint("CENTER");

		t:SetPushedTexture("Interface\\Buttons\\UI-Quickslot-Depress");
		t:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square");

		if (index == 1) then
			t:SetPoint("TOPLEFT",4,-3);
		elseif (index == 9) then
			t:SetPoint("TOPRIGHT",-4,-3);
		elseif (index == 17) then
			t:SetPoint("BOTTOM",-40,27);
		elseif (index <= 16) then
			t:SetPoint("TOP",ex.slots[index - 1],"BOTTOM",0,-4);
		else
			t:SetPoint("LEFT",ex.slots[index - 1],"RIGHT",5,0);
		end

		tinsert(ex.slots,t);
	end
	-------------
	-- Talents --
	-------------
	ex.inspect = true;
	TalentFrame_Load(ex);
	-- Talent Tabs
	for i = 1, MAX_TALENT_TABS do
		t = CreateFrame("Button","ExaminerTab"..i,ex,"TabButtonTemplate");
		t:Hide();
		t.id = i;
		t:SetScript("OnClick",ExEvent_TalentsTab_OnClick);
		if (i == 1) then
			t:SetPoint("TOPLEFT",66,-39);
		else
			t:SetPoint("LEFT","ExaminerTab"..(i - 1),"RIGHT");
		end
	end
	ex.selectedTab = 1;
	ex.currentSelectedTab = 1;
	PanelTemplates_SetNumTabs(ex,3);
	PanelTemplates_UpdateTabs(ex);
	-- Talent Parents
	t = CreateFrame("Frame","ExaminerTalents",ex);
	t:SetWidth(320);
	t:SetHeight(354);
	t:SetPoint("BOTTOM",-11,10);
	t:Hide();

	t = CreateFrame("ScrollFrame","ExaminerTalentsScrollChild",ExaminerTalents,"UIPanelScrollFrameTemplate");
	t:SetPoint("TOPLEFT",ex.model,0,-2);
	t:SetPoint("BOTTOMRIGHT",ex.model,-25,25);

	CreateFrame("Frame","ExaminerScrollChildFrame");
	ExaminerScrollChildFrame:SetWidth(320);
	ExaminerScrollChildFrame:SetHeight(1);
	t:SetScrollChild(ExaminerScrollChildFrame);
	-- Create Buttons and Textures
	for i = 1, 40 do
		t = CreateFrame("Button","ExaminerTalent"..i,ExaminerScrollChildFrame,"TalentButtonTemplate");
		t.id = i;
		t:SetScript("OnLoad",nil);
		t:SetScript("OnEvent",nil);
		t:SetScript("OnClick",nil);
		t:SetScript("OnEnter",function(self) GameTooltip:SetOwner(self,"ANCHOR_RIGHT"); GameTooltip:SetTalent(ex.selectedTab,self.id,1); end);
	end
	CreateFrame("Frame","ExaminerArrowFrame",ExaminerScrollChildFrame):SetAllPoints();
	for i = 1, 30 do
		ExaminerScrollChildFrame:CreateTexture("ExaminerBranch"..i,"BACKGROUND","TalentBranchTemplate");
		ExaminerArrowFrame:CreateTexture("ExaminerArrow"..i,"OVERLAY","TalentArrowTemplate");
	end
	------------------
	-- Config Frame --
	------------------
	t = ex.frames[1]:CreateFontString(nil,"ARTWORK");
	SetHeaderFont(t);
	t:SetText("Configurations");
	t:SetPoint("TOP",0,-14);

	t = ex.frames[1]:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall");
	t:SetText("Examiner |cffffff80"..GetAddOnMetadata(modName,"Version"));
	t:SetPoint("BOTTOM",0,14);
	-- Checks
	ex.checks = {};
	for index, table in ipairs(EX_Checks) do
		t = CreateFrame("CheckButton",nil,ex.frames[1],"OptionsCheckButtonTemplate");
		t:SetWidth(27);
		t:SetHeight(27);
		t:SetScript("OnClick",ExEvent_ConfigCheckBox_OnClick);

		t.id = index;
		t.tooltipText = EX_Checks[index].tip;

		t.text = t:GetRegions();
		t.text:SetText(EX_Checks[index].label);
		t:SetHitRectInsets(0,t.text:GetWidth() * -1,0,0);

		if (index == 1) then
			t:SetPoint("TOPLEFT",20,-40);
		else
			t:SetPoint("TOP",ex.checks[index - 1],"BOTTOM");
		end

		tinsert(ex.checks,t);
	end
	----------------
	-- Stat Frame --
	----------------
	-- Info Icon
	ex.iconInfo = CreateFrame("Frame",nil,ex.frames[3]);
	ex.iconInfo:SetPoint("TOPLEFT",13,-16);
	ex.iconInfo:SetWidth(16);
	ex.iconInfo:SetHeight(16);
	ex.iconInfo:EnableMouse(1);

	ex.iconInfo:SetScript("OnEnter",ExEvent_InfoIcon_OnEnter);
	ex.iconInfo:SetScript("OnLeave",HideGTT);

	t = ex.iconInfo:CreateFontString(nil,"ARTWORK");
	SetHeaderFont(t);
	t:SetPoint("CENTER");
	t:SetTextColor(0.75,0.75,0.75);
	t:SetText("I");
	-- Cache Icon
	ex.iconCached = CreateFrame("Frame",nil,ex.frames[3]);
	ex.iconCached:SetPoint("TOPRIGHT",-13,-16);
	ex.iconCached:SetWidth(16);
	ex.iconCached:SetHeight(16);
	ex.iconCached:EnableMouse(1);

	ex.iconCached:SetScript("OnEnter",ExEvent_CacheIcon_OnEnter);
	ex.iconCached:SetScript("OnLeave",HideGTT);

	t = ex.iconCached:CreateFontString(nil,"ARTWORK");
	SetHeaderFont(t);
	t:SetPoint("CENTER");
	t:SetTextColor(0.75,0.75,0.75);
	t:SetText("C");
	-- Resistance Boxes
	ex.resists = {};
	for i = 1, 5 do
		t = CreateFrame("Frame",nil,ex.frames[3]);
		t:SetWidth(32);
		t:SetHeight(29);

		t.texture = t:CreateTexture(nil,"BACKGROUND");
		t.texture:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-ResistanceIcons");
		t.texture:SetTexCoord(0,1,(i - 1) * 0.11328125,i * 0.11328125);
		t.texture:SetAllPoints();

		t.value = t:CreateFontString(nil,"ARTWORK","TextStatusBarText");
		t.value:SetFont("Fonts\\FRIZQT__.TTF",12,"OUTLINE");
		t.value:SetPoint("BOTTOM",1,3);
		t.value:SetTextColor(1,1,0);

		if (i == 1) then
	 		t:SetPoint("TOPLEFT",36,-9);
		else
	 		t:SetPoint("LEFT",ex.resists[i - 1],"RIGHT");
		end

		tinsert(ex.resists,t);
	end
	-- Stat Entries
	ex.entries = {};
	for i = 1, 20 do
		t = CreateFrame("Frame",nil,ex.frames[3]);
		t:SetWidth(200);
		t:SetHeight(12);
		t.id = i;

		if (i == 1) then
			t:SetPoint("TOPLEFT",8,-40);
		else
			t:SetPoint("TOP",ex.entries[i - 1],"BOTTOM");
		end

		t.left = t:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall");
		t.left:SetPoint("LEFT");

		t.right = t:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall");
		t.right:SetPoint("RIGHT");
		t.right:SetTextColor(1,1,0);

		t.tip = CreateFrame("Frame",nil,t);
		t.tip:SetPoint("TOPRIGHT");
		t.tip:SetPoint("BOTTOMRIGHT");
		t.tip:SetScript("OnEnter",function(self) GameTooltip:SetOwner(self,"ANCHOR_RIGHT"); GameTooltip:SetText(self.tip); end);
		t.tip:SetScript("OnLeave",HideGTT);
		t.tip:EnableMouse(1);

		tinsert(ex.entries,t);
	end
	-- Scroll
	t = CreateFrame("ScrollFrame","ExaminerStatScroll",ex.frames[3],"FauxScrollFrameTemplate");
	t:SetPoint("TOPLEFT",ex.entries[1]);
	t:SetPoint("BOTTOMRIGHT",ex.entries[#ex.entries],-3,-1);
	t:SetScript("OnVerticalScroll",function() FauxScrollFrame_OnVerticalScroll(12,funcs.StatList_Update) end);
	-----------------
	-- Cache Frame --
	-----------------
	ex.cacheHeader = ex.frames[2]:CreateFontString(nil,"ARTWORK");
	SetHeaderFont(ex.cacheHeader);
	ex.cacheHeader:SetPoint("TOP",0,-14);
	-- Cache Entries
	ex.cache = {};
	for i = 1, 10 do
		t = CreateFrame("Button",nil,ex.frames[2]);
		t:SetWidth(200);
		t:SetHeight(24);
		t:RegisterForClicks("LeftButtonDown","RightButtonDown");
		t:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight");
		t.id = i;

		if (i == 1) then
			t:SetPoint("TOPLEFT",8,-40);
		else
			t:SetPoint("TOP",ex.cache[i - 1],"BOTTOM");
		end

		t:SetScript("OnClick",ExEvent_CacheEntry_OnClick);
		t:SetScript("OnEnter",ExEvent_CacheEntry_OnEnter);
		t:SetScript("OnLeave",HideGTT);

		t.race = t:CreateTexture(nil,"ARTWORK");
		t.race:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races");
		t.race:SetPoint("LEFT",3,0);
		t.race:SetWidth(22);
		t.race:SetHeight(22);

		t.name = t:CreateFontString(nil,"ARTWORK","GameFontHighlight");
		t.name:SetPoint("LEFT",t.race,"RIGHT",3,0);
		t.name:SetPoint("RIGHT",10);
		t.name:SetJustifyH("LEFT");

		tinsert(ex.cache,t);
	end
	-- Cache Scroll
	t = CreateFrame("ScrollFrame","ExaminerCacheScroll",ex.frames[2],"FauxScrollFrameTemplate");
	t:SetPoint("TOPLEFT",ex.cache[1]);
	t:SetPoint("BOTTOMRIGHT",ex.cache[#ex.cache],-3,-1);
	t:SetScript("OnVerticalScroll",function() FauxScrollFrame_OnVerticalScroll(30,funcs.CacheList_Update) end);
	---------------
	-- PVP Frame --
	---------------
	ex.pvpHeader = ex.frames[4]:CreateFontString(nil,"ARTWORK");
	SetHeaderFont(ex.pvpHeader);
	ex.pvpHeader:SetPoint("TOP",10,-14);

	ex.pvpRank = ex.frames[4]:CreateTexture(nil,"ARTWORK");
	ex.pvpRank:SetPoint("RIGHT",ex.pvpHeader,"LEFT",-5,0);
	ex.pvpRank:SetWidth(18);
	ex.pvpRank:SetHeight(18);
	-- Honor Labels
	ex.pvpLabels = {};
	for i = 1, 9 do
		t = ex.frames[4]:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall");
		t:SetWidth(70);

		if (i <= 3) then
			t:SetText(i == 1 and "Today" or i == 2 and "Yesterday" or "Lifetime");
			t:SetTextColor(0.5,0.75,1);
		else
			t:SetTextColor(1,1,0);
		end

		if (mod(i - 1,3) == 0) then
			t:SetPoint("TOP",-28,-36 - (i - 1) / 3 * 12);
		else
			t:SetPoint("LEFT",ex.pvpLabels[i - 1],"RIGHT");
		end

		tinsert(ex.pvpLabels,t);
	end
	-- Honor Label Side Headers
	t = ex.frames[4]:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall");
	t:SetPoint("RIGHT",ex.pvpLabels[4],"LEFT");
	t:SetWidth(70);
	t:SetJustifyH("LEFT");
	t:SetText("Honor Kills");
	t:SetTextColor(0.5,0.75,1);

	t = ex.frames[4]:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall");
	t:SetPoint("RIGHT",ex.pvpLabels[7],"LEFT");
	t:SetWidth(70);
	t:SetJustifyH("LEFT");
	t:SetText("Honor Points");
	t:SetTextColor(0.5,0.75,1);
	-- Detail Frame for Arena Frames
	local function MakeDetailFrame(parent)
		local f = CreateFrame("Frame",nil,parent);
		f:SetWidth(118);
		f:SetHeight(12);

		f.left = f:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall");
		f.left:SetPoint("LEFT");

		f.right = f:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall");
		f.right:SetPoint("RIGHT");
		f.right:SetTextColor(0.5,0.75,1);

		return f;
	end
	-- Arena
	local labels = { "Games", "Played", "Wins", "Losses", "Calculated Points", "PR" };
	ex.arena = {};
	for i = 1, 3 do
		t = CreateFrame("Frame",nil,ex.frames[4]);
		t:SetWidth(304);
		t:SetHeight(82);
		t:SetBackdrop(backdrop);
		t:SetBackdropColor(0.1,0.22,0.35,1);
		t:SetBackdropBorderColor(0.7,0.7,0.8,1);

		t.banner = t:CreateTexture(nil,"BORDER");
		t.banner:SetPoint("TOPLEFT",6,-4);
		t.banner:SetWidth(45);
		t.banner:SetHeight(90);
		t.border = t:CreateTexture(nil,"ARTWORK");
		t.border:SetPoint("CENTER",t.banner);
		t.border:SetWidth(45);
		t.border:SetHeight(90);
		t.emblem = t:CreateTexture(nil,"OVERLAY");
		t.emblem:SetPoint("CENTER",t.border,-5,17);
		t.emblem:SetWidth(24);
		t.emblem:SetHeight(24);

		t.name = t:CreateFontString(nil,"ARTWORK","GameFontHighlight");
		t.name:SetPoint("TOPLEFT",50,-8)
		t.name:SetTextColor(0.5,0.75,1);

		t.rating = t:CreateFontString(nil,"ARTWORK","GameFontHighlight");
		t.rating:SetPoint("TOPRIGHT",-8,-8)
		t.rating:SetTextColor(0.5,0.75,1);

		t.size = t:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall");
		t.size:SetPoint("BOTTOMRIGHT",-8,8)
		t.size:SetText(floor(i + i / 2 + 0.5).."v"..floor(i + i / 2 + 0.5));

		t.details = {};
		for index, label in ipairs(labels) do
			d = MakeDetailFrame(t);
			d.left:SetText(label);
			d.id = index;

			if (mod(index,2) == 1) then
				d:SetPoint("TOPLEFT",50,-29 - (index - 1) / 2 * 12 - (index == 5 and 6 or 0));
			else
				d:SetPoint("LEFT",t.details[index - 1],"RIGHT",8,0);
			end

			tinsert(t.details,d);
		end
		t.details[#t.details - 1]:SetWidth(130);
		t.details[#t.details]:SetWidth(50);

		if (i == 1) then
			t:SetPoint("TOPLEFT",8,-75);
		else
			t:SetPoint("TOP",ex.arena[i - 1],"BOTTOM");
		end

		tinsert(ex.arena,t);
	end
end