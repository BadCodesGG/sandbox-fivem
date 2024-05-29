import React from 'react';
import { useSelector } from 'react-redux';
import { useTheme } from '@mui/material';
import { makeStyles, withTheme } from '@mui/styles';
import { CSSTransition, TransitionGroup } from 'react-transition-group';

import Circle from '../components/Circle';
import CircleVOIP from '../components/CircleVOIP';
import CirlceBuffs from '../../Buffs/layouts/Circles';

const useStyles = makeStyles((theme) => ({
    status: {
        fontSize: 30,
        width: 'fit-content',
        textAlign: 'center',
        marginBottom: 4,
    },
    icons: {
        display: 'flex',
        gap: 6,
        flexFlow: 'wrap-reverse',
        marginBottom: 4,
    },
}));

export default withTheme(() => {
    const classes = useStyles();
    const theme = useTheme();

    const config = useSelector((state) => state.hud.config);
    const statuses = useSelector((state) => state.status.statuses);
    const isDead = useSelector((state) => state.status.isDead);
    const health = useSelector((state) => state.status.health);
    const maxHealth = useSelector((state) => state.status.maxHealth);
    const armor = useSelector((state) => state.status.armor);

    const els = [
        {
            icon: 'shield',
            color: isDead ? '#fff' : theme.palette.info.main,
            value: armor,
            options: {
                hideZero: true,
                order: 1,
            },
        },
        {
            icon: isDead ? 'skull' : 'heart',
            color: isDead ? '#fff' : theme.palette.success.main,
            value: isDead ? 100 : health,
            options: {
                hideZero: false,
                visibleWhileDead: true,
                order: 2,
                customMax: isDead ? 100 : maxHealth,
                forceIcon: isDead,
            },
        },
        ...statuses,
    ];

    return (
        <>
            <TransitionGroup className={classes.status}>
                <>
                    <div
                        className={classes.icons}
                        style={
                            config.condenseAlignment == 'compass'
                                ? {
                                      width: 255,
                                  }
                                : {
                                      width: '100%',
                                  }
                        }
                    >
                        <CircleVOIP />
                        {els
                            .filter((a) => a.name != 'radio-freq')
                            .sort(
                                (a, b) => a?.options?.order - b?.options?.order,
                            )
                            .map((s, i) => {
                                return (
                                    <CSSTransition
                                        key={`status-${i}`}
                                        timeout={500}
                                        classNames="fade"
                                    >
                                        <Circle status={s} />
                                    </CSSTransition>
                                );
                            })}
                        <CirlceBuffs />
                    </div>
                </>
            </TransitionGroup>
        </>
    );
});
