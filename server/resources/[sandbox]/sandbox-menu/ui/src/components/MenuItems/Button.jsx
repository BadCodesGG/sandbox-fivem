/* eslint-disable jsx-a11y/no-static-element-interactions */
/* eslint-disable jsx-a11y/click-events-have-key-events */
/* eslint-disable react/prop-types */
import React from 'react';
import { Button } from '@mui/material';
import { makeStyles } from '@mui/styles';
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
    error: {
        border: `1px solid ${theme.palette.border.input}`,
        borderLeft: `4px solid ${theme.palette.error.main}`,
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
    success: {
        border: `1px solid ${theme.palette.border.input}`,
        borderLeft: `4px solid ${theme.palette.success.main}`,
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
}));

export default ({ data }) => {
    const classes = useStyles();

    const onClick = () => {
        if (!data.options.disabled) {
            Nui.send('FrontEndSound', { sound: 'SELECT' });
            Nui.send('Selected', {
                id: data.id,
            });
        }
    };

    const cssClass = data.options.disabled
        ? `${data.options.success ? classes.success : classes.div} disabled`
        : data.options.success
        ? classes.success
        : data.options.error
        ? classes.error
        : classes.div;
    const style = data.options.disabled ? { opacity: 0.5 } : {};

    return (
        <Button className={cssClass} style={style} onClick={onClick}>
            {data.label}
        </Button>
    );
};
