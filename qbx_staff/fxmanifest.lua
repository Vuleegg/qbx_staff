fx_version 'cerulean'
game 'gta5'
lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'shared.lua'
}

client_script 'client/*.lua'
server_script 'server/*.lua'

dependency 'ox_lib'
