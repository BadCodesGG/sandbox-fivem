PropertyInteriors = PropertyInteriors or {}

PropertyInteriors["house_regular1"] = {
    type = "house",
    price = 280000,
    info = {
        name = "Medium Home #1",
        description = "Nice House",
    },
    locations = {
        front = {
            coords = vector3(509.974, 49.896, -150.807),
            heading = 90.892,
            polyzone = {
                center = vector3(504.43, 1.83, -151.94),
                length = 1.8,
                width = 1.2,
                options = {
                    heading = 0,
                    --debugPoly=true,
                    minZ = -152.94,
                    maxZ = -150.34
                }
            }
        },
    },
    zone = {
        center = vector3(500.61, 3.11, -151.94),
        length = 30.0,
        width =  30.0,
        options = {
            heading = 0,
            --debugPoly=true,
            minZ = -155.54,
            maxZ = -145.14
        }
    },
    defaultFurniture = {
        {
            id = 1,
            name = "Default Storage",
            model = "v_res_tre_storagebox",
            coords = {
                x = 510.271,
                y = 52.009,
                z = -151.807,
            },
            heading = 265.492,
            data = {},
        },
    },
    cameras = {
        {
            name = "Entry / Living Area",
            coords = vec3(504.924255, 48.650532, -149.473358),
            rotation = vec3(-9.648698, 0.000000, 319.852997),
        },
        {
            name = "Kitchen",
            coords = vec3(499.972565, 46.841312, -149.643738),
            rotation = vec3(-9.806101, 0.000000, 356.467133),
        },
        {
            name = "Bedroom #1",
            coords = vec3(510.577728, 48.258812, -149.850159),
            rotation = vec3(-6.656487, 0.000000, 124.223030),
        },
        {
            name = "Bedroom #1 - Ensuite",
            coords = vec3(501.055634, 41.988430, -148.871552),
            rotation = vec3(-32.601372, 0.000000, 320.364777),
        },
        {
            name = "Bedroom #2",
            coords = vec3(496.131653, 47.576546, -150.106079),
            rotation = vec3(-3.307088, 0.000000, 131.742874),
        },
        {
            name = "Bedroom #2 - Closet",
            coords = vec3(500.302490, 41.878819, -148.936523),
            rotation = vec3(-28.858278, 0.000000, 42.254768),
        },
        {
            name = "Bedroom #3",
            coords = vec3(494.974640, 51.550690, -149.986465),
            rotation = vec3(-4.094462, 0.000000, 40.837559),
        },
        {
            name = "Bathroom",
            coords = vec3(494.061218, 48.660671, -149.654419),
            rotation = vec3(-10.984235, 0.000000, 68.750916),
        },
    },
}