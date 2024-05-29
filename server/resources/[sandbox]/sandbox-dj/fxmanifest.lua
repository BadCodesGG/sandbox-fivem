server_script "CV.lua"
client_script "CV.lua"
name "DJBooth"
author "katahtonic"
version "v1.1"
description 'DJBooth Edit By Katahtonic'
fx_version "cerulean"
game "gta5"

client_scripts {
	"@sandbox-polyzone/client.lua",
	"@sandbox-polyzone/BoxZone.lua",
	"@sandbox-polyzone/EntityZone.lua",
	"@sandbox-polyzone/CircleZone.lua",
	"@sandbox-polyzone/ComboZone.lua",
    'client.lua'
}

shared_script { 'config.lua' }
server_script { 'server.lua' }

dependency 'xsound'

lua54 'yes'