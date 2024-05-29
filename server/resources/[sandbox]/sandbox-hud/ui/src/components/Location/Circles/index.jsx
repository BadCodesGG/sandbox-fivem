import React from 'react';
import { useSelector } from 'react-redux';
import { Grid } from '@mui/material';
import { makeStyles } from '@mui/styles';

const useStyles = makeStyles((theme) => ({
    temp: {
        background: 'red',
        position: 'absolute',
    },
}));

export default () => {
    const classes = useStyles();
    const config = useSelector((state) => state.hud.config);
    const position = useSelector((state) => state.hud.position);
    const isShowing = useSelector((state) => state.location.showing);
    const location = useSelector((state) => state.location.location);
    const isBlindfolded = useSelector((state) => state.app.blindfolded);

    if (!isShowing || isBlindfolded) return null;
    return (
        <div
            className={classes.temp}
            style={{
                height: `${position.height * 100}vh`,
                width: `${position.width * 100}vw`,
                top: `${position.topY * 100}vh`,
                left: `${position.leftX * 100}vw`,
            }}
        ></div>
    );
};
