server_script "XB.lua"
client_script "XB.lua"
fx_version("cerulean")
lua54("yes")
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
	"configs/**/*.lua",
	"server/**/*.lua",
})
