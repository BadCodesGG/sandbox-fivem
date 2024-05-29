import React, { useState } from 'react';
import { Grid, FormControlLabel, Switch } from '@mui/material';
import { useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';
import { Fragment } from 'react';

const useStyles = makeStyles((theme) => ({
    form: {
        padding: 10,
    },
    header: {
        display: 'block',
        fontSize: '1.17em',
        marginBlockEnd: '1em',
        fontWeight: 'bold',
    },
    field: {
        marginBottom: 10,
    },
}));

export default ({ state, setState, onChange, onChecked }) => {
    const classes = useStyles();

    return (
        <Fragment>
            <Grid item xs={12}>
                <Grid container spacing={2}>
                    <Grid item xs={12}>
                        <FormControlLabel
                            control={
                                <Switch
                                    name="minimapAnchor"
                                    checked={state.minimapAnchor}
                                    onChange={onChecked}
                                />
                            }
                            label="Anchor To Minimap"
                        />
                    </Grid>
                </Grid>
            </Grid>
        </Fragment>
    );
};
