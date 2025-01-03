---@diagnostic disable: missing-parameter
local Players = {}
Functions = {}
local adminsOnDuty = {}

local groupExist = function(group)
    for _, v in pairs(Shared.StaffGroups) do 
        if group == v.name then 
            return true 
        end
    end
    return false 
end

local groupLabel = function(group)
    for _, v in pairs(Shared.StaffGroups) do
        if string.match(group, "^%s*(.-)%s*$") == string.match(v.name, "^%s*(.-)%s*$") then
            return v.label
        end
    end
    return "undefined"
end

LoadujJson = function(data)
    local jsonData = LoadResourceFile(GetCurrentResourceName(), "data/" .. data.file .. ".json")
    if jsonData then
        return json.decode(jsonData) or {}
    else
        return {}
    end
end

UpdateJson = function(data)
    SaveResourceFile(GetCurrentResourceName(), "data/" .. data.file .. ".json", json.encode(data.table, { indent = true }), -1)
end

function LoadPlayersData()
    local data = LoadujJson({ file = "players" }) 
    if data then
        Players = data
        GlobalState.Players = Players
    end
end

AddEventHandler("onServerResourceStart", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        LoadPlayersData()  
    end
end)

Functions.getGroup = function(source)
    local player = QBCore.Functions.GetPlayer(source)

    if not player then
        print(string.format("[ERROR] Player not found for source: %d", source))
        return nil
    end

    local identifier = player.PlayerData.citizenid

    if Players[identifier] then
        return Players[identifier]['group']
    else
        print(string.format("[Info] Player with citizenid: %s is not in the players table.", identifier))
        return nil
    end
end

exports('getGroup', Functions.getGroup)

Functions.checkExistence = function(source)
    local player = QBCore.Functions.GetPlayer(source)

    if not player then
        print(string.format("[ERROR] Player not found for source: %d", source))
        return false
    end

    local identifier = player.PlayerData.citizenid

    if Players[identifier] then
        return true  
    end

    print(string.format("[INFO] Player with source %d has not been registered, adding to table.", source))
    return false
end

exports('checkExistence', Functions.checkExistence)

RegisterNetEvent("vule_staff:server:PlayerJoined")
AddEventHandler("vule_staff:server:PlayerJoined", function()
    if source then
        local exist = Functions.checkExistence(source)

        if exist then
            print("Player with ID " .. source .. " already exists, no need to insert.")
            local group = Functions.getGroup(source)
            if group then
                Functions.setGroup(source, group)
                print("Player with ID " .. source .. " has been assigned to group "..group)
            end
        else
            local player = QBCore.Functions.GetPlayer(source)

            if player then
                local identifier = player.PlayerData.citizenid
                print("Player with ID " .. source .. " does not exist, it has just been inserted.")

                local new_user = {
                    identifier = identifier,
                    group = Shared.DefaultGroup['name']
                }

                Players[identifier] = new_user
                GlobalState.Players = Players
                UpdateJson({ file = "players", table = Players })
                local group = Functions.getGroup(source)
                if group then
                    Functions.setGroup(source, group)
                end
            else
                print(string.format("[ERROR] Player with source ID %d was not found during insertion.", source))
            end
        end
    end
end)

Functions.setGroup = function(source, group)

    local player = QBCore.Functions.GetPlayer(source)
    if not player then
        print(string.format("[ERROR] Player with source ID %d was not found when setting group.", source))
        return
    end

    local identifier = player.PlayerData.citizenid

    local lastGroup = Players[identifier] and Players[identifier].group
    if lastGroup and lastGroup ~= group then
        lib.removePrincipal('player.' .. source, 'group.' .. group)
        lib.removeAce('player.' .. source, 'group.' .. group)
    end

    Players[identifier] = { identifier = identifier, group = group }
    GlobalState.Players = Players
    UpdateJson({ file = "players", table = Players })
    if not IsPlayerAceAllowed(source, group) then
      lib.addPrincipal('player.' .. source, 'group.' .. group)
      lib.addAce('player.' .. source, 'group.' .. group)
      print(string.format("[Info] Group for player with ID %d has been set to: %s", source, group))
    end
end

exports('setGroup', Functions.setGroup)

RegisterCommand(Shared.CommandNames['setgroup'], function(source, args)
    if source ~= 0 and not IsPlayerAceAllowed(source, "setgroup") then
        TriggerClientEvent('QBCore:Notify', source, "You do not have permission to use this command.", 'error')
        return
    end

    local targetPlayerId = tonumber(args[1])
    local groupName = args[2]

    if not targetPlayerId or not groupName then
        if source == 0 then
            print("[ERROR] You must specify the target player ID and group. Example: setgroup [playerID] [group]")
        else
            TriggerClientEvent('QBCore:Notify', source, "You must specify the target player ID and group.", 'error')
        end
        return
    end

    local player = QBCore.Functions.GetPlayer(targetPlayerId)

    if not player then
        local errorMsg = string.format("Player with ID %d was not found.", targetPlayerId)
        if source == 0 then
            print(string.format("[ERROR] %s", errorMsg))
        else
            TriggerClientEvent('QBCore:Notify', source, errorMsg, 'error')
        end
        return
    end
    
    if not groupExist(groupName) then
        local errorMsg = string.format("Group %s was not found.", groupName)
        if source == 0 then
            print(string.format("[ERROR] %s", errorMsg))
        else
            TriggerClientEvent('QBCore:Notify', source, errorMsg, 'error')
        end
        return
    end

    Functions.setGroup(targetPlayerId, groupName)

    local successMsg = string.format("Group for player with ID %d has been set to: %s", targetPlayerId, groupName)
    if source == 0 then
        print(string.format("[SUCCESS] %s", successMsg))
    else
        TriggerClientEvent('QBCore:Notify', source, successMsg, 'success')
    end
end)

if Shared.DutySystem then 

    RegisterNetEvent("vule_staff:server:RegisterDuty", function()
        local player = QBCore.Functions.GetPlayer(source)

        if not player then
            print(string.format("[ERROR] Player not found for source: %d", source))
            return
        end
    
        local group = Functions.getGroup(source)
    
        if group then
            local hiddenEnabled = false
            for _, v in pairs(Shared.StaffGroups) do
                if v.name == group and v.enableHidden then
                    hiddenEnabled = true
                    break
                end
            end
            Player(source).state.aduty = false
            Player(source).state.hiddenduty = hiddenEnabled
    
            if hiddenEnabled then
                print(string.format("[INFO] Player with source ID %d has hidden duty enabled for group: %s", source, group))
            else
                print(string.format("[INFO] Player with source ID %d does not have hidden duty enabled for group: %s", source, group))
            end
        else
            print(string.format("[ERROR] Group not found for player with source ID %d", source))
        end
    end)

    RegisterCommand(Shared.CommandNames['aduty'], function(source)
        local group = Functions.getGroup(source)
        if group then
            if groupExist(group) then
                if DutyState(source, 'aduty') then
                    ToggleDuty(source, false)
                    adminsOnDuty[source] = nil 
                    TriggerClientEvent('vule_staff:client:removeGamerTag', -1, source)
                    TriggerClientEvent('QBCore:Notify', source, "Admin duty disabled", 'error')
                else
                    ToggleDuty(source, true)
                    adminsOnDuty[source] = groupLabel(group) 
                    TriggerClientEvent('vule_staff:client:addGamerTag', -1, source, groupLabel(group))
                    TriggerClientEvent('QBCore:Notify', source, "Admin duty enabled", 'success')
                end
            else
                print("[ERROR] Group does not exist.")
            end
        else
            print("[ERROR] Group is nil.")
        end
    end)  

    ToggleDuty = function(source, boolean)
        if source then 
           Player(source).state.aduty = boolean
        end
    end

    exports('ToggleDuty', ToggleDuty)

    DutyState = function(source, type) 
        if source then 
            if type == "aduty" then  
                return Player(source).state.aduty 
            elseif type == "hiddenduty" then 
                return Player(source).state.hiddenduty 
            else
                print("[INFO] This type of duty does not exist!")
            end
         end
    end

    exports('DutyState', DutyState)

    checkDuty = function(source) 
        if source then 
            if DutyState(source, 'aduty') or DutyState(source, 'hiddenduty') then
                return true
            else
                return false
            end
        end
        return false
    end

    exports('checkDuty', checkDuty)
    
end

RegisterNetEvent("playerDropped")
AddEventHandler("playerDropped", function(reason)
    if Shared.DutySystem then 
        adminsOnDuty[source] = nil
        TriggerClientEvent('vule_staff:client:removeGamerTag', -1, source)
    end
end)
