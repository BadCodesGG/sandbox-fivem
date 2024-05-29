function RegisterCallbacks()
    Callbacks:RegisterServerCallback('Status:Get', function(source, data, cb)
        local char = Fetch:CharacterSource(source)
        if char ~= nil then
            local s = char:GetData('Status')
            cb(s)
        else
            cb({})
        end
    end)
end