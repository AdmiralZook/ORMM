local _, core = ...;

DataSet = {
	timestamp = nil,
	
	realm = nil,
	name = nil,
	level = nil,
	itemLevel = nil,
	race = nil,
	class = nil,
	spec = nil,
	
	instName = nil,
	instDiff = nil,
	instSize = nil,
	
	runTime = nil,
	goldMade = nil,
	gpm = nil
};

function DataSet:new(o)
	o = o or {};
	setmetatable(o, self);
	self.__index = self;
	
	return o;
end

function DataSet:SetTimestamp()
	-- this is the epoch time, don't worry about converting to UTC
	self.timestamp = time();
	--print(self.timestamp - (60 * 60 * 24 * 7));
	
	--[[
	self.timestamp = time(date("!*t"));
	local dateInfo = date("!*t", self.timestamp);
	print(self.timestamp);
	print(
		format("%s-%s-%s (%s, %s) %s:%s:%s",
			dateInfo.year,
			dateInfo.month,
			dateInfo.day,
			dateInfo.yday,
			dateInfo.wday,
			dateInfo.hour,
			dateInfo.min,
			dateInfo.sec
		)
	);
	
	local secondsSinceOneWeekAgo = 60 * 60 * 24 * 7;
	local timeInfo = time(dateInfo);
	print(timeInfo);
	timeInfo = time() - secondsSinceOneWeekAgo;
	print(timeInfo);
	dateInfo = date("!*t", timeInfo);
	print(
		format("%s-%s-%s (%s, %s) %s:%s:%s",
			dateInfo.year,
			dateInfo.month,
			dateInfo.day,
			dateInfo.yday,
			dateInfo.wday,
			dateInfo.hour,
			dateInfo.min,
			dateInfo.sec
		)
	);--]]
end

function DataSet:SetCharacterInfo(realm, name, level, itemLevel, race, class, spec)
	self.realm = realm;
	self.name = name;
	self.level = level;
	self.itemLevel = itemLevel;
	self.race = race;
	self.class = class;
	self.spec = spec;
end

function DataSet:SetInstanceInfo(instName, instDiff, instSize)
	self.instName = instName;
	self.instDiff = instDiff;
	self.instSize = instSize;
end

function DataSet:SetRunInfo(runTime, goldMade, gpm)
	self.runTime = runTime;
	self.goldMade = goldMade;
	self.gpm = gpm;
end

function DataSet:Clear()
	self.timestamp = nil;
	self:SetCharacterInfo(nil, nil, nil, nil, nil);
	self:SetInstanceInfo(nil, nil, nil);
	self:SetRunInfo(nil, nil, nil);
end

core.Data = {};
local Data = core.Data;

function Data:SaveData(dataSet)
	local formattedData = format("%s;%s,%s,%s,%s,%s,%s,%s;%s,%s,%s;%s;%s,%s",
		dataSet.timestamp,
		dataSet.realm,
		dataSet.name,
		dataSet.level,
		dataSet.itemLevel,
		dataSet.race,
		dataSet.class,
		dataSet.spec,
		dataSet.instName,
		dataSet.instDiff,
		dataSet.instSize,
		dataSet.runTime,
		dataSet.goldMade,
		dataSet.gpm
	);
	
	tinsert(SAVED_DATA, formattedData);
end
