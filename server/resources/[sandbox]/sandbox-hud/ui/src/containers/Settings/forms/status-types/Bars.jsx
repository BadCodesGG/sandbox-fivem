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
                                    name="largeBars"
                                    checked={state.largeBars}
                                    onChange={onChecked}
                                />
                            }
                            label="Longer Bars"
                        />
                    </Grid>
                    <Grid item xs={12}>
                        <FormControlLabel
                            control={
                                <Switch
                                    name="transparentBg"
                                    checked={state.transparentBg}
                                    onChange={onChecked}
                                />
                            }
                            label="Transparent Bar Backgrounds"
                        />
                    </Grid>
                </Grid>
            </Grid>
        </Fragment>
    );
};
