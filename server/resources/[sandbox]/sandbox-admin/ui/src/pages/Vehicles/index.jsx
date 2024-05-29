import React, { useEffect, useState } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import {
    Grid,
    TextField,
    InputAdornment,
    IconButton,
    Pagination,
    List,
    MenuItem,
} from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import Nui from '../../util/Nui';
import { Loader } from '../../components';

import Vehicle from './Vehicle';

const useStyles = makeStyles((theme) => ({
    wrapper: {
        padding: '20px 10px 20px 20px',
        height: '100%',
    },
    search: {
        height: '10%',
    },
    results: {
        height: '90%',
    },
    items: {
        maxHeight: '95%',
        height: '95%',
        overflowY: 'auto',
        overflowX: 'hidden',
    },
    loader: {
        marginTop: '10%',
    }
}));

export default (props) => {
    const classes = useStyles();
    const dispatch = useDispatch();
    const PER_PAGE = 32;

    const [searched, setSearched] = useState('');
    const [pages, setPages] = useState(1);
    const [page, setPage] = useState(1);
    const [loading, setLoading] = useState(false);

    const [results, setResults] = useState(Array());
    const [vehicles, setVehicles] = useState(Array());

    useEffect(() => {
        fetch();
        // let interval = setInterval(() => fetch(), 60 * 1000);

        // return () => {
        //     clearInterval(interval);
        // }
    }, []);

    useEffect(() => {
        setPages(Math.ceil(vehicles.length / PER_PAGE));
    }, [vehicles]);

    useEffect(() => {
        setVehicles(results.filter((r) => {
            return (
                (`${r?.Make} ${r?.Model}`.toLowerCase().includes(searched.toLowerCase())) ||
                (r.Plate.toUpperCase().includes(searched.toUpperCase())) ||
                (r.VIN.toUpperCase() == searched.toUpperCase()) ||
                (r.OwnerId.toString().includes(searched.toLowerCase()))
            )
        }));
    }, [results, searched]);

    const fetch = async () => {
        setLoading(true);

        try {
            let res = await (await Nui.send('GetVehicleList', {})).json()
            if (res) setResults(res);
        } catch (e) {
            // setResults([
            //     {
            //         OwnerId: 'police',
            //         Entity: 1,
            //         Plate: 'TWAT',
            //         Make: 'Ford',
            //         Model: 'CVPI',
            //         VIN: "RWAAAAAAAAAAAAAAAAAAAAAA",
            //     },
            //     {
            //         OwnerId: 1,
            //         Entity: 1,
            //         Plate: 'TWAT',
            //         Make: 'Ford',
            //         Model: 'CVPI',
            //         VIN: "RWAAAAAAAAAAAAAAAAAAAAAA",
            //     },
            // ])
            //console.log(e)
        }

        setLoading(false)
    }

    const onClear = () => {
        setSearched('');
    };

    const onPagi = (e, p) => {
        setPage(p);
    };

    return (
        <div className={classes.wrapper}>
            <div className={classes.search}>
                <Grid container spacing={1}>
                    <Grid item xs={12}>
                        <TextField
                            fullWidth
                            variant="outlined"
                            name="search"
                            value={searched}
                            onChange={(e) => setSearched(e.target.value)}
                            label="Search"
                            InputProps={{
                                endAdornment: (
                                    <InputAdornment position="end">
                                        {searched != '' && (
                                            <IconButton
                                                type="button"
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
                    </Grid>
                </Grid>
            </div>
            <div className={classes.results}>
                {loading ? (
                    <Loader text="Loading" />
                ) : (
                    <>
                        <List className={classes.items}>
                            {vehicles
                                .slice((page - 1) * PER_PAGE, page * PER_PAGE)
                                .sort((a, b) => b.Source - a.Source)
                                .map((p) => {
                                    return (
                                        <Vehicle
                                            key={p.Source}
                                            vehicle={p}
                                        />
                                    );
                                })}
                        </List>
                        {pages > 1 && (
                            <Pagination
                                variant="outlined"
                                shape="rounded"
                                color="primary"
                                page={page}
                                count={pages}
                                onChange={onPagi}
                            />
                        )}
                    </>
                )}
            </div>
        </div>
    );
};
