local chatRate = 2 -- limit to 2 msg/sec
local channelName = "wQueue"
local filterEnabled = true -- chat filter

local isHost = false
local hostedCategory = ""
local realHostedCategory = ""
local playersQueued = {}
local chatQueue = {}
local groups = {}

local wQueueFrame = {}
local catListButtons = {}
local wQueueFrameShown = false
local selectedQuery = ""
local selectedCat = ""
local isWaitListShown = false

local categories = {}
local hostListButtons = {}
local hostListFrame
local categoryListFrame
local infoFrame = {}
local catListHidden = {}
local catListHiddenBot = {}
local waitingList = {}
local realScroll = false
local findTimer = 0
local miniDrag = false
local leaderMessages = {}
local playerMessages = {}
local whoRequestList = {}
local newGroups = {}
local fixingChat = false
local lastUpdate = 0
local whoRequestTimer = 0
local idleMessage = 0

local tankSelected = false
local healerSelected = false
local damageSelected = false

local wQueueColors = {
}
wQueueColors["WHITE"] = {
	247/255, --r
	235/255, --g
	233/255 --b
}
wQueueColors["YELLOW"] = {
	209/255, --r
	164/255, --g
	29/255 --b
}
wQueueColors["GREEN"] = {
	79/255,
	247/255,
	93/255
}

local hostOptions = {}

wQueue = AceLibrary("AceAddon-2.0"):new("AceHook-2.1")

function valtohex(num)
	if num == 0 then return "00"
	else return string.format("%x",num*255)
	end
end

function table_print (tt, indent, done)
  done = done or {}
  indent = indent or 0
  if type(tt) == "table" then
    local sb = {}
    for key, value in pairs (tt) do
      table.insert(sb, string.rep (" ", indent)) -- indent it
      if type (value) == "table" and not done [value] then
        done [value] = true
        table.insert(sb, "{\n");
        table.insert(sb, table_print (value, indent + 2, done))
        table.insert(sb, string.rep (" ", indent)) -- indent it
        table.insert(sb, "}\n");
      elseif "number" == type(key) then
        table.insert(sb, string.format("\"%s\"\n", tostring(value)))
      else
        table.insert(sb, string.format(
            "%s = \"%s\"\n", tostring (key), tostring(value)))
       end
    end
    return table.concat(sb)
  else
    return tt .. "\n"
  end
end

function to_string( tbl )
    if  "nil"       == type( tbl ) then
        return tostring(nil)
    elseif  "table" == type( tbl ) then
        return table_print(tbl)
    elseif  "string" == type( tbl ) then
        return tbl
    else
        return tostring(tbl)
    end
end

function Wholefind(Search_string, Word)
 _, F_result = string.gsub(Search_string, '%f[%a]'..Word..'%f[%A]',"")
 return F_result
end

function addToSet(set, key)
    set[key] = true
end

function removeFromSet(set, key)
	set[key] = nil
end

function setContains(set, key)
    return set[key] ~= nil
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function round(num)
    under = math.floor(num)
    upper = math.floor(num) + 1
    underV = -(under - num)
    upperV = upper - num
    if (upperV > underV) then
        return under
    else
        return upper
    end
end

function split(pString, pPattern)
   local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pPattern
   local last_end = 1
   local s, e, cap = string.find(pString, fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
		table.insert(Table,cap)
      end
      last_end = e+1
      s, e, cap = string.find(pString, fpat, last_end)
   end
   if last_end <= string.len(pString) then
      cap = string.sub(pString, last_end)
      table.insert(Table, cap)
   end
   return Table
end

function wQueue:OnInitialize()
	for i = NUM_CHAT_WINDOWS, 1, -1 do
		self:SecureHook(getglobal("ChatFrame"..i), "AddMessage")
	end
end

function wQueue:AddMessage(frame, text, r, g, b, id)
	local channelId = GetChannelName(channelName)
	local blockMsg = false
	if event == nil then event = "CHAT_MSG_NONE" end
	if wQueueOptions["filter"] and strfind(event,"CHAT_MSG_CHANNEL") then
		arg9 = string.lower(arg9)
		if not wQueueOptions["onlylfg"] then
			if wQueueOptions["general"] and arg9 == "general - " .. string.lower(GetRealZoneText()) and GetChannelName("General - " .. GetRealZoneText()) ~= 0 then blockMsg = true end
			if wQueueOptions["trade"] and arg9 == "trade - city" and GetChannelName("Trade - City") ~= 0 then blockMsg = true end
			if wQueueOptions["lfg"] and arg9 == "lookingforgroup" and GetChannelName("LookingForGroup") ~= 0 then blockMsg = true end
			if wQueueOptions["global"] and arg9 == "global" and GetChannelName("global") ~= 0 then blockMsg = true end
			if wQueueOptions["world"] and arg9 == "world" and GetChannelName("world") ~= 0 then blockMsg = true end
		elseif wQueueOptions["onlylfg"] then
			local foundArg = false
			local noPunc = filterPunctuation(tostring(text))
			for k, v in pairs(getglobal("LFMARGS")) do
				if Wholefind(noPunc, v) > 0 then foundArg = true end
			end
			for k, v in pairs(getglobal("LFGARGS")) do
				if Wholefind(noPunc, v) > 0 then foundArg = true end
			end
			if foundArg then
				foundArg = false
				for kCat, kVal in pairs(getglobal("CATARGS")) do
					for kkCat, kkVal in pairs(kVal) do
						if Wholefind(noPunc, kkVal) > 0 then foundArg = true end
					end
				end
			end
			if foundArg then
				if wQueueOptions["general"] and arg9 == "general - " .. string.lower(GetRealZoneText()) and GetChannelName("General - " .. GetRealZoneText()) ~= 0 then blockMsg = true end
				if wQueueOptions["trade"] and arg9 == "trade - city" and GetChannelName("Trade - City") ~= 0 then blockMsg = true end
				if wQueueOptions["lfg"] and arg9 == "lookingforgroup" and GetChannelName("LookingForGroup") ~= 0 then blockMsg = true end
				if wQueueOptions["global"] and arg9 == "global" and GetChannelName("global") ~= 0 then blockMsg = true end
				if wQueueOptions["world"] and arg9 == "world" and GetChannelName("world") ~= 0 then blockMsg = true end
			end
		end
	end
	if strfind(event,"CHAT_MSG_CHANNEL") or strfind(event, "CHAT_MSG_CHANNEL_JOIN") or strfind(event, "CHAT_MSG_CHANNEL_LEAVE") or strfind(event, "CHAT_MSG_CHANNEL_NOTICE") then
		arg9 = string.lower(arg9)
		if (strfind(arg9, channelName)) and filterEnabled then
			blockMsg = true
		end
	end
	if (Wholefind(tostring(text), "vqgroup") > 0 or Wholefind(tostring(text), "vqrequest") > 0 or Wholefind(tostring(text), "vqaccept") > 0 or Wholefind(tostring(text), "vqdecline") > 0 or Wholefind(tostring(text), "vqremove") > 0) and filterEnabled then
		blockMsg = true
	end
	if not blockMsg then
		-- DEFAULT_CHAT_FRAME:AddMessage(frame.." ")
		-- self.hooks[frame].AddMessage(frame, string.format("%s", text), r, g, b, id)
	end
end

function wQueue_OnLoad()
	this:RegisterEvent("ADDON_LOADED");
	this:RegisterEvent("CHAT_MSG_CHANNEL");
	this:RegisterEvent("CHAT_MSG_WHISPER");
	this:RegisterEvent("WHO_LIST_UPDATE");
end

function filterPunctuation( s )
	s = string.lower(s)
	local newString = ""
	for i = 1, string.len(s) do
		if string.find(string.sub(s, i, i), "%p") ~= nil then
			newString = newString .. " "
		elseif string.find(string.sub(s, i, i), "%d") ~= nil then
			--nothing needed here
		else
			newString = newString .. string.sub(s, i, i)
		end
	end
	return newString
end

function wQueue_OnEvent(event)
	if event == "ADDON_LOADED" and arg1 == "wQueue" then
		findTimer = GetTime() - 10
		if MinimapPos == nil then
			MinimapPos = -30
		end
		if wQueueOptions == nil then
			wQueueOptions = {}
		end
		if wQueueOptions["filter"] == nil then
			wQueueOptions["filter"] = false
		end
		if wQueueOptions["general"] == nil then
			wQueueOptions["general"] = true
		end
		if wQueueOptions["trade"] == nil then
			wQueueOptions["trade"] = true
		end
		if wQueueOptions["lfg"] == nil then
			wQueueOptions["lfg"] = true
		end
		if wQueueOptions["global"] == nil then
			wQueueOptions["global"] = true
		end
		if wQueueOptions["world"] == nil then
			wQueueOptions["world"] = true
		end
		if wQueueOptions["onlylfg"] == nil then
			wQueueOptions["onlylfg"] = true
		end
		if selectedRole ==  nil then selectedRole = "" end
		if isFinding == nil then isFinding = true end
		if notCaught == nil then notCaught = {} end
		categories["Miscellaneous"] =
		{
			expanded = false,
			"Misc:misc"
		}
		categories["Raids"] =
		{
			expanded = false,
			"Karazhan:kara",
			"Gruul's Lair:gruul",
			"Zul'Aman:za",
			"Magtheridon's Lair:mag",
			"Serpentshrine Cavern:ssc",
			"The Eye:tk",
			"Hyjal Summit:hyjal",
			"Black Temple:bt",
			"Sunwell Plateau:swp"
			
		}
		categories["Battlegrounds"] =
		{
			expanded = false,
			"Warsong Gulch:wsg",
			"Arathi Basin:ab",
			"Arena:arena"
		
		}
		categories["Classic"] = 
		{
			expanded = false,
			"Ragefire Chasm:rfc",
			"The Deadmines:dead",
			"Wailing Caverns:wc",
			"Shadowfang Keep:sfk",
			"The Stockade:stock",
			"Blackfathom Deeps:bfd",
			"Gnomeregan:gnomer",
			"Razorfen Kraul:rfk",
			"Scarlet Monastery:sm",
			"Razorfen Downs:rfd",
			"Uldaman:ulda",
			"Zul'Farrak:zf",
			"Maraudon:mara",
			"The Sunken Temple:st",
			"Blackrock Depths:brd",
			"Lower Blackrock:lbrs",
			"Dire Maul:dem",
			"Stratholme:strat",
			"Scholomance:scholo",
			"Raid Upper Blackrock:ubrs",
			"Raid Zul'Gurub:zg",
			"Raid Molten Core:mc",
			"Raid Onyxia's Lair:ony",
			"Raid Ruins of Ahn'Qiraj:ruins",
			"Raid Blackwing Lair:bwl",
			"Raid Temple of Ahn'Qiraj:temple",
			"Raid Naxxramas:naxx"
			
			}
			categories["Burning Crusade"] = 
		{
		expanded = false,
			"Hellfire Ramparts:ramps",
			"The Blood Furnace:bf",
			"The Slave Pens:sp",
			"The Underbog:ub",
			"Mana-Tombs:mt",
			"Sethekk Halls:seth",
			"Auchenai Crypts:ac",
			"Old Hillsbrad Foothills:dh",
			"The Steamvault:sv",
			"The Shattered Halls:sh",
			"The Mechanar:mech",
			"The Botanica:bot",
			"Shadow Labyrinth:sl",
			"The Black Morass:bm",
			"The Arcatraz:arc",
			"Magisters' Terrace:mgt"
			
			}
		categories["Quest Groups"] =
		{
			expanded = false,
			"Quests 1-20:quest120",
			"Quests 20-30:quest2030",
			"Quests 30-40:quest3040",
			"Quests 40-50:quest4050",
			"Quests 50-60:quest5060",
			"Quests 60-70:quest6070"
		}
		
		for k, v in pairs(categories) do
			for kk, vv in pairs(categories[k]) do
				if type(vv) == "string" then
					args = split(vv, "\:")
					if args[2] ~= nil then
						groups[args[2]] = {}
					end
				end
			end
		end
		groups["waitlist"] = {}
		
		playersQueued = 
		{

		}
		local wQueueFrameBackdrop = {
		  -- path to the background texture
		  bgFile = "Interface\\AddOns\\wQueue\\media\\white",  
		  -- path to the border texture
		  edgeFile = "Interface\\AddOns\\wQueue\\media\\border",
		  -- true to repeat the background texture to fill the frame, false to scale it
		  tile = true,
		  -- size (width or height) of the square repeating background tiles (in pixels)
		  tileSize = 8,
		  -- thickness of edge segments and square size of edge corners (in pixels)
		  edgeSize = 12,
		  -- distance from the edges of the frame to those of the background texture (in pixels)
		  insets = {
			left = 1,
			right = 1,
			top = 1,
			bottom = 1
		  }
		}
		wQueueFrame = CreateFrame("Frame", UIParent)
		wQueueFrame:SetWidth(740)
		wQueueFrame:SetHeight(395)
		wQueueFrame:ClearAllPoints()
		wQueueFrame:SetPoint("CENTER", UIParent,"CENTER") 
		wQueueFrame:SetMovable(true)
		wQueueFrame:EnableMouse(true)
		wQueueFrame:SetBackdrop(wQueueFrameBackdrop)
		wQueueFrame:SetBackdropColor(15/255, 15/255, 15/255, 0.7)
		wQueueFrame:SetScript("OnMouseDown", function(self, button)
			wQueueFrame:StartMoving()
			wQueueFrame.hostlistNameField:ClearFocus()
			wQueueFrame.hostlistLevelField:ClearFocus()
			if isHost or isFinding then
				wQueueFrame.hostlistRoleText:SetText("")
			end
		end)
		wQueueFrame:SetScript("OnMouseUp", function(self, button)
			wQueueFrame:StopMovingOrSizing()
		end)
		wQueueFrame:SetScript("OnHide", function()
			wQueueFrame.catList:Hide()
			wQueueFrame.hostlist:Hide()
		end)
		wQueueFrame:SetScript("OnShow", function()
			wQueue_UpdateHostScroll(scrollbar:GetValue())
			wQueue_updateCatColors()
		end)
		
		wQueueFrame.closeButton = wQueue_newButton(wQueueFrame, 10)
		wQueueFrame.closeButton:SetPoint("BOTTOMRIGHT", wQueueFrame, "BOTTOMRIGHT", -6, 3)
		wQueueFrame.closeButton:SetText("Close")
		wQueueFrame.closeButton:SetWidth(wQueueFrame.closeButton:GetTextWidth()+4)
		wQueueFrame.closeButton:SetScript("OnClick", function()
			wQueueFrame:Hide()
			wQueueFrame.catList:Hide()
			wQueueFrame.hostlist:Hide()
			wQueueFrameShown = false
		end)
		
		wQueueFrame.optionsButton = wQueue_newButton(wQueueFrame, 10)
		wQueueFrame.optionsButton:SetPoint("BOTTOMLEFT", wQueueFrame, "BOTTOMLEFT", 6, 3)
		wQueueFrame.optionsButton:SetText("Options")
		wQueueFrame.optionsButton:SetWidth(wQueueFrame.optionsButton:GetTextWidth()+3)
		wQueueFrame.optionsButton:SetScript("OnMouseDown", function()
			if wQueueFrame.optionsFrame:IsShown() then
				wQueueFrame.optionsFrame:Hide()
			else
				wQueueFrame.optionsFrame:Show()
			end
		end)
		
		wQueueFrame.catList = CreateFrame("ScrollFrame", wQueueFrame)
		wQueueFrame.catList:ClearAllPoints()
		wQueueFrame.catList:SetPoint("LEFT", wQueueFrame, "LEFT", 5, -5)
		wQueueFrame.catList:SetWidth(200)
		wQueueFrame.catList:SetHeight(355)
		wQueueFrame.catList:EnableMouseWheel(true)
		wQueueFrame.catList:SetBackdrop(wQueueFrameBackdrop)
		wQueueFrame.catList:SetBackdropColor(20/255, 20/255, 20/255, 0.9)
		wQueueFrame.catList:SetScript("OnMouseWheel", function()
			if arg1 == 1 then
				scrollbarCat:SetValue(scrollbarCat:GetValue()-1)
			elseif arg1 == -1 then
				scrollbarCat:SetValue(scrollbarCat:GetValue()+1)
			end
			realScroll = true
		end)
		
		wQueueFrame.hostlist = CreateFrame("ScrollFrame", wQueueFrame)
		wQueueFrame.hostlist:ClearAllPoints()
		wQueueFrame.hostlist:SetPoint("RIGHT", wQueueFrame, "RIGHT", -5, -5)
		wQueueFrame.hostlist:SetWidth(528)
		wQueueFrame.hostlist:SetHeight(355)
		wQueueFrame.hostlist:EnableMouseWheel(true)
		wQueueFrame.hostlist:SetBackdrop(wQueueFrameBackdrop)
		wQueueFrame.hostlist:SetBackdropColor(20/255, 20/255, 20/255, 0.9)
		wQueueFrame.hostlist:SetScript("OnMouseWheel", function(self, delta)
			if arg1 == 1 then
				scrollbar:SetValue(scrollbar:GetValue()-1)
			elseif arg1 == -1 then
				scrollbar:SetValue(scrollbar:GetValue()+1)
			end
		end)
		CreateFrame( "GameTooltip", "groupToolTip", nil, "GameTooltipTemplate" ); -- Tooltip name cannot be nil
		CreateFrame( "GameTooltip", "playerQueueToolTip", nil, "GameTooltipTemplate" ); -- Tooltip name cannot be nil
		hostListFrame = wQueueFrame.hostlist
		
		wQueueFrame.hostlistTopSection = CreateFrame("Frame", nil, wQueueFrame.hostlist)
		wQueueFrame.hostlistTopSection:ClearAllPoints()
		wQueueFrame.hostlistTopSection:SetPoint("TOPLEFT", wQueueFrame.hostlist, "TOPLEFT", 0 , 0)
		wQueueFrame.hostlistTopSection:SetWidth(wQueueFrame.hostlist:GetWidth())
		wQueueFrame.hostlistTopSection:SetHeight(wQueueFrame.hostlist:GetHeight() * 1/5)
		wQueueFrame.hostlistTopSection:SetBackdrop(wQueueFrameBackdrop)
		wQueueFrame.hostlistTopSection:SetBackdropColor(10/255, 10/255, 10/255, 0.4)
		wQueueFrame.hostlistTopSection:SetFrameLevel(2)
		
		wQueueFrame.hostlistTopSectionBg = wQueueFrame.hostlistTopSection:CreateTexture(nil, "BACKGROUND")
		wQueueFrame.hostlistTopSectionBg:SetTexture(0, 0, 0, 0)
		wQueueFrame.hostlistTopSectionBg:SetPoint("BOTTOMLEFT", wQueueFrame.hostlistTopSection, "BOTTOMLEFT", 1, 1)
		wQueueFrame.hostlistTopSectionBg:SetWidth(wQueueFrame.hostlistTopSection:GetWidth()-2)
		wQueueFrame.hostlistTopSectionBg:SetHeight(wQueueFrame.hostlistTopSection:GetHeight()-2)
		
		wQueueFrame.hostlistBotShadow = wQueueFrame.hostlistTopSection:CreateTexture(nil, "OVERLAY")
		wQueueFrame.hostlistBotShadow:SetTexture(0, 0, 0, 1)
		wQueueFrame.hostlistBotShadow:SetPoint("BOTTOM", wQueueFrame.hostlist, "BOTTOM", 0, 1)
		wQueueFrame.hostlistBotShadow:SetWidth(wQueueFrame.hostlist:GetWidth())
		wQueueFrame.hostlistBotShadow:SetHeight(40)
		wQueueFrame.hostlistBotShadow:SetGradientAlpha("VERTICAL", 0, 0, 0, 1, 0, 0, 0, 0)
		wQueueFrame.hostlistBotShadow:Hide()
		
		wQueueFrame.catlistBotShadow = CreateFrame("Frame", nil, wQueueFrame.catList)
		wQueueFrame.catlistBotShadow:SetAllPoints()
		wQueueFrame.catlistBotShadow:SetWidth(wQueueFrame.catList:GetWidth())
		wQueueFrame.catlistBotShadow:SetHeight(wQueueFrame.catList:GetHeight())
		wQueueFrame.catlistBotShadow:SetFrameLevel(2)
		
		wQueueFrame.catlistBotShadowbg = wQueueFrame.catlistBotShadow:CreateTexture(nil, "OVERLAY")
		wQueueFrame.catlistBotShadowbg:SetTexture(0, 0, 0, 1)
		wQueueFrame.catlistBotShadowbg:SetPoint("BOTTOM", wQueueFrame.catList, "BOTTOM", 0, 1)
		wQueueFrame.catlistBotShadowbg:SetWidth(wQueueFrame.catList:GetWidth())
		wQueueFrame.catlistBotShadowbg:SetHeight(40)
		wQueueFrame.catlistBotShadowbg:SetGradientAlpha("VERTICAL", 0, 0, 0, 1, 0, 0, 0, 0)
		
		--hostframe waitlist header strings
		wQueueFrame.hostTitle = CreateFrame("Button", "wQueueButton", wQueueFrame.hostlist, "UIPanelButtonTemplate")
		wQueueFrame.hostTitle:ClearAllPoints()
		wQueueFrame.hostTitle:SetPoint("TOPLEFT", wQueueFrame.hostlist, "TOPLEFT", 0 , -wQueueFrame.hostlistTopSection:GetHeight()-2)
		--wQueueFrame.hostTitle:SetFont("Fonts\\FRIZQT__.TTF", 10)
		wQueueFrame.hostTitle:SetText("Name")
		--wQueueFrame.hostTitle:SetTextColor(wQueueColors["YELLOW"][1], wQueueColors["YELLOW"][2], wQueueColors["YELLOW"][3])
		wQueueFrame.hostTitle:SetPushedTextOffset(0,0)
		wQueueFrame.hostTitle:SetWidth(wQueueFrame.hostTitle:GetTextWidth())
		wQueueFrame.hostTitle:SetHeight(wQueueFrame.hostTitle:GetTextHeight())
		wQueueFrame.hostTitle:Hide()
		
		wQueueFrame.hostTitleLevel = CreateFrame("Button", "wQueueButton", wQueueFrame.hostlist, "UIPanelButtonTemplate")
		wQueueFrame.hostTitleLevel:ClearAllPoints()
		wQueueFrame.hostTitleLevel:SetPoint("TOPLEFT", wQueueFrame.hostlist, "TOPLEFT", 149, -wQueueFrame.hostlistTopSection:GetHeight() - 2)
		--wQueueFrame.hostTitleLevel:SetFont("Fonts\\FRIZQT__.TTF", 10)
		wQueueFrame.hostTitleLevel:SetText("Level")
		--wQueueFrame.hostTitleLevel:SetTextColor(wQueueColors["YELLOW"][1], wQueueColors["YELLOW"][2], wQueueColors["YELLOW"][3])
		wQueueFrame.hostTitleLevel:SetPushedTextOffset(0,0)
		wQueueFrame.hostTitleLevel:SetWidth(wQueueFrame.hostTitleLevel:GetTextWidth())
		wQueueFrame.hostTitleLevel:SetHeight(wQueueFrame.hostTitleLevel:GetTextHeight())
		wQueueFrame.hostTitleLevel:Hide()
		
		
		wQueueFrame.hostTitleClass = CreateFrame("Button", "wQueueButton", wQueueFrame.hostlist, "UIPanelButtonTemplate")
		wQueueFrame.hostTitleClass:ClearAllPoints()
		wQueueFrame.hostTitleClass:SetPoint("TOPLEFT", wQueueFrame.hostlist, "TOPLEFT", 245, -wQueueFrame.hostlistTopSection:GetHeight() - 2)
		--wQueueFrame.hostTitleClass:SetFont("Fonts\\FRIZQT__.TTF", 10)
		wQueueFrame.hostTitleClass:SetText("Class")
		--wQueueFrame.hostTitleClass:SetTextColor(wQueueColors["YELLOW"][1], wQueueColors["YELLOW"][2], wQueueColors["YELLOW"][3])
		wQueueFrame.hostTitleClass:SetPushedTextOffset(0,0)
		wQueueFrame.hostTitleClass:SetWidth(wQueueFrame.hostTitleClass:GetTextWidth())
		wQueueFrame.hostTitleClass:SetHeight(wQueueFrame.hostTitleClass:GetTextHeight())
		wQueueFrame.hostTitleClass:Hide()
		
		wQueueFrame.hostTitleRole = CreateFrame("Button", "wQueueButton", wQueueFrame.hostlist, "UIPanelButtonTemplate")
		wQueueFrame.hostTitleRole:SetPoint("TOPLEFT", wQueueFrame.hostlist, "TOPLEFT", 320, -wQueueFrame.hostlistTopSection:GetHeight() - 2)
		--wQueueFrame.hostTitleRole:SetFont("Fonts\\FRIZQT__.TTF", 10)
		wQueueFrame.hostTitleRole:SetText("Role")
		--wQueueFrame.hostTitleRole:SetTextColor(wQueueColors["YELLOW"][1], wQueueColors["YELLOW"][2], wQueueColors["YELLOW"][3])
		wQueueFrame.hostTitleRole:SetPushedTextOffset(0,0)
		wQueueFrame.hostTitleRole:SetWidth(wQueueFrame.hostTitleRole:GetTextWidth())
		wQueueFrame.hostTitleRole:SetHeight(wQueueFrame.hostTitleRole:GetTextHeight())
		wQueueFrame.hostTitleRole:Hide()	
		-----------------------------------------------------------------
		
		--hostframe find header strings
		wQueueFrame.hostTitleFindName = CreateFrame("Button", "wQueueButton", wQueueFrame.hostlist, "UIPanelButtonGrayTemplate")
		wQueueFrame.hostTitleFindName:ClearAllPoints()
		wQueueFrame.hostTitleFindName:SetPoint("TOPLEFT", wQueueFrame.hostlist, "TOPLEFT", 0, -wQueueFrame.hostlistTopSection:GetHeight() - 2)
		--wQueueFrame.hostTitleFindName:SetFont("Fonts\\FRIZQT__.TTF", 10)
		wQueueFrame.hostTitleFindName:SetText("Title")
		wQueueFrame.hostTitleFindName:EnableMouse(false)
		--wQueueFrame.hostTitleFindName:SetTextColor(wQueueColors["YELLOW"][1], wQueueColors["YELLOW"][2], wQueueColors["YELLOW"][3])
		wQueueFrame.hostTitleFindName:SetPushedTextOffset(0,0)
		wQueueFrame.hostTitleFindName:SetWidth(wQueueFrame.hostTitleFindName:GetTextWidth()+20)
		wQueueFrame.hostTitleFindName:SetHeight(wQueueFrame.hostTitleFindName:GetTextHeight())
		
		wQueueFrame.hostTitleFindLeader = CreateFrame("Button", "wQueueButton", wQueueFrame.hostlist, "UIPanelButtonGrayTemplate")
		wQueueFrame.hostTitleFindLeader:ClearAllPoints()
		wQueueFrame.hostTitleFindLeader:SetPoint("TOPLEFT", wQueueFrame.hostlist, "TOPLEFT", 251, -wQueueFrame.hostlistTopSection:GetHeight() - 2)
		--wQueueFrame.hostTitleFindLeader:SetFont("Fonts\\FRIZQT__.TTF", 10)
		wQueueFrame.hostTitleFindLeader:SetText("Leader")
		wQueueFrame.hostTitleFindLeader:EnableMouse(false)
		--wQueueFrame.hostTitleFindLeader:SetTextColor(wQueueColors["YELLOW"][1], wQueueColors["YELLOW"][2], wQueueColors["YELLOW"][3])
		wQueueFrame.hostTitleFindLeader:SetPushedTextOffset(0,0)
		wQueueFrame.hostTitleFindLeader:SetWidth(wQueueFrame.hostTitleFindLeader:GetTextWidth()+20)
		wQueueFrame.hostTitleFindLeader:SetHeight(wQueueFrame.hostTitleFindLeader:GetTextHeight())
		
		wQueueFrame.hostTitleFindLevel = CreateFrame("Button", "wQueueButton", wQueueFrame.hostlist)
		wQueueFrame.hostTitleFindLevel:ClearAllPoints()
		wQueueFrame.hostTitleFindLevel:SetPoint("TOPLEFT", wQueueFrame.hostlist, "TOPLEFT", 278, -wQueueFrame.hostlistTopSection:GetHeight() - 2)
		--wQueueFrame.hostTitleFindLevel:SetFont("Fonts\\FRIZQT__.TTF", 10)
		wQueueFrame.hostTitleFindLevel:SetText("Level")
		--wQueueFrame.hostTitleFindLevel:SetTextColor(wQueueColors["YELLOW"][1], wQueueColors["YELLOW"][2], wQueueColors["YELLOW"][3])
		wQueueFrame.hostTitleFindLevel:SetPushedTextOffset(0,0)
		wQueueFrame.hostTitleFindLevel:SetWidth(wQueueFrame.hostTitleFindLevel:GetTextWidth())
		wQueueFrame.hostTitleFindLevel:SetHeight(wQueueFrame.hostTitleFindLevel:GetTextHeight())
		
		wQueueFrame.hostTitleFindSize = CreateFrame("Button", "wQueueButton", wQueueFrame.hostlist)
		wQueueFrame.hostTitleFindSize:ClearAllPoints()
		wQueueFrame.hostTitleFindSize:SetPoint("TOPLEFT", wQueueFrame.hostlist, "TOPLEFT", 312, -wQueueFrame.hostlistTopSection:GetHeight() - 2)
		--wQueueFrame.hostTitleFindSize:SetFont("Fonts\\FRIZQT__.TTF", 10)
		wQueueFrame.hostTitleFindSize:SetText("Size")
		--wQueueFrame.hostTitleFindSize:SetTextColor(wQueueColors["YELLOW"][1], wQueueColors["YELLOW"][2], wQueueColors["YELLOW"][3])
		wQueueFrame.hostTitleFindSize:SetPushedTextOffset(0,0)
		wQueueFrame.hostTitleFindSize:SetWidth(wQueueFrame.hostTitleFindLeader:GetTextWidth())
		wQueueFrame.hostTitleFindSize:SetHeight(wQueueFrame.hostTitleFindLeader:GetTextHeight())
		
		wQueueFrame.hostTitleFindRoles = CreateFrame("Button", "wQueueButton", wQueueFrame.hostlist)
		wQueueFrame.hostTitleFindRoles:ClearAllPoints()
		wQueueFrame.hostTitleFindRoles:SetPoint("TOPLEFT", wQueueFrame.hostlist, "TOPLEFT", 361, -wQueueFrame.hostlistTopSection:GetHeight() - 2)
		--wQueueFrame.hostTitleFindRoles:SetFont("Fonts\\FRIZQT__.TTF", 10)
		wQueueFrame.hostTitleFindRoles:SetText("Role(s)")
		--wQueueFrame.hostTitleFindRoles:SetTextColor(wQueueColors["YELLOW"][1], wQueueColors["YELLOW"][2], wQueueColors["YELLOW"][3])
		wQueueFrame.hostTitleFindRoles:SetPushedTextOffset(0,0)
		wQueueFrame.hostTitleFindRoles:SetWidth(wQueueFrame.hostTitleFindRoles:GetTextWidth())
		wQueueFrame.hostTitleFindRoles:SetHeight(wQueueFrame.hostTitleFindRoles:GetTextHeight())
		wQueueFrame.hostTitleFindName:Hide()
		wQueueFrame.hostTitleFindLeader:Hide()
		wQueueFrame.hostTitleFindLevel:Hide()
		wQueueFrame.hostTitleFindSize:Hide()
		wQueueFrame.hostTitleFindRoles:Hide()
		--------------------------------------------------------------------------------------------------------
		
		wQueueFrame.hostlistHeal = CreateFrame("Button", nil, wQueueFrame.hostlistTopSection, "UIPanelButtonTemplate")
		wQueueFrame.hostlistHeal:ClearAllPoints()
		wQueueFrame.hostlistHeal:SetPoint("RIGHT", wQueueFrame.hostlistTopSection, "RIGHT", -32, 0)
		wQueueFrame.hostlistHeal:SetWidth(32)
		wQueueFrame.hostlistHeal:SetHeight(32)
		wQueueFrame.hostlistHeal:UnlockHighlight()
		wQueueFrame.hostlistHeal:SetScript("OnMouseDown", function()
			wQueueFrame.hostlistTankCheck:Hide()
			wQueueFrame.hostlistDpsCheck:Hide()
			wQueueFrame.hostlistHealCheck:Show()
			wQueueFrame.hostlistRoleText:SetText("")
			wQueueFrame.hostlistHostButton:Show()
			selectedRole = "Healer"
		end)
		wQueueFrame.hostlistHeal:SetScript("OnEnter", function()
			wQueueFrame.hostlistHealTex:SetVertexColor(1, 1, 0)
		end)
		wQueueFrame.hostlistHeal:SetScript("OnLeave", function()
			wQueueFrame.hostlistHealTex:SetVertexColor(1, 1, 1)
		end)
		
		wQueueFrame.hostlistHealTex = wQueueFrame.hostlistHeal:CreateTexture(nil, "ARTWORK")
		wQueueFrame.hostlistHealTex:SetTexture("Interface\\AddOns\\wQueue\\media\\Healer")
		wQueueFrame.hostlistHealTex:SetPoint("TOP", wQueueFrame.hostlistHeal, "TOP", 0, 0)
		wQueueFrame.hostlistHealTex:SetWidth(wQueueFrame.hostlistHeal:GetWidth())
		wQueueFrame.hostlistHealTex:SetHeight(wQueueFrame.hostlistHeal:GetHeight())
		
		wQueueFrame.hostlistHealCheck = wQueueFrame.hostlistHeal:CreateTexture(nil, "OVERLAY")
		wQueueFrame.hostlistHealCheck:SetTexture("Interface\\BUTTONS\\UI-CheckBox-Check")
		wQueueFrame.hostlistHealCheck:SetVertexColor(0.1,0.8,0.1)
		wQueueFrame.hostlistHealCheck:SetAllPoints()
		
		wQueueFrame.hostlistDps = CreateFrame("Button", nil, wQueueFrame.hostlistTopSection, "UIPanelButtonTemplate")
		wQueueFrame.hostlistDps:SetPoint("RIGHT", wQueueFrame.hostlistTopSection, "RIGHT",  0, 0)
		wQueueFrame.hostlistDps:SetWidth(32)
		wQueueFrame.hostlistDps:SetHeight(32)
		wQueueFrame.hostlistDps:SetScript("OnMouseDown", function()
			wQueueFrame.hostlistTankCheck:Hide()
			wQueueFrame.hostlistDpsCheck:Show()
			wQueueFrame.hostlistHealCheck:Hide()
			wQueueFrame.hostlistRoleText:SetText("")
			selectedRole = "Damage"
		end)
		wQueueFrame.hostlistDps:SetScript("OnEnter", function()
			wQueueFrame.hostlistDpsTex:SetVertexColor(1, 1, 0)
		end)
		wQueueFrame.hostlistDps:SetScript("OnLeave", function()
			wQueueFrame.hostlistDpsTex:SetVertexColor(1, 1, 1)
		end)
		
		wQueueFrame.hostlistDpsTex = wQueueFrame.hostlistDps:CreateTexture(nil, "ARTWORK")
		wQueueFrame.hostlistDpsTex:SetTexture("Interface\\AddOns\\wQueue\\media\\Damage")
		wQueueFrame.hostlistDpsTex:SetPoint("TOP", wQueueFrame.hostlistDps, "TOP", 0, 0)
		wQueueFrame.hostlistDpsTex:SetWidth(wQueueFrame.hostlistDps:GetWidth())
		wQueueFrame.hostlistDpsTex:SetHeight(wQueueFrame.hostlistDps:GetHeight())
		
		wQueueFrame.hostlistDpsCheck = wQueueFrame.hostlistDps:CreateTexture(nil, "OVERLAY")
		wQueueFrame.hostlistDpsCheck:SetTexture("Interface\\BUTTONS\\UI-CheckBox-Check")
		wQueueFrame.hostlistDpsCheck:SetVertexColor(0.1,0.8,0.1)
		wQueueFrame.hostlistDpsCheck:SetAllPoints()
		
		wQueueFrame.hostlistTank = CreateFrame("Button", nil, wQueueFrame.hostlistTopSection, "UIPanelButtonTemplate")
		wQueueFrame.hostlistTank:SetPoint("RIGHT", wQueueFrame.hostlistTopSection, "RIGHT", -64 , 0)
		wQueueFrame.hostlistTank:SetWidth(32)
		wQueueFrame.hostlistTank:SetHeight(32)
		wQueueFrame.hostlistTank:SetScript("OnMouseDown", function()
			wQueueFrame.hostlistTankCheck:Show()
			wQueueFrame.hostlistDpsCheck:Hide()
			wQueueFrame.hostlistHealCheck:Hide()
			wQueueFrame.hostlistRoleText:SetText("")
			selectedRole = "Tank"
		end)
		wQueueFrame.hostlistTank:SetScript("OnEnter", function()
			wQueueFrame.hostlistTankTex:SetVertexColor(1, 1, 0)
		end)
		wQueueFrame.hostlistTank:SetScript("OnLeave", function()
			wQueueFrame.hostlistTankTex:SetVertexColor(1, 1, 1)
		end)
				
		wQueueFrame.hostlistTankTex = wQueueFrame.hostlistTank:CreateTexture(nil, "ARTWORK")
		wQueueFrame.hostlistTankTex:SetTexture("Interface\\AddOns\\wQueue\\media\\Tank")
		wQueueFrame.hostlistTankTex:SetPoint("TOP", wQueueFrame.hostlistTank, "TOP", 0, 0)
		wQueueFrame.hostlistTankTex:SetWidth(wQueueFrame.hostlistTank:GetWidth())
		wQueueFrame.hostlistTankTex:SetHeight(wQueueFrame.hostlistTank:GetHeight())
		
		wQueueFrame.hostlistTankCheck = wQueueFrame.hostlistTank:CreateTexture(nil, "OVERLAY")
		wQueueFrame.hostlistTankCheck:SetTexture("Interface\\BUTTONS\\UI-CheckBox-Check")
		wQueueFrame.hostlistTankCheck:SetVertexColor(0.1,0.8,0.1)
		wQueueFrame.hostlistTankCheck:SetAllPoints()
		
		wQueueFrame.hostlistRoleText = CreateFrame("Button", nil, wQueueFrame.hostlistTopSection, "UIPanelButtonTemplate")
		wQueueFrame.hostlistRoleText:ClearAllPoints()
		wQueueFrame.hostlistRoleText:SetPoint("BOTTOMLEFT", wQueueFrame.hostlistTopSection, "BOTTOMLEFT", 5, 5)
		wQueueFrame.hostlistRoleText:EnableMouse(false)
		--wQueueFrame.hostlistRoleText:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
		wQueueFrame.hostlistRoleText:SetText("(Select a role to start finding)")
		--wQueueFrame.hostlistRoleText:SetTextColor(wQueueColors["YELLOW"][1], wQueueColors["YELLOW"][2], wQueueColors["YELLOW"][3])
		wQueueFrame.hostlistRoleText:SetWidth(wQueueFrame.hostlistRoleText:GetTextWidth())
		wQueueFrame.hostlistRoleText:SetHeight(wQueueFrame.hostlistRoleText:GetTextHeight())
		wQueueFrame.hostlistRoleText:SetScript("OnUpdate", function()
			this:SetWidth(wQueueFrame.hostlistRoleText:GetTextWidth())
			this:SetHeight(wQueueFrame.hostlistRoleText:GetTextHeight())
		end)
		
		if selectedRole == "Healer" then
			wQueueFrame.hostlistTankCheck:Hide()
			wQueueFrame.hostlistDpsCheck:Hide()
			wQueueFrame.hostlistHealCheck:Show()
			wQueueFrame.hostlistRoleText:SetText("")
		elseif selectedRole == "Damage" then
			wQueueFrame.hostlistTankCheck:Hide()
			wQueueFrame.hostlistDpsCheck:Show()
			wQueueFrame.hostlistHealCheck:Hide()
			wQueueFrame.hostlistRoleText:SetText("")
		elseif selectedRole == "Tank" then
			wQueueFrame.hostlistTankCheck:Show()
			wQueueFrame.hostlistDpsCheck:Hide()
			wQueueFrame.hostlistHealCheck:Hide()
			wQueueFrame.hostlistRoleText:SetText("")
		end
		
		wQueueFrame.hostlistHostButton = wQueue_newButton(wQueueFrame.hostlistTopSection, 10)
		wQueueFrame.hostlistHostButton:SetPoint("BOTTOMRIGHT", wQueueFrame.hostlistTopSection, "BOTTOMRIGHT", -3, 5)
		wQueueFrame.hostlistHostButton:SetText("Start new group")
		wQueueFrame.hostlistHostButton:SetWidth(wQueueFrame.hostlistHostButton:GetTextWidth()+10)
		wQueueFrame.hostlistHostButton:SetScript("OnClick", function()
			if UnitLevel("player") < 5 then 
				wQueueFrame.hostlistRoleText:SetText("(You must be at least level 5 to use this)")
				return
			end
			titleDung = selectedQuery
			if titleDung == "dead" then titleDung = "DM" end
			wQueueFrame.hostlistNameField:SetText("LFM " .. string.upper(selectedQuery) .. " - " .. getglobal("MINLVLS")[selectedQuery] .. "+ need all")
			wQueueFrame.hostlistHostButton:Hide()
			isWaitListShown = true
			wQueueFrame.hostTitleFindName:Hide()
			wQueueFrame.hostTitleFindLeader:Hide()
			wQueueFrame.hostTitleFindLevel:Hide()
			wQueueFrame.hostTitleFindSize:Hide()
			wQueueFrame.hostTitleFindRoles:Hide()
			wQueueFrame.hostlistLevelField:SetText(getglobal("MINLVLS")[selectedQuery])
			wQueueFrame.hostlistLevelField:Show()
			wQueueFrame.hostlistNameField:Show()
			wQueueFrame.hostlistCreateButton:Show()
			wQueueFrame.hostlistCancelButton:Show()
			wQueueFrame.hostlistCreateButton:SetText("Create group")
			scrollbar:SetValue(1)
			hostedCategory = selectedQuery
			prevSelected = selectedQuery
			selectedQuery = "waitlist"
			wQueue_ShowGroups(selectedQuery, prevSelected)
		end)
		wQueueFrame.hostlistHostButton:SetScript("OnEnter", function()
			playerQueueToolTip:SetOwner( this, "ANCHOR_CURSOR" );
			playerQueueToolTip:AddLine("Find players for", 1, 1, 1, 1)
			playerQueueToolTip:AddLine(realHostedCategory, wQueueColors["GREEN"][1], wQueueColors["GREEN"][2], wQueueColors["GREEN"][3], 1)
			playerQueueToolTip:Show()
		end)
		wQueueFrame.hostlistHostButton:SetScript("OnLeave", function()
			playerQueueToolTip:Hide()
		end)
		
		wQueueFrame.hostlistEditButton = wQueue_newButton(wQueueFrame.hostlistTopSection, 10)
		wQueueFrame.hostlistEditButton:SetPoint("BOTTOMRIGHT", wQueueFrame.hostlistTopSection, "BOTTOMRIGHT", -3, 5)
		wQueueFrame.hostlistEditButton:SetText("Edit group")
		wQueueFrame.hostlistEditButton:SetWidth(wQueueFrame.hostlistEditButton:GetTextWidth()+5)
		wQueueFrame.hostlistEditButton:SetScript("OnClick", function()
			wQueueFrame.hostlistEditButton:Hide()
			isWaitListShown = true
			scrollbar:SetValue(1)
			prevSelected = selectedQuery
			selectedQuery = "waitlist"
			wQueue_ShowGroups(selectedQuery, prevSelected)
			wQueueFrame.hostTitleFindName:Hide()
			wQueueFrame.hostTitleFindLeader:Hide()
			wQueueFrame.hostTitleFindLevel:Hide()
			wQueueFrame.hostTitleFindSize:Hide()
			wQueueFrame.hostTitleFindRoles:Hide()
			wQueueFrame.hostlistLevelField:Show()
			wQueueFrame.hostlistNameField:Show()
			wQueueFrame.hostlistCreateButton:Show()
			wQueueFrame.hostlistBotShadow:SetHeight(400)
			wQueueFrame.hostlistBotShadow:Show()
			wQueueFrame.hostlistCreateButton:SetText("Save")
		end)
		wQueueFrame.hostlistEditButton:Hide()
		
		wQueueFrame.hostlistUnlistButton = wQueue_newButton(wQueueFrame.hostlistTopSection, 10)
		wQueueFrame.hostlistUnlistButton:SetPoint("TOPRIGHT", wQueueFrame.hostlistTopSection, "TOPRIGHT", -3, -5)
		wQueueFrame.hostlistUnlistButton:SetText("Unlist group")
		wQueueFrame.hostlistUnlistButton:SetWidth(wQueueFrame.hostlistUnlistButton:GetTextWidth()+5)
		wQueueFrame.hostlistUnlistButton:SetScript("OnClick", function()
			wQueueFrame.hostlistEditButton:Hide()
			wQueueFrame.hostlistWaitListButton:Hide()
			this:Hide()
			wQueueFrame.hostlistLevelField:Hide()
			wQueueFrame.hostlistNameField:Hide()
			wQueueFrame.hostlistCreateButton:Hide()
			isHost = false
			isWaitListShown = false
			wQueueFrame.hostTitle:Hide()
			wQueueFrame.hostTitleRole:Hide()
			wQueueFrame.hostTitleClass:Hide()
			wQueueFrame.hostTitleLevel:Hide()
			wQueueFrame.topsectionHostName:Hide()
			if selectedQuery == "waitlist" then selectedQuery = hostedCategory end
			scrollbar:SetValue(1)
			wQueue_ShowGroups(selectedQuery, "waitlist")
			groups["waitlist"] = {}
			wQueueFrame.hostlistRoleText:SetText("")
			wQueueFrame.hostlistHostButton:Show()
			wQueueFrame.hostTitleFindName:Show()
			wQueueFrame.hostTitleFindLeader:Show()
			wQueueFrame.hostTitleFindLevel:Show()
			wQueueFrame.hostTitleFindSize:Show()
			wQueueFrame.hostTitleFindRoles:Show()
		end)
		wQueueFrame.hostlistUnlistButton:Hide()
		
		wQueueFrame.hostlistWaitListButton = wQueue_newButton(wQueueFrame.hostlistTopSection, 10)
		wQueueFrame.hostlistWaitListButton:SetPoint("TOPRIGHT", wQueueFrame.hostlistTopSection, "TOPRIGHT", -75, -5)
		wQueueFrame.hostlistWaitListButton:SetText("Wait list")
		wQueueFrame.hostlistWaitListButton:SetWidth(wQueueFrame.hostlistWaitListButton:GetTextWidth()+10)
		wQueueFrame.hostlistWaitListButton:SetScript("OnClick", function()
			wQueueFrame.topsectiontitle:SetText(realHostedCategory .. "(" .. getglobal("MINLVLS")[hostedCategory] .. ")")
			wQueueFrame.topsectiontitle:SetWidth(wQueueFrame.topsectiontitle:GetTextWidth())
			wQueueFrame.topsectiontitle:SetHeight(wQueueFrame.topsectiontitle:GetTextHeight())
			if not wQueueFrame.hostlistTopSectionBg:SetTexture("Interface\\AddOns\\wQueue\\media\\" .. hostedCategory) then
				wQueueFrame.hostlistTopSectionBg:SetTexture(0, 0, 0, 0)
			end
			for k, v in pairs(catListButtons) do
				if split(v:GetText(), "%(")[1] == realHostedCategory then
					wQueueFrame.catListHighlight:SetParent(v)
					wQueueFrame.catListHighlight:SetPoint("LEFT", v, "LEFT", -11, 0)
					wQueueFrame.catListHighlight:Show()
				end
			end
			isWaitListShown = true
			wQueueFrame.hostTitle:Show()
			wQueueFrame.hostTitleRole:Show()
			wQueueFrame.hostTitleClass:Show()
			wQueueFrame.hostTitleLevel:Show()
			wQueueFrame.topsectionHostName:Show()
			scrollbar:SetValue(1)
			prevSelected = selectedQuery
			selectedQuery = "waitlist"
			wQueue_ShowGroups(selectedQuery, prevSelected)
			wQueueFrame.hostTitleFindName:Hide()
			wQueueFrame.hostTitleFindLeader:Hide()
			wQueueFrame.hostTitleFindLevel:Hide()
			wQueueFrame.hostTitleFindSize:Hide()
			wQueueFrame.hostTitleFindRoles:Hide()
		end)
		wQueueFrame.hostlistWaitListButton:SetScript("OnUpdate", function()
			this:SetText("Wait list(" .. tablelength(groups["waitlist"]) .. ")")
			this:SetWidth(this:GetTextWidth()+10)
		end)
		wQueueFrame.hostlistWaitListButton:Hide()
		
		wQueueFrame.optionsFrame = CreateFrame("Frame", nil, wQueueFrame)
		wQueueFrame.optionsFrame:SetWidth(200)
		wQueueFrame.optionsFrame:SetHeight(160)
		wQueueFrame.optionsFrame:SetPoint("BOTTOM", wQueueFrame, "TOP")
		wQueueFrame.optionsFrame:SetBackdrop(wQueueFrameBackdrop)
		wQueueFrame.optionsFrame:SetBackdropColor(10/255, 10/255, 10/255, 0.8)
		wQueueFrame.optionsFrame:EnableMouse(true)
		wQueueFrame.optionsFrame:SetMovable(true)
		wQueueFrame.optionsFrame:SetFrameLevel(4)
		wQueueFrame.optionsFrame:SetClampedToScreen(true)
		wQueueFrame.optionsFrame:SetScript("OnMouseDown", function()
			this:StartMoving()
		end)
		wQueueFrame.optionsFrame:SetScript("OnMouseUp", function()
			this:StopMovingOrSizing()
		end)
		wQueueFrame.optionsFrame:Hide()
		
		wQueueFrame.hostlistFindButton = CreateFrame("CheckButton", "findButtonCheck", wQueueFrame.optionsFrame, "UICheckButtonTemplate");
		wQueueFrame.hostlistFindButton:SetPoint("BOTTOMRIGHT", wQueueFrame.optionsFrame, "BOTTOMRIGHT", -65, 20)
		getglobal(wQueueFrame.hostlistFindButton:GetName() .."Text"):SetText("Find groups")
		wQueueFrame.hostlistFindButton:SetWidth(16)
		wQueueFrame.hostlistFindButton:SetHeight(16)
		wQueueFrame.hostlistFindButton:SetChecked(isFinding)
		
		wQueueFrame.hostlistFindButton:SetScript("OnClick", function()
			if this:GetChecked() then
				wQueueFrame.hostlistHostButton:Show()
				wQueueFrame.hostlistLevelField:Hide()
				wQueueFrame.hostlistNameField:Hide()
				wQueueFrame.hostlistCreateButton:Hide()
				isFinding = true
				wQueue_SlashCommandHandler( "lfg " .. selectedQuery )
			elseif not this:GetChecked() then
				isFinding = false
			end
		end)
		
		wQueueFrame.hostlistNameField = CreateFrame("EditBox", nil, wQueueFrame.hostlist )
		wQueueFrame.hostlistNameField:SetPoint("CENTER", wQueueFrame.hostlist, "CENTER", 0, 20)
		wQueueFrame.hostlistNameField:SetAutoFocus(false)
		wQueueFrame.hostlistNameField:SetFont("Fonts\\FRIZQT__.TTF", 10)
		wQueueFrame.hostlistNameField:SetTextColor(wQueueColors["WHITE"][1], wQueueColors["WHITE"][2], wQueueColors["WHITE"][3])
		wQueueFrame.hostlistNameField:SetMaxLetters(36)
		wQueueFrame.hostlistNameField:SetBackdrop(wQueueFrameBackdrop)
		wQueueFrame.hostlistNameField:SetBackdropColor(30/255, 30/255, 30/255, 1.0)
		wQueueFrame.hostlistNameField:SetWidth(wQueueFrame.hostlist:GetWidth() * 4/5)
		wQueueFrame.hostlistNameField:SetTextInsets(4, 0, 0, 0)
		wQueueFrame.hostlistNameField:SetHeight(20)
		wQueueFrame.hostlistNameField:SetFrameLevel(4)
		
		wQueueFrame.hostlistNameFieldText = CreateFrame("Button", nil, wQueueFrame.hostlistNameField, "UIPanelButtonGrayTemplate")
		wQueueFrame.hostlistNameFieldText:ClearAllPoints()
		wQueueFrame.hostlistNameFieldText:SetPoint("CENTER", wQueueFrame.hostlistNameField, "CENTER", -8, 20)
		--wQueueFrame.hostlistNameFieldText:SetFont("Fonts\\FRIZQT__.TTF", 12)
		wQueueFrame.hostlistNameFieldText:SetText("Title")
		wQueueFrame.hostlistNameFieldText:EnableMouse(false)
		--wQueueFrame.hostlistNameFieldText:SetTextColor(wQueueColors["YELLOW"][1], wQueueColors["YELLOW"][2], wQueueColors["YELLOW"][3])
		wQueueFrame.hostlistNameFieldText:SetPushedTextOffset(0,0)
		wQueueFrame.hostlistNameFieldText:SetWidth(wQueueFrame.hostlistNameFieldText:GetTextWidth()+20)
		wQueueFrame.hostlistNameFieldText:SetHeight(wQueueFrame.hostlistNameFieldText:GetTextHeight())
		wQueueFrame.hostlistNameFieldText:SetFrameLevel(4)
		
		wQueueFrame.hostlistLevelField = CreateFrame("EditBox", nil, wQueueFrame.hostlistNameField )
		wQueueFrame.hostlistLevelField:SetPoint("TOPLEFT", wQueueFrame.hostlistNameField, "BOTTOMLEFT", 55, -6)
		wQueueFrame.hostlistLevelField:SetAutoFocus(false)
		wQueueFrame.hostlistLevelField:SetFont("Fonts\\FRIZQT__.TTF", 10)
		wQueueFrame.hostlistLevelField:SetText(tostring(UnitLevel("player")))
		wQueueFrame.hostlistLevelField:SetTextColor(wQueueColors["WHITE"][1], wQueueColors["WHITE"][2], wQueueColors["WHITE"][3])
		wQueueFrame.hostlistLevelField:SetMaxLetters(2)
		wQueueFrame.hostlistLevelField:SetBackdrop(wQueueFrameBackdrop)
		wQueueFrame.hostlistLevelField:SetBackdropColor(30/255, 30/255, 30/255, 1.0)
		wQueueFrame.hostlistLevelField:SetTextInsets(3, 0, 0, 0)
		wQueueFrame.hostlistLevelField:SetNumeric(true)
		wQueueFrame.hostlistLevelField:SetWidth(20)
		wQueueFrame.hostlistLevelField:SetHeight(18)
		wQueueFrame.hostlistLevelField:SetFrameLevel(4)
		
		wQueueFrame.hostlistLevelFieldText = CreateFrame("Button", nil, wQueueFrame.hostlistLevelField, "UIPanelButtonTemplate")
		wQueueFrame.hostlistLevelFieldText:ClearAllPoints()
		wQueueFrame.hostlistLevelFieldText:SetPoint("RIGHT", wQueueFrame.hostlistLevelField, "LEFT", -3, 0)
		--wQueueFrame.hostlistLevelFieldText:SetFont("Fonts\\FRIZQT__.TTF", 8)
		wQueueFrame.hostlistLevelFieldText:SetText("Minimum lvl")
		--wQueueFrame.hostlistLevelFieldText:SetTextColor(wQueueColors["YELLOW"][1], wQueueColors["YELLOW"][2], wQueueColors["YELLOW"][3])
		wQueueFrame.hostlistLevelFieldText:SetPushedTextOffset(0,0)
		wQueueFrame.hostlistLevelFieldText:SetWidth(wQueueFrame.hostlistLevelFieldText:GetTextWidth())
		wQueueFrame.hostlistLevelFieldText:SetHeight(wQueueFrame.hostlistLevelFieldText:GetTextHeight())
		wQueueFrame.hostlistLevelFieldText:SetFrameLevel(4)
		
		wQueueFrame.replyFrame = CreateFrame("Frame", nil, wQueueFrame)
		wQueueFrame.replyFrame:SetWidth(300)
		wQueueFrame.replyFrame:SetHeight(150)
		wQueueFrame.replyFrame:SetPoint("CENTER", wQueueFrame)
		wQueueFrame.replyFrame:SetBackdrop(wQueueFrameBackdrop)
		wQueueFrame.replyFrame:SetFrameLevel(4)
		wQueueFrame.replyFrame:SetBackdropColor(15/255, 15/255, 15/255, 0.9)
		
		wQueueFrame.replyFrameToString = wQueueFrame.replyFrame:CreateFontString(nil)
		wQueueFrame.replyFrameToString:SetFont("Fonts\\FRIZQT__.TTF", 10)
		wQueueFrame.replyFrameToString:SetText("To:")
		wQueueFrame.replyFrameToString:SetTextColor(wQueueColors["YELLOW"][1], wQueueColors["YELLOW"][2], wQueueColors["YELLOW"][3])
		wQueueFrame.replyFrameToString:SetWidth(wQueueFrame.replyFrameToString:GetStringWidth())
		wQueueFrame.replyFrameToString:SetHeight(8)
		wQueueFrame.replyFrameToString:SetPoint("TOPLEFT", wQueueFrame.replyFrame, "TOPLEFT", 5, -13)
		
		wQueueFrame.replyFrameTo = CreateFrame("EditBox", nil, wQueueFrame.replyFrame )
		wQueueFrame.replyFrameTo:SetPoint("TOPLEFT", wQueueFrame.replyFrame, "TOPLEFT", 25, -8)
		wQueueFrame.replyFrameTo:SetAutoFocus(false)
		wQueueFrame.replyFrameTo:SetFont("Fonts\\FRIZQT__.TTF", 10)
		wQueueFrame.replyFrameTo:SetText("LFM")
		wQueueFrame.replyFrameTo:SetTextColor(wQueueColors["WHITE"][1], wQueueColors["WHITE"][2], wQueueColors["WHITE"][3])
		wQueueFrame.replyFrameTo:SetMaxLetters(12)
		wQueueFrame.replyFrameTo:SetWidth(wQueueFrame.replyFrame:GetWidth() * 4/5 - 10)
		wQueueFrame.replyFrameTo:SetHeight(20)
		wQueueFrame.replyFrameTo:SetBackdrop(wQueueFrameBackdrop)
		wQueueFrame.replyFrameTo:SetBackdropColor(25/255, 25/255, 25/255, 1.0)
		wQueueFrame.replyFrameTo:SetTextInsets(5, 0, 0, 0)
		
		wQueueFrame.replyFrameMsg = CreateFrame("EditBox", nil, wQueueFrame.replyFrame )
		wQueueFrame.replyFrameMsg:SetPoint("TOPLEFT", wQueueFrame.replyFrame, "TOPLEFT", 5, -30)
		wQueueFrame.replyFrameMsg:SetPoint("BOTTOMRIGHT", wQueueFrame.replyFrame, "BOTTOMRIGHT", -5, 20)
		wQueueFrame.replyFrameMsg:SetAutoFocus(false)
		wQueueFrame.replyFrameMsg:SetFont("Fonts\\FRIZQT__.TTF", 10)
		wQueueFrame.replyFrameMsg:SetTextColor(wQueueColors["WHITE"][1], wQueueColors["WHITE"][2], wQueueColors["WHITE"][3])
		wQueueFrame.replyFrameMsg:SetMaxLetters(200)
		wQueueFrame.replyFrameMsg:SetBackdrop(wQueueFrameBackdrop)
		wQueueFrame.replyFrameMsg:SetBackdropColor(25/255, 25/255, 25/255, 1.0)
		wQueueFrame.replyFrameMsg:SetMultiLine(true)
		wQueueFrame.replyFrameMsg:SetTextInsets(5, 5, 5, 0)
		
		wQueueFrame.replyFrameSend = wQueue_newButton(wQueueFrame.replyFrame, 10)
		wQueueFrame.replyFrameSend:SetPoint("BOTTOMRIGHT", wQueueFrame.replyFrame, "BOTTOMRIGHT", -8, 8)
		wQueueFrame.replyFrameSend:SetText("Send")
		wQueueFrame.replyFrameSend:SetWidth(wQueueFrame.replyFrameSend:GetTextWidth()+5)
		wQueueFrame.replyFrameSend:SetScript("OnClick", function()
			addToSet(chatQueue, wQueueFrame.replyFrameMsg:GetText() .. "-WHISPER-" .. wQueueFrame.replyFrameTo:GetText())
			this:GetParent():Hide()
		end)
		
		wQueueFrame.replyFrameClose = wQueue_newButton(wQueueFrame.replyFrame, 10)
		wQueueFrame.replyFrameClose:SetPoint("TOPRIGHT", wQueueFrame.replyFrame, "TOPRIGHT", -8, -8)
		wQueueFrame.replyFrameClose:SetText("Close")
		wQueueFrame.replyFrameClose:SetWidth(wQueueFrame.replyFrameClose:GetTextWidth()+5)
		wQueueFrame.replyFrameClose:SetScript("OnClick", function()
			this:GetParent():Hide()
		end)
		wQueueFrame.replyFrame:Hide()
		
		wQueueFrame.optionsFrameTopString = wQueueFrame.optionsFrame:CreateFontString(nil)
		wQueueFrame.optionsFrameTopString:SetFont("Fonts\\FRIZQT__.TTF", 10)
		wQueueFrame.optionsFrameTopString:SetText("wQueue v" .. GetAddOnMetadata("wQueue", "Version") .." by Hazar Options")
		wQueueFrame.optionsFrameTopString:SetTextColor(wQueueColors["YELLOW"][1], wQueueColors["YELLOW"][2], wQueueColors["YELLOW"][3])
		wQueueFrame.optionsFrameTopString:SetWidth(wQueueFrame.optionsFrameTopString:GetStringWidth())
		wQueueFrame.optionsFrameTopString:SetHeight(8)
		wQueueFrame.optionsFrameTopString:SetPoint("TOP", wQueueFrame.optionsFrame, "TOP", 0, -7)
		
		wQueueFrame.filterCheck = CreateFrame("CheckButton", "optionsFilterCheck", wQueueFrame.optionsFrame, "UICheckButtonTemplate");
		wQueueFrame.filterCheck:SetWidth(18)
		wQueueFrame.filterCheck:SetHeight(18)
		getglobal(wQueueFrame.filterCheck:GetName() .."Text"):SetText("Hide channel messages")
		wQueueFrame.filterCheck:SetPoint("TOPLEFT", wQueueFrame.optionsFrame, "TOPLEFT", 5, -15)
		wQueueFrame.filterCheck:SetChecked(wQueueOptions["filter"])
		wQueueFrame.filterCheck:SetScript("OnClick", function()
			if this:GetChecked() then
				wQueueFrame.filterCheckGeneral:Enable()
				wQueueFrame.filterCheckTrade:Enable()
				wQueueFrame.filterCheckLFG:Enable()
				wQueueFrame.filterCheckWorld:Enable()
				wQueueFrame.filterCheckGlobal:Enable()
				wQueueFrame.filterCheckOnlyFilter:Enable()
				wQueueOptions["filter"] = true
			elseif not this:GetChecked() then
				wQueueFrame.filterCheckGeneral:Disable()
				wQueueFrame.filterCheckTrade:Disable()
				wQueueFrame.filterCheckLFG:Disable()
				wQueueFrame.filterCheckWorld:Disable()
				wQueueFrame.filterCheckGlobal:Disable()
				wQueueFrame.filterCheckOnlyFilter:Disable()
				wQueueOptions["filter"] = false
			end
		end)
		
		wQueueFrame.filterCheckGeneral = CreateFrame("CheckButton", "optionsFilterCheckGeneral", wQueueFrame.optionsFrame, "UICheckButtonTemplate");
		wQueueFrame.filterCheckGeneral:SetWidth(16)
		wQueueFrame.filterCheckGeneral:SetHeight(16)
		getglobal(wQueueFrame.filterCheckGeneral:GetName() .."Text"):SetText("General")
		getglobal(wQueueFrame.filterCheckGeneral:GetName() .."Text"):SetFont("Fonts\\FRIZQT__.TTF", 8)
		wQueueFrame.filterCheckGeneral:SetPoint("TOPLEFT", wQueueFrame.optionsFrame, "TOPLEFT", 15, -30)
		if not wQueueOptions["filter"] then wQueueFrame.filterCheckGeneral:Disable() end
		wQueueFrame.filterCheckGeneral:SetChecked(wQueueOptions["general"])
		wQueueFrame.filterCheckGeneral:SetScript("OnClick", function()
			if this:GetChecked() then
				wQueueOptions["general"] = true
			elseif not this:GetChecked() then
				wQueueOptions["general"] = false
			end
		end)
		
		wQueueFrame.filterCheckTrade = CreateFrame("CheckButton", "optionsFilterCheckTrade", wQueueFrame.optionsFrame, "UICheckButtonTemplate");
		wQueueFrame.filterCheckTrade:SetWidth(16)
		wQueueFrame.filterCheckTrade:SetHeight(16)
		getglobal(wQueueFrame.filterCheckTrade:GetName() .."Text"):SetText("Trade")
		getglobal(wQueueFrame.filterCheckTrade:GetName() .."Text"):SetFont("Fonts\\FRIZQT__.TTF", 8)
		wQueueFrame.filterCheckTrade:SetPoint("TOPLEFT", wQueueFrame.optionsFrame, "TOPLEFT", 15, -42)
		if not wQueueOptions["filter"] then wQueueFrame.filterCheckTrade:Disable() end
		wQueueFrame.filterCheckTrade:SetChecked(wQueueOptions["trade"])
		wQueueFrame.filterCheckTrade:SetScript("OnClick", function()
			if this:GetChecked() then
				wQueueOptions["trade"] = true
			elseif not this:GetChecked() then
				wQueueOptions["trade"] = false
			end
		end)
		
		wQueueFrame.filterCheckLFG = CreateFrame("CheckButton", "optionsFilterCheckLFG", wQueueFrame.optionsFrame, "UICheckButtonTemplate");
		wQueueFrame.filterCheckLFG:SetWidth(16)
		wQueueFrame.filterCheckLFG:SetHeight(16)
		getglobal(wQueueFrame.filterCheckLFG:GetName() .."Text"):SetText("Looking For Group")
		getglobal(wQueueFrame.filterCheckLFG:GetName() .."Text"):SetFont("Fonts\\FRIZQT__.TTF", 8)
		wQueueFrame.filterCheckLFG:SetPoint("TOPLEFT", wQueueFrame.optionsFrame, "TOPLEFT", 15, -54)
		if not wQueueOptions["filter"] then wQueueFrame.filterCheckLFG:Disable() end
		wQueueFrame.filterCheckLFG:SetChecked(wQueueOptions["lfg"])
		wQueueFrame.filterCheckLFG:SetScript("OnClick", function()
			if this:GetChecked() then
				wQueueOptions["lfg"] = true
			elseif not this:GetChecked() then
				wQueueOptions["lfg"] = false
			end
		end)
		
		wQueueFrame.filterCheckWorld = CreateFrame("CheckButton", "optionsFilterCheckWorld", wQueueFrame.optionsFrame, "UICheckButtonTemplate");
		wQueueFrame.filterCheckWorld:SetWidth(16)
		wQueueFrame.filterCheckWorld:SetHeight(16)
		getglobal(wQueueFrame.filterCheckWorld:GetName() .."Text"):SetText("World")
		getglobal(wQueueFrame.filterCheckWorld:GetName() .."Text"):SetFont("Fonts\\FRIZQT__.TTF", 8)
		wQueueFrame.filterCheckWorld:SetPoint("TOPLEFT", wQueueFrame.optionsFrame, "TOPLEFT", 15, -66)
		if not wQueueOptions["filter"] then wQueueFrame.filterCheckWorld:Disable() end
		wQueueFrame.filterCheckWorld:SetChecked(wQueueOptions["world"])
		wQueueFrame.filterCheckWorld:SetScript("OnClick", function()
			if this:GetChecked() then
				wQueueOptions["world"] = true
			elseif not this:GetChecked() then
				wQueueOptions["world"] = false
			end
		end)
		
		wQueueFrame.filterCheckGlobal = CreateFrame("CheckButton", "optionsFilterCheckGlobal", wQueueFrame.optionsFrame, "UICheckButtonTemplate");
		wQueueFrame.filterCheckGlobal:SetWidth(16)
		wQueueFrame.filterCheckGlobal:SetHeight(16)
		getglobal(wQueueFrame.filterCheckGlobal:GetName() .."Text"):SetText("Global")
		getglobal(wQueueFrame.filterCheckGlobal:GetName() .."Text"):SetFont("Fonts\\FRIZQT__.TTF", 8)
		wQueueFrame.filterCheckGlobal:SetPoint("TOPLEFT", wQueueFrame.optionsFrame, "TOPLEFT", 15, -78)
		if not wQueueOptions["filter"] then wQueueFrame.filterCheckGlobal:Disable() end
		wQueueFrame.filterCheckGlobal:SetChecked(wQueueOptions["global"])
		wQueueFrame.filterCheckGlobal:SetScript("OnClick", function()
			if this:GetChecked() then
				wQueueOptions["global"] = true
			elseif not this:GetChecked() then
				wQueueOptions["global"] = false
			end
		end)
		
		wQueueFrame.filterCheckOnlyFilter = CreateFrame("CheckButton", "optionsFilterCheckOnlyLfg", wQueueFrame.optionsFrame, "UICheckButtonTemplate");
		wQueueFrame.filterCheckOnlyFilter:SetWidth(16)
		wQueueFrame.filterCheckOnlyFilter:SetHeight(16)
		getglobal(wQueueFrame.filterCheckOnlyFilter:GetName() .."Text"):SetText("Only hide LFG/LFM messages")
		wQueueFrame.filterCheckOnlyFilter:SetPoint("TOPLEFT", wQueueFrame.optionsFrame, "TOPLEFT", 15, -92)
		if not wQueueOptions["filter"] then wQueueFrame.filterCheckOnlyFilter:Disable() end
		wQueueFrame.filterCheckOnlyFilter:SetChecked(wQueueOptions["onlylfg"])
		wQueueFrame.filterCheckOnlyFilter:SetScript("OnClick", function()
			if this:GetChecked() then
				wQueueOptions["onlylfg"] = true
			elseif not this:GetChecked() then
				wQueueOptions["onlylfg"] = false
			end
		end)
		
		wQueueFrame.optionsFrameClose = wQueue_newButton(wQueueFrame.optionsFrame, 10)
		wQueueFrame.optionsFrameClose:SetPoint("BOTTOM", wQueueFrame.optionsFrame, "BOTTOM", 0, 5)
		wQueueFrame.optionsFrameClose:SetText("Save")
		wQueueFrame.optionsFrameClose:SetWidth(wQueueFrame.optionsFrameClose:GetTextWidth()+10)
		wQueueFrame.optionsFrameClose:SetScript("OnClick", function()
			this:GetParent():Hide()
		end)
		
		wQueueFrame.optionsFrameFix = wQueue_newButton(wQueueFrame.optionsFrame, 10)
		wQueueFrame.optionsFrameFix:SetPoint("TOPLEFT", wQueueFrame.filterCheckOnlyFilter, "BOTTOMLEFT", 0, 0)
		wQueueFrame.optionsFrameFix:SetText("Leave all Channels")
		wQueueFrame.optionsFrameFix:SetWidth(wQueueFrame.optionsFrameFix:GetTextWidth()+15)
		wQueueFrame.optionsFrameFix:SetScript("OnClick", function()
			LeaveChannelByName(channelName)
			fixingChat = true
			whoRequestTimer = 0
			idleMessage = 0
			for i = 1, 10 do
				id, name = GetChannelName(i)
				if (name ~= nil) then
					LeaveChannelByName(name)
				end
			end
		end)
		
		--Role Icons for group creation
		wQueueFrame.hostlistHostHealer = CreateFrame("Button", "wQueueInfoButton", wQueueFrame.hostlistNameField, "UIPanelButtonTemplate")
		wQueueFrame.hostlistHostHealer:SetWidth(32)
		wQueueFrame.hostlistHostHealer:SetHeight(32)
		wQueueFrame.hostlistHostHealer:SetPoint("TOPRIGHT", wQueueFrame.hostlistNameField, "BOTTOMRIGHT", -32, -5)
		wQueueFrame.hostlistHostHealer:SetFrameLevel(4)
		wQueueFrame.hostlistHostHealerTex = wQueueFrame.hostlistHostHealer:CreateTexture(nil, "ARTWORK")
		wQueueFrame.hostlistHostHealerTex:SetAllPoints()
		wQueueFrame.hostlistHostHealerTex:SetTexture("Interface\\AddOns\\wQueue\\media\\Healer")
		wQueueFrame.hostlistHostHealerTex:SetWidth(wQueueFrame.hostlistHostHealer:GetWidth())
		wQueueFrame.hostlistHostHealerTex:SetHeight(wQueueFrame.hostlistHostHealer:GetHeight())
		wQueueFrame.hostlistHostHealCheck = wQueueFrame.hostlistHostHealer:CreateTexture(nil, "OVERLAY")
		wQueueFrame.hostlistHostHealCheck:SetTexture("Interface\\BUTTONS\\UI-CheckBox-Check")
		wQueueFrame.hostlistHostHealCheck:SetVertexColor(0.1,0.8,0.1)
		wQueueFrame.hostlistHostHealCheck:SetAllPoints()
		healerSelected = true
		wQueueFrame.hostlistHostHealer:SetScript("OnMouseDown", function()
			healerSelected = not healerSelected
			if healerSelected then
				wQueueFrame.hostlistHostHealCheck:Show()
			else
				wQueueFrame.hostlistHostHealCheck:Hide()
			end
		end)
		wQueueFrame.hostlistHostHealer:SetScript("OnEnter", function()
			wQueueFrame.hostlistHostHealerTex:SetVertexColor(1, 1, 0)
		end)
		wQueueFrame.hostlistHostHealer:SetScript("OnLeave", function()
			wQueueFrame.hostlistHostHealerTex:SetVertexColor(1, 1, 1)
		end)
		
		wQueueFrame.hostlistHostDamage = CreateFrame("Button", "wQueueInfoButton", wQueueFrame.hostlistNameField, "UIPanelButtonTemplate")
		wQueueFrame.hostlistHostDamage:SetWidth(32)
		wQueueFrame.hostlistHostDamage:SetHeight(32)
		wQueueFrame.hostlistHostDamage:SetFrameLevel(4)
		wQueueFrame.hostlistHostDamage:SetPoint("TOPRIGHT", wQueueFrame.hostlistNameField, "BOTTOMRIGHT", 0, -5)
		wQueueFrame.hostlistHostDamageTex = wQueueFrame.hostlistHostDamage:CreateTexture(nil, "ARTWORK")
		wQueueFrame.hostlistHostDamageTex:SetAllPoints()
		wQueueFrame.hostlistHostDamageTex:SetTexture("Interface\\AddOns\\wQueue\\media\\Damage")
		wQueueFrame.hostlistHostDamageTex:SetWidth(wQueueFrame.hostlistHostDamage:GetWidth())
		wQueueFrame.hostlistHostDamageTex:SetHeight(wQueueFrame.hostlistHostDamage:GetHeight())
		wQueueFrame.hostlistHostDamageCheck = wQueueFrame.hostlistHostDamage:CreateTexture(nil, "OVERLAY")
		wQueueFrame.hostlistHostDamageCheck:SetTexture("Interface\\BUTTONS\\UI-CheckBox-Check")
		wQueueFrame.hostlistHostDamageCheck:SetVertexColor(0.1,0.8,0.1)
		wQueueFrame.hostlistHostDamageCheck:SetAllPoints()
		damageSelected = true
		wQueueFrame.hostlistHostDamage:SetScript("OnMouseDown", function()
			damageSelected = not damageSelected
			if damageSelected then
				wQueueFrame.hostlistHostDamageCheck:Show()
			else
				wQueueFrame.hostlistHostDamageCheck:Hide()
			end
		end)
		wQueueFrame.hostlistHostDamage:SetScript("OnEnter", function()
			wQueueFrame.hostlistHostDamageTex:SetVertexColor(1, 1, 0)
		end)
		wQueueFrame.hostlistHostDamage:SetScript("OnLeave", function()
			wQueueFrame.hostlistHostDamageTex:SetVertexColor(1, 1, 1)
		end)
		
		wQueueFrame.hostlistHostTank = CreateFrame("Button", "wQueueInfoButton", wQueueFrame.hostlistNameField, "UIPanelButtonTemplate")
		wQueueFrame.hostlistHostTank:SetWidth(32)
		wQueueFrame.hostlistHostTank:SetHeight(32)
		wQueueFrame.hostlistHostTank:SetFrameLevel(4)
		wQueueFrame.hostlistHostTank:SetPoint("TOPRIGHT", wQueueFrame.hostlistNameField, "BOTTOMRIGHT", -64, -5)
		wQueueFrame.hostlistHostTankTex = wQueueFrame.hostlistHostTank:CreateTexture(nil, "ARTWORK")
		wQueueFrame.hostlistHostTankTex:SetAllPoints()
		wQueueFrame.hostlistHostTankTex:SetTexture("Interface\\AddOns\\wQueue\\media\\Tank")
		wQueueFrame.hostlistHostTankTex:SetWidth(wQueueFrame.hostlistHostTank:GetWidth())
		wQueueFrame.hostlistHostTankTex:SetHeight(wQueueFrame.hostlistHostTank:GetHeight())
		wQueueFrame.hostlistHostTankCheck = wQueueFrame.hostlistHostTank:CreateTexture(nil, "OVERLAY")
		wQueueFrame.hostlistHostTankCheck:SetTexture("Interface\\BUTTONS\\UI-CheckBox-Check")
		wQueueFrame.hostlistHostTankCheck:SetVertexColor(0.1,0.8,0.1)
		wQueueFrame.hostlistHostTankCheck:SetAllPoints()
		tankSelected = true
		wQueueFrame.hostlistHostTank:SetScript("OnMouseDown", function()
			tankSelected = not tankSelected
			if tankSelected then
				wQueueFrame.hostlistHostTankCheck:Show()
			else
				wQueueFrame.hostlistHostTankCheck:Hide()
			end
		end)
		wQueueFrame.hostlistHostTank:SetScript("OnEnter", function()
			wQueueFrame.hostlistHostTankTex:SetVertexColor(1, 1, 0)
		end)
		wQueueFrame.hostlistHostTank:SetScript("OnLeave", function()
			wQueueFrame.hostlistHostTankTex:SetVertexColor(1, 1, 1)
		end)
		
		wQueueFrame.hostlistNeededRolesText = CreateFrame("Button", nil, wQueueFrame.hostlistHostTank , "UIPanelButtonTemplate")
		wQueueFrame.hostlistNeededRolesText:SetPoint("RIGHT", wQueueFrame.hostlistHostTank , "LEFT", 0, 2)
		--wQueueFrame.hostlistNeededRolesText:SetFont("Fonts\\FRIZQT__.TTF", 8)
		wQueueFrame.hostlistNeededRolesText:SetText("Needed roles")
		--wQueueFrame.hostlistNeededRolesText:SetTextColor(wQueueColors["YELLOW"][1], wQueueColors["YELLOW"][2], wQueueColors["YELLOW"][3])
		wQueueFrame.hostlistNeededRolesText:SetPushedTextOffset(0,0)
		wQueueFrame.hostlistNeededRolesText:SetWidth(wQueueFrame.hostlistNeededRolesText:GetTextWidth())
		wQueueFrame.hostlistNeededRolesText:SetHeight(wQueueFrame.hostlistNeededRolesText:GetTextHeight())
		---------------------------------------------------
		
		wQueueFrame.hostlistCancelButton = wQueue_newButton(wQueueFrame.hostlist, 10)
		wQueueFrame.hostlistCancelButton:SetPoint("CENTER", wQueueFrame.hostlist, "CENTER", -8, -130)
		wQueueFrame.hostlistCancelButton:SetText("Cancel")
		wQueueFrame.hostlistCancelButton:SetWidth(wQueueFrame.hostlistCancelButton:GetTextWidth()+20)
		wQueueFrame.hostlistCancelButton:SetFrameLevel(4)
		wQueueFrame.hostlistCancelButton:SetScript("OnClick", function()
			isWaitListShown = false
			if selectedQuery == "waitlist" then selectedQuery = hostedCategory end
			wQueue_ShowGroups(selectedQuery, selectedQuery)
			wQueueFrame.hostTitleFindName:Show()
			wQueueFrame.hostTitleFindLeader:Show()
			wQueueFrame.hostTitleFindLevel:Show()
			wQueueFrame.hostTitleFindSize:Show()
			wQueueFrame.hostTitleFindRoles:Show()
			wQueueFrame.hostlistLevelField:Hide()
			wQueueFrame.hostlistNameField:Hide()
			wQueueFrame.hostlistCreateButton:Hide()
			wQueueFrame.hostlistHostButton:Show()
			this:Hide()
		end)
		wQueueFrame.hostlistCancelButton:Hide()
		
		wQueueFrame.hostlistCreateButton = wQueue_newButton(wQueueFrame.hostlist, 14)
		wQueueFrame.hostlistCreateButton:SetPoint("CENTER", wQueueFrame.hostlist, "CENTER", -8, -100)
		wQueueFrame.hostlistCreateButton:SetText("Create group")
		wQueueFrame.hostlistCreateButton:SetWidth(wQueueFrame.hostlistCreateButton:GetTextWidth()+30)
		wQueueFrame.hostlistCreateButton:SetFrameLevel(4)
		wQueueFrame.hostlistCreateButton:SetScript("OnClick", function()
			if wQueueFrame.hostlistNameField:GetText() ~= "" and wQueueFrame.hostlistLevelField:GetText() ~= "" then
				if tonumber(wQueueFrame.hostlistLevelField:GetText()) < 1 then wQueueFrame.hostlistLevelField:SetText("1") end
				if tonumber(wQueueFrame.hostlistLevelField:GetText()) > 60 then wQueueFrame.hostlistLevelField:SetText("60") end
				local name = wQueueFrame.hostlistNameField:GetText()
				local strippedStr = ""
				for i=1, string.len(name) do
					local add = true
					if string.sub(name, i, i) == ":" or string.sub(name, i, i) == "-" then
						add = false
					end
					if add then
						strippedStr = strippedStr .. string.sub(name, i, i)
					end
				end
				hostOptions[0] = strippedStr
				hostOptions[1] = wQueueFrame.hostlistLevelField:GetText()
				hostOptions[2] = healerSelected
				hostOptions[3] = damageSelected
				hostOptions[4] = tankSelected
				wQueueFrame.topsectionHostName:SetWidth(400)
				wQueueFrame.topsectionHostName:SetText(hostOptions[0])
				wQueueFrame.topsectionHostName:SetWidth(wQueueFrame.topsectionHostName:GetTextWidth())
				wQueueFrame.topsectionMinLvl:SetWidth(100)
				wQueueFrame.topsectionMinLvl:SetText(hostOptions[1] .. "+")
				wQueueFrame.topsectionMinLvl:SetWidth(wQueueFrame.topsectionMinLvl:GetStringWidth())
				if healerSelected then wQueueFrame.topsectionHostHeal:Show() else wQueueFrame.topsectionHostHeal:Hide() end
				if damageSelected then wQueueFrame.topsectionHostDamage:Show() else wQueueFrame.topsectionHostDamage:Hide() end
				if tankSelected then wQueueFrame.topsectionHostTank:Show() else wQueueFrame.topsectionHostTank:Hide() end
				wQueueFrame.hostlistLevelField:Hide()
				wQueueFrame.hostlistNameField:Hide()
				wQueueFrame.hostlistCancelButton:Hide()
				this:Hide()
				wQueueFrame.hostlistEditButton:Show()
				wQueueFrame.hostlistUnlistButton:Show()
				wQueueFrame.hostlistWaitListButton:Show()
				wQueueFrame.hostTitle:Show()
				wQueueFrame.hostTitleRole:Show()
				wQueueFrame.hostTitleClass:Show()
				wQueueFrame.hostTitleLevel:Show()
				wQueueFrame.topsectionHostName:Show()
				wQueueFrame.hostlistBotShadow:SetHeight(40)
				if tablelength(groups[selectedQuery]) > 16 then wQueueFrame.hostlistBotShadow:Show() else wQueueFrame.hostlistBotShadow:Hide() end
				if isHost then return end
				wQueue_SlashCommandHandler( "host " .. selectedQuery )
			end
		end)
		
		--scrollbarhost
		scrollbar = CreateFrame("Slider", nil, wQueueFrame.hostlist, "UIPanelScrollBarTemplate") 
		scrollbar:SetMinMaxValues(1, 1)
		scrollbar:SetValueStep(1)
		scrollbar.scrollStep = 1
		scrollbar:SetValue(0)
		scrollbar:EnableMouse(true)
		scrollbar:EnableMouseWheel(true)
		scrollbar:SetWidth(16)
		scrollbar:SetHeight((wQueueFrame.hostlist:GetHeight()* 4/5) - 35)
		scrollbar:SetPoint("BOTTOMLEFT", wQueueFrame.hostlist, "BOTTOMRIGHT", -16, 16)
		scrollbar:SetScript("OnValueChanged",
		function (self, value)
			wQueue_UpdateHostScroll(arg1)
		end)
		scrollbar:Hide()
		
		--scrollbarcategory
		scrollbarCat = CreateFrame("Slider", nil, wQueueFrame.catList, "UIPanelScrollBarTemplate") 
		scrollbarCat:SetMinMaxValues(1, 10)
		scrollbarCat:SetValueStep(1)
		scrollbarCat.scrollStep = 1
		scrollbarCat:SetValue(0)
		scrollbarCat:EnableMouse(true)
		scrollbarCat:EnableMouseWheel(true)
		scrollbarCat:SetWidth(16)
		scrollbarCat:SetHeight(wQueueFrame.catList:GetHeight()-32)
		scrollbarCat:SetPoint("BOTTOMLEFT", wQueueFrame.catList, "BOTTOMRIGHT", -16, 16)
		scrollbarCat:SetScript("OnValueChanged",
		function (self, value)
			wQueue_UpdateCatScroll(arg1)
		end)
		scrollbarCat:Hide()
		
		
		wQueueFrame.title = CreateFrame("Button", "wQueueButton", wQueueFrame.hostlist, "UIPanelButtonGrayTemplate")
		wQueueFrame.title:ClearAllPoints()
		wQueueFrame.title:SetPoint("CENTER", wQueueFrame.hostlist, "TOP", 0 , 6)
		--wQueueFrame.title:SetFont("Fonts\\FRIZQT__.TTF", 10)
		wQueueFrame.title:SetText("wQueue")
		wQueueFrame.title:EnableMouse(false)
		--wQueueFrame.title:SetTextColor(wQueueColors["YELLOW"][1], wQueueColors["YELLOW"][2], wQueueColors["YELLOW"][3])
		wQueueFrame.title:SetPushedTextOffset(0,0)
		wQueueFrame.title:SetWidth(wQueueFrame.title:GetTextWidth()+20)
		wQueueFrame.title:SetHeight(20)
		
		wQueueFrame.titleCat = CreateFrame("Button", "wQueueButton", wQueueFrame.catList, "UIPanelButtonGrayTemplate")
		wQueueFrame.titleCat:ClearAllPoints()
		wQueueFrame.titleCat:SetPoint("CENTER", wQueueFrame.catList, "TOP", 0 , 6)
		--wQueueFrame.titleCat:SetFont("Fonts\\FRIZQT__.TTF", 10)
		wQueueFrame.titleCat:SetText("Categories")
		wQueueFrame.titleCat:EnableMouse(false)
		--wQueueFrame.titleCat:SetTextColor(wQueueColors["YELLOW"][1], wQueueColors["YELLOW"][2], wQueueColors["YELLOW"][3])
		wQueueFrame.titleCat:SetPushedTextOffset(0,0)
		wQueueFrame.titleCat:SetWidth(100)
		wQueueFrame.titleCat:SetHeight(20)
		
		
		DEFAULT_CHAT_FRAME:AddMessage("Loaded " .. arg1)
		minimapButton = CreateFrame("Button", "wQueueMap", Minimap)
		minimapButton:SetFrameStrata("LOW")
		minimapButton:SetWidth(32)
		minimapButton:SetHeight(32)
		minimapButton:ClearAllPoints()
		minimapButton:SetPoint("TOPLEFT", Minimap,"TOPLEFT",54-(75*cos(MinimapPos)),(75*sin(MinimapPos))-55) 
		minimapButton:SetHighlightTexture("Interface\\MINIMAP\\UI-Minimap-ZoomButton-Highlight", "ADD")
		minimapButton:RegisterForDrag("RightButton")
		minimapButton.texture = minimapButton:CreateTexture(nil, "BUTTON")
		minimapButton.texture:SetTexture("Interface\\AddOns\\wQueue\\media\\icon")
		minimapButton.texture:SetPoint("CENTER", minimapButton)
		minimapButton.texture:SetWidth(20)
		minimapButton.texture:SetHeight(20)
		
		minimapButton.border = minimapButton:CreateTexture(nil, "BORDER")
		minimapButton.border:SetTexture("Interface\\MINIMAP\\MiniMap-TrackingBorder")
		minimapButton.border:SetPoint("TOPLEFT", minimapButton.texture, -6, 5)
		minimapButton.border:SetWidth(52)
		minimapButton.border:SetHeight(52)
		
		minimapButton.notifyText = minimapButton:CreateTexture(nil, "OVERLAY")
		minimapButton.notifyText:SetTexture("Interface\\MINIMAP\\UI-Minimap-ZoomButton-Highlight")
		minimapButton.notifyText:SetBlendMode("ADD")
		minimapButton.notifyText:SetAllPoints()
		minimapButton.notifyText:Hide()
		minimapButton:SetScript("OnMouseDown", function()
			point, relativeTo, relativePoint, xOffset, yOffset = minimapButton.texture:GetPoint(1)
			minimapButton.texture:SetPoint(point, relativeTo, relativePoint, xOffset + 2, yOffset - 2)
		end);
		minimapButton:SetScript("OnLeave", function(self, button)
			MinimapTool:Hide()
			minimapButton.notifyText:Hide()
			minimapButton.texture:SetPoint("CENTER", minimapButton)
		end);
		minimapButton:SetScript("OnMouseUp", function()
			if arg1 == "LeftButton" then
				if wQueueFrameShown then 
					wQueueFrame:Hide() 
					wQueueFrame.catList:Hide()
					wQueueFrame.hostlist:Hide()
					wQueueFrameShown = false
				else
					wQueueFrame:Show() 
					wQueueFrame.catList:Show()
					wQueueFrame.hostlist:Show()
					wQueueFrameShown = true
				end
			end
			minimapButton.texture:SetPoint("CENTER", minimapButton)
		end);
		minimapButton:SetScript("OnDragStart", function()
			miniDrag = true
		end)
		minimapButton:SetScript("OnDragStop", function()
			miniDrag = false
		end)
		minimapButton:SetScript("OnUpdate", function()
			if miniDrag then
				    local xpos,ypos = GetCursorPosition() 
					local xmin,ymin = Minimap:GetLeft(), Minimap:GetBottom() 

					xpos = xmin-xpos/UIParent:GetScale()+70 
					ypos = ypos/UIParent:GetScale()-ymin-70 
					
					MinimapPos = math.deg(math.atan2(ypos,xpos))
					if (MinimapPos < 0) then
						MinimapPos = MinimapPos + 360
					end
					this:SetPoint("TOPLEFT", Minimap,"TOPLEFT",54-(75*cos(MinimapPos)),(75*sin(MinimapPos))-55) 
			end
		end)
		CreateFrame( "GameTooltip", "MinimapTool", nil, "GameTooltipTemplate" ); -- Tooltip name cannot be nil
		minimapButton:SetScript("OnEnter", function()
			if isHost then
				MinimapTool:SetOwner( this, "ANCHOR_CURSOR" );
				MinimapTool:AddLine(tablelength(groups["waitlist"]) .. " player(s) in your wait list.", 1, 1, 1, 1)
				MinimapTool:Show()
			end
		end)
		MinimapTool:SetScript("OnUpdate", function()
			if this:IsShown() then
				this:Hide()
				MinimapTool:SetOwner( minimapButton, "ANCHOR_CURSOR" );
				MinimapTool:AddLine(tablelength(groups["waitlist"]) .. " player(s) in your wait list.", 1, 1, 1, 1)
				MinimapTool:Show()
			end
		end)
		
		
		wQueueFrame.topsectiontitle = CreateFrame("Button", "wQueueButton", wQueueFrame.hostlistTopSection, "UIPanelButtonGrayTemplate")
		wQueueFrame.topsectiontitle:ClearAllPoints()
		wQueueFrame.topsectiontitle:SetPoint("LEFT", wQueueFrame.hostlistTopSection, "LEFT", 5, wQueueFrame.hostlistTopSection:GetHeight() * 1/6)
		--wQueueFrame.topsectiontitle:SetFont("Fonts\\MORPHEUS.ttf", 24, "OUTLINE")
		wQueueFrame.topsectiontitle:SetText("<-- Select a catergory")
		--wQueueFrame.topsectiontitle:SetTextColor(wQueueColors["WHITE"][1], wQueueColors["WHITE"][2], wQueueColors["WHITE"][3])
		wQueueFrame.topsectiontitle:EnableMouse(false)
		wQueueFrame.topsectiontitle:SetFrameLevel(3)
		wQueueFrame.topsectiontitle:SetWidth(wQueueFrame.topsectiontitle:GetTextWidth()+20)
		wQueueFrame.topsectiontitle:SetHeight(wQueueFrame.topsectiontitle:GetTextHeight())
		
		wQueueFrame.topsectionHostName = CreateFrame("Button", "wQueueButton", wQueueFrame.topsectiontitle, "UIPanelButtonTemplate")
		wQueueFrame.topsectionHostName:SetPoint("TOPLEFT", wQueueFrame.topsectiontitle, "BOTTOMLEFT", 0, -3)
		--wQueueFrame.topsectionHostName:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE")
		wQueueFrame.topsectionHostName:SetText("")
		--wQueueFrame.topsectionHostName:SetTextColor(wQueueColors["YELLOW"][1], wQueueColors["YELLOW"][2], wQueueColors["YELLOW"][3])
		wQueueFrame.topsectionHostName:EnableMouse(false)
		wQueueFrame.topsectionHostName:SetWidth(wQueueFrame.topsectionHostName:GetTextWidth())
		wQueueFrame.topsectionHostName:SetHeight(wQueueFrame.topsectionHostName:GetTextHeight())
		wQueueFrame.topsectionHostName:Hide()
		
		wQueueFrame.topsectionMinLvl = wQueueFrame.topsectionHostName:CreateFontString(nil, "ARTWORK")
		wQueueFrame.topsectionMinLvl:SetPoint("TOPLEFT", wQueueFrame.topsectionHostName, "BOTTOMLEFT", -2, -3)
		wQueueFrame.topsectionMinLvl:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE")
		wQueueFrame.topsectionMinLvl:SetText("17+")
		wQueueFrame.topsectionMinLvl:SetTextColor(wQueueColors["YELLOW"][1], wQueueColors["YELLOW"][2], wQueueColors["YELLOW"][3])
		wQueueFrame.topsectionMinLvl:SetWidth(wQueueFrame.topsectionMinLvl:GetStringWidth())
		wQueueFrame.topsectionMinLvl:SetHeight(10)
		
		wQueueFrame.topsectionHostHeal = wQueueFrame.topsectionHostName:CreateTexture(nil, "ARTWORK")
		wQueueFrame.topsectionHostHeal:SetPoint("LEFT", wQueueFrame.topsectionMinLvl, "RIGHT", 12, 0)
		wQueueFrame.topsectionHostHeal:SetTexture("Interface\\AddOns\\wQueue\\media\\Healer")
		wQueueFrame.topsectionHostHeal:SetWidth(12)
		wQueueFrame.topsectionHostHeal:SetHeight(12)
		wQueueFrame.topsectionHostDamage = wQueueFrame.topsectionHostName:CreateTexture(nil, "ARTWORK")
		wQueueFrame.topsectionHostDamage:SetPoint("LEFT", wQueueFrame.topsectionMinLvl, "RIGHT", 24, 0)
		wQueueFrame.topsectionHostDamage:SetTexture("Interface\\AddOns\\wQueue\\media\\Damage")
		wQueueFrame.topsectionHostDamage:SetWidth(12)
		wQueueFrame.topsectionHostDamage:SetHeight(12)
		wQueueFrame.topsectionHostTank = wQueueFrame.topsectionHostName:CreateTexture(nil, "ARTWORK")
		wQueueFrame.topsectionHostTank:SetPoint("LEFT", wQueueFrame.topsectionMinLvl, "RIGHT", 0, 0)
		wQueueFrame.topsectionHostTank:SetTexture("Interface\\AddOns\\wQueue\\media\\Tank")
		wQueueFrame.topsectionHostTank:SetWidth(12)
		wQueueFrame.topsectionHostTank:SetHeight(12)
		
		wQueueFrame.catListHighlight = CreateFrame("Frame", nil, nil)
		wQueueFrame.catListHighlight:SetPoint("CENTER", wQueueFrame.catList, "CENTER", 0, 2)
		wQueueFrame.catListHighlight:SetWidth(wQueueFrame.catList:GetWidth()-4)
		wQueueFrame.catListHighlight:SetHeight(10)
		wQueueFrame.catListHighlightTex = wQueueFrame.catListHighlight:CreateTexture(nil, "ARTWORK")
		wQueueFrame.catListHighlightTex:SetTexture(1, 1, 0, 0.4)
		wQueueFrame.catListHighlightTex:SetGradientAlpha("HORIZONTAL", 1, 1, 0, 0.5, 1, 1, 0, 0)
		wQueueFrame.catListHighlightTex:SetAllPoints()
		wQueueFrame.catListHighlight:Hide()
		
		wQueue_createCategories("Burning Crusade")
		wQueue_createCategories("Raids")
		wQueue_createCategories("Battlegrounds")
		wQueue_createCategories("Classic")
		wQueue_createCategories("Quest Groups")
		wQueue_createCategories("Miscellaneous")

		minimapButton:Show()
		wQueueFrame:Hide()
		wQueueFrame.catList:Hide()
		wQueueFrame.hostlist:Hide()
		wQueueFrame.hostlistTank:Hide()
		wQueueFrame.hostlistHeal:Hide()
		wQueueFrame.hostlistDps:Hide()
		wQueueFrame.hostlistRoleText:Hide()
		wQueueFrame.hostlistLevelField:Hide()
		wQueueFrame.hostlistNameField:Hide()
		wQueueFrame.hostlistCreateButton:Hide()
		wQueueFrame.hostlistHostButton:Hide()
	end
	if event == "CHAT_MSG_CHANNEL" then
		if string.lower(arg9) ~= string.lower(channelName) then
			local puncString = filterPunctuation(arg1)
			for kLfm, vLfm in pairs(getglobal("LFMARGS")) do
				if Wholefind(puncString, vLfm) > 0 then
					local usedthis = false
					for kCat, kVal in pairs(getglobal("CATARGS")) do
						for kkCat, kkVal in pairs(kVal) do
							if Wholefind(puncString, kkVal) > 0 then
								usedthis = true
								local healerRole = ""
								local damageRole = ""
								local tankRole = ""
								for kHeal, vHeal in pairs(getglobal("ROLEARGS")["Healer"]) do
									if Wholefind(puncString, vHeal) > 0 then
										healerRole = "Healer"
									end
								end
								for kDps, vDps in pairs(getglobal("ROLEARGS")["Damage"]) do
									if Wholefind(puncString, vDps) > 0 then
										damageRole = "Damage"
									end
								end
								for kTank, vTank in pairs(getglobal("ROLEARGS")["Tank"]) do
									if Wholefind(puncString, vTank) > 0 then
										tankRole = "Tank"
									end
								end
								if healerRole == "" and tankRole == "" and damageRole == "" then
									healerRole = "Healer"
									damageRole = "Damage"
									tankRole = "Tank"
								end
								local strippedStr = ""
								for i=1, string.len(arg1) do
									local add = true
									if string.sub(arg1, i, i) == ":" then
										add = false
									end
									if add then
										strippedStr = strippedStr .. string.sub(arg1, i, i)
									end
								end
								leaderMessages[arg2] = strippedStr .. ":" .. kCat .. ":" .. tostring(GetTime())
								if kCat ~= "dm" then
									wQueue_addToGroup(kCat, "(Mouseover to see chat message)" .. ":" .. arg2 .. ":" .. getglobal("MINLVLS")[kCat] .. ":" .. "?" .. ":" .. healerRole .. ":" .. damageRole .. ":" .. tankRole)
								end
								if kCat == 'dm' then
									if not setContains(whoRequestList, arg2) then addToSet(whoRequestList, arg2) end
								end
								refreshCatList(kCat)
								break
							end
						end
					end
					--if not usedthis then 
						--DEFAULT_CHAT_FRAME:AddMessage("Added: " .. puncString)
						--table.insert(notCaught, tablelength(notCaught), puncString)
					--end
				end
			end
			if isHost then
			for kLfm, vLfm in pairs(getglobal("LFGARGS")) do
				if Wholefind(puncString, vLfm) > 0 then
					for kCat, kVal in pairs(getglobal("CATARGS")) do
						for kkCat, kkVal in pairs(kVal) do
							for groupindex = 1,MAX_PARTY_MEMBERS do
								if UnitName("party" .. tostring(groupindex)) == arg2 then return end
							end
							if Wholefind(puncString, kkVal) > 0 and isHost and hostedCategory == kCat then
								local exists = false
								local playerRole = ""
								for kHeal, vHeal in pairs(getglobal("ROLEARGS")["Healer"]) do
									if Wholefind(puncString, vHeal) > 0 then
										playerRole = "Healer"
									end
								end
								for kDps, vDps in pairs(getglobal("ROLEARGS")["Damage"]) do
									if Wholefind(puncString, vDps) > 0 then
										playerRole = "Damage"
									end
								end
								for kTank, vTank in pairs(getglobal("ROLEARGS")["Tank"]) do
									if Wholefind(puncString, vTank) > 0 then
										playerRole = "Tank"
									end
								end
								if playerRole == "" then playerRole = "Damage" end
								if not setContains(whoRequestList, arg2) then addToSet(whoRequestList, arg2) end
								local strippedStr = ""
								for i=1, string.len(arg1) do
									local add = true
									if string.sub(arg1, i, i) == ":" then
										add = false
									end
									if add then
										strippedStr = strippedStr .. string.sub(arg1, i, i)
									end
								end
								playerMessages[arg2] = strippedStr .. ":" .. GetTime()
								wQueue_addToWaitList(arg2 .. ":" .. "..." .. ":" .. "..." .. ":" .. playerRole)
								break
							end
						end
					end
				end
			end
			end
		end
		if string.lower(arg9) == string.lower(channelName) then
			local wQueueArgs = {}
			if arg1 ~= nil then
				wQueueArgs = split(arg1, "\%s")
			end
			
			if wQueueArgs[1] == "vqgroup" and wQueueArgs[2] ~= nil then
				local name = split(arg1, "\:")
				local healerRole = ""
				local damageRole = ""
				local tankRole = ""
				if wQueueArgs[5] == "true" then
					healerRole = "Healer"
				end
				if wQueueArgs[6] == "true" then
					damageRole = "Damage"
				end
				if wQueueArgs[7] == "true" then
				 tankRole = "Tank"
				end
				
				if tonumber(wQueueArgs[8]) == 0 and setContains(waitingList, arg2) then removeFromSet(waitingList, arg2)
				elseif tonumber(wQueueArgs[8]) == 1 and not setContains(waitingList, arg2) then addToSet(waitingList, arg2) end
				
				local strippedStr = ""
				for i=1, string.len(name[2]) do
					local add = true
					if string.sub(name[2], i, i) == ":" or string.sub(name[2], i, i) == "-" then
						add = false
					end
					if add then
						strippedStr = strippedStr .. string.sub(name[2], i, i)
					end
				end
				leaderMessages[arg2] = strippedStr .. ":" .. wQueueArgs[2] .. ":" .. GetTime()
				
				wQueue_addToGroup(wQueueArgs[2], strippedStr .. ":" .. arg2 .. ":" .. wQueueArgs[3] .. ":" .. wQueueArgs[4] .. ":" .. healerRole .. ":" .. damageRole .. ":" .. tankRole)
				refreshCatList(wQueueArgs[2])
			end	
		end
	end
	
	if event == "WHO_LIST_UPDATE" then
		wQueue_WhoSorting()
		
		if tablelength(whoRequestList) > 0 then
			for i=1, GetNumWhoResults() do
				name, guild, level, race, class, zone, classFileName, sex = GetWhoInfo(i)
				if groups["waitlist"][name] ~= nil then
					local gname, gbg, glevel, gclass, grole = groups["waitlist"][name]:GetRegions()
					glevel:SetWidth(100)
					glevel:SetText(tostring(level))
					glevel:SetWidth(gclass:GetStringWidth())
					local diffColor = getDifficultyColor(tonumber(level), UnitLevel("player"))
					glevel:SetTextColor(diffColor[1], diffColor[2], diffColor[3])
					gclass:SetWidth(100)
					gclass:SetText(class)
					local classColor = getClassColor(class)
					gclass:SetTextColor(classColor[1], classColor[2], classColor[3])
					gclass:SetWidth(gclass:GetStringWidth())
				end
			end
			removeFromSet(whoRequestList, name)
		end
		SetWhoToUI(0)
	end
	
	if event == "CHAT_MSG_WHISPER" then
		local args = {}
		if arg1 ~= nil then
			args = split(arg1, "\%s")
		end
		if next(args) == nil then return end
		-- Group request info from players
		if args[1] == "vqrequest" and isHost then
			for groupindex = 1,MAX_PARTY_MEMBERS do
				if UnitName("party" .. tostring(groupindex)) == arg2 then return end
			end
			wQueue_addToWaitList(arg2 .. ":" .. args[2] .. ":" .. args[3] .. ":" .. args[4])
			playerMessages[arg2] = "vqrequest" .. ":" .. GetTime()
		end
		if (args[1] == "vqaccept" or args[1] == "vqdecline") and isFinding then
			for key, value in pairs(groups) do
				if groups[key][arg2] ~= nil then
					if args[1] == "vqaccept" then
						DEFAULT_CHAT_FRAME:AddMessage("Your application to " .. arg2 .. "'s group(" .. key .. ") has been accepted.", 0.2, 1.0, 0.2)
					elseif args[1] == "vqdecline" then
						DEFAULT_CHAT_FRAME:AddMessage("Your application to " .. arg2 .. "'s group(" .. key .. ") has been declined.", 1.0, 0.2, 0.2)
					end
					removeFromSet(waitingList, arg2)
					groups[key][arg2]:Hide()
					groups[key][arg2] = nil
					refreshCatList(key)
				end
			end
		end	
	end
end

function wQueue_updateCatColors()
	local curCat = ""
	for kk, vv in pairs(catListButtons) do
		if categories[vv:GetText()] ~= nil then curCat = vv:GetText() end
		if categories[vv:GetText()] == nil and curCat ~= "Battlegrounds" and curCat ~= "Miscellaneous" then
			local args = {}
			for k, v in pairs(categories) do
				for i, item in pairs(v) do
					if type(item) == "string" then
						local tArgs = split(item, "\:")
						if tArgs[1] == split(vv:GetText(), "%(")[1] then 
							args = tArgs
							break
						end
					end
				end
			end
			local diffColor = getDifficultyColor(getglobal("MINLVLS")[args[2]], UnitLevel("Player"))
			vv:GetNormalTexture():SetTexture(diffColor[1],diffColor[2],diffColor[3],0.1)
--vv:SetText("|cff"..valtohex(diffColor[1])..valtohex(diffColor[2])..valtohex(diffColor[3])..vv:GetText().."|r")

			--vv:SetTextColor(diffColor[1], diffColor[2], diffColor[3])
		end
	end
end

function wQueue_createCategories(textKey)
	newCatButton = CreateFrame("Button", "wQueueButton", wQueueFrame.catList, "UIPanelButtonGrayTemplate")
	--newCatButton:SetFont("Fonts\\FRIZQT__.TTF", 10)
	newCatButton:SetText(textKey)
	--newCatButton:SetTextColor(wQueueColors["YELLOW"][1], wQueueColors["YELLOW"][2], wQueueColors["YELLOW"][3])
	newCatButton:SetWidth(newCatButton:GetTextWidth())
	newCatButton:SetHeight(10)
	newCatButton:SetFrameLevel(1)
	newCatButton:EnableMouse(true)
	newCatButton:SetPoint("TOPLEFT", wQueueFrame.catList, "TOPLEFT",  2, tablelength(catListButtons)*-10)
	newCatButton:SetScript("OnMouseDown", function()
		--newCatButton:Hide()
	end)
	table.insert(catListButtons, tablelength(catListButtons), newCatButton)
	for k, v in pairs(categories[textKey]) do
		local args = {}
		if type(v) == "string" then
			args = split(v, "\:")	
		end
		if type(args[1]) == "string" then
			local dropedItemFrame = CreateFrame("Button", "wQueueButton", wQueueFrame.catList, "UIPanelButtonTemplate")
		--	dropedItemFrame:SetFont("Fonts\\FRIZQT__.TTF", 8)
			dropedItemFrame:SetText(args[1] .. "(" .. tostring(tablelength(groups[args[2]])) .. ")")
		--	dropedItemFrame:SetHighlightTextColor(wQueueColors["YELLOW"][1], wQueueColors["YELLOW"][2], wQueueColors["YELLOW"][3])
			dropedItemFrame:SetWidth(dropedItemFrame:GetTextWidth())
dropedItemFrame:SetWidth(185)
		dropedItemFrame:SetNormalTexture("Interface\\DialogFrame\\UI-DialogBox-Background")
			dropedItemFrame:SetHeight(8)
			dropedItemFrame:SetFrameLevel(1)
		--	dropedItemFrame:SetTextColor(wQueueColors["WHITE"][1], wQueueColors["WHITE"][2], wQueueColors["WHITE"][3])
			dropedItemFrame:SetPoint("TOPLEFT", wQueueFrame.catList, "TOPLEFT",  12, tablelength(catListButtons)*-10)
			dropedItemFrame:SetScript("OnMouseDown", function()
				wQueueFrame.catListHighlight:SetParent(this)
				wQueueFrame.catListHighlight:SetPoint("LEFT", this, "LEFT", -11, 0)
				wQueueFrame.catListHighlight:Show()
				isWaitListShown = false
				wQueueFrame.hostTitle:Hide()
				wQueueFrame.hostTitleRole:Hide()
				wQueueFrame.hostTitleClass:Hide()
				wQueueFrame.hostTitleLevel:Hide()
				wQueueFrame.topsectionHostName:Hide()
				wQueueFrame.hostlistLevelField:Hide()
				wQueueFrame.hostlistNameField:Hide()
				wQueueFrame.hostlistCreateButton:Hide()
				wQueueFrame.hostlistCancelButton:Hide()
				wQueueFrame.hostTitleFindName:Show()
				wQueueFrame.hostTitleFindLeader:Show()
				wQueueFrame.hostTitleFindLevel:Show()
				wQueueFrame.hostTitleFindSize:Show()
				wQueueFrame.hostTitleFindRoles:Show()
				if not isHost then realHostedCategory = args[1] end
				local args = {}
				for k, v in pairs(categories) do
					for i, item in pairs(v) do
						if type(item) == "string" then
							local tArgs = split(item, "\:")
							if tArgs[1] == split(this:GetText(), "%(")[1] then 
								args = tArgs
								break
							end
						end
					end
				end
				if args[2] ~= nil and type(args[2]) == "string" then
					local prevCat = selectedQuery
					selectedQuery = args[2]
					wQueue_ShowGroups(selectedQuery, prevCat)
					wQueueFrame.topsectiontitle:SetText(args[1] .. "(" .. getglobal("MINLVLS")[args[2]] .. ")")
					wQueueFrame.topsectiontitle:SetWidth(wQueueFrame.topsectiontitle:GetTextWidth())
					wQueueFrame.topsectiontitle:SetHeight(wQueueFrame.topsectiontitle:GetTextHeight())
				end
				if not wQueueFrame.hostlistTopSectionBg:SetTexture("Interface\\AddOns\\wQueue\\media\\" .. args[2]) then
					wQueueFrame.hostlistTopSectionBg:SetTexture(0, 0, 0, 0)
				end
				wQueueFrame.hostlistHeal:Show()
				wQueueFrame.hostlistDps:Show()
				wQueueFrame.hostlistTank:Show()
				wQueueFrame.hostlistRoleText:Show()
				if not isHost and not wQueueFrame.hostlistCreateButton:IsShown() then
					wQueueFrame.hostlistHostButton:Show()
				else
					wQueueFrame.hostlistHostButton:Hide()
				end
				scrollbar:SetValue(1)
				scrollbar:SetMinMaxValues(1, math.abs(tablelength(groups[selectedQuery])-10))
			end)
			dropedItemFrame:SetScript("OnShow", function()
				if wQueueFrame.catListHighlight:GetParent() and split(wQueueFrame.catListHighlight:GetParent():GetText(), "%(")[1] == split(this:GetText(), "%(")[1] then
					wQueueFrame.catListHighlight:SetParent(this)
					wQueueFrame.catListHighlight:SetPoint("LEFT", this, "LEFT", -11, 0)
					wQueueFrame.catListHighlight:Show()
				end
			end)
			table.insert(catListButtons, tablelength(catListButtons), dropedItemFrame)
		end
	end
	scrollbarCat:SetMinMaxValues(1, tablelength(catListButtons)-10)
	wQueue_UpdateCatScroll(scrollbarCat:GetValue())
end

function wQueue_addToWaitList(playerinfo)
	local args = split(playerinfo, "\:")
	if groups["waitlist"][args[1]] == nil then
		newWaitEntry = CreateFrame("Button", "wQueueButton", wQueueFrame.hostlist, "UIPanelButtonTemplate")
		newWaitEntry:SetFont("Interface\\AddOns\\wQueue\\media\\anonpro.TTF", 10)
		newWaitEntry:SetText(args[1])
		--newWaitEntry:SetTextColor(wQueueColors["WHITE"][1], wQueueColors["WHITE"][2], wQueueColors["WHITE"][3])
		newWaitEntry:SetHighlightTextColor(1, 1, 0)
		newWaitEntry:SetPushedTextOffset(0,0)
		newWaitEntry:SetWidth(newWaitEntry:GetTextWidth())
		newWaitEntry:SetHeight(10)
		newWaitEntry:EnableMouse(true)
		newWaitEntry:SetFrameLevel(1)
		newWaitEntry:SetScript("OnEnter", function()
			if playerMessages[this:GetText()] ~= nil then
				local playerargs = split(playerMessages[this:GetText()], "\:")
				if Wholefind(playerargs[1], "vqrequest") > 0 then return end
				playerQueueToolTip:SetOwner( this, "ANCHOR_CURSOR" );
				playerQueueToolTip:AddLine(playerargs[1], 1, 1, 1, 1)
				playerQueueToolTip:Show()
			end
		end)
		newWaitEntry:SetScript("OnLeave", function()
			playerQueueToolTip:Hide()
		end)
		newWaitEntryBg = newWaitEntry:CreateTexture(nil, "BACKGROUND")
		newWaitEntryBg:SetPoint("LEFT", newWaitEntry, "LEFT", 1, 0)
		newWaitEntryBg:SetWidth(wQueueFrame.hostlist:GetWidth()-3)
		newWaitEntryBg:SetHeight(15)
		
		local diffColor
		if args[2] ~= "..." then
			diffColor = getDifficultyColor(tonumber(args[2]), UnitLevel("player"))
		else
			diffColor = {wQueueColors["WHITE"][1], wQueueColors["WHITE"][2], wQueueColors["WHITE"][3]}
		end
		newWaitEntryLvl = newWaitEntry:CreateFontString(nil, "ARTWORK")
		newWaitEntryLvl:SetFont("Interface\\AddOns\\wQueue\\media\\anonpro.TTF", 10)
		newWaitEntryLvl:SetText(args[2])
		newWaitEntryLvl:SetPoint("LEFT", newWaitEntry, "LEFT", 155, 0)
		newWaitEntryLvl:SetWidth(newWaitEntryLvl:GetStringWidth())
		newWaitEntryLvl:SetTextColor(diffColor[1], diffColor[2], diffColor[3])
		newWaitEntryLvl:SetHeight(10)
		
		local classColor
		if args[3] ~= "..." then
			classColor = getClassColor(args[3])
		else
			classColor = {wQueueColors["WHITE"][1], wQueueColors["WHITE"][2], wQueueColors["WHITE"][3]}
		end
		newWaitEntryClass = newWaitEntry:CreateFontString(nil, "ARTWORK")
		newWaitEntryClass:SetFont("Interface\\AddOns\\wQueue\\media\\anonpro.TTF", 10)
		newWaitEntryClass:SetText(args[3])
		newWaitEntryClass:SetPoint("LEFT", newWaitEntry, "LEFT", 245, 0)
		newWaitEntryClass:SetWidth(newWaitEntryClass:GetStringWidth())
		newWaitEntryClass:SetTextColor(classColor[1], classColor[2], classColor[3])
		newWaitEntryClass:SetHeight(10)
		
		newWaitEntryRole = newWaitEntry:CreateTexture(nil, "ARTWORK")
		newWaitEntryRole:SetPoint("LEFT", newWaitEntry, "LEFT", 325, 0)
		newWaitEntryRole:SetTexture("Interface\\AddOns\\wQueue\\media\\" .. args[4])
		newWaitEntryRole:SetWidth(16)
		newWaitEntryRole:SetHeight(16)
		
		newWaitEntryInvite = wQueue_newButton(newWaitEntry, 10)
		newWaitEntryInvite:SetPoint("RIGHT", newWaitEntryBg, "RIGHT", -20, 0)
		newWaitEntryInvite:SetFont("Interface\\AddOns\\wQueue\\media\\anonpro.TTF", 10)
		newWaitEntryInvite:SetText("invite")
		newWaitEntryInvite:SetWidth(newWaitEntryInvite:GetTextWidth()+5)
		newWaitEntryInvite:SetScript("OnClick", function()
			InviteByName(this:GetParent():GetText())
			groups["waitlist"][this:GetParent():GetText()]:Hide()
			groups["waitlist"][this:GetParent():GetText()] = nil
			wQueue_UpdateHostScroll(scrollbar:GetValue())
			scrollbar:SetMinMaxValues(1, tablelength(groups[selectedQuery])-10)
			if playerMessages[this:GetParent():GetText()] == nil then return end
			local invargs = split(playerMessages[this:GetParent():GetText()], "\:")
			if Wholefind(invargs[1], "vqrequest") > 0 then
				if not setContains(chatQueue, "vqaccept" .. "-WHISPER-" .. this:GetParent():GetText()) then
					addToSet(chatQueue, "vqaccept" .. "-WHISPER-" .. this:GetParent():GetText())
				end
			end
		end)
		newWaitEntryInvite:SetScript("OnUpdate", function()
			if playerMessages[this:GetParent():GetText()] ~= nil then
				local timeSplit = split(playerMessages[this:GetParent():GetText()], "\:")
				if type(tonumber(timeSplit[2])) == "number" then
					local minute = 0
					local seconds = math.floor(GetTime() - tonumber(timeSplit[2]))
					if seconds >= 60 then
						minute = math.floor(seconds/60)
						seconds = seconds - (minute*60)
					end
					if seconds < 10 then
						seconds = "0" .. tostring(seconds)
					end
					this:SetText("invite(" .. tostring(minute) .. ":" .. tostring(seconds)..")" )
					this:SetWidth(this:GetTextWidth()+5)
				end
			end
		end)

		newWaitEntryDecline = wQueue_newButton(newWaitEntry, 10)
		newWaitEntryDecline:SetPoint("RIGHT", newWaitEntryBg, "RIGHT", -3, 0)
		newWaitEntryDecline:SetText("X")
		newWaitEntryDecline:SetWidth(newWaitEntryDecline:GetTextWidth()+5)
		newWaitEntryDecline:SetScript("OnClick", function()
			groups["waitlist"][this:GetParent():GetText()]:Hide()
			groups["waitlist"][this:GetParent():GetText()] = nil
			wQueue_UpdateHostScroll(scrollbar:GetValue())
			scrollbar:SetMinMaxValues(1, tablelength(groups[selectedQuery])-10)
			if playerMessages[this:GetParent():GetText()] == nil then return end
			local invargs = split(playerMessages[this:GetParent():GetText()], "\:")
			if Wholefind(invargs[1], "vqrequest") > 0 then
				if not setContains(chatQueue, "vqdecline" .. "-WHISPER-" .. this:GetParent():GetText()) then
					addToSet(chatQueue, "vqdecline" .. "-WHISPER-" .. this:GetParent():GetText())
				end
			end
		end)
		if not wQueueFrame:IsShown() then minimapButton.notifyText:Show() end
		groups["waitlist"][args[1]] = newWaitEntry
	end
	if selectedQuery == "waitlist" and isWaitListShown then 
		groups["waitlist"][args[1]]:Show()
		wQueue_UpdateHostScroll(scrollbar:GetValue())
		scrollbar:SetMinMaxValues(1, tablelength(groups[selectedQuery])-10)
	else groups["waitlist"][args[1]]:Hide() end
end

function wQueue_WhoSorting()
	for i=1, GetNumWhoResults() do
		name, guild, level, race, class, zone, classFileName, sex = GetWhoInfo(i)
		if leaderMessages[name] ~= nil and level > 40 and groups["dead"][name] ~= nil then
			groups["dm"][name] = groups["dead"][name]
			if selectedQuery == "dead" then groups["dead"][name]:Hide() end
			groups["dead"][name] = nil	
			local thisframe, bg, name, level = groups["dm"][name]:GetRegions()
			level:SetText(getglobal("MINLVLS")["dm"])
			local diffColor = getDifficultyColor(tonumber(getglobal("MINLVLS")["dm"]), UnitLevel("player"))
			level:SetTextColor(diffColor[1], diffColor[2], diffColor[3])
		elseif leaderMessages[name] ~= nil and groups["dead"][name] ~= nil then
			local leaderArgs = split(leaderMessages[name], "\:")
			leaderMessages[name] = leaderArgs[1] .. ":" .. "dead" .. ":" .. leaderArgs[3]
			if "dead" == selectedQuery then groups["dead"][name]:Show() end
		end
		if leaderMessages[name] ~= nil then 
			refreshCatList("dm")
			refreshCatList("dead")
			wQueue_ShowGroups(selectedCat, selectedCat)
		end
	end
end

-- return the first integer index holding the value
function AnIndexOf(t,val)
	local i = 0
    for k,v in pairs(t) do 
        if k == val then return i end
		if v ~= nil then i = i+1 end
    end
end

function VisibleIndex(t,val)
	local i = 0
    for k,v in pairs(t) do
        if k == val then return i end
		if v ~= nil and v:IsShown() then i = i+1 end
    end
end

function wQueue_UpdateCatScroll(value)
	for k, v in pairs(catListButtons) do
		local index = k
		if (index+1) < value or index-value > 33 then v:Hide() else v:Show() end
	end
	for k, v in pairs(catListButtons) do
		if v ~= nil then
			if v:IsShown() then
				local vindex = VisibleIndex(catListButtons, k)
				if catListButtons[0]:IsShown() then vindex = vindex + 1 end
				if v:GetText() == catListButtons[0]:GetText() and v:IsShown() then vindex = 0 end
				local point, relativeTo, relativePoint, xOffset, yOffset = v:GetPoint()
				v:SetPoint("TOPLEFT", wQueueFrame.catList, "TOPLEFT",  xOffset, vindex*-10)
			end
		end
	end
end

function wQueue_UpdateHostScroll(value)
	if selectedQuery ~= "" then
		for k, v in pairs(groups[selectedQuery]) do
			local index = AnIndexOf(groups[selectedQuery], k)
			if (index+1) < value or index-value > 16 then v:Hide() else v:Show() end
		end
		if tablelength(groups[selectedQuery]) > 16 then wQueueFrame.hostlistBotShadow:Show() else wQueueFrame.hostlistBotShadow:Hide() end
	end
	if selectedQuery ~= "" then
		for k, v in pairs(groups[selectedQuery]) do
			if v ~= nil then
				if v:IsShown() then
					local thisframe, bg, ka1, ka2, ka3, ka4, name, level,size,tank,healer,damage = v:GetRegions()
					local vindex = VisibleIndex(groups[selectedQuery], k)
					v:SetPoint("TOPLEFT", wQueueFrame.hostlist, "TOPLEFT",  0, -(vindex*15)-15 - wQueueFrame.hostlistTopSection:GetHeight())
					if (vindex % 2 == 0) then
						bg:SetTexture(0.5, 0.5, 0.5, 0.1)
					else
						bg:SetTexture(0.2, 0.2, 0.2, 0.1)
					end
				end
			end
		end
	end
end

function getDifficultyColor(levelKey, playerLevel)
	local color = {}
	if (levelKey - playerLevel) >= 5 then
		color[1] = 1
		color[2] = 0
		color[3] = 0
	elseif  (levelKey - playerLevel) <= 4  and (levelKey - playerLevel) >= 3 then
		color[1] = 1
		color[2] = 0.5
		color[3] = 0
	elseif  (playerLevel - levelKey) <= 4  and (playerLevel - levelKey) >= 3 then
		color[1] = 0
		color[2] = 1
		color[3] = 0
	elseif  (playerLevel - levelKey) > 4 then
		color[1] = 0.5
		color[2] = 0.5
		color[3] = 0.5
	else
		color[1] = 1
		color[2] = 1
		color[3] = 0
	end
	return color
end

function getClassColor(class)
	local classColor = {}
	classColor["Druid"] = {1, 0.49, 0.04}
	classColor["Hunter"] = {0.67, 0.83, 0.45}
	classColor["Mage"] = {0.41, 0.80, 0.94}
	classColor["Paladin"] = {0.96, 0.55, 0.73}
	classColor["Priest"] = {1, 1, 1}
	classColor["Rogue"] = {1, 0.96, 0.41}
	classColor["Shaman"] = {0, 0.44, 0.87}
	classColor["Warlock"] = {0.58, 0.51, 0.79}
	classColor["Warrior"] = {0.78, 0.61, 0.43}
	for k, v in pairs(classColor) do
		if k == class then return v end
	end
end

function wQueue_addToGroup(category, groupinfo)
	if category == "waitlist" then return end
	local args = split(groupinfo, "\:")
	for k, v in pairs(groups) do
		for kk, vv in pairs(groups[k]) do
			if kk == args[2] and vv ~= nil and k ~= category and k ~= "waitlist" then
				groups[category][args[2]] = groups[k][kk]
				groups[k][kk]:Hide()
				groups[k][kk] = nil
				refreshCatList(k)
			end
		end
	end
	if groups[category][args[2]] == nil then
		newHostEntry = CreateFrame("Button", "wQueueButton", wQueueFrame.hostlist, "UIPanelButtonTemplate")
		--newHostEntry:SetFont("Interface\\AddOns\\wQueue\\media\\anonpro.TTF", 10)
		newHostEntry:SetText(args[1])
		--newHostEntry:SetTextColor(wQueueColors["YELLOW"][1], wQueueColors["YELLOW"][2], wQueueColors["YELLOW"][3])
		
		--newHostEntry:SetHighlightTextColor(1, 1, 0)
		newHostEntry:SetPushedTextOffset(0,0)
		newHostEntry:SetWidth(newHostEntry:GetTextWidth())
		
		newHostEntry:SetHeight(10)
		newHostEntry:EnableMouse(true)
		newHostEntry:SetFrameLevel(1)
		newHostEntry:SetScript("OnEnter", function()
			local thisframe, bg, ka1, ka2, ka3, ka4, name, level,size,tank,healer,damage = this:GetRegions()
			if leaderMessages[name:GetText()] ~= nil then
				local leaderargs = split(leaderMessages[name:GetText()], "\:")
				groupToolTip:SetOwner( this, "ANCHOR_CURSOR" );
				groupToolTip:AddLine(leaderargs[1], 1, 1, 1, 1)
				groupToolTip:Show()
			end
		end)
		newHostEntry:SetScript("OnUpdate", function()
			if wQueueFrame:IsShown() and this:IsShown() then
				local thisframe, bg, ka1, ka2, ka3, ka4, name, level,size,tank,healer,damage = this:GetRegions()
				--[[print("tf"..thisframe:GetText())
				print("bg"..bg:GetObjectType())
				print("1"..ka1:GetObjectType())
				print("2"..ka2:GetObjectType())
				print("3"..ka3:GetObjectType())
				print("4"..ka4:GetObjectType())
				print("n"..name:GetObjectType())
				print("l"..level:GetObjectType())
				print("s"..size:GetObjectType())
				print("t"..tank:GetObjectType())
				print("h"..healer:GetObjectType())
				print("d"..damage:GetObjectType())--]]
				if leaderMessages[name:GetText()] ~= nil and size:GetText() == "?" then
					local timeSplit = split(leaderMessages[name:GetText()], "\:")
					if type(tonumber(timeSplit[3])) == "number" then
						local minute = 0
						local seconds = math.floor(GetTime() - tonumber(timeSplit[3]))
						if seconds >= 60 then
							minute = math.floor(seconds/60)
							seconds = seconds - (minute*60)
						end
						if seconds < 10 then
							seconds = "0" .. tostring(seconds)
						end
						this:SetText("(Mouseover to see chat message) " .. tostring(minute) .. ":" .. tostring(seconds) )
						--this:SetWidth(this:GetTextWidth()-50)
						this:SetWidth(this:GetTextWidth())
					end
				end
			end
		end)
		newHostEntry:SetScript("OnLeave", function()
			groupToolTip:Hide()
		end)
		newHostEntryBg = newHostEntry:CreateTexture(nil, "BACKGROUND")
		newHostEntryBg:SetPoint("LEFT", newHostEntry, "LEFT", 1, 0)
		newHostEntryBg:SetWidth(wQueueFrame.hostlist:GetWidth()-3)
		newHostEntryBg:SetHeight(15)
		--if (math.mod(tablelength(groups[category])-1, 2) == 0) then
		if (((tablelength(groups[category])-1) % 2) == 0) then
			newHostEntryBg:SetTexture(0.5, 0.5, 0.5, 0.1)
		else
			newHostEntryBg:SetTexture(0.2, 0.2, 0.2, 0.1)
		end
		
		newHostEntryName = newHostEntry:CreateFontString(nil, "ARTWORK")
		newHostEntryName:SetFont("Interface\\AddOns\\wQueue\\media\\anonpro.TTF", 10)
		newHostEntryName:SetText(args[2])
		newHostEntryName:SetPoint("LEFT", newHostEntry, "LEFT", 261, 0)
		newHostEntryName:SetWidth(newHostEntryName:GetStringWidth())
		newHostEntryName:SetTextColor(wQueueColors["WHITE"][1], wQueueColors["WHITE"][2], wQueueColors["WHITE"][3])
		newHostEntryName:SetHeight(10)
		
		local diffColor = getDifficultyColor(tonumber(args[3]), UnitLevel("player"))
		newHostEntryLevel = newHostEntry:CreateFontString(nil, "ARTWORK")
		newHostEntryLevel:SetFont("Interface\\AddOns\\wQueue\\media\\anonpro.TTF", 10)
		newHostEntryLevel:SetText(args[3])
		newHostEntryLevel:SetPoint("LEFT", newHostEntry, "LEFT", 337, 0)
		newHostEntryLevel:SetWidth(newHostEntryLevel:GetStringWidth())
		newHostEntryLevel:SetTextColor(diffColor[1], diffColor[2], diffColor[3])
		newHostEntryLevel:SetHeight(10)
		
		newHostEntrySize = newHostEntry:CreateFontString(nil, "ARTWORK")
		newHostEntrySize:SetFont("Interface\\AddOns\\wQueue\\media\\anonpro.TTF", 10)
		newHostEntrySize:SetText(args[4])
		newHostEntrySize:SetPoint("LEFT", newHostEntry, "LEFT", 375, 0)
		newHostEntrySize:SetWidth(newHostEntrySize:GetStringWidth())
		newHostEntrySize:SetTextColor(wQueueColors["WHITE"][1], wQueueColors["WHITE"][2], wQueueColors["WHITE"][3])
		newHostEntrySize:SetHeight(10)
		
		newHostEntryTank = newHostEntry:CreateTexture(nil, "ARTWORK")
		newHostEntryTank:SetPoint("LEFT", newHostEntry, "LEFT", 410, 0)
		newHostEntryTank:SetTexture("Interface\\AddOns\\wQueue\\media\\Tank")
		newHostEntryTank:SetWidth(16)
		newHostEntryTank:SetHeight(16)
		if args[7] == "Tank" then newHostEntryTank:Show() else newHostEntryTank:Hide() end
		
		newHostEntryHealer = newHostEntry:CreateTexture(nil, "ARTWORK")
		newHostEntryHealer:SetPoint("LEFT", newHostEntry, "LEFT", 426, 0)
		newHostEntryHealer:SetTexture("Interface\\AddOns\\wQueue\\media\\Healer")
		newHostEntryHealer:SetWidth(16)
		newHostEntryHealer:SetHeight(16)
		if args[5] == "Healer" then newHostEntryHealer:Show() else newHostEntryHealer:Hide() end
		
		newHostEntryDamage = newHostEntry:CreateTexture(nil, "ARTWORK")
		newHostEntryDamage:SetPoint("LEFT", newHostEntry, "LEFT", 442, 0)
		newHostEntryDamage:SetTexture("Interface\\AddOns\\wQueue\\media\\Damage")
		newHostEntryDamage:SetWidth(16)
		newHostEntryDamage:SetHeight(16)
		if args[6] == "Damage" then newHostEntryDamage:Show() else newHostEntryDamage:Hide() end
		
		waitListButton = wQueue_newButton(newHostEntry, 9)
		waitListButton:SetPoint("RIGHT", newHostEntryBg, "RIGHT", -3, 0)
		if setContains(waitingList, args[2]) then
			waitListButton:SetText("waiting")
		else
			waitListButton:SetText("wait list")
		end
		if leaderMessages[args[2]] ~= nil and newHostEntrySize:GetText() == "?" then
			waitListButton:SetText("reply")
		end
		waitListButton:SetWidth(waitListButton:GetTextWidth()+10)
		waitListButton:SetScript("OnClick", function()
			if GetNumPartyMembers() > 0 and this:GetText() ~= "reply" then 
				wQueueFrame.hostlistRoleText:SetText("(Leave group before queueing for other groups)")
				return 
			end
			local thisframe, bg, ka1, ka2, ka3, ka4, name, level,size,tank,healer,damage = this:GetParent():GetRegions()
			if this:GetText() == "wait list" then
				if tonumber(level:GetText()) > UnitLevel("player") then
					wQueueFrame.hostlistRoleText:SetText("(You do not meet the level requirements for this group)")
					return
				end
				this:SetText("waiting")
				wQueue_SlashCommandHandler("request " .. name:GetText())
				if not setContains(waitingList, name:GetText()) then
					addToSet(waitingList, name:GetText())
				end
			end
			if this:GetText() == "reply" then
				wQueueFrame.replyFrameTo:SetText(name:GetText())
				wQueueFrame.replyFrameMsg:SetText("INV " .. tostring(UnitLevel("player")) .. "lvl " .. selectedRole .. " " .. tostring(UnitClass("player")))
				wQueueFrame.replyFrame:Show()
			end
		end)
		
		groups[category][args[2]] = newHostEntry
	else
		local thisframe, bg, ka1, ka2, ka3, ka4, name, level,size,tank,healer,damage = groups[category][args[2]]:GetRegions()
		groups[category][args[2]]:SetText(args[1])
		groups[category][args[2]]:SetWidth(groups[category][args[2]]:GetTextWidth())
		local diffColor = getDifficultyColor(tonumber(args[3]), UnitLevel("player"))
		level:SetText(args[3])
		level:SetWidth(level:GetStringWidth())
		level:SetTextColor(diffColor[1], diffColor[2], diffColor[3])
		size:SetText(args[4])
		size:SetWidth(size:GetStringWidth())
		if args[7] == "Tank" then tank:Show() else tank:Hide() end
		if args[5] == "Healer" then healer:Show() else healer:Hide() end
		if args[6] == "Damage" then damage:Show() else damage:Hide() end
	end
	if category == selectedQuery and not isWaitListShown then 
		groups[category][args[2]]:Show()
		wQueue_UpdateHostScroll(scrollbar:GetValue())
		scrollbar:SetMinMaxValues(1, math.abs(tablelength(groups[selectedQuery])-10))
	else groups[category][args[2]]:Hide() end
end

function wQueue_ShowGroups(category, prevCategory)
	if prevCategory ~= "" then
		for k, v in pairs(groups[prevCategory]) do v:Hide() end
	end
	if category ~= "" then
		for k, v in pairs(groups[category]) do v:Hide() end
		for k, v in pairs(groups[category]) do
			v:Show() 
		end
		scrollbar:SetMinMaxValues(1, math.abs(tablelength(groups[category])-10))
	end
	wQueue_UpdateHostScroll(scrollbar:GetValue())
end

function refreshCatList(cat)
	for kChild, child in ipairs(catListButtons) do
		local args = {}
		local realText = split(child:GetText(), "%(")
		for k, v in pairs(categories) do
			for i, item in pairs(v) do
				if type(item) == "string" then
					local tArgs = split(item, "\:")
					if tArgs[1] == realText[1] and tArgs[2] == cat then 
						args = tArgs
						break
					end
				end
			end
		end
		if args[2] ~= nil and type(args[2]) == "string" then
			child:SetText(realText[1] .. "(" .. tablelength(groups[args[2]]) .. ")")
			--child:SetWidth(child:GetTextWidth()+80)
			child:SetWidth(185)
			local diffColor = getDifficultyColor(getglobal("MINLVLS")[args[2]], UnitLevel("Player"))
			if tablelength(groups[args[2]])>0 then
				--child:SetNormalTexture("Interface\\TargetingFrame\\UI-StatusBar")
				--print(child:GetNormalTexture():GetVertexColor())
				
				child:GetNormalTexture():SetTexture(diffColor[1],diffColor[2],diffColor[3],0.3)

	
			else	
				child:GetNormalTexture():SetTexture(diffColor[1],diffColor[2],diffColor[3],0.1)
				--child:SetNormalTexture("Interface\\DialogFrame\\UI-DialogBox-Background")
			end
			--child:SetBackdropColor(0, 1, 0,1) 
			--print(child:GetNormalTexture())
			--child:GetNormalTexture():SetTexCoord( 0, 1, 0, 1 )
			break
		end
	end
end

function wQueue_newButton(parentFrame, FontSize)
	newButton = CreateFrame("Button", "wQueueButton", parentFrame, "UIPanelButtonTemplate")
	--newButton:SetFont("Fonts\\FRIZQT__.TTF", FontSize)
	--newButton:SetTextColor(wQueueColors["YELLOW"][1], wQueueColors["YELLOW"][2], wQueueColors["YELLOW"][3])
	newButton:SetNormalTexture("Interface\\AddOns\\wQueue\\media\\button")
	newButton:SetHighlightTexture("Interface\\BUTTONS\\CheckButtonHilight")
	newButton:GetHighlightTexture():SetVertexColor(1, 1, 1, 0.2)
	newButton:GetNormalTexture():SetVertexColor(0.25, 0.25, 0.25, 1.0)
	newButton:SetHeight(FontSize+2)
	
	local borderColor = {0.05, 0.05, 0.05, 1}
	
	leftBorder = newButton:CreateTexture(nil, "OVERLAY")
	leftBorder:SetPoint("TOPLEFT", newButton, "TOPLEFT")
	leftBorder:SetPoint("BOTTOMLEFT", newButton, "BOTTOMLEFT")
	leftBorder:SetTexture(borderColor[1], borderColor[2], borderColor[3], borderColor[4])
	leftBorder:SetWidth(1)
	
	rightBorder = newButton:CreateTexture(nil, "OVERLAY")
	rightBorder:SetPoint("TOPRIGHT", newButton, "TOPRIGHT")
	rightBorder:SetPoint("BOTTOMRIGHT", newButton, "BOTTOMRIGHT")
	rightBorder:SetTexture(borderColor[1], borderColor[2], borderColor[3], borderColor[4])
	rightBorder:SetWidth(1)
	return newButton
end

function wQueue_SlashCommandHandler( msg )
	local args = {}
	if msg ~= nil then
		args = split(msg, "\%s")
	end
	if args[1] == "host" and args[2] ~= nil then
		isHost = true
		DEFAULT_CHAT_FRAME:AddMessage("Now hosting for " .. hostedCategory)
		idleMessage = 25
	elseif args[1] == "lfg" and args[2] ~= nil then
		if not setContains(chatQueue, args[2]) then
			addToSet(chatQueue, "lfg " .. args[2] .. "-CHANNEL-" .. tostring(GetChannelName(channelName)))
		end
	elseif args[1] == "request" and args[2] ~= nil then
		if not setContains(chatQueue, "vqrequest " .. UnitLevel("player") .. " " .. UnitClass("player") .. " " .. selectedRole .. "-WHISPER-" .. args[2]) then
			addToSet(chatQueue, "vqrequest " .. UnitLevel("player") .. " " .. UnitClass("player") .. " " .. selectedRole .. "-WHISPER-" .. args[2])
		end
	elseif args[1] == "testgroups" then
		for i=1, 100 do
			wQueue_addToGroup("misc", "title" .. i .. ":" .. "lmaoiwaslike" .. i .. ":" .. i .. ":" .. "?" .. ":" .. "Healer" .. ":" .. "Damage" .. ":" .. "Tank")
		end
		refreshCatList("misc")
	elseif args[1] == "testplayers" then
		local classes = {}
		classes[1] = "Druid"
		classes[2] = "Hunter"
		classes[3] = "Mage"
		classes[4] = "Paladin"
		classes[5] = "Priest"
		classes[6] = "Rogue"
		classes[7] = "Shaman"
		classes[8] = "Warlock"
		classes[9] = "Warrior"
		local roles = {}
		roles[1] = "Healer"
		roles[2] = "Damage"
		roles[3] = "Tank"
		for i=1, 100 do
			wQueue_addToWaitList("lmaoiwaslike" .. i .. ":" .. math.random(1, 60) .. ":" .. classes[math.random(1, 9)] .. ":" .. roles[math.random(1,3)])
		end
	end
end

function wQueue_OnUpdate()
	whoRequestTimer = whoRequestTimer + arg1
	if whoRequestTimer > 2 then
		whoRequestTimer = 0
		if fixingChat then
			JoinChannelByName("General")
			JoinChannelByName("Trade")
			JoinChannelByName("LocalDefense")
			JoinChannelByName("LookingForGroup")
			JoinChannelByName("World")
			JoinChannelByName("Global")
			JoinChannelByName("wQueue")
			fixingChat = false
		end
		if tablelength(whoRequestList) > 0 and not FriendsFrame:IsShown() then
			local whoString = ""
			for k, v in pairs(whoRequestList) do
				whoString = whoString .. k .. " "
			end
			SetWhoToUI(1)
			FriendsFrame:UnregisterEvent("WHO_LIST_UPDATE")
			SendWho(whoString)
		elseif FriendsFrame:IsShown() then
			FriendsFrame:RegisterEvent("WHO_LIST_UPDATE")
		end
	end
	
	idleMessage = idleMessage + arg1
	if idleMessage > 30 and tablelength(chatQueue) == 0 then
		idleMessage = 0
		if (isFinding or isHost) and GetChannelName(channelName) < 1 then
			JoinChannelByName(channelName)
		elseif GetChannelName(channelName) > 0 and (isHost == false and isFinding == false) then
			LeaveChannelByName(channelName)
		end
		if isHost then
			local groupSize = GetNumRaidMembers()
			if groupSize == 0 then groupSize = GetNumPartyMembers() end
			groupSize = groupSize + 1
			addToSet(chatQueue, "vqgroup " .. hostedCategory .. " " .. tostring(hostOptions[1]) .. " " .. groupSize .. " " .. tostring(hostOptions[2]) .. " " .. tostring(hostOptions[3]) .. " " .. tostring(hostOptions[4]) .. " " .. tostring(2) .. " :" .. tostring(hostOptions[0]) .. "-CHANNEL-" .. tostring(GetChannelName(channelName)))
		end
		
		-- Removes entries after 10 minutes of no updates
		for k, v in pairs(leaderMessages) do
			if v ~= nil then
				local leaderArgs = split(v, "\:")
				local timeDiff = GetTime() - tonumber(leaderArgs[3])
				if leaderArgs[3] ~= nil and type(tonumber(leaderArgs[3])) == "number" then
					if timeDiff > (600) then -- delete chat entries after 10 minutes of no updates					
						if groups[leaderArgs[2]][k] ~= nil then
							groups[leaderArgs[2]][k]:Hide()
							groups[leaderArgs[2]][k] = nil
							leaderMessages[k] = nil
							refreshCatList(leaderArgs[2])
							if wQueueFrame:IsShown() and selectedQuery == leaderArgs[2] then wQueue_UpdateHostScroll(scrollbar:GetValue()) end
						end
					end
					if timeDiff > (40) then -- remove wQueue groups after 40 seconds
						if groups[leaderArgs[2]][k] ~= nil then
							local thisframe, bg, ka1, ka2, ka3, ka4, name, level,size,tank,healer,damage = groups[leaderArgs[2]][k]:GetRegions()
							if size:GetText() ~= "?" then
								groups[leaderArgs[2]][k]:Hide()
								groups[leaderArgs[2]][k] = nil
								leaderMessages[k] = nil
								refreshCatList(leaderArgs[2])
								if wQueueFrame:IsShown() and selectedQuery == leaderArgs[2] then wQueue_UpdateHostScroll(scrollbar:GetValue()) end
							end
						end
					end
				end
			end
		end
	end
	
	-- CHAT LIMITER
	if(chatRate > 0) then
		lastUpdate = lastUpdate + arg1
		-- MESSAGES TO SEND GO HERE
		if (lastUpdate > (1/chatRate)) then
			lastUpdate = 0
			--queue of chat messages limited to 3 per second
			if next(chatQueue) ~= nil then
				for key,value in pairs(chatQueue) do 
					local args = split(key, "\-")
					SendChatMessage(args[1] , args[2], nil , args[3]);
					removeFromSet(chatQueue, key)
					break
				end
			end
		end
	end
end

SlashCmdList["wQueue"] = wQueue_SlashCommandHandler
SLASH_wQueue1 = "/wQueue"
