import React, { useState, useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import {
    Grid,
    TextField,
    ButtonGroup,
    Button,
    Alert,
    MenuItem,
    Typography,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import { useNavigate, useLocation } from 'react-router';
import { toast } from 'react-toastify';
import qs from 'qs';
import moment from 'moment';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import Lightbox from 'react-image-lightbox';

import Nui from '../../util/Nui';
import { Loader, OfficerSearch, PersonSearch, Editor2, Modal } from '../../components';
import { ReportTypes, GetOfficerNameFromReportType, GetOfficerJobFromReportType } from '../../data';
import { useGovJob, usePermissions, useQualifications } from '../../hooks';

import SuspectForm from './components/SuspectForm';
import Suspect from './components/Suspect';
import SuspectView from './components/SuspectView';
import EvidenceForm from './components/EvidenceForm';
import Evidence from './components/Evidence';

import { initialState as susState } from './components/SuspectForm';

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
    editorField: {
        marginBottom: 10,
    },
    title: {
        fontSize: 18,
        color: theme.palette.text.main,
        textAlign: 'center',
    },
    option: {
        transition: 'background ease-in 0.15s',
        border: `1px solid ${theme.palette.border.divider}`,
        '&:hover': {
            background: theme.palette.secondary.main,
            cursor: 'pointer',
        },
        '&.selected': {
            color: theme.palette.primary.main,
        },
    },
    calculator: {
        height: '100%',
    },
    col: {
        //minHeight: '100%',
        // overflowY: 'auto',
        // overflowX: 'hidden',
        padding: 5,
    },
    formActions: {
        paddingBottom: 10,
        marginBottom: 5,
        borderBottom: `1px inset ${theme.palette.border.divider}`,
    },
    positiveButton: {
        borderColor: `${theme.palette.success.main}80`,
        color: theme.palette.success.main,
        '&:hover': {
            borderColor: theme.palette.success.main,
            background: `${theme.palette.success.main}14`,
        },
    },
    infoButton: {
        borderColor: `${theme.palette.info.main}80`,
        color: theme.palette.info.main,
        '&:hover': {
            borderColor: theme.palette.info.main,
            background: `${theme.palette.info.main}14`,
        },
    },
    negativeButton: {
        borderColor: `${theme.palette.error.light}80`,
        color: theme.palette.error.light,
        '&:hover': {
            borderColor: theme.palette.error.light,
            background: `${theme.palette.error.light}14`,
        },
    },
    popup: {
        maxHeight: `750px !important`,
    },
    draftItem: {
        borderBottom: `1px solid ${theme.palette.border.divider}`,
    },
    draftBtn: {
        '&:first-of-type': {
            marginRight: 10,
        },
    },
}));

// returns [added, removed]
const getPeopleChangesWow = (type, orig, newest) => {
    return [
        newest.filter(p => !orig.find(p2 => p2.SID === p.SID)).map(p => ({
            type,
            mode: "add",
            data: p,
        })),
        orig.filter(p => !newest.find(p2 => p2.SID === p.SID)).map(p => ({
            type,
            mode: "delete",
            data: p,
        })),
    ];
}

const ReportSaveButton = ({ type, onClick, canEdit }) => {
    switch (type) {
        case 'view':
            return <Button onClick={onClick} color="primary" disabled={!canEdit}>
                Edit Report
            </Button>
        case 'edit':
            return <Button onClick={onClick} color="warning">
                Save Report
            </Button>
        case 'create':
            return <Button onClick={onClick} color="success">
                Save Report
            </Button>
    }
}

export default (props) => {
    const classes = useStyles();
    const dispatch = useDispatch();
    const location = useLocation();
    const history = useNavigate();
    const hasJob = useGovJob();
    const hasPermission = usePermissions();
    const hasQualification = useQualifications();
    const myJob = useSelector((state) => state.app.govJob);

    const [editor, setEditor] = useState(null);
    const [initialEditorState, setInitialEditorState] = useState('');

    let qry = qs.parse(location.search.slice(1));
    const reportId = qry.report;
    const reportMode = qry.mode;
    const preSuspectQry = qry.addSuspect;

    const createReport = () => {
        let s = qs.parse(location.search.slice(1));
        delete s.report
        history({
            path: location.pathname,
            search: qs.stringify(s),
        });

        setTimeout(() => {
            s.mode = "create";

            history({
                path: location.pathname,
                search: qs.stringify(s),
            });
        }, 250);
    };

    const user = useSelector((state) => state.app.user);
    const me = {
        _id: user.ID,
        SID: user.SID,
        User: user.User,
        First: user.First,
        Last: user.Last,
        Gender: user.Gender,
        Origin: user.Origin,
        Job: user.Job,
        DOB: user.DOB,
        Callsign: user.Callsign,
        Phone: user.Phone,
        Licenses: user.Licenses,
    };


    const initialState = {
        type: ReportTypes.filter((r) => hasPermission(r.requiredCreatePermission, false))?.[0]?.value,
        title: '',
        notes: '',
        primariesInput: '',
        primaries: [me],
        suspects: Array(),
        suspectsOverturned: Array(),
        // suspects: [
        //     { sentenced: true, SID: 1, First: "Bob", Last: "Bobson", Licenses: { Drivers: { Points: 0 } }, charges: [], plea: "unknown" },
        // ],
        // suspectsOverturned: [
        //     { sentenced: true, SID: 1, First: "Bob", Last: "Bobson", Licenses: { Drivers: { Points: 0 } }, charges: [], plea: "unknown" },
        // ],
        peopleInput: '',
        people: Array(),
        evidence: Array(),
        evidenceCounter: 0,
        allowAttorney: false,
    };

    const [evidence, setEvidence] = useState(false);
    const [editEvidence, setEditEvidence] = useState(null);

    const [pOpen, setPOpen] = useState(false);
    const [pIndex, setPIndex] = useState(0);

    const [loading, setLoading] = useState(false);
    const [state, setState] = useState({ ...initialState });
    const [original, setOriginal] = useState(null);
    const [changes, setChanges] = useState(Array());
    const [form, setForm] = useState(false);
    const [editing, setEditing] = useState(null);
    const [officers, setOfficers] = useState(Array());
    const [people, setPeople] = useState(Array());

    const [preSuspect, setPreSuspect] = useState(null);

    const addChange = (mode, type, data) => {
        setChanges([
            ...changes,
            {
                mode,
                type,
                data,
            }
        ]);
    }

    const fetch = async (id) => {
        setLoading(true);
        try {
            let res = await (
                await Nui.send('View', {
                    type: 'report',
                    id,
                })
            ).json();
            if (res) {
                setState(res);
                setInitialEditorState(res.notes);
                setOriginal(res);
                setChanges(Array());
            }
        } catch (err) {
            console.log(err);
            toast.error('Unable to Load Report');
        }
        setLoading(false);
    };

    useEffect(() => {
        if (reportId && reportMode !== "create") {
            fetch(reportId);
        } else {
            setState({
                type: ReportTypes.filter((r) => hasPermission(r.requiredCreatePermission, false))?.[0]?.value,
                title: '',
                notes: '',
                primariesInput: '',
                primaries: [me],
                suspects: Array(),
                peopleInput: '',
                people: Array(),
                evidence: Array(),
                evidenceCounter: 0,
                allowAttorney: false,
            });
            setInitialEditorState('');
        };
    }, [reportId]);

    useEffect(() => {
        if (reportMode == "create" && preSuspectQry) {
            let s = qs.parse(location.search.slice(1));
            setPreSuspect(s.addSuspect);
            setForm(true);
            delete s.addSuspect

            history({
                path: location.pathname,
                search: qs.stringify(s),
            });
        }
    }, [preSuspectQry]);

    const onSuspectCancel = () => {
        setForm(false);
        setEditing(null);
        setPreSuspect(null);
    };

    const onSuspectEdit = (suspect) => {
        setEditing(suspect);
    };

    const onSuspectDelete = (suspect) => {
        setState({
            ...state,
            suspects: state.suspects.filter((s) => s.SID != suspect.SID),
        });
        addChange("delete", "suspect", suspect);
    };

    const onEditSuspect = (sState) => {
        setState({
            ...state,
            suspects: state.suspects.map((s) => {
                if (s.SID == sState.SID) return sState;
                else return s;
            }),
        });
        onSuspectCancel();
        addChange("update", "suspect", sState);
    };

    const onAddSuspect = (sState) => {
        let exists = state.suspects.filter((s) => s.SID == sState.SID).length > 0;

        if (!exists) {
            setState({
                ...state,
                suspects: [...state.suspects, sState],
            });
            addChange("add", "suspect", sState);
        } else {
            toast.error('Suspect Already Added To Report');
        }
        onSuspectCancel();
    };

    const onAddEvidence = (evidence) => {
        setState({
            ...state,
            evidence: [
                ...state.evidence,
                {
                    ...evidence,
                    id: `local-${Date.now()}`,
                },
            ],
        });
        setEvidence(false);
        addChange("add", "evidence", evidence);
    };

    const onRemoveEvidence = (evidence) => {
        setState({
            ...state,
            evidence: state.evidence.filter((e) => e.id != evidence.id),
        });

        addChange("delete", "evidence", evidence);
    };

    const onEvidenceOpen = (index) => {
        setPIndex(index);
        setPOpen(true);
    };

    const onEvidenceLocker = async () => {
        if (reportMode == "view") {
            try {
                let res = await (await Nui.send('EvidenceLocker', state?.id)).json();
                if (res) Nui.send('Close');
                else toast.error('Unable to Open Evidence Locker');
            } catch (err) {
                console.log(err);
                toast.error('Unable to Open Evidence Locker');
            }
        }
    };

    const onSubmit = async (e) => {
        e.preventDefault();

        if (!editor) return;

        const rawValue = editor.getData();
        const reg = /src=\"data:image\/([a-zA-Z]*);base64,([^\"]*)\"/g
        const value = rawValue.replace(reg, "src=\"https://i.ibb.co/x1vt3YY/ph.webp\"");

        if (reportMode === "create" || reportMode === "edit") {
            if (state.type == 0 && state.suspects.length == 0) {
                toast.error('Must Select Suspect');
                return;
            } else if (state.title == '') {
                toast.error('Must Add Report Title');
                return;
            } else if (value == '') {
                toast.error('Must Add Report Notes');
                return;
            }
        }

        if (reportMode === "create") { // Creating New Report
            try {
                let res = await (
                    await Nui.send('Create', {
                        type: 'report',
                        doc: {
                            type: state.type,
                            title: state.title,
                            notes: value,
                            time: Date.now(),
                            evidence: state.evidence,
                            suspects: state.suspects,
                            primaries: state.primaries,
                            people: state.people,
                            allowAttorney: state.allowAttorney,
                        },
                    })
                ).json();

                if (res) {
                    let s = qs.parse(location.search.slice(1));
                    s.report = res;
                    s.mode = "view"
                    history({
                        path: location.pathname,
                        search: qs.stringify(s),
                    });

                    toast.success('Report Created');
                } else toast.error('Unable to Create Report');
            } catch (e) {
                toast.error('Unable to Create Report');
            }
        } else if (reportMode === "view") { // Begin Editing a Report
            // TODO: Check Permissions 1st
            let s = qs.parse(location.search.slice(1));
            s.mode = "edit"
            history({
                path: location.pathname,
                search: qs.stringify(s),
            });
        } else if (reportMode === "edit") {
            try {
                const [addedPeople, removedPeople] = getPeopleChangesWow("person", original.people, state.people);
                const [addedPrimary, removedPrimary] = getPeopleChangesWow("primary", original.primaries, state.primaries);

                const c = [
                    ...changes,
                    ...addedPeople,
                    ...removedPeople,
                    ...addedPrimary,
                    ...removedPrimary,
                ];

                let res = await (
                    await Nui.send('Update', {
                        type: 'report',
                        id: state.id,
                        report: {
                            type: state.type,
                            title: state.title,
                            notes: value,
                            time: state.time,
                            allowAttorney: state.allowAttorney,
                            changes: c,
                        },
                    })
                ).json();

                if (res) {
                    let s = qs.parse(location.search.slice(1));
                    s.mode = "view"
                    history({
                        path: location.pathname,
                        search: qs.stringify(s),
                    });

                    toast.success('Report Edited');
                    setChanges(Array());
                    fetch(state.id);
                } else toast.error('Unable to Edit Report');
            } catch (e) {
                toast.error('Unable to Edit Report');
            }
        };
    };

    const reportOfficerName = GetOfficerNameFromReportType(state.type);
    const reportOfficerType = GetOfficerJobFromReportType(state.type);

    const reportTypeData = ReportTypes.find(r => r.value === state.type);
    const canEdit = hasPermission(reportTypeData?.requiredCreatePermission);

    if ((!reportId && reportMode !== "create") || loading) {
        return (
            <div className={classes.nWrapper}>
                {loading ? (
                    <Loader text="Loading" />
                ) : (
                    <>
                        <FontAwesomeIcon className={classes.nWrapperIcon} icon={['fas', 'file-lines']} />
                        <div>No Report Selected</div>
                        {myJob && <Button onClick={createReport} sx={{ margin: '0 auto' }}>Create New</Button>}
                    </>
                )}
            </div>
        );
    };

    const getReportTypeHasEvidence = (reportType) => {
        return ReportTypes.find((r) => r.value == reportType)?.hasEvidence;
    };

    return (
        <div className={classes.wrapper}>
            <Grid container style={{ height: '100%', paddingBottom: 10 }} spacing={2} justifyContent="center" alignContent="flex-start">
                <Grid item xs={12}>
                    <Grid container className={classes.formActions}>
                        <Grid item xs={6}>
                            <Typography className={classes.title} noWrap>
                                {reportMode !== "create" ? `Report #${state?.id ?? 1}` : "New Report"} - {state.title}
                            </Typography>
                        </Grid>
                        <Grid item xs={6} style={{ textAlign: 'right' }}>
                            <ButtonGroup fullWidth color="inherit">
                                {(reportMode === "view" && myJob?.Id === "police" && getReportTypeHasEvidence(state?.type)) ? (
                                    <Button className={classes.infoButton} variant="outlined" onClick={onEvidenceLocker}>Evidence Locker</Button>
                                ) : null}
                                {(reportMode !== "view") && <Button
                                    className={classes.infoButton}
                                    variant="outlined"
                                    onClick={() => setEvidence(true)}
                                >
                                    Add Evidence
                                </Button>}
                                {(state.type === 0 && reportMode !== "view") && (
                                    <Button
                                        className={classes.positiveButton}
                                        variant="outlined"
                                        onClick={() => setForm(true)}
                                    >
                                        Add Suspect
                                    </Button>
                                )}
                                <ReportSaveButton type={reportMode} onClick={onSubmit} canEdit={canEdit} />
                            </ButtonGroup>
                        </Grid>
                    </Grid>
                </Grid>
                <Grid item xs={6} className={classes.col} sx={{ minHeight: '100%' }}>
                    <div style={{ display: 'flex', height: '95%' }}>
                        <Editor2
                            allowMedia
                            name="notes"
                            title="Report Notes"
                            placeholder={'Enter Report Notes'}
                            disabled={reportMode === "view"}
                            editor={editor}
                            setEditor={setEditor}
                            initialEditorState={initialEditorState}
                        />
                    </div>
                </Grid>
                <Grid item xs={6} className={classes.col} sx={{ maxHeight: '95%', overflowY: 'auto' }}>
                    <Evidence
                        evidence={state.evidence}
                        onClick={(index) => {
                            onEvidenceOpen(index);
                        }}
                        onDelete={reportMode !== "view" ? onRemoveEvidence : null}
                    />
                    <TextField
                        select
                        fullWidth
                        variant="standard"
                        label="Report Type"
                        disabled={reportMode !== "create"}
                        name="type"
                        className={classes.editorField}
                        value={state.type}
                        onChange={(e) => setState({ ...state, type: e.target.value })}
                    >
                        {ReportTypes.filter((r) => hasPermission(r.requiredCreatePermission, false)).map((option) => (
                            <MenuItem key={option.value} value={option.value}>
                                {option.label}
                            </MenuItem>
                        ))}
                    </TextField>
                    <TextField
                        className={classes.editorField}
                        label="Report Title"
                        fullWidth
                        disabled={reportMode === "view"}
                        variant="standard"
                        placeholder="Report Title"
                        value={state.title}
                        onChange={(e) => setState({ ...state, title: e.target.value })}
                    />
                    {reportTypeData.allowAttorney && <TextField
                        select
                        fullWidth
                        variant="standard"
                        label="Attorney Access"
                        disabled={reportMode === "view"}
                        name="type"
                        className={classes.editorField}
                        value={state.allowAttorney}
                        onChange={(e) => setState({ ...state, allowAttorney: e.target.value })}
                    >
                        <MenuItem key="do-not-allow" value={false}>
                            Don't Allow Attorney Viewing
                        </MenuItem>
                        <MenuItem key="allow" value={true}>
                            Allow Attorney Viewing
                        </MenuItem>
                    </TextField>}
                    <OfficerSearch
                        disableSelf
                        job={reportOfficerType}
                        label={`${reportOfficerName} Involved`}
                        disabled={reportMode === "view"}
                        value={state.primaries}
                        inputValue={state.primariesInput}
                        options={officers}
                        setOptions={setOfficers}
                        onChange={(e, nv) => {
                            if (nv.length == 0) {
                                setState({
                                    ...state,
                                    primaries: [user],
                                    primariesInput: '',
                                });
                            } else {
                                setState({
                                    ...state,
                                    primaries: nv,
                                    primariesInput: '',
                                });
                            }
                        }}
                        onInputChange={(e, nv) => setState({ ...state, primariesInput: nv })}
                    />
                    {state.type !== 0 && (
                        <PersonSearch
                            label="People Involved"
                            placeholder="John Doe, Jane Doe etc..."
                            value={state.people}
                            inputValue={state.peopleInput}
                            options={people}
                            disabled={reportMode === "view"}
                            setOptions={setPeople}
                            onChange={(e, nv) => {
                                if (nv.length == 0) {
                                    setState({
                                        ...state,
                                        people: [],
                                        peopleInput: '',
                                    });
                                } else {
                                    setState({
                                        ...state,
                                        people: nv,
                                        peopleInput: '',
                                    });
                                }
                            }}
                            onInputChange={(e, nv) => setState({ ...state, peopleInput: nv })}
                        />
                    )}
                    {state.suspects.length > 0
                        ? state.suspects.map((suspect, k) => {
                            if (reportMode === "view") {
                                return (
                                    <SuspectView
                                        key={`suspect-${k}`}
                                        data={suspect}
                                        report={state}
                                        paroleData={state?.paroleData?.find(p => p.SID == suspect.SID)}
                                        refresh={() => {
                                            fetch(state.id);
                                        }}
                                    />
                                );
                            } else {
                                return (
                                    <Suspect
                                        key={`suspect-${k}`}
                                        data={suspect}
                                        onEdit={() => onSuspectEdit(suspect)}
                                        onDelete={() => onSuspectDelete(suspect)}
                                    />
                                );
                            }
                        })
                        : state.type === 0 && (
                            <Alert variant="outlined" severity="info" style={{ margin: 25 }}>
                                Please Add A Suspect To Your Report
                            </Alert>
                        )}
                    {state.suspectsOverturned?.length > 0
                        && state.suspectsOverturned.map((suspect, k) => {
                            return (
                                <SuspectView
                                    key={`suspect-overturned-${k}`}
                                    overturned
                                    data={suspect}
                                    report={state}
                                />
                            );
                        })}
                </Grid>
            </Grid>
            <SuspectForm
                open={form || Boolean(editing)}
                suspect={editing}
                onSubmit={onAddSuspect}
                onCancel={onSuspectCancel}
                onEdit={onEditSuspect}
                preSuspect={preSuspect}
            />

            <EvidenceForm
                open={evidence}
                existing={editEvidence}
                onSubmit={onAddEvidence}
                onClose={() => setEvidence(false)}
            />
            {
                state.evidence.length > 0 && pOpen && (
                    <Lightbox
                        mainSrc={state.evidence[pIndex].value}
                        nextSrc={state.evidence[(pIndex + 1) % state.evidence.length].value}
                        prevSrc={state.evidence[(pIndex + state.evidence.length - 1) % state.evidence.length].value}
                        onCloseRequest={() => setPOpen(false)}
                        onMovePrevRequest={() => setPIndex((pIndex + state.evidence.length - 1) % state.evidence.length)}
                        onMoveNextRequest={() => setPIndex((pIndex + 1) % state.evidence.length)}
                    />
                )
            }
        </div >
    );
};
