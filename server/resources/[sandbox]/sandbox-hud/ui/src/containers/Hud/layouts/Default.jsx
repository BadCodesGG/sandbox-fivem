import React, { useCallback, useState } from 'react';
import { useSelector } from 'react-redux';
import { Fade } from '@mui/material';
import { makeStyles } from '@mui/styles';

import { Location } from '../../../components';
import {
    Minimalistic,
    Default as VehicleDefault,
    Simple as VehicleSimple,
} from '../../../components/Vehicle';
import { Default as Status } from '../../../components/Status';
import { Default as Buffs } from '../../../components/Buffs';

const useStyles = makeStyles((theme) => ({
    wrapper: {
        position: 'relative',
        height: '100%',
        width: '100%',
    },
    shifted: {
        position: 'absolute',
        height: 'fit-content',
    },
    standard: {
        position: 'absolute',
        left: '1.35%',
        height: 'fit-content',
    },
}));

export default () => {
    const classes = useStyles();
    const showing = useSelector((state) => state.hud.showing);

    const config = useSelector((state) => state.hud.config);
    const position = useSelector((state) => state.hud.position);
    const isShifted = useSelector((state) => state.location.shifted);
    const inVeh = useSelector((state) => state.vehicle.showing);

    const statuses = useSelector((state) => state.status.statuses);
    const buffDefs = useSelector((state) => state.status.buffDefs);
    const buffs = useSelector((state) => state.status.buffs);
    const [height, setHeight] = useState(0);
    const shittyReact = useCallback(
        (node) => {
            if (node !== null) {
                setHeight(node.getBoundingClientRect().height);
            }
        },
        [statuses, config, position, buffDefs, buffs],
    );

    const getVehicleLayout = () => {
        switch (config.vehicle) {
            case 'simple':
                return <VehicleSimple />;
            case 'minimal':
                return <Minimalistic />;
            default:
                return <VehicleDefault />;
        }
    };

    return (
        <Fade in={showing}>
            <div className={classes.wrapper}>
                <div
                    ref={shittyReact}
                    className={
                        isShifted || inVeh ? classes.shifted : classes.standard
                    }
                    style={
                        isShifted || inVeh
                            ? {
                                  left: `${(position.rightX + 0.0055) * 100}vw`,
                                  top: `calc(${
                                      position.bottomY * 100
                                  }vh - ${height}px)`,
                              }
                            : {
                                  left: `${(position.leftX + 0.0045) * 100}vw`,
                                  top: `calc(${
                                      position.bottomY * 100
                                  }vh - ${height}px)`,
                              }
                    }
                >
                    <Status />
                    <Location />
                </div>
                <Buffs />
                {getVehicleLayout()}
            </div>
        </Fade>
    );
};
