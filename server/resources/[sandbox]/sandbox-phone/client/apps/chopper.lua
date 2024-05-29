RegisterNetEvent("Phone:Client:Spawn", function(data)

end)

PHONE.Chopper = {

}

RegisterNUICallback("GetChopperDetails", function(data, cb)
	Callbacks:ServerCallback("Laptop:LSUnderground:GetDetails", {
        phone = true
    }, function(data)
        cb(data)
    end)
end)