RegisterNetEvent("Phone:Client:SetData", function(type, data, options)
	while Phone == nil do
		Citizen.Wait(10)
	end
	Phone.Data:Set(type, data)
end)

RegisterNetEvent("Phone:Client:SetDataMulti", function(data)
	while Phone == nil do
		Citizen.Wait(10)
	end

	for k, v in ipairs(data) do
		Phone.Data:Set(v.type, v.data)
	end
end)

RegisterNetEvent("Phone:Client:AddData", function(type, data, id)
	while Phone == nil do
		Citizen.Wait(10)
	end

	Phone.Data:Add(type, data, id)
end)

RegisterNetEvent("Phone:Client:UpdateData", function(type, id, data)
	while Phone == nil do
		Citizen.Wait(10)
	end

	Phone.Data:Update(type, id, data)
end)

RegisterNetEvent("Phone:Client:RemoveData", function(type, id)
	while Phone == nil do
		Citizen.Wait(10)
	end

	Phone.Data:Remove(type, id)
end)

RegisterNetEvent("Phone:Client:ResetData", function()
	while Phone == nil do
		Citizen.Wait(10)
	end

	Phone.Data:Reset()
end)

RegisterNetEvent("Characters:Client:Logout", function()
	SendNUIMessage({ type = "PHONE_NOT_VISIBLE" })
	Phone.Data:Reset()
	Phone.Notification:Reset()
	Phone:ResetRoute()
end)
