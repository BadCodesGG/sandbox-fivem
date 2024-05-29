import React from 'react';
import { Button } from '@mui/material';
import { makeStyles } from '@mui/styles';
import Nui from '../../util/Nui';

const useStyles = makeStyles(theme => ({
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
}));

export default ({ data }) => {
    const classes = useStyles();
    const onClick = () => {
        if (!data.options.disabled) {
            Nui.send('FrontEndSound', { sound: 'SELECT' });
            Nui.send('MenuOpen', {
                id: data.id,
            });
        }
    };

    const style = data.options.disabled ? { opacity: 0.5 } : {};
    return (
        <Button className={classes.div} style={style} onClick={onClick}>
            {data.label}
        </Button>
    );
};
