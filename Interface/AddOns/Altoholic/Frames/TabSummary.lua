function Altoholic:SummaryMenuOnClick(index)
	
	AltoholicFrameSummary:Hide()
	AltoholicFrameBagUsage:Hide()
	AltoholicFrameSkills:Hide()
	
	if index == 1 then
		AltoholicFrameSummary:Show()
		Altoholic:AccountSummary_Update()
	elseif index == 2 then
		AltoholicFrameBagUsage:Show()
		Altoholic:BagUsage_Update()
	elseif index == 3 then
		AltoholicFrameSkills:Show()
		Altoholic:Skills_Update()
	end
	
	for i=1, 3 do 
		_G[ "AltoholicTabSummaryMenuItem"..i ]:UnlockHighlight();
	end
	_G[ "AltoholicTabSummaryMenuItem"..index ]:LockHighlight();
end
