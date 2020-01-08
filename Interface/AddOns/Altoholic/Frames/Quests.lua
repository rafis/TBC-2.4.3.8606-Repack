local L = AceLibrary("AceLocale-2.2"):new("Altoholic")
local V = Altoholic.vars

local WHITE		= "|cFFFFFFFF"
local RED		= "|cFFFF0000"
local GREEN		= "|cFF00FF00"
local TEAL		= "|cFF00FF9A"

function Altoholic:Quests_Update()
	local c = self.db.account.data[V.CurrentFaction][V.CurrentRealm].char[V.CurrentAlt]		-- current alt
	local VisibleLines = 14
	local frame = "AltoholicFrameQuests"
	local entry = frame.."Entry"
	
	if #c.questlog == 0 then
		AltoholicTabCharactersStatus:SetText(L["No quest found for "] .. V.CurrentAlt)
		self:ClearScrollFrame( _G[ frame.."ScrollFrame" ], entry, VisibleLines, 18)
		return
	end
	AltoholicTabCharactersStatus:SetText("")
	
	local offset = FauxScrollFrame_GetOffset( _G[ frame.."ScrollFrame" ] );
	local DisplayedCount = 0
	local VisibleCount = 0
	local DrawGroup
	local i=1
	
	for line, s in pairs(c.questlog) do
		if (offset > 0) or (DisplayedCount >= VisibleLines) then		-- if the line will not be visible
			if s.isHeader then													-- then keep track of counters
				if s.isCollapsed == false then
					DrawGroup = true
				else
					DrawGroup = false
				end
				VisibleCount = VisibleCount + 1
				offset = offset - 1		-- no further control, nevermind if it goes negative
			elseif DrawGroup then
				VisibleCount = VisibleCount + 1
				offset = offset - 1		-- no further control, nevermind if it goes negative
			end
		else		-- line will be displayed
			if s.isHeader then
				if s.isCollapsed == false then
					_G[ entry..i.."Collapse" ]:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up"); 
					DrawGroup = true
				else
					_G[ entry..i.."Collapse" ]:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up");
					DrawGroup = false
				end
				_G[entry..i.."Collapse"]:Show()
				_G[entry..i.."QuestLinkNormalText"]:SetText(TEAL .. s.name)
				_G[entry..i.."QuestLink"]:SetID(0)
				_G[entry..i.."QuestLink"]:SetPoint("TOPLEFT", 25, 0)
				
				_G[entry..i.."Tag"]:Hide()
				_G[entry..i.."Status"]:Hide()
				_G[entry..i.."Money"]:Hide()
				
				_G[ entry..i ]:SetID(line)
				_G[ entry..i ]:Show()
				i = i + 1
				VisibleCount = VisibleCount + 1
				DisplayedCount = DisplayedCount + 1
				
			elseif DrawGroup then
				_G[entry..i.."Collapse"]:Hide()
				
				local _, id, level = self:GetQuestDetails(s.link)
				_G[entry..i.."QuestLinkNormalText"]:SetText(WHITE .. "[" .. level .. "] " .. s.link)
				_G[entry..i.."QuestLink"]:SetID(line)
				_G[entry..i.."QuestLink"]:SetPoint("TOPLEFT", 15, 0)
				if s.tag then 
					_G[entry..i.."Tag"]:SetText(self:GetQuestTypeString(s.tag, s.groupsize))
					_G[entry..i.."Tag"]:Show()
				else
					_G[entry..i.."Tag"]:Hide()
				end
				
				if s.isComplete then
					if s.isComplete == 1 then
						_G[entry..i.."Status"]:SetText(GREEN .. COMPLETE)
					elseif s.isComplete == -1 then
						_G[entry..i.."Status"]:SetText(RED .. FAILED)
					end
					_G[entry..i.."Status"]:Show()
				else
					_G[entry..i.."Status"]:Hide()
				end
				
				if s.money then
					_G[entry..i.."Money"]:SetText(self:GetMoneyString(s.money))
					_G[entry..i.."Money"]:Show()
				else
					_G[entry..i.."Money"]:Hide()
				end
					
				_G[ entry..i ]:SetID(line)
				_G[ entry..i ]:Show()
				i = i + 1
				VisibleCount = VisibleCount + 1
				DisplayedCount = DisplayedCount + 1
			end
		end
	end 

	while i <= VisibleLines do
		_G[ entry..i ]:SetID(0)
		_G[ entry..i ]:Hide()
		i = i + 1
	end
	
	FauxScrollFrame_Update( _G[ frame.."ScrollFrame" ], VisibleCount, VisibleLines, 18);
end	

function Altoholic:GetQuestDetails(questString)
	if not questString then return nil end
	
	local _, _, questInfo, questName = strsplit("|", questString)
	local _, questId, questLevel = strsplit(":", questInfo)
	questName = string.sub(questName, 3, -2)

	return questName, questId, questLevel
end

function Altoholic:QuestLink_OnEnter(self)
	local id = self:GetID()
	if id == 0 then return end
	
	local r = Altoholic.db.account.data[V.CurrentFaction][V.CurrentRealm]
	local link = r.char[V.CurrentAlt].questlog[id].link
	if not link then return end

	GameTooltip:ClearLines();
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	GameTooltip:SetHyperlink(link);
	GameTooltip:AddLine(" ",1,1,1);
	
	local _, questID, level = Altoholic:GetQuestDetails(link)
	GameTooltip:AddDoubleLine(L["Level"] .. ": |cFF00FF9A" .. level, L["QuestID"] .. ": |cFF00FF9A" .. questID);
	
	local bOtherCharsOnQuest		-- is there at least one other char on the quest ?
	
	for CharacterName, c in pairs(r.char) do		-- browse all chars on this realm ..
		if CharacterName ~= V.CurrentAlt then		-- .. skip current char of course
			for index, q in pairs(c.questlog) do	-- parse all quests
				local _, altQuestID = Altoholic:GetQuestDetails(q.link)
				if altQuestID == questID then
					if not bOtherCharsOnQuest then
						GameTooltip:AddLine(" ",1,1,1);
						GameTooltip:AddLine(GREEN .. L["Are also on this quest:"],1,1,1);
						bOtherCharsOnQuest = true	-- pass here only once
					end
					GameTooltip:AddLine(Altoholic:GetClassColor(c.class) .. CharacterName,1,1,1);
				end
			end
		end
	end
	
	GameTooltip:Show();
end

function Altoholic:UpdateQuestLog()
	local q = self.db.account.data[V.faction][V.realm].char[UnitName("player")].questlog

	self:ClearTable(q)
	for i = GetNumQuestLogEntries(), 1, -1 do
		local _, _, _, _, isHeader, isCollapsed = GetQuestLogTitle(i);
		if isHeader and isCollapsed then
			ExpandQuestHeader(i)
		end
	end

	for i = 1, GetNumQuestLogEntries() do
		local title, _, questTag, groupSize, isHeader, _, isComplete = GetQuestLogTitle(i);
		if not isHeader then
			q[i].link = GetQuestLink(i)
			q[i].tag = questTag
			q[i].groupsize = groupSize
			q[i].isComplete = isComplete
			
			SelectQuestLogEntry(i);
			q[i].money= GetQuestLogRewardMoney();
		else
			q[i].name = title
			q[i].isHeader = true
		end
	end
end

-- *** EVENT HANDLERS ***

function Altoholic:UNIT_QUEST_LOG_CHANGED()		-- triggered when accepting/validating a quest .. but too soon to refresh data
	self:RegisterEvent("QUEST_LOG_UPDATE")			-- so register for this one ..
end

function Altoholic:QUEST_LOG_UPDATE()
	self:UnregisterEvent("QUEST_LOG_UPDATE")		-- .. and unregister it right away, since we only want it to be processed once (and it's triggered way too often otherwise)
	self:UpdateQuestLog()	
end
