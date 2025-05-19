local webhookURL = ""

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
