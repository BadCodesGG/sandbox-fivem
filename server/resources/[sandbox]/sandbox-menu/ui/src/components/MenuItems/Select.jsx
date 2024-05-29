import React from 'react';
import { TextField, MenuItem, Button } from '@mui/material';
import { makeStyles } from '@mui/styles';
import Nui from '../../util/Nui';

const useStyles = makeStyles(theme => ({
    div: {
        border: `1px solid ${theme.palette.border.input}`,
        borderLeft: `4px solid ${theme.palette.border.input}`,
        background: theme.palette.secondary.dark,
        color: theme.palette.text.main,
        fontSize: 13,
        minHeight: 84,
        width: '100%',
        textAlign: 'center',
        userSelect: 'none',
        transition: 'filter ease-in 0.15s',
        padding: '10px 20px',
        marginBottom: 10,
        borderRadius: 0,
        padding: '10px 20px',
    },
    item: {
        width: '100%',
        textAlign: 'left',
    },
}));

export default ({ data }) => {
    const classes = useStyles();
    const [value, setValue] = React.useState(data.options.current);

    const handleChange = event => {
        setValue(event.target.value);
        Nui.send('Selected', {
            id: data.id,
            data: { value: event.target.value },
        });
    };

    const cssClass = data.options.disabled
        ? `${classes.div} disabled`
        : classes.div;
    const style = data.options.disabled ? { opacity: 0.5 } : {};

    return (
        <div className={cssClass} style={style}>
            <TextField
                variant="standard"
                className={classes.item}
                select
                disabled={data.options.disabled}
                label={data.label}
                value={value}
                onChange={handleChange}
            >
                {data.options.list.map(option => (
                    <MenuItem
                        key={option.value}
                        value={option.value}
                        selected={false}
                    >
                        {option.label}
                    </MenuItem>
                ))}
            </TextField>
        </div>
    );
};
