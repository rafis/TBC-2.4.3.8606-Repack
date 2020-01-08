local BI = LibStub("LibBabble-Inventory-3.0"):GetLookupTable()
local L = AceLibrary("AceLocale-2.2"):new("Altoholic")
local V = Altoholic.vars

local INFO_REALM_LINE = 1
local INFO_CHARACTER_LINE = 2
local INFO_TOTAL_LINE = 3
local LEVEL_CAP = 70

local TEAL		= "|cFF00FF9A"
local WHITE		= "|cFFFFFFFF"
local GOLD		= "|cFFFFD700"
local GREEN		= "|cFF00FF00"

local VIEW_BAGS = 1
local VIEW_ALLINONE = 2
local VIEW_MAILS = 3
local VIEW_QUESTS = 4
local VIEW_AUCTIONS = 5
local VIEW_BIDS = 6

function Altoholic:AccountSummary_Update()
	local VisibleLines = 14
	local frame = "AltoholicFrameSummary"
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
				_G[entry..i.."Name"]:SetWidth(210)
				_G[entry..i.."LevelNormalText"]:SetText("")
				_G[entry..i.."Talents"]:SetText("")
				_G[entry..i.."Money"]:SetText("")
				_G[entry..i.."Played"]:SetText("")
				_G[entry..i.."Rested"]:SetText("")
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
					_G[entry..i.."Talents"]:SetText(c.talent)
					_G[entry..i.."Money"]:SetText(self:GetMoneyString(c.money))
					_G[entry..i.."Played"]:SetText(self:GetTimeString(c.played))
					
					if c.level == LEVEL_CAP then
						_G[entry..i.."Rested"]:SetText(L["No rest XP"])
					else
						if s.name == V.player then
							_G[entry..i.."Rested"]:SetText( self:GetRestedXP(c.xpmax, c.restxp, 0, c.isResting) )
						else
							_G[entry..i.."Rested"]:SetText( self:GetRestedXP(c.xpmax, c.restxp, c.lastlogout, c.isResting) )
						end
					end
					
				elseif (s.linetype == INFO_TOTAL_LINE) then
					_G[entry..i.."Collapse"]:Hide()
					_G[entry..i.."Name"]:SetText(L["Totals"])
					_G[entry..i.."Name"]:SetJustifyH("LEFT")
					_G[entry..i.."Name"]:SetPoint("TOPLEFT", 15, 0)
					_G[entry..i.."Name"]:SetWidth(70)
					_G[entry..i.."LevelNormalText"]:SetText(s.level)
					_G[entry..i.."LevelNormalText"]:SetJustifyH("RIGHT")
					_G[entry..i.."Talents"]:SetText("")
					_G[entry..i.."Money"]:SetText(s.money)
					_G[entry..i.."Money"]:SetTextColor(1.0, 1.0, 1.0)
					_G[entry..i.."Played"]:SetText(s.played)
					_G[entry..i.."Rested"]:SetText("")
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

function Altoholic_AccountSummaryLevel_OnEnter(self)
	local line = self:GetParent():GetID()
	local s = Altoholic.CharacterInfo[line]
	
	if s.linetype ~= INFO_CHARACTER_LINE then		
		return
	end
	
	local Faction, Realm = Altoholic:GetCharacterInfo(line)
	local c = Altoholic.db.account.data[Faction][Realm].char[s.name]
	local suggestion = Altoholic:GetSuggestion("Leveling", c.level)
	
	AltoTooltip:ClearLines();
	AltoTooltip:SetOwner(self, "ANCHOR_RIGHT");
	
	AltoTooltip:AddLine(Altoholic:GetClassColor(c.class) .. s.name,1,1,1);
	AltoTooltip:AddLine(L["Level"] .. " " .. GREEN .. c.level .. " |r".. c.race .. " " .. c.class,1,1,1);
	AltoTooltip:AddLine(L["Zone"] .. ": " .. GOLD .. c.zone .. " |r(" .. GOLD .. c.subzone .."|r)",1,1,1);	
	AltoTooltip:AddLine(EXPERIENCE_COLON .. " " 
				.. GREEN .. c.xp .. WHITE .. "/" 
				.. GREEN .. c.xpmax .. WHITE .. " (" 
				.. GREEN .. floor((c.xp / c.xpmax) * 100) .. "%"
				.. WHITE .. ")",1,1,1);	
	
	if c.restxp then
		AltoTooltip:AddLine(L["Rest XP"] .. ": " .. GREEN .. c.restxp,1,1,1);
	end
	
	if suggestion then
		AltoTooltip:AddLine(" ",1,1,1);
		AltoTooltip:AddLine(L["Suggested leveling zone: "],1,1,1);
		AltoTooltip:AddLine(TEAL .. suggestion,1,1,1);
	end

	-- parse saved instances
	local bLineBreak = true
	for InstanceName, InstanceInfo in pairs (c.SavedInstance) do
		if bLineBreak then
			AltoTooltip:AddLine(" ",1,1,1);		-- add a line break only once
			bLineBreak = nil
		end
	
		if type(InstanceInfo) == "string" then		-- temporary check, can be removed in .014, this is for players who might have saved instance data stored as table
			local id, reset, lastcheck = strsplit("|", InstanceInfo)
			reset = tonumber(reset)
			lastcheck = tonumber(lastcheck)
			local expiresIn = reset - (time() - lastcheck)
			
			if expiresIn > 0 then
				AltoTooltip:AddDoubleLine(GOLD .. InstanceName .. 
					" (".. WHITE.."ID: " .. GREEN .. id .. "|r)", Altoholic:GetTimeString(expiresIn))
			end
		end
	end
	
	-- add PVP info if any
	AltoTooltip:AddLine(" ",1,1,1);
	AltoTooltip:AddDoubleLine(WHITE.. L["Arena points: "] .. GREEN .. c.pvp_ArenaPoints, "HK: " .. GREEN .. c.pvp_hk )
	AltoTooltip:AddDoubleLine(WHITE.. L["Honor points: "] .. GREEN .. c.pvp_HonorPoints, "DK: " .. GREEN .. c.pvp_dk )
	
	AltoTooltip:Show();
end

function Altoholic_AccountSummaryLevel_OnClick(self, button)
	local line = self:GetParent():GetID()
	if line == 0 then return end

	local s = Altoholic.CharacterInfo[line]
	if s.linetype ~= INFO_CHARACTER_LINE then		
		return
	end
	
	if button == "RightButton" then
		V.CharInfoLine = line	-- line containing info about the alt on which action should be taken (delete, ..)
		ToggleDropDownMenu(1, nil, AltoholicFrameSummaryRightClickMenu, self:GetName(), 0, -5);
		return
	elseif button == "LeftButton" then
		V.CurrentFaction, V.CurrentRealm = Altoholic:GetCharacterInfo(line)
		V.CurrentAlt = s.name

		AltoholicTabCharacters:SelectCharDropDown_Initialize()
		UIDropDownMenu_SetSelectedValue(AltoholicTabCharacters_SelectChar, V.CurrentAlt)
		
		Altoholic:Tab_OnClick(2)
		AltoholicTabCharacters:ViewCharInfo(VIEW_BAGS)
	end
end

function Summary_RightClickMenu_OnLoad()
	local info = UIDropDownMenu_CreateInfo(); 

	info.text		= L["View bags"]
	info.value		= VIEW_BAGS
	info.func		= Altoholic_ViewAltInfo;
	UIDropDownMenu_AddButton(info, 1); 
	
	info.text		= L["View bags"] .. " (" .. L["All-in-one"] .. ")"
	info.value		= VIEW_ALLINONE
	info.func		= Altoholic_ViewAltInfo;
	UIDropDownMenu_AddButton(info, 1); 

	info.text		= L["View mailbox"]
	info.value		= VIEW_MAILS
	info.func		= Altoholic_ViewAltInfo;
	UIDropDownMenu_AddButton(info, 1); 
	
	info.text		= L["View quest log"]
	info.value		= VIEW_QUESTS
	info.func		= Altoholic_ViewAltInfo;
	UIDropDownMenu_AddButton(info, 1); 
	
	info.text		= L["View auctions"]
	info.value		= VIEW_AUCTIONS
	info.func		= Altoholic_ViewAltInfo;
	UIDropDownMenu_AddButton(info, 1); 

	info.text		= L["View bids"]
	info.value		= VIEW_BIDS
	info.func		= Altoholic_ViewAltInfo;
	UIDropDownMenu_AddButton(info, 1); 	
	
	info.text		= L["Delete this Alt"]
	info.func		= Altoholic_DeleteAlt;
	UIDropDownMenu_AddButton(info, 1); 
end

function Altoholic_ViewAltInfo()
	local line = V.CharInfoLine
	V.CharInfoLine = nil
	
	V.CurrentFaction, V.CurrentRealm = Altoholic:GetCharacterInfo(line)
	V.CurrentAlt = Altoholic.CharacterInfo[line].name

	UIDropDownMenu_SetSelectedValue(AltoholicTabCharacters_SelectRealm, V.CurrentFaction .."|".. V.CurrentRealm)
	UIDropDownMenu_SetText(V.CurrentRealm, AltoholicTabCharacters_SelectRealm)
	AltoholicTabCharacters:SelectCharDropDown_Initialize()
	UIDropDownMenu_SetSelectedValue(AltoholicTabCharacters_SelectChar, V.CurrentAlt)

	Altoholic:Tab_OnClick(2)
	AltoholicTabCharacters:ViewCharInfo(this.value)
end

function Altoholic_DeleteAlt()
	local line = V.CharInfoLine
	V.CharInfoLine = nil
	
	local s = Altoholic.CharacterInfo[line] -- no validity check, this comes from the dropdownmenu, it's been secured earlier
	local AltName = s.name
	local Faction, Realm = Altoholic:GetCharacterInfo(line)
	local r = Altoholic.db.account.data[Faction][Realm]
	
	if (Faction == V.faction) and	(Realm == V.realm) and (AltName == V.player) then
		DEFAULT_CHAT_FRAME:AddMessage(TEAL .. "Altoholic: " .. WHITE .. L["Cannot delete current character"])
		return
	end
	
	-- delete factions
	for RepName, RepTable in pairs(r.reputation) do
		RepTable[s.name] = nil
	end
	
	-- delete the character
	Altoholic:ClearTable(r.char[s.name])	-- clear all content for this char ..
	r.char[s.name] = nil							-- .. then the char entry itself
	
	local charCount = 0
	for _, _ in pairs(r.char) do
		charCount = charCount + 1
	end
	
	if charCount == 0 then		-- if no more chars on this realm, the realm can be deleted ..
		Altoholic:ClearTable(Altoholic.db.account.data[Faction][Realm])
		Altoholic.db.account.data[Faction][Realm] = nil
	end
	
	local realmCount = 0			
	for _, _ in pairs(Altoholic.db.account.data[Faction]) do
		realmCount = realmCount + 1
	end

	if realmCount == 0 then		-- if no more realms in this faction, the faction can be deleted ..
		Altoholic:ClearTable(Altoholic.db.account.data[Faction])
		Altoholic.db.account.data[Faction] = nil
	end	
	
	Altoholic:BuildCharacterInfoTable()		-- rebuild the main character table, and all the menus
	Altoholic:BuildFactionsTable()
	Altoholic:AccountSummary_Update()
	
	DEFAULT_CHAT_FRAME:AddMessage(TEAL .. "Altoholic: " 
		.. WHITE .. format( L["Character %s successfully deleted"], AltName))
end
