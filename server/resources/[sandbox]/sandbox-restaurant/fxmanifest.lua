server_script "XP.lua"
client_script "XP.lua"
name("ARP Restaurant")
author("[Cool People Dev Team]")
lua54("yes")
fx_version("cerulean")
game("gta5")
client_script("@sandbox-base/components/cl_error.lua")
client_script("@sandbox-pwnzor/client/check.lua")

client_scripts({
	"client/**/*.lua",
})

server_scripts({
	"configs/config.lua",
	"configs/recipies.lua",
	"configs/restaurants/**/*.lua",
	"server/**/*.lua",
})
