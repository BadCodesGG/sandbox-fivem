import React from 'react';
import {
    Grid,
    TextField,
    MenuItem,
    FormControlLabel,
    Switch,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import { Fragment } from 'react';

const anchorLocs = [
    {
        value: 'compass',
        label: 'Above Compass',
    },
    {
        value: 'minimap',
        label: 'Below Minimap',
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
                            value={state.buffsAnchor}
                            name="buffsAnchor"
                            label="Buffs Anchor Location"
                            defaultValue="compass"
                        >
                            {anchorLocs.map((option) => (
                                <MenuItem
                                    key={option.value}
                                    value={option.value}
                                >
                                    {option.label}
                                </MenuItem>
                            ))}
                        </TextField>
                    </Grid>
                    {state.buffsAnchor == 'minimap' && (
                        <Grid item xs={6}>
                            <FormControlLabel
                                control={
                                    <Switch
                                        name="buffsAnchor2"
                                        checked={state.buffsAnchor2}
                                        onChange={onChecked}
                                    />
                                }
                                label="Anchor Buffs To Minimap"
                            />
                        </Grid>
                    )}
                </Grid>
            </Grid>
        </Fragment>
    );
};
