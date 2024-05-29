import React, { useEffect, useState } from 'react';
import { useSelector } from 'react-redux';
import {
    List,
    ListItem,
    ListItemText,
    Grid,
    ButtonGroup,
    Button,
    TextField,
    MenuItem,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import moment from 'moment';
import { toast } from 'react-toastify';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { Link, useLocation } from 'react-router-dom';

import qs from 'qs';

import { Loader, Modal } from '../../components';
import { Sanitize } from '../../util/Parser';
import Nui from '../../util/Nui';

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
}));

const WarrantStates = [
    {
        label: 'Active',
        value: 'active',
    },
    {
        label: 'Served',
        value: 'served',
    },
    {
        label: 'Expired',
        value: 'expired',
    },
    {
        label: 'Void',
        value: 'void',
    },
];


export default ({ }) => {
    const classes = useStyles();
    const location = useLocation();
    const myJob = useSelector(state => state.app.govJob);

    let qry = qs.parse(location.search.slice(1));
    const warrantId = qry.warrant;

    const [loading, setLoading] = useState(false);
    const [err, setErr] = useState(false);
    const [warrant, setWarrant] = useState(null);
    const [updating, setUpdating] = useState(false);

    const fetch = async (wId) => {
        setLoading(true);
        try {
            let res = await (
                await Nui.send('View', {
                    type: 'warrant',
                    id: wId,
                })
            ).json();

            if (res) setWarrant(res);
            else toast.error('Unable to Load');
        } catch (err) {
            console.log(err);
            toast.error('Unable to Load');
            setErr(true);
        }

        setLoading(false);
    };

    useEffect(() => {
        if (warrantId) {
            fetch(warrantId);
        };
    }, [warrantId]);

    const onSubmit = async (e) => {
        e.preventDefault();

        try {
            let res = await (
                await Nui.send('Update', {
                    type: 'warrant',
                    id: warrant.id,
                    state: updating,
                })
            ).json();

            console.log(res)

            if (res) {
                setUpdating(false);
                toast.success('Warrant Updated');
                fetch(warrant.id);
            } else toast.error('Unable to Update Warrant');
        } catch (err) {
            console.log(err);
            toast.error('Unable to Update Warrant');
        }
    };

    if (loading || !warrant) {
        return (
            <div className={classes.nWrapper}>
                {loading ? (
                    <Loader text="Loading" />
                ) : (
                    <>
                        <FontAwesomeIcon className={classes.nWrapperIcon} icon={['fas', 'file-certificate']} />
                        <div>No Warrant Selected</div>
                    </>
                )}
            </div>
        );
    };

    return (
        <div className={classes.wrapper}>
            <Grid container spacing={2} style={{ height: '100%', paddingBottom: 10 }} justifyContent="center" alignContent="flex-start">
                {myJob?.Id === "police" && <Grid item xs={12}>
                    <ButtonGroup fullWidth>
                        <Button onClick={() => setUpdating(warrant.state === "active" ? "void" : warrant.state)}>Update Status</Button>
                    </ButtonGroup>
                </Grid>}
                <Grid item xs={6}>
                    <List>
                        <ListItem>
                            <ListItemText
                                primary="Title"
                                secondary={warrant.title}
                            />
                        </ListItem>
                        <ListItem>
                            <ListItemText
                                primary="Issued At"
                                secondary={moment(warrant.issued).format('LLLL')}
                            />
                        </ListItem>
                        {warrant.suspectData && <ListItem>
                            <ListItemText
                                primary="Suspect"
                                secondary={
                                    <Link className={classes.link} to={`/people?person=${warrant.suspectData.SID}`}>
                                        {`${warrant.suspectData.First} ${warrant.suspectData.Last} (${warrant.suspectData.SID})`}
                                    </Link>
                                }
                            />
                        </ListItem>}
                        {myJob?.Id && <>
                            <ListItem>
                                <ListItemText
                                    primary="Issuing Officer"
                                    secondary={`[${warrant.creatorCallsign}] ${warrant.creatorName} (${warrant.creatorSID})`}
                                />
                            </ListItem>
                            <ListItem>
                                <ListItemText
                                    primary="Report"
                                    secondary={
                                        <Link className={classes.link} to={`/reports?report=${warrant.report}&mode=view`}>
                                            Report #{warrant.report}
                                        </Link>
                                    }
                                />
                            </ListItem>
                        </>}
                        {warrant.status !== 'active' ? (
                            <ListItem>
                                <ListItemText
                                    primary="Status"
                                    secondary={WarrantStates.find((w) => w.value == warrant.state)?.label}
                                />
                            </ListItem>
                        ) : (warrant.status === 'active' && warrant.expires < Date.now()) ? (
                            <ListItem>
                                <ListItemText
                                    primary="Expires"
                                    secondary={moment(warrant.expires).format('LLLL')}
                                />
                            </ListItem>
                        ) : (
                            <ListItem>
                                <ListItemText primary="Expires" secondary="Expired" />
                            </ListItem>
                        )}
                    </List>
                </Grid>
                <Grid item xs={6}>
                    {myJob?.Id && <List>
                        <ListItem>
                            <ListItemText primary="Warrant Notes" />
                        </ListItem>
                        <div className={classes.notes}>{Sanitize(warrant.notes)}</div>
                    </List>}
                </Grid>
            </Grid>

            <Modal
                open={updating}
                title="Update Warrant"
                submitLang="Update"
                onSubmit={onSubmit}
                onClose={() => setUpdating(false)}
            >
                <p>A warrant state cannot be changed back to active once changed, a new warrant will have to be issued.</p>
                <TextField
                    select
                    fullWidth
                    required
                    label="State"
                    name="state"
                    className={classes.field}
                    value={updating}
                    onChange={(e) => setUpdating(e.target.value)}
                >
                    {WarrantStates.filter(w => w.value !== "active").map((option) => (
                        <MenuItem key={option.value} value={option.value}>
                            {option.label}
                        </MenuItem>
                    ))}
                </TextField>
            </Modal>
        </div>
    );
};
