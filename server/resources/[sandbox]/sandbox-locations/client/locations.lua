local _logoutLocations = {
    -- { -- Mt Zonah
    --     center = vector3(-435.59, -305.86, 35.0),
    --     length = 1.8,
    --     width = 2.2,
    --     options = {
    --         heading = 22,
    --         --debugPoly=true,
    --         minZ = 34.0,
    --         maxZ = 36.8
    --     },
    -- },
	{ -- St Fiacre Medical Bathroom
        center = vector3(1123.17, -1546.83, 35.03),
        length = 1.4,
        width = 1.4,
        options = {
            heading =  0,
            --debugPoly=true,
            minZ = 32.63,
  			maxZ = 36.63
        },
    },
	{ -- St Fiacre Medical Bathroom
        center = vector3(1123.2, -1538.36, 35.03),
        length = 1.4,
        width = 1.4,
        options = {
            heading =  0,
            --debugPoly=true,
			minZ = 32.63,
			maxZ = 36.63
        },
    },
    { -- MRPD Bathroom
        center = vector3(477.96, -981.89, 30.69),
        length = 5.0,
        width = 3.6,
        options = {
            heading = 0,
            --debugPoly=true,
            minZ = 29.69,
            maxZ = 32.09
        },
    },
	{ -- BCSO Bathroom
        center = vector3(1830.4, 3680.58, 38.86),
        length = 3.6,
        width = 3.2,
        options = {
            heading = 30,
            --debugPoly=true,
			minZ = 37.26,
			maxZ = 41.26
        },
    },
	{ -- SAST Bathroom
        center = vector3(-452.1, 5998.76, 37.01),
        length = 3.0,
        width = 4.0,
        options = {
            heading = 45,
            --debugPoly=true,
			minZ = 35.81,
  			maxZ = 39.81
        },
    },
    -- {
    --     center = vector3(1849.23, 3691.41, 29.82),
    --     length = 2.0,
    --     width = 2.0,
    --     options = {
    --         heading = 30,
    --         --debugPoly=true,
    --         minZ = 28.82,
    --         maxZ = 31.22
    --     },
    -- },
    { -- pillbox
        center = vector3(304.05, -568.87, 43.28),
        length = 1.0,
        width = 2.2,
        options = {
            heading = 340,
            --debugPoly=true,
            minZ = 41.82,
            maxZ = 45.22
        },
    },
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['sandbox-base']:RegisterComponent('Locations', LOCATIONS)
end)

AddEventHandler('Locations:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Callbacks = exports['sandbox-base']:FetchComponent('Callbacks')
    Locations = exports['sandbox-base']:FetchComponent('Locations')
    Targeting = exports['sandbox-base']:FetchComponent('Targeting')
    Characters = exports['sandbox-base']:FetchComponent('Characters')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['sandbox-base']:RequestDependencies('Locations', {
        'Callbacks',
        'Locations',
        'Targeting',
        'Characters',
    }, function(error)
        if #error > 0 then
            return;
        end
        RetrieveComponents()

        for k, v in ipairs(_logoutLocations) do
            Targeting.Zones:AddBox("logout-location-" .. k, "person-from-portal", v.center, v.length, v.width, v.options, {
                {
                    icon = "person-from-portal",
                    text = "Logout",
                    event = "Locations:Client:LogoutLocation",
                },
            }, 2.0, true)
        end
    end)
end)

LOCATIONS = {
    GetAll = function(self, type, cb)
        Callbacks:ServerCallback('Locations:GetAll', {
            type = type
        }, cb)
    end
}

AddEventHandler('Locations:Client:LogoutLocation', function()
    Characters:Logout()
end)

AddEventHandler("Characters:Client:Spawn", function()
	Citizen.CreateThread(function()
		while LocalPlayer.state.loggedIn do
			Citizen.Wait(60000)

            if not LocalPlayer.state?.tpLocation then
                local coords = GetEntityCoords(PlayerPedId())
                if LocalPlayer.state.loggedIn and coords and #(coords - vector3(0.0, 0.0, 0.0)) >= 10.0 then
                    TriggerServerEvent('Characters:Server:LastLocation', coords)
                end
            end
        end
	end)
end)
