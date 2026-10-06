-- Location-based Notifications using bln_notify
-- Displays notifications when players are near specific coordinates

local activeNotifications = {} -- Track active zone notifications
local notificationTimers = {} -- Track notification timers for closing
local myZoneCooldowns = {} -- Track THIS client's zone cooldowns (20 minutes)

-- Check if bln_notify is available
local function IsBLNNotifyAvailable()
    return GetResourceState("bln_notify") == "started"
end

-- Combine all messages into a single string with line breaks
local function CombineMessages(messages)
    return table.concat(messages, "\n")
end

-- Send notification using bln_notify
local function SendNotification(title, description)
    if not IsBLNNotifyAvailable() then
        -- print("^1Error: bln_notify resource is not started^7")
        return
    end

    local options = {
        title = title,
        description = description, -- Use 'description' not 'message'
        duration = Config.NotificationSettings.duration,
        placement = Config.NotificationSettings.placement,
        icon = Config.NotificationSettings.icon
    }
    
    -- print("^2mack-notices: Triggering bln_notify:send event^7")
    -- Trigger bln_notify's event properly
    TriggerEvent("bln_notify:send", options)
end

-- Remove notification by closing the current zone notification
local function RemoveNotification(zoneIndex)
    activeNotifications[zoneIndex] = nil
    if notificationTimers[zoneIndex] then
        notificationTimers[zoneIndex] = nil
    end
end

-- Main thread for zone detection
Citizen.CreateThread(function()
    -- print("^2mack-notices: Zone detection thread started^7")
    -- print("^2mack-notices: Loaded " .. #Config.Zones .. " zones^7")
    -- print("^2mack-notices: bln_notify status: " .. GetResourceState("bln_notify") .. "^7")
    
    while true do
        Citizen.Wait(100) -- Check frequently for accurate distance detection

        local playerPed = PlayerPedId()
        if playerPed ~= 0 then
            local playerCoords = GetEntityCoords(playerPed)

            for zoneIndex, zone in ipairs(Config.Zones) do
                local distance = #(playerCoords - zone.coords)
                local isInZone = distance < zone.distance -- Use distance from config
                local currentTime = GetGameTimer()

                -- Initialize cooldown for this zone if needed
                if not myZoneCooldowns[zoneIndex] then
                    myZoneCooldowns[zoneIndex] = 0
                end

                -- Show notification when within zone radius
                if isInZone then
                    -- print("^3mack-notices: Player in zone '" .. zone.name .. "' (distance: " .. string.format("%.2f", distance) .. "m)^7")
                    
                    -- Check if cooldown has expired (20 minutes = 1200000 ms)
                    local lastShown = myZoneCooldowns[zoneIndex]
                    local cooldownTime = 1200000 -- 20 minutes in milliseconds
                    local timeSinceLastShown = currentTime - lastShown
                    
                    if timeSinceLastShown > cooldownTime then
                        -- print("^2mack-notices: Showing notification for '" .. zone.name .. "'^7")
                        local combinedMessage = CombineMessages(zone.messages)
                        SendNotification(zone.name, combinedMessage)
                        myZoneCooldowns[zoneIndex] = currentTime -- Set cooldown timer
                    else
                        local timeRemaining = math.ceil((cooldownTime - timeSinceLastShown) / 60000)
                        -- print("^1mack-notices: Zone '" .. zone.name .. "' on cooldown (" .. timeRemaining .. " minutes remaining)^7")
                    end
                end
            end
        end
    end
end)

-- Clear all active notifications when resource stops
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        -- Clear all notification tracking
        activeNotifications = {}
        notificationTimers = {}
        myZoneCooldowns = {}
        -- print("^2mack-notices: All notifications and cooldowns cleared on resource stop^7")
    end
end)

-- Optional: Command to test notifications
RegisterCommand('testnoti', function(source, args, rawCommand)
    if IsBLNNotifyAvailable() then
        local testDescription = "This is a test notification\nAll messages appear together\nIn one notification box"
        SendNotification("Test Notification", testDescription)
    else
        -- print("^1bln_notify is not started^7")
    end
end, false)

-- Command to clear all cooldowns for current player
RegisterCommand('clearcooldowns', function(source, args, rawCommand)
    myZoneCooldowns = {}
    -- print("^2mack-notices: All zone cooldowns cleared^7")
end, false)
