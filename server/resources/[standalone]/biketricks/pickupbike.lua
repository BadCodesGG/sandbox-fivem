-- local models = {
--    `bmx`,
--    `cruiser`,
--    `scorcher`,
--    `fixter`,
--    `tribike`,
--    `tribike2`,
--    `tribike3`,
--    `pbike`
-- }

-- function IsBikeModel(bike)
--   for k,v in pairs(models) do
--     if v == GetEntityModel(bike) then
--       return true
--     end
--   end
--   return false
-- end

-- exports("IsBikeModel", IsBikeModel)

-- RegisterNetEvent('remo:bike')
-- AddEventHandler('remo:bike', function(entity)
--   print('pick up bike?', entity)
--   local playerPed = PlayerPedId()
--   local coords = GetEntityCoords(playerPed)
--   local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)
--   local bone = 24818
--   local bike = false

--   if GetEntityModel(vehicle) == GetHashKey("bmx") or GetEntityModel(vehicle) == GetHashKey("scorcher") or GetEntityModel(vehicle) == GetHashKey("cruiser") or GetEntityModel(vehicle) == GetHashKey("fixter") or GetEntityModel(vehicle) == GetHashKey("tribike") or GetEntityModel(vehicle) == GetHashKey("tribike2") or GetEntityModel(vehicle) == GetHashKey("tribike3") or GetEntityModel(vehicle) == GetHashKey("pbike") then

--   AttachEntityToEntity(vehicle, playerPed, bone, 0.18, -0.20, 0.40, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
--   lib.notify({
--     description = "Press G to drop the bike",
--     type = 'error'
--   })

--   RequestAnimDict("move_p_m_zero_rucksack")
--   while (not HasAnimDictLoaded("move_p_m_zero_rucksack")) do Citizen.Wait(0) end
--   TaskPlayAnim(playerPed, "move_p_m_zero_rucksack", "idle", 2.0, 2.0, -1, 51, 0, false, false, false)
--   bike = true

--   RegisterCommand('dropbike', function()
--     if IsEntityAttached(vehicle) and not IsPedInAnyVehicle(playerPed, false) then
--       DetachEntity(vehicle, nil, nil)
--       SetVehicleOnGroundProperly(vehicle)
--       ClearPedTasksImmediately(playerPed)
--       bike = false
--     end
--   end, false)

--     RegisterKeyMapping('dropbike', 'Drop Bike', 'keyboard', 'g')

--     Citizen.CreateThread(function()
--       if bike and IsEntityPlayingAnim(playerPed, "move_p_m_zero_rucksack", "idle", 3) ~= 1 then
--         RequestAnimDict("move_p_m_zero_rucksack")
--         while (not HasAnimDictLoaded("move_p_m_zero_rucksack")) do Citizen.Wait(0) end
--           TaskPlayAnim(playerPed, "move_p_m_zero_rucksack", "idle", 2.0, 2.0, -1, 51, 0, false, false, false)
--         if not IsEntityAttachedToEntity(playerPed, vehicle) then
--           bike = false
--           ClearPedTasksImmediately(playerPed)
--         end
--       end
--     end)
--   end
-- end)