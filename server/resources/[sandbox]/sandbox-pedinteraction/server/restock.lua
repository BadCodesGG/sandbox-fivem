local threading = false
function StartRestockThread()
	if threading then
		return
	end
	thread = true
	Citizen.CreateThread(function()
		Citizen.Wait(300000)
		while true do
			for k, v in pairs(_created) do
				if v.restock ~= false and os.time() > v.restockTime then
					for _, v2 in ipairs(v.items) do
						v2.qty = v2.oQty
					end

					v.restockTime = os.time() + v.restock
					Logger:Info("Vendor", string.format("Vendor ^3%s^7 Restocked", k))
				end
			end

			Citizen.Wait(30000)
		end
	end)
end
