local L = AceLibrary("AceLocale-2.2"):new("Altoholic")
local V = Altoholic.vars

function Altoholic:ContainersSpread_Update()
	local VisibleLines = 7
	local frame = "AltoholicFrameContainers"
	local entry = frame.."Entry"
	
	if #self.BagIndices == 0 then
		self:ClearScrollFrame( _G[ frame.."ScrollFrame" ], entry, VisibleLines, 41)
		return
	end
	
	AltoholicTabCharactersStatus:SetText("")
	
	local c = self.db.account.data[V.CurrentFaction][V.CurrentRealm].char[V.CurrentAlt]		-- current alt
	local offset = FauxScrollFrame_GetOffset( _G[ frame.."ScrollFrame" ] );
	
	for i=1, VisibleLines do
		local line = i + offset
		local b = c.bag["Bag" .. self.BagIndices[line].bagID]
		
		local itemName = entry..i .. "Item1";
		if self.BagIndices[line].from == 1 then		-- if this is the first line for this bag .. draw bag icon
			local itemButton = _G[itemName];	
			local itemTexture = _G[itemName .. "IconTexture"]
			if b.icon ~= nil then
				itemTexture:SetTexture(b.icon);
			else		-- will be nill for bag 100
				itemTexture:SetTexture("Interface\\Icons\\INV_Box_03");
			end
			itemTexture:SetWidth(36);
			itemTexture:SetHeight(36);
			itemTexture:SetAllPoints(itemButton);
			
			itemButton:SetID(self.BagIndices[line].bagID)

			itemButton:SetScript("OnEnter", function(self)
				local id = self:GetID()
				GameTooltip:SetOwner(this, "ANCHOR_LEFT");
				if id == -2 then
					GameTooltip:AddLine(KEYRING,1,1,1);
					GameTooltip:AddLine(L["32 Keys Max"],1,1,1);
				elseif id == 0 then
					GameTooltip:AddLine(BACKPACK_TOOLTIP,1,1,1);
					GameTooltip:AddLine(format(CONTAINER_SLOTS, 16, BAGSLOT),1,1,1);
					
				elseif id == 100 then
					GameTooltip:AddLine(L["Bank"],0.5,0.5,1);
					GameTooltip:AddLine(L["28 Slot"],1,1,1);
				else
					local r = Altoholic.db.account.data[V.CurrentFaction][V.CurrentRealm]
					GameTooltip:SetHyperlink( r.char[V.CurrentAlt].bag["Bag" .. id].link );
					if (id >= 5) and (id <= 11) then
						GameTooltip:AddLine(L["Bank bag"],0,1,0);
					end
				end
				GameTooltip:Show();
			end)
			_G[itemName .. "Count"]:Hide()
			
			_G[ itemName ]:Show()
		else
			_G[ itemName ]:Hide()
		end
		
		_G[ entry..i .. "Item2" ]:Hide()
		_G[ entry..i .. "Item2" ].id = nil
		_G[ entry..i .. "Item2" ].link = nil
		
		for j=3, 14 do
			local itemName = entry..i .. "Item" .. j;
			local itemButton = _G[itemName];
			
			local itemIndex = self.BagIndices[line].from - 3 + j
			
			if (itemIndex <= b.size) then 
				local itemTexture = _G[itemName .. "IconTexture"]
				
				if b.ids[itemIndex] ~= nil then
					itemTexture:SetTexture(GetItemIcon(b.ids[itemIndex]));
				else
					itemTexture:SetTexture("Interface\\PaperDoll\\UI-Backpack-EmptySlot");
				end
				itemTexture:SetWidth(36);
				itemTexture:SetHeight(36);
				itemTexture:SetAllPoints(itemButton);
				
				itemButton.id = b.ids[itemIndex]
				itemButton.link = b.links[itemIndex]
				itemButton:SetScript("OnEnter", Altoholic.Item_OnEnter)
				
				local itemCount = _G[itemName .. "Count"]
				if (b.counts[itemIndex] == nil) or (b.counts[itemIndex] < 2)then
					itemCount:Hide();
				else
					itemCount:SetText(b.counts[itemIndex]);
					itemCount:Show();
				end
			
				_G[ itemName ]:Show()
			else
				_G[ itemName ]:Hide()
				itemButton.id = nil
				itemButton.link = nil
			end
		end
		_G[ entry..i ]:Show()
	end
	
	if #self.BagIndices < VisibleLines then
		FauxScrollFrame_Update( _G[ frame.."ScrollFrame" ], VisibleLines, VisibleLines, 41);
	else
		FauxScrollFrame_Update( _G[ frame.."ScrollFrame" ], #self.BagIndices, VisibleLines, 41);
	end	
end	

function Altoholic:ContainersAllInOne_Update()
	local VisibleLines = 7
	local frame = "AltoholicFrameContainers"
	local entry = frame.."Entry"
	
	AltoholicTabCharactersStatus:SetText("")
	
	local c = self.db.account.data[V.CurrentFaction][V.CurrentRealm].char[V.CurrentAlt]		-- current alt
	local offset = FauxScrollFrame_GetOffset( _G[ frame.."ScrollFrame" ] );
	
	local minSlotIndex = offset * 14
	local currentSlotIndex = 0		-- this indexes the non-empty slots
	local i = 1
	local j = 1
	
	for BagName, b in pairs (c.bag) do
		for k, itemID in pairs (b.ids) do
			currentSlotIndex = currentSlotIndex + 1
			if (currentSlotIndex > minSlotIndex) and (i <= VisibleLines) then
				local itemName = entry..i .. "Item" .. j;
				local itemButton = _G[itemName];
				local itemTexture = _G[itemName .. "IconTexture"]
				
				itemTexture:SetTexture(GetItemIcon(itemID));
				itemTexture:SetWidth(36);
				itemTexture:SetHeight(36);
				itemTexture:SetAllPoints(itemButton);
				
				itemButton.id = itemID
				itemButton.link = b.links[k]
				itemButton:SetScript("OnEnter", Altoholic.Item_OnEnter)
			
				local itemCount = _G[itemName .. "Count"]
				if (b.counts[k] == nil) or (b.counts[k] < 2)then
					itemCount:Hide();
				else
					itemCount:SetText(b.counts[k]);
					itemCount:Show();
				end
		
				_G[ itemName ]:Show()
				
				j = j + 1
				if j > 14 then
					j = 1
					i = i + 1
				end
			end
		end
	end
	
	while i <= VisibleLines do
		while j <= 14 do
			_G[ entry..i .. "Item" .. j ]:Hide()
			_G[ entry..i .. "Item" .. j ].id = nil
			_G[ entry..i .. "Item" .. j ].link = nil
			j = j + 1
		end
	
		j = 1
		i = i + 1
	end
	
	for i=1, VisibleLines do
		_G[ entry..i ]:Show()
	end
	
	if #self.BagIndices < VisibleLines then
		FauxScrollFrame_Update( _G[ frame.."ScrollFrame" ], VisibleLines, VisibleLines, 41);
	else
		FauxScrollFrame_Update( _G[ frame.."ScrollFrame" ], ceil(currentSlotIndex / 14), VisibleLines, 41);
	end	
end

function Altoholic:Item_OnEnter()
	if not self.id then return end
	
	GameTooltip:SetOwner(self, "ANCHOR_LEFT");
	
	if not self.link then								-- if there's no full item link .. get it
		self.link = select(2, GetItemInfo(self.id) )
	end
	if not self.link then	-- still not valid ?
		GameTooltip:AddLine(L["Unknown link, please relog this character"],1,1,1);
	else
		GameTooltip:SetHyperlink(self.link);
	end
	GameTooltip:Show();
end

function Altoholic:Item_OnClick(this, button)
	if not this.id then return end
	
	if not this.link then
		this.link = select(2, GetItemInfo(this.id) )
	end
	if not this.link then return end		-- still not valid ? exit
	
	if ( button == "LeftButton" ) and ( IsControlKeyDown() ) then
		DressUpItemLink(this.link);
	elseif ( button == "LeftButton" ) and ( IsShiftKeyDown() ) then
		if ( ChatFrameEditBox:IsShown() ) then
			ChatFrameEditBox:Insert(this.link);
		else
			AltoholicFrame_SearchEditBox:SetText(GetItemInfo(this.link))
		end
	end
end
