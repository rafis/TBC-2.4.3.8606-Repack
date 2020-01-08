local L = AceLibrary("AceLocale-2.2"):new("Altoholic")

local V = Altoholic.vars
local ORANGE	= "|cFFFF7F00"
local GREEN		= "|cFF00FF00"
local YELLOW	= "|cFFFFFF00"

local VIEW_BAGS = 1
local VIEW_ALLINONE = 2
local VIEW_MAILS = 3
local VIEW_QUESTS = 4
local VIEW_AUCTIONS = 5
local VIEW_BIDS = 6
local VIEW_REP = 7
local VIEW_EQUIP = 8
local VIEW_SKILLS = 9

function AltoholicTabCharacters:SelectRealmDropDown_Initialize()
	local info = UIDropDownMenu_CreateInfo(); 

	for FactionName, f in pairs(Altoholic.db.account.data) do
		for RealmName, r in pairs(f) do
			info.text = RealmName
			info.value = FactionName .."|" .. RealmName
			info.owner = this:GetParent(); 
			info.checked = nil; 
			info.func = function(self)
				local OldRealm = V.CurrentRealm
				V.CurrentFaction, V.CurrentRealm = strsplit("|", this.value)
				UIDropDownMenu_ClearAll(this.owner);
				UIDropDownMenu_SetSelectedValue(this.owner, V.CurrentFaction .."|".. V.CurrentRealm)
				UIDropDownMenu_SetText(V.CurrentRealm, this.owner)
				
				if OldRealm then	-- clear the "select char" drop down only if realm has changed
					if OldRealm ~= V.CurrentRealm then
						UIDropDownMenu_ClearAll(AltoholicTabCharacters_SelectChar);
						UIDropDownMenu_ClearAll(AltoholicTabCharacters_View);
						AltoholicTabCharactersStatus:SetText("")
						V.CurrentAlt = nil
						V.CurrentProfession = nil
						Altoholic:BuildFactionsTable()
						
						AltoholicTabCharacters:HideAll()
					end
				end
			end
			UIDropDownMenu_AddButton(info, 1); 
		end
	end
end

function AltoholicTabCharacters:SelectCharDropDown_Initialize()
	if not V.CurrentFaction or 
		not V.CurrentRealm then return end
	
	local info = UIDropDownMenu_CreateInfo(); 
	for CharacterName, c in pairs(Altoholic.db.account.data[V.CurrentFaction][V.CurrentRealm].char) do
		info.text = CharacterName
		info.value = CharacterName
		info.owner = this:GetParent(); 
		info.func = AltoholicTabCharacters.ChangeAlt
		info.checked = nil; 
		UIDropDownMenu_AddButton(info, 1); 
	end
end

function AltoholicTabCharacters:ChangeAlt()
	local OldAlt = V.CurrentAlt
	
	UIDropDownMenu_SetSelectedValue(this.owner, this.value);
	V.CurrentAlt = this.value
	
	if (not OldAlt) or (OldAlt == V.CurrentAlt) then return end

	local infoType = UIDropDownMenu_GetSelectedValue(AltoholicTabCharacters_View)
	if (type(infoType) == "string") or
		((type(infoType) == "number") and (infoType > VIEW_BIDS)) then		-- true if we're dealing with a profession
		UIDropDownMenu_ClearAll(AltoholicTabCharacters_View);
		V.CurrentProfession = nil
		AltoholicTabCharacters:HideAll()
	else
		AltoholicTabCharacters:ShowCharInfo(infoType)		-- this will show the same info from another alt (ex: containers/mail/ ..)
	end
end

function AltoholicTabCharacters:ViewDropDown_Initialize()
	if not V.CurrentFaction or 
		not V.CurrentRealm or 
		not V.CurrentAlt then return end
	
	local info = UIDropDownMenu_CreateInfo(); 	
	local c = Altoholic.db.account.data[V.CurrentFaction][V.CurrentRealm].char[V.CurrentAlt]
	
	info.text = L["Containers"]
	info.value = VIEW_BAGS
	info.owner = this:GetParent(); 
	info.func = AltoholicTabCharacters.ViewCharInfo;
	info.checked = nil; 
	UIDropDownMenu_AddButton(info, 1); 
	
	info.text = L["Containers"] .. " (" .. L["All-in-one"] .. ")"
	info.value = VIEW_ALLINONE
	info.owner = this:GetParent(); 
	info.func = AltoholicTabCharacters.ViewCharInfo;
	info.checked = nil; 
	UIDropDownMenu_AddButton(info, 1); 

	info.text = format(L["Mails %s(%d)"], GREEN, #c.mail)
	info.value = VIEW_MAILS
	info.owner = this:GetParent(); 
	info.func = AltoholicTabCharacters.ViewCharInfo;
	info.checked = nil; 
	UIDropDownMenu_AddButton(info, 1); 
	
	info.text = L["Quests"]
	info.value = VIEW_QUESTS
	info.owner = this:GetParent();
	info.func = AltoholicTabCharacters.ViewCharInfo;
	info.checked = nil;
	UIDropDownMenu_AddButton(info, 1);

	info.text = format(L["Auctions %s(%d)"], GREEN, #c.auctions)
	info.value = VIEW_AUCTIONS
	info.owner = this:GetParent();
	info.func = AltoholicTabCharacters.ViewCharInfo;
	info.checked = nil;
	UIDropDownMenu_AddButton(info, 1);

	info.text = format(L["Bids %s(%d)"], GREEN, #c.bids)
	info.value = VIEW_BIDS
	info.owner = this:GetParent();
	info.func = AltoholicTabCharacters.ViewCharInfo;
	info.checked = nil;
	UIDropDownMenu_AddButton(info, 1);

	info.text = YELLOW .. L["Reputations"]
	info.value = VIEW_REP
	info.owner = this:GetParent();
	info.func = AltoholicTabCharacters.ViewCharInfo;
	info.checked = nil;
	UIDropDownMenu_AddButton(info, 1);
	
	info.text = YELLOW .. L["Equipment"]
	info.value = VIEW_EQUIP
	info.owner = this:GetParent();
	info.func = AltoholicTabCharacters.ViewCharInfo;
	info.checked = nil;
	UIDropDownMenu_AddButton(info, 1);
	
	for TradeSkillName, _ in pairs(c.recipes) do
		info.text = ORANGE .. TradeSkillName
		info.value = TradeSkillName
		info.owner = this:GetParent();
		info.func = AltoholicTabCharacters.ViewCharSkills;
		info.checked = nil;
		UIDropDownMenu_AddButton(info, 1);
	end
end

function AltoholicTabCharacters:ViewCharInfo(index)
	if not index then
		index = this.value
	end
	
	AltoholicTabCharacters:HideAll()
	AltoholicTabCharacters:ShowCharInfo(index)
end

function AltoholicTabCharacters:ViewCharSkills()
	AltoholicTabCharacters:HideAll()
	
	V.CurrentProfession = this.value
	this.value = ORANGE .. V.CurrentProfession
	UIDropDownMenu_SetSelectedValue(this.owner, this.value);
	AltoholicFrameRecipes:Show()
end

function AltoholicTabCharacters:ShowCharInfo(infoType)

	local c = Altoholic.db.account.data[V.CurrentFaction][V.CurrentRealm].char[V.CurrentAlt]

	UIDropDownMenu_SetSelectedValue(AltoholicTabCharacters_View, infoType);
	if infoType == VIEW_BAGS then
		UIDropDownMenu_SetText(L["Containers"], AltoholicTabCharacters_View)
		Altoholic:UpdateContainerCache()
		Altoholic:ClearScrollFrame(_G[ "AltoholicFrameContainersScrollFrame" ], "AltoholicFrameContainersEntry", 7, 41)
		AltoholicFrameContainers:Show()
		Altoholic.Containers_Update = Altoholic.ContainersSpread_Update
		Altoholic:Containers_Update();
	elseif infoType == VIEW_ALLINONE then
		UIDropDownMenu_SetText(L["Containers"] .. " (" .. L["All-in-one"] .. ")", AltoholicTabCharacters_View)
		Altoholic:UpdateContainerCache()
		Altoholic:ClearScrollFrame(_G[ "AltoholicFrameContainersScrollFrame" ], "AltoholicFrameContainersEntry", 7, 41)
		AltoholicFrameContainers:Show()
		Altoholic.Containers_Update = Altoholic.ContainersAllInOne_Update
		Altoholic:Containers_Update();
	elseif infoType == VIEW_MAILS then
		UIDropDownMenu_SetText(format(L["Mails %s(%d)"], GREEN, #c.mail), AltoholicTabCharacters_View)
		AltoholicFrameMail:Show()
		Altoholic:Mail_Update();
	elseif infoType == VIEW_QUESTS then
		UIDropDownMenu_SetText(L["Quests"], AltoholicTabCharacters_View)
		AltoholicFrameQuests:Show()
		Altoholic:Quests_Update();
	elseif infoType == VIEW_AUCTIONS then
		UIDropDownMenu_SetText(format(L["Auctions %s(%d)"], GREEN, #c.auctions), AltoholicTabCharacters_View)
		V.AuctionType = "auctions"
		Altoholic.Auctions_Update = Altoholic.Auctions_Update_Auctions
		AltoholicFrameAuctions:Show()
		Altoholic:Auctions_Update();
	elseif infoType == VIEW_BIDS then
		UIDropDownMenu_SetText(format(L["Bids %s(%d)"], GREEN, #c.bids), AltoholicTabCharacters_View)
		V.AuctionType = "bids"
		Altoholic.Auctions_Update = Altoholic.Auctions_Update_Bids
		AltoholicFrameAuctions:Show()
		Altoholic:Auctions_Update();
	elseif infoType == VIEW_REP then
		UIDropDownMenu_SetText(YELLOW .. L["Reputations"], AltoholicTabCharacters_View)
		AltoholicTabCharacters:ShowClassIcons()
		AltoholicTabCharactersRepNames:Show()
		AltoholicFrameReputations:Show()
		Altoholic:Reputations_Update();	
	elseif infoType == VIEW_EQUIP then
		UIDropDownMenu_SetText(YELLOW .. L["Equipment"], AltoholicTabCharacters_View)
		AltoholicTabCharacters:ShowClassIcons()
		AltoholicFrameEquipment:Show()
		Altoholic:Equipment_Update();	
	end
end

function AltoholicTabCharacters:ShowClassIcons()
	local i = 1

	for CharacterName, c in pairs(Altoholic.db.account.data[V.CurrentFaction][V.CurrentRealm].char) do
		local itemName = "AltoholicTabCharactersClassesItem" .. i;
		local itemButton = _G[itemName];
		itemButton:SetScript("OnEnter", function(self) 
				Altoholic:DrawCharacterTooltip(self.CharName)
			end)
		itemButton:SetScript("OnLeave", function(self) 
				AltoTooltip:Hide()
			end)
		itemButton:SetScript("OnClick", Altoholic_Equipment_OnClick)
		
		local tc = Altoholic.ClassInfo[ Altoholic.Classes[c.class] ].texcoord
		local itemTexture = _G[itemName .. "IconTexture"]		
		itemTexture:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes");
		itemTexture:SetTexCoord(tc[1], tc[2], tc[3], tc[4]);
		itemTexture:SetWidth(36);
		itemTexture:SetHeight(36);
		itemTexture:SetAllPoints(itemButton);
		itemButton.CharName = CharacterName
		_G[ itemName ]:Show()
		
		i = i + 1
	end
	
	while i <= 10 do
		_G[ "AltoholicTabCharactersClassesItem" .. i ]:Hide()
		_G[ "AltoholicTabCharactersClassesItem" .. i ].CharName = nil
		i = i + 1
	end
	
	AltoholicTabCharactersClasses:Show()
end

function AltoholicTabCharacters:HideAll()
	AltoholicFrameContainers:Hide()
	AltoholicFrameMail:Hide()
	AltoholicFrameQuests:Hide()
	AltoholicFrameAuctions:Hide()
	AltoholicFrameRecipes:Hide()
	AltoholicFrameReputations:Hide()
	AltoholicFrameEquipment:Hide()
	AltoholicTabCharactersClasses:Hide()
	AltoholicTabCharactersRepNames:Hide()
end
