function RegisterDonorVehicleSaleCallbacks()
  Callbacks:RegisterServerCallback("Dealerships:DonorSales:GetStock", function(source, data, cb)
    local plyr = Fetch:Source(source)
    if plyr and _donorDealerships[data] then
      local pending = Dealerships.Donator:GetPending(plyr:GetData("Identifier"))
      
      if pending and #pending > 0 then
        local filtered = {}
        local allowedClasses = {}
        local classList = {}
        
        for k, v in ipairs(pending) do
          allowedClasses[v.class] = true
          table.insert(classList, v.class)
        end

        local dealerData = Dealerships.Stock:FetchDealer(_donorDealerships[data].availableVehicles)
  
        for k, v in ipairs(dealerData) do
          if allowedClasses[v.data.class] and (not _donorDealerships[data].flags.depleteStockOnPurchase or v.quantity > 0) then
            table.insert(filtered, v)
          end
        end
  
        cb({
          stock = filtered,
          classDisplay = table.concat(classList, ", ")
        })
        return
      end
    end

    cb(false)
  end)

  Callbacks:RegisterServerCallback("Dealerships:DonorSales:GetPending", function(source, data, cb)
    local plyr = Fetch:Source(source)
    if plyr then
      local pending = Dealerships.Donator:GetPending(plyr:GetData("Identifier"), true)
      local mainMenuItems = {}
      for k, v in ipairs(pending) do
        if not v.redeemed then
          table.insert(mainMenuItems, {
            label = string.format("%s Class Vehicle", v.class),
            description = string.format("UID: %s", v._id), 
            disabled = v.redeemed,
          })
        end
      end

      for k, v in ipairs(pending) do
        if v.redeemed then
          table.insert(mainMenuItems, {
            label = string.format("%s Class Vehicle", v.class),
            description = string.format("UID: %s", v._id), 
            disabled = v.redeemed,
          })
        end
      end

      cb({
        main = {
          label = "Unredeemed Vehicle Purchases",
          items = mainMenuItems
        }
      })
      return
    end

    cb(false)
  end)

  Callbacks:RegisterServerCallback("Dealerships:DonorSales:Purchase", function(source, data, cb)
    if data?.dealer and data?.vehicle and _donorDealerships[data.dealer] then
      local plyr = Fetch:Source(source)
      if plyr then
        local char = Fetch:CharacterSource(source)
        local hostDealer = _donorDealerships[data.dealer].availableVehicles
        local dealerData = _dealerships[hostDealer]

        if char and hostDealer then
          local profitPercent = Dealerships.Management:GetData(hostDealer, 'profitPercentage')
          local commissionPercent = Dealerships.Management:GetData(hostDealer, 'commission')
          local saleVehicleData = Dealerships.Stock:FetchDealerVehicle(hostDealer, data.vehicle)

          if profitPercent and commissionPercent and saleVehicleData and saleVehicleData.quantity > 0 and saleVehicleData.data.price and saleVehicleData.data.price > 0 then
            local donatorStuff = Dealerships.Donator:GetPending(plyr:GetData("Identifier"))

            local allowedClasses = {}
            for k, v in ipairs(donatorStuff) do
              allowedClasses[v.class] = true
            end

            if allowedClasses[saleVehicleData.data.class] then
              local vehiclePrice = saleVehicleData.data.price
              local priceMultiplier = 1 + (profitPercent / 100)
              local commissionMultiplier = (commissionPercent / 100)
              local salePrice = Utils:Round(vehiclePrice * priceMultiplier, 0)
  
              local playerCommission = Utils:Round((salePrice - vehiclePrice) * commissionMultiplier, 0)
              local dealerRecieves = Utils:Round(salePrice - playerCommission, 0)
  
              local removeSuccess = nil
              if _donorDealerships[data.dealer].flags.depleteStockOnPurchase then
                removeSuccess = Dealerships.Stock:Remove(hostDealer, saleVehicleData.vehicle, 1)
              else
                removeSuccess = saleVehicleData.quantity
              end

              local removeId
              for k, v in ipairs(donatorStuff) do
                if v.class == saleVehicleData.data.class then
                  removeId = v._id
                end
              end

              local revokeToken = Dealerships.Donator:RemovePending(plyr:GetData("Identifier"), removeId)
  
              if removeSuccess and revokeToken then
                Vehicles.Owned:AddToCharacter(char:GetData('SID'), GetHashKey(saleVehicleData.vehicle), 0, saleVehicleData.modelType, { 
                  make = saleVehicleData.data.make,
                  model = saleVehicleData.data.model,
                  class = saleVehicleData.data.class,
                  value = salePrice,
                  donatorFlag = true,
                }, function(success, vehicleData)
                  if success and vehicleData then

                    if _donorDealerships[data.dealer].flags.depleteStockOnPurchase then
                      Dealerships.Records:Create(hostDealer, {
                        time = os.time(),
                        type = "full",
                        vehicle = {
                          VIN = vehicleData.VIN,
                          vehicle = saleVehicleData.vehicle,
                          data = saleVehicleData.data,
                        },
                        profitPercent = profitPercent,
                        salePrice = salePrice,
                        dealerProfits = 0, --dealerRecieves,
                        commission = 0,
                        buyer = {
                          ID = char:GetData('ID'),
                          SID = char:GetData('SID'),
                          First = char:GetData('First'),
                          Last = char:GetData('Last'),
                        },
                        newQuantity = removeSuccess,
                      })

                      SendDealerProfits(dealerData, 100, false, 0, saleVehicleData.data, {
                        SID = char:GetData('SID'),
                        First = char:GetData('First'),
                        Last = char:GetData('Last'),
                        Source = source,
                      })
                    end

                    SendCompletedCashSaleEmail({
                      SID = char:GetData('SID'),
                      First = char:GetData('First'),
                      Last = char:GetData('Last'),
                      Source = source,
                    }, dealerData, saleVehicleData.data, salePrice, vehicleData.VIN, vehicleData.RegisteredPlate)
                    
                    cb(true)

                    Logger:Warn(
                      "Donator",
                      string.format(
                        "%s [%s] Redeemed %s Class Donator Vehicle - Character %s %s (%s) - Vehicle %s %s", 
                        plyr:GetData("Name"),
                        plyr:GetData("AccountID"),
                        saleVehicleData.data.class,
                        char:GetData('First'),
                        char:GetData('Last'),
                        char:GetData('SID'),
                        saleVehicleData.data.make,
                        saleVehicleData.data.model
                      ),
                      {
                        console = true,
                        file = false,
                        database = true,
                        discord = {
                          embed = true,
                          type = "error",
                          webhook = GetConvar("discord_donation_webhook", ''),
                        }
                      }
                    )
                    return
                  end
                end, false, _donorDealerships[data.dealer].storage)
              end
            end
          end
        end
      end
    end

    cb(false)
  end)

  Chat:RegisterAdminCommand("adddonatorvehicle", function(source, args, rawCommand)
    local license, class = table.unpack(args)

    if license and class then
      local success = Dealerships.Donator:AddPending(license, class)
      if success then
        Chat.Send.System:Single(source, "Successfully Added Donator Token")
      else
        Chat.Send.System:Single(source, "Failed")
      end
    end
  end, {
    help = "[Admin] Add a players donator vehicles",
    params = {
      {
        name = "Player Identifier",
        help = "Player License",
      },
      {
        name = "Vehicle Class",
        help = "Vehicle Class",
      },
    },
  }, 2)

  Chat:RegisterAdminCommand("getdonatorvehicle", function(source, args, rawCommand)
    local license = table.unpack(args)

    if license then
      local res = Dealerships.Donator:GetPending(license, true)
      if res then
        local message = string.format("Player Identifier: %s<br>", license)
        for k, v in ipairs(res) do
          message = message .. string.format("<br>ID: %s<br>Class: %s<br>Redeemed: %s<br>", v._id, v.class, v.redeemed and "Yes" or "No")
        end
        Chat.Send.System:Single(source, message)
      else
        Chat.Send.System:Single(source, "Failed")
      end
    end
  end, {
    help = "[Admin] Check donator vehicles",
    params = {
      {
        name = "Player Identifier",
        help = "Player License",
      },
    },
  }, 1)

  Chat:RegisterAdminCommand("removedonatorvehicle", function(source, args, rawCommand)
    local license, tokenId = table.unpack(args)

    if license and tokenId then
      local success = Dealerships.Donator:DeletePending(license, tokenId)
      if success then
        Chat.Send.System:Single(source, "Successfully Removed")
      else
        Chat.Send.System:Single(source, "Failed")
      end
    end
  end, {
    help = "[Admin] Remove donator vehicles",
    params = {
      {
        name = "Player Identifier",
        help = "Player License",
      },
      {
        name = "ID",
        help = "Donator Vehicle Pending Token",
      },
    },
  }, 2)
end

DEALERSHIPS.Donator = {
  AddPending = function(self, playerIdentifier, class, data)
    local p = promise.new()
    Database.Game:insertOne({
      collection = "donator_vehicles",
      document = {
        player = playerIdentifier,
        class = class,
        redeemed = false,
        data = data,
      },
    }, function(success, inserted)
      p:resolve(success and inserted > 0)
    end)

    return Citizen.Await(p)
  end,
  GetPending = function(self, playerIdentifier, includeRedeemed)
    local p = promise.new()

    local stupid = false
    if includeRedeemed then
      stupid = nil
    end

    Database.Game:find({
      collection = "donator_vehicles",
      query = {
        player = playerIdentifier,
        redeemed = stupid,
      },
    }, function(success, results)
      if success and #results > 0 then
        p:resolve(results)
      else
        p:resolve({})
      end
    end)

    return Citizen.Await(p)
  end,
  RemovePending = function(self, playerIdentifier, id)
    local p = promise.new()

    Database.Game:updateOne({
      collection = "donator_vehicles",
      query = {
        player = playerIdentifier,
        _id = id,
      },
      update = {
        ["$set"] = {
          redeemed = true,
        }
      }
    }, function(success, updated)
      p:resolve(success)
    end)

    return Citizen.Await(p)
  end,
  DeletePending = function(self, playerIdentifier, id)
    local p = promise.new()

    Database.Game:deleteOne({
      collection = "donator_vehicles",
      query = {
        player = playerIdentifier,
        _id = id,
      },
    }, function(success)
      p:resolve(success)
    end)

    return Citizen.Await(p)
  end
}

AddEventHandler("DonorDealer:Server:AddCarToPlayer", function(identifier, class)
  Dealerships.Donator:AddPending(identifier, class)
end)

function TebexAddDonatorVehicle(source, args)
	local sid, class = table.unpack(args)
	sid = tonumber(sid)
	if sid == nil or sid == 0 then
        Logger:Warn(
			"Donator Vehicle",
			"Provided SID (server ID) was empty.",
			{
				console = true,
				file = false,
				database = true,
				discord = {
					embed = true,
					type = "error",
					webhook = GetConvar("discord_donation_webhook", ''),
				}
			}
		)
		return
	end
	local player = Fetch:Source(sid)
	if player then
		local license = player:GetData("Identifier")
		if license and class then
			local success = Dealerships.Donator:AddPending(license, class)
			if success then
				Chat.Send.System:Single(sid, "Successfully Added Donator Token")
			else
				Chat.Send.System:Single(sid, "Failed")
			end
		end
	end  
end
RegisterCommand("tebexadddonatorvehicle", TebexAddDonatorVehicle, true)