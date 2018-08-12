local _, core = ...;

core.Game = {};
local Game = core.Game;

function Game:GetMoney()
	return GetMoney();
end

function Game:GetCharacterInfo()
	local specId, specName, specDesc, specIcon, specBg, specRole = GetSpecializationInfo(GetSpecialization());
	local iLOverall, iLEquipped = GetAverageItemLevel();
	return {
		realm = GetRealmName(),
		name = UnitName("Player"),
		level = UnitLevel("Player"),
		itemLevel = math.floor(iLEquipped);
		race = UnitRace("Player"),
		class = UnitClass("Player"),
		spec = specName
	};
end

function Game:GetInstanceInfo()
	local iName, iType, iDiffId, iDiffName, iMaxPlayers, iDynamicDiff, iIsDynamic, iMapId, iGroupSize = GetInstanceInfo();
	return {
		inInstance = iDiffName ~= nil and iDiffName ~= "",
		name = iName,
		diff = iDiffName,
		size = iMaxPlayers
	}
end
