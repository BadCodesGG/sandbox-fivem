local _activeTestDrives = {}
local maxActive = 10
local _hasStartedCountdown = false

RegisterNetEvent('Dealerships:Server:StartSale', function(dealership, type, data)
    
end)

RegisterNetEvent('Vehicles:Server:TestDriveTime', function(vNet)
	local _src = source
    local vehicle = NetworkGetEntityFromNetworkId(vNet)
    if vehicle and DoesEntityExist(vehicle) and Entity(vehicle).state.testDrive then
        local dealership = Entity(vehicle).state.testDriveDealership
        local timeRemaining = Entity(vehicle).state.testDrive - os.time()

        if _activeTestDrives[dealership] and not _activeTestDrives[dealership].startedTimer then
            _activeTestDrives[dealership].startedTimer = true

            if timeRemaining > 0 then
                Execute:Client(_src, "Notification", "Info", "Test Drive Time Remaining", timeRemaining * 1000, "car")
    
                Citizen.SetTimeout(timeRemaining * 1000, function()
                    EndTestDrive(vehicle, dealership, _src)
                end)
            else
                EndTestDrive(vehicle, dealership, _src)
            end
        end
    end
end)

function EndTestDrive(vehicle, dealership, _src)
    if vehicle and vehicle ~= 0 and DoesEntityExist(vehicle) then
        Vehicles:Delete(vehicle, function(success) end)
    else
        Execute:Client(_src, "Notification", "Error", "Cannot find vehicle to return. Test drive cancelled.", 3000, "car")
    end

    if _dealerships[dealership].testdrive.setplayerback then
        SetEntityCoords(
            GetPlayerPed(_src),
            _dealerships[dealership].testdrive.coords.x,
            _dealerships[dealership].testdrive.coords.y,
            _dealerships[dealership].testdrive.coords.z,
            0,
            0,
            0,
            false
        )
    end
    
    _activeTestDrives[dealership] = nil
end

function RegisterVehicleSaleCallbacks()
	Callbacks:RegisterServerCallback('Dealerships:Sales:TestDrive', function(source, testDriveData, cb)
		local dealership = testDriveData?.dealership
        local data = testDriveData?.data
		if dealership and data then
			local spawn = _dealerships[dealership].testdrive.coords
			local timer = _dealerships[dealership].testdrive.timer
			local model = data.vehicle

            -- In Case of Deletion
            if _activeTestDrives[dealership] and not DoesEntityExist(_activeTestDrives[dealership].veh) then
                _activeTestDrives[dealership] = nil
            end

			if _activeTestDrives[dealership] == nil then
				Vehicles:SpawnTemp(
					source,
					GetHashKey(model),
                    data.modelType,
					vector3(spawn.x, spawn.y, spawn.z),
					spawn.w,
					function(spawnedVehicle, VIN, plate)
						if spawnedVehicle then
							Vehicles.Keys:Add(source, VIN)

							_activeTestDrives[dealership] = {
								veh = spawnedVehicle,
								net = NetworkGetNetworkIdFromEntity(spawnedVehicle),
								VIN = VIN,
								plate = plate,
                                startedTimer = false,
							}

							Execute:Client(source, "Notification", "Success", "Your Test Drive Vehicle Was Provided", 5000, "car")
							Entity(spawnedVehicle).state.testDrive = os.time() + timer
							Entity(spawnedVehicle).state.testDriveDealership = dealership
						else
							Execute:Client(source, "Notification", "Error", "Test Drive Vehicle Failed To Spawn", 5000, "car")
						end
					end,
					{
						Make = "Test Drive",
						Model = model,
						Value = 999999,
					}
				)
			else
				Execute:Client(source, "Notification", "Error", "We Already Gave You a Test Drive Vehicle", 5000, "car")
			end
			cb(true, 'Initiating Test Drive')
		else
            cb(false, 'Error Initiating Test Drive')
		end
	end)

    Callbacks:RegisterServerCallback('Dealerships:Sales:StartSale', function(source, saleData, cb)
        local dealership = saleData?.dealership
        local type = saleData?.type
        local data = saleData?.data

        if dealership and type and data then
            local dealerData = _dealerships[dealership]
            local customerStateId, vehicle = math.tointeger(data.customer), data.vehicle
            local char = Fetch:CharacterSource(source)
            if char and dealerData and customerStateId and vehicle and Jobs.Permissions:HasPermissionInJob(source, dealerData.id, 'dealership_sell') then
                local targetCharacter = Fetch:SID(customerStateId)
                if targetCharacter then
                    local playerCoords = GetEntityCoords(GetPlayerPed(source))
                    local targetCoords = GetEntityCoords(GetPlayerPed(targetCharacter:GetData('Source')))
                    if #(playerCoords - targetCoords) <= 15.0 then
                        local targetSrc = targetCharacter:GetData('Source')

                        local profitPercent = Dealerships.Management:GetData(dealership, 'profitPercentage')
                        local commissionPercent = Dealerships.Management:GetData(dealership, 'commission')

                        local saleVehicleData = Dealerships.Stock:FetchDealerVehicle(dealerData.id, vehicle)
                        if profitPercent and commissionPercent and saleVehicleData and saleVehicleData.quantity > 0 and saleVehicleData.data.price and saleVehicleData.data.price > 0 then
                            local vehiclePrice = saleVehicleData.data.price
                            local priceMultiplier = 1 + (profitPercent / 100)
                            local commissionMultiplier = (commissionPercent / 100)
                            local salePrice = Utils:Round(vehiclePrice * priceMultiplier, 0)

                            local playerCommission = Utils:Round((salePrice - vehiclePrice) * commissionMultiplier, 0)
                            local dealerRecieves = Utils:Round(salePrice - playerCommission, 0)


                            if type == 'full' then
                                Billing:Create(targetSrc, dealerData.abbreviation .. ' - Sales', salePrice, '', function(wasPayed, withAccount)
                                    if wasPayed then
                                        local removeSuccess = Dealerships.Stock:Remove(dealerData.id, saleVehicleData.vehicle, 1)
                                        if removeSuccess then
                                            Vehicles.Owned:AddToCharacter(targetCharacter:GetData('SID'), GetHashKey(saleVehicleData.vehicle), 0, saleVehicleData.modelType, { 
                                                make = saleVehicleData.data.make,
                                                model = saleVehicleData.data.model,
                                                class = saleVehicleData.data.class,
                                                value = salePrice,
                                            }, function(success, vehicleData)
                                                if success and vehicleData then
                                                    Dealerships.Records:Create(dealerData.id, {
                                                        time = os.time(),
                                                        type = type,
                                                        vehicle = {
                                                            VIN = vehicleData.VIN,
                                                            vehicle = saleVehicleData.vehicle,
                                                            data = saleVehicleData.data,
                                                        },
                                                        profitPercent = profitPercent,
                                                        salePrice = salePrice,
                                                        dealerProfits = dealerRecieves,
                                                        commission = playerCommission,
                                                        seller = {
                                                            ID = char:GetData('ID'),
                                                            SID = char:GetData('SID'),
                                                            First = char:GetData('First'),
                                                            Last = char:GetData('Last'),
                                                        },
                                                        buyer = {
                                                            ID = targetCharacter:GetData('ID'),
                                                            SID = targetCharacter:GetData('SID'),
                                                            First = targetCharacter:GetData('First'),
                                                            Last = targetCharacter:GetData('Last'),
                                                        },
                                                        newQuantity = removeSuccess,
                                                    })
        
                                                    Execute:Client(source, 'Notification', 'Success', 'Completed Sales Process - The Customer Received their Vehicle', 7500, 'car-building')
                                                    SendCompletedCashSaleEmail({
                                                        SID = targetCharacter:GetData('SID'),
                                                        First = targetCharacter:GetData('First'),
                                                        Last = targetCharacter:GetData('Last'),
                                                        Source = targetSrc,
                                                    }, dealerData, saleVehicleData.data, salePrice, vehicleData.VIN, vehicleData.RegisteredPlate)
                                                    
                                                    SendDealerProfits(dealerData, dealerRecieves, char:GetData('BankAccount'), playerCommission, saleVehicleData.data, {
                                                        SID = targetCharacter:GetData('SID'),
                                                        First = targetCharacter:GetData('First'),
                                                        Last = targetCharacter:GetData('Last'),
                                                        Source = targetSrc,
                                                    })

                                                    -- Disable credit increase if purchased in fule
                                                    -- if salePrice >= 50000 then
                                                    --     local creditIncrease = math.floor(salePrice / 2000)
                                                    --     if creditIncrease > 25 then
                                                    --         creditIncrease = 25
                                                    --     end

                                                    --     Loans.Credit:Increase(targetCharacter:GetData('SID'), creditIncrease)
                                                    -- end
                                                else
                                                    Execute:Client(source, 'Notification', 'Error', 'Error Completing Vehicle Sale', 5000, 'car-building')
                                                    Execute:Client(targetSrc, 'Notification', 'Error', 'Error Completing Vehicle Sale', 5000, 'car-building')
                                                end
                                            end, false, dealerData.storage)
                                        else
                                            Execute:Client(source, 'Notification', 'Error', 'Error Completing Vehicle Sale', 5000, 'car-building')
                                            Execute:Client(targetSrc, 'Notification', 'Error', 'Error Completing Vehicle Sale', 5000, 'car-building')
                                        end
                                    else
                                        Execute:Client(source, 'Notification', 'Error', 'Payment Failed', 5000, 'car-building')
                                    end
                                end)

                                cb(true, 'Initiating Sales Process')
                            elseif type == 'loan' then

                                local loanData = Loans:GetAllowedLoanAmount(targetCharacter:GetData('SID'))
                                local hasLoans = Loans:GetPlayerLoans(targetCharacter:GetData('SID'), 'vehicle')

                                if loanData and #hasLoans < loanData.limit then
                                    if loanData and loanData.maxBorrowable and loanData.maxBorrowable > 0 then
                                        local defaultInterestRate = Loans:GetDefaultInterestRate()
                                        local downPaymentPercent, loanWeeks = math.tointeger(data.downPayment), math.tointeger(data.loanWeeks)
        
                                        if downPaymentPercent and loanWeeks and defaultInterestRate then
        
                                            local downPayment = Utils:Round(salePrice * (downPaymentPercent / 100), 0)
                                            local salePriceAfterDown = salePrice - downPayment
                                            local afterInterest = Utils:Round(salePriceAfterDown * (1 + (defaultInterestRate / 100)), 0)
        
                                            local perWeek = Utils:Round(afterInterest / loanWeeks, 0)
        
                                            if loanData.maxBorrowable >= salePriceAfterDown then
                                                SendPendingLoanEmail({
                                                    SID = targetCharacter:GetData('SID'),
                                                    First = targetCharacter:GetData('First'),
                                                    Last = targetCharacter:GetData('Last'),
                                                    Source = targetSrc,
                                                }, dealerData, saleVehicleData.data, downPaymentPercent, downPayment, loanWeeks, perWeek, afterInterest, function()
                                                    Execute:Client(source, 'Notification', 'Info', 'The Loan Terms Were Accepted by the Customer', 5000, 'car-building')
                                                    Billing:Create(
                                                        targetSrc, 
                                                        dealerData.name, 
                                                        downPayment,
                                                        string.format('Vehicle Loan Downpayment, %s %s', saleVehicleData.data.make, saleVehicleData.data.model),
                                                        function(wasPayed, withAccount)
                                                            if wasPayed then
                                                                local preGenerateVIN = Vehicles.Identification.VIN:GenerateOwned()

                                                                local loanSuccess = Loans:CreateVehicleLoan(targetSrc, preGenerateVIN, salePrice, downPayment, loanWeeks)
                                                                if loanSuccess then
                                                                    local removeSuccess = Dealerships.Stock:Remove(dealerData.id, saleVehicleData.vehicle, 1)
                                                                    if removeSuccess then
                                                                        Vehicles.Owned:AddToCharacter(targetCharacter:GetData('SID'), GetHashKey(saleVehicleData.vehicle), 0, saleVehicleData.modelType, { 
                                                                            make = saleVehicleData.data.make,
                                                                            model = saleVehicleData.data.model,
                                                                            class = saleVehicleData.data.class,
                                                                            value = saleVehicleData.data.price
                                                                        }, function(success, vehicleData)
                                                                            if success and vehicleData then
                                                                                Dealerships.Records:Create(dealerData.id, {
                                                                                    time = os.time(),
                                                                                    type = type,
                                                                                    loan = {
                                                                                        length = loanWeeks,
                                                                                        downPayment = downPayment,
                                                                                    },
                                                                                    vehicle = {
                                                                                        VIN = vehicleData.VIN,
                                                                                        vehicle = saleVehicleData.vehicle,
                                                                                        data = saleVehicleData.data,
                                                                                    },
                                                                                    profitPercent = profitPercent,
                                                                                    salePrice = salePrice,
                                                                                    dealerProfits = dealerRecieves,
                                                                                    commission = playerCommission,
                                                                                    seller = {
                                                                                        ID = char:GetData('ID'),
                                                                                        SID = char:GetData('SID'),
                                                                                        First = char:GetData('First'),
                                                                                        Last = char:GetData('Last'),
                                                                                    },
                                                                                    buyer = {
                                                                                        ID = targetCharacter:GetData('ID'),
                                                                                        SID = targetCharacter:GetData('SID'),
                                                                                        First = targetCharacter:GetData('First'),
                                                                                        Last = targetCharacter:GetData('Last'),
                                                                                    },
                                                                                    newQuantity = removeSuccess,
                                                                                })
                
                                                                                Execute:Client(source, 'Notification', 'Success', 'Completed Sales Process - The Customer Received their Vehicle', 7500, 'car-building')
                                                                                SendCompletedLoanSaleEmail({
                                                                                    SID = targetCharacter:GetData('SID'),
                                                                                    First = targetCharacter:GetData('First'),
                                                                                    Last = targetCharacter:GetData('Last'),
                                                                                    Source = targetSrc,
                                                                                }, dealerData, saleVehicleData.data, downPaymentPercent, downPayment, loanWeeks, perWeek, afterInterest, vehicleData.VIN, vehicleData.RegisteredPlate)
                
                                                                                SendDealerProfits(dealerData, dealerRecieves, char:GetData('BankAccount'), playerCommission, saleVehicleData.data, {
                                                                                    SID = targetCharacter:GetData('SID'),
                                                                                    First = targetCharacter:GetData('First'),
                                                                                    Last = targetCharacter:GetData('Last'),
                                                                                    Source = targetSrc,
                                                                                })
                                                                            else
                                                                                Execute:Client(source, 'Notification', 'Error', 'Error Completing Vehicle Sale', 5000, 'car-building')
                                                                                Execute:Client(targetSrc, 'Notification', 'Error', 'Error Completing Vehicle Sale', 5000, 'car-building')
                                                                            end
                                                                        end, false, dealerData.storage, preGenerateVIN)
                                                                    else
                                                                        -- Removal of Car from Stock Failed
                                                                        Logger:Error(
                                                                            'Dealerships', 
                                                                            string.format(
                                                                                'Vehicle Purchase Failed (Removal of Car from Stock Failed) After Taking Money, Uh Oh! Remove Success: %s, Loan Success: %s, Pre Gen VIN: %s, withAccount: %s, targetSrc: %s', 
                                                                                removeSuccess,
                                                                                loanSuccess,
                                                                                preGenerateVIN,
                                                                                withAccount,
                                                                                targetSrc
                                                                            )
                                                                        )
                                                                    end
                                                                else
                                                                    -- Car Loan Adding Failed

                                                                    Logger:Error(
                                                                        'Dealerships', 
                                                                        string.format(
                                                                            'Vehicle Purchase Failed (Car Loan Added Failed) After Taking Money, Uh Oh! Loan Success: %s, Pre Gen VIN: %s, withAccount: %s, targetSrc: %s', 
                                                                            loanSuccess,
                                                                            preGenerateVIN,
                                                                            withAccount,
                                                                            targetSrc
                                                                        )
                                                                    )
                                                                end
                                                            else
                                                                Execute:Client(source, 'Notification', 'Error', 'Loan Downpayment Failed', 5000, 'car-building')
                                                            end
                                                        end
                                                    )
                                                end)

                                                cb(true, 'Initiating Sales Process')
                                            else
                                                cb(false, 'Person Doesn\'t Qualify for Loan')
                                            end
                                        else
                                            cb(false, 'Error Initiating Sale')
                                        end
                                    else
                                        cb(false, 'Person Doesn\'t Qualify for Loan')
                                    end
                                else
                                    cb(false, 'Person Has a Vehicle Loan')
                                end
                            else
                                cb(false, 'Error Initiating Sale')
                            end
                        else
                            cb(false, 'Vehicle Isn\'t In Stock')
                        end
                    else
                        cb(false, 'The Customer is Required to be Present')
                    end

                    return
                end
            end

            cb(false, 'Ensure that the Customer\'s State ID is Correct')
        else
            cb(false, 'Error Initiating Sale')
        end
    end)
end

function SendCompletedCashSaleEmail(charData, dealerData, vehicleInfoData, price, VIN, plate)
    Phone.Email:Send(
        charData.Source,
        dealerData.emails.sales,
        os.time(),
        string.format('Vehicle Purchase - %s %s', vehicleInfoData.make, vehicleInfoData.model),
        string.format(
            [[
                Dear %s %s,
                We thank you for completing your purchase of a <b>%s %s</b> for $%s, it has been a pleasure doing business with you.
                Your new vehicle will be delivered as quickly as possible.<br><br>
                The Vehicle VIN is <b>%s</b><br>
                The Vehicle License Plate is <b>%s</b><br>
                <br><br>
                Thanks, %s
            ]],
            charData.First,
            charData.Last,
            vehicleInfoData.make,
            vehicleInfoData.model,
            formatNumberToCurrency(math.floor(price)),
            VIN,
            plate,
            dealerData.name
        ),
        {}
    )
end

local _pendingLoanAccept = {}

function SendPendingLoanEmail(charData, dealerData, vehicleInfoData, downPaymentPercent, downPayment, loanWeeks, weeklyPayments, remaining, cb)
    if not _pendingLoanAccept[charData.SID] then
        _pendingLoanAccept[charData.SID] = cb
        Phone.Email:Send(
            charData.Source,
            dealerData.emails.loans,
            os.time(),
            string.format('Vehicle Loan - %s %s', vehicleInfoData.make, vehicleInfoData.model),
            string.format(
                [[
                    Dear %s %s, 
                    Thank you for applying for a vehicle loan for a %s %s. The terms of this loan are set out below.<br><br>
                    Down payment: <b>$%s</b> (%s%%)<br>
                    Remaining Amount Owed: <b>$%s</b> (Interest Applied)<br>
                    Loan Length: <b>%s Weeks</b><br>
                    Weekly Payments: <b>$%s</b><br><br>

                    Missing loan payments will lead to an increase in the loans interest rate and a missed payment fee.
                    It may also lead to the eventual seizure of your vehicle by the State of San Andreas.
                    <br><br>
                    If you agree with these terms, please click the link attached above to begin the loan acceptance process.
                    <br><br>
                    Thanks, %s
                ]],
                charData.First,
                charData.Last,
                vehicleInfoData.make,
                vehicleInfoData.model,
                formatNumberToCurrency(math.floor(downPayment)),
                downPaymentPercent,
                formatNumberToCurrency(math.floor(remaining)),
                loanWeeks,
                formatNumberToCurrency(math.floor(weeklyPayments)),
                dealerData.name
            ),
            {
                hyperlink = {
                    event = 'Dealerships:Server:AcceptLoan',
                },
            },
            (os.time() + (60 * 5))
        )

        Citizen.SetTimeout(60000 * 5, function()
            _pendingLoanAccept[charData.SID] = nil
        end)
    else
        cb(false, 1)
    end
end

RegisterNetEvent('Dealerships:Server:AcceptLoan', function(_, email)
    local src = source
    local char = Fetch:CharacterSource(src)
    if char then
        Phone.Email:Delete(char:GetData('ID'), email)
        local stateId = char:GetData('SID')

        if _pendingLoanAccept[stateId] then
            _pendingLoanAccept[stateId]()
            _pendingLoanAccept[stateId] = nil
        end
    end
end)


function SendCompletedLoanSaleEmail(charData, dealerData, vehicleInfoData, downPaymentPercent, downPayment, loanWeeks, weeklyPayments, remaining, VIN, plate)
    Phone.Email:Send(
        charData.Source,
        dealerData.emails.loans,
        os.time(),
        string.format('Vehicle Loan - %s %s', vehicleInfoData.make, vehicleInfoData.model),
        string.format(
            [[
                Dear %s %s, 
                Thank you for taking out a vehicle loan for a %s %s, it has been a pleasure doing business with you.
                Your new vehicle will be delivered as quickly as possible.<br><br>
                
                The Vehicle VIN is <b>%s</b><br>
                The Vehicle License Plate is <b>%s</b><br>
                <br><br>
                
                The terms of this loan are set out below.<br><br>
                Down payment: <b>$%s</b> (%s%%)<br>
                Remaining Amount Owed: <b>$%s</b> (Interest Applied)<br>
                Loan Length: <b>%s Weeks</b><br>
                Weekly Payments: <b>$%s</b><br><br>

                Missing loan payments will lead to an increase in the loans interest rate and a missed payment fee.
                It may also lead to the eventual seizure of your vehicle by the State of San Andreas.
                <br><br>
                Thanks, %s
            ]],
            charData.First,
            charData.Last,
            vehicleInfoData.make,
            vehicleInfoData.model,
            VIN,
            plate,
            formatNumberToCurrency(math.floor(downPayment)),
            downPaymentPercent,
            formatNumberToCurrency(math.floor(remaining)),
            loanWeeks,
            formatNumberToCurrency(math.floor(weeklyPayments)),
            dealerData.name
        )
    )
end

function SendDealerProfits(dealerData, dealerProfits, playerBankAccount, playerProfits, vehicleInfoData, buyerData)
    local dealerAccount = Banking.Accounts:GetOrganization(dealerData.id)
    if dealerAccount then
        Banking.Balance:Deposit(dealerAccount.Account, math.floor(dealerProfits), {
            type = 'transfer',
            title = 'Vehicle Purchase',
            description = string.format('Vehicle Sale of a %s %s to %s %s (State ID %s)', vehicleInfoData.make, vehicleInfoData.model, buyerData.First, buyerData.Last, buyerData.SID),
            data = {},
        })
    end

    if playerBankAccount then
        Banking.Balance:Deposit(playerBankAccount, math.floor(playerProfits), {
            type = 'transfer',
            title = dealerData.abbreviation .. ' - Commission',
            description = string.format('Vehicle Sale Commission from your %s employment.', dealerData.name),
            data = {}
        })
    end
end