Report = {}
Admins = {}
OldCoords = {}

local nextReportId = 1

----- ADMINS MANAGEMENT ------

AddEventHandler('onResourceStart', function(resourceName)
  if (GetCurrentResourceName() ~= resourceName) then
    return
  end

  local xPlayers = ESX.GetExtendedPlayers()
 
    for i, xPlayer in ipairs(xPlayers) do
        if HasPerm(xPlayer.group) then
            Admins[tostring(xPlayer.source)] = true
        end
    end

    print(json.encode(Admins))
end)

RegisterNetEvent('esx:setGroup')
AddEventHandler('esx:setGroup', function(source, group, lastGroup)
    if Admins[tostring(source)] and not not HasPerm(group) then
        Admins[tostring(source)] = nil
    end
end)

AddEventHandler('esx:playerLoaded', function (playerId, xPlayer, isNew)
    if HasPerm(xPlayer.group) then
        Admins[tostring(playerId)] = true
    end
end)

AddEventHandler('esx:playerDropped', function (playerId)
    if Admins[tostring(source)] then
        Admins[tostring(source)] = nil
    end
end)

-------------------------------

RegisterServerEvent("report:newreport", function(data, player)
    table.insert(Report, {
        id = player,
        reportId = nextReportId,  
        title = data.title,
        info = data.info,
        name = GetPlayerName(player)
    })

    TriggerClientEvent('report:refreshUI', -1, Report)

    for source, v in pairs(Admins) do
        Config.Notify("New Report", "Check the Reports for the Informations /report", "info", source)
    end

    nextReportId = nextReportId + 1 
end)

RegisterServerEvent("report:closereport", function(reportId)
    if not Isadmin(source) then return end
    for i, report in ipairs(Report) do
        if report.reportId == reportId.reportId then
            Config.Notify("Report", "One of our Staff team members are closed your report", "info", report.id)
            sendwebhook({
                title = "BP Report - Close",
                msg = string.format("**%s** (ID: %d) bezárta #%d report id-t\n\n" ..
                    "**Report Írója:** %s\n" ..
                    "**Időpont:** %s",
                    GetPlayerName(source), 
                    source,
                    report.reportId, 
                    GetPlayerName(report.id),
                    os.date("%Y.%m.%d %H:%M:%S")
                ),
            }, "close")
            table.remove(Report, i)
            break
        end
    end
    TriggerClientEvent('report:refreshUI', -1, Report)
end)

-- DEBUG 
--[[
RegisterCommand("spammreport", function(source, args)
    local count = tonumber(args[1]) or 1
    local randomNames = {"Pandateam", "Bandi", "SpookyHell", "CsakEgyWarii", "hBalint", "NightTerror", "Kristof"}
    local randomTitles = {"Player hacking", "RDM", "VDM", "Cheating", "Exploiting", "Spamming", "Bad RP"}
    
    Report = Report or {}
    
    for i = 1, count do
        local randomId = math.random(1, 1000)
        local randomName = randomNames[math.random(#randomNames)]
        
        table.insert(Report, {
            id = randomId,
            reportId = nextReportId, 
            title = randomTitles[math.random(#randomTitles)],
            info = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed pulvinar turpis in elit eleifend fringilla. Duis venenatis odio nec volutpat scelerisque. Duis et risus ac nisl egestas volutpat. Vivamus fermentum accumsan dui a facilisis. Curabitur eleifend risus vel ligula auctor ultrices. Nullam cursus, neque ac sollicitudin viverra, justo urna dignissim odio, sed pharetra risus elit id ligula. Vestibulum volutpat, urna at pellentesque tempor, nisi justo mollis purus, ac dapibus nibh lectus at nunc. Quisque aliquet luctus purus, nec mollis est. Mauris ullamcorper justo nec purus laoreet, id molestie tortor pharetra. Aenean iaculis magna nec tortor dapibus eleifend. Suspendisse quis massa maximus, eleifend sem in, imperdiet diam. Interdum et malesuada fames ac ante ipsum primis in faucibus. Donec arcu ante, sollicitudin sed imperdiet vitae, gravida a ligula. Morbi faucibus vestibulum risus, in tempus turpis viverra at.",
            name = randomName
        })
        nextReportId = nextReportId + 1
    end
    
    TriggerClientEvent('chat:addMessage', source, { args = { '^1[REPORT]', 'Created ' .. count .. ' random reports' } })
end, false)
]]--
-- DEBUG

lib.callback.register('report:getData', function(source)
    return {Isadmin(source), Report}
end)

function RefreshAllClients()
    TriggerClientEvent('report:refreshUI', -1, Report)
end

lib.callback.register('bp_report:action', function(source, type, target)
    if not Isadmin(source) then 
        Config.Notify("Report", "You are not an admin", "error", source)    
        return false
    end

    return Actions[type](source, target)
end)