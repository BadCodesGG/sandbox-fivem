RegisterServerEvent("VOIP:Server:Gag:SetPlayerState", function(state)
	local src = source
	TriggerClientEvent("VOIP:Client:Gag:SetPlayerState", -1, src, state)
end)
