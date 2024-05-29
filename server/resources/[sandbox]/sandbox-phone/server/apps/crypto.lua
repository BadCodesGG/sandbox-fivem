AddEventHandler("Crypto:Server:Startup", function()
	while Crypto == nil do
		Citizen.Wait(10)
	end

	Crypto.Coin:Create("Vroom", "VRM", 100, false, false)
	Crypto.Coin:Create("Mald", "MALD", 250, true, 190)

    -- Compatability since we're renaming MALD
	Middleware:Add("Characters:Spawning", function(source)
		local char = Fetch:CharacterSource(source)
		local myCrypto = char:GetData("Crypto")

		if myCrypto.PLEB ~= nil then
			myCrypto.MALD = myCrypto.PLEB
			myCrypto.PLEB= nil	
			char:SetData("Crypto", myCrypto)
		end
	end, 1)
end)

AddEventHandler("Phone:Server:RegisterCallbacks", function()
	Callbacks:RegisterServerCallback("Phone:Crypto:Buy", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char then
			return cb(Crypto.Exchange:Buy(data.Short, char:GetData("SID"), data.Quantity))
		end
		cb(false)
	end)

	Callbacks:RegisterServerCallback("Phone:Crypto:Sell", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char then
			return cb(Crypto.Exchange:Sell(data.Short, char:GetData("SID"), data.Quantity))
		end
		cb(false)
	end)

	Callbacks:RegisterServerCallback("Phone:Crypto:Transfer", function(source, data, cb)
		local char = Fetch:CharacterSource(source)
		if char and char:GetData("SID") ~= data.Target then
			return cb(Crypto.Exchange:Transfer(data.Short, char:GetData("SID"), data.Target, data.Quantity))
		end
		cb(false)
	end)
end)
