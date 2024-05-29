import React from 'react';
import { Fade } from '@mui/material';
import { makeStyles, withTheme } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { useSelector } from 'react-redux';

const useStyles = makeStyles((theme) => ({
    container: {
        paddingLeft: 5,
        lineHeight: '25px',
        display: 'flex',
        '&.transparent': {
            background: `${theme.palette.secondary.dark}80`,
        },
        '&.solid': {
            background: theme.palette.secondary.dark,
        },
    },
    icon: {
        width: 24,
        display: 'block',
        fontSize: 18,
        padding: (data) =>
            Boolean(data.status?.options?.force) &&
            data.status.options.force != data.config.statusType
                ? 0
                : 5,
        paddingLeft: '0 !important',
        borderRight: `1px solid ${theme.palette.border.divider}`,
    },
    number: {
        fontSize: 18,
        lineHeight: (data) =>
            Boolean(data.status?.options?.force) &&
            data.status.options.force != data.config.statusType
                ? '24px'
                : '34px',
        flex: 1,
        textAlign: 'center',
        overflow: 'hidden',
        textOverflow: 'ellipsis',
        whiteSpace: 'nowrap',
        '&.low': {
            animation: '$flash linear 1s infinite',
        },
    },
}));

export default withTheme(({ status }) => {
    const config = useSelector((state) => state.hud.config);
    const isDead = useSelector((state) => state.status.isDead);
    const classes = useStyles({ status, config });

    if (
        (status.options.hideZero && status.value <= 0) ||
        (status.value >= 90 && status?.options?.hideHigh) ||
        (status.value == 0 && status?.options?.hideZero) ||
        (isDead && !status?.options?.visibleWhileDead)
    )
        return null;
    return (
        <Fade in={true}>
            <div
                className={`${classes.container}${
                    Boolean(status?.options?.force) &&
                    status.options.force != config.statusType &&
                    !config.transparentBg
                        ? ' solid'
                        : ' transparent'
                }`}
                style={{
                    borderLeft: `4px solid ${status.color}`,
                    width:
                        Boolean(status?.options?.force) &&
                        status.options.force != config.statusType &&
                        config.largeBars
                            ? 124.5
                            : 81,
                }}
            >
                <div className={classes.icon}>
                    <FontAwesomeIcon
                        icon={status.icon}
                        className={classes.iconTxt}
                    />
                </div>
                <div
                    className={`${classes.number} ${
                        ((!status.inverted && status.value <= 10) ||
                            (status.inverted && status.value >= 90)) &&
                        status.flash
                            ? ' low'
                            : ''
                    }`}
                >
                    {status.value}
                </div>
            </div>
        </Fade>
    );
});
