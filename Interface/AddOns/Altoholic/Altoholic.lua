-- *** TO DO's ***
-- General: information sharing with other players (later .. much later..)
-- General: gather hunter pet info + warlock known books (on hold till wotlk, see how pet talents will be implemented)
-- General: find a way to sort data in all panes that might benefit from i(characters' lists /search results ...)
-- General: investigate a dailies tracker
-- Emails: a summary window : Chars "Personal emails" "Duration" "AH emails" "Total mails" "Total Value"
-- Search: Add two new filters for min & max item level
-- New tab: WishList
-- New tab: Auction window ( Name Auctions Duration Total Value )  (from Quokka)
-- Try Auctioneer & Reagent Cost, see what can be done (info in wowace thread)
-- find a way to filter guilds in the tooltip info.
-- make icons & font sizes configurable.
-- in rep tooltip, see if we could display items that could be turned in for rep.
-- more pvp info in a dedicated tab (team names, ratings, etc..)
-- ore/mote also shows bar/primal count 
-- Tooltip possessions: order by name or by count
-- search usable (pour les recettes unknown only)
-- Detect when a profession is abandonned.
-- data export
-- Icon selection in the options (use Quokka's submissions)
-- Loots: add pvp reputation items from honor hold (same stats but <> from thrallmar)
-- Reputations: finish suggestions for reputations (ongoing)
-- mail expiry warning: make it better (popup/chat/in alto, configurable)
-- stack search results when searching bags.
-- add support for patterns so that searching "cloak .+ agility" finds "enchant cloak - greater agility"

-- show %xp next to rested
-- delete a guild bank info
-- delete a profession
-- find a way to allow spliting bags/bank in both views

-- atlas loot update !!

-- *** Open bugs ***

-- .Localization
local L = AceLibrary("AceLocale-2.2"):new("Altoholic")
local BI = LibStub("LibBabble-Inventory-3.0"):GetLookupTable()

local V = Altoholic.vars
V.version = "v2.4.016"

local WHITE		= "|cFFFFFFFF"
local RED		= "|cFFFF0000"
local GREEN		= "|cFF00FF00"
local YELLOW	= "|cFFFFFF00"
local ORANGE	= "|cFFFF7F00"
local TEAL		= "|cFF00FF9A"
local GOLD		= "|cFFFFD700"

-- These two tables are necessary to find equivalences between INVTYPEs returned by GetItemInfo and the actual equipment slots.
-- For instance, the "ranged" slot can contain bows/guns/wans/relics/thrown weapons.
Altoholic.InvSlots = {
	["INVTYPE_HEAD"] = 1,		-- 1 means first entry in the SearchSlots table (just below this one)
	["INVTYPE_SHOULDER"] = 2,
	["INVTYPE_CHEST"] = 3,
	["INVTYPE_ROBE"] = 3,
	["INVTYPE_WRIST"] = 4,
	["INVTYPE_HAND"] = 5,
	["INVTYPE_WAIST"] = 6,
	["INVTYPE_LEGS"] = 7,
	["INVTYPE_FEET"] = 8,
	
	["INVTYPE_NECK"] = 9,
	["INVTYPE_CLOAK"] = 10,
	["INVTYPE_FINGER"] = 11,
	["INVTYPE_TRINKET"] = 12,
	["INVTYPE_WEAPON"] = 13,
	["INVTYPE_2HWEAPON"] = 14,
	["INVTYPE_WEAPONMAINHAND"] = 15,
	["INVTYPE_WEAPONOFFHAND"] = 16,
	["INVTYPE_HOLDABLE"] = 16,
	["INVTYPE_SHIELD"] = 17,
	["INVTYPE_RANGED"] = 18,
	["INVTYPE_THROWN"] = 18,
	["INVTYPE_RANGEDRIGHT"] = 18,
	["INVTYPE_RELIC"] = 18
}

Altoholic.EquipmentSlots = {
	[1] = BI["Head"],			-- "INVTYPE_HEAD" 
	[2] = BI["Shoulder"],	-- "INVTYPE_SHOULDER"
	[3] = BI["Chest"],		-- "INVTYPE_CHEST",  "INVTYPE_ROBE"
	[4] = BI["Wrist"],		-- "INVTYPE_WRIST"
	[5] = BI["Hands"],		-- "INVTYPE_HAND"
	[6] = BI["Waist"],		-- "INVTYPE_WAIST"
	[7] = BI["Legs"],			-- "INVTYPE_LEGS"
	[8] = BI["Feet"],			-- "INVTYPE_FEET"
	
	[9] = BI["Neck"],			-- "INVTYPE_NECK"
	[10] = BI["Back"],		-- "INVTYPE_CLOAK"
	[11] = BI["Ring"],		-- "INVTYPE_FINGER"
	[12] = BI["Trinket"],	-- "INVTYPE_TRINKET"
	[13] = BI["One-Hand"],	-- "INVTYPE_WEAPON"
	[14] = BI["Two-Hand"],	-- "INVTYPE_2HWEAPON"
	[15] = BI["Main Hand"],	-- "INVTYPE_WEAPONMAINHAND"
	[16] = BI["Off Hand"],	-- "INVTYPE_WEAPONOFFHAND", "INVTYPE_HOLDABLE"
	[17] = BI["Shield"],		-- "INVTYPE_SHIELD"
	[18] = L["Ranged"]		-- "INVTYPE_RANGED",  "INVTYPE_THROWN", "INVTYPE_RANGEDRIGHT", "INVTYPE_RELIC"
}

-- ** texture coordinates found in a scrub.lua somewhere on the web
-- "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes";
Altoholic.ClassInfo = {
	[1] = { color = "|cFF69CCF0", texcoord = {0.25, 0.49609375, 0, 0.25} },
	[2] = { color = "|cFFC79C6E", texcoord = {0, 0.25, 0, 0.25} },
	[3] = { color = "|cFFABD473", texcoord = {0, 0.25, 0.25, 0.5} },
	[4] = { color = "|cFFFFF569", texcoord = {0.49609375, 0.7421875, 0, 0.25} },
	[5] = { color = "|cFF9482CA", texcoord = {0.7421875, 0.98828125, 0.25, 0.5} },
	[6] = { color = "|cFFFF7D0A", texcoord = {0.7421875, 0.98828125, 0, 0.25} },
	[7] = { color = "|cFF2459FF", texcoord = {0.25, 0.49609375, 0.25, 0.5} },
	[8] = { color = "|cFFF58CBA", texcoord = {0, 0.25, 0.5, 0.75} },
	[9] = { color = WHITE, texcoord = {0.49609375, 0.7421875, 0.25, 0.5} }

	-- color ok, texture coord missing, should be ok if icon is next to paladin
	-- 			X	0		0.25		0.49...		0.74...		0.98...
	--	Y = 0			War		Mage		Rogue		Druid
	--	Y = 0.25			Hunt		Sham		Priest		Warlock
	--	Y = 0.5			Pala			DK?
	--	Y = 0.75
	--	[10] = { color = "|cFFC41F3B", texcoord = {0.25, 0.49609375, 0.5, 0.75} },
}

Altoholic.Classes = {
	[L["Mage"]]		= 1,
	[L["Warrior"]]	= 2,
	[L["Hunter"]]	= 3,
	[L["Rogue"]]	= 4,
	[L["Warlock"]]	= 5,
	[L["Druid"]]	= 6,
	[L["Shaman"]]	= 7,
	[L["Paladin"]]	= 8,
	[L["Priest"]]	= 9,
--	[L["Death Knight"]]	= 10,
	
	-- frFR female class names
	["Guerrière"] = 2,			-- Warrior
	["Chasseresse"] = 3,			-- Hunter
	["Voleuse"] = 4,				-- Rogue
	["Druidesse"] = 6,			-- Druid
	["Chamane"] = 7,				-- Shaman
	["Prêtresse"] = 9,			-- Priest
	
	-- deDE female class names
	["Magierin"] = 1,				-- Mage
	["Kriegerin"] = 2,			-- Warrior
	["J\195\164gerin"] = 3,		-- Hunter
	["Schurkin"] = 4,				-- Rogue
	["Hexenmeisterin"] = 5,		-- Warlock 
	["Druidin"] = 6,				-- Druid
	["Schamanin"] = 7,			-- Shaman
	["Priesterin"] = 9,			-- Priest
	
	-- ruRU female class names
	["Охотница"]      = 3,        -- Hunter
	["Разбойница"]    = 4,        -- Rogue
	["Чернокнижница"] = 5,        -- Warlock
	["Шаманка"]       = 7,        -- Shaman
	["Жрица"]         = 9,        -- Priest

	-- ruRU as some russians still have characters on english-speaking realms
	-- they will still need bilingual version of Altoholic,
	-- that supports both english and russian character types
	["Mage"] = 1,
	["Warrior"] = 2,
	["Hunter"] = 3,
	["Rogue"] = 4,
	["Warlock"] = 5,
	["Druid"] = 6,
	["Shaman"] = 7,
	["Paladin"] = 8,
	["Priest"] = 9,  

}

local INFO_REALM_LINE = 1
local INFO_CHARACTER_LINE = 2
local INFO_TOTAL_LINE = 3

function Altoholic:OnInitialize()
end

function Altoholic:OnEnable()
	self:RegisterEvent("PLAYER_ALIVE")
	self:RegisterEvent("PLAYER_LEVEL_UP")
	self:RegisterEvent("PLAYER_MONEY")
	self:RegisterEvent("PLAYER_XP_UPDATE")
	self:RegisterEvent("PLAYER_LOGOUT")
	self:RegisterEvent("PLAYER_UPDATE_RESTING")
	self:RegisterEvent("PLAYER_GUILD_UPDATE")		-- for gkick, gquit, etc..
	self:RegisterEvent("ZONE_CHANGED")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	self:RegisterEvent("ZONE_CHANGED_INDOORS")
	self:RegisterEvent("TIME_PLAYED_MSG")
	
	self:RegisterEvent("BANKFRAME_OPENED")
	self:RegisterEvent("BANKFRAME_CLOSED")
	self:RegisterEvent("GUILDBANKFRAME_OPENED")
	self:RegisterEvent("GUILDBANKFRAME_CLOSED")
	self:RegisterEvent("AUCTION_HOUSE_SHOW")
	self:RegisterEvent("AUCTION_HOUSE_CLOSED")
		
	self:RegisterEvent("MAIL_SHOW")
	self:RegisterEvent("MAIL_CLOSED")
	self:RegisterEvent("AceEvent_FullyInitialized")
	
	_G["AltoholicFrameName"]:SetText("Altoholic |cFFFFFFFF"..V.version)
	V.player = UnitName("player")
	V.realm = GetRealmName()
	V.faction = UnitFactionGroup("player")
	
	V.CurrentFaction = V.faction
	V.CurrentRealm = V.realm
	V.CurrentAlt = V.player
	
	-- Characters tab DDM
	UIDropDownMenu_SetSelectedValue(AltoholicTabCharacters_SelectRealm, V.CurrentFaction .."|".. V.CurrentRealm)
	UIDropDownMenu_SetText(V.CurrentRealm, AltoholicTabCharacters_SelectRealm)
	
	UIDropDownMenu_SetSelectedValue(AltoholicTabCharacters_SelectChar, V.player);
	UIDropDownMenu_SetText(V.player, AltoholicTabCharacters_SelectChar)
	
	UIDropDownMenu_SetSelectedValue(AltoholicTabCharacters_View, 1);
	UIDropDownMenu_SetText(L["Containers"], AltoholicTabCharacters_View)

	UIDropDownMenu_Initialize(AltoholicTabCharacters_SelectRealm, function(self) 
		AltoholicTabCharacters:SelectRealmDropDown_Initialize();
	end)
	
	UIDropDownMenu_Initialize(AltoholicTabCharacters_SelectChar, function(self) 
		AltoholicTabCharacters:SelectCharDropDown_Initialize();
	end)
	
	UIDropDownMenu_Initialize(AltoholicTabCharacters_View, function(self) 
		AltoholicTabCharacters:ViewDropDown_Initialize();
	end)
	
	-- Search Tab DDM
	UIDropDownMenu_Initialize(AltoholicTabSearch_SelectRarity, function(self) 
		AltoholicTabSearch:DropDownRarity_Initialize();
	end)

	UIDropDownMenu_Initialize(AltoholicTabSearch_SelectSlot, function(self) 
		AltoholicTabSearch:DropDownSlot_Initialize();
	end)
	
	UIDropDownMenu_Initialize(AltoholicTabSearch_SelectLocation, function(self) 
		AltoholicTabSearch:DropDownLocation_Initialize();
	end)

	UIDropDownMenu_SetSelectedValue(AltoholicTabSearch_SelectRarity, 0);
	UIDropDownMenu_SetText(ITEM_QUALITY_COLORS[0].hex .. _G["ITEM_QUALITY0_DESC"], AltoholicTabSearch_SelectRarity)

	UIDropDownMenu_SetSelectedValue(AltoholicTabSearch_SelectSlot, 0);
	UIDropDownMenu_SetText(L["Any"], AltoholicTabSearch_SelectSlot)
	
	UIDropDownMenu_SetSelectedValue(AltoholicTabSearch_SelectLocation, 1);
	UIDropDownMenu_SetText(L["This realm"], AltoholicTabSearch_SelectLocation)

	UIDropDownMenu_Initialize(AltoholicTabGuildBank_SelectGuild, function(self) 
		AltoholicTabGuildBank:SelectGuildDropDown_Initialize();
	end)
	
	if self.db.account.data[V.faction][V.realm].char[V.player].playtime == nil then
		RequestTimePlayed()	-- trigger a TIME_PLAYED_MSG event if playtime is unavailable for this character
	end
	
	-- *** Create Scroll Frames' children lines ***
	self:CreateScrollLines("AltoholicFrameSummary", "CharacterSummaryTemplate", 14);
	self:CreateScrollLines("AltoholicFrameBagUsage", "BagUsageTemplate", 14);
	self:CreateScrollLines("AltoholicFrameContainers", "ContainerTemplate", 7, 14);
	
	-- guild bank frames
	local p = _G[ "GuildBank" ]					-- parent frame
	local e = "GuildBankEntry"
	local f = CreateFrame("Button", e .. 1, p, "ContainerTemplate")
	f:SetPoint("TOPLEFT", p, "TOPLEFT", 0, 0)
	
	for i = 2, 7 do
		f = CreateFrame("Button", e .. i, p, "ContainerTemplate")
		f:SetPoint("TOPLEFT", e .. (i-1), "BOTTOMLEFT", 0, 0)
	end
	
	for i=1, 7 do
		_G[e..i.."Item14"]:SetPoint("BOTTOMRIGHT", e..i, "BOTTOMRIGHT", -15, 0);
		for j=13, 1, -1 do
			_G[e..i.."Item" .. j]:SetPoint("BOTTOMRIGHT", e..i.."Item" .. (j + 1), "BOTTOMLEFT", -5, 0);
		end
	end		

	self:CreateScrollLines("AltoholicFrameMail", "MailEntryTemplate", 7);
	self:CreateScrollLines("AltoholicFrameSearch", "SearchEntryTemplate", 7);
	self:CreateScrollLines("AltoholicFrameEquipment", "EquipmentEntryTemplate", 7, 10);

	-- Manually fill the reputation frame
	local repFrame = "AltoholicFrameReputations"
	f = CreateFrame("Button", repFrame .. "Entry" .. 1, _G[repFrame], "ReputationEntryTemplate")
	f:SetPoint("TOPLEFT", repFrame .. "ScrollFrame", "TOPLEFT", 3, 3)
	
	for i = 2, 14 do
		f = CreateFrame("Button", repFrame .. "Entry" .. i, _G[repFrame], "ReputationEntryTemplate")
		f:SetPoint("TOPLEFT", repFrame .. "Entry" .. (i-1), "BOTTOMLEFT", 0, 0)
	end
	
	for i=1, 14 do
		_G[repFrame.."Entry"..i.."Item10"]:SetPoint("BOTTOMRIGHT", repFrame .. "Entry"..i, "BOTTOMRIGHT", -15, 0);
		for j=9, 1, -1 do
			_G[repFrame.."Entry"..i.."Item" .. j]:SetPoint("BOTTOMRIGHT", repFrame.."Entry"..i.."Item" .. (j + 1), "BOTTOMLEFT", -5, 0);
		end
	end

	_G["AltoholicTabCharactersClassesItem10"]:SetPoint("BOTTOMRIGHT", "AltoholicTabCharactersClasses", "BOTTOMRIGHT", -15, 0);
	for j=9, 1, -1 do
		_G["AltoholicTabCharactersClassesItem" .. j]:SetPoint("BOTTOMRIGHT", "AltoholicTabCharactersClassesItem" .. (j + 1), "BOTTOMLEFT", -5, 0);
	end
	
--	self:CreateScrollLines("AltoholicFrameReputations", "ReputationEntryTemplate", 14, 10);
	self:CreateScrollLines("AltoholicFrameSkills", "SkillsTemplate", 14);
	self:CreateScrollLines("AltoholicFrameQuests", "QuestEntryTemplate", 14);
	self:CreateScrollLines("AltoholicFrameRecipes", "RecipesEntryTemplate", 14);
	self:CreateScrollLines("AltoholicFrameAuctions", "AuctionEntryTemplate", 7);
	self:CheckExpiredMail()

	local O = self.db.account.options
	local optionFrame
	
	optionFrame = "AltoholicTabOptionsFrame1"
	_G[ optionFrame .. "_RestXPMode"]:SetChecked(O.RestXPMode)
	optionFrame = "AltoholicTabOptionsFrame2"
	_G[ optionFrame .. "_SearchAutoQuery"]:SetChecked(O.SearchAutoQuery)
	_G[ optionFrame .. "_SortDescending"]:SetChecked(O.SortDescending)
	_G[ optionFrame .. "LootInfo"]:SetText(GREEN .. O.TotalLoots .. "|r " .. L["Loots"] .. " / "
										.. GREEN .. O.UnknownLoots .. "|r " .. L["Unknown"])
	optionFrame = "AltoholicTabOptionsFrame3"
	_G[ optionFrame .. "_SliderMailExpiry"]:SetValue(O.MailWarningThreshold)
	_G[ optionFrame .. "_ScanMailBody"]:SetChecked(O.ScanMailBody)
	optionFrame = "AltoholicTabOptionsFrame4"
	_G[ optionFrame .. "_SliderAngle"]:SetValue(O.MinimapIconAngle)
	_G[ optionFrame .. "_SliderRadius"]:SetValue(O.MinimapIconRadius)
	_G[ optionFrame .. "_ShowMinimap"]:SetChecked(O.ShowMinimap)
	optionFrame = "AltoholicTabOptionsFrame5"
	_G[ optionFrame .. "Source"]:SetChecked(O.TooltipSource)
	_G[ optionFrame .. "Count"]:SetChecked(O.TooltipCount)
	_G[ optionFrame .. "Total"]:SetChecked(O.TooltipTotal)
	_G[ optionFrame .. "GuildBank"]:SetChecked(O.TooltipGuildBank)
	_G[ optionFrame .. "RecipeInfo"]:SetChecked(O.TooltipRecipeInfo)
		
	if AltoholicTabOptionsFrame4_ShowMinimap:GetChecked() then
		self:MoveMinimapIcon()
		AltoholicMinimapButton:Show();
	else
		AltoholicMinimapButton:Hide();
	end
end

function Altoholic:OnDisable()
end

function Altoholic:ToggleUI()
	if (AltoholicFrame:IsVisible()) then
		AltoholicFrame:Hide();
	else
		AltoholicFrame:Show();
	end
end

function Altoholic:OnShow()
	
	if V.ExpiredMail then
		AltoholicTabCharactersStatus:SetText(L["Mail expires in less than "].. self.db.account.options.MailWarningThreshold .. L[" days"])
		V.ExpiredMail = nil
	end
	
	self:UpdatePlayerStats()
	self:UpdatePlayerBags()
	self:UpdateTalents()
	SetPortraitTexture(AltoholicFramePortrait, "player");	
	V.guild = GetGuildInfo("player")

	self:BuildFactionsTable()
	self:BuildCharacterInfoTable()
	
	Altoholic:SummaryMenuOnClick(1)
end

function Altoholic:Tab_OnClick(index)
	if ( not index ) then
		index = this:GetID();
	end
	
	PanelTemplates_SetTab(AltoholicFrame, index);
	AltoholicTabSummary:Hide();
	AltoholicTabCharacters:Hide();
	AltoholicTabSearch:Hide();
	AltoholicTabGuildBank:Hide();
	AltoholicTabOptions:Hide();

	if ( index == 1 ) then				-- Main tab
		AltoholicTabSummary:Show();
	elseif ( index == 2 ) then			-- Info tab
		AltoholicTabCharacters:Show();
	elseif ( index == 3 ) then			-- Search tab
		AltoholicTabSearch:Show();
	elseif ( index == 4 ) then			-- Guild Bank tab
		AltoholicTabGuildBank:Show();
	elseif ( index == 5 ) then			-- Options tab
		AltoholicTabOptions:Show();
	end
end

function Altoholic:BuildCharacterInfoTable()
	local money = 0
	local played = 0
	local levels = 0
	
	V.SkillsCache = {}
	V.Skills = {}

	self:ClearTable(self.CharacterInfo)
	
	for FactionName, f in pairs(self.db.account.data) do
		for RealmName, r in pairs(f) do
			local realmmoney = 0
			local realmplayed = 0
			local realmlevels = 0
			
			table.insert(self.CharacterInfo, { linetype = INFO_REALM_LINE,
				isCollapsed = false,
				--name = fullRealmName
				faction = FactionName,
				realm = RealmName
			} )
			
			local parentRealm = #self.CharacterInfo
			
			for CharacterName, c in pairs(r.char) do
				V.Skills[1] = ""
				V.Skills[2] = ""
				V.SkillsCache[1] = 0
				V.SkillsCache[2] = 0
				local i = 1
				for SkillName, s in pairs(c.skill[L["Professions"]]) do
					V.SkillsCache[i] = self:GetSkillInfo(s)
					V.Skills[i] = SkillName
					i = i + 1
				end
				
				V.SkillsCache[3] = self:GetSkillInfo( c.skill[L["Secondary Skills"]][BI["Cooking"]] )
				V.SkillsCache[4] = self:GetSkillInfo( c.skill[L["Secondary Skills"]][BI["First Aid"]] )
				V.SkillsCache[5] = self:GetSkillInfo( c.skill[L["Secondary Skills"]][BI["Fishing"]] )
				V.SkillsCache[6] = self:GetSkillInfo( c.skill[L["Secondary Skills"]][L["Riding"]] )
				
				local color = self:GetClassColor(c.class)
				
				local bank
				if (c.bankslots == nil) or (c.bankslots == "") then
					bank = L["Bank not visited yet"]
				else
					bank = c.bankslots
				end
				
				table.insert(self.CharacterInfo, { linetype = INFO_CHARACTER_LINE,
					name = CharacterName,
					parentID = parentRealm,
					bankslots = bank,
					skillRank1 = V.SkillsCache[1],
					skillName1 = V.Skills[1],
					skillRank2 = V.SkillsCache[2],
					skillName2 = V.Skills[2],
					cooking = V.SkillsCache[3],
					firstaid = V.SkillsCache[4],
					fishing = V.SkillsCache[5],
					riding = V.SkillsCache[6],
				} )

				realmlevels = realmlevels + c.level
				realmmoney = realmmoney + c.money
				realmplayed = realmplayed + c.played
			end		-- end char

			table.insert(self.CharacterInfo, { linetype = INFO_TOTAL_LINE,
				level = WHITE .. realmlevels .. " |r" .. L["Levels"],
				money = self:GetMoneyString(realmmoney, WHITE),
				played = self:GetTimeString(realmplayed)
			} )
	
			levels = levels + realmlevels
			money = money + realmmoney
			played = played + realmplayed
		end		-- end realm
	end		-- end faction
	
	_G["AltoholicFrameTotalLv"]:SetText(WHITE .. levels .. " |rLv")
	_G["AltoholicFrameTotalGold"]:SetText(floor( money / 10000 ) .. "|cFFFFD700g")
	_G["AltoholicFrameTotalPlayed"]:SetText(floor(played / 86400) .. "|cFFFFD700d")
	
	self:ClearTable(V.SkillsCache)
	self:ClearTable(V.Skills)
end

function Altoholic:UpdatePlayerStats()
	local r = self.db.account.data[V.faction][V.realm]		-- this realm
	local c = r.char[V.player]						-- this char
			
	self:PLAYER_XP_UPDATE()
	self:UpdatePlayerSkills()
	
	-- *** Container information ***
	local nTotalSlots = 0
	local nSlots
	
	nTotalSlots = GetContainerNumSlots(0) 
	c.bags = nTotalSlots .. "/"
	for i = 1, 4 do
		nSlots = GetContainerNumSlots(i)
		nTotalSlots = nTotalSlots + nSlots

		c.bags = c.bags .. WHITE .. nSlots
		if i ~= 4 then
			c.bags = c.bags .. "|r/"
		end
	end
	c.bags = c.bags .. " |r(|cFF00FF00" .. nTotalSlots .. "|r)"
	
	self:UpdateEquipment()
	self:PLAYER_MONEY()
	
	-- *** Factions ***
	for i = GetNumFactions(), 1, -1 do		-- 1st pass, expand all headers (from last to first), otherwise data can't be collected
		local _, _, _, _, _, _, _,	_, isHeader, isCollapsed, _ = GetFactionInfo(i)
		if isHeader and isCollapsed then
			ExpandFactionHeader(i)
		end
	end

	for i = 1, GetNumFactions() do		-- 2nd pass, data collection
		local name, _, _, bottom, top, earned, _,	_, isHeader, _, _ = GetFactionInfo(i)
		if isHeader == nil then
			r.reputation[name][V.player] = bottom .. "|" .. top .. "|" .. earned
		end
	end
	
	self:UpdateQuestLog()
	self:UpdateRaidTimers()
	self:UpdatePVPStats()
end

function Altoholic:UpdatePlayerSkills()
	local c = Altoholic.db.account.data[V.faction][V.realm].char[UnitName("player")]
	
	if not c then return end
	
    -- *** Skills inventory ***
	for i = GetNumSkillLines(), 1, -1 do		-- 1st pass, expand all categories
		local _, isHeader = GetSkillLineInfo(i)
		if isHeader then
			ExpandSkillHeader(i)
		end
	end

	local category
	for i = 1, GetNumSkillLines() do
		local skillName, isHeader, _, skillRank, _, _, skillMaxRank = GetSkillLineInfo(i)
		if isHeader then
			category = skillName
		else
			if category and skillName then
				c.skill[category][skillName] = skillRank .. "|" .. skillMaxRank
			end
		end
	end
end

function Altoholic:UpdatePVPStats()
	local c = self.db.account.data[V.faction][V.realm].char[UnitName("player")]
	
	c.pvp_hk, c.pvp_dk = GetPVPLifetimeStats()
	c.pvp_ArenaPoints = GetArenaCurrency()
	c.pvp_HonorPoints = GetHonorCurrency()
end

function Altoholic:UpdateTalents()
	local c = self.db.account.data[V.faction][V.realm].char[UnitName("player")]
	
	c.talent = ""
	for i = 1, GetNumTalentTabs() do
		local numTalents = GetNumTalents(i) 
		local _, _, pointsSpent, _ = GetTalentTabInfo( i );
		
		c.talent = c.talent .. WHITE .. pointsSpent
		if i ~= 3 then
			c.talent = c.talent .. "|r/"
		end
	end
end

function Altoholic:UpdateEquipment()
	local c = self.db.account.data[V.faction][V.realm].char[UnitName("player")]
	
	for i = 1, 19 do
		local link = GetInventoryItemLink("player", i)
		if link ~= nil then 
			
			-- if any of these differs from 0, there's an enchant or a jewel, so save the full link
			if self:GetEnchantInfo(link) then		-- 1st return value = isEnchanted
				c.inventory[i] = link
			else -- only save the id otherwise
				c.inventory[i] = self:GetIDFromLink(link)
			end		
		else
			c.inventory[i] = nil
		end
	end		
end

function Altoholic:UpdatePlayerBags()
	for bagID = 0, 4 do
		self:UpdatePlayerBag(bagID)
	end
	self:UpdateKeyRing()
end

function Altoholic:UpdatePlayerBag(bagID)
	if bagID < 0 then return end

	local b = self.db.account.data[V.faction][V.realm].char[V.player].bag["Bag" .. bagID]
	
	if bagID == 0 then	-- Bag 0	
		b.icon = "Interface\\Buttons\\Button-Backpack-Up";
		b.link = nil;
	else						-- Bags 1 through 11
		b.icon = GetInventoryItemTexture("player", ContainerIDToInventoryID(bagID))
		b.link = GetInventoryItemLink("player", ContainerIDToInventoryID(bagID))
	end
	b.freeslots, b.bagtype = GetContainerNumFreeSlots(bagID)
	b.size = GetContainerNumSlots(bagID)
	self:PopulateContainer(bagID)
end

function Altoholic:PopulateContainer(bagID)
	local b = self.db.account.data[V.faction][V.realm].char[V.player].bag["Bag" .. bagID]

	for slotID = 1, b.size do
		b.ids[slotID] = nil
		b.counts[slotID] = nil
		b.links[slotID] = nil
		
		local link = GetContainerItemLink(bagID, slotID)
		if link ~= nil then
			b.ids[slotID] = self:GetIDFromLink(link)
		
			-- if any of these differs from 0, there's an enchant or a jewel, so save the full link
			if self:GetEnchantInfo(link) then		-- 1st return value = isEnchanted
				b.links[slotID] = link
			end
		
			local _, count = GetContainerItemInfo(bagID, slotID)
			if (count ~= nil) and (count > 1)  then
				b.counts[slotID] = count	-- only save the count if it's > 1 (to save some space since a count of 1 is extremely redundant)
			end
		end
	end
end

function Altoholic:UpdateKeyRing()
	local b = self.db.account.data[V.faction][V.realm].char[V.player].bag["Bag-2"]
	
	b.size = GetContainerNumSlots(-2)
	b.icon = "Interface\\Icons\\INV_Misc_Key_14";
	b.link = nil
	self:PopulateContainer(-2)
end

function Altoholic:UpdateContainerCache()
	local c = self.db.account.data[V.CurrentFaction][V.CurrentRealm].char[V.CurrentAlt]
	
	self:ClearTable(self.BagIndices)
	for bagID = 0, 11 do
		if c.bag["Bag"..bagID] ~= nil then 
			self:UpdateBagIndices(bagID, c.bag["Bag"..bagID].size)
		end
	end
	
	self:UpdateBagIndices(-2, 32)		-- KeyRing
	if c.bag["Bag100"] ~= nil then 	-- if bank hasn't been visited yet, exit
		self:UpdateBagIndices(100, 28)
	end
end

function Altoholic:UpdateBagIndices(bag, size)
	-- the BagIndices table will be used by self:Containers_Update to determine which part of a bag should be displayed on a given line
	-- ex: [1] = bagID = 0, from 1, to 12
	-- ex: [2] = bagID = 0, from 13, to 16
	local lowerLimit = 1

	while size > 0 do					-- as long as there are slots to process ..
		table.insert(self.BagIndices, { bagID=bag, from=lowerLimit} )
	
		if size <= 12 then			-- no more lines ? leave
			return
		else
			size = size - 12			-- .. or adjust counters
			lowerLimit = lowerLimit + 12
		end
	end
end

function Altoholic:UpdatePlayerBank(scanBags)
	if scanBags == nil then		-- by default, scan everything
		scanBags = true
	end

	local c = self.db.account.data[V.faction][V.realm].char[V.player]	-- this char
	if scanBags then
		local nTotalSlots = 28
		c.bankslots = "28/"
		for bagID = 5, 11 do
			self:UpdatePlayerBag(bagID)
			local nSlots = GetContainerNumSlots(bagID)
			nTotalSlots = nTotalSlots + nSlots

			c.bankslots = c.bankslots .. WHITE .. nSlots
			if bagID ~= 11 then
				c.bankslots = c.bankslots .. "|r/"
			end
		end	
		c.bankslots = c.bankslots .. " |r(|cFF00FF00" .. nTotalSlots .. "|r)"
	end
	
	local b = c.bag["Bag100"]
	b.size = 28
	b.freeslots, b.bagtype = GetContainerNumFreeSlots(-1)		-- -1 = player bank
	
	for slotID = 40, 67 do
		local index = slotID-39		-- 28 bank slots = inventory slot id 40 to 67, so subtract 39
		b.ids[index] = nil
		b.counts[index] = nil
		b.links[index] = nil		
		
		local link = GetInventoryItemLink("player", slotID)	
		if link ~= nil then
			b.ids[index] = self:GetIDFromLink(link)
			
			-- if any of these differs from 0, there's an enchant or a jewel, so save the full link
			if self:GetEnchantInfo(link) then		-- 1st return value = isEnchanted
				b.links[index] = link
			end
			
			local count = GetInventoryItemCount("player", slotID)
			if (count ~= nil) and (count > 1)  then
				b.counts[index] = count	-- only save the count if it's > 1 (to save some space since a count of 1 is extremely redundant)
			end
		end
	end
end

function Altoholic:UpdateRaidTimers()	
	local c = self.db.account.data[V.faction][V.realm].char[V.player]
	
	self:ClearTable(c.SavedInstance)
	
	for i=1, GetNumSavedInstances() do
		local instanceName, instanceID, instanceReset = GetSavedInstanceInfo(i)
		
		c.SavedInstance[instanceName] = instanceID .. "|" .. instanceReset .. "|" .. time()
	end
end

function Altoholic:BuildFactionsTable()
	local repDB = self.db.account.data[V.CurrentFaction][V.CurrentRealm].reputation
	
	if V.Factions then
		self:ClearTable(V.Factions)
	else
		V.Factions = {}
	end
	
	local factionGroup
	for i, f in pairs(self.FactionsRefTable) do		-- browse the reference table
		if type(f) == "string" then		-- is the entry a string or a table ?
			for repName, _ in pairs(repDB) do
				if repName == f then			-- if the current rep from the reference table exists in the DB ..
					if factionGroup ~= nil then
						table.insert(V.Factions, {			 	-- save the header table
							name = self.FactionsRefTable[factionGroup][1],
							isHeader = true,
							isCollapsed = false
						} )
						factionGroup = nil
					end
				
					table.insert(V.Factions, f)	-- then save the current line (a string)
					break
				end
			end
		else
			factionGroup = i		-- save the index of the last faction group encountered in the refTable
		end
	end
end


-- *** Utility functions ***
function Altoholic:ClearTable(t)
	if type(t) ~= "table" then
		return
	end
	
	for k in pairs (t) do
		if type(t[k]) == "table" then
			self:ClearTable(t[k])
		end
		t[k] = nil
	end
end

function Altoholic:ClearScrollFrame(name, entry, lines, height)
	for i=1, lines do					-- Hides all entries of the scrollframe, and updates it accordingly
		_G[ entry..i ]:Hide()
	end
	FauxScrollFrame_Update( name, lines, lines, height);
end

function Altoholic:CreateScrollLines(parentFrame, inheritsFrom, numLines, numItems)
	local f = CreateFrame("Button", parentFrame .. "Entry1", _G[parentFrame], inheritsFrom)
	f:SetPoint("TOPLEFT", parentFrame .. "ScrollFrame", "TOPLEFT", 0, 0)
	
	for i = 2, numLines do
		f = CreateFrame("Button", parentFrame .. "Entry" .. i, _G[parentFrame], inheritsFrom)
		f:SetPoint("TOPLEFT", parentFrame .. "Entry" .. (i-1), "BOTTOMLEFT", 0, 0)
	end
	
	if not numItems then return end
	
	for i=1, numLines do
		_G[parentFrame.."Entry"..i.."Item" .. numItems]:SetPoint("BOTTOMRIGHT", parentFrame .. "Entry"..i, "BOTTOMRIGHT", -15, 0);
		for j=(numItems-1), 1, -1 do
			_G[parentFrame.."Entry"..i.."Item" .. j]:SetPoint("BOTTOMRIGHT", parentFrame.."Entry"..i.."Item" .. (j + 1), "BOTTOMLEFT", -5, 0);
		end
	end
end

function Altoholic:GetIDFromLink(link)
	return tonumber(link:match("item:(%d+)"))
end

function Altoholic:GetEnchantInfo(link)
	local _, _, itemString = strsplit("|", link)
	local _, itemID, enchantId, jewelId1, jewelId2, jewelId3, 
					jewelId4, suffixId = strsplit(":", itemString)
					
	local isEnchanted = false
	for i=1, 6 do	-- parse all arguments
		-- if not nil and differs from "0" .. item is enchanted
		if select(i, enchantId, jewelId1, jewelId2, jewelId3, jewelId4, suffixId) and
			select(i, enchantId, jewelId1, jewelId2, jewelId3, jewelId4, suffixId) ~= "0" then
			
			isEnchanted = true
			break
		end
	end
	
	return isEnchanted, enchantId, jewelId1, jewelId2, jewelId3, jewelId4, suffixId
end

function Altoholic:GetMoneyString(copper, color)
	local gold = floor( copper / 10000 );
	copper = copper - (gold * 10000)
	local silver = floor( copper / 100 );
	copper = copper - (silver * 100)
	
	if color == nil then
		color = "|cFFFFD700"
	end

	-- use this later, when it will be possible to use texcoords in a fontstring
	--DEFAULT_CHAT_FRAME:AddMessage("|TInterface\\MoneyFrame\\UI-MoneyIcons:30|t")
	
	return color .. gold .. "|cFFFFD700g " .. color .. silver .. "|cFFC7C7CFs " .. color .. copper .. "|cFFEDA55Fc"
end

function Altoholic:GetTimeString(seconds)
	local days = floor(seconds / 86400);				-- TotalTime is expressed in seconds
	seconds = seconds - (days * 86400)
	local hours = floor(seconds / 3600);
	seconds = seconds - (hours * 3600)
	local minutes = floor(seconds / 60);
	seconds = seconds - (minutes * 60)
	
	local c1 = WHITE
	local c2 = "|r"

	return c1 .. days .. c2 .. "d " .. c1 .. hours .. c2 .. "h " .. c1 .. minutes .. c2 .. "m"
end

function Altoholic:GetRealmString(faction, realm)
	if faction == FACTION_ALLIANCE then
		return "|cFF2459FF" .. realm
	else
		return "|cFFFF0000" .. realm
	end
end

function Altoholic:GetFullRealmString(faction, realm)
	if faction == "Alliance" then
		return "|cFF2459FF[" .. FACTION_ALLIANCE .. "] " .. WHITE .. realm
	else
		return "|cFFFF0000[" .. FACTION_HORDE .. "] " .. WHITE .. realm
	end
end

function Altoholic:GetQuestTypeString(tag, size)
	if size == 0 then
		return WHITE .. tag 
	elseif size == 2 then
		return WHITE .. tag .. GREEN .. " (" .. size .. ")"
	elseif size == 3 then
		return WHITE .. tag .. YELLOW .. " (" .. size .. ")"
	elseif size == 4 then
		return WHITE .. tag .. ORANGE .. " (" .. size .. ")"
	end
	return WHITE .. tag .. RED .. " (" .. size .. ")"
end

function Altoholic:GetClassColor(class)
	-- with "Mage" as parameter
	-- the function uses the value of the class entry in Altoholic.Classes
	-- ex:	[L["Mage"]]		= 1,
	-- to return the color from Altoholic.ClassInfo:
	-- ex:	[1] = { color = "|cFF69CCF0", texcoord = {0.25, 0.49609375, 0, 0.25} },
	-- this is necessary to easily support the female class names introduced in 2.4 in French & German
	
	return Altoholic.ClassInfo[ Altoholic.Classes[class] ].color
end

function Altoholic:GetDelayInDays(delay)
	return floor((time() - delay) / 86400)
end

function Altoholic:GetRestedXP(maxXP, restXP, logout, isResting)
	-- get the known rate of rest xp (the one saved at last logout) + the rate represented by the elapsed time since last logout
	-- (elapsed time / 3600) * 0.625 * (2/3)  simplifies to elapsed time / 8640
	-- 0.625 comes from 8 hours rested = 5% of a level, *2/3 because 100% rested = 150% of xp (1.5 level)
	local rate = self:GetRestXPRate(maxXP, restXP)
	
	if logout ~= 0 then		-- time since last logout, 0 for current char, <> for all others
		if isResting then
			rate = rate + ((time() - logout) / 8640)
		else
			rate = rate + ((time() - logout) / 34560)	-- 4 times less if not at an inn
		end
	end

	local coeff
	if AltoholicTabOptionsFrame1_RestXPMode:GetChecked() then
		coeff = 1.5
		rate = rate * coeff
	else
		coeff = 1
	end
	
	if rate >= (100 * coeff) then 
		return "|cFF00FF00" .. format("%d", (100 * coeff)) .. L["% rested"]
	else
		local color
		if rate < (30 * coeff) then
			color = "|cFFFF0000"
		elseif rate < (60 * coeff) then
			color = "|cFFFFFF00"
		else
			color = GREEN
		end
		return color .. format("%d", rate) .. L["% rested"]
	end
end

function Altoholic:GetRestXPRate(maxXP, restXP)

	-- after extensive tests, it seems that the known formula to calculate rest xp is incorrect.
	-- I believed that the maximum rest xp was exactly 1.5 level, and since 8 hours of rest = 5% of a level
	-- being 100% rested would mean having 150% xp .. but there's a trick...
	-- One would expect that 150% of rest xp would be split over the following levels, and that calculating the exact amount of rest
	-- would require taking into account that 30% are over the current level, 100% over lv+1, and the remaining 20% over lv+2 ..
	
	-- .. But that is not the case.Blizzard only takes into account 150% of rest xp AT THE CURRENT LEVEL RATE.
	-- ex: at level 15, it takes 13600 xp to go to 16, therefore the maximum attainable rest xp is:
	--	136 (1% of the level) * 150 = 20400 

	-- thus, to calculate the exact rate (ex at level 15): 
		-- divide xptonext by 100 : 		13600 / 100 = 136	==> 1% of the level
		-- multiply by 1.5				136 * 1.5 = 204
		-- divide rest xp by this value	20400 / 204 = 100	==> rest xp rate
		
	if not restXP then return 0 end
	return (restXP / ((maxXP / 100) * 1.5))
end

function Altoholic:GetGuildBankTabName(faction, realm, guildName, id)
	local gb = self.db.account.data[faction][realm].guild[guildName].bank
	
	for k, v in pairs(gb) do
		if id == v.tabID then return v.name end
	end
	return nil	
end

function Altoholic:GetCharacterInfo(line)
	-- with the line number in the Altoholic.CharacterInfo table, return the realm & faction based on the parent id of this line
	local s = Altoholic.CharacterInfo[ Altoholic.CharacterInfo[line].parentID ]
	return s.faction, s.realm
end

function Altoholic:GetCharacterInfoLine(char)
	-- with the name of a character, returns the line number in the Altoholic.CharacterInfo table
	-- This prevents from saving the character name, realm and faction in the search results table.

	for k, v in pairs(Altoholic.CharacterInfo) do
		if v.linetype == INFO_CHARACTER_LINE then
			if v.name == char then
				return k
			end
		end
	end
end

function Altoholic:GetItemDropLocation(searchedID)
	for Instance, BossList in pairs(Altoholic.LootTable) do
		for Boss, LootList in pairs(BossList) do
			for itemID, _ in pairs(LootList) do
				if LootList[itemID] == searchedID then
					return Instance, Boss
				end
			end
		end
	end
	return nil
end

function Altoholic:GetItemCount(searchedID)
	-- Return the total amount of times an item is present on this realm, and prepares the V.ItemCount table for later display by the tooltip
	if V.ItemCount == nil then				-- create this table if it doesn't exist yet
		V.ItemCount = {}
	else
		self:ClearTable(V.ItemCount)		-- or clear it if it does
	end
	
	local count = 0
	for CharacterName, c in pairs(self.db.account.data[V.faction][V.realm].char) do
		
		local bagCount = 0
		local bankCount = 0
		for BagName, b in pairs(c.bag) do
			for slotID=1, b.size do
				local id = b.ids[slotID]
				
				if (id) and (id == searchedID) then
					local itemCount
					if (b.counts[slotID] == nil) or (b.counts[slotID] == 0) then
						itemCount = 1
					else
						itemCount = b.counts[slotID]
					end
					
					if (BagName == "Bag100") then
						bankCount = bankCount + itemCount
					elseif (BagName == "Bag-2") then
						bagCount = bagCount + itemCount
					else
						local bagNum = tonumber(string.sub(BagName, 4))
						if (bagNum >= 0) and (bagNum <= 4) then
							bagCount = bagCount + itemCount
						else
							bankCount = bankCount + itemCount
						end			
					end		
				end
			end
		end	-- bag loop
		
		local equipCount = 0
		for slotID=1, 19 do								-- equipped items
			local s = c.inventory[slotID]
			if (s ~= nil) then
				if type(s) == "number" then
					if (s == searchedID) then
						equipCount = equipCount + 1
					end
				elseif self:GetIDFromLink(s) == searchedID then
					equipCount = equipCount + 1
				end
			end
		end
		
		local mailCount = 0
		for slotID=1, #c.mail do						-- mails
			local s = c.mail[slotID]
			if (s.link ~= nil) and (self:GetIDFromLink(s.link) == searchedID) then
				if (s.count == nil) or (s.count == 0) then
					mailCount = mailCount + 1
				else
					mailCount = mailCount + s.count
				end
			end
		end

		local charCount = bagCount + bankCount + equipCount + mailCount
		count = count + charCount		-- add the character count to the total count
		
		if charCount > 0 then
			-- charInfo should look like 	(Bags: 4, Bank: 8, Equipped: 1, Mail: 7)
			local charInfo = ORANGE .. charCount .. WHITE .. " ("
			if bagCount > 0 then
				charInfo = charInfo .. WHITE .. L["Bags"] .. ": "  .. TEAL .. bagCount
				charCount = charCount - bagCount			-- decrease the charcount to see if the comma should be added
				if charCount > 0 then
					charInfo = charInfo .. WHITE .. L[", "]
				end
			end

			if bankCount > 0 then
				charInfo = charInfo .. WHITE .. L["Bank"] .. ": " .. TEAL .. bankCount
				charCount = charCount - bankCount
				if charCount > 0 then
					charInfo = charInfo .. WHITE .. L[", "]
				end
			end

			if equipCount > 0 then
				charInfo = charInfo .. WHITE .. L["Equipped"] .. ": "  .. TEAL .. equipCount
				charCount = charCount - equipCount
				if charCount > 0 then
					charInfo = charInfo .. WHITE .. L[", "]
				end
			end

			if mailCount > 0 then
				charInfo = charInfo .. WHITE .. L["Mail"] .. ": "  .. TEAL .. mailCount
			end
			
			charInfo = charInfo .. WHITE .. ")"
					
			V.ItemCount[Altoholic:GetClassColor(c.class) .. CharacterName] = charInfo
		end
	end	-- character loop
	
	if AltoholicTabOptionsFrame5GuildBank:GetChecked() then
		for guildName, g in pairs(self.db.account.data[V.faction][V.realm].guild) do
			local guildCount = 0
			for TabName, t in pairs(g.bank) do
				for slotID, id in pairs(t.ids) do
					if (id) and (id == searchedID) then
						if (t.counts[slotID] == nil) or (t.counts[slotID] == 0) then
							guildCount = guildCount + 1
						else
							guildCount = guildCount + t.counts[slotID]
						end
					end
				end	-- end slots
			end	-- end tabs
			if guildCount > 0 then
				V.ItemCount[GREEN .. guildName] = WHITE .. L["(Guild bank: "] .. TEAL .. guildCount .. WHITE .. ")"
			end
			count = count + guildCount
		end	-- end guild
	end
	
	return count
end

function Altoholic:IsGatheringNode(name)
	-- returns the itemID if "name" is a known type of gathering node (mines & herbs)
	if name == nil then return nil end
	
	for k, v in pairs( self.Gathering ) do
		if name == k then
			return v
		end
	end
	return nil	-- not found, return nil
end

function Altoholic:IsKnownQuest(quest)
	if not quest then return nil end
	
	local bOtherCharsOnQuest		-- is there at least one other char on the quest ?
	for CharacterName, c in pairs(self.db.account.data[V.faction][V.realm].char) do
		if CharacterName ~= V.player then
			for index, q in pairs(c.questlog) do	-- parse all quests
				local altQuestName = Altoholic:GetQuestDetails(q.link)
				if altQuestName == quest then
					if not bOtherCharsOnQuest then
						ItemRefTooltip:AddLine(" ",1,1,1);
						ItemRefTooltip:AddLine(GREEN .. L["Are also on this quest:"],1,1,1);
						bOtherCharsOnQuest = true	-- pass here only once
					end
					ItemRefTooltip:AddLine(Altoholic:GetClassColor(c.class) .. CharacterName,1,1,1);
				end
			end
		end
	end
end

function Altoholic:GetSuggestion(index, level)
	if self.Suggestions[index] == nil then return nil end
	
	for k, v in pairs( self.Suggestions[index] ) do
		if level < v[1] then		-- the suggestions are sorted by level, so whenever we're below, return the text
			return v[2]
		end
	end
	return nil	-- already at max level, no suggestion
end

function Altoholic:GetSkillColor(rank)
	if rank < 150 then
		return RED
	elseif rank < 300 then
		return ORANGE
	elseif rank < 375 then
		return YELLOW
	else
		return GREEN
	end
end

function Altoholic:UpdateSlider(name, text, field)
	local s = getglobal(name)
	getglobal(name .. "Text"):SetText(text .. " (" .. s:GetValue() ..")");
	
	local a = self.db.account
	if a == nil then return	end
	
	a.options[field] = s:GetValue()
	self:MoveMinimapIcon()
end


-- *** Overloaded events (OnEnter, OnClick ..) ***
function Altoholic:DrawCharacterTooltip(charName)
	local c = self.db.account.data[V.CurrentFaction][V.CurrentRealm].char[charName]
	AltoTooltip:SetOwner(this, "ANCHOR_LEFT");
	AltoTooltip:ClearLines();
	AltoTooltip:AddLine(Altoholic:GetClassColor(c.class)..charName,1,1,1);
	AltoTooltip:AddLine(L["Level"] .. " " .. GREEN .. c.level .. " |r".. c.race .. " " .. c.class,1,1,1);
	AltoTooltip:AddLine(L["Zone"] .. ": " .. GOLD .. c.zone .. " |r(" .. GOLD .. c.subzone .."|r)",1,1,1);
	if c.restxp then
		AltoTooltip:AddLine(L["Rest XP"] .. ": " .. GREEN .. c.restxp,1,1,1);
	end
	
	local totalItemLevel = 0
	local itemCount = 0
	for k, v in pairs(c.inventory) do
		itemCount = itemCount + 1
		local iLvl = select(4, GetItemInfo(v))
		totalItemLevel = totalItemLevel + tonumber(iLvl)
	end

	AltoTooltip:AddLine("Average iLevel: " .. GREEN .. format("%.1f", (totalItemLevel / itemCount)),1,1,1);	
	
	AltoTooltip:Show();
end


-- *** Hooks ***
local Orig_ChatEdit_InsertLink = ChatEdit_InsertLink

function ChatEdit_InsertLink(text, ...)
	if text and AltoholicFrame_SearchEditBox:IsVisible() then
		AltoholicFrame_SearchEditBox:Insert(GetItemInfo(text))
		return true
	else
		return Orig_ChatEdit_InsertLink(text, ...)
	end
end

local function Hook_LinkWranger (frame)
	local name, link = frame:GetItem ()
	if name and link then
		Altoholic:ProcessTooltip (frame, name, link)
	end
end

-- ** GameTooltip Hooks **

-- local Orig_GameTooltip_SetUnit  = GameTooltip:GetScript("OnTooltipSetUnit")
-- GameTooltip:SetScript("OnTooltipSetUnit", function(tooltip, ...)
	-- if Orig_GameTooltip_SetUnit then
		-- Orig_GameTooltip_SetUnit(tooltip, ...)
	-- end
-- end)

-- local Orig_GameTooltip_SetSpell  = GameTooltip:GetScript("OnTooltipSetSpell")
-- GameTooltip:SetScript("OnTooltipSetSpell", function(tooltip, ...)
	-- if Orig_GameTooltip_SetSpell then
		-- Orig_GameTooltip_SetSpell(tooltip, ...)
	-- end
-- end)

local Orig_GameTooltip_SetItem = GameTooltip:GetScript("OnTooltipSetItem")
GameTooltip:SetScript("OnTooltipSetItem", function(tooltip, ...)
	if Orig_GameTooltip_SetItem then
		Orig_GameTooltip_SetItem(tooltip, ...)
	end

	if (not V.TooltipDone) and tooltip then
		local name, link = tooltip:GetItem()
		V.TooltipDone = true
		if link then
			Altoholic:ProcessTooltip(tooltip, name, link)
		end
	end
end)

local Orig_GameTooltip_ClearItem = GameTooltip:GetScript("OnTooltipCleared")
GameTooltip:SetScript("OnTooltipCleared", function(tooltip, ...)
	V.TooltipDone = nil
	return Orig_GameTooltip_ClearItem(tooltip, ...)
end)

local Orig_GameTooltip_OnShow = GameTooltip:GetScript("OnShow")
GameTooltip:SetScript("OnShow", function(...)

	if Orig_GameTooltip_OnShow then
		Orig_GameTooltip_OnShow(...)
	end	

	local itemID = Altoholic:IsGatheringNode( _G["GameTooltipTextLeft1"]:GetText() )
	if itemID and (itemID ~= V.ToolTipCachedItemID) then			-- is the item in the tooltip a known type of gathering node ?

		-- check player bags to see how many times he owns this item, and where
		if AltoholicTabOptionsFrame5Count:GetChecked() or AltoholicTabOptionsFrame5Total:GetChecked() then
			V.ToolTipCachedCount = Altoholic:GetItemCount(itemID) -- if one of the 2 options is active, do the count
			if V.ToolTipCachedCount > 0 then
				V.ToolTipCachedTotal = GOLD .. L["Total owned"] .. ": |cff00ff9a" .. V.ToolTipCachedCount
			else
				V.ToolTipCachedTotal = nil
			end
		end		
		
		if (AltoholicTabOptionsFrame5Count:GetChecked()) and (V.ToolTipCachedCount > 0) then			-- add count per character
			GameTooltip:AddLine(" ",1,1,1);
			for CharacterName, c in pairs (V.ItemCount) do
				GameTooltip:AddDoubleLine(CharacterName .. ":",  TEAL .. c);
			end
		end
		
		if (AltoholicTabOptionsFrame5Total:GetChecked()) and (V.ToolTipCachedTotal) then		-- add total count
			GameTooltip:AddLine(V.ToolTipCachedTotal,1,1,1);
		end		
	end
	
	GameTooltip:Show()
end)

local Orig_ItemRefTooltip_OnShow = ItemRefTooltip:GetScript("OnShow")
ItemRefTooltip:SetScript("OnShow", function(...)
	
	if Orig_ItemRefTooltip_OnShow then
		Orig_ItemRefTooltip_OnShow(...)
	end

	Altoholic:IsKnownQuest( _G["ItemRefTooltipTextLeft1"]:GetText() )
	ItemRefTooltip:Show()
end)

local Orig_ItemRefTooltip_SetItem = ItemRefTooltip:GetScript("OnTooltipSetItem")
ItemRefTooltip:SetScript("OnTooltipSetItem", function(tooltip, ...)
	if Orig_ItemRefTooltip_SetItem then
		Orig_ItemRefTooltip_SetItem(tooltip, ...)
	end
	
	if (not V.TooltipDone) and tooltip then
		local name, link = tooltip:GetItem()
		V.TooltipDone = true
		if link then
			Altoholic:ProcessTooltip(tooltip, name, link)
		end
	end
end)

local Orig_ItemRefTooltip_ClearItem = ItemRefTooltip:GetScript("OnTooltipCleared")
ItemRefTooltip:SetScript("OnTooltipCleared", function(tooltip, ...)
	V.TooltipDone = nil
	return Orig_ItemRefTooltip_ClearItem(tooltip, ...)
end)

function Altoholic:ProcessTooltip(tooltip, name, link)
	local itemID = self:GetIDFromLink(link)
	
	-- if there's no cached item id OR if it's different from the previous one ..
	if (not V.ToolTipCachedItemID) or 
		(V.ToolTipCachedItemID and (itemID ~= V.ToolTipCachedItemID)) then

		V.TooltipRecipeCache = nil
		
		-- these are the cpu intensive parts of the update .. so do them only if necessary
		if AltoholicTabOptionsFrame5Source:GetChecked() then
			local Instance, Boss = self:GetItemDropLocation(itemID)
			V.ToolTipCachedItemID = itemID			-- we have searched this ID ..
		
			if (Instance == nil) then
				V.ToolTipCachedSource = nil			--  no results found, or the option is unchecked
			else
				V.ToolTipCachedSource = GOLD .. L["Source"]..  ": |cff00ff9a" .. Instance .. ", " .. Boss
			end
		else
			V.ToolTipCachedSource = nil			--  make sure nothing is displayed if the option is unchecked
		end
		
		-- .. then check player bags to see how many times he owns this item, and where
		if AltoholicTabOptionsFrame5Count:GetChecked() or AltoholicTabOptionsFrame5Total:GetChecked() then
			V.ToolTipCachedCount = self:GetItemCount(itemID) -- if one of the 2 options is active, do the count
			if V.ToolTipCachedCount > 0 then
				V.ToolTipCachedTotal = GOLD .. L["Total owned"] .. ": |cff00ff9a" .. V.ToolTipCachedCount
			else
				V.ToolTipCachedTotal = nil
			end
		end
	end
	
	if (AltoholicTabOptionsFrame5Count:GetChecked()) and (V.ToolTipCachedCount > 0) then			-- add count per character
		tooltip:AddLine(" ",1,1,1);
		for CharacterName, c in pairs (V.ItemCount) do
			tooltip:AddDoubleLine(CharacterName .. ":",  TEAL .. c);
		end
	end
	
	if (AltoholicTabOptionsFrame5Total:GetChecked()) and (V.ToolTipCachedTotal) then		-- add total count
		tooltip:AddLine(V.ToolTipCachedTotal,1,1,1);
	end
	
	if V.ToolTipCachedSource then		-- add item source
		tooltip:AddLine(" ",1,1,1);
		tooltip:AddLine(V.ToolTipCachedSource,1,1,1);
	end
	
	-- Keep here if necessary, can be useful for debugging
	-- local iLevel = select(4, GetItemInfo(itemID))
	
	-- if iLevel then
		-- tooltip:AddLine(" ",1,1,1);
		-- tooltip:AddDoubleLine("Item ID: " .. GREEN .. itemID,  "iLvl: " .. GREEN .. iLevel);
		-- tooltip:AddLine(TEAL .. select(10, GetItemInfo(itemID)));
	-- end
	
	if not AltoholicTabOptionsFrame5RecipeInfo:GetChecked() then return end -- exit if recipe information is not wanted
	
	local _, _, _, _, _, itemType, itemSubType = GetItemInfo(itemID)
	if itemType ~= BI["Recipe"] then return end		-- exit if not a recipe
	if itemSubType == BI["Book"] then return end		-- exit if it's a book

	if not V.TooltipRecipeCache then
		local tooltipName = tooltip:GetName()
		local reqLevel
		for i = 2, tooltip:NumLines() do			-- parse all tooltip lines, one by one
			local tooltipText = _G[tooltipName .. "TextLeft" .. i]:GetText()
			if tooltipText then
				if string.find(tooltipText, "%d+") then	-- try to find a numeric value .. 
					reqLevel = tonumber(string.sub(tooltipText, string.find(tooltipText, "%d+")))
					break
				end
			end
		end
		V.TooltipRecipeCache = self:WhoKnowsRecipe(itemSubType, link, reqLevel)
	end
	
	if V.TooltipRecipeCache then
		tooltip:AddLine(" ",1,1,1);	
		tooltip:AddLine(V.TooltipRecipeCache,1,1,1);
	end	
end

function Altoholic:GetCraftFromRecipe(link)
	-- get the craft name from the itemlink (strsplit on | to get the 4th value, then split again on ":" )
	local recipeName = select(4, strsplit("|", link))
	local craftName

	-- try to determine if it's a transmute (has 2 colons in the string --> Alchemy: Transmute: blablabla)
	local pos = string.find(recipeName, L["Transmute"])
	if pos then	-- it's a transmute
		return string.sub(recipeName, pos, -2)
	else
		craftName = select(2, strsplit(":", recipeName))
	end
	
	if craftName == nil then		-- will be nil for enchants
		return string.sub(recipeName, 3, -2)		-- ex: "Enchant Weapon - Striking"
	end
	
	return string.sub(craftName, 2, -2)	-- at this point, get rid of the leading space and trailing square bracket
end

function Altoholic:WhoKnowsRecipe(profession, link, recipeLevel)
	local craftName = self:GetCraftFromRecipe(link)
	if craftName == nil then return end		-- if this happens, then exit
	local s 	-- will contain the string to add in the tooltip
	
	for CharacterName, c in pairs(self.db.account.data[V.faction][V.realm].char) do
		local p = c.recipes[profession]
		if p.ScanFailed == false then
			local isKnownByChar = false
			
			for _, TradeSkillInfo in pairs (p.list) do
				if TradeSkillInfo.link ~= nil then
					--ex:  "|cffffd000|Henchant:3175|h[Alchemy: Limited Invulnerability Potion]|h|r",
					local TradeSkillName = select(4, strsplit("|", TradeSkillInfo.link))
					local skillName
					if profession == BI["Enchanting"] then				-- specific parsing for enchanting
						skillName = string.sub(TradeSkillName, 3, -2)
					else
						skillName = select(2, strsplit(":", TradeSkillName))
						skillName = string.sub(skillName, 2, -2)
					end
					if skillName == craftName then
						isKnownByChar = true
						break
					end
				end
			end	-- known skills loop
			
			local msg
			if isKnownByChar then
				msg = TEAL .. L["Already known by "] .. WHITE .. CharacterName .. "\n"
			else
				local curRank
				if (profession == BI["Cooking"]) or 
					(profession == BI["First Aid"]) or
					(profession == BI["Fishing"]) then
					curRank = self:GetSkillInfo( c.skill[L["Secondary Skills"]][profession] )
				else
					curRank = self:GetSkillInfo( c.skill[L["Professions"]][profession] )
				end
				if curRank < recipeLevel then 
					msg = RED .. L["Will be learnable by "] .. WHITE .. CharacterName .. YELLOW .. " ("..curRank..")" .. "\n"
				else
					msg = YELLOW .. L["Could be learned by "] .. WHITE .. CharacterName .. "\n"
				end
			end
			
			if s == nil then
				s = msg
			else
				s = s .. msg
			end
		end
	end
	
	return s
end

-- *** EVENT HANDLERS ***
function Altoholic:PLAYER_ALIVE()
	local c = self.db.account.data[V.faction][V.realm].char[V.player]		-- this char

	c.level = UnitLevel("player")
	c.race = UnitRace("player")
	c.class = UnitClass("player")
	
	self:UpdatePlayerStats()
	self:UpdateTalents()
end

function Altoholic:AceEvent_FullyInitialized()
	self:UpdatePlayerBags()		-- manually update bags 0 to 4, then register the event
	self:RegisterEvent("BAG_UPDATE")
	self:RegisterEvent("UNIT_INVENTORY_CHANGED")
	self:RegisterEvent("UNIT_QUEST_LOG_CHANGED")
	
	self:RegisterEvent("TRADE_SKILL_SHOW")
	self:RegisterEvent("TRADE_SKILL_CLOSE")
	self:RegisterEvent("CRAFT_SHOW")
	self:RegisterEvent("CRAFT_CLOSE")
	
	if AltoholicFu then	-- if fubar plugin is found, but not active (the addon's icon will be attached to the minimap .. then hide it)
		if AltoholicFu:IsMinimapAttached() then
			_G[ "FuBarPluginAltoholicFrameMinimapButton" ]:Hide()
		end		
	end
	
	local currentGuild = GetGuildInfo("player")
	if currentGuild then
		UIDropDownMenu_SetSelectedValue(AltoholicTabGuildBank_SelectGuild, 
				V.faction .."|" .. V.realm .."|".. currentGuild )
		UIDropDownMenu_SetText(GREEN .. currentGuild .. WHITE .. " (" .. V.realm .. ")",
				AltoholicTabGuildBank_SelectGuild)

		for i = 1, 6 do
			local t = Altoholic.db.account.data[V.faction][V.realm].guild[currentGuild].bank["Tab"..i]
			if t.tabID then
				_G[ "AltoholicTabGuildBankMenuItem" .. i ]:SetText(WHITE .. t.name)
				_G[ "AltoholicTabGuildBankMenuItem" .. i ]:Show()
			else
				_G[ "AltoholicTabGuildBankMenuItem" .. i ]:Hide()
			end
		end
	end
	
	self:BuildUnsafeItemList()
	
	Altoholic:UpdateContainerCache()		-- prepare the containers frame for the first time it will be displayed
	AltoholicFrameContainers:Show()
	Altoholic.Containers_Update = Altoholic.ContainersSpread_Update
	Altoholic:Containers_Update();

	
	-- LinkWrangler supoprt
   if LinkWrangler then
       LinkWrangler.RegisterCallback ("Altoholic",  Hook_LinkWranger, "refresh")
   end
end

function Altoholic:PLAYER_LEVEL_UP(newLevel)
	self.db.account.data[V.faction][V.realm].char[V.player].level = newLevel
end

function Altoholic:PLAYER_XP_UPDATE()
	local c = self.db.account.data[V.faction][V.realm].char[V.player]		-- this char
	c.xp = UnitXP("player")
	c.xpmax = UnitXPMax("player")
	c.restxp = GetXPExhaustion()
end

function Altoholic:PLAYER_MONEY()
	self.db.account.data[V.faction][V.realm].char[V.player].money = GetMoney();
end

function Altoholic:PLAYER_UPDATE_RESTING()
	self.db.account.data[V.faction][V.realm].char[V.player].isResting = IsResting();
end

function Altoholic:PLAYER_GUILD_UPDATE()
	V.guild = GetGuildInfo("player")	
end

function Altoholic:ZONE_CHANGED()
	self:UpdatePlayerLocation()
end

function Altoholic:ZONE_CHANGED_NEW_AREA()
	self:UpdatePlayerLocation()
end

function Altoholic:ZONE_CHANGED_INDOORS()
	self:UpdatePlayerLocation()
end

function Altoholic:UpdatePlayerLocation()
	local c = self.db.account.data[V.faction][V.realm].char[V.player]	-- current char
	c.zone = GetRealZoneText()
	c.subzone = GetSubZoneText()
end

function Altoholic:PLAYER_LOGOUT()
	self.db.account.data[V.faction][V.realm].char[V.player].lastlogout = time()
end

function Altoholic:TIME_PLAYED_MSG(TotalTime, CurrentLevelTime)
	self.db.account.data[V.faction][V.realm].char[V.player].played = TotalTime
end

function Altoholic:UNIT_INVENTORY_CHANGED()
	self:UpdateEquipment()
end

function Altoholic:BAG_UPDATE(bag)
	V.ToolTipCachedItemID = nil		-- putting this at NIL will force a tooltip refresh in self:ProcessToolTip
	if (bag >= 5) and (bag <= 11) and not V.isBankOpen then
		return
	end
	
	if V.isMailBoxOpen then			-- if a bag is updated while the mailbox is opened, this means an attachment has been taken.
		self:UpdatePlayerMail()		-- I could not hook TakeInboxItem because mailbox content is not updated yet
	end
	self:UpdatePlayerBag(bag)
end

function Altoholic:BANKFRAME_OPENED()
	self:UpdatePlayerBank()
	V.isBankOpen = true
	self:RegisterEvent("PLAYERBANKSLOTS_CHANGED")
end
	
function Altoholic:BANKFRAME_CLOSED()
	V.isBankOpen = nil
	if self:IsEventRegistered("PLAYERBANKSLOTS_CHANGED") then
		self:UnregisterEvent("PLAYERBANKSLOTS_CHANGED")
	end
end

function Altoholic:PLAYERBANKSLOTS_CHANGED()
	self:UpdatePlayerBank(false)		-- false = don't scan bags, only the 28 main slots
end
