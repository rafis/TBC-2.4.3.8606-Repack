local V = Altoholic.vars

local TEAL		= "|cFF00FF9A"

function Altoholic:Recipes_Update()
	local c = self.db.account.data[V.CurrentFaction][V.CurrentRealm].char[V.CurrentAlt]		-- current alt
	local VisibleLines = 14
	local frame = "AltoholicFrameRecipes"
	local entry = frame.."Entry"
	
	if c.recipes[V.CurrentProfession].ScanFailed then
		AltoholicTabCharactersStatus:SetText(L["No data: "] .. V.CurrentProfession .. L[" scan failed for "] .. V.CurrentAlt)
		self:ClearScrollFrame( _G[ frame.."ScrollFrame" ], entry, VisibleLines, 18)
		return
	else
		AltoholicTabCharactersStatus:SetText("")
	end
	
	local offset = FauxScrollFrame_GetOffset( _G[ frame.."ScrollFrame" ] );
	local DisplayedCount = 0
	local VisibleCount = 0
	local DrawGroup = true
	local i=1
	
	for line, s in pairs(c.recipes[V.CurrentProfession].list) do
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
				_G[entry..i.."RecipeLinkNormalText"]:SetText(TEAL .. s.name)
				_G[entry..i.."RecipeLink"]:SetID(0)
				_G[entry..i.."RecipeLink"]:SetPoint("TOPLEFT", 25, 0)

				for j=1, 8 do
					_G[ entry..i .. "Item" .. j ]:Hide()
				end
				
				_G[ entry..i ]:SetID(line)
				_G[ entry..i ]:Show()
				i = i + 1
				VisibleCount = VisibleCount + 1
				DisplayedCount = DisplayedCount + 1
				
			elseif DrawGroup then
				_G[entry..i.."Collapse"]:Hide()
				_G[entry..i.."RecipeLinkNormalText"]:SetText(s.link)
				_G[entry..i.."RecipeLink"]:SetID(line)
				_G[entry..i.."RecipeLink"]:SetPoint("TOPLEFT", 15, 0)

				for j=1, 8 do
					local itemName = entry..i .. "Item" .. j;
					local reagent = select(j, strsplit("|", s.reagents))
					
					if reagent then
						local reagentID, reagentCount = strsplit(":", reagent)
						reagentID = tonumber(reagentID)
						reagentCount = tonumber(reagentCount)
						
						local itemButton = _G[itemName];
						itemButton:SetID(reagentID)
						local itemTexture = _G[itemName .. "IconTexture"]
						itemTexture:SetTexture(GetItemIcon(reagentID));
						itemTexture:SetWidth(18);
						itemTexture:SetHeight(18);
						itemTexture:SetAllPoints(itemButton);

						local itemCount = _G[itemName .. "Count"]
						itemCount:SetText(reagentCount);
						itemCount:Show();
						
						_G[ itemName ]:Show()
					else
						_G[ itemName ]:Hide()
					end
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

