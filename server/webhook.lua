local webhookURL = "https://ptb.discord.com/api/webhooks/1327974296940843068/vSCFRlmF_R8MEx0NASTzzxPEYfnzdDkBEejU76YEI40fv7ePzNPCwRK4EunGCSixOmyh"

function sendwebhook(data, type)
    local connect = {}
    if type == "goto" then
        connect = {
            {
                ["color"] = "3319890",
                ["title"] = data.title ,
                ["description"] = data.msg,
                ["footer"] = {
                    ["text"] = "BP Report - "..os.date("%Y.%m.%d %H:%M:%S")
                }
            }
        }
    elseif type == "close" then
        connect = {
            {
                ["color"] = "14365491",
                ["title"] = data.title ,
                ["description"] = data.msg,
                ["footer"] = {
                    ["text"] = "BP Report - "..os.date("%Y.%m.%d %H:%M:%S")
                }
            }
        }
    elseif type == "bring" then
        connect = {
            {
                ["color"] = "3319890",
                ["title"] = data.title ,
                ["description"] = data.msg,
                ["footer"] = {
                    ["text"] = "BP Report - "..os.date("%Y.%m.%d %H:%M:%S")
                }
            }
        }
    end
    PerformHttpRequest(webhookURL, function(err, text, headers) end, 
    'POST', json.encode({username = "Report", embeds = connect}), 
    { ['Content-Type'] = 'application/json' })
end
