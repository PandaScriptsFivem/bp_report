Actions = {
    ['goto'] = function(source, target)
        local targetped = GetPlayerPed(target)
        local sourceped = GetPlayerPed(source)

        SetEntityCoords(sourceped, GetEntityCoords(targetped), true, false, false, false)
        
        Config.Notify("Report", "a Staff member teleported to you", "info", target)
        sendwebhook({
                title = "BP Report - Goto",
                msg = string.format("**%s** (ID: %d) gotozott id-re\n\n" ..
                    "**Report Írója:** %s\n" ..
                    "**Időpont:** %s",
                    GetPlayerName(source), 
                    source,
                    GetPlayerName(report.id),
                    os.date("%Y.%m.%d %H:%M:%S")
                ),
        }, "goto")
        return true
    end,
    ['bring'] = function(source, target)
        local targetped = GetPlayerPed(target)
        local sourceped = GetPlayerPed(source)

        OldCoords[target] = GetEntityCoords(targetped)

        SetEntityCoords(targetped, GetEntityCoords(sourceped), true, false, false, false)
        
        Config.Notify("Report", "a Staff member brought you", "info", target)
        sendwebhook({
                title = "BP Report - Goto",
                msg = string.format("**%s** (ID: %d) bringelte id-t\n\n" ..
                    "**Report Írója:** %s\n" ..
                    "**Időpont:** %s",
                    GetPlayerName(source), 
                    source,
                    GetPlayerName(report.id),
                    os.date("%Y.%m.%d %H:%M:%S")
                ),
        }, "bring")
        return true
    end,
    ['bringback'] = function(source, target)
        if not OldCoords[target] then
            Config.Notify("Report", "The player is not bringed", "error", source)
            return 
        end

        local targetped = GetPlayerPed(target)
        local sourceped = GetPlayerPed(source)

        SetEntityCoords(targetped, OldCoords[target], true, false, false, false)
        
        Config.Notify("Report", "a Staff member bring back to your old position", "info", target)
        return true
    end
}

function HasPerm(group)
    return Config.AdminPerm[group]
end

function Isadmin(source)
    return Admins[tostring(source)]
end