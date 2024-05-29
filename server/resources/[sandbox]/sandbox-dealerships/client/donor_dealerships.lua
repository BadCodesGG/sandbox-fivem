function CreateDonorDealerships()
  for k, v in ipairs(_donorDealerships) do
    PedInteraction:Add("donor_dealer_" .. k, v.ped.model, v.ped.location.xyz, v.ped.location.w, 50.0, {
      {
        icon = "car-side",
        text = "Donator Vehicle Purchases",
        event = "DonorDealer:Client:Open",
        data = { id = k },
      },
      {
        icon = "receipt",
        text = "View Unredeemed Purchases",
        event = "DonorDealer:Client:ViewPending",
        data = { id = k },
      },
    }, "comment-dollar", v.ped.scenario)
  end
end

AddEventHandler("DonorDealer:Client:ViewPending", function(entityData, data)
  Callbacks:ServerCallback("Dealerships:DonorSales:GetPending", {}, function(menu)
    ListMenu:Show(menu)
  end)
end)

AddEventHandler("DonorDealer:Client:Open", function(entityData, data)
  local dealer = data.id
  Callbacks:ServerCallback("Dealerships:DonorSales:GetStock", dealer, function(data)
    if not data then
      return Notification:Error("No Pending Donator Purchases to Redeem")
    end

    local fData = FormatDealerStockToCategories(data.stock)
  
    local orderedCategories = Utils:GetTableKeys(_catalogCategories)
    table.sort(orderedCategories, function(a, b)
      return _catalogCategories[a] < _catalogCategories[b]
    end)

    local menu = {}
    local mainMenuItems = {}

    table.insert(mainMenuItems, {
      label = "Your Redeemable Classes",
      description = data.classDisplay,
    })

    for _, cat in ipairs(orderedCategories) do
      if fData.sorted[cat] and #fData.sorted[cat] > 0 then
        table.insert(mainMenuItems, {
          label = _catalogCategories[cat],
          description = string.format("%s Vehicle(s) Available", #fData.sorted[cat]),
          submenu = cat,
        })

        local sItems = {}
  
        for k, v in ipairs(fData.sorted[cat]) do
          table.insert(sItems, {
            label = string.format("%s %s", v.make, v.model),
            description = string.format("Class: %s", string.upper(v.class) or 'Unknown'),
            event = "DonorDealer:Client:StartPurchase",
            data = {
              dealer = dealer,
              vehicle = v.vehicle,
              make = v.make,
              model = v.model,
              class = v.class,
            }
          })
        end
  
        menu[cat] = {
          label = _catalogCategories[cat],
          items = sItems
        }
      end
    end

    menu["main"] = {
      label = "Donator Vehicle Purchase",
      items = mainMenuItems,
    }

    ListMenu:Show(menu)
  end)
end)

AddEventHandler("DonorDealer:Client:StartPurchase", function(data)
  Confirm:Show(
    "Confirm Donator Vehicle Purchase",
    {
      yes = "DonorDealer:Client:ConfirmPurchase",
      no = "",
    },
    string.format(
      [[
        Are you sure that you want to buy this vehicle, you will not be able to use your donator vehicle purchase on another character once you confirm this purchase.<br>
        Vehicle: %s %s<br>
        Class: %s<br>
      ]],
      data.make or "Unknown",
      data.model or "Unknown",
      data.class or "?"
    ),
    data,
    "Deny",
    "Confirm"
  )
end)

AddEventHandler("DonorDealer:Client:ConfirmPurchase", function(data)
  Callbacks:ServerCallback("Dealerships:DonorSales:Purchase", data)
end)