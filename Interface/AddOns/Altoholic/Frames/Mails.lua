local L = AceLibrary("AceLocale-2.2"):new("Altoholic")
local V = Altoholic.vars
local GREEN		= "|cFF00FF00"

function Altoholic:Mail_Update()
	local c = self.db.account.data[V.CurrentFaction][V.CurrentRealm].char[V.CurrentAlt]		-- current alt
	local VisibleLines = 7
	local frame = "AltoholicFrameMail"
	local entry = frame.."Entry"
	
	if #c.mail == 0 then
		if c.lastmailcheck == 0 then
			AltoholicTabCharactersStatus:SetText(V.CurrentAlt .. L[" has not visited his/her mailbox yet"])
		else
			AltoholicTabCharactersStatus:SetText(V.CurrentAlt .. L[" has no mail, last check "] .. self:GetDelayInDays(c.lastmailcheck).. L[" days ago"])
		end
	
		self:ClearScrollFrame( _G[ frame.."ScrollFrame" ], entry, VisibleLines, 41)
		return
	else
		AltoholicTabCharactersStatus:SetText(L["Mailbox: "] .. V.CurrentAlt)
	end

	local offset = FauxScrollFrame_GetOffset( _G[ frame.."ScrollFrame" ] );
	
	for i=1, VisibleLines do
		local line = i + offset
		if line <= #c.mail then
			local s = c.mail[line]
			if s.link then
				_G[ entry..i.."Name" ]:SetText(s.link)
			else
				_G[ entry..i.."Name" ]:SetText(s.subject)
			end
			
			_G[ entry..i.."Character" ]:SetText(s.sender)
			_G[ entry..i.."Expiry" ]:SetText(self:FormatMailExpiry(s.lastcheck, s.daysleft) .. L[" days"])
			_G[ entry..i.."ItemIconTexture" ]:SetTexture(s.icon);
			if (s.count ~= nil) and (s.count > 1) then
				_G[ entry..i.."ItemCount" ]:SetText(s.count)
				_G[ entry..i.."ItemCount" ]:Show()
			else
				_G[ entry..i.."ItemCount" ]:Hide()
			end
			-- trick: pass the index of the current item in the results table, required for the tooltip
			_G[ entry..i.."Item" ]:SetID(line)
			_G[ entry..i ]:Show()
		else
			_G[ entry..i ]:Hide()
		end
	end
	
	AltoholicTabCharactersStatus:SetText(L["Mail was last checked "] .. self:GetDelayInDays(c.lastmailcheck).. L[" days ago"])
	
	if #c.mail < VisibleLines then
		FauxScrollFrame_Update( _G[ frame.."ScrollFrame" ], VisibleLines, VisibleLines, 41);
	else
		FauxScrollFrame_Update( _G[ frame.."ScrollFrame" ], #c.mail, VisibleLines, 41);
	end
end

function Altoholic:FormatMailExpiry(lastcheck, mailexpiry)
	if (lastcheck == nil) or (lastcheck == 0) then
		-- return mailexpiry
		return GREEN .. string.format("%.2f", mailexpiry)
	end

	local expiry = self:GetMailExpiry(lastcheck, mailexpiry)
	
	if expiry > 10 then
		return GREEN .. string.format("%.2f", expiry)
	elseif expiry > 5 then
		return "|cFFFFFF00" .. string.format("%.2f", expiry)
	end
	return "|cFFFF0000" .. string.format("%.2f", expiry)
end

function Altoholic:GetMailExpiry(lastcheck, mailexpiry)
	return mailexpiry - ((time() - lastcheck) / 86400)
end

function Altoholic:CheckExpiredMail()
	-- this function checks the expiry date of each mail stored on all realms, and sets a flag if any is below threshold
	local O = self.db.account.options
	
	for FactionName, f in pairs(self.db.account.data) do
		for RealmName, r in pairs(f) do
			for CharacterName, c in pairs(r.char) do
				for k, v in pairs(c.mail) do		--  parse mails
					if self:GetMailExpiry(v.lastcheck, v.daysleft) < O.MailWarningThreshold then
						V.ExpiredMail = true
						return
						-- at the moment, trigger the message if at least one char meets the condition
					end
				end
			end
		end
	end
end

function Altoholic:UpdatePlayerMail()
	local c = self.db.account.data[V.faction][V.realm].char[V.player]
	local numItems = GetInboxNumItems();

	self:ClearTable(c.mail)
	if numItems == 0 then
		return
	end
	
	for i = 1, numItems do
		local _, stationaryIcon, mailSender, mailSubject, mailMoney, _, daysLeft, numAttachments = GetInboxHeaderInfo(i);
		if numAttachments ~= nil then			-- treat attachments as separate entries
			for j = 1, 12 do		-- mandatory, loop through all 12 slots, since attachments could be anywhere (ex: slot 4,5,8)
				local item, mailIcon, itemCount = GetInboxItem(i, j)
				if item ~= nil then
					table.insert(c.mail, {
						icon = mailIcon,
						count = itemCount,
						link = GetInboxItemLink(i, j),
						sender = mailSender,
						lastcheck = time(),
						daysleft = daysLeft
					} )
				end
			end
		end

		local inboxText
		if AltoholicTabOptionsFrame3_ScanMailBody:GetChecked() then
			inboxText = GetInboxText(i)					-- this marks the mail as read
		end
		
		if (mailMoney > 0) or inboxText then			-- if there's money or text .. save the entry
			if mailMoney > 0 then
				mailIcon = "Interface\\Icons\\INV_Misc_Coin_01"
			else
				mailIcon = stationaryIcon
			end
			table.insert(c.mail, {
				icon = mailIcon,
				money = mailMoney,
				text = inboxText,
				subject = mailSubject,
				sender = mailSender,
				lastcheck = time(),
				daysleft = daysLeft
			} )
		end
	end
	
	table.sort(c.mail, function(a, b)		-- show mails with the lowest expiry first
		return a.daysleft < b.daysleft
	end)
end

-- *** Hooks ***

local Orig_SendMail = SendMail

function SendMail(recipient, subject, body, ...)
	for CharacterName, c in pairs(Altoholic.db.account.data[V.faction][V.realm].char) do
		if CharacterName == recipient then			-- if recipient is a known alt
			for k, v in pairs(V.Attachments) do		--  .. save attachments into his mailbox
				table.insert(c.mail, {
					icon = v.icon,
					link = v.link,
					count = v.count,
					sender = V.player,
					lastcheck = time(),
					daysleft = 30,
					realm = V.realm
				} )
			end
			
			-- .. then save the mail itself + gold if any
			local moneySent = GetSendMailMoney()
			if (moneySent > 0) or (strlen(body) > 0) then
				local mailIcon
				if moneySent > 0 then
					mailIcon = "Interface\\Icons\\INV_Misc_Coin_01"
				else
					mailIcon = "Interface\\Icons\\INV_Misc_Note_01"
				end
				table.insert(c.mail, {
					money = moneySent,
					icon = mailIcon,
					text = body,
					subject = subject,
					sender = V.player,
					lastcheck = time(),
					daysleft = 30,
					realm = V.realm
				} )
			end
			
			if (c.lastmailcheck == nil) or (c.lastmailcheck == 0) then
				-- if the alt has never checked his mail before, this value won't be correct, so set it to make sure expiry returns proper results.
				c.lastmailcheck = time()
			end
			
			table.sort(c.mail, function(a, b)		-- show mails with the lowest expiry first
				return a.daysleft < b.daysleft
			end)
			
			break
		end
	end
	Altoholic:ClearTable(V.Attachments)	
	Orig_SendMail(recipient, subject, body, ...)
end

-- *** EVENT HANDLERS ***

function Altoholic:MAIL_SHOW()
	CheckInbox()
	self:RegisterEvent("MAIL_INBOX_UPDATE")
	self:RegisterEvent("MAIL_SEND_INFO_UPDATE")
	V.Attachments = {}	-- create a temporary table to hold the attachments that will be sent, keep it local since the event is rare
	V.AllowMailUpdate = true
	V.isMailBoxOpen = true
end

function Altoholic:MAIL_CLOSED()
	V.isMailBoxOpen = nil
	-- the MAIL_CLOSED event is fired twice when the bank is closed, only take care of the 1st pass
	if V.mailclose == nil then		-- Closing bank, 1st pass, update the bags
		V.mailclose = 1
		self:UpdatePlayerMail()
		self.db.account.data[V.faction][V.realm].char[V.player].lastmailcheck = time()
		self:UpdatePlayerBags()
		self:UnregisterEvent("MAIL_INBOX_UPDATE");
		self:UnregisterEvent("MAIL_SEND_INFO_UPDATE");
	else									-- Closing bank, 2nd pass, do nothing
		V.mailclose = nil
	end
	V.Attachments = nil
end

function Altoholic:MAIL_INBOX_UPDATE()
	-- don't try to update mail if MAIL_SHOW did not happen, or if an update is already happening, only do it once
	if V.AllowMailUpdate then
		self:UpdatePlayerMail()
		V.AllowMailUpdate = false
	end
end

function Altoholic:MAIL_SEND_INFO_UPDATE()
	self:ClearTable(V.Attachments)

	for i=1, 12 do
		local name, itemIcon, itemCount = GetSendMailItem(i)
		if name ~= nil then								-- if attachment slot is not empty .. save it
			table.insert(V.Attachments, {
				icon = itemIcon,
				link = GetSendMailItemLink(i),
				count = itemCount
			} )
		end
	end
end
