local _hasFetched = false
local defaultSetup = "basketball"

local _MBAeventNames = {
	basketball = true,
	boxing = true,
	concert = true,
	curling = true,
	derby = true,
	fameorshame = true,
	fashion = true,
	football = true,
	icehockey = true,
	gokarta = true,
	gokartb = true,
	trackmaniaa = true,
	trackmaniab = true,
	trackmaniac = true,
	trackmaniad = true,
	mma = true,
	none = true,
	paintball = true,
	rocketleague = true,
	wrestling = true,
}

function SetMBAInterior(interior)
    if not _MBAeventNames[interior] then
        return false
    end

    local p = promise.new()
    Database.Game:updateOne({
        collection = "business_configs",
        query = {
            key = "mba_setup",
        },
        update = {
            ["$set"] = {
                value = interior,
            },
        },
        options = {
            upsert = true,
        }
    }, function(success, results)
        if success then
            GlobalState["MBA:Interior"] = interior
            TriggerClientEvent("Businesses:Client:MBA:InteriorUpdate", -1, interior)
        end

        p:resolve(success)
    end)

    local res = Citizen.Await(p)
    return res
end

AddEventHandler("Businesses:Server:Startup", function()
    if not _hasFetched then
        _hasFetched = true

        local p = promise.new()
        Database.Game:findOne({
            collection = "business_configs",
            query = {
                key = "mba_setup"
            }
        }, function(success, results)
            if success and results and #results > 0 and results[1]?.value then
                p:resolve(results[1].value)
            else
                p:resolve(defaultSetup)
            end
        end)

        local d = Citizen.Await(p)

        GlobalState["MBA:Interior"] = d
    end

    Callbacks:RegisterServerCallback("MBA:ChangeInterior", function(source, data, cb)
        if Player(source).state.onDuty == "mba" and data ~= GlobalState["MBA:Interior"] then
            cb(SetMBAInterior(data))
        else
            cb(false)
        end
    end)

    Chat:RegisterStaffCommand("setmazebank", function(source, args, rawCommand)
        local int = args[1]
        if _MBAeventNames[int] then
            if SetMBAInterior(int) then
                Chat.Send.System:Single(source, "Success") 
            else
                Chat.Send.System:Single(source, "Error") 
            end
        else
            Chat.Send.System:Single(source, "Invalid Interior") 
        end
	end, {
		help = "[Staff] Set Maze Bank Arena Interior",
		params = {
			{
				name = "Interior Type",
				help = "basketball, gokarta, etc.",
			},
		},
	}, 1)
end)