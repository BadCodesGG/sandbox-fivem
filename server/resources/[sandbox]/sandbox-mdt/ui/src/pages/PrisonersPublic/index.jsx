import React, { useEffect, useState } from 'react';
import {
    TextField,
    InputAdornment,
    IconButton,
    Pagination,
    List,
    Paper,
    Grid,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import qs from 'qs';
import { useNavigate, useLocation } from 'react-router';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import Nui from '../../util/Nui';
import { usePerPage } from '../../hooks';
import { Loader } from '../../components';
import Item from './components/Prisoner';

const useStyles = makeStyles((theme) => ({
    wrapper: {
        padding: 10,
        height: '100%',
    },
    search: {},
    results: {
        flexGrow: 1,
    },
    items: {
        maxHeight: '95%',
        height: '95%',
        overflowY: 'auto',
        overflowX: 'hidden',
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
    noResults: {
        margin: '15% 0',
        textAlign: 'center',
        fontSize: 22,
        color: theme.palette.text.main,
    },
}));

export default () => {
    const classes = useStyles();
    const history = useNavigate();
    const location = useLocation();
    const getPerPage = usePerPage();
    const PER_PAGE = getPerPage();
    let qry = qs.parse(location.search.slice(1));

    const [pages, setPages] = useState(1);
    const [page, setPage] = useState(1);
    const [loading, setLoading] = useState(false);
    const [searched, setSearched] = useState(qry.search ?? '');
    const [results, setResults] = useState(Array());
    const [filtered, setFiltered] = useState(Array());

    useEffect(() => {
        if (searched != "") {
            setFiltered(results.filter((r) => {
                return (
                    (`${r?.First} ${r?.Last}`.toLowerCase().includes(searched.toLowerCase())) ||
                    (r?.SID == parseInt(searched))
                )
            }));
        } else {
            setFiltered(results)
        }
    }, [results, searched]);

    useEffect(() => {
        setPages(Math.ceil(filtered.length / PER_PAGE));
    }, [filtered]);

    useEffect(() => {
        fetch();
    }, []);

    const fetch = async () => {
        setLoading(true);

        try {
            let res = await (
                await Nui.send('DOCGetPrisoners', {})
            ).json();
            if (res) setResults(res);
            else setResults(Array());
            setLoading(false);
        } catch (err) {
            console.log(err);
            setResults(Array());
            setLoading(false);

            setResults([
                {
                    First: "Bob", Last: "Bobson", SID: 1, Jailed: {
                        Duration: 50,
                        Time: Date.now() / 1000,
                        Release: (Date.now() / 1000) + (60 * 50),
                    }
                },
            ])
        }
    };

    const onSearchChange = (e) => {
        let s = qs.parse(location.search.slice(1));
        s.search = e.target.value;
        history({
            path: location.pathname,
            search: qs.stringify(s),
        });

        setSearched(e.target.value);
    };

    const onClear = () => {
        let s = qs.parse(location.search.slice(1));
        delete s.search;
        history({
            path: location.pathname,
            search: qs.stringify(s),
        });

        setSearched('');
    };

    const onPagi = (e, p) => {
        setPage(p);
    };

    return (
        <div className={classes.wrapper}>
            <Grid container spacing={1} sx={{ height: '100%' }}>
                <Grid item xs={12}>
                    <Paper elevation={3} className={classes.paper}>
                        <div className={classes.inner}>
                            <div className={classes.search}>
                                <TextField
                                    fullWidth
                                    variant="standard"
                                    name="search"
                                    value={searched}
                                    onChange={onSearchChange}
                                    label="Search By Prisoner Name or State ID"
                                    InputProps={{
                                        endAdornment: (
                                            <InputAdornment position="end">
                                                {searched != '' && (
                                                    <IconButton
                                                        type="button"
                                                        size="small"
                                                        onClick={onClear}
                                                    >
                                                        <FontAwesomeIcon
                                                            icon={['fas', 'xmark']}
                                                        />
                                                    </IconButton>
                                                )}
                                            </InputAdornment>
                                        ),
                                    }}
                                />
                            </div>
                            <div className={classes.results}>
                                {loading ? (
                                    <Loader text="Loading" />
                                ) : filtered?.length > 0 ? (
                                    <>
                                        <List className={classes.items}>
                                            {filtered
                                                .slice((page - 1) * PER_PAGE, page * PER_PAGE)
                                                .map((result) => {
                                                    return (
                                                        <Item
                                                            key={result.id}
                                                            prisoner={result}
                                                        />
                                                    );
                                                })}
                                        </List>
                                    </>
                                ) : <p className={classes.noResults}>No Prisoners Awake</p>}
                            </div>
                            {pages > 1 && <div>
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
                    </Paper>

                </Grid>
            </Grid>
        </div>
    );
};
