-- local Targets = {}
local xSound = exports.xsound
local Props = {}

AddEventHandler("DJ:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	Targeting = exports["sandbox-base"]:FetchComponent("Targeting")
	Menu = exports["sandbox-base"]:FetchComponent("Menu")
	Notification = exports["sandbox-base"]:FetchComponent("Notification")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("DJ", {
		"Callbacks",
		"Targeting",
		"Menu",
		"Notification",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()
		RegisterDjZones()
	end)
end)

function RegisterDjZones()
	for k,v in ipairs(Props) do
		DeleteObject(v)
	end

	Props = {}

	for k, v in ipairs(Config.Locations) do
		if v.enableBooth then
			Targeting.Zones:AddBox("dj-booth" .. k, "compact-disc", v.coords, 1.0, 1.0, {
				name = "djbooth" .. k,
				heading = 0,
				--debugPoly=true,
				minZ = v.coords.z - 1.5,
				maxZ = v.coords.z + 1.5,
			}, {
				{
					icon = "compact-disc",
					text = "Open Stereo",
					event = "sandbox-dj:client:playMusic",
					data = { zone = k },
				},
			})

			if v.prop then
				RequestModel(v.prop)
				while not HasModelLoaded(v.prop) do
					Citizen.Wait(1)
				end
				local obj = CreateObject(v.prop, v.coords, false, false, false)
				local heading = v.heading or math.random(1, 359) + 0.0
				SetEntityHeading(obj, heading)
				FreezeEntityPosition(obj, true)

				table.insert(Props, obj)
			end
		end
	end
end

RegisterNetEvent("sandbox-dj:client:playMusic", function(data)
	local booth = ""
	local boothId = 0

	for k, v in pairs(Config.Locations) do
		if #(GetEntityCoords(PlayerPedId()) - v["coords"]) <= v["radius"] then
			-- if v["job"] then booth = v["job"]..k elseif v["gang"] then booth = v["gang"]..k end
			booth = "public" .. k
			boothId = k
		end
	end

	local song = {
		playing = "",
		duration = "",
		timeStamp = "",
		duration = "",
		url = "",
		icon = "",
		header = "",
		txt = "🔇 No Song Playing",
		volume = 0,
	}
	local p = promise.new()
	Callbacks:ServerCallback("sandbox-dj:server:songInfo", {}, function(cb)
		p:resolve(cb)
	end)
	previousSongs = Citizen.Await(p)

	-- Grab song info and build table
	if xSound:soundExists(booth) then
		song = {
			playing = xSound:isPlaying(booth),
			timeStamp = "",
			url = xSound:getLink(booth),
			icon = "https://img.youtube.com/vi/" .. string.sub(xSound:getLink(booth), -11) .. "/mqdefault.jpg",
			header = "",
			txt = xSound:getLink(booth),
			volume = math.ceil(xSound:getVolume(booth) * 100),
		}
		if xSound:isPlaying(booth) then
			song.header = "Currently Playing: "
		end
		if xSound:isPaused(booth) then
			song.header = "Currently Paused: "
		end
		if xSound:getMaxDuration(booth) == 0 then
			song.timeStamp = "🔴 Live"
		end
		if xSound:getMaxDuration(booth) > 0 then
			local timestamp = (xSound:getTimeStamp(booth) * 10)
			local mm = (timestamp // (60 * 10)) % 60.
			local ss = (timestamp // 10) % 60.
			timestamp = string.format("%02d:%02d", mm, ss)
			local duration = (xSound:getMaxDuration(booth) * 10)
			mm = (duration // (60 * 10)) % 60.
			ss = (duration // 10) % 60.
			duration = string.format("%02d:%02d", mm, ss)
			song.timeStamp = "(" .. timestamp .. "/" .. duration .. ")"
			if xSound:isPlaying(booth) then
				song.timeStamp = "🔊 " .. song.timeStamp
			else
				song.timeStamp = "🔇 " .. song.timeStamp
			end
		end
	end

	local djMenu = {}
	local djMenuSub = {}

	djMenu = Menu:Create("djMenuPlayer", string.format("DJ Turntable"), function() end, function()
		djMenu = nil
		djMenuSub = nil
		collectgarbage()
	end)

	djMenu.Add:Text(string.format("Song: %s", song.header), { "pad", "code", "center", "textLarge" })
	djMenu.Add:Text(string.format("Txt: %s", song.txt), { "pad", "code", "center", "textLarge" })
	djMenu.Add:Text(string.format("Time: %s", song.timeStamp), { "pad", "code", "center", "textLarge" })

	djMenu.Add:Text("Play a song", { "pad", "code", "center", "textLarge" })
	djMenu.Add:Input("Youtube URL", {
		disabled = false,
		max = 100,
		current = nil,
	}, function(data)
		local song = data.data.value
		if song == "" or song == nil then
			Notification:Error("Empty text cannot be played dummy.", 2500, "fas fa-volume-off")
			return
		end
		if not string.find(song, "youtu") then
			song = "https://www.youtube.com/watch?v=" .. song
		end
		Callbacks:ServerCallback("sandbox-dj:server:playMusic", {
			song = song,
			zoneNum = boothId,
		}, function(success, zoneNum)
			if success then
				TriggerEvent("sandbox-dj:client:playMusic", { zone = zoneNum })
				Notification:Success("Loading link: " .. song, 2500, "fas fa-pause")
			else
				Notification:Error("Failed to Load Song", 2500, "fas fa-volume-off")
			end
		end)
	end)

	djMenuSub["songhistory"] = Menu:Create("djSongHistoryMenu", "Song History")
	if previousSongs[booth] then
		for _, v in pairs(previousSongs[booth]) do
			djMenuSub["songhistory"].Add:Text(string.format("Song: %s", v), { "pad", "code", "center", "textLarge" })
		end
	end

	djMenuSub["songhistory"].Add:SubMenuBack("Go Back", {})

	djMenu.Add:SubMenu("Song History", djMenuSub["songhistory"], {})

	if xSound:soundExists(booth) then
		if xSound:isPlaying(booth) then
			djMenu.Add:Button("Pause Music", { success = true }, function()
				Callbacks:ServerCallback("sandbox-dj:server:pauseMusic", {
					zoneName = booth,
					zoneNum = boothId,
				}, function(success)
					if success then
						Notification:Success("Paused Music", 2500, "fas fa-pause")
					else
						Notification:Error("Failed to Pause Music", 2500, "fas fa-pause")
					end
				end)
			end)
		elseif xSound:isPaused(booth) then
			djMenu.Add:Button("Resume Music", { success = true }, function()
				Callbacks:ServerCallback("sandbox-dj:server:resumeMusic", {
					zoneName = booth,
					zoneNum = boothId,
				}, function(success)
					if success then
						Notification:Success("Resume Music", 2500, "fas fa-play")
					else
						Notification:Error("Failed to Resume Music", 2500, "fas fa-play")
					end
				end)
			end)
		end
		-- i-_1Os7hVDw
		djMenuSub["changevolume"] = Menu:Create("dj_change_volume", "Change Volume")

		djMenuSub["changevolume"].Add:Slider("Change Volume", {
			current = song.volume,
			min = 0,
			max = 100,
			step = 1,
		}, function(data)
			-- data comes back as type number
			local volume = data.data.value
			if not volume then
				return
			end
			-- Automatically correct from numbers to be numbers xsound understands
			volume = (volume / 100)
			-- Don't let numbers go too high or too low
			if volume <= 0.01 then
				volume = 0.01
			end
			if volume > 1.0 then
				volume = 1.0
			end
			Callbacks:ServerCallback("sandbox-dj:server:changeVolume", {
				volume = volume,
				zoneName = booth,
				zoneNum = boothId,
			}, function(success, zoneNum)
				if success then
					song.volume = volume * 100
					TriggerEvent("sandbox-dj:client:playMusic", { zone = zoneNum })
					Notification:Success(
						string.format("Changed Volume to %s/100", tostring(math.ceil(volume * 100))),
						2500,
						"fas fa-volume-off"
					)
				else
					Notification:Error("Failed to Change Volume", 2500, "fas fa-volume-off")
				end
			end)
		end)

		djMenuSub["changevolume"].Add:SubMenuBack("Go Back", {})
		djMenu.Add:SubMenu("Change Volume", djMenuSub["changevolume"], {})

		djMenu.Add:Button("Stop Music", { success = true }, function()
			Callbacks:ServerCallback("sandbox-dj:server:stopMusic", {
				zoneName = booth,
				zoneNum = boothId,
			}, function(success)
				if success then
					Notification:Success("Stop Music", 2500, "fas fa-stop")
				else
					Notification:Error("Failed to Stop Music", 2500, "fas fa-stop")
				end
			end)
		end)
	end

	djMenu.Add:Button("Close", { success = true }, function()
		djMenu:Close()
	end)

	djMenu:Show()
end)

AddEventHandler('onResourceStop', function(resourceName)
	if resourceName == GetCurrentResourceName() then
		for k,v in ipairs(Props) do
			DeleteObject(v)
		end
	end
end)