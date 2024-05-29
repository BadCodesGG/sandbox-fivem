import React from 'react';
import { Fade } from '@mui/material';
import { makeStyles, withTheme } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { useSelector } from 'react-redux';

const useStyles = makeStyles((theme) => ({
    container: {
        lineHeight: '25px',
        display: 'flex',
        '&.transparent': {
            background: `${theme.palette.secondary.dark}80`,
            border: `2px solid ${theme.palette.secondary.dark}80`,
        },
        '&.solid': {
            background: theme.palette.secondary.dark,
            border: `2px solid ${theme.palette.secondary.dark}`,
        },
    },
    icon: {
        width: 24,
        display: 'block',
        textAlign: 'center',
        fontSize: 14,
        borderRight: `1px solid ${theme.palette.border.divider}`,
    },
    barWrapper: {
        height: '100%',
        flex: 1,
    },
    bar: {
        height: '100%',
    },
}));

export default withTheme(({ status }) => {
    const classes = useStyles();

    const config = useSelector((state) => state.hud.config);
    const isDead = useSelector((state) => state.status.isDead);

    if (
        (status.options.hideZero && status.value <= 0) ||
        (status.value >= (Boolean(status?.options?.customMax) ? status?.options?.customMax / 0.9 : 90) && status?.options?.hideHigh) ||
        (status.value == 0 && status?.options?.hideZero) ||
        (isDead && !status?.options?.visibleWhileDead)
    )
        return null;
    return (
        <Fade in={true}>
            <div
                className={`${classes.container} ${
                    ((!status.inverted && status.value <= 10) ||
                        (status.inverted && status.value >= 90)) &&
                    status.flash
                        ? ' low'
                        : ''
                } ${config.transparentBg ? 'transparent' : 'solid'}`}
                style={{ width: config.largeBars ? 124.5 : 81 }}
            >
                <div className={classes.icon}>
                    <FontAwesomeIcon
                        icon={status.icon}
                        className={classes.iconTxt}
                    />
                </div>
                <div className={classes.barWrapper}>
                    <div
                        className={classes.bar}
                        style={{
                            background: status.color,
                            width: `${
                                Boolean(status?.options?.customMax)
                                    ? (status.value /
                                          status?.options?.customMax) *
                                      100
                                    : status.value
                            }%`,
                        }}
                    ></div>
                </div>
            </div>
        </Fade>
    );
});
