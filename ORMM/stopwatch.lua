local _, core = ...;

Stopwatch = {
	hasBeenRun = false,
	previousTime = nil,
	elapsedTime = 0,
	
	seconds = nil,
	minutes = nil,
	hours = nil
};

function Stopwatch:new(o)
	o = o or {};
	setmetatable(o, self);
	self.__index = self;
	
	return o;
end

function Stopwatch:ClearTimesCache()
	self.seconds = nil;
	self.minutes = nil;
	self.hours = nil;
end

function Stopwatch:GetSecondsTimeComponent()
	self.seconds = self.seconds or self.elapsedTime % 60;
	return self.seconds;
end

function Stopwatch:GetMinutesTimeComponent()
	self.minutes = self.minutes or math.floor(self.elapsedTime / 60) % 60;
	return self.minutes;
end

function Stopwatch:GetHoursTimeComponent()
	self.hours = self.hours or math.floor(self.elapsedTime / 3600);
	return self.hours;
end

function Stopwatch:GetTime()
	return self.elapsedTime;
end

function Stopwatch:SetTime(elapsedTime)
	self.elapsedTime = elapsedTime;
	self:ClearTimesCache();
end

function Stopwatch:GetTimeAsString()
	local seconds = self:GetSecondsTimeComponent();
	if seconds < 10 then
		seconds = "0" .. seconds;
	end
	
	local minutes = self:GetMinutesTimeComponent();
	if minutes < 10 then
		minutes = "0" .. minutes;
	end
	
	return self:GetHoursTimeComponent() .. ":" .. minutes .. ":" .. seconds;
end

function Stopwatch:Start()
	self.hasBeenRun = true;
	self.previousTime = time();
end

function Stopwatch:Stop()
	self:Update();
	self.previousTime = nil;
end

function Stopwatch:Reset()
	self.previousTime = nil;
	self.elapsedTime = 0;
	self:ClearTimesCache();
	self.hasBeenRun = false;
end

function Stopwatch:Update()
	if self:IsRunning() then
		local currentTime = time();
		self.elapsedTime = self.elapsedTime + (currentTime - self.previousTime);
		self.previousTime = currentTime;
		
		self:ClearTimesCache();
	end
end

function Stopwatch:HasBeenRun()
	return self.hasBeenRun;
end

function Stopwatch:IsRunning()
	return self.previousTime ~= nil;
end
