import React from 'react';
import { useSelector } from 'react-redux';
import { Grid } from '@mui/material';
import { makeStyles } from '@mui/styles';

const useStyles = makeStyles((theme) => ({
    container: {
        padding: '0 5px',
        background: `${theme.palette.secondary.dark}80`,
        borderLeft: `4px solid ${theme.palette.primary.main}`,
        display: 'flex',
        minWidth: 255,
    },
    containerNoBg: {
        padding: '0 5px',
        display: 'flex',
        minWidth: 255,
        filter: 'drop-shadow(1px 2px 1px #000)',
    },
    street: {
        padding: 5,
    },
    highlight: {
        color: theme.palette.primary.main,
    },
    highlight2: {
        color: theme.palette.primary.main,
        fontSize: 15,
    },
    areaWrap: {
        display: 'block',
        fontSize: 16,
        position: 'relative',
        top: 5,
    },
    direction: {
        display: 'block',
        fontSize: 40,
        padding: 5,
        paddingLeft: 0,
        borderRight: `1px solid ${theme.palette.border.divider}`,
        width: 35,
        textAlign: 'center',
    },
    locationMain: {
        color: theme.palette.text.main,
        fontSize: 22,
    },
    locationSecondary: {
        color: theme.palette.text.alt,
        fontSize: 18,
        marginLeft: 5,
    },
    '@keyframes flash': {
        '0%': {
            opacity: 1,
        },
        '50%': {
            opacity: 0.1,
        },
        '100%': {
            opacity: 1,
        },
    },
}));

export default () => {
    const classes = useStyles();
    const config = useSelector((state) => state.hud.config);
    const isShowing = useSelector((state) => state.location.showing);
    const location = useSelector((state) => state.location.location);
    const isBlindfolded = useSelector((state) => state.app.blindfolded);

    if (!isShowing || isBlindfolded) return null;
    return (
        <div
            className={
                config.hideCompassBg ? classes.containerNoBg : classes.container
            }
            style={{
                marginBottom:
                    config.layout == 'minimap' || config.layout == 'center'
                        ? 8
                        : 0,
            }}
        >
            <div className={classes.direction}>{location.direction}</div>
            <div className={classes.street}>
                <div className={classes.locationMain}>
                    {location.main}
                    <span className={classes.locationSecondary}>
                        {location.cross !== '' && !config.hideCrossStreet ? (
                            <span>
                                <span className={classes.highlight}> x </span>
                                {location.cross}
                            </span>
                        ) : null}
                    </span>
                </div>
                <div className={classes.areaWrap}>
                    <span className={classes.area}>{location.area}</span>
                </div>
            </div>
        </div>
    );
};
