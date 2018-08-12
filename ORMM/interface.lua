local _, core = ...;

core.Interface = {};
local Interface = core.Interface;

--------------------
-- MISC FUNCTIONS --
--------------------

local function TryPaintText(frame, text, default)
	frame:SetText(text and text or default)
end

local function AsGoldString(gold)
	if not gold then return nil end
	return GetCoinTextureString(gold);
end

--------------------------------------
-- GENERAL FRAME CREATION FUNCTIONS --
--------------------------------------

local function CreateORMMMovableFrame(title, template, width, height)
	local frame = CreateFrame("Frame", title, UIParent, template);
	frame:SetMovable(true);
	frame:EnableMouse(true);
	frame:RegisterForDrag("LeftButton");
	frame:SetScript("OnDragStart", frame.StartMoving);
	frame:SetScript("OnDragStop", frame.StopMovingOrSizing);
	frame:SetSize(width, height);
	return frame;
end

local function CreateORMMLabel(parent, text, font, point, relativeFrame, relativePoint, xOffset, yOffset)
	local label = parent:CreateFontString(nil, "ARTWORK");
	label:SetFontObject(font);
	label:SetPoint(point, relativeFrame, relativePoint, xOffset, yOffset);
	label:SetText(text);
	return label;
end

local function CreateORMMStandardButton(parent, text, width, height, point, relativeFrame, relativePoint, xOffset, yOffset)
	local button = CreateFrame("Button", "OVERLAY", parent, "GameMenuButtonTemplate");
	button:SetPoint(point, relativeFrame, relativePoint, xOffset, yOffset);
	button:SetSize(width, height);
	button:SetNormalFontObject("GameFontNormal");
	button:SetHighlightFontObject("GameFontHighlight");
	button:SetText(text);
	return button;
end

----------------------
-- COLLECTION FRAME --
----------------------

CollectionFrame = {
	frame = nil,
	state = nil
};

function CollectionFrame:new(o)
	o = o or {};
	setmetatable(o, self);
	self.__index = self;
	
	self.frame = self:Create();
	self.state = CollectionState:new(nil);
	self:HookUpActions();
	
	return o;
end

function CollectionFrame:Create()
	-- Frame and Title
	
	local frame = CreateORMMMovableFrame("ORMMCollectionFrame", "BasicFrameTemplateWithInset", 560, 200);
	frame:Hide();
	frame:SetPoint("CENTER", UIParent, "CENTER");
	
	frame.title = CreateORMMLabel(frame, "Old Raid Money Maker (ORMM)", "GameFontHighlight", "CENTER", frame.TitleBg, "CENTER", 0, 0);
	
	-- Character Information Section
	
	frame.nameLabel = CreateORMMLabel(frame, "Name", "GameFontNormal", "TOPLEFT", frame, "TOPLEFT", 13, -33);
	frame.levelLabel = CreateORMMLabel(frame, "Level", "GameFontNormal", "TOPLEFT", frame.nameLabel, "TOPLEFT", 0, -15);
	frame.raceLabel = CreateORMMLabel(frame, "Race", "GameFontNormal", "TOPLEFT", frame.levelLabel, "TOPLEFT", 0, -15);
	frame.classLabel = CreateORMMLabel(frame, "Class", "GameFontNormal", "TOPLEFT", frame.raceLabel, "TOPLEFT", 0, -15);
	frame.specLabel = CreateORMMLabel(frame, "Spec", "GameFontNormal", "TOPLEFT", frame.classLabel, "TOPLEFT", 0, -15);
	
	frame.nameValue = CreateORMMLabel(frame, "", "GameFontWhite", "TOPLEFT", frame.nameLabel, "TOPLEFT", 70, 0);
	frame.levelValue = CreateORMMLabel(frame, "", "GameFontWhite", "TOPLEFT", frame.nameValue, "TOPLEFT", 0, -15);
	frame.raceValue = CreateORMMLabel(frame, "", "GameFontWhite", "TOPLEFT", frame.levelValue, "TOPLEFT", 0, -15);
	frame.classValue = CreateORMMLabel(frame, "", "GameFontWhite", "TOPLEFT", frame.raceValue, "TOPLEFT", 0, -15);
	frame.specValue = CreateORMMLabel(frame, "", "GameFontWhite", "TOPLEFT", frame.classValue, "TOPLEFT", 0, -15);
	
	-- Instance Information Section
	
	frame.instPresentLabel = CreateORMMLabel(frame, "Collecting data for the instance:", "GameFontNormal", "TOPLEFT", frame.specLabel, "TOPLEFT", 0, -30);
	
	frame.instNameValue = CreateORMMLabel(frame, "", "GameFontWhite", "TOPLEFT", frame.instPresentLabel, "TOPLEFT", 0, -15);
	frame.instDiffAndSizeValue = CreateORMMLabel(frame, "", "GameFontWhite", "TOPLEFT", frame.instNameValue, "TOPLEFT", 0, -15);
	
	-- Save and Reset All Buttons
	
	frame.saveButton = CreateORMMStandardButton(frame, "Save", 160, 20, "TOPLEFT", frame.instDiffAndSizeValue, "TOPLEFT", 0, -15);
	frame.resetAllButton = CreateORMMStandardButton(frame, "RESET ALL", 90, 20, "TOPLEFT", frame.saveButton, "TOPLEFT", 160, 0);
	
	-- Stopwatch Section
	
	frame.timeLabel = CreateORMMLabel(frame, "Run Time", "GameFontNormal", "TOPRIGHT", frame, "TOPRIGHT", -223, -33);
	
	frame.timeValue = CreateORMMLabel(frame, "", "GameFontWhite", "TOPLEFT", frame.timeLabel, "TOPLEFT", 100, 0);
	
	frame.timeStartButton = CreateORMMStandardButton(frame, "Start", 90, 20, "TOPLEFT", frame.timeLabel, "TOPLEFT", 0, -15);
	frame.timeToggleButton = CreateORMMStandardButton(frame, "Stop", 90, 20, "TOPLEFT", frame.timeStartButton, "TOPLEFT", 90, 0);
	frame.timeResetButton = CreateORMMStandardButton(frame, "Reset", 90, 20, "TOPLEFT", frame.timeToggleButton, "TOPLEFT", 90, 0);
	
	-- Gold Section
	
	frame.startGoldLabel = CreateORMMLabel(frame, "Starting Gold", "GameFontNormal", "TOPLEFT", frame.timeStartButton, "TOPLEFT", 0, -35);
	frame.endGoldLabel = CreateORMMLabel(frame, "Ending Gold", "GameFontNormal", "TOPLEFT", frame.startGoldLabel, "TOPLEFT", 0, -15);
	frame.goldMadeLabel = CreateORMMLabel(frame, "Gold Made", "GameFontNormal", "TOPLEFT", frame.endGoldLabel, "TOPLEFT", 0, -25);
	frame.gpmLabel = CreateORMMLabel(frame, "GPM", "GameFontNormal", "TOPLEFT", frame.goldMadeLabel, "TOPLEFT", 0, -15);
	
	frame.startGoldValue = CreateORMMLabel(frame, "", "GameFontWhite", "TOPLEFT", frame.startGoldLabel, "TOPLEFT", 100, 0);
	frame.endGoldValue = CreateORMMLabel(frame, "", "GameFontWhite", "TOPLEFT", frame.startGoldValue, "TOPLEFT", 0, -15);
	frame.goldMadeValue = CreateORMMLabel(frame, "", "GameFontWhite", "TOPLEFT", frame.endGoldValue, "TOPLEFT", 0, -25);
	frame.gpmValue = CreateORMMLabel(frame, "", "GameFontWhite", "TOPLEFT", frame.goldMadeValue, "TOPLEFT", 0, -15);
	
	frame.endGoldButton = CreateORMMStandardButton(frame, "Set Ending Gold", 270, 20, "TOPLEFT", frame.gpmLabel, "TOPLEFT", 0, -15);
	
	frame.endGoldWarning = CreateORMMLabel(frame, "Make sure you sell your loot!", "GameFontDarkGraySmall", "TOP", frame.endGoldButton, "BOTTOM", 0, -5);
	
	return frame;
end

function CollectionFrame:Repaint()
	if not self.state then return end
	
	TryPaintText(self.frame.nameValue, self.state.dataSet.name, "N/A");
	local levelString = self.state.dataSet.level;
	if levelString and self.state.dataSet.itemLevel then
		levelString = levelString .. " (" .. self.state.dataSet.itemLevel .. " iL)";
	end
	TryPaintText(self.frame.levelValue, levelString, "N/A");
	TryPaintText(self.frame.raceValue, self.state.dataSet.race, "N/A");
	TryPaintText(self.frame.classValue, self.state.dataSet.class, "N/A");
	TryPaintText(self.frame.specValue, self.state.dataSet.spec, "N/A");
	
	TryPaintText(self.frame.instNameValue, self.state.dataSet.instName, "");
	TryPaintText(self.frame.instDiffAndSizeValue, self.state.dataSet.instDiff, "");
	if self.state.dataSet.instName and self.state.dataSet.runTime and self.state.dataSet.goldMade then
		self.frame.saveButton:Enable();
	else
		self.frame.saveButton:Disable();
	end
	
	TryPaintText(self.frame.timeValue, self.state.stopwatch:GetTimeAsString(), "--:--:--");
	
	local stopwatchHasBeenRun = self.state.stopwatch:HasBeenRun();
	local stopwatchIsRunning = self.state.stopwatch:IsRunning();
	
	if self.state.dataSet.instName then
		if stopwatchHasBeenRun then
			self.frame.timeStartButton:Disable();
			self.frame.timeToggleButton:Enable();
			self.frame.timeResetButton:Enable();
		else
			self.frame.timeStartButton:Enable();
			self.frame.timeToggleButton:Disable();
			self.frame.timeResetButton:Disable();
		end
	else
		self.frame.timeStartButton:Disable();
		self.frame.timeToggleButton:Disable();
		self.frame.timeResetButton:Disable();
	end
	
	if stopwatchIsRunning or not stopwatchHasBeenRun then
		self.frame.timeToggleButton:SetText("Stop");
	else
		self.frame.timeToggleButton:SetText("Resume");
	end
	
	TryPaintText(self.frame.startGoldValue, AsGoldString(self.state.startGold), "");
	TryPaintText(self.frame.endGoldValue, AsGoldString(self.state.endGold), "");
	TryPaintText(self.frame.goldMadeValue, AsGoldString(self.state.dataSet.goldMade), "");
	if self.state.dataSet.goldMade and not self.state.dataSet.gpm then
		TryPaintText(self.frame.gpmValue, "???", "");
	else
		TryPaintText(self.frame.gpmValue, AsGoldString(self.state.dataSet.gpm), "");
	end
	
	if stopwatchHasBeenRun and not stopwatchIsRunning then
		self.frame.endGoldButton:Enable();
		self.frame.endGoldWarning:Show();
	else
		self.frame.endGoldButton:Disable();
		self.frame.endGoldWarning:Hide();
	end
end

function CollectionFrame:PerformResetAll()
	self.state:ResetData();
	self.state:GrabCharacterInfo();
	core.Interface:CheckInstanceEntry();
	self:Repaint();
end

function CollectionFrame:HookUpActions()
	StaticPopupDialogs["RESET_ALL_CONFIRMATION"] = {
		text = "Are you sure you want to reset the collection data?",
		button1 = "Yes",
		button2 = "No",
		OnAccept = function()
			self:PerformResetAll()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	
	StaticPopupDialogs["SAVE_NOTIFICATION"] = {
		text = "Data saved successfully.", nil, "GameFontWhite",
		button1 = "OK",
		OnAccept = nil,
		timeout = 0;
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	
	self.frame.saveButton:SetScript("OnClick",
		function()
			self.state:SaveData();
			self:PerformResetAll();
			self:Repaint();
			
			StaticPopup_Show("SAVE_NOTIFICATION");
		end
	);
	self.frame.resetAllButton:SetScript("OnClick",
		function()
			StaticPopup_Show("RESET_ALL_CONFIRMATION");
		end
	);
	
	self.frame.timeStartButton:SetScript("OnClick",
		function()
			self.state:StartTime();
			self:Repaint();
		end
	);
	self.frame.timeToggleButton:SetScript("OnClick",
		function()
			self.state:ToggleTime();
			self:Update();
			self:Repaint();
		end
	);
	self.frame.timeResetButton:SetScript("OnClick",
		function()
			self.state:ResetTime();
			self:Repaint();
		end
	);
	
	self.frame.endGoldButton:SetScript("OnClick",
		function()
			self.state:SetEndGold();
			self:Repaint();
		end
	);
end

function CollectionFrame:Hide()
	self.frame:Hide();
end

function CollectionFrame:Show()
	self.frame:Show();
	
	self.state:GrabCharacterInfo();
	
	Interface:CheckInstanceEntry();
	Interface:Update();
	self:Repaint();
end

function CollectionFrame:Update()
	self.state.stopwatch:Update();
	self.state.dataSet.runTime = self.state.stopwatch:GetTime();
	self:Repaint();
end

function CollectionFrame:IsShown()
	return self.frame:IsShown();
end

function CollectionFrame:RegisterEvent(event)
	self.frame:RegisterEvent(event);
end

function CollectionFrame:SetScript(event, script)
	self.frame:SetScript(event, script);
end

function CollectionFrame:SetState(state)
	self.state = state;
end

function CollectionFrame:OnInstanceEntry(instInfo)
	if self.state.stopwatch:HasBeenRun() then return end
	self.state.dataSet:SetInstanceInfo(instInfo.name, instInfo.diff, instInfo.size);
	
	self:Repaint();
	if not self:IsShown() then
		self:Show();
	end
end

--------------------------
-- BEHAVIORAL FUNCTIONS --
--------------------------

local collectionFrame;
function Interface:GetOrCreateCollectionFrame()
	collectionFrame = collectionFrame or CollectionFrame:new(nil);
	return collectionFrame;
end

function Interface:GetFrame()
	return Interface:GetOrCreateCollectionFrame();
end

function Interface:Show()
	Interface:GetFrame():Show();
end

function Interface:Hide()
	Interface:GetFrame():Hide();
end

function Interface:Toggle()
	local frame = Interface:GetFrame();
	if frame:IsShown() then
		frame:Hide();
	else
		frame:Show();
	end
end

function Interface:Update()
	if collectionFrame then
		collectionFrame:Update();
	end
end

---------------------
-- EVENT FUNCTIONS --
---------------------

function Interface:CheckInstanceEntry()
	local instInfo = core.Game:GetInstanceInfo();
	if not instInfo.inInstance then return end
	
	Interface:GetOrCreateCollectionFrame():OnInstanceEntry(instInfo);
end
