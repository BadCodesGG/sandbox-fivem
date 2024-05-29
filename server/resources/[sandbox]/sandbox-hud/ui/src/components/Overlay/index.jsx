import React, { useState, useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Grid, List, IconButton, Slide } from '@mui/material';
import { makeStyles } from '@mui/styles';
import HuntingMapDark from '../../assets/hunting-map-dark.webp';
import HuntingMapLight from '../../assets/hunting-map-light.webp';

const useStyles = makeStyles((theme) => ({
    wrapper: {
        top: '25vh',
        left: 0,
        right: 'auto',
        margin: 'auto',
        position: 'absolute',
    },
    wrapperContainer: {
        height: '50vh',
        width: '25vw',
        marginLeft: '2vw',
    },
    imageBG: {
        backgroundSize: 'contain',
        backgroundRepeat: 'no-repeat',
        width: '100%',
        height: '100%',
    },
}));

export default () => {
    const classes = useStyles();
    const showing = useSelector((state) => state.overlay.showing);
    const info = useSelector((state) => state.overlay.data);

    return (
        <Slide
            direction="right"
            in={showing}
            timeout={500}
            mountOnEnter
            unmountOnExit
        >
            <div className={classes.wrapper}>
                <div className={classes.wrapperContainer}>
                    {info[0] && info[0].Name == 'hunting_map_dark' && (
                        <div
                            className={classes.imageBG}
                            style={{
                                backgroundImage: `url(${HuntingMapDark})`,
                            }}
                        />
                    )}
                    {info[0] && info[0].Name == 'hunting_map_light' && (
                        <div
                            className={classes.imageBG}
                            style={{
                                backgroundImage: `url(${HuntingMapLight})`,
                            }}
                        />
                    )}
                    {info[0] && info[0].Name.includes('vanityitem') && (
                        <div
                            className={classes.imageBG}
                            style={{
                                backgroundImage: `url(${info[0].MetaData.CustomItemImage})`,
                            }}
                        />
                    )}
                </div>
            </div>
        </Slide>
    );
};
