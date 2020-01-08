function Altoholic:UpdateMinimapIconCoords()
	-- Thanks to Atlas for this code, modified to fit this addon's requirements though
	local xPos, yPos = GetCursorPosition() 
	local left, bottom = Minimap:GetLeft(), Minimap:GetBottom() 

	xPos = left - xPos/UIParent:GetScale() + 70 
	yPos = yPos/UIParent:GetScale() - bottom - 70 

	local O = self.db.account.options
	O.MinimapIconAngle = math.deg(math.atan2(yPos, xPos))
	
	if(O.MinimapIconAngle < 0) then
		O.MinimapIconAngle = O.MinimapIconAngle + 360
	end
	_G["AltoholicTabOptionsFrame4_SliderAngle"]:SetValue(O.MinimapIconAngle)
end

function Altoholic:MoveMinimapIcon()
	local O = self.db.account.options
	
	AltoholicMinimapButton:SetPoint(	"TOPLEFT", "Minimap", "TOPLEFT",
		54 - (O.MinimapIconRadius * cos(O.MinimapIconAngle)),
		(O.MinimapIconRadius * sin(O.MinimapIconAngle)) - 55	);
end
