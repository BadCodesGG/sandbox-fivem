import React, { useState, useEffect, Fragment } from 'react';
import { useSelector } from 'react-redux';
import { Fade, useTheme } from '@mui/material';
import { makeStyles } from '@mui/styles';
import ReactHtmlParser from 'react-html-parser';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

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
        height: 155,
    },
    dashIcon: {
        textAlign: 'center',
        display: 'block',
        fontSize: 16,
        lineHeight: '45px',
        padding: 5,
        fontSize: 30,
        zIndex: 5,

        '&.seatbelt': {
            color: `${theme.palette.secondary.light}80`,
            display: 'block',

            '&.active': {
                animation: 'flash linear 3s infinite',
                color: theme.palette.warning.main,
            },
        },
        '&.checkEngine': {
            color: `${theme.palette.secondary.light}80`,
            display: 'block',

            '&.active': {
                animation: 'flash linear 1s infinite',
                color: theme.palette.error.main,
            },
        },
        '&.cruise': {
            color: `${theme.palette.secondary.light}80`,
            display: 'block',

            '&.active': {
                color: theme.palette.info.main,
            },
        },
    },
    left: {
        height: '100%',
        width: 100,
        position: 'relative',
    },
    right: {
        paddingLeft: 10,
    },
    speedText: {
        fontSize: 65,
        lineHeight: '65px',
        height: 'fit-content',
        width: 'fit-content',
        position: 'absolute',
        top: 0,
        bottom: 0,
        left: 0,
        right: 0,
        margin: 'auto',
    },
    speedMeasure: {
        fontSize: 22,
        height: 'fit-content',
        width: 'fit-content',
        position: 'absolute',
        bottom: 18,
        right: 2,
    },
    bars: {
        display: 'flex',
        height: '100%',
        gap: 8,
    },
    vehBar: {
        height: '100%',
        display: 'flex',
        flexFlow: 'column',
        gap: 4,
    },
    barBg: {
        flex: 1,
        borderRadius: 8,
        borderBottomLeftRadius: 0,
        borderBottomRightRadius: 0,
        position: 'relative',
        background: `${theme.palette.secondary.dark}80`,
    },
    barFill: {
        borderRadius: 8,
        borderBottomLeftRadius: 0,
        borderBottomRightRadius: 0,
        position: 'absolute',
        bottom: 0,
        left: 0,
        right: 0,
        margin: 'auto',
        transition: 'color ease-in 0.15s',

        '&.nos': {
            background: '#0078ec',
        },
    },
    barIcon: {
        fontSize: 16,
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

    const nos = useSelector((state) => state.vehicle.nos);

    const isShiftedUp = () => {
        return (
            config.layout == 'default' ||
            config.layout == 'center' ||
            (config.layout == 'minimap' && config.buffsAnchor2)
        );
    };

    const [speedStr, setSpeedStr] = useState(speed.toString());

    useEffect(() => {
        if (speed === 0) {
            setSpeedStr(`<span class="filler">000</span>`);
        } else if (speed < 10) {
            setSpeedStr(`<span class="filler">00</span>${speed.toString()}`);
        } else if (speed < 100) {
            setSpeedStr(`<span class="filler">0</span>${speed.toString()}`);
        } else {
            setSpeedStr(speed.toString());
        }
    }, [speed]);

    return (
        <Fade in={showing}>
            <div
                className={classes.wrapper}
                style={{ bottom: isShiftedUp() ? 65 : 0 }}
            >
                <div className={classes.left}>
                    {ignition ? (
                        <Fragment>
                            <div className={classes.speedText}>
                                {ReactHtmlParser(speedStr)}
                            </div>
                            <div className={classes.speedMeasure}>
                                {speedMeasure}
                            </div>
                        </Fragment>
                    ) : (
                        <div className={classes.speedText}>Off</div>
                    )}
                </div>
                <div className={classes.right}>
                    <span
                        className={`${classes.dashIcon} checkEngine ${
                            Boolean(checkEngine) ? 'active' : ''
                        }`}
                    >
                        <FontAwesomeIcon icon={['fas', 'car-burst']} />
                    </span>
                    <span
                        className={`${classes.dashIcon} cruise ${
                            Boolean(cruise) ? 'active' : ''
                        }`}
                    >
                        <FontAwesomeIcon icon={['fas', 'gauge']} />
                    </span>
                    {!seatbeltHide && (
                        <span
                            className={`${classes.dashIcon} seatbelt ${
                                !seatbelt ? 'active' : ''
                            }`}
                        >
                            <FontAwesomeIcon
                                icon={['fas', 'triangle-exclamation']}
                            />
                        </span>
                    )}
                </div>
                <div className={classes.bars}>
                    {ignition && !Boolean(fuelHide) && (
                        <div className={classes.vehBar}>
                            <div className={classes.barBg}>
                                <div
                                    className={classes.barFill}
                                    style={{
                                        height: `${fuel}%`,
                                        animation:
                                            fuel <= 10
                                                ? 'flash linear 0.5s infinite'
                                                : 'none',
                                        background:
                                            fuel >= 50
                                                ? theme.palette.success.main
                                                : fuel >= 10
                                                ? theme.palette.warning.main
                                                : fuel >= 0
                                                ? theme.palette.error.main
                                                : theme.palette.primary.main,
                                    }}
                                ></div>
                            </div>
                            <div className={classes.barIcon}>
                                <FontAwesomeIcon icon="gas-pump" />
                            </div>
                        </div>
                    )}
                    {ignition && nos > 0 && (
                        <div className={classes.vehBar}>
                            <div className={classes.barBg}>
                                <div
                                    className={`${classes.barFill} nos`}
                                    style={{ height: `${nos}%` }}
                                ></div>
                            </div>
                            <div className={classes.barIcon}>
                                <FontAwesomeIcon icon="wine-bottle" />
                            </div>
                        </div>
                    )}
                </div>
            </div>
        </Fade>
    );
};
