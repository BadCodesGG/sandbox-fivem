import React, { useState, useEffect, Fragment } from 'react';
import { useSelector } from 'react-redux';
import { Fade, useTheme } from '@mui/material';
import { makeStyles } from '@mui/styles';
import ReactHtmlParser from 'react-html-parser';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import {
    CircularProgressbarWithChildren,
    buildStyles,
} from 'react-circular-progressbar';

const useStyles = makeStyles((theme) => ({
    wrapper: {
        position: 'absolute',
        display: 'flex',
        left: 0,
        right: 0,
        bottom: 50,
        margin: 'auto',
        width: 'fit-content',
        filter: `drop-shadow(0 0 2px ${theme.palette.secondary.dark}e0)`,
        fontSize: 30,
        color: theme.palette.text.main,
        textAlign: 'center',
        height: 125,
        width: 125,
    },
    fuelGauge: {
        position: 'absolute',
        height: 125,
        width: 125,
        left: -20,
        top: 0,
    },
    fuelIcon: {
        fontSize: 12,
        position: 'absolute',
        bottom: 5,
        left: 22,
    },
    nosGauge: {
        position: 'absolute',
        height: 125,
        width: 125,
        right: -20,
        top: 0,
    },
    nosIcon: {
        fontSize: 12,
        position: 'absolute',
        bottom: 5,
        right: 22,
    },
    speed: {
        fontSize: 40,
        lineHeight: '30PX',

        '& small': {
            fontSize: 16,
            display: 'block',
        },
    },
    off: {
        fontSize: 18,
        color: theme.palette.text.alt,
    },
    checkEngine: {
        width: 'fit-content',
        height: 'fit-cotnent',
        position: 'absolute',
        bottom: 0,
        fontSize: 18,
        color: theme.palette.error.light,
        animation: 'flash linear 1s infinite',
    },
    seatBelt: {
        width: 'fit-content',
        height: 'fit-cotnent',
        position: 'absolute',
        top: -20,
        right: 10,
        fontSize: 18,
        color: theme.palette.warning.light,
        animation: 'flash linear 3s infinite',
    },
    cruise: {
        width: 'fit-content',
        height: 'fit-cotnent',
        position: 'absolute',
        top: -20,
        left: 10,
        fontSize: 18,
        color: theme.palette.info.light,
    },
}));

export default () => {
    const classes = useStyles();
    const theme = useTheme();

    const config = useSelector((state) => state.hud.config);

    const showing = useSelector((state) => state.vehicle.showing);
    const ignition = useSelector((state) => state.vehicle.ignition);
    const speed = useSelector((state) => state.vehicle.speed);
    const speedMeasure = useSelector((state) => state.vehicle.speedMeasure);
    const seatbelt = useSelector((state) => state.vehicle.seatbelt);
    const checkEngine = useSelector((state) => state.vehicle.checkEngine);
    const seatbeltHide = useSelector((state) => state.vehicle.seatbeltHide);
    const cruise = useSelector((state) => state.vehicle.cruise);

    const fuelHide = useSelector((state) => state.vehicle.fuelHide);
    const fuel = useSelector((state) => state.vehicle.fuel);

    const rpm = useSelector((state) => state.vehicle.rpm);

    const nos = useSelector((state) => state.vehicle.nos);

    const isShiftedUp = () => {
        return (
            config.layout == 'default' ||
            config.layout == 'center' ||
            (config.layout == 'minimap' && config.buffsAnchor2) ||
            (config.layout == 'condensed' &&
                config.condenseAlignment == 'center')
        );
    };

    return (
        <Fade in={showing}>
            <div
                className={classes.wrapper}
                style={{ bottom: isShiftedUp() ? 65 : 0 }}
            >
                {ignition && !Boolean(fuelHide) && (
                    <div className={classes.fuelGauge}>
                        <CircularProgressbarWithChildren
                            value={fuel}
                            strokeWidth={4}
                            circleRatio={0.25}
                            styles={buildStyles({
                                strokeLinecap: 'butt',
                                rotation: 0.635,
                                position: 'relative',
                                trailColor: theme.palette.secondary.dark,
                                pathColor:
                                    fuel >= 50
                                        ? theme.palette.success.main
                                        : fuel >= 25
                                        ? theme.palette.warning.main
                                        : theme.palette.error.main,
                            })}
                        >
                            <FontAwesomeIcon
                                className={classes.fuelIcon}
                                icon={['fas', 'gas-pump']}
                            />
                        </CircularProgressbarWithChildren>
                    </div>
                )}

                {Boolean(ignition) ? (
                    <CircularProgressbarWithChildren
                        value={ignition ? rpm * 100 : 0}
                        strokeWidth={6}
                        circleRatio={0.75}
                        styles={buildStyles({
                            strokeLinecap: 'butt',
                            rotation: 0.625,
                            trailColor: theme.palette.secondary.dark,
                            pathColor: theme.palette.primary.main,
                            position: 'relative',
                        })}
                    >
                        <div className={classes.speed}>
                            {speed}
                            <small>{speedMeasure}</small>
                        </div>
                        {Boolean(checkEngine) && (
                            <span className={classes.checkEngine}>
                                <FontAwesomeIcon
                                    icon={['fas', 'engine-warning']}
                                />
                            </span>
                        )}
                        {!Boolean(seatbelt) && !Boolean(seatbeltHide) && (
                            <span className={classes.seatBelt}>
                                <FontAwesomeIcon
                                    icon={['fas', 'triangle-exclamation']}
                                />
                            </span>
                        )}
                        {Boolean(cruise) && (
                            <span className={classes.cruise}>
                                <FontAwesomeIcon icon={['fas', 'gauge']} />
                            </span>
                        )}
                    </CircularProgressbarWithChildren>
                ) : null}
                {ignition && nos > 0 && (
                    <div className={classes.nosGauge}>
                        <CircularProgressbarWithChildren
                            value={nos}
                            strokeWidth={4}
                            counterClockwise
                            circleRatio={0.25}
                            styles={buildStyles({
                                strokeLinecap: 'butt',
                                rotation: -0.635,
                                position: 'relative',
                                trailColor: theme.palette.secondary.dark,
                                pathColor: '#0078ec',
                            })}
                        >
                            <FontAwesomeIcon
                                className={classes.nosIcon}
                                icon="wine-bottle"
                            />
                        </CircularProgressbarWithChildren>
                    </div>
                )}
            </div>
        </Fade>
    );
};
