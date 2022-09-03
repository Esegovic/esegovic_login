fx_version "adamant"

game "gta5"

author "esegovic#1337"

lua54 'yes'

client_scripts {
    'settings/*.lua',
    'src/client/*.lua'
}

server_scripts {
    --'@mysql-async/lib/MySQL.lua', ---> Uncomment if you are NOT using ESX Legacy
    '@oxmysql/lib/MySQL.lua', ---> ONLY FOR ESX LEGACY
    'settings/*.lua',
    'src/server/*.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/img/*.jpg',
    'html/img/*.png',
}