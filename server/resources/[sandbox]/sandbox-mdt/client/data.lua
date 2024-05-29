RegisterNetEvent("MDT:Client:SetData")
AddEventHandler("MDT:Client:SetData", function(type, data, options)
	while MDT == nil do
		Citizen.Wait(1)
	end

	MDT.Data:Set(type, data)
end)

RegisterNetEvent("MDT:Client:SetMultipleData", function(data)
	if data then
		for k, v in pairs(data) do
			MDT.Data:Set(k, v)
		end
	end
end)

RegisterNetEvent("MDT:Client:AddData")
AddEventHandler("MDT:Client:AddData", function(type, data, id)
	while MDT == nil do
		Citizen.Wait(1)
	end
	
	MDT.Data:Add(type, data, id)
end)

RegisterNetEvent("MDT:Client:UpdateData")
AddEventHandler("MDT:Client:UpdateData", function(type, id, data)
	while MDT == nil do
		Citizen.Wait(1)
	end
	
	MDT.Data:Update(type, id, data)
end)

RegisterNetEvent("MDT:Client:RemoveData")
AddEventHandler("MDT:Client:RemoveData", function(type, id)
	while MDT == nil do
		Citizen.Wait(1)
	end
	
	MDT.Data:Remove(type, id)
end)

RegisterNetEvent("MDT:Client:ResetData")
AddEventHandler("MDT:Client:ResetData", function()
	while MDT == nil do
		Citizen.Wait(1)
	end
	
	Phone.Data:Reset()
end)

RegisterNetEvent("Characters:Client:Logout")
AddEventHandler("Characters:Client:Logout", function()
	while MDT == nil do
		Citizen.Wait(1)
	end
	
	MDT.Data:Reset()
end)
