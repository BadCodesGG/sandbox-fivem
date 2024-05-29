local eventHandlers = {}
local _working = false
local _state = 0 -- 0 is no pickup | 1 active pickup
local _activeDropoffState = 0 -- 0 not actively working | 1 actively working
local _dropOffBlip = nil
local _dropOffBlipCfg = nil
local _deliveryCounter = nil -- set counter to nil
local _currentCookItem = nil -- unset current cook item
local _gracePeriod = 30 * 1000 -- in ms
local _lastDelivery = GetGameTimer() - _gracePeriod
local _lastCook = GetGameTimer() - _gracePeriod
local _durationThread = false
local _durationTimer = (60 * 1000) * 20
local _durationCheck = 0

AddEventHandler("Businesses:Client:Startup", function()
	-- Setup Zones
	Polyzone.Create:Box("TacoPickup", _tacoPickUp.coords, _tacoPickUp.length, _tacoPickUp.width, _tacoPickUp.options)
	Polyzone.Create:Box("TacoQueue", _tacoQueue.coords, _tacoQueue.length, _tacoQueue.width, _tacoQueue.options)

	Polyzone.Create:Box("TacoShop_DriveThru", vector3(17.11, -1595.12, 29.28), 6.6, 3.8, {
		heading = 50,
		--debugPoly=true,
		minZ = 28.28,
		maxZ = 32.28,
	})

	Targeting.Zones:AddBox(string.format("TacoShop_SelfServe"), "store", vector3(15.38, -1599.99, 29.38), 1.3, 0.6, {
		name = "shop",
		heading = 320,
		--debugPoly=true,
		minZ = 25.78,
		maxZ = 29.78,
	}, {
		{
			icon = "store",
			text = "Shop Taco Ingredients",
			event = "Taco:Client:TacoShop",
		},
	}, 2.0, true)

	-- Setup Pickup
	for k, v in pairs(_tacoConfig.sharedPickup) do
		Targeting.Zones:AddBox(
			string.format("TacoSharedPickup-%s", k),
			"box-open",
			v.coords,
			v.length,
			v.width,
			v.options,
			{
				{
					icon = "box-open",
					text = "Order Pickup",
					event = "Businesses:Client:Pickup",
					data = v.data,
					allowFromVehicle = v.driveThru or false,
				},
			},
			v.driveThru and 5.0 or 2.0,
			true
		)
	end

	-- Setup Event Handlers
	eventHandlers["poly-enter"] = AddEventHandler("Polyzone:Enter", function(id, testedPoint, insideZones, data)
		if id == "TacoPickup" and LocalPlayer.state.loggedIn then
			ShowTacoPickup()
		elseif id == "TacoQueue" and LocalPlayer.state.loggedIn then
			ShowTacoQueue()
		elseif id == "TacoShop_DriveThru" then
			Sounds.Play:Distance(25, "bell.ogg", 0.3)
		end
	end)

	eventHandlers["poly-exit"] = AddEventHandler("Polyzone:Exit", function(id, testedPoint, insideZones, data)
		if id == "TacoPickup" and LocalPlayer.state.loggedIn then
			LocalPlayer.state.TacoPickup = false
			Action:Hide("tacopickup")
		elseif id == "TacoQueue" and LocalPlayer.state.loggedIn then
			LocalPlayer.state.TacoQueue = false
			Action:Hide("tacoqueue")
		end
	end)

	eventHandlers["primary_action"] = AddEventHandler("Keybinds:Client:KeyUp:primary_action", function()
		if
			_state == 0
			and _activeDropoffState == 0
			and LocalPlayer.state.TacoPickup
			and not LocalPlayer.state.doingAction
		then
			if _deliveryCounter > 0 then
				Action:Hide("tacopickup")
				if _lastCook + _gracePeriod > GetGameTimer() then
					Notification:Error(
						string.format(
							"You must wait to swap to deliveries! (%s seconds)",
							math.floor((_lastCook + _gracePeriod - GetGameTimer()) / 1000)
						)
					)
					ShowTacoPickup()
					return
				end
				Callbacks:ServerCallback("Taco:SetState", { state = 1 }, function()
					-- if not LocalPlayer.state.TacoPickup or not LocalPlayer.state.TacoQueue then
					-- 	return
					-- end
					Progress:Progress({
						name = "taco_pickup",
						duration = 2500,
						label = "Picking up delivery.",
						useWhileDead = false,
						canCancel = false,
						ignoreModifier = true,
						disarm = false,
						controlDisables = {
							disableMovement = true,
							disableCarMovement = true,
							disableMouse = false,
							disableCombat = true,
						},
						animation = {
							anim = "handoff",
						},
					}, function(status)
						Callbacks:ServerCallback("Tacos:Pickup", {}, function(s)
							if s then
								Callbacks:ServerCallback("Taco:SetState", { state = 0 }, function()
									FetchDropOffLocation()
									_activeDropoffState = 1
									Action:Hide("tacopickup")
									_lastDelivery = GetGameTimer()
								end)
							end
						end)
					end)
				end)
			else
				Action:Hide("tacopickup")
				ShowTacoPickup()
			end
		elseif _activeDropoffState == 0 and LocalPlayer.state.TacoQueue and LocalPlayer.state.loggedIn then
			if _deliveryCounter < _tacoQueue.maxQueue then
				Action:Hide("tacoqueue")
				if _lastDelivery + _gracePeriod > GetGameTimer() then
					Notification:Error(
						string.format(
							"You must wait to swap to start prepping food! (%s seconds)",
							math.floor((_lastDelivery + _gracePeriod - GetGameTimer()) / 1000)
						)
					)
					ShowTacoQueue()
					return
				end
				if Inventory.Check.Player:HasItem(_tacoFoodItems[_currentCookItem].item, 1) then
					Progress:Progress({
						name = "taco_queue",
						duration = 2500,
						label = string.format("Placing %s in bag.", _tacoFoodItems[_currentCookItem].label),
						useWhileDead = false,
						canCancel = false,
						ignoreModifier = true,
						disarm = false,
						controlDisables = {
							disableMovement = true,
							disableCarMovement = true,
							disableMouse = false,
							disableCombat = true,
						},
						animation = {
							anim = "handoff",
						},
					}, function(status)
						Callbacks:ServerCallback(
							"Tacos:AddToQueue",
							{ item = _tacoFoodItems[_currentCookItem].item },
							function(s)
								if s then
									GetNewQueueItem()
									_lastCook = GetGameTimer()
								else
									Notification:Error("You do not have the proper item to bag.")
									ShowTacoQueue()
								end
							end
						)
					end)
				else
					Notification:Error("You do not have the proper item to bag.")
					ShowTacoQueue()
				end
			else
				Notification:Error("The queue is full.")
				Action:Hide("tacoqueue")
				ShowTacoQueue()
			end
		end
	end)
end)

RegisterNetEvent("Taco:SetQueue", function(data)
	_deliveryCounter = data.counter
	_currentCookItem = data.item
	if LocalPlayer.state.TacoQueue then
		ShowTacoQueue()
	end
	if LocalPlayer.state.TacoPickup then
		ShowTacoPickup()
	end
end)

RegisterNetEvent("Taco:PickupState", function(data)
	_state = data.state
end)

function GetNewQueueItem()
	Callbacks:ServerCallback("Taco:GetNewQueueItem", {}, function() end)
end

function ShowTacoPickup()
	if _activeDropoffState == 0 and _deliveryCounter ~= nil then
		LocalPlayer.state.TacoPickup = true
		if _deliveryCounter > 0 then
			Action:Show("tacopickup", "{keybind}primary_action{/keybind} Grab Delivery")
		else
			Action:Show("tacopickup", "No deliveries available.")
		end
	end
end

function ShowTacoQueue()
	if _activeDropoffState == 0 and _deliveryCounter ~= nil then
		if _deliveryCounter >= _tacoQueue.maxQueue then
			Action:Show("tacoqueue", "We require food to be delivered")
		else
			Action:Show(
				"tacoqueue",
				string.format(
					"{keybind}primary_action{/keybind} We require a %s to be delivered.",
					_tacoFoodItems[_currentCookItem].label
				)
			)
			LocalPlayer.state.TacoQueue = true
		end
	end
end

function FetchDropOffLocation()
	local _randomDropoff = math.random(#_tacoDropOffs)
	_dropOffBlipCfg = _tacoConfig.dropOffInfo

	if _tacoDropOffs[_randomDropoff] then
		local _dropOffCoords = _tacoDropOffs[_randomDropoff].coords
		local _gameTimer = GetGameTimer()
		_dropOffBlipCfg.coords = _dropOffCoords
		_dropOffBlipCfg.id = string.format("taco_dropoff_blip_%s", _gameTimer)
		_dropOffBlipCfg.zoneId = string.format("TacoDropOffZone-%s", _gameTimer)
		_dropOffBlip = Blips:Add(
			_dropOffBlipCfg.id,
			_dropOffBlipCfg.name,
			vector3(_dropOffBlipCfg.coords.x, _dropOffBlipCfg.coords.y, _dropOffBlipCfg.coords.z),
			_dropOffBlipCfg.sprite,
			_dropOffBlipCfg.colour,
			_dropOffBlipCfg.scale
		)

		if not _durationThread then
			_durationThread = true
			_durationCheck = _durationTimer
			Citizen.CreateThread(function()
				while _activeDropoffState == 1 and _durationCheck > 0 do
					_durationCheck = _durationCheck - 5
					DrawMarker(
						1,
						_dropOffBlipCfg.coords.x,
						_dropOffBlipCfg.coords.y,
						_dropOffBlipCfg.coords.z - 1.0,
						0,
						0,
						0,
						0,
						0,
						0,
						0.5,
						0.5,
						1.0,
						250,
						250,
						250,
						250,
						false,
						false,
						2,
						false,
						false,
						false,
						false
					)
					if _durationCheck <= 0 then
						_durationCheck = 0
						Notification:Error("You failed to deliver the order in time.")
						RunCleanUp()
						return
					end
					Citizen.Wait(5)
				end
			end)
		end

		Targeting.Zones:AddBox(
			_dropOffBlipCfg.zoneId,
			"box-open-full",
			_tacoDropOffs[_randomDropoff].coords,
			_tacoDropOffs[_randomDropoff].length,
			_tacoDropOffs[_randomDropoff].width,
			_tacoDropOffs[_randomDropoff].options,
			{
				{
					icon = "box",
					text = "Deliver Order",
					event = "Tacos:DeliverOrder",
					data = { blipConfig = _dropOffBlipCfg },
				},
			},
			3.0,
			true
		)

		Targeting.Zones:Refresh()
	end
end

AddEventHandler("Taco:Client:TacoShop", function()
	Inventory.Shop:Open("taco-shop-self")
end)

AddEventHandler("Tacos:DeliverOrder", function(_, data)
	Progress:Progress({
		name = "taco_dropoff",
		duration = 3000,
		label = "Dropping off delivery.",
		useWhileDead = false,
		canCancel = false,
		ignoreModifier = true,
		disarm = false,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			anim = "pickfromground",
		},
	}, function(status)
		Callbacks:ServerCallback("Tacos:Dropoff", {}, function(s)
			if s then
				Blips:Remove(data.blipConfig.id)
				_activeDropoffState = 0
				_dropOffBlipCfg = nil
				_dropOffBlip = nil
				_durationThread = false
				_durationCheck = _durationTimer
				Targeting.Zones:RemoveZone(data.blipConfig.zoneId)
				Targeting.Zones:Refresh()
			end
		end)
	end)
end)

RegisterNetEvent("Characters:Client:Logout", function()
	RunCleanUp()
end)

function RunCleanUp()
	LocalPlayer.state.TacoQueue = false
	LocalPlayer.state.TacoPickup = false
	if _dropOffBlipCfg ~= nil then
		Blips:Remove(_dropOffBlipCfg.id)
		Targeting.Zones:RemoveZone(_dropOffBlipCfg.zoneId)
	end
	_activeDropoffState = 0
	_dropOffBlipCfg = nil
	_dropOffBlip = nil
	_durationThread = false
	_durationCheck = _durationTimer
end
