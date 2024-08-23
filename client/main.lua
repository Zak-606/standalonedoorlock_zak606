local doorStates = {}

local function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local function SetupDoor(doorId, door)
    if door.doorType == "double" then
        for i, singleDoor in ipairs(door.doors) do
            AddDoorToSystem(doorId * 100 + i, singleDoor.model, singleDoor.coords)
        end
    else
        AddDoorToSystem(doorId, door.model, door.coords)
    end
    doorStates[doorId] = door.locked
end

local function UpdateDoorState(doorId, isLocked)
    local door = Config.Doors[doorId]
    if door.doorType == "double" then
        for i, _ in ipairs(door.doors) do
            DoorSystemSetDoorState(doorId * 100 + i, isLocked and 1 or 0, false, false)
        end
    else
        DoorSystemSetDoorState(doorId, isLocked and 1 or 0, false, false)
    end
    doorStates[doorId] = isLocked
end

Citizen.CreateThread(function()
    for doorId, door in pairs(Config.Doors) do
        SetupDoor(doorId, door)
        UpdateDoorState(doorId, door.locked)
    end
end)

RegisterNetEvent('my-doorlock:client:initialize')
AddEventHandler('my-doorlock:client:initialize', function(allDoors)
    for doorId, door in pairs(allDoors) do
        SetupDoor(doorId, door)
        UpdateDoorState(doorId, door.locked)
    end
end)

RegisterNetEvent('my-doorlock:client:updateDoorState')
AddEventHandler('my-doorlock:client:updateDoorState', function(doorId, isLocked)
    UpdateDoorState(doorId, isLocked)
    
    -- Play lock/unlock sound
    local soundFile = isLocked and "door-bolt-4.ogg" or "door-unbolt-2.ogg"
    TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, soundFile, 0.4)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())

        for doorId, door in pairs(Config.Doors) do
            local doorCoords
            if door.doorType == "double" then
                local door1 = door.doors[1].coords
                local door2 = door.doors[2].coords
                doorCoords = (door1 + door2) / 2
            else
                doorCoords = door.coords
            end

            local distance = #(playerCoords - doorCoords)

            if distance < 10.0 then
                local isLocked = doorStates[doorId]
                local lockEmoji = isLocked and "🔒" or "🔓"
                
                local emojiHeight = doorCoords.z + 1.0

                DrawText3D(doorCoords.x, doorCoords.y, emojiHeight, lockEmoji)

                if distance < 2.0 then
                    local doorState = isLocked and "Locked" or "Unlocked"
                    DrawText3D(doorCoords.x, doorCoords.y, emojiHeight - 0.1, door.doorLabel .. " [" .. doorState .. "]")

                    if IsControlJustReleased(0, 38) then -- 'E' key
                        TriggerServerEvent('my-doorlock:server:updateDoorState', doorId)
                    end
                end
            end
        end
    end
end)