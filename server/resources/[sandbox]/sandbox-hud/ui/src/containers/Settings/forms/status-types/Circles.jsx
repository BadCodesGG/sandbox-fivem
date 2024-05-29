import React from 'react';
import { Grid, FormControlLabel, Switch } from '@mui/material';
import { Fragment } from 'react';

export default ({ state, setState, onChange, onChecked }) => {
    return (
        <Fragment>
            <Grid item xs={12}>
                <Grid container spacing={2}>
                    <Grid item xs={12}>
                        <FormControlLabel
                            control={
                                <Switch
                                    name="circleNumbers"
                                    checked={state.circleNumbers}
                                    onChange={onChecked}
                                />
                            }
                            label="Show Numbers Instead of Icons (Where Possible)"
                        />
                    </Grid>
                </Grid>
            </Grid>
        </Fragment>
    );
};
