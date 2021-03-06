--[[
	Auctioneer Addon for World of Warcraft(tm).
	Version: 5.0.0 (BillyGoat)
	Revision: $Id: BeanCounterConfig.lua 3491 2008-09-14 09:11:58Z kandoko $
	URL: http://auctioneeraddon.com/
	
	BeanCounterConfig - Controls Configuration data

	License:
		This program is free software; you can redistribute it and/or
		modify it under the terms of the GNU General Public License
		as published by the Free Software Foundation; either version 2
		of the License, or (at your option) any later version.

		This program is distributed in the hope that it will be useful,
		but WITHOUT ANY WARRANTY; without even the implied warranty of
		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
		GNU General Public License for more details.

		You should have received a copy of the GNU General Public License
		along with this program(see GPL.txt); if not, write to the Free Software
		Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

	Note:
		This AddOn's source code is specifically designed to work with
		World of Warcraft's interpreted AddOn system.
		You have an implicit licence to use this AddOn with these facilities
		since that is it's designated purpose as per:
		http://www.fsf.org/licensing/licenses/gpl-faq.html#InterpreterIncompat
]]
--Most of this code is from enchantrix 
local lib = BeanCounter
local private = lib.Private
local print =  BeanCounter.Print

local gui
local settings
local _BC = private.localizations

local function debugPrint(...)
    if private.getOption("util.beancounter.debugConfig") then
        private.debugPrint("BeanCounterConfig",...)
    end
end

local function getUserSig()
	local userSig = string.format("users.%s.%s", GetRealmName(), UnitName("player"))
	return userSig
end

local function getUserProfileName()
	if (not settings) then settings = BeanCounterDB["settings"] end
	local userSig = getUserSig()
	return settings[userSig] or "Default"
end

local function getUserProfile()
	if (not settings) then settings = BeanCounterDB["settings"] end
	local profileName = getUserProfileName()
	if (not settings["profile."..profileName]) then
		if profileName ~= "Default" then
			profileName = "Default"
			settings[getUserSig()] = "Default"
		end
		if profileName == "Default" then
			settings["profile."..profileName] = {}
		end
	end
	return settings["profile."..profileName]
end


local function cleanse( profile )
	if (profile) then
		profile = {}
	end
end


-- Default setting values
local Buyer, Seller = string.match(_BC('UiBuyerSellerHeader'), "(.*)/(.*)") --We have no direct translation so this is a temp workaround	
private.settingDefaults = {
	["util.beancounter.ButtonExactCheck"] = false,
	["util.beancounter.ButtonClassicCheck"] = false,
	["util.beancounter.ButtonBidCheck"] = true,
	["util.beancounter.ButtonBidFailedCheck"] = true,
	["util.beancounter.ButtonAuctionCheck"] = true,
	["util.beancounter.ButtonAuctionFailedCheck"] = true,	

	["util.beancounter.activated"] = true,
	["util.beancounter.integrityCheckComplete"] = false,
	["util.beancounter.integrityCheck"] = true,
	
	--Tootip Settings
	["util.beancounter.displayReasonCodeTooltip"] = true,
	["util.beancounter.displaybeginerTooltips"] = true,
	
	--Debug settings
	["util.beancounter.debug"] = false,
	["util.beancounter.debugMail"] = true,
	["util.beancounter.debugCore"] = true,
	["util.beancounter.debugConfig"] = true,
	["util.beancounter.debugVendor"] = true,
	["util.beancounter.debugBid"] = true,
	["util.beancounter.debugPost"] = true,
	["util.beancounter.debugUpdate"] = true,
	["util.beancounter.debugFrames"] = true,
	["util.beancounter.debugAPI"] = true,
	["util.beancounter.debugSearch"] = true,
	
	["util.beacounter.invoicetime"] = 5,
	["util.beancounter.mailrecolor"] = "off",
	["util.beancounter.externalSearch"] = true,
	
	["util.beancounter.hasUnreadMail"] = false,
	
	--["util.beancounter.dateFormat"] = "%c",
	["dateString"] = "%c", 
	
	--GUI column default widths
	["columnwidth.".._BC('UiNameHeader')] = 120,
	["columnwidth.".._BC('UiTransactions')] = 100,
	["columnwidth.".._BC('UiBidTransaction')] = 60,
	["columnwidth.".._BC('UiBuyTransaction')] = 60,
	["columnwidth.".._BC('UiNetHeader')] = 65,
	["columnwidth.".._BC('UiQuantityHeader')] = 40,
	["columnwidth.".._BC('UiPriceper')] = 70, 
		
	["columnwidth.".."|CFFFFFF00"..Seller.."/|CFF4CE5CC"..Buyer] = 90,
				
	["columnwidth.".._BC('UiDepositTransaction')] = 58,
	["columnwidth.".._BC('UiPriceper')] = 50, 
	["columnwidth.".._BC("UiFee")] = 70, 
	["columnwidth.".._BC('UiReason')] = 70, 
	["columnwidth.".._BC('UiDateHeader')] = 250,
    }

local function getDefault(setting)
	local a,b,c = strsplit(".", setting)

	-- basic settings
	if (a == "show") then return true end
	if (b == "enable") then return true end
	
	-- lookup the simple settings
	local result = private.settingDefaults[setting];

	return result
end

function lib.GetDefault(setting)
	local val = getDefault(setting);
	return val;
end
local tbl = {}
local function setter(setting, value)
	if (not settings) then settings = BeanCounterDB["settings"] end
	-- turn value into a canonical true or false
	if value == 'on' then
		value = true
	elseif value == 'off' then
		value = false
	end

	-- for defaults, just remove the value and it'll fall through
	if (value == 'default') or (value == getDefault(setting)) then
		-- Don't save default values
		value = nil
	end
	
	--button to check database integrity pushed
	if (setting == "database.validate") then 
		print("Checking")
		private.integrityCheck(true)
		value = nil
	elseif (setting == "database.sort") then
		private.sortArrayByDate()
		value = time()
	end		
		
	--This is used to do the DateString
	local a,b = strsplit(".", setting)
	if (a == "dateString") then --used to update the Config GUI when a user enters a new date string 
		if not value then value = "%c" end
		tbl = {}
		for w in string.gmatch(value, "%%(.)" ) do --look for the date commands prefaced by %  
			tinsert(tbl, w)
		end
		
		local valid, invalid = {['a']= 1,['A'] =1,['b'] =1,['B'] =1,['c']=1,['d']=1,['H']=1,['I']=1,['m']=1,['M']=1,['p']=1,['S']=1,['U']=1,['w']=1,['x']=1,['X']=1,['y']=1,['Y']=1} --valid date commands
		
		for i,v in pairs(tbl) do
			 if not valid[v] then  invalid = v break end
		end
		if invalid then print("Invalid Date Format", "%"..invalid)  return end --Prevent processing if we have an invalid command
		
		local text = gui.elements.dateString:GetText()
		gui.elements.dateStringdisplay.textEl:SetText(_BC('C_DateStringExample').." "..date(text, 1196303661))
	end
	
	--[[Check for profile changes or store settings ]]
	
	if (a == "profile") then
		if (setting == "profile.save") then
			value = gui.elements["profile.name"]:GetText()

			-- Create the new profile
			settings["profile."..value] = {}

			-- Set the current profile to the new profile
			settings[getUserSig()] = value
			-- Get the new current profile
			local newProfile = getUserProfile()

			-- Clean it out and then resave all data
			cleanse(newProfile)
			gui:Resave()

			-- Add the new profile to the profiles list
			local profiles = settings["profiles"]
			if (not profiles) then
				profiles = { "Default" }
				settings["profiles"] = profiles
			end

			-- Check to see if it already exists
			local found = false
			for pos, name in ipairs(profiles) do
				if (name == value) then found = true end
			end

			-- If not, add it and then sort it
			if (not found) then
				table.insert(profiles, value)
				table.sort(profiles)
			end

			print("ChatSavedProfile",value)

		elseif (setting == "profile.delete") then
			-- User clicked the Delete button, see what the select box's value is.
			value = gui.elements["profile"].value

			-- If there's a profile name supplied
			if (value) then
				-- Clean it's profile container of values
				cleanse(settings["profile."..value])

				-- Delete it's profile container
				settings["profile."..value] = nil

				-- Find it's entry in the profiles list
				local profiles = settings["profiles"]
				if (profiles) then
					for pos, name in ipairs(profiles) do
						-- If this is it, then extract it
						if (name == value and name ~= "Default") then
							table.remove(profiles, pos)
						end
					end
				end

				-- If the user was using this one, then move them to Default
				if (getUserProfileName() == value) then
					settings[getUserSig()] = 'Default'
				end

				print("ChatDeletedProfile",value)

			end

		elseif (setting == "profile.default") then
			-- User clicked the reset settings button

			-- Get the current profile from the select box
			value = gui.elements["profile"].value

			-- Clean it's profile container of values
			settings["profile."..value] = {}

			print("ChatResetProfile",value)

		elseif (setting == "profile") then
			-- User selected a different value in the select box, get it
			value = gui.elements["profile"].value

			-- Change the user's current profile to this new one
			settings[getUserSig()] = value

			print("ChatUsingProfile",value)

		end

		-- Refresh all values to reflect current data
		gui:Refresh()
	else
		-- Set the value for this setting in the current profile
		local db = getUserProfile()
		db[setting] = value
		--setUpdated()
	end

end

function lib.SetSetting(...)
	setter(...)
	if (gui) then
		gui:Refresh()
	end
end


local function getter(setting)
	if (not settings) then settings = BeanCounterDB["settings"] end
	if not setting then return end

	local a,b,c = strsplit(".", setting)
	if (a == 'profile') then
		if (b == 'profiles') then
			local pList = settings["profiles"]
			if (not pList) then
				pList = { "Default" }
			end
			return pList
		end
	end

	if (a == 'scanvalue') then
		if (b == 'list') then
			if not private.scanValueNames then private.scanValueNames = {} end

			for i = 1, #private.scanValueNames do
				private.scanValueNames[i] = nil
			end

			table.insert(private.scanValueNames,{"average", "GuiItemValueAverage"})
			table.insert(private.scanValueNames,{"baseline", "GuiItemValueBaseline"})
			if AucAdvanced then
				table.insert(private.scanValueNames,{"adv:market", "GuiItemValueAuc5Market" })
				local algoList = AucAdvanced.API.GetAlgorithms()
				for pos, name in ipairs(algoList) do
					table.insert(private.scanValueNames,{"aucadv:stat:"..name, "AucAdv Stat:"..name})
				end
			end
			if Auctioneer then
				table.insert(private.scanValueNames,{"auc4:hsp", "GuiItemValueAuc4HSP" })
				table.insert(private.scanValueNames,{"auc4:med", "GuiItemValueAuc4Median" })
			end

			return private.scanValueNames
		end
	end

	if (setting == 'profile') then
		return getUserProfileName()
	end

	local db = getUserProfile()
	if ( db[setting] ~= nil ) then
		return db[setting]
	else
		return getDefault(setting)
	end
end

function lib.GetSetting(setting, default)
	local option = getter(setting)
	if ( option ~= nil ) then
		return option
	else
		return default
	end
end

private.setter = setter
private.getter = getter
function lib.MakeGuiConfig()

	
	if gui then return end
	
	local id
	local Configator = LibStub:GetLibrary("Configator")
	gui = Configator:Create(setter, getter)
		
	local baseGUI
	lib.Gui = gui
	
  	gui:AddCat("BeanCounter")
	
	id = gui:AddTab(_BC('C_BeanCounterConfig')) --"BeanCounter Config")
	gui:MakeScrollable(id)
	gui:AddControl(id, "Header",     0,    _BC('C_BeanCounterOptions')) --"BeanCounter options")
	
	gui:AddControl(id, "Checkbox",   0, 1, "util.beancounter.displaybeginerTooltips", _BC('C_ShowBeginnerTooltips'))--"Show beginner tooltips on mouse over" 
	gui:AddTip(id, _BC('TTShowBeginnerTooltips')) --Turns on the beginner tooltips that display on mouse eover
	
	gui:AddControl(id, "Checkbox",   0, 1, "util.beancounter.displayReasonCodeTooltip", _BC('C_ShowReasonPurchase'))--Show reason for purchase in the games Tooltips
	gui:AddTip(id, _BC('TTShowReasonPurchase'))--Turns on the SearchUI reason an item was purchased for in the tooltip
		
	gui:AddControl(id, "Checkbox",   0, 1, "util.beancounter.externalSearch", _BC('C_ExtenalSearch')) --"Allow External Addons to use BeanCounter's Search?")
	gui:AddTip(id, _BC('TTExtenalSearch')) --"When entering a search in another addon, BeanCounter will also display a search for that item.")
		
	gui:AddControl(id, "WideSlider", 0, 1, "util.beacounter.invoicetime",    1, 20, 1, _BC('C_MailInvoiceTimeout')) --"Mail Invoice Timeout = %d seconds")
	gui:AddTip(id, _BC('TTMailInvoiceTimeout')) --Chooses how long BeanCounter will attempt to get a mail invoice from the server before giving up. Lower == quicker but more chance of missing data, Higher == slower but improves chances of getting data if the Mail server is extremely busy.
		
	gui:AddControl(id, "Subhead",    0,    _BC('C_MailRecolor')) --"Mail Re-Color Method")
	gui:AddControl(id, "Selectbox",  0, 1, {{"off",_BC("NoRe-Color")},{"icon",_BC("Re-ColorIcons")},{"both",_BC("Re-ColorIconsandText")},{"text",_BC("Re-ColorText")}}, "util.beancounter.mailrecolor", _BC("MailRe-ColorMethod"))
	gui:AddTip(id, _BC('TTMailRecolor')) --"Choose how Mail will appear after BeanCounter has scanned the Mail Box")
		
	gui:AddControl(id, "Text",       0, 1, "dateString", "|CCFFFCC00".._BC('C_DateString')) --"|CCFFFCC00Date format to use:")
	gui:AddTip(id, _BC('TTDateString'))--"Enter the format that you would like your date field to show. Default is %c")
	gui:AddControl(id, "Checkbox",   0, 1, "dateStringdisplay", "|CCFFFCC00".._BC('C_DateStringExample').." 11/28/07 21:34:21") --"|CCFFFCC00Example Date: 11/28/07 21:34:21")
	gui:AddTip(id, _BC('TTDateStringExample'))--"Displays an example of what your formated date will look like")
	
	gui:AddHelp(id, "what is invoice",
		_BC('Q_MailInvoiceTimeout'), --"What is Mail Invoice Timeout?",
		_BC('A_MailInvoiceTimeout') --"The length of time BeanCounter will wait on the server to respond to an invoice request. A invoice is the who, what, how of an Auction house mail"
		)
	gui:AddHelp(id, "what is recolor",
		_BC('Q_MailRecolor'), --"What is Mail Re-Color Method?",
		_BC('A_MailRecolor') --"BeanCounter reads all mail from the Auction House, This option tells Beancounter how the user want's to Recolor the messages to make them look unread."
		)
	gui:AddHelp(id, "what is tooltip",
		_BC('Q_BeanCountersTooltip'),--What is BeanCounters Tooltip 
		_BC('A_BeanCountersTooltip')--BeanCounter will store the SearchUI reason an item was purchased and display it in the tooltip
		)
	gui:AddHelp(id, "what is external",
		_BC('Q_ExtenalSearch'), --"Allow External Addons to use BeanCounter?",
		_BC('A_ExtenalSearch') --"Other addons can have BeanCounter search for an item to be displayed in BeanCounter's GUI. For example this allows BeanCounter to show what items you are looking at in Appraiser"
		)
	gui:AddHelp(id, "what is date",
		_BC('Q_DateString'), --"Date Format to use?",
		_BC('A_DateString') --"This controls how the Date field of BeanCounter's GUI is shown. Commands are prefaced by % and multiple commands and text can be mixed. For example %a == %X would display Wed == 21:34:21"
		)
	gui:AddHelp(id, "what is date command",
		_BC('Q_DateStringCommands'), --"Acceptable Date Commands?",
		_BC('A_DateStringCommands') --"Commands: \n %a = abr. weekday name, \n %A = weekday name, \n %b = abr. month name, \n %B = month name,\n %c = date and time, \n %d = day of the month (01-31),\n %H = hour (24), \n %I = hour (12),\n %M = minute, \n %m = month,\n %p = am/pm, \n %S = second,\n %U = week number of the year ,\n %w = numerical weekday (0-6),\n %x = date, \n %X = time,\n %Y = full year (2007), \n %y = two-digit year (07)"
		)			
	
	id = gui:AddTab(_BC('C_DataMaintenance')) --"Data Maintenance"
	lib.Id = id
	gui:MakeScrollable(id)
	gui:AddControl(id, "Header",     0,    _BC('C_BeanCounterDatabaseMaintenance')) --"BeanCounter Database Maintenance"
	gui:AddControl(id, "Subhead",    0,    _BC('C_Resortascendingtime')) --"Resort all entries by ascending time"
	gui:AddControl(id, "Button",     0, 1, "database.sort", _BC('C_Resort Database')) --"Resort Database"
	gui:AddTip(id, _BC('TTResort Database'))--"This will scan Beancounter's Data sort all entries in ascending time order. This helps speed up the database compression functions"
	
	gui:AddControl(id, "Subhead",    0,    _BC('C_ScanDatabase')) --"Scan Database for errors: Use if you have errors when searching BeanCounter. \n Backup BeanCounter's saved variables before using."
	gui:AddControl(id, "Button",     0, 1, "database.validate", _BC('C_ValidateDatabase')) --"Validate Database"
	gui:AddTip(id, _BC('TTValidateDatabase')) --"This will scan Beancounter's Data and attempt to correct any error it may find. Use if you are getting errors on search"
		
	
	id = gui:AddTab("BeanCounter Debug")
	gui:AddControl(id, "Header",     0,    "BeanCounter Debug")
	gui:AddControl(id, "Checkbox",   0, 1, "util.beancounter.debug", "Turn on BeanCounter Debugging.")
	gui:AddControl(id, "Subhead",    0,    "Reports From Specific Modules")

	gui:AddControl(id, "Checkbox",   0, 2, "util.beancounter.debugMail", "Mail")
	gui:AddControl(id, "Checkbox",   0, 2, "util.beancounter.debugCore", "Core")
	gui:AddControl(id, "Checkbox",   0, 2, "util.beancounter.debugConfig", "Config")
	gui:AddControl(id, "Checkbox",   0, 2, "util.beancounter.debugVendor", "Vendor")
	gui:AddControl(id, "Checkbox",   0, 2, "util.beancounter.debugBid", "Bid")
	gui:AddControl(id, "Checkbox",   0, 2, "util.beancounter.debugPost", "Post")
	gui:AddControl(id, "Checkbox",   0, 2, "util.beancounter.debugUpdate", "Update")
	gui:AddControl(id, "Checkbox",   0, 2, "util.beancounter.debugFrames", "Frames")
	gui:AddControl(id, "Checkbox",   0, 2, "util.beancounter.debugAPI", "API")
	gui:AddControl(id, "Checkbox",   0, 2, "util.beancounter.debugSearch", "Search")

end
