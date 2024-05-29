local _ghostedObjects = {
	[1043035044] = true,
	[-1063472968] = true,
	[-655644382] = true,
	[862871082] = true,
	[267702115] = true,
	[729253480] = true,
	[865627822] = true,
	[1821241621] = true,
	[431612653] = true,
	[589548997] = true,
	[1327054116] = true,
	[-1114695146] = true,
	[1021745343] = true,
	[-1684988513] = true,
	[-1529663453] = true,
	[681787797] = true,
}

local _characterLoaded = true
-- RegisterNetEvent("Characters:Client:Spawn")
-- AddEventHandler("Characters:Client:Spawn", function()
-- 	_characterLoaded = true

-- 	Citizen.CreateThread(function()
-- 		while _characterLoaded do
-- 			for obj in EnumerateObjects() do
-- 				if _ghostedObjects[GetEntityModel(obj)] then
-- 					if not HasObjectBeenBroken(obj) then
-- 						SetEntityCollision(obj, false, false)
-- 					end
-- 				end
-- 			end
-- 			Citizen.Wait(500)
-- 		end
-- 	end)
-- end)

-- RegisterNetEvent("Characters:Client:Logout")
-- AddEventHandler("Characters:Client:Logout", function()
-- 	_characterLoaded = false
-- end)