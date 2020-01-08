local L = AceLibrary("AceLocale-2.2"):new("Altoholic")

local V = Altoholic.vars
local WHITE		= "|cFFFFFFFF"
local GREEN		= "|cFF00FF00"

function AltoholicTabGuildBank:SelectGuildDropDown_Initialize()
	local info = UIDropDownMenu_CreateInfo(); 

	for FactionName, f in pairs(Altoholic.db.account.data) do
		for RealmName, r in pairs(f) do
			for GuildName, _ in pairs(r.guild) do
				info.text = GREEN .. GuildName .. WHITE .. " (" .. RealmName .. ")"
				info.value = FactionName .."|" .. RealmName .."|".. GuildName
				info.owner = this:GetParent(); 
				info.checked = nil; 
				info.func = function(self)
					local OldValue = UIDropDownMenu_GetSelectedValue(this.owner)
					local faction, realm, guildname = strsplit("|", this.value)
					
					UIDropDownMenu_ClearAll(this.owner);
					UIDropDownMenu_SetSelectedValue(this.owner, faction .."|" .. realm .."|".. guildname)
					UIDropDownMenu_SetText(GREEN .. guildname .. WHITE .. " (" .. realm .. ")", this.owner)
				
					if OldValue then
						local OldFaction, OldRealm, OldGuild = strsplit("|", OldValue)
						if (OldGuild ~= guildname) or (OldRealm ~= realm) or (OldFaction ~= faction) then
							for i = 1, 6 do
								GuildBank:Hide()
								_G[ "AltoholicTabGuildBankMenuItem"..i ]:UnlockHighlight();
								local t = Altoholic.db.account.data[V.faction][V.realm].guild[guildname].bank["Tab"..i]
								if t.tabID then
									_G[ "AltoholicTabGuildBankMenuItem" .. i ]:SetText(WHITE .. t.name)
									_G[ "AltoholicTabGuildBankMenuItem" .. i ]:Show()
								else
									_G[ "AltoholicTabGuildBankMenuItem" .. i ]:Hide()
								end
							end
							AltoholicTabGuildBankStatus:SetText("")
						end
					end
				end
				
				UIDropDownMenu_AddButton(info, 1); 
			end
		end
	end
end
