local BI = LibStub("LibBabble-Inventory-3.0"):GetLookupTable()
local L = AceLibrary("AceLocale-2.2"):new("Altoholic")
local V = Altoholic.vars

local WHITE		= "|cFFFFFFFF"
local GREEN		= "|cFF00FF00"
local RED		= "|cFFFF0000"

Altoholic.SearchMenu = {
	{ name = BI["Weapon"], isCollapsed = true },
		L["Any"],
		BI["One-Handed Axes"],
		BI["Two-Handed Axes"],
		BI["One-Handed Maces"],
		BI["Two-Handed Maces"],
		BI["One-Handed Swords"],
		BI["Two-Handed Swords"],
		BI["Bows"],
		BI["Guns"],
		BI["Crossbows"],
		BI["Staves"],
		BI["Wands"],
		BI["Polearms"],
		BI["Daggers"],
		BI["Fist Weapons"],
		BI["Thrown"],
		L["Miscellaneous"],
		L["Fishing Poles"],
	{ name = BI["Armor"], isCollapsed = true },
		L["Any"],
		L["Miscellaneous"],
		BI["Cloth"],
		BI["Leather"],
		BI["Mail"],
		BI["Plate"],
		BI["Shields"],
		BI["Librams"],
		BI["Idols"],
		BI["Totems"],
	{ name = BI["Consumable"], isCollapsed = true },
		L["Any"],
		BI["Food & Drink"],
		BI["Potion"],
		BI["Elixir"],
		BI["Flask"],
		BI["Bandage"],
		BI["Item Enhancement"],
		BI["Scroll"],
		BI["Other"],
	{ name = BI["Trade Goods"], isCollapsed = true },
		L["Any"],
		BI["Elemental"],
		BI["Cloth"],
		BI["Leather"],
		BI["Metal & Stone"],
		BI["Meat"],
		BI["Herb"],
		BI["Enchanting"],
		BI["Jewelcrafting"],
		BI["Parts"],
		BI["Devices"],
		BI["Explosives"],
		BI["Other"],
	{ name = BI["Gem"], isCollapsed = true },
		L["Any"],
		RED_GEM,
		BLUE_GEM,
		YELLOW_GEM,
		BI["Purple"],
		BI["Green"],
		BI["Orange"],
		META_GEM,
		BI["Simple"],
		BI["Prismatic"],
	{ name = BI["Recipe"], isCollapsed = true },
		L["Any"],
		BI["Alchemy"],
		BI["Blacksmithing"],
		BI["Enchanting"],
		BI["Engineering"],
		BI["Jewelcrafting"],
		BI["Leatherworking"],
		BI["Tailoring"],
		BI["Book"],
		BI["Cooking"],
		BI["First Aid"]
}

function Altoholic:SearchMenu_Update()
	local VisibleLines = 15

	local itemTypeIndex				-- index of the item type in the menu table
	local itemTypeCacheIndex		-- index of the item type in the cache table
	local SearchMenuCache = {}
	
	for k, v in pairs (self.SearchMenu) do		-- rebuild the cache
		if type(v) == "table" then		-- header
			itemTypeIndex = k
			table.insert(SearchMenuCache, { linetype=1, nameIndex=k } )
			itemTypeCacheIndex = #SearchMenuCache
		else
			if self.SearchMenu[itemTypeIndex].isCollapsed == false then
				table.insert(SearchMenuCache, { linetype=2, nameIndex=k, parentIndex=itemTypeIndex } )
				
				if (V.SearchMenuHighlight) and (V.SearchMenuHighlight == k) then
					SearchMenuCache[#SearchMenuCache].needsHighlight = true
					SearchMenuCache[itemTypeCacheIndex].needsHighlight = true
				end
			end
		end
	end
	
	local offset = FauxScrollFrame_GetOffset( _G[ "AltoholicSearchMenuScrollFrame" ] );
	local itemButtom = "AltoholicTabSearchMenuItem"
	for i=1, VisibleLines do
		local line = i + offset
		
		if line > #SearchMenuCache then
			_G[itemButtom..i]:Hide()
		else
			local p = SearchMenuCache[line]
			
			if p.needsHighlight then
				_G[itemButtom..i]:LockHighlight()
			else
				_G[itemButtom..i]:UnlockHighlight()
			end			
			
			if p.linetype == 1 then
				_G[itemButtom..i.."NormalText"]:SetText(WHITE .. self.SearchMenu[p.nameIndex].name)
				_G[itemButtom..i]:SetScript("OnClick", Altoholic_SearchMenuHeader_OnClick)
				_G[itemButtom..i].itemTypeIndex = p.nameIndex
			elseif p.linetype == 2 then
				_G[itemButtom..i.."NormalText"]:SetText("|cFFBBFFBB   " .. self.SearchMenu[p.nameIndex])
				_G[itemButtom..i]:SetScript("OnClick", Altoholic_SearchMenuItem_OnClick)
				_G[itemButtom..i].itemTypeIndex = p.parentIndex
				_G[itemButtom..i].itemSubTypeIndex = p.nameIndex
			end

			_G[itemButtom..i]:Show()
		end
	end
	
	FauxScrollFrame_Update( _G[ "AltoholicSearchMenuScrollFrame" ], #SearchMenuCache, VisibleLines, 20);
	self:ClearTable(SearchMenuCache)
	SearchMenuCache = nil	-- most likely useless since its local, but let's be safe.
end

function Altoholic_SearchMenuHeader_OnClick()
	local h = Altoholic.SearchMenu[this.itemTypeIndex]
	
	if h.isCollapsed == true then
		h.isCollapsed = false
	else
		h.isCollapsed = true
	end
	Altoholic:SearchMenu_Update()
end

function Altoholic_SearchMenuItem_OnClick()
	V.SearchMenuHighlight = this.itemSubTypeIndex

	Altoholic:SearchMenu_Update()
	
	if Altoholic.SearchMenu[this.itemSubTypeIndex] == L["Any"] then
		Altoholic:SearchItem(Altoholic.SearchMenu[this.itemTypeIndex].name)
	else
		Altoholic:SearchItem(Altoholic.SearchMenu[this.itemTypeIndex].name, Altoholic.SearchMenu[this.itemSubTypeIndex])
	end
end

function AltoholicTabSearch:DropDownRarity_Initialize() 
	local info = UIDropDownMenu_CreateInfo(); 

	V.SearchRarity = 0
	
	for i = 0, 5 do		-- Quality: 0 = poor .. 5 = legendary
		info.text = ITEM_QUALITY_COLORS[i].hex .. _G["ITEM_QUALITY"..i.."_DESC"]
		info.value = i
		info.func = function(self)	
			UIDropDownMenu_SetSelectedValue(this.owner, this.value);
			V.SearchRarity = this.value		
		end
		info.owner = this:GetParent(); 
		info.checked = nil; 
		info.icon = nil; 
		UIDropDownMenu_AddButton(info, 1); 
	end
end 

function AltoholicTabSearch:DropDownSlot_Initialize() 
	local info = UIDropDownMenu_CreateInfo(); 

	V.SearchSlot = 0
	info.text = L["Any"]
	info.value = 0
	info.func = function(self)	
		UIDropDownMenu_SetSelectedValue(this.owner, this.value);
		V.SearchSlot = this.value		
	end
	info.owner = this:GetParent(); 
	info.checked = nil; 
	info.icon = nil; 
	UIDropDownMenu_AddButton(info, 1); 	
	for i = 1, 18 do
		info.text = Altoholic.EquipmentSlots[i]
		info.value = i
		info.func = function(self)	
			UIDropDownMenu_SetSelectedValue(this.owner, this.value);
			V.SearchSlot = this.value		
		end
		info.owner = this:GetParent(); 
		info.checked = nil; 
		info.icon = nil; 
		UIDropDownMenu_AddButton(info, 1); 
	end
end 

local SEARCH_THISREALM = 1
local SEARCH_ALLREALMS = 2
local SEARCH_LOOTS = 3

function AltoholicTabSearch:DropDownLocation_Initialize() 
	local info = UIDropDownMenu_CreateInfo();
	
	info.text = L["This realm"]
	info.value = SEARCH_THISREALM
	info.func = AltoholicTabSearch.SetSearchLocation
	info.owner = this:GetParent(); 
	info.checked = nil; 
	info.icon = nil; 
	UIDropDownMenu_AddButton(info, 1); 	
	
	info.text = L["All realms"]
	info.value = SEARCH_ALLREALMS
	info.func = AltoholicTabSearch.SetSearchLocation
	info.owner = this:GetParent(); 
	info.checked = nil; 
	info.icon = nil; 
	UIDropDownMenu_AddButton(info, 1); 	

	info.text = L["Loot tables"]
	info.value = SEARCH_LOOTS
	info.func = AltoholicTabSearch.SetSearchLocation
	info.owner = this:GetParent(); 
	info.checked = nil; 
	info.icon = nil; 
	UIDropDownMenu_AddButton(info, 1); 	
end

function AltoholicTabSearch:SetSearchLocation()
	UIDropDownMenu_SetSelectedValue(this.owner, this.value);
end

function AltoholicTabSearch:SetMode(mode)

	for i = 1, 8 do 
		_G[ "AltoholicTabSearch_Sort" .. i .. "Arrow"]:Hide()
		_G[ "AltoholicTabSearch_Sort"..i ].ascendingSort = nil	-- not sorted by default
	end

	-- sets the search mode, and prepares the frame accordingly (search update callback, column sizes, headers, etc..)
	if mode == "realm" then
		Altoholic.Search_Update = Altoholic.SearchRealm_Update
		
		AltoholicTabSearch_Sort1:SetText(XML_ALTO_SEARCH_COL1)
		AltoholicTabSearch_Sort1:SetScript("OnClick", function(self) 
			AltoholicTabSearch:SortSearch(self, "item") 
		end)
		AltoholicTabSearch_Sort1:SetWidth(240)
		
		AltoholicTabSearch_Sort2:SetText(XML_ALTO_CHAR_DD2)
		AltoholicTabSearch_Sort2:SetScript("OnClick", function(self) 
			AltoholicTabSearch:SortSearch(self, "char") 
		end)
		AltoholicTabSearch_Sort2:SetWidth(160)
		AltoholicTabSearch_Sort2:SetPoint("LEFT", AltoholicTabSearch_Sort1, "RIGHT", 5, 0)
		
		AltoholicTabSearch_Sort3:SetText(XML_ALTO_CHAR_DD1)
		AltoholicTabSearch_Sort3:SetScript("OnClick", function(self) 
			AltoholicTabSearch:SortSearch(self, "realm") 
		end)
		AltoholicTabSearch_Sort3:SetWidth(150)
		AltoholicTabSearch_Sort3:SetPoint("LEFT", AltoholicTabSearch_Sort2, "RIGHT", 5, 0)
		
		for i = 4, 8 do
			_G["AltoholicTabSearch_Sort"..i]:Hide()
		end
		
		for i=1, 7 do
			_G[ "AltoholicFrameSearchEntry"..i.."Name" ]:SetWidth(240)
			_G[ "AltoholicFrameSearchEntry"..i.."Stat1" ]:SetWidth(160)
			_G[ "AltoholicFrameSearchEntry"..i.."Stat1" ]:SetPoint("LEFT", _G[ "AltoholicFrameSearchEntry"..i.."Name" ], "RIGHT", 5, 0)
			_G[ "AltoholicFrameSearchEntry"..i.."Stat2" ]:SetWidth(150)
			_G[ "AltoholicFrameSearchEntry"..i.."Stat2" ]:SetPoint("LEFT", _G[ "AltoholicFrameSearchEntry"..i.."Stat1" ], "RIGHT", 5, 0)
			
			for j=3, 6 do
				_G[ "AltoholicFrameSearchEntry"..i.."Stat"..j ]:Hide()
			end
			_G[ "AltoholicFrameSearchEntry"..i.."ILvl" ]:Hide()
			
			_G[ "AltoholicFrameSearchEntry"..i ]:SetScript("OnEnter", nil)
			_G[ "AltoholicFrameSearchEntry"..i ]:SetScript("OnLeave", nil)
		end
				
	elseif mode == "loots" then
		Altoholic.Search_Update = Altoholic.SearchLoots_Update
		
		AltoholicTabSearch_Sort1:SetText(XML_ALTO_SEARCH_COL1)
		AltoholicTabSearch_Sort1:SetScript("OnClick", function(self) 
			AltoholicTabSearch:SortSearch(self, "item") 
		end)
		AltoholicTabSearch_Sort1:SetWidth(240)
		
		AltoholicTabSearch_Sort2:SetText(L["Source"])
		AltoholicTabSearch_Sort2:SetScript("OnClick", function(self) 
			AltoholicTabSearch:SortSearch(self, "bossName") 
		end)
		AltoholicTabSearch_Sort2:SetWidth(160)
		AltoholicTabSearch_Sort2:SetPoint("LEFT", AltoholicTabSearch_Sort1, "RIGHT", 5, 0)
		
		AltoholicTabSearch_Sort3:SetText(L["Item Level"])
		AltoholicTabSearch_Sort3:SetScript("OnClick", function(self) 
			AltoholicTabSearch:SortSearch(self, "iLvl") 
		end)
		AltoholicTabSearch_Sort3:SetWidth(150)
		AltoholicTabSearch_Sort3:SetPoint("LEFT", AltoholicTabSearch_Sort2, "RIGHT", 5, 0)
		
		for i = 4, 8 do
			_G["AltoholicTabSearch_Sort"..i]:Hide()
		end
		
		for i=1, 7 do
			_G[ "AltoholicFrameSearchEntry"..i.."Name" ]:SetWidth(240)
			_G[ "AltoholicFrameSearchEntry"..i.."Stat1" ]:SetWidth(160)
			_G[ "AltoholicFrameSearchEntry"..i.."Stat1" ]:SetPoint("LEFT", _G[ "AltoholicFrameSearchEntry"..i.."Name" ], "RIGHT", 5, 0)
			_G[ "AltoholicFrameSearchEntry"..i.."Stat2" ]:SetWidth(150)
			_G[ "AltoholicFrameSearchEntry"..i.."Stat2" ]:SetPoint("LEFT", _G[ "AltoholicFrameSearchEntry"..i.."Stat1" ], "RIGHT", 5, 0)
			
			for j=3, 6 do
				_G[ "AltoholicFrameSearchEntry"..i.."Stat"..j ]:Hide()
			end
			_G[ "AltoholicFrameSearchEntry"..i.."ILvl" ]:Hide()
			
			_G[ "AltoholicFrameSearchEntry"..i ]:SetScript("OnEnter", nil)
			_G[ "AltoholicFrameSearchEntry"..i ]:SetScript("OnLeave", nil)
		end
		
	elseif mode == "upgrade" then
		Altoholic.Search_Update = Altoholic.SearchUpgrade_Update
		
		AltoholicTabSearch_Sort1:SetText(XML_ALTO_SEARCH_COL1)
		AltoholicTabSearch_Sort1:SetScript("OnClick", function(self) 
			AltoholicTabSearch:SortSearch(self, "item") 
		end)
		AltoholicTabSearch_Sort1:SetWidth(200)
		
		AltoholicTabSearch_Sort2:SetWidth(50)
		AltoholicTabSearch_Sort2:SetPoint("LEFT", AltoholicTabSearch_Sort1, "RIGHT", 0, 0)
		
		AltoholicTabSearch_Sort3:SetWidth(50)
		AltoholicTabSearch_Sort3:SetPoint("LEFT", AltoholicTabSearch_Sort2, "RIGHT", 0, 0)
		
		for i=1, 6 do 
			local button = _G[ "AltoholicTabSearch_Sort"..(i+1) ]
			local text = select(i, strsplit("|", Altoholic.FormatStats[V.CharacterClass]))
			if text then
				button:SetText(string.sub(text, 1, 3))
				button:Show()
				button:SetScript("OnClick", function(self) 
					AltoholicTabSearch:SortSearch(self, "stat") -- use a getID to know which stat
				end)
			else
				button:Hide()
			end
		end
		AltoholicTabSearch_Sort8:SetText("iLvl")
		AltoholicTabSearch_Sort8:Show()
		AltoholicTabSearch_Sort8:SetScript("OnClick", function(self) 
			AltoholicTabSearch:SortSearch(self, "iLvl") 
		end)
		
		for i=1, 7 do
			_G[ "AltoholicFrameSearchEntry"..i.."Name" ]:SetWidth(190)
			_G[ "AltoholicFrameSearchEntry"..i.."Stat1" ]:SetWidth(50)
			_G[ "AltoholicFrameSearchEntry"..i.."Stat1" ]:SetPoint("LEFT", _G[ "AltoholicFrameSearchEntry"..i.."Name" ], "RIGHT", 0, 0)
			_G[ "AltoholicFrameSearchEntry"..i.."Stat2" ]:SetWidth(50)
			_G[ "AltoholicFrameSearchEntry"..i.."Stat2" ]:SetPoint("LEFT", _G[ "AltoholicFrameSearchEntry"..i.."Stat1" ], "RIGHT", 0, 0)
			
			_G[ "AltoholicFrameSearchEntry"..i ]:SetScript("OnEnter", function(self) 
				AltoholicTabSearch:TooltipStats(self) 
			end)
			_G[ "AltoholicFrameSearchEntry"..i ]:SetScript("OnLeave", function(self) 
				AltoTooltip:Hide()
			end)
		end
	end
	
	AltoholicTabSearch_Sort1:Show()
	AltoholicTabSearch_Sort2:Show()
	AltoholicTabSearch_Sort3:Show()
end

function AltoholicTabSearch:TooltipStats(self)
	AltoTooltip:ClearLines();
	AltoTooltip:SetOwner(self, "ANCHOR_RIGHT");
	
	AltoTooltip:AddLine(STATS_LABEL)
	AltoTooltip:AddLine(" ");
	
	local s = Altoholic.SearchResults[self:GetID()]
	for i=1, 6 do
		local text = select(i, strsplit("|", Altoholic.FormatStats[V.CharacterClass]))
		if text then 
			local diff = select(2, strsplit("|", s["stat"..i]))
			diff = tonumber(diff)

			if diff < 0 then
				AltoTooltip:AddLine(RED .. diff .. " " .. text)
			elseif diff > 0 then 
				AltoTooltip:AddLine(GREEN .. "+" .. diff .. " " .. text)
			else
				AltoTooltip:AddLine(WHITE .. diff .. " " .. text)
			end
		end
	end
	AltoTooltip:Show()
end

function AltoholicTabSearch:SortSearch(self, field)
	
	if #Altoholic.SearchResults == 0 then return end
	
	for i = 1, 8 do
		_G[ "AltoholicTabSearch_Sort" .. i .. "Arrow"]:Hide()
	end
	
	local button = _G[ "AltoholicTabSearch_Sort" .. self:GetID() .. "Arrow"]
	button:Show()
	
	if not self.ascendingSort then
		self.ascendingSort = true
		button:SetTexCoord(0, 0.5625, 0, 1.0);		-- arrow pointing down
	else
		self.ascendingSort = nil
		button:SetTexCoord(0, 0.5625, 1.0, 0);		-- arrow pointing up
	end
		
	if field == "item" then
		table.sort(Altoholic.SearchResults, function(a, b)
				return AltoholicTabSearch:SortByItemName(a, b, self.ascendingSort)
			end)
	elseif field == "char" then
		table.sort(Altoholic.SearchResults, function(a, b)
				return AltoholicTabSearch:SortByChar(a, b, self.ascendingSort)
			end)
	elseif field == "realm" then
		table.sort(Altoholic.SearchResults, function(a, b)
				return AltoholicTabSearch:SortByRealm(a, b, self.ascendingSort)
			end)
	elseif field == "stat" then
		table.sort(Altoholic.SearchResults, function(a, b)
				return AltoholicTabSearch:SortByStat(a, b, "stat" .. self:GetID()-1, self.ascendingSort)
			end)
	else
		table.sort(Altoholic.SearchResults, function(a, b)
				return AltoholicTabSearch:SortByField(a, b, field, self.ascendingSort)
			end)
		
	end
	
	Altoholic:Search_Update();
end

function AltoholicTabSearch:SortByItemName(a, b, ascending)
	local nameA = GetItemInfo(a.id)
	local nameB = GetItemInfo(b.id)
	
	if ascending then
		return nameA < nameB
	else
		return nameA > nameB
	end
end

function AltoholicTabSearch:SortByChar(a, b, ascending)
	local nameA, nameB
	
	if type(a.char) == "number" then
		nameA = Altoholic.CharacterInfo[a.char].name	-- a character
	else
		nameA = select(3, strsplit("|", a.char))		-- a guild
	end
	
	if type(b.char) == "number" then
		nameB = Altoholic.CharacterInfo[b.char].name
	else
		nameB = select(3, strsplit("|", b.char))
	end

	if nameA == nameB then								-- if it's the same character name ..
		return AltoholicTabSearch:SortByItemName(a, b, ascending)	-- .. then sort by item name
	elseif ascending then
		return nameA < nameB
	else
		return nameA > nameB
	end
end

function AltoholicTabSearch:SortByRealm(a, b, ascending)
	local nameA, nameB
	
	if type(a.char) == "number" then
		nameA = select(2, Altoholic:GetCharacterInfo(a.char))	-- a character
	else
		nameA = select(2, strsplit("|", a.char))		-- a guild
	end
	
	if type(b.char) == "number" then
		nameB = select(2, Altoholic:GetCharacterInfo(b.char))
	else
		nameB = select(2, strsplit("|", b.char))
	end
	
	if nameA == nameB then								-- if it's the same realm ..
		return AltoholicTabSearch:SortByChar(a, b, ascending)	-- .. then sort by character name
	elseif ascending then
		return nameA < nameB
	else
		return nameA > nameB
	end
end

function AltoholicTabSearch:SortByStat(a, b, field, ascending)
	local statA = strsplit("|", a[field])
	local statB = strsplit("|", b[field])
	
	statA = tonumber(statA)
	statB = tonumber(statB)
	
	if ascending then
		return statA < statB
	else
		return statA > statB
	end
end

function AltoholicTabSearch:SortByField(a, b, field, ascending)
	if ascending then
		return a[field] < b[field]
	else
		return a[field] > b[field]
	end
end
