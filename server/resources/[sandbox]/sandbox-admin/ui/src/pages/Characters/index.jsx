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

import Character from './Character';

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
    const PER_PAGE = 10;

    const [searched, setSearched] = useState('');
    const [pages, setPages] = useState(1);
    const [page, setPage] = useState(1);
    const [loading, setLoading] = useState(false);

    const [players, setPlayers] = useState(Array());

    useEffect(() => {
        fetch();
    }, []);

    const fetch = async (p) => {
        setLoading(true);

        try {
            let res = await (await Nui.send('GetAllPlayersByCharacter', {
                term: searched,
                page: p ?? 1,
            })).json();
            console.log(res)
            if (res) {
                setPlayers(res.players);
                setPages(Math.ceil(res.pages / PER_PAGE));
            }
        } catch (e) {
            setPlayers([
                {
                    First: 'Walter',
                    Last: 'Western',
                    SID: 3,
                    Online: 1,
                },
                {
                    First: 'Walter',
                    Last: 'Western',
                    SID: 4,
                    //Online: 1,
                },
            ]);
            setPages(1);
            //console.log(e)
        }

        setLoading(false)
    }

    const onClear = () => {
        setSearched('');
    };

    const onPagi = (e, p) => {
        setPage(p);
        fetch(p);
    };

    const handleSubmit = (key) => {
        if (key == "Enter") {
            setPage(1);
            fetch(1);
        }
    };

    const onSubmit = () => {
        setPage(1);
        fetch(1);
    }

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
                            onKeyUp={e => handleSubmit(e.key)}
                            label="Search"
                            InputProps={{
                                endAdornment: (
                                    <InputAdornment position="end">
                                        {searched != '' && (
                                            <IconButton
                                                type="button"
                                                onClick={onSubmit}
                                            >
                                                <FontAwesomeIcon
                                                    icon={['fas', 'magnifying-glass']}
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
                            {players
                                // .slice((page - 1) * PER_PAGE, page * PER_PAGE)
                                // .sort((a, b) => b.Source - a.Source)
                                .map((p) => {
                                    return (
                                        <Character
                                            key={p.Source}
                                            player={p}
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
