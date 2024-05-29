RegisterServerEvent('Inventory:Server:Grapple:CreateRope', function(grappleid, dest)
    TriggerClientEvent('Inventory:Client:Grapple:CreateRope', -1, source, grappleid, dest)
end)

RegisterServerEvent('Inventory:Server:Grapple:DestroyRope', function(grappleid)
    TriggerClientEvent(string.format("Inventory:Client:Grapple:DestroyRope:%s", grappleid), -1)
end)