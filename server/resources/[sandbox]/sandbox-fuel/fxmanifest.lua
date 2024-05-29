server_script "NE1.lua"
client_script "NE1.lua"
fx_version("cerulean")
lua54("yes")
games({ "gta5" })
client_script("@sandbox-base/components/cl_error.lua")
client_script("@sandbox-pwnzor/client/check.lua")

client_scripts({
	"config.lua",
	"shared/*.lua",
	"client/*.lua",
})

server_scripts({
	"config.lua",
	"shared/*.lua",
	"server/*.lua",
})
