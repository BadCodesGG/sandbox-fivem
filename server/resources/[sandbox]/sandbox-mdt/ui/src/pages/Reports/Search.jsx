import React, { useEffect, useMemo, useState } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import {
    Grid,
    TextField,
    InputAdornment,
    IconButton,
    Pagination,
    List,
    MenuItem,
    Fab,
    Checkbox,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import { throttle } from 'lodash';
import qs from 'qs';
import { useNavigate, useLocation } from 'react-router';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { usePermissions, useGovJob, usePerPage } from '../../hooks';

import Nui from '../../util/Nui';
import { Loader } from '../../components';
import Item from './components/Report';

import { ReportTypes } from '../../data';

const useStyles = makeStyles((theme) => ({
    wrapper: {
        padding: '10px 5px 10px 5px',
        height: '100%',
        display: 'flex',
        flexDirection: 'column',
    },
    search: {},
    results: {
        flexGrow: 1,
    },
    noResults: {
        margin: '15% 0',
        textAlign: 'center',
        fontSize: 22,
        color: theme.palette.text.main,
    },
    items: {
        maxHeight: '100%',
        height: '100%',
        overflowY: 'auto',
        overflowX: 'hidden',
    },
    fab: {
        position: 'sticky',
        bottom: '5%',
        left: '100%',
        marginRight: '5%',
    }
}));

export default () => {
    const classes = useStyles();
    const dispatch = useDispatch();
    const hasPermission = usePermissions();
    const getPerPage = usePerPage();
    const hasJob = useGovJob();
    const history = useNavigate();
    const location = useLocation();
    const type = 'report';
    const isAttorney = useSelector(state => state.app.attorney) || hasJob('government', 'publicdefenders');
    const searchTerm = useSelector((state) => state.search.searchTerms[type]);
    const myJob = useSelector((state) => state.app.govJob);

    let qry = qs.parse(location.search.slice(1));

    const [toggleEvidenceMode, setToggleEvidenceMode] = useState(false);

    const [reportType, setReportType] = useState(ReportTypes.find(r => hasPermission(r.requiredViewPermission))?.value ?? 1);
    const [pages, setPages] = useState(1);
    const [page, setPage] = useState(1);
    const [loading, setLoading] = useState(false);
    const [err, setErr] = useState(false);
    const [results, setResults] = useState(Array());

    useEffect(() => {
        if (qry.search) {
            dispatch({
                type: 'UPDATE_SEARCH_TERM',
                payload: {
                    type: type,
                    term: qry.search,
                },
            });
            fetch(qry.search, 0, 1, pages);
        } else {
            const availTypes = ReportTypes.filter(r => hasPermission(r.requiredViewPermission) || (r.allowAttorney && isAttorney))
            if (availTypes && availTypes.length > 0) {
                fetch("", availTypes[0].value, 1, pages);
            }
        }
    }, []);

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

    const fetch = useMemo(() => throttle(async (value, rType, page, currentPages, evidenceMode) => {
        let s = qs.parse(location.search.slice(1));
        s.search = value;
        history({
            path: location.pathname,
            search: qs.stringify(s),
        });

        setLoading(true);

        try {
            let res = await (
                await Nui.send('Search', {
                    type: type,
                    term: value,
                    reportType: rType,
                    page: page ?? 1,
                    perPage: getPerPage(),
                    isAttorney, // They can only view reports marked for attorneys
                    evidence: evidenceMode,
                })
            ).json();
            if (res?.data) {
                // Only update pages if not going backwards
                if (res?.pages && res.pages > currentPages) {
                    setPages(Math.ceil(res.pages));
                };

                setResults(res.data);
            } else throw res;
            setLoading(false);
        } catch (err) {
            console.log(err);
            setErr(true);
            setResults(Array(getPerPage()).fill({
                ID: 1,
                title: 'Fleeing and Evading - Mack Morgan | 05/13/2023 What If I Make This Longer',
                suspects: [],
                primaries: [],
            }))
            // setResults([
            //     {
            //         ID: 1,
            //         title: 'Fleeing and Evading - Mack Morgan | 05/13/2023 What If I Make This Longer',
            //         suspects: [],
            //         primaries: [],
            //     },
            //     {
            //         ID: 1,
            //         title: 'Fleeing and Evading - Mack Morgan | 05/13/2023 What If I Make This Longer',
            //         suspects: [],
            //         primaries: [],
            //     },
            // ]);
            setLoading(false);
        }
    }, 1500), []);

    const onSearch = (e) => {
        e.preventDefault();
        setPage(1);
        setPages(1);
        fetch(searchTerm, reportType, 1, pages, toggleEvidenceMode);
    };

    const onSearchChange = (e) => {
        dispatch({
            type: 'UPDATE_SEARCH_TERM',
            payload: {
                type: type,
                term: e.target.value,
            },
        });
    };

    const onClear = () => {
        let s = qs.parse(location.search.slice(1));
        delete s.search;
        delete s.page;
        history({
            path: location.pathname,
            search: qs.stringify(s),
        });
        dispatch({
            type: 'CLEAR_SEARCH',
            payload: { type },
        });

        setPage(1);
        setResults(Array());
    };

    const onPagi = (e, p) => {
        setPage(p);
        fetch(searchTerm, reportType, p, pages, toggleEvidenceMode);
    };

    return (
        <>
            <div className={classes.wrapper}>
                <div className={classes.search}>
                    <form onSubmitCapture={onSearch}>
                        <Grid container spacing={1}>
                            <Grid item xs={1} sx={{ display: 'flex' }}>
                                <Checkbox
                                    checked={toggleEvidenceMode}
                                    onChange={(e) => {
                                        setToggleEvidenceMode(e.target.checked)
                                    }}
                                    sx={{ margin: 'auto', alignSelf: 'center' }}
                                    icon={<FontAwesomeIcon icon={['fas', 'dna']} />}
                                    checkedIcon={<FontAwesomeIcon icon={['fas', 'dna']} />}
                                />
                            </Grid>
                            <Grid item xs={4}>
                                <TextField
                                    select
                                    fullWidth
                                    variant="standard"
                                    label="Report Type"
                                    className={classes.editorField}
                                    value={reportType}
                                    onChange={(e) => setReportType(e.target.value)}
                                >
                                    {ReportTypes.filter(r => hasPermission(r.requiredViewPermission) || (r.allowAttorney && isAttorney)).map((option) => (
                                        <MenuItem
                                            key={option.value}
                                            value={option.value}
                                        >
                                            {option.label}
                                        </MenuItem>
                                    ))}
                                </TextField>
                            </Grid>
                            <Grid item xs={7}>
                                <TextField
                                    fullWidth
                                    variant="standard"
                                    name="search"
                                    value={searchTerm}
                                    onChange={onSearchChange}
                                    error={err}
                                    helperText={err ? 'Error Performing Search' : null}
                                    label={toggleEvidenceMode ? "Search Reports By Evidence Identifier" : "Search Reports"}
                                    InputProps={{
                                        endAdornment: (
                                            <InputAdornment position="end">
                                                {searchTerm != '' && (
                                                    <IconButton
                                                        size="small"
                                                        type="button"
                                                        onClick={onClear}
                                                    >
                                                        <FontAwesomeIcon
                                                            icon={['fas', 'xmark']}
                                                        />
                                                    </IconButton>
                                                )}
                                                <IconButton
                                                    size="small"
                                                    type="submit"
                                                    disabled={loading}
                                                >
                                                    <FontAwesomeIcon
                                                        icon={['fas', 'magnifying-glass']}
                                                    />
                                                </IconButton>
                                            </InputAdornment>
                                        ),
                                    }}
                                />
                            </Grid>
                        </Grid>
                    </form>
                </div>
                <div className={classes.results}>
                    {loading ? (
                        <Loader text="Loading" />
                    ) : results?.length > 0 ? (
                        <>
                            <List className={classes.items}>
                                {results
                                    .map((result) => {
                                        return (
                                            <Item
                                                key={result._id}
                                                report={result}
                                            />
                                        );
                                    })}
                            </List>
                        </>
                    ) : <p className={classes.noResults}>No Results Found</p>}
                </div>
                {(pages > 1) && <div>
                    <Pagination
                        variant="outlined"
                        shape="rounded"
                        color="primary"
                        page={page}
                        count={pages}
                        onChange={onPagi}
                    />
                </div>}
            </div>
            {myJob && <Fab color="primary" className={classes.fab} onClick={createReport}>
                <FontAwesomeIcon icon={['fas', 'plus-large']} />
            </Fab>}
        </>
    );
};
