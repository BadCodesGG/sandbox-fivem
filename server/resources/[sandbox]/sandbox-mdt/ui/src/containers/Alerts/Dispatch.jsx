import React, { useState, useMemo, useRef, useEffect } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { TextField, Grid, InputAdornment, IconButton, Checkbox, FormControlLabel } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { debounce } from 'lodash';

import { Modal } from '../../components';

import LogItem from './components/LogItem';

const useStyles = makeStyles((theme) => ({
    dispatchContainer: {
        display: 'flex',
        flexDirection: 'row',
        position: 'fixed',
        maxWidth: 'min(350px, calc(100% - 1000px))',
        width: '30%',
        height: '50%',
        maxHeight: 900,
        top: 0,
        left: 0,
        marginTop: 100,
    },
    logWrap: {
        display: 'flex',
        flexDirection: 'column',
        background: `${theme.palette.secondary.dark}CC`,
        width: '0%',
        height: '100%',
        transition: 'all 0.25s linear',
        position: 'relative',
    },
    title: {
        background: `${theme.palette.secondary.dark}CC`,
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        justifyContent: 'center',
        cursor: 'pointer',
        padding: '40px 0',
        gap: '20px',
        '& h3': {
            padding: '0 2px',
            marginBlockEnd: 0,
            margin: 0,
            textOrientation: 'mixed',
            writingMode: 'vertical-rl',
            transform: 'rotateZ(180deg)',
            '& small': {
                fontSize: 15,
                color: theme.palette.text.alt,
                fontWeight: 400,
            },
        },
        '& span': {
            transition: 'all 0.25s ease-in-out',
            margin: '0 10px',
        },
    },
    input: {
        margin: '10px 10px',
    },
    scroller: {
        position: 'absolute',
        bottom: '10%',
        width: '80%',
        margin: '0 10%',
        textAlign: 'center',
        background: theme.palette.secondary.dark,
        borderRadius: 5,
        cursor: 'pointer',
    }
}));

const defaultSettings = {
    attaching: true,
    dutyChange: true,
    unitChange: true,
    radioUpdate: true,
    subUnitChanges: true,
    availabilityChange: true,
}

export default () => {
    const containerRef = useRef(null);
    const ref = useRef(null);
    const timerRef = useRef(null);
    const dispatch = useDispatch();
    const classes = useStyles();
    const user = useSelector((state) => state.app.user);
    const job = useSelector((state) => state.app.govJob);
    const expanded = useSelector((state) => state.alerts.dispatchExpanded);
    const logs = useSelector((state) => state.alerts.dispatchLog);

    const [pauseScroll, setPauseScroll] = useState(false);
    const [showLogs, setShowLogs] = useState(expanded);
    const [settingsOpen, setSettingsOpen] = useState(false);
    const [settingsState, setSettingsState] = useState(JSON.parse(localStorage.getItem("dispatchLog_settings")) ?? defaultSettings);

    if (!user || (job.Id != 'police' && job.Id != 'ems' && job.Id != 'tow' && job.Id != 'prison')) return null;

    const toggleLog = () => {
        dispatch({
            type: 'TOGGLE_DISPATCH_LOG',
        });
    }

    const sendMessage = useMemo(() => debounce((input, message) => {
        input.value = '';

        dispatch({
            type: 'EMIT_LOG_MESSAGE',
            payload: {
                message,
            }
        });
    }, 1500, { leading: true, trailing: false }), []);

    const onSubmit = (e) => {
        e.preventDefault();

        sendMessage(e.target[0], e.target[0].value);
    }

    useEffect(() => {
        if (!pauseScroll) {
            ref.current?.scrollIntoView({ behavior: 'instant', block: "end", inline: "end", alignToTop: true });
        }
    }, [logs]);

    useEffect(() => {
        if (expanded) {
            timerRef.current = setTimeout(() => {
                setShowLogs(true);
                ref.current?.scrollIntoView({ behavior: 'instant', block: "end", inline: "end", alignToTop: true });
            }, 250);
        } else {
            setShowLogs(false);
        }

        return () => {
            if (timerRef?.current) {
                clearTimeout(timerRef.current);
            }
        }
    }, [expanded]);

    useEffect(() => {
        const handler = containerRef.current.addEventListener("scrollend", (e) => {
            if (e.target.id === "dispatchScrollContainer") {
                const percentage = (e.target.scrollTop / (e.target.scrollHeight - e.target.clientHeight)) * 100;

                if (percentage > 92) {
                    setPauseScroll(false);
                } else {
                    setPauseScroll(true);
                }
            }
        });

        return () => {
            removeEventListener("scrollend", handler);
        }
    }, []);

    const filteredLogs = useMemo(() => {
        const settingsData = JSON.parse(localStorage.getItem("dispatchLog_settings")) ?? defaultSettings;

        return logs.filter(log => log.type === "message" || settingsData[log.type]);
    }, [logs, settingsState, settingsOpen]);

    const scrollBottom = () => {
        setPauseScroll(false);
        ref.current?.scrollIntoView({ behavior: 'smooth', block: "end", inline: "end", alignToTop: true });
    }

    const openSettings = (e) => {
        e.stopPropagation();
        setSettingsOpen(true);
    }

    const resetSettings = () => {
        setSettingsOpen(false);
        setSettingsState(JSON.parse(localStorage.getItem("dispatchLog_settings")) ?? defaultSettings);
    }

    const saveSettings = () => {
        localStorage.setItem("dispatchLog_settings", JSON.stringify(settingsState));
        setSettingsOpen(false);
    }

    return (
        <div className={classes.dispatchContainer}>
            <div className={classes.logWrap} style={{
                width: expanded ? "100%" : "0%",
            }}>
                <div style={{
                    flexGrow: 1,
                    width: '100%',
                    overflowY: 'auto',
                    padding: '2px 0',
                    visibility: expanded ? "visible" : "hidden",

                }} id="dispatchScrollContainer" ref={containerRef}>
                    {showLogs && filteredLogs.map((item, k) => <LogItem key={k} log={item} />)}
                    <div style={{ height: 25 }} ref={ref}></div>

                    {pauseScroll && <div className={classes.scroller} onClick={scrollBottom}>Resume Scroll</div>}
                </div>
                <form className={classes.input} onSubmit={onSubmit}>
                    <TextField
                        size="small"
                        fullWidth
                        variant="standard"
                        placeholder="Send Message"
                        disabled={open === 2}
                        inputProps={{ maxLength: 128 }}
                        InputProps={{
                            endAdornment: (
                                <InputAdornment position="end">
                                    {expanded && <IconButton
                                        type="submit"
                                        size="small"
                                    >
                                        <FontAwesomeIcon
                                            icon={[
                                                'fas',
                                                'send',
                                            ]}
                                        />
                                    </IconButton>}
                                </InputAdornment>
                            ),
                        }}
                    />
                </form>
            </div>
            <div className={classes.title} onClick={toggleLog}>
                <h3>
                    Dispatch Log
                </h3>
                <span style={{
                    transform: expanded ? "rotateZ(270deg)" : "rotateZ(90deg)",
                }}>
                    <FontAwesomeIcon icon={['fas', 'chevron-up']} />
                </span>
                {expanded && <IconButton size="small" style={{ position: 'absolute', bottom: 0, marginBottom: 10, marginRight: 10 }} onClick={openSettings}>
                    <FontAwesomeIcon icon={['fas', 'cog']} />
                </IconButton>}
            </div>
            <Modal
                open={settingsOpen}
                title={"Dispatch Log Settings"}
                acceptLang="Save"
                onClose={resetSettings}
                onAccept={saveSettings}
                hideBackdrop
                maxWidth="sm"
            >
                <FormControlLabel control={<Checkbox
                    checked={Boolean(settingsState.dutyChange)}
                    name="dutyChange"
                    onChange={(e) => {
                        setSettingsState({
                            ...settingsState,
                            [e.target.name]: e.target.checked,
                        })
                    }}
                    sx={{ margin: 'auto', alignSelf: 'center' }}
                />} label="Show Units Going On/Off Duty" />
                <br />
                <FormControlLabel control={<Checkbox
                    checked={Boolean(settingsState.unitChange)}
                    name="unitChange"
                    onChange={(e) => {
                        setSettingsState({
                            ...settingsState,
                            [e.target.name]: e.target.checked,
                        })
                    }}
                    sx={{ margin: 'auto', alignSelf: 'center' }}
                />} label="Show Units Transitioning" />
                <br />
                <FormControlLabel control={<Checkbox
                    checked={Boolean(settingsState.subUnitChanges)}
                    name="subUnitChanges"
                    onChange={(e) => {
                        setSettingsState({
                            ...settingsState,
                            [e.target.name]: e.target.checked,
                        })
                    }}
                    sx={{ margin: 'auto', alignSelf: 'center' }}
                />} label="Show Units Operating Under/Breaking Off" />
                <br />
                <FormControlLabel control={<Checkbox
                    checked={Boolean(settingsState.availabilityChange)}
                    name="availabilityChange"
                    onChange={(e) => {
                        setSettingsState({
                            ...settingsState,
                            [e.target.name]: e.target.checked,
                        })
                    }}
                    sx={{ margin: 'auto', alignSelf: 'center' }}
                />} label="Show Units Changing Availability" />
                <br />
                <FormControlLabel control={<Checkbox
                    checked={Boolean(settingsState.attaching)}
                    name="attaching"
                    onChange={(e) => {
                        setSettingsState({
                            ...settingsState,
                            [e.target.name]: e.target.checked,
                        })
                    }}
                    sx={{ margin: 'auto', alignSelf: 'center' }}
                />} label="Show Units Attaching/Detaching From Calls" />
                <br />
                <FormControlLabel control={<Checkbox
                    checked={Boolean(settingsState.radioUpdate)}
                    name="radioUpdate"
                    onChange={(e) => {
                        setSettingsState({
                            ...settingsState,
                            [e.target.name]: e.target.checked,
                        })
                    }}
                    sx={{ margin: 'auto', alignSelf: 'center' }}
                />} label="Show When Radio Info Is Added" />
            </Modal>
        </div>
    );
};
