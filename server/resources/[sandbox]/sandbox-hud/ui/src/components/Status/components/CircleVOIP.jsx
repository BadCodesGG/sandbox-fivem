import React from 'react';
import { Avatar, CircularProgress, Fade, useTheme } from '@mui/material';
import { makeStyles, withTheme } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { useSelector } from 'react-redux';

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
        color: theme.palette.text.alt,

        '&.talking': {
            color: theme.palette.primary.main,
        },
        '&.radio': {
            color: theme.palette.info.main,
        },
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

export default withTheme(() => {
    const classes = useStyles();

    const radioFreq = useSelector((state) => state.status.statuses).filter(
        (s) => s.name == 'radio-freq',
    )[0];

    const voip = useSelector((state) => state.hud.voip);
    const voipIcon = useSelector((state) => state.hud.voipIcon);
    const config = useSelector((state) => state.hud.config);
    const isTalking = useSelector((state) => state.hud.talking);

    const getTalkingLevel = () => {
        switch (voip) {
            case 1:
                return 33.333;
            case 2:
                return 66.666;
            case 3:
                return 100.0;
        }
    };

    return (
        <Fade in={true}>
            <div className={classes.status}>
                <CircularProgress
                    className={`${classes.bar}${
                        isTalking == 1
                            ? ' talking'
                            : isTalking == 2
                            ? ' radio'
                            : ''
                    }`}
                    variant="determinate"
                    value={getTalkingLevel()}
                    thickness={5}
                    size={45}
                />
                <Avatar className={classes.background}>
                    {Boolean(radioFreq) && radioFreq.value > 0 ? (
                        config.maskRadio ? (
                            <FontAwesomeIcon icon={voipIcon} />
                        ) : (
                            <span className={classes.number}>
                                {radioFreq.value}
                            </span>
                        )
                    ) : (
                        <FontAwesomeIcon icon={voipIcon ?? 'microphone'} />
                    )}
                </Avatar>
            </div>
        </Fade>
    );
});
