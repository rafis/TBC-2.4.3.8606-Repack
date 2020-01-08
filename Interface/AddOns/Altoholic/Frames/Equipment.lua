local BI = LibStub("LibBabble-Inventory-3.0"):GetLookupTable()
local L = AceLibrary("AceLocale-2.2"):new("Altoholic")
local V = Altoholic.vars

local WHITE		= "|cFFFFFFFF"
local GREEN		= "|cFF00FF00"
local ORANGE	= "|cFFFF7F00"

-- Class constants, for readability, these values match the ones in Altoholic.Classes (altoholic.lua)
local CLASS_MAGE		= 1
local CLASS_WARRIOR	= 2
local CLASS_HUNTER	= 3
local CLASS_ROGUE		= 4
local CLASS_WARLOCK	= 5
local CLASS_DRUID		= 6
local CLASS_SHAMAN	= 7
local CLASS_PALADIN	= 8
local CLASS_PRIEST	= 9

local Equipment = {
	{ color = "|cFF69CCF0", name = BI["Head"], icon = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Head"},
	{ color = "|cFFABD473", name = BI["Neck"], icon = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Neck"},
	{ color = "|cFF69CCF0", name = BI["Shoulder"], icon = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Shoulder"},
	{ color = WHITE, name = BI["Shirt"], icon = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Shirt"},
	{ color = "|cFF69CCF0", name = BI["Chest"], icon = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Chest"},
	{ color = "|cFF69CCF0", name = BI["Waist"], icon = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Waist"},
	{ color = "|cFF69CCF0", name = BI["Legs"], icon = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Legs"},
	{ color = "|cFF69CCF0", name = BI["Feet"], icon = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Feet"},
	{ color = "|cFF69CCF0", name = BI["Wrist"], icon = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Wrists"},
	{ color = "|cFF69CCF0", name = BI["Hands"], icon = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Hands"},
	{ color = ORANGE, name = BI["Ring"] .. " 1", icon = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Finger"},
	{ color = ORANGE, name = BI["Ring"] .. " 2", icon = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Finger"},
	{ color = ORANGE, name = BI["Trinket"] .. " 1", icon = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Trinket"},
	{ color = ORANGE, name = BI["Trinket"] .. " 2", icon = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Trinket"},
	{ color = "|cFFABD473", name = BI["Back"], icon = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Chest"},
	{ color = "|cFFFFFF00", name = BI["Main Hand"], icon = "Interface\\PaperDoll\\UI-PaperDoll-Slot-MainHand"},
	{ color = "|cFFFFFF00", name = BI["Off Hand"], icon = "Interface\\PaperDoll\\UI-PaperDoll-Slot-SecondaryHand"},
	{ color = "|cFFABD473", name = L["Ranged"], icon = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Ranged"},
	{ color = WHITE, name = BI["Tabard"], icon = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Tabard"}
}

function Altoholic:Equipment_Update()
	local VisibleLines = 7
	local frame = "AltoholicFrameEquipment"
	local entry = frame.."Entry"
	
	AltoholicTabCharactersStatus:SetText("")
	
	local offset = FauxScrollFrame_GetOffset( _G[ frame.."ScrollFrame" ] );
	for i=1, VisibleLines do
		local line = i + offset

		_G[ entry..i.."Name" ]:SetText(Equipment[line].color .. Equipment[line].name)

		local j = 1
		for CharacterName, c in pairs(self.db.account.data[V.CurrentFaction][V.CurrentRealm].char) do
			local itemName = entry.. i .. "Item" .. j;
			local itemButton = _G[itemName];
			itemButton:SetScript("OnEnter", Altoholic_Equipment_OnEnter)
			itemButton:SetScript("OnClick", Altoholic_Equipment_OnClick)
			local itemTexture = _G[itemName .. "IconTexture"]
			
			local itemID = c.inventory[line]
			if itemID ~= nil then
				itemButton.CharName = CharacterName
				itemTexture:SetTexture(GetItemIcon(itemID));
			else
				itemButton.CharName = nil
				itemTexture:SetTexture(Equipment[line].icon);
			end
			itemTexture:SetWidth(36);
			itemTexture:SetHeight(36);
			itemTexture:SetAllPoints(itemButton);
			_G[ itemName ]:Show()
			j = j + 1
		end
		
		while j <= 10 do
			_G[ entry.. i .. "Item" .. j ]:Hide()
			j = j + 1
		end
		
		_G[ entry..i ]:Show()
		_G[ entry..i ]:SetID(line)
	end

	FauxScrollFrame_Update( _G[ frame.."ScrollFrame" ], 19, VisibleLines, 41);
end

function Altoholic_Equipment_OnEnter(self)
	if not self.CharName then return end
	
	local r = Altoholic.db.account.data[V.CurrentFaction][V.CurrentRealm]		-- this realm
	local itemID = self:GetParent():GetID()

	local item = r.char[self.CharName].inventory[itemID]	--  equipment slot
	if not item then return end

	GameTooltip:SetOwner(this, "ANCHOR_LEFT");
	local link
	if type(item) == "number" then
		link = select(2, GetItemInfo(item))
	else
		link = item
	end
	
	if not link then
		GameTooltip:AddLine(L["Unknown link, please relog this character"],1,1,1);
		GameTooltip:Show();
		return
	end
	
	GameTooltip:SetHyperlink(link);
	GameTooltip:AddLine(" ");
	GameTooltip:AddLine(GREEN .. L["Right-Click to find an upgrade"]);
	GameTooltip:Show();
end

function Altoholic_Equipment_OnClick(self, button)
	if not self.CharName then return end
	
	local r = Altoholic.db.account.data[V.CurrentFaction][V.CurrentRealm]		-- this realm
	local itemID = self:GetParent():GetID()

	if itemID == 0 then return end		-- class icon
	
	local item = r.char[self.CharName].inventory[itemID]	--  equipment slot
	if not item then return end
	
	local link
	if type(item) == "number" then
		link = select(2, GetItemInfo(item))
	else
		link = item
	end
	
	if not link then return end
	
	if button == "RightButton" then
		V.UpgradeItemID = Altoholic:GetIDFromLink(link)		-- item ID of the item to find an upgrade for
		V.CharacterClass = Altoholic.Classes[ r.char[self.CharName].class ]
		ToggleDropDownMenu(1, nil, AltoholicFrameEquipmentRightClickMenu, self:GetName(), 0, -5);
		return
	end
	
	if ( button == "LeftButton" ) and ( IsControlKeyDown() ) then
		DressUpItemLink(link);
	elseif ( button == "LeftButton" ) and ( IsShiftKeyDown() ) then
		if ( ChatFrameEditBox:IsShown() ) then
			ChatFrameEditBox:Insert(link);
		else
			AltoholicFrame_SearchEditBox:SetText(GetItemInfo(link))
		end
	end
end

function Equipment_RightClickMenu_OnLoad()
	local info = UIDropDownMenu_CreateInfo(); 

	info.text		= L["Find Upgrade"] .. " " .. GREEN .. L["(based on iLvl)"]
	info.value		= -1
	info.func		= Altoholic_FindEquipmentUpgrade;
	UIDropDownMenu_AddButton(info, 1); 

	-- Tank upgrade
	if (V.CharacterClass == CLASS_WARRIOR) or
		(V.CharacterClass == CLASS_DRUID) or
		(V.CharacterClass == CLASS_PALADIN) then
		
		info.text		= L["Find Upgrade"] .. " " .. GREEN .. "(".. L["Tank"] .. ")"
		info.value		= V.CharacterClass .. "Tank"
		info.func		= Altoholic_FindEquipmentUpgrade;
		UIDropDownMenu_AddButton(info, 1); 	
	end
	
	-- DPS upgrade
	if V.CharacterClass then
		info.text		= L["Find Upgrade"] .. " " .. GREEN .. "(".. L["DPS"] .. ")"
		info.value		= V.CharacterClass .. "DPS"
		info.func		= Altoholic_FindEquipmentUpgrade;
		UIDropDownMenu_AddButton(info, 1); 
	end
		
	if V.CharacterClass == CLASS_DRUID then
		info.text		= L["Find Upgrade"] .. " " .. GREEN .. "(".. L["Balance"] .. ")"
		info.value		= V.CharacterClass .. "Balance"
		info.func		= Altoholic_FindEquipmentUpgrade;
		UIDropDownMenu_AddButton(info, 1); 
	elseif V.CharacterClass == CLASS_SHAMAN then
		info.text		= L["Find Upgrade"] .. " " .. GREEN .. "(".. L["Elemental Shaman"] .. ")"
		info.value		= V.CharacterClass .. "Elemental"
		info.func		= Altoholic_FindEquipmentUpgrade;
		UIDropDownMenu_AddButton(info, 1); 
	end
		
	-- Heal upgrade
	if (V.CharacterClass == CLASS_PRIEST) or
		(V.CharacterClass == CLASS_SHAMAN) or
		(V.CharacterClass == CLASS_DRUID) or
		(V.CharacterClass == CLASS_PALADIN) then
		
		info.text		= L["Find Upgrade"] .. " " .. GREEN .. "(".. L["Heal"] .. ")"
		info.value		= V.CharacterClass .. "Heal"
		info.func		= Altoholic_FindEquipmentUpgrade;
		UIDropDownMenu_AddButton(info, 1); 
	end
end

function Altoholic_FindEquipmentUpgrade(self)
	
	-- debugprofilestart()
	
	local _, itemLink, _, itemLevel, _, itemType, itemSubType, _, itemEquipLoc = GetItemInfo(V.UpgradeItemID)
	V.Search_iLvl = itemLevel				-- set search parameters
	V.SearchType = itemType
	V.SearchSubType = itemSubType
	V.SearchEquipLoc = Altoholic.InvSlots[itemEquipLoc]
	
	Altoholic:ClearTable(Altoholic.SearchResults)
	V.SearchLoots = true
	
	local VerifyFunc
	if this.value ~= -1 then
		V.CharacterClass = this.value
		VerifyFunc = Altoholic.VerifyUpgradeByStats
		
		AltoTooltip:SetOwner(this, "ANCHOR_LEFT");	-- set the owner only once before the sethyperlink's in the verification method
		
		
		V.RawItemStats = {}	-- contains the raw stats of the item currently being searched, placed here to avoid creating/deleting the table during the search
		
		
		-- Get current item stats
		V.SearchItemStats = {}	-- contains the stats of the item for which we'll try to find upgrades
		V.TooltipLines = {}	-- cache containing the text lines of the tooltip "+15 stamina, etc.."
		local statLine = Altoholic.FormatStats[V.CharacterClass]
		AltoTooltip:SetHyperlink(itemLink)
		
		local j=1
		for _, BaseStat in pairs(Altoholic.BaseStats[V.CharacterClass]) do
			for i = 4, AltoTooltip:NumLines() do
				local tooltipText = _G[ "AltoTooltipTextLeft" .. i]:GetText()
				if tooltipText then
					if string.find(tooltipText, BaseStat) ~= nil then
						V.SearchItemStats[BaseStat] = tonumber(string.sub(tooltipText, string.find(tooltipText, "%d+")))
						statLine = string.gsub(statLine, "-s", WHITE .. V.SearchItemStats[BaseStat], 1)
						
						V.RawItemStats[j] = V.SearchItemStats[BaseStat] .. "|0"
						break
					end
				end
			end
			if not V.SearchItemStats[BaseStat] then
				V.RawItemStats[j] = "0|0"
			
				V.SearchItemStats[BaseStat] = 0 -- Set the current stat to zero if it was not found on the item
				statLine = string.gsub(statLine, "-s", WHITE .. "0", 1)
			end
			j = j + 1
		end
		AltoTooltip:ClearLines();
		
		-- Save currently equipped item to the results table
		table.insert(Altoholic.SearchResults, {
			id = V.UpgradeItemID,
			iLvl = itemLevel,
			bossName = statLine,
			dropLocation = "Currently equipped",
			stat1 = V.RawItemStats[1],
			stat2 = V.RawItemStats[2],
			stat3 = V.RawItemStats[3],
			stat4 = V.RawItemStats[4],
			stat5 = V.RawItemStats[5],
			stat6 = V.RawItemStats[6]
		} )
	else	-- simple search, point to simple VerifyUpgrade method
		VerifyFunc = Altoholic.VerifyUpgrade
	end

	V.UpgradeItemID = nil
	
	for Instance, BossList in pairs(Altoholic.LootTable) do		-- parse the loot table to find an upgrade
		for Boss, LootList in pairs(BossList) do
			for itemID, _ in pairs(LootList) do
				V.SearchInstance = Instance
				V.SearchBoss = Boss
				V.SearchLootItemID = LootList[itemID]
				VerifyFunc()
			end
		end
	end
	AltoTooltip:Hide();	-- mandatory hide after processing	
	
	V.Search_iLvl = nil				-- release memory
	V.SearchType = nil
	V.SearchSubType = nil
	V.SearchEquipLoc = nil
--	V.CharacterClass = nil			-- do not nil this one, required to setup the column headers
	V.SearchInstance = nil
	V.SearchBoss = nil
	V.SearchLootItemID = nil
	Altoholic:ClearTable(V.SearchItemStats)
	V.SearchItemStats = nil
	Altoholic:ClearTable(V.TooltipLines)
	V.TooltipLines = nil
	Altoholic:ClearTable(V.RawItemStats)
	V.RawItemStats = nil
	
	AltoholicTabSearch:SetMode("upgrade")
	
	if AltoholicTabOptionsFrame2_SortDescending:GetChecked() then 		-- descending sort ?
		AltoholicTabSearch_Sort8.ascendingSort = true		-- say it's ascending now, it will be toggled
		AltoholicTabSearch:SortSearch(AltoholicTabSearch_Sort8, "iLvl")
	else
		AltoholicTabSearch_Sort8.ascendingSort = nil
		AltoholicTabSearch:SortSearch(AltoholicTabSearch_Sort8, "iLvl")
	end
	
	if not AltoholicTabSearch:IsVisible() then
		Altoholic:Tab_OnClick(3)
	end
	
	Altoholic:Search_Update();
	-- DEFAULT_CHAT_FRAME:AddMessage(debugprofilestop())
end
