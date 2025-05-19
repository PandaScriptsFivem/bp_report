fx_version 'cerulean'
game 'gta5'
author 'Bandi'
lua54 'yes'

client_script 'client/client.lua'
server_scripts {
    'server/functions.lua',
    'server/server.lua',
    'server/webhook.lua'
}
shared_script 'config.lua'
shared_script '@es_extended/imports.lua'
shared_script '@ox_lib/init.lua'
ui_page 'ui/html.html'

files {
    'ui/*.*'
}

dependencies {
    'oxmysql',
    'es_extended'
}