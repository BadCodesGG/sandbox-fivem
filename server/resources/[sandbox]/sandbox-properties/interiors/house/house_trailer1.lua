PropertyInteriors = PropertyInteriors or {}

PropertyInteriors["house_trailer1"] = {
    type = "house",
    price = 10000,
    info = {
        name = "Awful Trailer",
        description = "You Don't Want to Live Here",
    },
    locations = {
        front = {
            coords = vector3(1967.145, 3826.450, 13.230),
            heading = 33.134,
            polyzone = {
                center = vector3(1967.31, 3826.06, 13.23),
                length = 0.8,
                width = 1.6,
                options = {
                    heading = 30,
                    --debugPoly=true,
                    minZ = 12.23,
                    maxZ = 14.63
                }
            }
        },
    },
    zone = {
        center = vector3(1966.57, 3828.82, 13.23),
        length = 20.0,
        width = 20.0,
        options = {
            heading = 0,
            --debugPoly=true,
            minZ = 11.23,
            maxZ = 16.43
        }
    },
    defaultFurniture = {
        {
            id = 1,
            name = "Default Storage",
            model = "v_res_tre_storagebox",
            coords = { x = 1968.925, y = 3827.809, z = 12.230 },
            heading = 209.288,
            data = {},
        },
        {
            id = 2,
            name = "Default Bed",
            model = "ex_prop_exec_bed_01",
            coords = { x = 1962.906, y = 3826.679, z = 12.230 },
            heading = 296.765,
            data = {},
        },
    },
    cameras = {
        {
            name = "Trailer",
            coords = vec3(1970.920410, 3832.850342, 14.699047),
            rotation = vec3(-13.973484, 0.000000, 148.085663),
        },
        {
            name = "The \"Bedroom\"",
            coords = vec3(1961.631958, 3827.692383, 14.628222),
            rotation = vec3(-16.729408, 0.000000, 233.833572),
        },
    }
}