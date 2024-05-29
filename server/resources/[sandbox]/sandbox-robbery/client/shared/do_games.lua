_lpStage = 0
_seqPass = 1
_scramPass = 1
_memPass = 1
_capPass = 1

local stageComplete = 0
function DoLockpick(data, base, cb)
	local size = 10 - (stageComplete * 2)
	if size <= 1 then
		size = 2
	end

	Minigame.Play:RoundSkillbar(base + (0.2 * stageComplete), size, {
		onSuccess = function()
			Citizen.Wait(400)

			if stageComplete >= (data.stages or 3) then
				stageComplete = 0
				cb(true)
			else
				stageComplete += 1
				DoLockpick(data, base, cb)
			end
		end,
		onFail = function()
			stageComplete = 0
			cb(false)
		end,
	}, {
		useWhileDead = false,
		vehicle = false,
		animation = {
			animDict = "veh@break_in@0h@p_m_one@",
			anim = "low_force_entry_ds",
			flags = 16,
		},
	})
end

function DoSequence(passes, config, data, cb)
	Minigame.Play:Sequencer(
		config.countdown or 3,
		config.preview or 300,
		(config.timer or 10000) - ((config.passReduce or 500) * _seqPass),
		(config.base or 5) + _seqPass,
		config.isMasked,
		{
			onSuccess = function(data)
				if _seqPass < passes then
					_seqPass += 1
					DoSequence(passes, config, data, cb)
				else
					cb(true, data)
				end
			end,
			onFail = function(data)
				cb(false, data)
			end,
		},
		{
			playableWhileDead = false,
			animation = config.anim,
		},
		data
	)
end

function DoMemory(passes, config, data, cb)
	Minigame.Play:Memory(
		config.countdown or 3,
		config.preview or 3000,
		config.timer - ((config.passReduce or 300) * _memPass),
		config.cols or 5,
		config.rows or 5,
		(config.base or 5) + _memPass,
		config.strikes or 3,
		{
			onSuccess = function(data)
				if _memPass < passes then
					_memPass += 1
					DoMemory(passes, config, data, cb)
				else
					cb(true, data)
				end
			end,
			onFail = function(data)
				cb(false, data)
			end,
		},
		{
			playableWhileDead = false,
			animation = config.anim,
		},
		data
	)
end

function DoCaptcha(passes, config, data, cb)
	Minigame.Play:Captcha(
		config.countdown or 3,
		config.timer or 1500,
		config.limit - ((config.passReduce or 1000) * _capPass),
		config.difficulty or 4,
		config.difficulty2 or 2,
		{
			onSuccess = function(data)
				if _capPass < passes then
					_capPass += 1
					Citizen.Wait(1500)
					DoCaptcha(passes, config, data, cb)
				else
					cb(true, data)
				end
			end,
			onFail = function(data)
				cb(false, data)
			end,
		},
		{
			playableWhileDead = false,
			animation = config.anim,
		},
		data
	)
end

function DoAim(config, data, cb)
	Minigame.Play:Aim(
		config.countdown or 3,
		config.limit or 15750,
		config.timer or 1000,
		config.startSize or 25,
		config.maxSize or 75,
		config.growthRate or 15,
		config.accuracy or 50,
		config.isMoving or false,
		{
			onSuccess = function(data)
				cb(true, data)
			end,
			onPerfect = function(data)
				cb(true, data, true)
			end,
			onFail = function(data)
				cb(false, data)
			end,
		},
		{
			playableWhileDead = false,
			animation = config.anim,
		},
		data
	)
end

function DoKeymaster(config, data, cb)
	Minigame.Play:Keymaster(
		config.countdown or 3,
		config.timer or { 2000, 4000 },
		config.limit or 40000,
		config.difficulty or 3,
		config.chances or 5,
		config.isShuffled or false,
		{
			onSuccess = function(data)
				cb(true, data)
			end,
			onFail = function(data)
				cb(false, data)
			end,
		},
		{
			playableWhileDead = false,
			animation = config.anim,
		},
		data
	)
end

function DoTracking(config, data, cb)
	Minigame.Play:Tracking(config.countdown or 3, config.delay or 2500, config.limit or 20000, config.difficulty or 5, {
		onSuccess = function(data)
			cb(true, data)
		end,
		onFail = function(data)
			cb(false, data)
		end,
	}, {
		playableWhileDead = false,
		animation = config.anim,
	}, data)
end

function DoIcons(config, data, cb)
	Minigame.Play:Icons(
		config.countdown or 3,
		config.timer or 5,
		config.limit or 7500,
		config.delay or 1500,
		config.difficulty or 4,
		config.chances or 4,
		{
			onSuccess = function(data)
				cb(true, data)
			end,
			onFail = function(data)
				cb(false, data)
			end,
		},
		{
			playableWhileDead = false,
			animation = config.anim,
		},
		data
	)
end

function DoDrill(data, cb)
	Minigame.Play:Drill({
		onSuccess = function(data)
			cb(true, data)
		end,
		onFail = function(data)
			cb(false, data)
		end,
	}, data)
end

function DoScrambler(passes, base, strikes, data, cb)
	Minigame.Play:Scrambler(
		3,
		4000,
		14000 + ((_scramPass or 1) * 4000),
		strikes or 2,
		(base or 12) + (_scramPass * 4),
		{
			onSuccess = function(data)
				if _scramPass < passes then
					_scramPass += 1
					DoScrambler(passes, base, strikes, data, cb)
				else
					cb(true, data)
				end
			end,
			onFail = function(data)
				cb(false, data)
			end,
		},
		{
			useWhileDead = false,
			vehicle = false,
			controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			},
			animation = {
				animDict = "amb@prop_human_atm@male@idle_a",
				anim = "idle_b",
				flags = 49,
			},
		},
		data
	)
end