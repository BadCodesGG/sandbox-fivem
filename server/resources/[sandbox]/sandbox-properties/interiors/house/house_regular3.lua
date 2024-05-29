PropertyInteriors = PropertyInteriors or {}

PropertyInteriors["house_regular3"] = {
    type = "house",
    price = 301000,
    info = {
        name = "Medium Home #3",
        description = "Modern House With Loft Area",
    },
    locations = {
        front = {
            coords = vector3(494.606, 103.088, -151.956),
            heading = 271.943,
            polyzone = {
                center = vector3(493.37, 103.06, -151.96),
                length = 2.0,
                width = 2.0,
                options = {
                    heading = 0,
                    --debugPoly=true,
                    minZ = -152.96,
                    maxZ = -150.16
                }
            }
        },
    },
    zone = {
        center = vector3(500.29, 102.21, -151.96),
        length = 30.0,
        width =  30.0,
        options = {
            heading = 0,
            --debugPoly=true,
            minZ = -155.56,
            maxZ = -145.16
        }
    },
    defaultFurniture = {
        {
            id = 1,
            name = "Default Storage",
            model = "v_res_tre_storagebox",
            coords = {
                x = 495.838,
                y = 105.341,
                z = -152.956,
            },
            heading = 270.577,
            data = {},
        },
    },
    cameras = {
        {
            name = "Kitchen",
            coords = vec3(495.692139, 102.154533, -150.484818),
            rotation = vec3(-13.929790, 0.000000, 323.010498),
        },
        {
            name = "Bedroom",
            coords = vec3(500.144714, 101.431015, -151.063950),
            rotation = vec3(-5.937662, 0.000000, 223.483154),
        },
        {
            name = "Bathroom",
            coords = vec3(507.783325, 103.912910, -150.224976),
            rotation = vec3(-24.914047, 0.000000, 158.286362),
        },
        {
            name = "Main Living Area",
            coords = vec3(499.169373, 103.312080, -151.398300),
            rotation = vec3(-1.850404, 0.000000, 157.932007),
        },
        {
            name = "Main Living Area",
            coords = vec3(499.151367, 90.651909, -149.728348),
            rotation = vec3(-13.070859, 0.000000, 22.223171),
        },
        {
            name = "Main Living Area - Loft",
            coords = vec3(499.436310, 101.550316, -147.601807),
            rotation = vec3(-12.834652, 0.000000, 150.963303),
        },
    },
}