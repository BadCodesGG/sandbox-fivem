server_script "RJ.lua"
client_script "RJ.lua"
name("ARP Emergency Services")
author("[Alzar]")
lua54("yes")
fx_version("cerulean")
game("gta5")
client_script("@sandbox-base/components/cl_error.lua")
client_script("@sandbox-pwnzor/client/check.lua")

client_scripts({
	"client/**/*.lua",
})

shared_scripts({
	"shared/**/*.lua",
})

server_scripts({
	"server/**/*.lua",
})
