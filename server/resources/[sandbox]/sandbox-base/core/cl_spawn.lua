COMPONENTS.Spawn = COMPONENTS.Spawn or {
	_required = { "InitCamera", "Init" },
	_name = "base",
}

COMPONENTS.Spawn.SpawnPoint = {
	x = -1044.84,
	y = -2749.85,
	z = 21.36,
	h = 0,
}

function COMPONENTS.Spawn.InitCamera(self)
	return
end

function COMPONENTS.Spawn.Init(self)
	DoScreenFadeOut(500)
	TriggerEvent("PAC:IgnoreNextNoclipFlag")
	SetEntityCoords(PlayerPedId(), self.SpawnPoint.x, self.SpawnPoint.y, self.SpawnPoint.z)
	SetEntityHeading(PlayerPedId(), self.SpawnPoint.h)

	ShutdownLoadingScreenNui()
	ShutdownLoadingScreen()

	DoScreenFadeIn(500)

	while not IsScreenFadingIn() do
		Citizen.Wait(10)
	end
end

-- Citizen.CreateThread(function()
-- 	exports["spawnmanager"]:setAutoSpawn(false)
-- end)

local firstLoad = true
AddEventHandler("Core:Shared:Ready", function()
	if firstLoad then
		COMPONENTS.Spawn:InitCamera()
		COMPONENTS.Spawn:Init()
		firstLoad = false
	end
end)
