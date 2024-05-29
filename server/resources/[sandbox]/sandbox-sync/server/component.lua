AvailableWeatherTypes = {
	"EXTRASUNNY",
	"CLEAR",
	"SMOG",
	"FOGGY",
	"OVERCAST",
	"CLOUDS",
	"CLEARING",
	"RAIN",
	"THUNDER",
	-- Non Regular Weather Types
	"NEUTRAL",
	"HALLOWEEN",
	"SNOW",
	"BLIZZARD",
	"SNOWLIGHT",
	"XMAS",
}

StartingWeatherTypes = {
	"EXTRASUNNY",
	"CLEAR",
	"OVERCAST",
	"SMOG",
}

AvailableTimeTypes = {
	MORNING = { hour = 8 },
	NOON = { hour = 12 },
	EVENING = { hour = 18, minute = 30 },
	NIGHT = { hour = 23, minute = 30 },
}

local _weather = StartingWeatherTypes[math.random(1, #StartingWeatherTypes)]
local _weatherFrozen = false
local _timeFrozen = false

local _isWinterOnly = false
local snowCd = false
local hasBlizzard = false

local _blackoutState = false

local _timeHour = math.random(5, 9)
local _timeMinute = 0
local _isNight = false

AddEventHandler("Sync:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Logger = exports["sandbox-base"]:FetchComponent("Logger")
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	Chat = exports["sandbox-base"]:FetchComponent("Chat")
	Sync = exports["sandbox-base"]:FetchComponent("Sync")
	RegisterChatCommands()
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Sync", {
		"Callbacks",
		"Fetch",
		"Utils",
		"Chat",
		"Status",
		"Inventory",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		RetrieveComponents()

		StartThreads()
	end)
end)

local started = false
function StartThreads()
	if started then
		return
	end
	started = true

	_isWinterOnly = GetConvar("winter_only", "false") == "true"

	if not GlobalState.IsProduction then
		_weather = "EXTRASUNNY"
		_weatherFrozen = true
		Logger:Trace("Sync", "Freezing Weather (Non Production Server)")
	end

	GlobalState["Sync:Time"] = {
		hour = _timeHour,
		minute = _timeMinute,
	}

	GlobalState["Sync:Winter"] = _isWinterOnly
	GlobalState["Sync:Blackout"] = _blackoutState
	GlobalState["Sync:Weather"] = _weather
	GlobalState["Sync:IsNight"] = _isNight

	Logger:Trace(
		"Sync",
		string.format(
			"Started Time and Weather Sync Threads With Weather: %s and Time: %02d:%02d",
			_weather,
			_timeHour,
			_timeMinute
		),
		{ console = true }
	)

	Citizen.CreateThread(function()
		while true do
			local waitTime = math.random(15, 30)
			Citizen.Wait(waitTime * 60000)
			if not _weatherFrozen then
				Sync:NextWeatherStage()
			end
		end
	end)

	Citizen.CreateThread(function()
		while true do
			if not _timeFrozen then
				_timeMinute = _timeMinute + 1
				if _timeMinute >= 60 then
					_timeMinute = 0

					_timeHour = _timeHour + 1
					if _timeHour >= 23 then
						_timeHour = 0
					end

					if _timeHour >= 21 or _timeHour <= 6 then
						_isNight = true
					else
						_isNight = false
					end

					GlobalState["Sync:IsNight"] = _isNight

					TriggerEvent("Sync:Server:HourChange", _timeHour, _timeMinute, _isNight)
				end

				--print(string.format('Time: %02d:%02d', _timeHour, _timeMinute))
			end
			Citizen.Wait(8500) -- At this rate of 8500, an IN GAME DAY takes 3.4 hours to complete (mult by 0.0004 to calculate)
		end
	end)

	Citizen.CreateThread(function()
		while true do
			GlobalState["Sync:Time"] = {
				hour = _timeHour,
				minute = _timeMinute,
			}
			Citizen.Wait(20000)
		end
	end)
end

SYNC = {
	Get = {
		TimeFrozen = function(self)
			return _timeFrozen
		end,
		WeatherFrozen = function(self)
			return _weatherFrozen
		end,
		Blackout = function(self)
			return _blackoutState
		end,
		Night = function(self)
			return _isNight
		end,
		Time = function(self)
			return {
				hour = _timeHour,
				minute = _timeMinute,
			}
		end,
		Weather = function(self)
			return _weather
		end,
		Winter = function(self)
			return _isWinterOnly
		end,
	},
	FreezeWeather = function(self, state)
		if state == nil then
			state = not _weatherFrozen
		end

		_weatherFrozen = state

		Logger:Info(
			"Sync",
			"Weather Was: ^5" .. (_weatherFrozen and "Frozen" or "Unfrozen") .. "^7",
			{ console = true }
		)
	end,
	FreezeTime = function(self, state)
		if state == nil then
			state = not _timeFrozen
		end

		_timeFrozen = state

		Logger:Info("Sync", "Time Was: ^5" .. (_timeFrozen and "Frozen" or "Unfrozen") .. "^7", { console = true })
	end,
	Set = {
		Winter = function(self, state)
			if state == nil then
				state = not _isWinterOnly
			end

			_isWinterOnly = state
			GlobalState["Sync:Winter"] = state
			Sync:NextWeatherStage()
		end,
		Blackout = function(self, state)
			if state == nil then
				state = not _blackoutState
			end

			_blackoutState = state
			GlobalState["Sync:Blackout"] = _blackoutState

			TriggerEvent("Sync:Server:BlackoutChange", _blackoutState)

			Logger:Info(
				"Sync",
				"Blackout Was: ^5" .. (_blackoutState and "Enabled" or "Disabled") .. "^7",
				{ console = true }
			)
		end,
		Weather = function(self, wtype)
			_weather = string.upper(wtype)
			GlobalState["Sync:Weather"] = _weather
			TriggerEvent("Sync:Server:WeatherChange", _weather)
			Logger:Info("Sync", "Weather Manually Updated: ^5" .. _weather .. "^7", { console = true })
		end,
		TimeType = function(self, type)
			local timeTypeData = AvailableTimeTypes[type:upper()]
			if timeTypeData and timeTypeData.hour then
				Sync.Set:Time(timeTypeData.hour, timeTypeData.minute)
			end
		end,
		Time = function(self, hour, minute)
			if not minute or minute < 0 or minute > 59 then
				minute = 0
			end

			if not hour or hour < 0 or hour > 23 then
				hour = 12
			end

			_timeHour = hour
			_timeMinute = minute

			if _timeHour >= 21 or _timeHour <= 6 then
				_isNight = true
			else
				_isNight = false
			end

			GlobalState["Sync:IsNight"] = _isNight

			TriggerEvent("Sync:Server:HourChange", _timeHour, _timeMinute, _isNight)

			GlobalState["Sync:Time"] = {
				hour = _timeHour,
				minute = _timeMinute,
			}

			Logger:Info(
				"Sync",
				"Time Manually Set: ^5" .. string.format("%02d:%02d", _timeHour, _timeMinute) .. "^7",
				{ console = true }
			)
		end,
	},
	NextWeatherStage = function(self)
		-- Check for special exact dates
		local CurrentDate = os.date("*t", os.time())
		if CurrentDate.month == 10 and CurrentDate.day == 31 and CurrentDate.hour >= 18 then
			_weather = "HALLOWEEN"
		elseif CurrentDate.month == 12 and CurrentDate.day == 25 then
			_weather = "XMAS"
		elseif _isWinterOnly then
			if _weather == "CLEARING" then
				_weather = "SNOWLIGHT"
			elseif _weather == "SNOWLIGHT" then
				local newWeather = math.random(1, 10)
				if newWeather <= 3 then
					_weather = "XMAS"
				else
					_weather = "CLEAR"
				end
			elseif _weather == "XMAS" then
				_weather = "CLEARING"
			elseif _weather == "BLIZZARD" then
				_weather = "XMAS"
			else
				local newWeather = math.random(4, 20)
				if newWeather == 13 then
					_weather = "CLEARING"
				else
					_weather = "XMAS"
				end
			end
		else
			local snow = math.random(1, 100)
			local shouldSnow = CurrentDate.month == 11
				and (snow <= math.ceil(CurrentDate.day / 2))
				and (not snowCd or os.time() >= snowCd)
			if shouldSnow and _weather ~= "SNOWLIGHT" then
				_weather = "SNOWLIGHT"
				snowCd = os.time() + 60 * 60 * 6
			elseif _weather == "CLEAR" or _weather == "CLOUDS" or _weather == "SNOWLIGHT" then
				local newWeather = math.random(4, 20)
				if newWeather == 13 then
					_weather = "CLEARING"
				else
					_weather = "OVERCAST"
				end
			elseif _weather == "EXTRASUNNY" then
				local newWeather = math.random(1, 5)
				if newWeather <= 2 then
					_weather = "CLOUDS"
				else
					_weather = "SMOG"
				end
			elseif _weather == "CLEARING" or _weather == "OVERCAST" then
				local newWeather = math.random(1, 15)
				if newWeather >= 1 and newWeather <= 3 then
					_weather = "SMOG"
				elseif newWeather >= 4 and newWeather <= 6 then
					_weather = "CLEAR"
				elseif newWeather == 7 then
					_weather = "CLOUDS"
				elseif newWeather == 8 then
					if _weather == "CLEARING" then
						_weather = "FOGGY"
					else
						_weather = "RAIN"
					end
				elseif newWeather == 9 then
					_weather = "FOGGY"
				else
					_weather = "EXTRASUNNY"
				end
			elseif _weather == "THUNDER" or _weather == "RAIN" then
				_weather = "CLEARING"
			elseif _weather == "SMOG" or _weather == "FOGGY" then
				_weather = "CLEAR"
			end
		end

		GlobalState["Sync:Weather"] = _weather
		TriggerEvent("Sync:Server:WeatherChange", _weather)
		Logger:Info("Sync", "Weather Updated: ^5" .. _weather .. "^7", { console = true })
	end,
}

AddEventHandler("Proxy:Shared:RegisterReady", function(component)
	exports["sandbox-base"]:RegisterComponent("Sync", SYNC)
end)

AddEventHandler("txAdmin:events:scheduledRestart", function(eventData)
	if eventData.secondsRemaining == 180 then
		Sync:FreezeWeather(true)
		Sync.Set:Weather("THUNDER")
	end
end)
