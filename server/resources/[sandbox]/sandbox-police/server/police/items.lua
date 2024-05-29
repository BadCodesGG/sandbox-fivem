function PoliceItems()
    Inventory.Items:RegisterUse("det_cord", "PDItems", function(source, slot, itemData)
        local pState = Player(source).state
        if pState.onDuty == "police" then
            Callbacks:ClientCallback(source, "Police:DoDetCord", {}, function(s, doorId)
                if s and Inventory.Items:RemoveSlot(slot.Owner, slot.Name, 1, slot.Slot, 1) then
                    Doors:SetLock(doorId, false)
                    Doors:DisableDoor(doorId, 60 * 60)
                end
            end)
        end
    end)
end