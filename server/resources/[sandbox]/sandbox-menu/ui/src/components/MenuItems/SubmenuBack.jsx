import React from 'react';
import { Button } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { useDispatch } from 'react-redux';
import Nui from '../../util/Nui';

const useStyles = makeStyles(theme => ({
    div: {
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
}));

export default ({ data }) => {
    const classes = useStyles();
	const dispatch = useDispatch();

    const onClick = () => {
        if (!data.options.disabled) {
            Nui.send('FrontEndSound', { sound: 'BACK' });
            Nui.send('Selected', {
                id: data.id,
            });

            dispatch({
                type: 'SUBMENU_BACK',
            });
        }
    };

    return (
        <Button className={classes.div} onClick={onClick}>
            {data.label}
        </Button>
    );
};
