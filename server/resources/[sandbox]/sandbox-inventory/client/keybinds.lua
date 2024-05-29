function RegisterKeyBinds()
	Keybinds:Add("open_hotbar", "", "keyboard", "Inventory - Show Hotbar", function()
		if not _startup or _reloading or _loading then
			return
		end
		OpenHotBar()
	end)

	Keybinds:Add("open_inventory", "TAB", "keyboard", "Inventory - Open Inventory", function()
		if not _startup or _reloading or _loading then
			return
		end
		OpenInventory()
	end)

	function HotBarAction(key)
		Keybinds:Add(
			"hotbar_action_" .. tostring(key),
			key,
			"keyboard",
			"Inventory - Hotbar Action " .. tostring(key),
			function()
				if not _startup then
					return
				end
				Inventory.Used:HotKey(key)
			end
		)
	end

	for i = 1, 5 do
		HotBarAction(i)
	end
end
