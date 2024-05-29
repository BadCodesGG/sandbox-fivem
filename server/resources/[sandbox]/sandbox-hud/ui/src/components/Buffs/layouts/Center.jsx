import React from 'react';
import { useSelector } from 'react-redux';
import { makeStyles, withTheme } from '@mui/styles';
import { CSSTransition, TransitionGroup } from 'react-transition-group';

import TimedBuff from '../Types/Timed';
import ValueBuff from '../Types/Value';
import PermBuff from '../Types/Permanent';

const useStyles = makeStyles((theme) => ({
    container: {
        display: 'flex',
        gap: 6,
        flexFlow: 'wrap-reverse',
        width: 255,
        marginBottom: 4,
    },
    minimapContainer: {
        display: 'flex',
        gap: 6,
        flexFlow: 'row',
        position: 'absolute',
        bottom: 2,
    },
    status: {
        position: 'absolute',
        margin: 'auto',
        fontSize: 30,
        width: 'fit-content',
        textAlign: 'center',
        filter: 'drop-shadow(0 0 2px #000000)',
    },
    iconWrapper: {
        position: 'relative',
        height: 50,
        width: 50,
        '&:not(:last-of-type)': {
            marginRight: 20,
        },
        '&.low': {
            animation: '$flash linear 1s infinite',
        },
    },
    iconProg: {
        position: 'absolute',
        height: 5,
        left: 0,
        right: 0,
        bottom: 0,
        margin: 'auto',
        zIndex: 5,
    },
    barBg: {
        position: 'absolute',
        height: 7,
        left: 0,
        right: 0,
        bottom: 0,
        margin: 'auto',
        zIndex: 5,
        boxShadow: '0 0 5px #000',
        background: theme.palette.secondary.dark,
        border: `1px solid ${theme.palette.border.divider}`,
    },
    bar: {
        maxWidth: '100%',
        height: '100%',
        transition: 'width ease-in 0.15s',
    },
    iconAvatar: {
        position: 'absolute',
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        margin: 'auto',
        // backgroundImage: `linear-gradient(to top, ${theme.palette.secondary.dark}7a, transparent)`,
        '& svg, & span': {
            position: 'absolute',
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            margin: 'auto',
            fontSize: 22,
            textShadow: '0 0 5px #000',
            color: theme.palette.text.main,
        },
    },
    errorIcon: {
        color: theme.palette.error.light,
    },
}));

export default withTheme(() => {
    const classes = useStyles();

    const config = useSelector((state) => state.hud.config);
    const position = useSelector((state) => state.hud.position);
    const buffDefs = useSelector((state) => state.status.buffDefs);
    const buffs = useSelector((state) => state.status.buffs);

    return (
        <TransitionGroup
            className={
                config.buffsAnchor == 'compass'
                    ? classes.container
                    : classes.minimapContainer
            }
            style={{
                left: config.buffsAnchor2
                    ? `calc(${position.leftX * 100}% * 1.4)`
                    : 15,
            }}
        >
            {buffs.map((s, i) => {
                if (!Boolean(s)) return null;
                const buffDef = buffDefs[s?.buff];
                switch (buffDef.type) {
                    case 'timed':
                        return (
                            <CSSTransition
                                key={`status-${i}`}
                                timeout={500}
                                classNames="fade"
                            >
                                <TimedBuff buff={s} />
                            </CSSTransition>
                        );
                    case 'value':
                        return (
                            <CSSTransition
                                key={`status-${i}`}
                                timeout={500}
                                classNames="fade"
                            >
                                <ValueBuff buff={s} />
                            </CSSTransition>
                        );
                    default:
                        return (
                            <CSSTransition
                                key={`status-${i}`}
                                timeout={500}
                                classNames="fade"
                            >
                                <PermBuff buff={s} />
                            </CSSTransition>
                        );
                }
            })}
        </TransitionGroup>
    );
});
