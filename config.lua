Config = {}

Config.Debug = true

Config.AdminPerm = {
    ["admin"] = true,
    ["owner"] = true
}


Config.Notify = function(title, msg, type, source)
    if not IsDuplicityVersion() then
        lib.notify({
            title = title,
            description = msg,
            type = type
        })
    else
        TriggerClientEvent("ox_lib:notify", source, {
            title = title,
            description = msg,
            type = type
        })
    end
end