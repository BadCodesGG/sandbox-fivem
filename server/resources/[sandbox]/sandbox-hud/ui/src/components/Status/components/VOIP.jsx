import React from 'react';
import { useSelector } from 'react-redux';
import { makeStyles, withTheme } from '@mui/styles';
import { CSSTransition, TransitionGroup } from 'react-transition-group';

const useStyles = makeStyles((theme) => ({
    voipContainer: {
        fontSize: 30,
        width: 'fit-content',
        textAlign: 'center',
    },
    voip: {
        width: 255,
        height: 8,
        display: 'flex',
    },
    voipStage: {
        width: 81,
        height: 8,
        border: `1px solid ${theme.palette.border.divider}`,
        '&.active:not(.talking):not(.radio)': {
            background: theme.palette.text.alt,
        },
        '&.active.talking': {
            background: theme.palette.primary.main,
        },
        '&.active.radio': {
            background: theme.palette.info.main,
        },
        '&:not(.active)': {
            background: theme.palette.secondary.dark,
        },
        '&:not(:last-of-type)': {
            marginRight: 6,
        },
    },
}));

export default withTheme(() => {
    const classes = useStyles();

    const voip = useSelector((state) => state.hud.voip);
    const isTalking = useSelector((state) => state.hud.talking);

    return (
        <TransitionGroup className={classes.voipContainer}>
            <div className={classes.voip}>
                <CSSTransition key="voip-1" timeout={500} classNames="fade">
                    <div
                        className={`${classes.voipStage} ${
                            voip >= 1 ? 'active' : ''
                        } ${
                            isTalking == 1
                                ? 'talking'
                                : isTalking == 2
                                ? 'radio'
                                : ''
                        }`}
                    ></div>
                </CSSTransition>
                <CSSTransition key="voip-2" timeout={500} classNames="fade">
                    <div
                        className={`${classes.voipStage} ${
                            voip >= 2 ? 'active' : ''
                        } ${
                            isTalking == 1
                                ? 'talking'
                                : isTalking == 2
                                ? 'radio'
                                : ''
                        }`}
                    ></div>
                </CSSTransition>
                <CSSTransition key="voip-3" timeout={500} classNames="fade">
                    <div
                        className={`${classes.voipStage} ${
                            voip >= 3 ? 'active' : ''
                        } ${
                            isTalking == 1
                                ? 'talking'
                                : isTalking == 2
                                ? 'radio'
                                : ''
                        }`}
                    ></div>
                </CSSTransition>
            </div>
        </TransitionGroup>
    );
});
