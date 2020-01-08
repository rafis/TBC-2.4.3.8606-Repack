local L = AceLibrary("AceLocale-2.2"):new("Altoholic")
local V = Altoholic.vars

local LEVEL_CAP = 70
local WHITE		= "|cFFFFFFFF"
local GREEN		= "|cFF00FF00"
local RED		= "|cFFFF0000"
local TEAL		= "|cFF00FF9A"
local YELLOW	= "|cFFFFFF00"

function Altoholic:SearchRealm_Update()
	local VisibleLines = 7
	local frame = "AltoholicFrameSearch"
	local entry = frame.."Entry"
	
	if #self.SearchResults == 0 then
		self:ClearScrollFrame( _G[ frame.."ScrollFrame" ], entry, VisibleLines, 41)
		return
	end

	local offset = FauxScrollFrame_GetOffset( _G[ frame.."ScrollFrame" ] );
	
	for i=1, VisibleLines do
		local line = i + offset
		local s = self.SearchResults[line]
		if s ~= nil then
			local faction, realm, guildName
			local charName
			if type(s.char) == "number" then
				faction, realm = self:GetCharacterInfo(s.char)
				charName = Altoholic.CharacterInfo[s.char].name
				local c = Altoholic.db.account.data[faction][realm].char[charName]
				_G[ entry..i.."Stat1" ]:SetText(Altoholic:GetClassColor(c.class) .. charName)
			else
				faction, realm, guildName = strsplit("|", s.char)
				_G[ entry..i.."Stat1" ]:SetText(GREEN .. guildName)
			end
				
			local itemID = s.id
			local itemName, itemRarity, itemIcon, hex
			if not itemID then		-- nil item ID only in the case of enchanting recipes. Adjust later if necessary.
				hex = WHITE
				_G[ entry..i.."ItemIconTexture" ]:SetTexture("Interface\\Icons\\Trade_Engraving");
			else
				itemName, _, itemRarity, _, _, _, _, _, _, itemIcon = GetItemInfo(itemID)
				_, _, _, hex = GetItemQualityColor(itemRarity)
				_G[ entry..i.."ItemIconTexture" ]:SetTexture(GetItemIcon(itemID));
			end

			_G[ entry..i.."Stat2" ]:SetText(self:GetRealmString(faction, realm))
			
			if s.craftName then
				_G[ entry..i.."Name" ]:SetText(hex .. s.craftName)
				_G[ entry..i.."SourceNormalText" ]:SetText(s.craftLink)
				_G[ entry..i.."Source" ]:SetID(line)
			else 
				_G[ entry..i.."Name" ]:SetText(hex .. itemName)
				_G[ entry..i.."Source" ]:SetText(TEAL .. s.location)
				_G[ entry..i.."Source" ]:SetID(0)
			end
			
			if (s.count ~= nil) and (s.count > 1) then
				_G[ entry..i.."ItemCount" ]:SetText(s.count)
				_G[ entry..i.."ItemCount" ]:Show()
			else
				_G[ entry..i.."ItemCount" ]:Hide()
			end

			_G[ entry..i.."Item" ]:SetID(line)
			_G[ entry..i ]:Show()
		else
			_G[ entry..i ]:Hide()
		end
	end

	if (offset+VisibleLines) <= #self.SearchResults then
		AltoholicTabSearchStatus:SetText(#self.SearchResults .. L[" results found (Showing "] .. (offset+1) .. "-" .. (offset+VisibleLines) .. ")")
	else
		AltoholicTabSearchStatus:SetText(#self.SearchResults .. L[" results found (Showing "] .. (offset+1) .. "-" .. #self.SearchResults .. ")")
	end
	
	if #self.SearchResults < VisibleLines then
		FauxScrollFrame_Update( _G[ frame.."ScrollFrame" ], VisibleLines, VisibleLines, 41);
	else
		FauxScrollFrame_Update( _G[ frame.."ScrollFrame" ], #self.SearchResults, VisibleLines, 41);
	end
	
	if not AltoholicFrameSearch:IsVisible() then
		AltoholicFrameSearch:Show()
	end
end

function Altoholic:SearchLoots_Update()
	local VisibleLines = 7
	local frame = "AltoholicFrameSearch"
	local entry = frame.."Entry"
	
	if #self.SearchResults == 0 then
		self:ClearScrollFrame( _G[ frame.."ScrollFrame" ], entry, VisibleLines, 41)
		return
	end

	local offset = FauxScrollFrame_GetOffset( _G[ frame.."ScrollFrame" ] );
	
	for i=1, VisibleLines do
		local line = i + offset
		local s = self.SearchResults[line]
		if s ~= nil then
			local itemID = s.id
			local itemName, _, itemRarity = GetItemInfo(itemID)
			local _, _, _, hex = GetItemQualityColor(itemRarity)
			_G[ entry..i.."ItemIconTexture" ]:SetTexture(GetItemIcon(itemID));

			_G[ entry..i.."Stat2" ]:SetText(YELLOW .. s.iLvl)
			_G[ entry..i.."Name" ]:SetText(hex .. itemName)
			_G[ entry..i.."Source" ]:SetText(TEAL .. s.dropLocation)
			_G[ entry..i.."Source" ]:SetID(0)
			
			_G[ entry..i.."Stat1" ]:SetText(GREEN .. s.bossName)
			
			if (s.count ~= nil) and (s.count > 1) then
				_G[ entry..i.."ItemCount" ]:SetText(s.count)
				_G[ entry..i.."ItemCount" ]:Show()
			else
				_G[ entry..i.."ItemCount" ]:Hide()
			end

			_G[ entry..i.."Item" ]:SetID(line)
			_G[ entry..i ]:Show()
		else
			_G[ entry..i ]:Hide()
		end
	end

	if (offset+VisibleLines) <= #self.SearchResults then
		AltoholicTabSearchStatus:SetText(#self.SearchResults .. L[" results found (Showing "] .. (offset+1) .. "-" .. (offset+VisibleLines) .. ")")
	else
		AltoholicTabSearchStatus:SetText(#self.SearchResults .. L[" results found (Showing "] .. (offset+1) .. "-" .. #self.SearchResults .. ")")
	end
	
	if #self.SearchResults < VisibleLines then
		FauxScrollFrame_Update( _G[ frame.."ScrollFrame" ], VisibleLines, VisibleLines, 41);
	else
		FauxScrollFrame_Update( _G[ frame.."ScrollFrame" ], #self.SearchResults, VisibleLines, 41);
	end
	
	if not AltoholicFrameSearch:IsVisible() then
		AltoholicFrameSearch:Show()
	end
end

function Altoholic:SearchUpgrade_Update()
	local VisibleLines = 7
	local frame = "AltoholicFrameSearch"
	local entry = frame.."Entry"
	
	if #self.SearchResults == 0 then
		self:ClearScrollFrame( _G[ frame.."ScrollFrame" ], entry, VisibleLines, 41)
		return
	end

	local offset = FauxScrollFrame_GetOffset( _G[ frame.."ScrollFrame" ] );
	
	for i=1, VisibleLines do
		local line = i + offset
		local s = self.SearchResults[line]
		if s ~= nil then
			local itemID = s.id
			local itemName, _, itemRarity = GetItemInfo(itemID)
			local _, _, _, hex = GetItemQualityColor(itemRarity)
			_G[ entry..i.."ItemIconTexture" ]:SetTexture(GetItemIcon(itemID));

			_G[ entry..i.."Name" ]:SetText(hex .. itemName)
			_G[ entry..i.."Source" ]:SetText(TEAL .. s.dropLocation)
			_G[ entry..i.."Source" ]:SetID(0)
		
			for j=1, 6 do
				if s["stat"..j] ~= nil then
					local statValue, diff = strsplit("|", s["stat"..j])
					local color
					diff = tonumber(diff)
					
					if diff < 0 then
						color = RED
					elseif diff > 0 then 
						color = GREEN
					else
						color = WHITE
					end
					
					_G[ entry..i.."Stat"..j ]:SetText(color .. statValue)
					_G[ entry..i.."Stat"..j ]:Show()
				else
					_G[ entry..i.."Stat"..j ]:Hide()
				end
			end

			_G[ entry..i.."ILvl" ]:SetText(YELLOW .. s.iLvl)
			_G[ entry..i.."ILvl" ]:Show()
			
			if (s.count ~= nil) and (s.count > 1) then
				_G[ entry..i.."ItemCount" ]:SetText(s.count)
				_G[ entry..i.."ItemCount" ]:Show()
			else
				_G[ entry..i.."ItemCount" ]:Hide()
			end

			_G[ entry..i.."Item" ]:SetID(line)
			_G[ entry..i ]:SetID(line)
			_G[ entry..i ]:Show()
		else
			_G[ entry..i ]:Hide()
		end
	end

	if (offset+VisibleLines) <= #self.SearchResults then
		AltoholicTabSearchStatus:SetText(#self.SearchResults .. L[" results found (Showing "] .. (offset+1) .. "-" .. (offset+VisibleLines) .. ")")
	else
		AltoholicTabSearchStatus:SetText(#self.SearchResults .. L[" results found (Showing "] .. (offset+1) .. "-" .. #self.SearchResults .. ")")
	end
	
	if #self.SearchResults < VisibleLines then
		FauxScrollFrame_Update( _G[ frame.."ScrollFrame" ], VisibleLines, VisibleLines, 41);
	else
		FauxScrollFrame_Update( _G[ frame.."ScrollFrame" ], #self.SearchResults, VisibleLines, 41);
	end
	
	if not AltoholicFrameSearch:IsVisible() then
		AltoholicFrameSearch:Show()
	end
end

-- *** Search Functions ***
function Altoholic:SearchReset()
	AltoholicFrame_SearchEditBox:SetText("")
	AltoholicTabSearch_MinLevel:SetText("")
	AltoholicTabSearch_MaxLevel:SetText("")
	AltoholicTabSearchStatus:SetText("")				-- .. the search results
	AltoholicFrameSearch:Hide()
	self:ClearTable(self.SearchResults)
	
	for k, v in pairs (self.SearchMenu) do		-- rebuild the cache
		if type(v) == "table" then		-- header
			v.isCollapsed = true
		end
	end
	V.SearchMenuHighlight = nil
	
	for i = 1, 8 do 
		_G[ "AltoholicTabSearch_Sort"..i ]:Hide()
		_G[ "AltoholicTabSearch_Sort"..i ].ascendingSort = nil
	end
	Altoholic:SearchMenu_Update()
end

local SEARCH_THISREALM = 1
local SEARCH_ALLREALMS = 2
local SEARCH_LOOTS = 3

function Altoholic:SearchItem(searchType, searchSubType)
	if (V.ongoingsearch ~= nil) then
		return		-- if a search is already happening .. then exit
	end
	V.ongoingsearch = 1
	
	V.SearchLoots = nil
	V.SearchType = searchType
	V.SearchSubType = searchSubType
	
	local value = AltoholicFrame_SearchEditBox:GetText()
	V.SearchValue = strlower(value)
	
	V.MinLevel = AltoholicTabSearch_MinLevel:GetNumber()
	V.MaxLevel = AltoholicTabSearch_MaxLevel:GetNumber()
	if V.MaxLevel == 0 then
		V.MaxLevel = LEVEL_CAP
	end
	
	self:ClearTable(self.SearchResults)
	
	local searchLocation = UIDropDownMenu_GetSelectedValue(AltoholicTabSearch_SelectLocation)
	
	if searchLocation == SEARCH_THISREALM then
		AltoholicTabSearch:SetMode("realm")
		V.SearchFaction = V.faction
		V.SearchRealm = V.realm
		self:SearchRealm()
	elseif searchLocation == SEARCH_ALLREALMS then
		AltoholicTabSearch:SetMode("realm")
		for FactionName, f in pairs(self.db.account.data) do
			for RealmName, _ in pairs(f) do
				V.SearchFaction = FactionName
				V.SearchRealm = RealmName
				self:SearchRealm()
			end
		end
	else	-- search loot tables
		AltoholicTabSearch:SetMode("loots")
		V.TotalLoots = 0
		V.TotalUnknown = 0
		V.MaxAutoQuery = 5
		V.AutoQueriesDone = 0
	
		-- break if no filter selected !
		V.SearchLoots = true -- this value will be tested in self:Search_Update() to resize columns properly
		for Instance, BossList in pairs(Altoholic.LootTable) do
			for Boss, LootList in pairs(BossList) do
				for itemID, _ in pairs(LootList) do
					self:VerifyLoot(Instance, Boss, LootList[itemID])
				end
			end
		end

		local O = self.db.account.options
		O.TotalLoots = V.TotalLoots
		O.UnknownLoots = V.TotalUnknown
		_G["AltoholicTabOptionsFrame2LootInfo"]:SetText(GREEN .. O.TotalLoots .. "|r " .. L["Loots"] .. " / "
										.. GREEN .. O.UnknownLoots .. "|r " .. L["Unknown"])
										
		V.TotalLoots = nil
		V.TotalUnknown = nil
		V.MaxAutoQuery = nil
	end
	
	if #self.SearchResults == 0 then
		if V.SearchValue == "" then 
			AltoholicTabSearchStatus:SetText(L["No match found!"])
		else
			AltoholicTabSearchStatus:SetText(value .. L[" not found!"])
		end
	end
	V.ongoingsearch = nil 	-- search done
	
	V.SearchValue = nil
	V.SearchFaction = nil
	V.SearchRealm = nil
	V.SearchType = nil
	V.SearchSubType = nil
	
	if V.SearchLoots then
		if AltoholicTabOptionsFrame2_SortDescending:GetChecked() then 		-- descending sort ?
			AltoholicTabSearch_Sort3.ascendingSort = true		-- say it's ascending now, it will be toggled
			AltoholicTabSearch:SortSearch(AltoholicTabSearch_Sort3, "iLvl")
		else
			AltoholicTabSearch_Sort3.ascendingSort = nil
			AltoholicTabSearch:SortSearch(AltoholicTabSearch_Sort3, "iLvl")
		end
	end
	
	if not AltoholicTabSearch:IsVisible() then
		Altoholic:Tab_OnClick(3)
	end

	Altoholic:Search_Update();
end

function Altoholic:SearchRealm()

	for CharacterName, c in pairs(self.db.account.data[V.SearchFaction][V.SearchRealm].char) do
		V.SearchCharacterIndex = self:GetCharacterInfoLine(CharacterName)
		for BagName, b in pairs(c.bag) do
			
			if (BagName == "Bag100") then
				V.SearchLocation = L["Bank"]
			elseif (BagName == "Bag-2") then
				V.SearchLocation = KEYRING
			else
				local bagNum = tonumber(string.sub(BagName, 4))
				if (bagNum >= 0) and (bagNum <= 4) then
					V.SearchLocation = L["Bags"]
				else
					V.SearchLocation = L["Bank"]
				end			
			end
		
			for slotID=1, b.size do
				if b.ids[slotID] ~= nil then
					self:VerifyItem(b.ids[slotID], b.counts[slotID])
				end
			end	-- slot loop
		end	-- bag loop
		
		V.SearchLocation = L["Equipped"]
		for slotID=1, 19 do
			if c.inventory[slotID] ~= nil then
				self:VerifyItem(c.inventory[slotID], 1)
			end
		end
		
		if AltoholicTabOptionsFrame2_CheckButton1:GetChecked() then			-- check mail ?
			V.SearchLocation = L["Mail"]
			for slotID=1, #c.mail do
				local s = c.mail[slotID]
				if s.link ~= nil then
					self:VerifyItem(self:GetIDFromLink(s.link), s.count)
				end
			end	-- slot loop
		end
		
		if AltoholicTabOptionsFrame2_CheckButton3:GetChecked() and (V.SearchType == nil) then			-- check known recipes ?
			for ProfessionName, p in pairs(c.recipes) do
				if p.ScanFailed == false then
					for CraftNumber, craft in pairs(p.list) do
						self:VerifyRecipe(craft.link, ProfessionName, craft.id, CraftNumber, CharacterName)
					end
				end
			end
		end
	end	-- character loop
	
	if AltoholicTabOptionsFrame2_CheckButton2:GetChecked() then	-- Check guild bank(s) ?
		V.SearchLocation = GUILD_BANK
		for guildName, g in pairs(self.db.account.data[V.SearchFaction][V.SearchRealm].guild) do
			V.SearchCharacterIndex = V.SearchFaction .. "|" .. V.SearchRealm .. "|" .. guildName		-- use this variable to store guild name
			for TabName, t in pairs(g.bank) do
				for slotID, id in pairs(t.ids) do
					if id then
						self:VerifyItem(id, t.counts[slotID])
					end
				end	-- end slots
			end	-- end tabs
		end	-- end guild
	end
	
	V.SearchCharacterIndex = nil
	V.SearchLocation = nil
end

function Altoholic:VerifyRecipe(link, profession, itemID, CraftNumber, charName)
	--if (not link) or (not itemID) then 
	if not link then return end	-- itemID should never be nil, exit if it is
	
	local itemName = self:GetCraftFromRecipe(link)
	
	if not itemName then return end
	
	if string.find(strlower(itemName), V.SearchValue, 1, true) == nil then
		return 
	end

	-- All conditions ok ? save it
	table.insert(self.SearchResults, {
		id = itemID,
		char = V.SearchCharacterIndex,
		craftName = itemName,
		craftLink = link,
		realm = self:GetRealmString(V.SearchFaction, V.SearchRealm),
		searchRealm = V.SearchRealm,
		searchFaction = V.SearchFaction,
		location = profession,
		craftNum = CraftNumber,
		altName = charName
	} )	
	
end

function Altoholic:VerifyItem(itemID, itemCount)

	local itemName, _, itemRarity, _, itemMinLevel, itemType, itemSubType, _, itemEquipLoc = GetItemInfo(itemID)

	if (itemName == nil) and (itemRarity == nil) then
		-- with these 2 being nil, the item isn't in the item cache, so its link would be invalid: don't list it
		-- This should never happen here, since this function deals only with alts inventories, therefore all items are supposed to be known
		return
	end
	
	if (V.SearchType ~= nil) and (V.SearchType ~= itemType) then
		return		-- if there's a type and it's invalid .. Exit
	end

	if (V.SearchSubType ~= nil) and (V.SearchSubType ~= itemSubType) then
		return		-- if there's a subtype and it's invalid .. Exit
	end	

	if (itemRarity < V.SearchRarity) then
		return		-- if rarity is too low .. exit
	end
	
	if (itemMinLevel == 0) then
		if (AltoholicTabOptionsFrame2_IncludeNoMinLevel:GetChecked() == nil) then
			return		-- no minimum requireement & should not be included ? .. exit
		end
	else
		if (itemMinLevel < V.MinLevel) or (itemMinLevel > V.MaxLevel) then
			return		-- not within the right level boundaries ? .. exit
		end
	end
	
	if V.SearchSlot ~= 0 then	-- if a specific equipment slot is specified ..
		if self.InvSlots[itemEquipLoc] ~= V.SearchSlot then
			return		-- not the right slot ? .. exit
		end
	end

	if string.find(strlower(itemName), V.SearchValue, 1, true) == nil then
		return		-- item name does not match search value ? .. exit
	end

	-- All conditions ok ? save it
	table.insert(self.SearchResults, {
		id = itemID,
		char = V.SearchCharacterIndex,		-- line number in CharacterInfo table
		count = itemCount,
		location = V.SearchLocation
	} )
end

function Altoholic:VerifyLoot(Instance, Boss, itemID)
	V.TotalLoots = V.TotalLoots + 1

	local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, _, itemEquipLoc, itemIcon = GetItemInfo(itemID)

	if (itemName == nil) and (itemRarity == nil) then
		-- with these 2 being nil, the item isn't in the item cache, so its link would be invalid: don't list it
		V.TotalUnknown = V.TotalUnknown + 1
		
		if V.AutoQueriesDone < V.MaxAutoQuery then		-- find up to MaxAutoQuery new loots in next search
			if AltoholicTabOptionsFrame2_SearchAutoQuery:GetChecked() then
				if self:IsUnsafeItemKnown(itemID) then		-- if the item is known to be unsafe .. exit !
					return
				end
				GameTooltip:SetHyperlink("item:"..itemID..":0:0:0:0:0:0:0")	-- this line queries the server for an unknown id
				GameTooltip:ClearLines(); -- don't leave residual info in the tooltip after the server query

				-- save ALL tested id's, clean the list in OnEnable during the next session.
				-- the unsafe list will be cleaned in OnEnable, by parsing all ids and testing if getiteminfo returns a nil or not, if so, it's a definite unsafe link
				self:SaveUnsafeItem(itemID)			-- save id to unsafe list
			end
			V.AutoQueriesDone = V.AutoQueriesDone + 1
		end
		return
	end
	
	if (V.SearchType ~= nil) and (V.SearchType ~= itemType) then
		return		-- if there's a type and it's invalid .. Exit
	end

	if (V.SearchSubType ~= nil) and (V.SearchSubType ~= itemSubType) then
		return		-- if there's a subtype and it's invalid .. Exit
	end	

	if (itemRarity < V.SearchRarity) then
		return		-- if rarity is too low .. exit
	end
	
	if (itemMinLevel == 0) then
		if (AltoholicTabOptionsFrame2_IncludeNoMinLevel:GetChecked() == nil) then
			return		-- no minimum requireement & should not be included ? .. exit
		end
	else
		if (itemMinLevel < V.MinLevel) or (itemMinLevel > V.MaxLevel) then
			return		-- not within the right level boundaries ? .. exit
		end
	end

	if V.SearchSlot ~= 0 then	-- if a specific equipment slot is specified ..
		if self.InvSlots[itemEquipLoc] ~= V.SearchSlot then
			return		-- not the right slot ? .. exit
		end
	end
	
	if string.find(strlower(itemName), V.SearchValue, 1, true) == nil then
		return		-- item name does not match search value ? .. exit
	end

	-- All conditions ok ? save it
	table.insert(self.SearchResults, {
		id = itemID,
		iLvl = itemLevel,
		bossName = Boss,
		dropLocation = Instance
	} )
end

function Altoholic:SaveUnsafeItem(itemID)
	if self:IsUnsafeItemKnown(itemID) then			-- if the unsafe item has already been saved .. exit
		return
	end
	
	-- if not, save it
	table.insert(self.db.account.data[V.faction][V.realm].unsafeItems, itemID)
end

function Altoholic:IsUnsafeItemKnown(itemID)
	for k, v in pairs(self.db.account.data[V.faction][V.realm].unsafeItems) do 	-- browse current realm's unsafe item list
		if v == itemID then		-- if the itemID passed as parameter is a known unsafe item .. return true to skip it
			return true
		end
	end
	return false			-- false if unknown
end

function Altoholic:BuildUnsafeItemList()
	-- This method will clean the unsafe item list currently in the DB. 
	-- In the previous game session, the list has been populated with items id's that were originally unsafe and for which a query was sent to the server.
	-- In this session, a getiteminfo on these id's will keep returning a nil if the item is really unsafe, so this method will get rid of the id's that are now valid.
	V.TmpUnsafe = {}		-- create a temporary table with confirmed unsafe id's
	for k, v in pairs(self.db.account.data[V.faction][V.realm].unsafeItems) do
		local itemName = GetItemInfo(v)
		if not itemName then							-- if the item is really unsafe .. save it
			table.insert(V.TmpUnsafe, v)
		end
	end
	
	self:ClearTable(self.db.account.data[V.faction][V.realm].unsafeItems)	-- clear the DB table
	
	for k, v in pairs(V.TmpUnsafe) do
		table.insert(self.db.account.data[V.faction][V.realm].unsafeItems, v)	-- save the confirmed unsafe ids back in the db
	end
	
	self:ClearTable(V.TmpUnsafe)		-- then clear the temporary table
	V.TmpUnsafe = nil
end

--function Altoholic:VerifyUpgrade(Instance, Boss, itemID)
function Altoholic:VerifyUpgrade()

	local itemName, _, itemRarity, itemLevel, _, itemType, itemSubType, _, itemEquipLoc = GetItemInfo(V.SearchLootItemID)

	if (itemName == nil) and (itemRarity == nil) then
		return			-- with these 2 being nil, the item isn't in the item cache, so its link would be invalid: don't list it
	end

	if (itemLevel <= V.Search_iLvl) or (V.SearchType ~= itemType) or 
		(V.SearchSubType ~= itemSubType) then
		return		-- not within the right level boundaries ? invalid type or subtype ? .. exit
	end

	if Altoholic.InvSlots[itemEquipLoc] ~= V.SearchEquipLoc then
		return		-- not the right slot ? .. exit
	end

	-- All conditions ok ? save it
	table.insert(Altoholic.SearchResults, {
		id = V.SearchLootItemID,
		iLvl = itemLevel,
		bossName = V.SearchBoss,
		dropLocation = V.SearchInstance
	} )
end

--function Altoholic:VerifyUpgradeByStats(Instance, Boss, itemID)
function Altoholic:VerifyUpgradeByStats()

	local itemName, itemLink, itemRarity, itemLevel, _, itemType, itemSubType, _, itemEquipLoc = GetItemInfo(V.SearchLootItemID)

	if (itemName == nil) and (itemRarity == nil) then
		return			-- with these 2 being nil, the item isn't in the item cache, so its link would be invalid: don't list it
	end

	if (itemLevel <= V.Search_iLvl) or (V.SearchType ~= itemType) or 
		(V.SearchSubType ~= itemSubType) then
		return		-- not within the right level boundaries ? invalid type or subtype ? .. exit
	end

	if Altoholic.InvSlots[itemEquipLoc] ~= V.SearchEquipLoc then
		return		-- not the right slot ? .. exit
	end

	-- This method is called from Equipment.lua ==> Altoholic_Equipment_OnClick, some variables are set there before the call.
	AltoTooltip:ClearLines();	
	AltoTooltip:SetOwner(this, "ANCHOR_LEFT");
	AltoTooltip:SetHyperlink(itemLink)	-- Set the link to be able to parse item stats (set owner is done earlier, before the loop)
	
	-- save some time by trying to find out if the item could be excluded
	Altoholic:ClearTable(V.TooltipLines)
	for i = 4, AltoTooltip:NumLines() do	-- parse all tooltip lines, one by one, start at 4 since 1= item name, 2 = binds on.., 3 = type/slot/unique ..etc
		-- in this first pass, save the lines into a cache, reused below
		local tooltipLine = _G[ "AltoTooltipTextLeft" .. i]:GetText()
		if tooltipLine then
			if string.find(tooltipLine, L["Socket"]) == nil then
				for _, v in pairs(Altoholic.ExcludeStats[V.CharacterClass]) do
					--if string.find(tooltipLine, v, 1, true) ~= nil then return end
					if string.find(tooltipLine, v) ~= nil then return end
				end
				V.TooltipLines[i] = tooltipLine
			end
		end
	end
	
	local statFound
	local j=1
	for _, BaseStat in pairs(Altoholic.BaseStats[V.CharacterClass]) do

		statFound = nil
		for i, tooltipText in pairs(V.TooltipLines) do
			--if string.find(tooltipText, BaseStat, 1, true) ~= nil then
			if string.find(tooltipText, BaseStat) ~= nil then
				--local stat = tonumber(string.sub(tooltipText, string.find(tooltipText, "%d+")))
				local stat = tonumber(string.match(tooltipText, "%d+"))
				
				V.RawItemStats[j] = stat .. "|" .. (stat - V.SearchItemStats[BaseStat])
				table.remove(V.TooltipLines, i)	-- remove the current entry, so it won't be parsed in the next loop cycle
				statFound = true
				break
			end
		end
		
		if not statFound then
			V.RawItemStats[j] = "0|" .. (0 - V.SearchItemStats[BaseStat])
		end
		j = j + 1
	end
		
	-- All conditions ok ? save it
	table.insert(Altoholic.SearchResults, {
		id = V.SearchLootItemID,
		iLvl = itemLevel,
		bossName = statLine,
		dropLocation = V.SearchInstance .. ", " .. GREEN .. V.SearchBoss,
		stat1 = V.RawItemStats[1],
		stat2 = V.RawItemStats[2],
		stat3 = V.RawItemStats[3],
		stat4 = V.RawItemStats[4],
		stat5 = V.RawItemStats[5],
		stat6 = V.RawItemStats[6]
	} )
end
