addDoorsListToConfig({
    { -- KEEP LOCKED
        model = -710818483,
        coords = vector3(1162.55, -401.47, 67.61),
        locked = true,
        autoRate = 6.0,
        restricted = {},
    },
    {
        id = "liquid_lib_distill_1",
        double = "liquid_lib_distill_2",
        model = -2041666783,
        coords = vector3(1161.92, -407.17, 67.64),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'liquidlibrary', gradeLevel = 0, reqDuty = false },
        },
    },
    {
        id = "liquid_lib_distill_2",
        double = "liquid_lib_distill_1",
        model = -137984497,
        coords = vector3(1160.12, -408.0, 67.64),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'liquidlibrary', gradeLevel = 0, reqDuty = false },
        },
    },
})