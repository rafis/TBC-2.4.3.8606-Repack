local L = AceLibrary("AceLocale-2.2"):new("Altoholic")
local V = Altoholic.vars

function Altoholic:DrawGuildBankTab(tabID)

	local selectedGuild = UIDropDownMenu_GetSelectedValue(AltoholicTabGuildBank_SelectGuild)
	if not selectedGuild then return end		-- not defined yet ? exit.

	if not GuildBank:IsVisible() then
		GuildBank:Show()
	end
	
	local faction, realm, guildName = strsplit("|", selectedGuild)
	local guild	= Altoholic.db.account.data[faction][realm].guild[guildName]
	
	local b = guild.bank["Tab" .. tabID]
	local entry = "GuildBankEntry"
	
	for i=1, 7 do
	
		local from = mod(i, 7)
		if from == 0 then from = 7 end
	
		for j=14, 1, -1 do
			local itemName = entry..i .. "Item" .. j;
			local itemButton = _G[itemName];
			
			local itemIndex = from + ((j - 1) * 7)
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
		end
		_G[ entry..i ]:Show()
	end

	AltoholicTabGuildBankStatus:SetText(L["Last visited "] .. self:GetDelayInDays(guild.lastbankvisittime) 
			.. L[" days ago by "] .. guild.lastbankvisitby .. " (" .. self:GetMoneyString(guild.bankmoney) .. "|r)")
end

function Altoholic:UpdateGuildBankTab()
	if V.guild == nil then
		V.guild = GetGuildInfo("player")
	end
	
	-- only the current tab can be updated
	local guild = self.db.account.data[V.faction][V.realm].guild[V.guild]
	local i = GetCurrentGuildBankTab();			-- tab ID
	local t = guild.bank["Tab" .. i]							-- t = current tab
	guild.bankmoney = GetGuildBankMoney()			-- read guild bank money while we're at it
	t.name = GetGuildBankTabInfo(i)
	t.tabID = i
	
	for j = 1, 98 do
		t.ids[j] = nil
		t.counts[j] = nil
		t.links[j] = nil
		
		local link = GetGuildBankItemLink(i, j)
		if link ~= nil then
			t.ids[j] = self:GetIDFromLink(link)

			-- if any of these differs from 0, there's an enchant or a jewel, so save the full link
			if self:GetEnchantInfo(link) then		-- 1st return value = isEnchanted
				t.links[j] = link
			end
			
			local _, count = GetGuildBankItemInfo(i, j)
			if (count ~= nil) and (count > 1)  then
				t.counts[j] = count	-- only save the count if it's > 1 (to save some space since a count of 1 is extremely redundant)
			end
		end
	end
end

-- *** EVENT HANDLERS ***

function Altoholic:GUILDBANKFRAME_OPENED()
	self:RegisterEvent("GUILDBANKBAGSLOTS_CHANGED")
end

function Altoholic:GUILDBANKFRAME_CLOSED()
	-- the GUILDBANKFRAME_CLOSED event is fired twice when the bank is closed, only take care of the 1st pass
	if V.guildbankclose == nil then		-- Closing bank, 1st pass, update the bags
		local guild = self.db.account.data[V.faction][V.realm].guild[V.guild]
		if guild then
			guild.lastbankvisitby = V.player
			guild.lastbankvisittime = time()	
		end
		V.guildbankclose = 1
		-- test if correctly registered, seems to bug after purchasing a new guild bank tab.
		if self:IsEventRegistered("GUILDBANKBAGSLOTS_CHANGED") then
			self:UnregisterEvent("GUILDBANKBAGSLOTS_CHANGED")
		end
	else									-- Closing bank, 2nd pass, do nothing
		V.guildbankclose = nil
	end
end

function Altoholic:GUILDBANKBAGSLOTS_CHANGED()
	-- same system as for the mail, will work fine UNLESS another player checks the guild bank exactly at the same time
	-- will need to be improved once I find out how x)
	if (V.ongoingbankscan == nil) then
		V.ongoingbankscan = 1
		self:UpdateGuildBankTab()
		V.ongoingbankscan = nil
	end
end
