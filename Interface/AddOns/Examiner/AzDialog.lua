-- Set AzDialog Revision. Don't load again if newer or same revision is already loaded
if (AZDIALOG_REV and AZDIALOG_REV >= 2) then
	return;
end
AZDIALOG_REV = 2;

-- local callback variables
local callBackText, callBackOK, callBackCancel;

--------------------------------------------------------------------------------------------------------
--                                         Create the Dialog                                          --
--------------------------------------------------------------------------------------------------------

-- AzDialog
local d = CreateFrame("Frame",nil,UIParent);
d:SetWidth(310);
d:SetHeight(88);
d:SetBackdrop({ bgFile="Interface\\ChatFrame\\ChatFrameBackground", edgeFile="Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 8,edgeSize = 12, insets = { left = 2, right = 2, top = 2, bottom = 2 } });
d:SetBackdropColor(0.1,0.22,0.35,1.0);
d:SetBackdropBorderColor(0.1,0.1,0.1,1.0);
d:SetMovable(1);
d:EnableMouse(1);
d:SetToplevel(1);
d:SetScript("OnMouseDown",function(self) self:StartMoving(); end);
d:SetScript("OnMouseUp",function(self) self:StopMovingOrSizing(); end);
d:Hide();

-- Header
d.header = d:CreateFontString(nil,"ARTWORK","GameFontHighlight");

-- Dialog Closed Using "OK"
local function onOK()
	if (callBackOK) then
		callBackOK(callBackText and d.edit:GetText());
	end
	d:Hide();
end

-- Dialog Closed Using "Cancel"
local function onCancel()
	if (callBackCancel) then
		callBackCancel(callBackText);
	end
	d:Hide();
end

-- Edit
d.edit = CreateFrame("EditBox","AzDialogEdit"..AZDIALOG_REV,d,"InputBoxTemplate");
d.edit:SetHeight(21);
d.edit:SetPoint("TOPLEFT",16,-30);
d.edit:SetPoint("TOPRIGHT",-12,-30);
d.edit:SetScript("OnEnterPressed",onOK);
d.edit:SetScript("OnEscapePressed",onCancel);

-- Cancel
d.cancel = CreateFrame("Button",nil,d,"UIPanelButtonTemplate");
d.cancel:SetWidth(75);
d.cancel:SetHeight(21);
d.cancel:SetScript("OnClick",onCancel);
d.cancel:SetText("Cancel");

-- OK
d.ok = CreateFrame("Button",nil,d,"UIPanelButtonTemplate");
d.ok:SetWidth(75);
d.ok:SetHeight(21);
d.ok:SetPoint("RIGHT",d.cancel,"LEFT",-8,0);
d.ok:SetScript("OnClick",onOK);
d.ok:SetText("OK");

--------------------------------------------------------------------------------------------------------
--                                                Code                                                --
--------------------------------------------------------------------------------------------------------

-- Close this frame with escape
AzDialog = d;
tinsert(UISpecialFrames,"AzDialog");

-- Show Dialog
function d:New(header,text,funcOK,funcCancel)
	-- Store call back values
	callBackText = text;
	callBackOK = funcOK;
	callBackCancel = funcCancel;
	-- Set Type
	d.header:SetText(header or "Enter text here...");
	if (text) then
		d:SetHeight(88);
		d.header:ClearAllPoints();
		d.header:SetPoint("TOPLEFT",10,-10);
		d.edit:SetText(callBackText);
		d.edit:Show();
		d.cancel:ClearAllPoints();
		d.cancel:SetPoint("BOTTOMRIGHT",-10,10);
	else
		d:SetHeight(66);
		d.header:ClearAllPoints();
		d.header:SetPoint("TOP",0,-10);
		d.edit:Hide();
		d.cancel:ClearAllPoints();
		d.cancel:SetPoint("BOTTOM",42,10);
	end
	-- Center Dialog & Show
	d:ClearAllPoints();
	d:SetPoint("CENTER",0,110);
	d:Show();
end