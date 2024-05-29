import React from 'react';
import Nui from '../../util/Nui';
import { Grid, Button } from '@mui/material';
import { makeStyles } from '@mui/styles';

const useStyles = makeStyles((theme) => ({
    div: {
        border: `1px solid ${theme.palette.border.input}`,
        borderLeft: `4px solid ${theme.palette.border.input}`,
        background: theme.palette.secondary.dark,
        color: theme.palette.text.main,
        fontSize: 13,
        height: 42,
        width: '100%',
        textAlign: 'center',
        userSelect: 'none',
        transition: 'background ease-in 0.15s',
        marginBottom: 10,
        borderRadius: 0,
        '&:hover': {
            background: theme.palette.secondary.main,
        },
    },
    left: {
        display: 'inline-block',
        width: '50%',
        textAlign: 'left',
        paddingLeft: 10,
    },
    right: {
        display: 'inline-block',
        width: '50%',
        textAlign: 'right',
        paddingRight: 10,
    },
}));

export default ({ data }) => {
    const classes = useStyles();

    const onClick = () => {
        Nui.send('FrontEndSound', { sound: 'SELECT' });
        Nui.send('Selected', {
            id: data.id,
        });
    };

    return (
        <Button className={classes.div} onClick={onClick}>
            <Grid container>
                <Grid item xs={2}>
                    {data.options.secondaryLabel}
                </Grid>
                <Grid item xs={8}>
                    {data.label}
                </Grid>
                <Grid item xs={2}></Grid>
            </Grid>
        </Button>
    );
};
