import React from 'react';
import { useSelector } from 'react-redux';
import { Fade, CircularProgress, Avatar } from '@mui/material';
import { makeStyles, withTheme } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

const useStyles = makeStyles((theme) => ({
    status: {
        position: 'relative',
        height: 45,
        width: 45,
    },
    bar: {
        position: 'absolute',
        height: 45,
        width: 45,
        top: 0,
        bottom: 0,
        right: 0,
        left: 0,
    },
    background: {
        position: 'absolute',
        height: 45,
        width: 45,
        top: 0,
        bottom: 0,
        right: 0,
        left: 0,
        zIndex: -1,
        background: theme.palette.secondary.dark,
        color: theme.palette.text.main,
        fontSize: 16,
    },
    number: {
        fontSize: '0.75rem',
    },
}));

export default withTheme(({ buff }) => {
    const classes = useStyles(buff);
    const buffDefs = useSelector((state) => state.status.buffDefs);
    const buffDef = buffDefs[buff?.buff];

    return (
        <Fade in={true}>
            <div className={classes.status}>
                <CircularProgress
                    className={classes.bar}
                    variant="determinate"
                    value={100}
                    thickness={5}
                    size={45}
                    style={{ color: buffDef.color }}
                />
                <Avatar className={classes.background}>
                    {Boolean(buff.override) ? (
                        <span className={classes.number}>{buff.override}</span>
                    ) : (
                        <FontAwesomeIcon icon={buffDef.icon} />
                    )}
                </Avatar>
            </div>
        </Fade>
    );
});
