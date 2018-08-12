local _, core = ...;

---------------------
-- SAVED VARIABLES --
---------------------

SAVED_DATA = {};
core.Data.SAVED_DATA = SAVED_DATA;

----------------------
-- UPDATE PROCEDURE --
----------------------

function Update()
	core.Interface:Update();
end

--------------------------------
-- WINDOW/ADDON EVENT HOOKUPS --
--------------------------------

local updateInterval = 0.2;
local timeSinceLastUpdate = 0;

core.Interface:GetFrame():SetScript("OnUpdate",
	function(self, elapsed)
		timeSinceLastUpdate = timeSinceLastUpdate + elapsed;
		if timeSinceLastUpdate >= updateInterval then
			timeSinceLastUpdate = 0;
			Update();
		end
	end
);

core.Interface:GetFrame():RegisterEvent("ZONE_CHANGED_NEW_AREA");
core.Interface:GetFrame():SetScript("OnEvent",
	function (self, event, ...)
		core.Interface:CheckInstanceEntry();
	end
);

--------------------
-- SLASH COMMANDS --
--------------------

SLASH_FRAMESTK1 = "/ormm";
SlashCmdList.FRAMESTK = function()
	core.Interface:Toggle();
end

----------------------------
-- MAIN STARTUP PROCEDURE --
----------------------------

local frame = core.Interface:GetFrame();
