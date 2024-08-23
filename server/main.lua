function HasPermission(source)
    return IsPlayerAceAllowed(source, Config.PermissionName)
end

RegisterNetEvent('my-doorlock:server:updateDoorState')
AddEventHandler('my-doorlock:server:updateDoorState', function(doorId)
    local src = source
    if HasPermission(src) then
        local doorState = Config.Doors[doorId]
        doorState.locked = not doorState.locked
        TriggerClientEvent('my-doorlock:client:updateDoorState', -1, doorId, doorState.locked)
    else
        print(GetPlayerName(src) .. " attempted to update door state without permission!")
    end
end)

AddEventHandler('playerJoining', function()
    TriggerClientEvent('my-doorlock:client:initialize', source, Config.Doors)
end)