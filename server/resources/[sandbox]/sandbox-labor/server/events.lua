local _houseLocs = {
	{
		coords = vector3(850.425, -2504.266, 39.686),
		heading = 88.629,
	},
	{
		coords = vector3(998.948, -501.274, 31.411),
		heading = 352.765,
	},
}

local rando = _houseLocs[math.random(#_houseLocs)]
local _locations = {
	houseRobbery = rando,
	oxy = _oxyStarts[tostring(os.date("%w"))],
	corner = {
		coords = vector3(-1296.270, -741.837, 32.152),
		heading = 35.615,
	},
}

AddEventHandler("onResourceStart", function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.Wait(20)
		TriggerClientEvent("Labor:Client:GetLocs", -1, _locations)
	end
end)

AddEventHandler("Queue:Server:SessionActive", function(source, data)
	TriggerClientEvent("Labor:Client:GetLocs", source, _locations)
end)
