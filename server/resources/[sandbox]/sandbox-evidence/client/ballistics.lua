_withinBallistics = false
_ballisticsId = nil
_holdingGun = nil

AddEventHandler('Polyzone:Enter', function(id, point, insideZone, data)
    if data and data.ballistics and LocalPlayer.state.onDuty == 'police' then
        _ballisticsId = id
        _withinBallistics = true
        Action:Show('ballistics', '{keybind}primary_action{/keybind} Test & File Gun Ballistics | {key}Use Projectile Evidence{/key} File Projectile & Compare')
    end
end)

AddEventHandler('Polyzone:Exit', function(id, point, insideZone, data)
    if _withinBallistics and data and data.ballistics and LocalPlayer.state.onDuty == 'police' then
        _ballisticsId = nil
        _withinBallistics = false
        Action:Hide('ballistics')
    end
end)

AddEventHandler('Keybinds:Client:KeyUp:primary_action', function()
    if _withinBallistics and LocalPlayer.state.loggedIn then
        Action:Hide('ballistics')
        Inventory.Dumbfuck:Open({
            invType = 212,
            owner = _ballisticsId,
        })
    end
end)

RegisterNetEvent('Evidence:Client:FiledProjectile', function(tooDegraded, success, alreadyFiled, filedEvidenceData, matchingWeaponData, evidenceId)
    if tooDegraded then
        return Notification:Error('Projectile too Degraded to Run Ballistics')
    end
    
    Animations.Emotes:Play('type3', false, 5500, true, true)
    Progress:Progress({
        name = 'projectile_ballistics_test',
        duration = 5000,
        label = 'Testing Projectile Ballistics',
        useWhileDead = false,
        canCancel = false,
        ignoreModifier = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        },
    }, function(status)
        if not status then
            if success then
                if alreadyFiled then
                    Notification:Success('Projectile Was Already Filed', 7500)
                else
                    Notification:Success('Projectile Filed Successfully', 7500)
                end

                local desc, label

                if matchingWeaponData and matchingWeaponData.police_filed then
                    label = string.format('Successfully Matched to a %s', matchingWeaponData.model)

                    if matchingWeaponData.scratched then
                        desc = string.format('Matched to a Weapon with no Serial Number<br>Assigned Police Weapon ID: PWI-%s', matchingWeaponData.police_id)
                    else
                        desc = string.format('Serial Number: %s', matchingWeaponData.serial)
                    end
                else
                    label = 'No Matching Weapon Found'
                    desc = 'There are currently no weapons filed that match this projectile'
                end

                if label and desc then
                    ListMenu:Show({
                        main = {
                            label = 'Ballistics Comparison - Results',
                            items = {
                                {
                                    label = 'Projectile Evidence Identifier',
                                    description = evidenceId,
                                },
                                {
                                    label = label,
                                    description = desc,
                                }
                            },
                        },
                    })
                end
            else
                Notification:Error('Ballistics Testing Failed')
            end
        end
    end)
end)