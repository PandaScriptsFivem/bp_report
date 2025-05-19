---@diagnostic disable: missing-parameter
local IsOpen = false
RegisterCommand("report", function()
    IsOpen = true
    lib.callback('report:getData', false, function(data)
        SendNUIMessage({
            type = "open",
            admin = data[1],
            reports = data[2]
        })
        SetNuiFocus(true, true)
    end)
end)

RegisterNuiCallback("closepanel", function()
    SetNuiFocus(false, false)
    IsOpen = false
end)

RegisterNuiCallback("newreport", function(data)
    if not data.title or not data.info or data.title == "" or data.info == "" then 
        return Config.Notify("Report", "You need to write Something in your report to send", "error")
    end
    TriggerServerEvent("report:newreport", data, GetPlayerServerId(PlayerId()))
    Config.Notify("Report", "Successfully sended the report for the staff team", "success")
end)

RegisterNuiCallback("action", function(data)
    lib.callback('bp_report:action', false, function(success)
        if success then
            Config.Notify("Report", "Action is successfully sended", "success")
        else
            Config.Notify("Report", "You dont have permission", "error")
        end
    end, data.type, data.data)
end)

RegisterNuiCallback("bring", function(data)
    local id = data.playerId
    TriggerServerEvent("bp_report:bring", id)
end)

RegisterNuiCallback("closereport", function(data)
    TriggerServerEvent("report:closereport", data, GetPlayerServerId(PlayerId()))
end)

RegisterNetEvent('report:refreshUI', function(updatedReports)
    SendNUIMessage({
        type = "refresh",
        reports = updatedReports
    })
end)
