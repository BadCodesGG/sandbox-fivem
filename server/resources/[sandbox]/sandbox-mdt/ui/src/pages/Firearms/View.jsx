import React, { useEffect, useState } from 'react';
import {
    List,
    ListItem,
    ListItemText,
    Grid,
    IconButton,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import { toast } from 'react-toastify';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { Link, useLocation } from 'react-router-dom';
import Moment from 'react-moment';

import qs from 'qs';

import { Loader } from '../../components';
import Nui from '../../util/Nui';

import FlagForm from './components/FlagForm';
import FirearmFlag from './components/FirearmFlag';

const useStyles = makeStyles((theme) => ({
    nWrapper: {
        padding: '10px 5px 10px 5px',
        height: '100%',
        display: 'flex',
        flexDirection: 'column',
        justifyContent: 'center',
        alignContent: 'center',
        textAlign: 'center',
        fontSize: 22,
    },
    wrapper: {
        padding: '10px 5px 10px 5px',
        height: '100%',
        overflow: 'hidden',
    },
    nWrapperIcon: {
        opacity: '50%',
        color: theme.palette.primary.main,
        fontSize: 80,
        marginBottom: 20,
    },
    mainInfos: {
        display: 'flex',
        flexDirection: 'column',
        justifyContent: 'center',
        alignContent: 'center',
    },
    mugshot: {
        margin: 'auto',
        //marginBottom: 25,
        height: 150,
        width: 150,
        border: `3px solid ${theme.palette.primary.main}8a`,
    },
    link: {
        color: theme.palette.text.alt,
        transition: 'color ease-in 0.15s',
        '&:hover': {
            color: theme.palette.primary.main,
        },
        '&:not(:last-of-type)::after': {
            color: theme.palette.text.main,
            content: '", "',
        },
    },
    item: {
        margin: 4,
        transition: 'background ease-in 0.15s',
        border: `1px solid ${theme.palette.border.divider}`,
        margin: 7.5,
        transition: 'filter ease-in 0.15s',
        '&:hover': {
            filter: 'brightness(0.8)',
            cursor: 'pointer',
        },
    },
    jobChip: {
        backgroundColor: '#00497d',
    },
    vehicleChip: {
        backgroundColor: '#81449c',
    },
    charge: {
        margin: 4,
        '&.type-1': {
            backgroundColor: theme.palette.info.main,
        },
        '&.type-2': {
            backgroundColor: theme.palette.warning.main,
        },
        '&.type-3': {
            backgroundColor: theme.palette.error.main,
        },
    },
    editorField: {
        marginTop: 10,
    },
    items: {
        maxHeight: '95%',
        height: '95%',
        overflowY: 'auto',
        overflowX: 'hidden',
    },
    itemWrapper: {
        padding: '5px 2.5px 5px 5px',
        borderBottom: `1px solid ${theme.palette.border.divider}`,
        '&:first-of-type': {
            borderTop: `1px solid ${theme.palette.border.divider}`,
        },
    },
}));

export default ({ }) => {
    const classes = useStyles();
    const location = useLocation();

    let qry = qs.parse(location.search.slice(1));
    const firearmId = qry.firearm;

    const [adding, setAdding] = useState(false);
    const [loading, setLoading] = useState(false);
    const [err, setErr] = useState(false);
    const [firearm, setFirearm] = useState(null);

    useEffect(() => {
        const fetch = async (fId) => {
            setLoading(true);
            try {
                let res = await (
                    await Nui.send('View', {
                        type: 'firearm',
                        id: fId,
                    })
                ).json();

                if (res) setFirearm(res);
                else toast.error('Unable to Load');
            } catch (err) {
                console.log(err);
                toast.error('Unable to Load');
                setErr(true);
            }

            setLoading(false);
        };

        if (firearmId) {
            fetch(firearmId);
        };
    }, [firearmId]);

    const addFlag = async (flag) => {
        if (firearm.Flags && firearm.Flags.find((f) => f.value == flag.value)) {
            toast.error('Unable to Create Flag');
            return;
        }

        setLoading(true);
        try {
            let res = await (
                await Nui.send('Create', {
                    type: 'firearm-flag',
                    parentId: firearm.serial,
                    doc: flag,
                })
            ).json();

            if (res) {
                const currentFlags = firearm.flags ?? [];
                setFirearm({
                    ...firearm,
                    flags: [...currentFlags, res],
                });
            } else toast.error('Unable to Create Flag');
        } catch (err) {
            console.log(err);
            toast.error('Unable to Create Flag');
        }
        setAdding(false);
        setLoading(false);
    };

    const dismissFlag = async (id) => {
        try {
            let res = await (
                await Nui.send('Delete', {
                    type: 'firearm-flag',
                    parentId: firearm.serial,
                    id: id,
                })
            ).json();

            if (res) {
                setFirearm({
                    ...firearm,
                    flags: firearm.flags.filter((f) => f.id !== id),
                });
            } else toast.error('Unable to Create Flag');
        } catch (err) {
            console.log(err);
            toast.error('Unable to Create Flag');
        }
        setAdding(false);
    };

    if (loading || !firearm) {
        return (
            <div className={classes.nWrapper}>
                {loading ? (
                    <Loader text="Loading" />
                ) : (
                    <>
                        <FontAwesomeIcon className={classes.nWrapperIcon} icon={['fas', 'gun']} />
                        <div>No Firearm Selected</div>
                    </>
                )}
            </div>
        );
    };

    return (
        <div className={classes.wrapper}>
            <Grid container spacing={2} style={{ height: '100%', paddingBottom: 10 }} justifyContent="center" alignContent="flex-start">
                <Grid item xs={6}>
                    <List>
                        <ListItem>
                            <ListItemText primary="Firearm" secondary={firearm.model ?? 'Unknown'} />
                        </ListItem>
                        <ListItem>
                            <ListItemText primary="Serial Number" secondary={firearm.serial} />
                        </ListItem>
                        <ListItem>
                            <ListItemText
                                primary="Registered Owner"
                                secondary={
                                    Boolean(firearm.owner_sid) ? (
                                        <Link
                                            className={classes.link}
                                            to={`/people?person=${firearm.owner_sid}`}
                                        >
                                            {`${firearm.owner_name} (${firearm.owner_sid})`}
                                        </Link>
                                    ) : (
                                        <span>{firearm.owner_name}</span>
                                    )
                                }
                            />
                        </ListItem>
                        <ListItem>
                            <ListItemText
                                primary="Date of Purchase"
                                secondary={<Moment date={firearm.purchased} format="LLL" />}
                            />
                        </ListItem>
                    </List>
                </Grid>
                <Grid item xs={6}>
                    <ListItem>
                        <ListItemText
                            primary={
                                <span>
                                    Flags{' '}
                                    <IconButton style={{ fontSize: 16 }} onClick={() => setAdding(true)}>
                                        <FontAwesomeIcon icon={['fas', 'plus']} />
                                    </IconButton>
                                </span>
                            }
                            secondary={firearm.Flags?.length == 0 ? 'No Flags' : null}
                        />
                    </ListItem>
                    {firearm.flags?.length > 0 && (
                        <ListItem>
                            {firearm.flags.map(f => {
                                return <FirearmFlag key={`flag-${f.id}`} flag={f} onDismiss={dismissFlag} />;
                            })}
                        </ListItem>
                    )}
                </Grid>
            </Grid>
            <FlagForm open={adding} onSubmit={addFlag} onClose={() => setAdding(false)} />
        </div>
    );
};
