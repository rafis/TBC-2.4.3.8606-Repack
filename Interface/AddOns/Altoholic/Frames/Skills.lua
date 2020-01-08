local BI = LibStub("LibBabble-Inventory-3.0"):GetLookupTable()
local L = AceLibrary("AceLocale-2.2"):new("Altoholic")
local V = Altoholic.vars

local INFO_REALM_LINE = 1
local INFO_CHARACTER_LINE = 2
local INFO_TOTAL_LINE = 3

local WHITE		= "|cFFFFFFFF"
local TEAL		= "|cFF00FF9A"
local RED		= "|cFFFF0000"
local ORANGE	= "|cFFFF7F00"
local YELLOW	= "|cFFFFFF00"
local GREEN		= "|cFF00FF00"

function Altoholic:Skills_Update()
	local VisibleLines = 14
	local frame = "AltoholicFrameSkills"
	local entry = frame.."Entry"
	
	if #self.CharacterInfo == 0 then
		self:ClearScrollFrame( _G[ frame.."ScrollFrame" ], entry, VisibleLines, 18)
		return
	end
	
	local offset = FauxScrollFrame_GetOffset( _G[ frame.."ScrollFrame" ] );
	local DisplayedCount = 0
	local VisibleCount = 0
	local DrawRealm
	local CurrentFaction, CurrentRealm
	local i=1
	
	for line, s in pairs(self.CharacterInfo) do
		if (offset > 0) or (DisplayedCount >= VisibleLines) then		-- if the line will not be visible
			if s.linetype == INFO_REALM_LINE then								-- then keep track of counters
				CurrentFaction = s.faction
				CurrentRealm = s.realm
				if s.isCollapsed == false then
					DrawRealm = true
				else
					DrawRealm = false
				end
				VisibleCount = VisibleCount + 1
				offset = offset - 1		-- no further control, nevermind if it goes negative
			elseif DrawRealm then
				VisibleCount = VisibleCount + 1
				offset = offset - 1		-- no further control, nevermind if it goes negative
			end
		else		-- line will be displayed
			if s.linetype == INFO_REALM_LINE then
				CurrentFaction = s.faction
				CurrentRealm = s.realm
				if s.isCollapsed == false then
					_G[ entry..i.."Collapse" ]:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up"); 
					DrawRealm = true
				else
					_G[ entry..i.."Collapse" ]:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up");
					DrawRealm = false
				end
				_G[entry..i.."Collapse"]:Show()
				_G[entry..i.."Name"]:SetText(self:GetFullRealmString(s.faction, s.realm))
				_G[entry..i.."Name"]:SetJustifyH("LEFT")
				_G[entry..i.."Name"]:SetPoint("TOPLEFT", 25, 0)
				_G[entry..i.."Name"]:SetWidth(190)
				_G[entry..i.."LevelNormalText"]:SetText("")
				_G[entry..i.."LevelNormalText"]:SetWidth(10)
				_G[entry..i.."Level"]:SetWidth(10)
				_G[entry..i.."Skill1NormalText"]:SetText(WHITE .. L["Prof. 1"])
				_G[entry..i.."Skill2NormalText"]:SetText(WHITE .. L["Prof. 2"])
				_G[entry..i.."CookingNormalText"]:SetText(WHITE .. BI["Cooking"])
				_G[entry..i.."FirstAidNormalText"]:SetText(WHITE .. BI["First Aid"])
				_G[entry..i.."FishingNormalText"]:SetText(WHITE .. BI["Fishing"])
				_G[entry..i.."RidingNormalText"]:SetText(WHITE .. L["Riding"])
				_G[ entry..i ]:SetID(line)
				_G[ entry..i ]:Show()
				i = i + 1
				VisibleCount = VisibleCount + 1
				DisplayedCount = DisplayedCount + 1
			elseif DrawRealm then
				if (s.linetype == INFO_CHARACTER_LINE) then
					local c = self.db.account.data[CurrentFaction][CurrentRealm].char[s.name]
					local color = self:GetClassColor(c.class)
				
					_G[entry..i.."Collapse"]:Hide()
					_G[entry..i.."Name"]:SetText(color .. s.name)
					_G[entry..i.."Name"]:SetJustifyH("RIGHT")
					_G[entry..i.."Name"]:SetPoint("TOPLEFT", 15, 0)
					_G[entry..i.."Name"]:SetWidth(70)
					_G[entry..i.."LevelNormalText"]:SetText(color .. "Lv |cFF00FF00" .. c.level .. color .. " " .. c.race .. " " .. c.class)
					_G[entry..i.."LevelNormalText"]:SetJustifyH("LEFT")
					_G[entry..i.."LevelNormalText"]:SetWidth(140)
					_G[entry..i.."Level"]:SetWidth(140)
					_G[entry..i.."Skill1NormalText"]:SetText(self:GetSkillColor(s.skillRank1) .. s.skillRank1)
					_G[entry..i.."Skill2NormalText"]:SetText(self:GetSkillColor(s.skillRank2) .. s.skillRank2)
					_G[entry..i.."CookingNormalText"]:SetText(self:GetSkillColor(s.cooking) .. s.cooking)
					_G[entry..i.."FirstAidNormalText"]:SetText(self:GetSkillColor(s.firstaid) .. s.firstaid)
					_G[entry..i.."FishingNormalText"]:SetText(self:GetSkillColor(s.fishing) .. s.fishing)
					_G[entry..i.."RidingNormalText"]:SetText(self:GetSkillColor(s.riding) .. s.riding)
				elseif (s.linetype == INFO_TOTAL_LINE) then
					_G[entry..i.."Collapse"]:Hide()
					_G[entry..i.."Name"]:SetText(L["Totals"])
					_G[entry..i.."Name"]:SetJustifyH("LEFT")
					_G[entry..i.."Name"]:SetPoint("TOPLEFT", 15, 0)
					_G[entry..i.."Name"]:SetWidth(70)
					_G[entry..i.."LevelNormalText"]:SetText(s.level)
					_G[entry..i.."LevelNormalText"]:SetJustifyH("RIGHT")
					_G[entry..i.."LevelNormalText"]:SetWidth(140)
					_G[entry..i.."Level"]:SetWidth(140)
					_G[entry..i.."Skill1NormalText"]:SetText("")
					_G[entry..i.."Skill2NormalText"]:SetText("")
					_G[entry..i.."CookingNormalText"]:SetText("")
					_G[entry..i.."FirstAidNormalText"]:SetText("")
					_G[entry..i.."FishingNormalText"]:SetText("")
					_G[entry..i.."RidingNormalText"]:SetText("")
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

function Altoholic_Skill_OnEnter(self)
	local line = self:GetParent():GetID()
	local s = Altoholic.CharacterInfo[line]
	
	if s.linetype ~= INFO_CHARACTER_LINE then		
		return
	end
	
	local id = self:GetID()
	local skill, rank, suggestion
	local Faction, Realm = Altoholic:GetCharacterInfo(line)
	local c = Altoholic.db.account.data[Faction][Realm].char[s.name]

	local curRank, maxRank
	
	if id == 1 then
		skill = s.skillName1
		curRank, maxRank = Altoholic:GetSkillInfo( c.skill[L["Professions"]][skill] )
	elseif id == 2 then
		skill = s.skillName2
		curRank, maxRank = Altoholic:GetSkillInfo( c.skill[L["Professions"]][skill] )
	elseif id == 3 then
		skill = BI["Cooking"]
		curRank, maxRank = Altoholic:GetSkillInfo( c.skill[L["Secondary Skills"]][BI["Cooking"]] )
	elseif id == 4 then
		skill = BI["First Aid"]
		curRank, maxRank = Altoholic:GetSkillInfo( c.skill[L["Secondary Skills"]][BI["First Aid"]] )
	elseif id == 5 then
		skill = BI["Fishing"]
		curRank, maxRank = Altoholic:GetSkillInfo( c.skill[L["Secondary Skills"]][BI["Fishing"]] )
	elseif id == 6 then
		skill = L["Riding"]
		curRank, maxRank = Altoholic:GetSkillInfo( c.skill[L["Secondary Skills"]][L["Riding"]] )
	end
	
	if (id >= 1) and (id <= 6) then
		rank = Altoholic:GetSkillColor(curRank) .. curRank .. "/" .. maxRank
		suggestion = Altoholic:GetSuggestion(skill, curRank)
	elseif id == 7 then	-- class
		if c.class ~= L["Rogue"] then
			return
		end
		skill = L["Rogue Proficiencies"]
		
		local curLock, maxLock = Altoholic:GetSkillInfo( c.skill["Class Skills"][L["Lockpicking"]] )
		local curPois, maxPois = Altoholic:GetSkillInfo( c.skill["Class Skills"][L["Poisons"]] )
		rank = TEAL .. L["Lockpicking"] .. " " .. curLock .. "/" .. maxLock .. "\n" 
						.. L["Poisons"] .. " " .. curPois .. "/" .. maxPois
		suggestion = Altoholic:GetSuggestion(L["Lockpicking"], curLock)
	end
	
	AltoTooltip:ClearLines();
	AltoTooltip:SetOwner(self, "ANCHOR_RIGHT");
	AltoTooltip:AddLine(skill,1,1,1);
	AltoTooltip:AddLine(GREEN..rank,1,1,1);
	AltoTooltip:AddLine(" ",1,1,1);
	AltoTooltip:AddLine(RED .. RED_GEM .. "|r " .. L["up to"] .. " 149",1,1,1);
	AltoTooltip:AddLine(ORANGE .. BI["Orange"] .. "|r " .. L["up to"] .. " 299",1,1,1);
	AltoTooltip:AddLine(YELLOW .. YELLOW_GEM .. "|r " .. L["up to"] .. " 374",1,1,1);
	AltoTooltip:AddLine(GREEN .. BI["Green"] .. "|r " .. L["at"] .. " 375 " .. L["and above"],1,1,1);
	if suggestion then
		AltoTooltip:AddLine(" ",1,1,1);
		AltoTooltip:AddLine(L["Suggestion"] .. ": ",1,1,1);
		AltoTooltip:AddLine(TEAL .. suggestion,1,1,1);
	end
	
	-- parse profession cooldowns
	local bLineBreak = true
	for k, v in pairs(c.ProfessionCooldowns) do
		if bLineBreak then
			AltoTooltip:AddLine(" ",1,1,1);		-- add a line break only once
			bLineBreak = nil
		end
		
		local skillName, itemID = strsplit("-", k)		-- keys are like : ["Tailoring-21845"] = "315459.769|1211033170"
		if skill == skillName	then		-- if we're on the right tradeskill ..
			local reset, lastcheck = strsplit("|", v)
			reset = tonumber(reset)
			lastcheck = tonumber(lastcheck)
			local expiresIn = reset - (time() - lastcheck)
			
			if expiresIn > 0 then
				AltoTooltip:AddDoubleLine(select(2, GetItemInfo(itemID) ), Altoholic:GetTimeString(expiresIn));
			end
		end
	end
	
	AltoTooltip:Show();
end

function Altoholic:GetSkillInfo(skillString)
	-- from "200/225", returns the numeric values
	if type(skillString) ~= "string" then
		return 0, 0
	end
	
	local rank, maxRank = strsplit("|", skillString)
	return tonumber(rank), tonumber(maxRank)
end

function Altoholic:UpdateTradeSkill(tradeskillName)
	local c = self.db.account.data[V.faction][V.realm].char[V.player]		-- this char
	local r = c.recipes[tradeskillName].list

	local invSlots = { GetTradeSkillInvSlots() }
	for k, v in pairs (invSlots) do
		SetTradeSkillInvSlotFilter(k, 1)
	end
	
	local subClasses = { GetTradeSkillSubClasses() }
	for k, v in pairs (subClasses) do
		SetTradeSkillSubClassFilter(k, 1)
	end

	if GetNumTradeSkills() < #r then return end

	self:ClearTable(r)
	for i = GetNumTradeSkills(), 1, -1 do		-- 1st pass, expand all categories
		local _, skillType, _, isExpanded  = GetTradeSkillInfo(i)
		if (skillType == "header") and (isExpanded ~= true)  then
			ExpandTradeSkillSubClass(i)
		end
	end
	
	for k, v in pairs(c.ProfessionCooldowns) do
		local skill = strsplit("-", k)		-- keys are like : ["Tailoring-21845"] = "315459.769|1211033170"
		if skill == tradeskillName	then		-- if we're on the right tradeskill .. clear this entry, as it will be refreshed a bit further in this method
			v = nil
		end
	end
	
	local bScanFailed = false
	for i = 1, GetNumTradeSkills() do
		local skillName, skillType = GetTradeSkillInfo(i)

		if skillType == "header" then
			r[i].name = skillName
			r[i].isHeader = true
		else
			r[i].link = GetTradeSkillRecipeLink(i)
			local itemLink = GetTradeSkillItemLink(i)		-- in certain cases, scanning the item link will fail
			if not itemLink then				-- this usually happens  after a patch, when the local skills  cache has been reset
				bScanFailed = true
				break
			end
			r[i].id = self:GetIDFromLink(itemLink)

			local cooldown = GetTradeSkillCooldown(i)
			if cooldown then
				c.ProfessionCooldowns[ tradeskillName .. "-" .. r[i].id ] = cooldown .. "|" .. time()
			end
			
			local numReagents = GetTradeSkillNumReagents(i)
			local s = ""
			for j=1, numReagents do
				local _, _, reagentCount = GetTradeSkillReagentInfo(i, j);
				local link = GetTradeSkillReagentItemLink(i, j)
				if link then
					s = s .. self:GetIDFromLink( link ) .. ":" .. reagentCount .. "|"
				else	-- when the trading skill window is opened, this should never happen, if it does, let the user known
					bScanFailed = true
				end
			end
			r[i].reagents = string.sub(s, 1, -2)
		end
	end
	c.recipes[tradeskillName].ScanFailed = bScanFailed
	
	if bScanFailed then
		DEFAULT_CHAT_FRAME:AddMessage(TEAL .. "Altoholic: " .. WHITE .. L["At least one recipe could not be read"])
		DEFAULT_CHAT_FRAME:AddMessage(TEAL .. "Altoholic: " .. YELLOW .. L["Please open this window again"])
	end
end

function Altoholic:UpdateCraft(tradeskillName)
	if tradeskillName == L["Beast Training"] then return end
	
	local c = self.db.account.data[V.faction][V.realm].char[V.player]		-- this char
	local r = c.recipes[tradeskillName].list

	-- Until I find the name of the functions that deal with filters in this window, let's filter based on the content
	if GetNumCrafts() < #r then return end
	
	self:ClearTable(r)
	for i = GetNumCrafts(), 1, -1 do		-- 1st pass, expand all categories
		local _, _, craftType, _, isExpanded = GetCraftInfo(i)
		if (craftType == "header") and (isExpanded ~= true)  then
			ExpandCraftSkillLine(i)
		end
	end
	
	for k, v in pairs(c.ProfessionCooldowns) do
		local skill = strsplit("-", k)		-- keys are like : ["Tailoring-21845"] = "315459.769|1211033170"
		if skill == tradeskillName	then		-- if we're on the right tradeskill .. clear this entry, as it will be refreshed a bit further in this method
			v = nil
		end
	end
	
	local bScanFailed = false
	for i = 1, GetNumCrafts() do
		local craftName, _, craftType = GetCraftInfo(i)

		if craftType == "header" then
			r[i].name = craftName
			r[i].isHeader = true
		else
			r[i].link = GetCraftRecipeLink(i)
			local itemLink = GetCraftItemLink(i)
			if not itemLink then
				bScanFailed = true
				break
			end
			r[i].id = self:GetIDFromLink(itemLink)

			local cooldown = GetCraftCooldown(i)
			if cooldown then
				c.ProfessionCooldowns[ tradeskillName .. "-" .. r[i].id ] = cooldown .. "|" .. time()
			end
			
			local numReagents = GetCraftNumReagents(i)
			local s = ""

			for j=1, numReagents do
				local _, _, reagentCount = GetCraftReagentInfo(i, j);
				local link = GetCraftReagentItemLink(i, j)
				if link then
					s = s .. self:GetIDFromLink( link ) .. ":" .. reagentCount .. "|"
				else	-- when the trading skill window is opened, this should never happen, if it does, let the user known
					bScanFailed = true
				end
			end
			r[i].reagents = string.sub(s, 1, -2)
			
		end
	end
	
	c.recipes[tradeskillName].ScanFailed = bScanFailed
	if bScanFailed then
		DEFAULT_CHAT_FRAME:AddMessage(TEAL .. "Altoholic: " .. WHITE .. L["At least one recipe could not be read"])
		DEFAULT_CHAT_FRAME:AddMessage(TEAL .. "Altoholic: " .. YELLOW .. L["Please open this window again"])
	end
end

-- *** Hooks ***

local Orig_DoTradeSkill = DoTradeSkill

function DoTradeSkill(index, repeatCount, ...)
	Orig_DoTradeSkill(index, repeatCount, ...)
	Altoholic:RegisterEvent("TRADE_SKILL_UPDATE")
end

local Orig_DoCraft = DoCraft

function DoCraft(index, ...)
	Orig_DoCraft(index, ...)
	Altoholic:RegisterEvent("CRAFT_UPDATE")
end

-- *** EVENT HANDLERS ***

function Altoholic:TRADE_SKILL_SHOW()
	self:UpdateTradeSkill(GetTradeSkillLine())
	V.isTradeSkillWindowOpen = true
end

function Altoholic:TRADE_SKILL_UPDATE()
	-- The hook in DoTradeSkill will register this event so that we only update skills once.
	-- unregister it before calling the update, or the event will be called recursively (due to expand/collapse)
	self:UnregisterEvent("TRADE_SKILL_UPDATE")
	self:UpdateTradeSkill(GetTradeSkillLine())
end

function Altoholic:TRADE_SKILL_CLOSE()
	if self:IsEventRegistered("TRADE_SKILL_UPDATE") then
		self:UnregisterEvent("TRADE_SKILL_UPDATE")
	end
	if V.isTradeSkillWindowOpen then
		self:UpdatePlayerSkills()
	end
	V.isTradeSkillWindowOpen = nil
end

function Altoholic:CRAFT_SHOW()
	self:UpdateCraft(GetCraftName())
	V.isCraftWindowOpen = true
end

function Altoholic:CRAFT_UPDATE()
	self:UnregisterEvent("CRAFT_UPDATE")
	self:UpdateCraft(GetCraftName())
end

function Altoholic:CRAFT_CLOSE()
	if self:IsEventRegistered("CRAFT_UPDATE") then
		self:UnregisterEvent("CRAFT_UPDATE")
	end
	if V.isCraftWindowOpen then
		self:UpdatePlayerSkills()
	end
	V.isCraftWindowOpen = nil
end
