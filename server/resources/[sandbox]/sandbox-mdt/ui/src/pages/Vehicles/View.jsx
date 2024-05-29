import React, { useEffect, useState } from 'react';
import {
    List,
    ListItem,
    ListItemText,
    Grid,
    IconButton,
    Alert,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import { toast } from 'react-toastify';
import moment from 'moment';
import Moment from 'react-moment';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { Link, useLocation } from 'react-router-dom';

import qs from 'qs';

import { Loader } from '../../components';
import Nui from '../../util/Nui';
import { useSelector } from 'react-redux';

import { VehicleTypes } from '../../data';
import FlagForm from './components/FlagForm';
import StrikeForm from './components/StrikeForm';
import AssigneesForm from './components/AssigneesForm';
import VehicleFlag, { FlagTypes } from './components/VehicleFlag';
import VehicleStrike from './components/VehicleStrike';

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
}));

export default ({ }) => {
    const classes = useStyles();
    const location = useLocation();
    const myJob = useSelector((state) => state.app.govJob);
    const govJobs = useSelector((state) => state.data.data.governmentJobs);

    let qry = qs.parse(location.search.slice(1));
    const vehicleId = qry.vehicle;
    const isFleetManage = qry["fleet-manage"] == "1";

    const [adding, setAdding] = useState(false);
    const [loading, setLoading] = useState(false);
    const [err, setErr] = useState(false);
    const [vehicle, setVehicle] = useState(null);

    const [addingStrike, setAddingStrike] = useState(false);

    const [editingAssigned, setEditingAssigned] = useState(false);

    useEffect(() => {
        const fetch = async (VIN) => {
            setLoading(true);
            try {
                let res = await (
                    await Nui.send('View', {
                        type: 'vehicle',
                        id: VIN,
                    })
                ).json();

                if (res) setVehicle(res);
                else toast.error('Unable to Load');
            } catch (err) {
                console.log(err);
                toast.error('Unable to Load');
                setErr(true);
            }

            setLoading(false);
        };

        if (vehicleId) {
            fetch(vehicleId);
        };
    }, [vehicleId]);

    const addFlag = async (flag) => {
        if (vehicle.Flags && vehicle.Flags.find((f) => f.Type == flag.Type)) {
            toast.error('Unable to Create Flag');
            return;
        }

        setLoading(true);
        try {
            let res = await (
                await Nui.send('Create', {
                    type: 'vehicle-flag',
                    parent: vehicle.VIN,
                    plate: vehicle.RegisteredPlate,
                    doc: flag,
                })
            ).json();

            if (res) {
                const currentFlags = vehicle.Flags ?? [];
                setVehicle({
                    ...vehicle,
                    Flags: [...currentFlags, flag],
                });
            } else toast.error('Unable to Create Flag');
        } catch (err) {
            console.log(err);
            toast.error('Unable to Create Flag');
        }

        setLoading(false);
        setAdding(false);
    };

    const addStrike = async (strike) => {
        let currentStrikes = vehicle.Strikes ?? Array();
        if (currentStrikes.length >= 15) {
            toast.error('Unable to Add Strike');
            return;
        };

        currentStrikes.push(strike);
        setLoading(true);
        try {
            let res = await (
                await Nui.send('Update', {
                    type: 'vehicle-strikes',
                    VIN: vehicle.VIN,
                    strikes: currentStrikes,
                })
            ).json();

            if (res) {
                setVehicle({
                    ...vehicle,
                    Strikes: currentStrikes,
                });
            } else toast.error('Unable to Add Strike');
        } catch (err) {
            console.log(err);
            toast.error('Unable to Add Strike');
        }

        setLoading(false);
        setAddingStrike(false);
    };

    const dismissStrike = async (id) => {
        let currentStrikes = vehicle.Strikes ?? Array();

        currentStrikes.splice(id, 1)

        setLoading(true);
        try {
            let res = await (
                await Nui.send('Update', {
                    type: 'vehicle-strikes',
                    VIN: vehicle.VIN,
                    strikes: currentStrikes,
                })
            ).json();

            if (res) {
                setVehicle({
                    ...vehicle,
                    Strikes: currentStrikes,
                });
            } else toast.error('Unable to Remove Strike');
        } catch (err) {
            console.log(err);
            toast.error('Unable to Remove Strike');
        }

        setLoading(false);
        setAddingStrike(false);
    };

    const dismissFlag = async (id) => {
        try {
            let res = await (
                await Nui.send('Delete', {
                    type: 'vehicle-flag',
                    parent: vehicle.VIN,
                    plate: vehicle.RegisteredPlate,
                    removeRadarFlag: vehicle.Flags.length <= 1,
                    id: id,
                })
            ).json();

            if (res) {
                setVehicle({
                    ...vehicle,
                    Flags: vehicle.Flags.filter((f) => f.Type !== id),
                });
            } else toast.error('Unable to Create Flag');
        } catch (err) {
            console.log(err);
            toast.error('Unable to Create Flag');
        }
        setAdding(false);
    };

    const getOrganizationType = (jobId) => {
        if (govJobs.includes(jobId)) {
            return 'Government';
        } else return 'Business';
    };

    const assignDrivers = async (assigned) => {
        setLoading(true);
        try {
            let res = await (
                await Nui.send('SetAssignedDrivers', {
                    vehicle: vehicle.VIN,
                    assigned: assigned,
                })
            ).json();

            if (res) {
                setVehicle({
                    ...vehicle,
                    GovAssigned: assigned,
                });
            } else toast.error('Unable to Update Assigned Drivers');
        } catch (err) {
            console.log(err);
            toast.error('Unable to Update Assigned Drivers');
        }

        setLoading(false);
        setEditingAssigned(false);
    };

    const onTrackVehicle = async () => {
        try {
            let res = await (
                await Nui.send('TrackFleetVehicle', {
                    vehicle: vehicle.VIN,
                })
            ).json();

            if (res) {
                toast.success('Marked GPS Location');
            } else toast.error('Unable to Track Vehicle');
        } catch (err) {
            console.log(err);
            toast.error('Unable to Track Vehicle');
        }
    };

    if (loading || !vehicle) {
        return (
            <div className={classes.nWrapper}>
                {loading ? (
                    <Loader text="Loading" />
                ) : (
                    <>
                        <FontAwesomeIcon className={classes.nWrapperIcon} icon={['fas', 'cars']} />
                        <div>No Vehicle Selected</div>
                    </>
                )}
            </div>
        );
    };

    return (
        <div className={classes.wrapper}>
            <Grid container spacing={2} style={{ height: '100%', paddingBottom: 10 }} justifyContent="center" alignContent="flex-start">
                {vehicle?.RadarFlag && (
                    <Grid item xs={12}>
                        <Alert variant="filled" severity="error">
                            Radar Flagged:{' '}{vehicle.RadarFlag}
                        </Alert>
                    </Grid>
                )}
                <Grid item xs={6}>
                    <List>
                        <ListItem>
                            <ListItemText
                                primary="Vehicle Type"
                                secondary={VehicleTypes?.[vehicle?.Type] ?? 'Vehicle'}
                            />
                        </ListItem>
                        <ListItem>
                            <ListItemText primary="VIN" secondary={vehicle.VIN} />
                        </ListItem>
                        <ListItem>
                            <ListItemText
                                primary="Make / Model"
                                secondary={`${vehicle.Make} ${vehicle.Model}`}
                            />
                        </ListItem>
                        <ListItem>
                            <ListItemText primary="Registered Plate" secondary={vehicle.RegisteredPlate} />
                        </ListItem>
                        {vehicle.Owner?.Type === 0 ? (
                            <ListItem>
                                <ListItemText
                                    primary="Registered Owner"
                                    secondary={
                                        <Link
                                            className={classes.link}
                                            to={`/people?person=${vehicle.Owner?.Id}`}
                                        >
                                            {`${vehicle.Owner.Person?.First} ${vehicle.Owner.Person?.Last}`}
                                        </Link>
                                    }
                                />
                            </ListItem>
                        ) : (
                            <ListItem>
                                <ListItemText
                                    primary="Registered Owner"
                                    secondary={`${getOrganizationType(vehicle.Owner?.Id)} - ${vehicle.Owner?.JobName ?? 'Unknown'
                                        }`}
                                />
                            </ListItem>
                        )}
                        <ListItem>
                            <ListItemText
                                primary="Registration Date"
                                secondary={
                                    vehicle.RegistrationDate ? (
                                        <Moment date={vehicle.RegistrationDate} unix format="LL" />
                                    ) : (
                                        'Unknown'
                                    )
                                }
                            />
                        </ListItem>
                        <ListItem>
                            <ListItemText
                                primary="Impounded"
                                secondary={vehicle.Storage?.Type === 0 ? 'Yes' : 'No'}
                            />
                        </ListItem>
                    </List>
                </Grid>
                <Grid item xs={6}>
                    {myJob.Id == "police" && <ListItem>
                        <ListItemText
                            primary={
                                <span>
                                    Flags{' '}
                                    <IconButton style={{ fontSize: 16 }} onClick={() => setAdding(true)}>
                                        <FontAwesomeIcon icon={['fas', 'plus']} />
                                    </IconButton>
                                </span>
                            }
                            secondary={vehicle.Flags?.length == 0 ? 'No Flags' : null}
                        />
                    </ListItem>}
                    {vehicle.Flags?.length > 0 && (
                        <ListItem>
                            <List
                                style={{
                                    maxHeight: 650,
                                    height: '100%',
                                    overflowY: 'auto',
                                    overflowX: 'hidden',
                                }}
                            >
                                {vehicle.Flags.map((f) => {
                                    return <VehicleFlag key={`flag-${f.value}`} flag={f} onDismiss={dismissFlag} />;
                                })}
                            </List>
                        </ListItem>
                    )}
                    {myJob.Id == "police" && <ListItem>
                        <ListItemText
                            primary={
                                <span>
                                    Vehicle Strikes{' '}
                                    <IconButton style={{ fontSize: 16 }} onClick={() => setAddingStrike(true)}>
                                        <FontAwesomeIcon icon={['fas', 'plus']} />
                                    </IconButton>
                                </span>
                            }
                            secondary={vehicle.Strikes?.length == 0 ? 'No Flags' : null}
                        />
                    </ListItem>}
                    {vehicle.Strikes?.length > 0 && (
                        <ListItem>
                            <List
                                style={{
                                    maxHeight: 650,
                                    height: '100%',
                                    overflowY: 'auto',
                                    overflowX: 'hidden',
                                }}
                            >
                                {vehicle.Strikes.map((v, k) => {
                                    return <VehicleStrike key={`strike-${k}`} index={k} strike={v} onDismiss={dismissStrike} />;
                                })}
                            </List>
                        </ListItem>
                    )}
                    <ListItem>
                        <ListItemText
                            primary={'Ownership History'}
                            secondary={<span className={classes.newLineStuff}>{
                                vehicle.OwnerHistory ? vehicle.OwnerHistory.map(o => {
                                    if (o.Type == 0) {
                                        if (o.First) {
                                            return `Transferred From State ID: ${o.Id} (${o.First} ${o.Last}) on ${moment(o.Time * 1000).format('LLLL')}`;
                                        } else {
                                            return `Transferred From State ID: ${o.Id}`;
                                        }
                                    } else {
                                        return `Transferred From Organization`;
                                    }
                                }).concat('; \n') : 'No Previous Owners'}
                            </span>}
                        />
                    </ListItem>
                    {vehicle.PreviousPlates && <ListItem>
                        <ListItemText
                            primary={'License Plate History'}
                            secondary={
                                vehicle.PreviousPlates ? vehicle.PreviousPlates.map(o => {
                                    return <span>{`${o.oldPlate} -> ${o.newPlate} on ${moment(o.time * 1000).format('LLLL')}`}<br></br></span>
                                })
                                    : 'No Previous Plates'
                            }
                        />
                    </ListItem>}
                    {isFleetManage && <ListItem>
                        <ListItemText
                            primary={
                                <span>
                                    Storage Location{' '}
                                    <IconButton style={{ fontSize: 16 }} onClick={onTrackVehicle}>
                                        <FontAwesomeIcon icon={['fas', 'location']} />
                                    </IconButton>
                                </span>
                            }
                            secondary={vehicle?.Storage?.Name ?? "Unknown"}
                        />
                    </ListItem>}
                    {isFleetManage && <ListItem>
                        <ListItemText
                            primary={
                                <span>
                                    Assigned Drivers{' '}
                                    <IconButton style={{ fontSize: 16 }} onClick={() => setEditingAssigned(true)}>
                                        <FontAwesomeIcon icon={['fas', 'plus']} />
                                    </IconButton>
                                </span>
                            }
                            secondary={vehicle.GovAssigned?.length > 0 ? vehicle.GovAssigned.map(g => `(${g.Callsign ?? 'N/A'}) ${g.First[0]}. ${g.Last}`).join(", ") : 'Non Assigned'}
                        />
                    </ListItem>}
                </Grid>
            </Grid>
            <FlagForm open={adding} flagTypes={FlagTypes} onSubmit={addFlag} onClose={() => setAdding(false)} />
            <StrikeForm open={addingStrike} onSubmit={addStrike} onClose={() => setAddingStrike(false)} />

            <AssigneesForm open={editingAssigned} onSubmit={assignDrivers} onClose={() => setEditingAssigned(false)} existing={vehicle.GovAssigned} />
        </div>
    );
};
