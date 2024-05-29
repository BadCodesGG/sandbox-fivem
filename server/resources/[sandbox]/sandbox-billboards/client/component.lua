AddEventHandler("Billboards:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Logger = exports["sandbox-base"]:FetchComponent("Logger")
	Fetch = exports["sandbox-base"]:FetchComponent("Fetch")
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	Game = exports["sandbox-base"]:FetchComponent("Game")
	Targeting = exports["sandbox-base"]:FetchComponent("Targeting")
	Utils = exports["sandbox-base"]:FetchComponent("Utils")
	Animations = exports["sandbox-base"]:FetchComponent("Animations")
	Notification = exports["sandbox-base"]:FetchComponent("Notification")
	Polyzone = exports["sandbox-base"]:FetchComponent("Polyzone")
	Jobs = exports["sandbox-base"]:FetchComponent("Jobs")
	Weapons = exports["sandbox-base"]:FetchComponent("Weapons")
	Progress = exports["sandbox-base"]:FetchComponent("Progress")
	Vehicles = exports["sandbox-base"]:FetchComponent("Vehicles")
	Targeting = exports["sandbox-base"]:FetchComponent("Targeting")
	ListMenu = exports["sandbox-base"]:FetchComponent("ListMenu")
	Action = exports["sandbox-base"]:FetchComponent("Action")
	Sounds = exports["sandbox-base"]:FetchComponent("Sounds")
	PedInteraction = exports["sandbox-base"]:FetchComponent("PedInteraction")
	Blips = exports["sandbox-base"]:FetchComponent("Blips")
	Keybinds = exports["sandbox-base"]:FetchComponent("Keybinds")
	Minigame = exports["sandbox-base"]:FetchComponent("Minigame")
	Input = exports["sandbox-base"]:FetchComponent("Input")
	Interaction = exports["sandbox-base"]:FetchComponent("Interaction")
	Inventory = exports["sandbox-base"]:FetchComponent("Inventory")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Billboards", {
		"Logger",
		"Fetch",
		"Callbacks",
		"Game",
		"Menu",
		"Targeting",
		"Notification",
		"Utils",
		"Animations",
		"Polyzone",
		"Jobs",
		"Weapons",
		"Progress",
		"Vehicles",
		"Targeting",
		"ListMenu",
		"Action",
		"Sounds",
		"PedInteraction",
		"Blips",
		"Keybinds",
		"Minigame",
		"Input",
		"Interaction",
		"Inventory",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()

		-- print('testing biatch')
		-- local dui = CreateBillboardDUI('https://i.imgur.com/Zlf40QZ.png', 1024, 512)
		-- AddReplaceTexture('ch2_03b_cg2_03b_bb', 'ch2_03b_bb_lowdown', dui.dictionary, dui.texture)

		-- Citizen.Wait(10000)

		-- print(dui.id)

		-- ReleaseBillboardDUI(dui.id)
		-- RemoveReplaceTexture('ch2_03b_cg2_03b_bb', 'ch2_03b_bb_lowdown')

		StartUp()
	end)
end)

local started = false
local _billboardDUIs = {}

function StartUp()
	if started then
		return
	end

	started = true

	for k, v in pairs(_billboardConfig) do
		v.url = GlobalState[string.format("Billboards:%s", k)]
	end
end

AddEventHandler("Characters:Client:Spawn", function()
	Citizen.CreateThread(function()
		Citizen.Wait(5000)

		while LocalPlayer.state.loggedIn do
			for k, v in pairs(_billboardConfig) do
				local dist = #(GetEntityCoords(LocalPlayer.state.ped) - v.coords)
				if dist <= v.range then
					if not _billboardDUIs[k] and v.url then
						local createdDui = CreateBillboardDUI(v.url, v.width, v.height)
						AddReplaceTexture(
							v.originalDictionary,
							v.originalTexture,
							createdDui.dictionary,
							createdDui.texture
						)

						_billboardDUIs[k] = createdDui
					end
				elseif _billboardDUIs[k] then
					ReleaseBillboardDUI(_billboardDUIs[k].id)
					RemoveReplaceTexture(v.originalDictionary, v.originalTexture)
					_billboardDUIs[k] = nil
				end
			end
			Citizen.Wait(1500)
		end
	end)
end)

RegisterNetEvent("Characters:Client:Logout")
AddEventHandler("Characters:Client:Logout", function()
	for k, v in pairs(_billboardConfig) do
		if _billboardDUIs[k] then
			ReleaseBillboardDUI(_billboardDUIs[k].id)
			RemoveReplaceTexture(v.originalDictionary, v.originalTexture)
			_billboardDUIs[k] = nil
		end
	end
end)

RegisterNetEvent("Billboards:Client:UpdateBoardURL", function(id, url)
	if not _billboardConfig[id] then
		return
	end

	if _billboardDUIs[id] then
		if url then
			UpdateBillboardDUI(_billboardDUIs[id].id, url)
			AddReplaceTexture(
				_billboardConfig[id].originalDictionary,
				_billboardConfig[id].originalTexture,
				_billboardDUIs[id].dictionary,
				_billboardDUIs[id].texture
			)
		else
			ReleaseBillboardDUI(_billboardDUIs[id].id)
			RemoveReplaceTexture(_billboardConfig[id].originalDictionary, _billboardConfig[id].originalTexture)
			_billboardDUIs[id] = nil
		end
	end

	_billboardConfig[id].url = url
end)
