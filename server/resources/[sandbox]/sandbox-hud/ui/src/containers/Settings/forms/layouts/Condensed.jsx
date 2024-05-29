import React, { useState } from 'react';
import { Grid, TextField, MenuItem } from '@mui/material';
import { useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';
import { Fragment } from 'react';

const Alignments = [
    {
        label: 'Left',
        value: 'left',
    },
    {
        label: 'Center',
        value: 'center',
    },
    {
        label: 'Minimap',
        value: 'minimap',
    },
    {
        label: 'Compass',
        value: 'compass',
    },
];

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
                        <TextField
                            fullWidth
                            select
                            className={classes.field}
                            onChange={onChange}
                            value={state.condenseAlignment}
                            name="condenseAlignment"
                            label="Align Items"
                            defaultValue="left"
                        >
                            {Alignments.map((option) => (
                                <MenuItem
                                    key={option.value}
                                    value={option.value}
                                >
                                    {option.label}
                                </MenuItem>
                            ))}
                        </TextField>
                    </Grid>
                </Grid>
            </Grid>
        </Fragment>
    );
};
