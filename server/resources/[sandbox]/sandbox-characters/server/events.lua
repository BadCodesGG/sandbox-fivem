RegisterServerEvent('Characters:Server:Spawning', function()
    Middleware:TriggerEvent("Characters:Spawning", source)
end)

RegisterServerEvent('Ped:LeaveCreator', function()
    local char = Fetch:CharacterSource(source)
    if char ~= nil then
        if char:GetData("New") then
            char:SetData("New", false)
        end
    end
end)