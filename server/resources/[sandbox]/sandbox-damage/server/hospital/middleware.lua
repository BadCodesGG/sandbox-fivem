function HospitalMiddleware()
	
end

AddEventHandler("Characters:Server:PlayerLoggedOut", function(source, cData)
	if _inBedChar[cData.ID] ~= nil then
		_inBed[_inBedChar[cData.ID]] = nil
		_inBedChar[cData.ID] = nil
	end
end)

AddEventHandler("Characters:Server:PlayerDropped", function(source, cData)
	if cData ~= nil then
		if _inBedChar[cData.ID] ~= nil then
			_inBed[_inBedChar[cData.ID]] = nil
			_inBedChar[cData.ID] = nil
		end
	end
end)