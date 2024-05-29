import React, { useEffect, useState } from 'react';
import { useSelector } from 'react-redux';
import {
    TextField,
    Paper,
    Grid,
    Tabs,
    Tab,
    Button,
    MenuItem,
} from '@mui/material';
import { makeStyles } from '@mui/styles';

import Nui from '../../util/Nui';
import { usePermissions } from '../../hooks';
import { Loader } from '../../components';
import { toast } from 'react-toastify';

const useStyles = makeStyles((theme) => ({
    wrapper: {
        padding: 10,
        height: '100%',
    },
    paper: {
        height: '100%',
        maxHeight: '100%',
    },
    inner: {
        display: 'flex',
        flexDirection: 'column',
        padding: '10px 5px 10px 5px',
        height: '100%',
    },
    fullHeight: {
        height: '100%',
    },
    editorField: {
        marginBottom: 10,
    },
    loaderStuff: {
        display: 'flex',
        width: '100%',
        height: '50%',
        justifyContent: 'center',
        alignContent: 'center',
        marginTop: 50,
    }
}));

export default () => {
    const classes = useStyles();
    const hasPerm = usePermissions();
    const myJob = useSelector(state => state.app.govJob);
    const governmentJobs = useSelector(state => state.data.data.governmentJobs);

    const allJobData = useSelector(state => state.data.data.governmentJobsData);
    const [jobData, setJobData] = useState(allJobData?.[myJob?.Id]);

    const [loading, setLoading] = useState(false);
    const [docs, setDocs] = useState(Array());
    const [selected, setSelected] = useState(1);
    const [creating, setCreating] = useState({
        job: myJob?.Id ?? false,
        workplace: false,
        link: '',
        label: '',
    });

    useEffect(() => {
        setJobData(allJobData?.[creating?.job]);
        setCreating({ ...creating, workplace: false });
    }, [creating.job, allJobData]);

    const isSysAdmin = hasPerm(true);

    useEffect(() => {
        fetch();
    }, []);

    const fetch = async () => {
        setLoading(true);

        try {
            let res = await (
                await Nui.send('GetLibraryDocuments', {})
            ).json();
            if (res) setDocs(res);
            else setDocs(Array());
            setLoading(false);
            setSelected(res?.[0]?.id);
        } catch (err) {
            console.log(err);
            setLoading(false);
            //setResults(Array());
            // setDocs([
            //     {
            //         id: 1,
            //         label: "SOPs",
            //         link: "https://sandboxrp.gg/files/pd_sop.pdf"
            //     },
            // ]);
            // setSelected(1);
        }
    };

    const onChange = (e) => {
        setCreating({ ...creating, [e.target.name]: e.target.value });
    };

    const onAddDocument = async () => {
        setLoading(true);

        try {
            let res = await (
                await Nui.send('AddLibraryDocument', creating)
            ).json();
            if (res) {
                toast.success('Sucessfully Added Document to Library');
                fetch();
            } else throw res;
        } catch (err) {
            console.log(err);
            toast.error('Failed to Add Document to Library');
        }
        setLoading(false);
    };

    const onRemoveDocument = async (id) => {
        setLoading(true);

        try {
            let res = await (
                await Nui.send('RemoveLibraryDocument', {
                    id,
                })
            ).json();
            if (res) {
                toast.success('Sucessfully Added Document to Library');
                fetch();
            } else throw res;
        } catch (err) {
            console.log(err);
            toast.error('Failed to Add Document to Library');
        }
        setLoading(false);
    };

    return (
        <div className={classes.wrapper}>
            <Grid container spacing={1} sx={{ height: '100%' }}>
                <Grid item xs={12}>
                    <Paper elevation={3} className={classes.paper}>
                        <div className={classes.inner}>
                            {!loading ?
                                (
                                    <Grid container spacing={2} className={classes.fullHeight}>
                                        <Grid item xs={2} className={classes.fullHeight}>
                                            <Tabs
                                                orientation="vertical"
                                                variant="scrollable"
                                                sx={{ borderRight: 1, borderColor: 'divider', height: '100%' }}
                                                value={selected}
                                                onChange={(event, newValue) => setSelected(newValue)}
                                            >
                                                {docs.map(doc => <Tab label={doc.label} value={doc.id} />)}
                                                {isSysAdmin && <Tab label="Add New Document" value={-1} />}
                                            </Tabs>
                                        </Grid>
                                        <Grid item xs={10} className={classes.fullHeight}>
                                            {selected == -1 ? (
                                                <>
                                                    <TextField
                                                        required
                                                        fullWidth
                                                        variant="standard"
                                                        className={classes.editorField}
                                                        label="Document Label"
                                                        name="label"
                                                        value={creating.label}
                                                        onChange={onChange}
                                                        inputProps={{ maxLength: 64 }}
                                                    />
                                                    <TextField
                                                        required
                                                        fullWidth
                                                        variant="standard"
                                                        className={classes.editorField}
                                                        label="Document Link (Must be .pdf)"
                                                        name="link"
                                                        value={creating.link}
                                                        onChange={onChange}
                                                        inputProps={{ maxLength: 400 }}
                                                    />
                                                    <TextField
                                                        select
                                                        fullWidth
                                                        label="Agency"
                                                        name="job"
                                                        variant="standard"
                                                        className={classes.editorField}
                                                        value={creating.job}
                                                        onChange={onChange}
                                                    >
                                                        {governmentJobs.map(j => (
                                                            <MenuItem key={j} value={j}>
                                                                {allJobData[j]?.Name ?? 'Unknown'}
                                                            </MenuItem>
                                                        ))}
                                                    </TextField>
                                                    <TextField
                                                        select
                                                        fullWidth
                                                        label="Department"
                                                        name="workplace"
                                                        variant="standard"
                                                        className={classes.editorField}
                                                        value={creating.workplace}
                                                        onChange={onChange}
                                                    >
                                                        <MenuItem key={false} value={false}>
                                                            All Departments
                                                        </MenuItem>
                                                        {jobData.Workplaces.map(w => (
                                                            <MenuItem key={w.Id} value={w.Id}>
                                                                {w.Name}
                                                            </MenuItem>
                                                        ))}
                                                    </TextField>
                                                    <Button fullWidth onClick={onAddDocument}>Add To Library</Button>
                                                </>
                                            ) : (
                                                <>
                                                    <iframe src={docs.find(d => d.id == selected)?.link} title="sandbox" width="100%" height={isSysAdmin ? "95%" : "100%"}></iframe>
                                                    {isSysAdmin && <Button fullWidth onClick={() => onRemoveDocument(docs.find(d => d.id == selected)?.id)}>Remove Document</Button>}
                                                </>
                                            )}
                                        </Grid>
                                    </Grid>
                                ) : (
                                    <div className={classes.loaderStuff}>
                                        <Loader />
                                    </div>
                                )}
                        </div>
                    </Paper>
                </Grid>
            </Grid>
        </div>
    );
};
