local _, core = ...;

CollectionState = {
	dataSet = nil,
	stopwatch = nil,
	startGold = nil,
	endGold = nil
};

function CollectionState:new(o)
	o = o or {};
	setmetatable(o, self);
	self.__index = self;
	
	self.dataSet = DataSet:new(nil);
	self.stopwatch = Stopwatch:new(nil);
	
	return o;
end

function CollectionState:GrabCharacterInfo()
	local charInfo = core.Game:GetCharacterInfo();
	self.dataSet:SetCharacterInfo(
		charInfo.realm,
		charInfo.name,
		charInfo.level,
		charInfo.itemLevel,
		charInfo.race,
		charInfo.class,
		charInfo.spec
	);
end

function CollectionState:SaveData()
	self.dataSet:SetTimestamp();
	core.Data:SaveData(self.dataSet);
end

function CollectionState:ResetData()
	self.dataSet:Clear();
	self.stopwatch:Reset();
	self.startGold = nil;
	self.endGold = nil;
end

function CollectionState:StartTime()
	if not startGold then
		self.startGold = core.Game:GetMoney();
	end
	
	self.stopwatch:Start();
end

function CollectionState:ToggleTime()
	if self.stopwatch:IsRunning() then
		self.stopwatch:Stop();
	else
		self.stopwatch:Start();
	end
end

function CollectionState:ResetTime()
	self.startGold = nil;
	self.endGold = nil;
	self.dataSet:SetRunInfo(nil, nil, nil);
	self.stopwatch:Reset();
end

local function GoldToCopper(gold)
	gold = math.floor(rawGoldMade * 100000);
	if gold % 10 > 4 then
		gold = gold + 10;
	end
	return math.floor(gold / 10);
end

function CollectionState:SetEndGold()
	self.endGold = core.Game:GetMoney();
	
	self.dataSet.goldMade = self.endGold - self.startGold;
	
	if self.dataSet.runTime == 0 then
		self.dataSet.gpm = nil;
	else
		local gpm = self.dataSet.goldMade / (self.dataSet.runTime / 60);
		gpm = gpm * 10;
		if gpm % 10 > 4 then
			gpm = gpm + 10;
		end
		gpm = math.floor(gpm / 10);
		
		self.dataSet.gpm = gpm;
	end
end
