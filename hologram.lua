-- Location-based Notifications using bln_notify
-- Displays notifications when players are near specific coordinates

local Config = {
    -- Define your notification zones
    Zones = {
        {
            name = "Dutton County Welcome",
            coords = vector3(-368.48, 736.85, 119.97),
            distance = 10.0,
            messages = {
                "Welcome To Dutton County Wild West RP",
                "Check your Inventory for Guide Book",
                "Discord : https://discord.gg/eayARvRAJe",
                "The County is RP and a Mic is Required"
            },
            showOnce = false,
            lastShown = 0,
            cooldown = 5000 -- Cooldown between notifications in ms
        },
        {
            name = "Controls Help",
            coords = vector3(-366.27, 736.50, 119.91),
            distance = 10.0,
            messages = {
                "Press F6 For Radial Menu",
                "Press I for Inventory",
                "Press N to Talk",
                "Press T to Chat",
                "Press M for Map"
            },
            showOnce = false,
            lastShown = 0,
            cooldown = 5000
        },
        {
            name = "Server Rules",
            coords = vector3(-372.05, 736.48, 119.18),
            distance = 10.0,
            messages = {
                "**VERY IMPORTANT** - This is REDM RP not RDO",
                "In towns do not pull out your Gun",
                "or Random Kill Players Or Peds, Unless part",
                "of RP and a Dual must be offered within voice chat.",
                "Failure to do so will result in warning and then a Ban"
            },
            showOnce = false,
            lastShown = 0,
            cooldown = 5000
        },
        {
            name = "Horse Purchase Guide",
            coords = vector3(-375.43, 786.56, 116.18),
            distance = 10.0,
            messages = {
                "To Buy a Horse or Wagon, Look at the Horse",
                "Press Left Alt to use Target Menu",
                "Goto Horse Dealer, View and Set as Main Horse",
                "Go outside, whistle Horse using -H- and bring",
                "horse back inside, get off and visit the Horse Dealer",
                "to customize your horse and saddle"
            },
            showOnce = false,
            lastShown = 0,
            cooldown = 5000
        }
    }
}

-- Track which zones the player has been notified in
local playersInZone = {}

-- Check if bln_notify is available
local function IsBLNNotifyAvailable()
    return GetResourceState("bln_notify") == "started"
end

-- Send notification using bln_notify
local function SendNotification(title, message)
    if not IsBLNNotifyAvailable() then
        print("^1Error: bln_notify resource is not started^7")
        return
    end

    TriggerEvent("bln_notify:send", {
        title = title,
        message = message,
        duration = 5000,
        placement = 'middle-left',
        icon = 'info'
    }, "INFO")
end

-- Main thread for zone detection
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500) -- Check every 500ms to reduce CPU load

        local playerPed = PlayerPedId()
        if playerPed ~= 0 then
            local playerCoords = GetEntityCoords(playerPed)

            for zoneIndex, zone in ipairs(Config.Zones) do
                local distance = #(playerCoords - zone.coords)

                -- Check if player is within zone
                if distance < zone.distance then
                    local currentTime = GetGameTimer()
                    
                    -- Only show notification if cooldown has passed
                    if (currentTime - zone.lastShown) > zone.cooldown then
                        -- Display all messages for this zone
                        for messageIndex, message in ipairs(zone.messages) do
                            Citizen.Wait(100) -- Small delay between each message
                            SendNotification(zone.name, message)
                        end
                        zone.lastShown = currentTime
                    end
                else
                    -- Reset zone if player leaves
                    if not playersInZone[zoneIndex] then
                        playersInZone[zoneIndex] = false
                    end
                end
            end
        end
    end
end)

-- Optional: Command to test notifications
RegisterCommand('testnoti', function(source, args, rawCommand)
    if IsBLNNotifyAvailable() then
        SendNotification("Test Notification", "This is a test message from hologram.lua")
    else
        print("^1bln_notify is not started^7")
    end
end, false)
