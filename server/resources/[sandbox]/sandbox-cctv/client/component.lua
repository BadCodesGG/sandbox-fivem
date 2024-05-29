createdCamera = 0
globalWait = 10
globalCamera = 0
hacking = false
inCamera = false
low = "CAMERA_secuirity"
offlineCam = "Broken_camera_fuzz"

local cameraActive = false
local allowedToSwitch = false
local currentCameraIndex = 0
local currentCameraIndexIndex = 0
local currentTimecycle = nil
local offline = false
local canrotate = false

AddEventHandler("Sync:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Callbacks = exports["sandbox-base"]:FetchComponent("Callbacks")
	Keybinds = exports["sandbox-base"]:FetchComponent("Keybinds")
	CCTV = exports["sandbox-base"]:FetchComponent("CCTV")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("CCTV", {
		"Callbacks",
		"Keybinds",
		"CCTV",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		RetrieveComponents()
		RegisterKeyBinds()
	end)
end)

_CCTV = {
	View = function(self, camId)
		local camKey = string.format("CCTV:Camera:%s", camId)
		EnterCam(camId)
	end,
	Close = function(self)
		if LocalPlayer.state.inCCTVCam then
			ExitCam()
		end
	end,
}

AddEventHandler("Proxy:Shared:RegisterReady", function(component)
	exports["sandbox-base"]:RegisterComponent("CCTV", _CCTV)
end)
