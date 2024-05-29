import React, { useEffect, useState } from 'react';
import { connect } from 'react-redux';
import { LinearProgress, Fade, Typography } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { styled } from '@mui/material/styles';
import { linearProgressClasses } from '@mui/material/LinearProgress';
import useInterval from 'react-useinterval';

import Nui from '../../util/Nui';

const useStyles = makeStyles((theme) => ({
    container: {
        width: '100%',
        maxWidth: 400,
        height: 'fit-content',
        position: 'absolute',
        bottom: 180,
        left: 0,
        right: 0,
        margin: 'auto',
    },
    details: {
        height: 40,
        display: 'flex',
        background: `${theme.palette.secondary.dark}80`,
        paddingTop: 10,
    },
    timer: {
        width: 75,
        fontSize: 18,
        textAlign: 'center',
        lineHeight: '22px',
    },
    label: {
        color: theme.palette.text.main,
        fontSize: 18,
        textShadow: '0 0 5px #000',
        paddingLeft: 15,
        flex: 1,
        borderRight: `1px solid ${theme.palette.border.divider}`,
    },
    progressbar: {
        transition: 'none !important',
    },
}));

const mapStateToProps = (state) => ({
    showing: state.progress.showing,
    failed: state.progress.failed,
    cancelled: state.progress.cancelled,
    finished: state.progress.finished,
    label: state.progress.label,
    duration: state.progress.duration,
    startTime: state.progress.startTime,
});

export default connect(mapStateToProps)(
    ({ cancelled, finished, failed, label, duration, startTime, dispatch }) => {
        const classes = useStyles();

        const BorderLinearProgress = styled(LinearProgress)(({ theme }) => ({
            height: 10,
            [`&.${linearProgressClasses.colorPrimary}`]: {
                backgroundColor: theme.palette.secondary.dark,
            },
            [`& .${linearProgressClasses.bar}`]: {
                backgroundColor:
                    cancelled || failed
                        ? theme.palette.primary.main
                        : finished
                        ? theme.palette.success.main
                        : theme.palette.info.main,
            },
        }));

        const [curr, setCurr] = useState(0);
        const [fin, setFin] = useState(true);
        const [to, setTo] = useState(null);

        useEffect(() => {
            setCurr(0);
            setFin(true);
            if (to) {
                clearTimeout(to);
            }
        }, [startTime]);

        useEffect(() => {
            return () => {
                if (to) clearTimeout(to);
            };
        }, []);

        useEffect(() => {
            return () => {
                if (to) clearTimeout(to);
            };
        }, []);

        useEffect(() => {
            if (cancelled || finished || failed) {
                setCurr(0);
                setTo(
                    setTimeout(() => {
                        setFin(false);
                    }, 2000),
                );
            }
        }, [cancelled, finished, failed]);

        const tick = () => {
            if (failed || finished || cancelled) return;

            if (curr + 10 > duration) {
                dispatch({
                    type: 'FINISH_PROGRESS',
                });
            } else {
                setCurr(curr + 10);
            }
        };

        const hide = () => {
            dispatch({
                type: 'HIDE_PROGRESS',
            });
        };

        useInterval(tick, curr > duration ? null : 10);
        return (
            <Fade in={fin} duration={1000} onExited={hide}>
                <div className={classes.container}>
                    <div className={classes.details}>
                        <div className={classes.label}>
                            {finished
                                ? 'Finished'
                                : failed
                                ? 'Failed'
                                : cancelled
                                ? 'Cancelled'
                                : label}
                        </div>
                        <div className={classes.timer}>
                            {!cancelled && !finished && !failed ? (
                                <small>
                                    {Math.round(curr / 1000)}s /{' '}
                                    {Math.round(duration / 1000)}s
                                </small>
                            ) : (
                                <small>-</small>
                            )}
                        </div>
                    </div>
                    <BorderLinearProgress
                        variant="determinate"
                        classes={{
                            determinate: classes.progressbar,
                            bar: classes.progressbar,
                            bar1: classes.progressbar,
                        }}
                        value={
                            cancelled || finished || failed
                                ? 100
                                : (curr / duration) * 100
                        }
                    />
                </div>
            </Fade>
        );
    },
);
