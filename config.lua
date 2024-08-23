Config = {}

Config.Doors = {
    -- Single door
    [1] = {
        doorType = "door",
        model = -1116041313,
        coords = vector3(127.96, -1298.50, 29.42),
        locked = false,
        doorLabel = "Vanilla Unicorn Front Door"
    },
    -- Double door
    [2] = {
        doorType = "double",
        doorLabel = "MRPD Main Entrance",
        locked = true,
        doors = {
            {model = -1547307588, coords = vector3(434.74, -980.76, 30.82)},
            {model = -1547307588, coords = vector3(434.74, -983.08, 30.82)},
        }
    },
    -- Sliding door
    [3] = {
        doorType = "sliding",
        model = -1603817716,
        coords = vector3(254.1, 224.3, 101.9),
        locked = true,
        doorLabel = "Bank Vault"
    },
    -- Garage door
    [4] = {
        doorType = "garage",
        model = 741314661,
        coords = vector3(431.4, -1000.8, 26.7),
        locked = true,
        doorLabel = "Police Garage"
    },
    -- Gate
    [5] = {
        doorType = "gate",
        model = -1603817716,
        coords = vector3(1844.9, 2604.8, 44.6),
        locked = true,
        doorLabel = "Prison Main Gate"
    }
}

Config.PermissionName = "doorlock.access" -- ACE permission name