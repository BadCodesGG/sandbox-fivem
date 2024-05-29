PropertyInteriors = PropertyInteriors or {}

PropertyInteriors["house_regular2"] = { -- Has 2 Stories
    type = "house",
    price = 300000,
    info = {
        name = "Medium Home #2",
        description = "Nice House with an Upstairs",
    },
    locations = {
        front = {
            coords = vector3(503.800, 1.772, -151.939),
            heading = 90.683,
            polyzone = {
                center = vector3(510.93, 49.93, -150.81),
                length = 1.6,
                width = 1.0,
                options = {
                    heading = 0,
                    --debugPoly=true,
                    minZ = -151.81,
                    maxZ = -149.21
                }
            }
        },
    },
    zone = {
        center = vector3(501.14, 47.75, -150.81),
        length = 25.0,
        width =  25.0,
        options = {
            heading = 0,
            --debugPoly=true,
            minZ = -153.21,
            maxZ = -148.01
        }
    },
    defaultFurniture = {
        {
            id = 1,
            name = "Default Storage",
            model = "v_res_tre_storagebox",
            coords = {
                x = 510.185,
                y = 51.801,
                z = -151.807,
            },
            heading = 88.096,
            data = {},
        },
    },
    cameras = {
        {
            name = "Entry",
            coords = vec3(497.772614, -1.370482, -150.535675),
            rotation = vec3(-8.015543, 0.000000, 319.882446),
        },
        {
            name = "Downstairs Bedroom",
            coords = vec3(501.119202, -0.887051, -151.099594),
            rotation = vec3(-9.511607, 0.000000, 228.386261),
        },
        {
            name = "Downstairs Bedroom - Ensuite",
            coords = vec3(497.706512, -6.755786, -150.649582),
            rotation = vec3(-16.811047, 0.000000, 320.748596),
        },
        {
            name = "Kitchen Area",
            coords = vec3(493.174744, 6.708445, -150.535812),
            rotation = vec3(-10.669325, 0.000000, 203.740952),
        },
        {
            name = "Upstairs Hallway",
            coords = vec3(501.289795, -2.593517, -147.411438),
            rotation = vec3(-15.511848, 0.000000, 5.945491),
        },
        {
            name = "Upstairs Bedroom #1",
            coords = vec3(497.481720, 0.689970, -147.973907),
            rotation = vec3(-9.370115, 0.000000, 52.756584),
        },
        {
            name = "Upstairs Bedroom #2",
            coords = vec3(500.624420, -6.807791, -147.385513),
            rotation = vec3(-13.897679, 0.000000, 49.095150),
        },
        {
            name = "Closet",
            coords = vec3(504.831696, 2.715285, -147.546326),
            rotation = vec3(-30.275640, 0.000000, 200.315659),
        },
        {
            name = "Bathroom",
            coords = vec3(506.680969, -6.576989, -147.444046),
            rotation = vec3(-17.677210, 0.000000, 35.670044),
        },
    },
}