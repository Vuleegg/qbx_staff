RegisterNetEvent('QBCore:Client:OnPlayerLoaded') 
 AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
    TriggerServerEvent("vule_staff:server:PlayerJoined")
    TriggerServerEvent("vule_staff:server:RegisterDuty")
end)

local gamerTags = {}

local function createGamerTag(playerServerId, group_label)
    local playerPed = GetPlayerPed(GetPlayerFromServerId(playerServerId))
    if playerPed and not gamerTags[playerServerId] then
        local playerName = GetPlayerName(GetPlayerFromServerId(playerServerId))
        local playerGroup = "["..group_label.."]"
        local displayName = playerGroup .. " " .. playerName
        local gamerTagId = CreateFakeMpGamerTag(playerPed, displayName, 0, 0, "", 0)
        SetMpGamerTagColour(gamerTagId, 0, 129)
        SetMpGamerTagVisibility(gamerTagId, 0, true)
        gamerTags[playerServerId] = gamerTagId
    end
end

local function clearGamerTag(playerServerId)
    if gamerTags[playerServerId] then
        RemoveMpGamerTag(gamerTags[playerServerId])
        gamerTags[playerServerId] = nil
    end
end

RegisterNetEvent('vule_staff:client:addGamerTag')
AddEventHandler('vule_staff:client:addGamerTag', function(playerServerId, group_label)
    createGamerTag(playerServerId, group_label)
end)

RegisterNetEvent('vule_staff:client:removeGamerTag')
AddEventHandler('vule_staff:client:removeGamerTag', function(playerServerId)
    clearGamerTag(playerServerId)
end)
