/* eslint-disable jsx-a11y/no-static-element-interactions */
/* eslint-disable jsx-a11y/click-events-have-key-events */
/* eslint-disable react/prop-types */
import React, { useState } from 'react';
import { Grid, Button } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import Nui from '../../util/Nui';

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
        width: '10%',
        marginTop: 3,
    },
    icon: {
        width: '0.75em',
        height: '100%',
        fontSize: '1.25rem',
    },
    right: {
        width: '90%',
        textAlign: 'center',
        float: 'right',
    },
}));

export default ({ data }) => {
    const classes = useStyles();
    const [selected, setSelected] = useState(data.options.selected);

    const onClick = () => {
        setSelected(!selected);
        Nui.send('FrontEndSound', { sound: 'SELECT' });
        Nui.send('Selected', {
            id: data.id,
            data: { selected: !selected },
        });
    };

    return (
        <Button className={classes.div} onClick={onClick}>
            <Grid container>
                <Grid item xs={2}>
                    {selected ? (
                        <FontAwesomeIcon
                            icon="square-check"
                            className={classes.icon}
                        />
                    ) : (
                        <FontAwesomeIcon
                            icon="square"
                            className={classes.icon}
                        />
                    )}
                </Grid>
                <Grid item xs={8}>
                    <span>{data.label}</span>
                </Grid>
                <Grid item xs={2}></Grid>
            </Grid>
        </Button>
    );
};
