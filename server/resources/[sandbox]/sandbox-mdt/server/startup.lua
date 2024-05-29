_warrants = {}
_charges = {}
_notices = {}

local _ran = false

function Startup()
	if _ran then
		return
	end
	RegisterTasks()

	-- Set Expired Active Warrants to Expired
	MySQL.query.await("UPDATE mdt_warrants SET state = ? WHERE state = ? AND expires < NOW()", {
		"expired",
		"active",
	})

	_charges = MySQL.query.await("SELECT * from mdt_charges")
	Logger:Trace("MDT", "Loaded ^2" .. #_charges .. "^7 Charges", { console = true })

	Database.Game:find({
		collection = "vehicles",
		query = {
			["Flags.0"] = { ["$exists"] = true },
		},
		options = {
			projection = {
				_id = 0,
				Type = 1,
				VIN = 1,
				Flags = 1,
				RegisteredPlate = 1,
			},
		},
	}, function(success, results)
		if not success then
			return
		end

		for k, v in ipairs(results) do
			if v.RegisteredPlate and v.Type == 0 then
				Radar:AddFlaggedPlate(v.RegisteredPlate, "Vehicle Flagged in MDT")
			end
		end
	end)

	_ran = true

	-- SetHttpHandler(function(req, res)
	-- 	if req.path == '/charges' then
	-- 		res.send(json.encode(_charges))
	-- 	end
	-- end)

	Database.Game:update({
		collection = "vehicles",
		query = {
			["$and"] = {
				{ ["$nor"] = {
					{ Strikes = { ["$elemMatch"] = {
						Date = {
							["$gte"] = (os.time() * 1000) - (60 * 60 * 24 * 30 * 1000)
						}
					}}}
				}},
				{
					Strikes = { ["$elemMatch"] = {
						Date = { ["$lte"] = (os.time() * 1000) - (60 * 60 * 24 * 30 * 1000) }
					}}
				}
			},
		},
		update = {
			["$pull"] = {
				Strikes = {
					Date = {
						["$lte"] = (os.time() * 1000) - (60 * 60 * 24 * 30 * 1000),
					}
				}
			}
		}
	}, function(success, results)

	end)
end
