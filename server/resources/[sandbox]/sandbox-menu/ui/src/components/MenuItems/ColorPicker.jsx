/* eslint-disable react/prop-types */
import React, { useState } from 'react';
import {
    Fade,
    Button,
    Dialog,
    DialogTitle,
    DialogContent,
    DialogActions,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import { ChromePicker } from 'react-color';
import Nui from '../../util/Nui';

const useStyles = makeStyles((theme) => ({
    div: {
        width: '100%',
        height: 82,
        fontSize: 13,
        fontWeight: 500,
        textAlign: 'center',
        textDecoration: 'none',
        textShadow: 'none',
        whiteSpace: 'nowrap',
        display: 'inline-block',
        verticalAlign: 'middle',
        padding: '10px 20px',
        userSelect: 'none',
        transition: '0.1s all linear',
        userSelect: 'none',
        background: theme.palette.secondary.dark,
        border: `1px solid ${theme.palette.border.input}`,
        borderLeft: `4px solid ${theme.palette.border.input}`,
        color: theme.palette.text.main,
        marginBottom: 10,
        '&:hover:not(.disabled)': {
            background: theme.palette.secondary.main,
        },
    },
    picker: {
        background: `${theme.palette.secondary.dark} !important`,
        boxShadow: 'none !important',
        color: theme.palette.text.dark,
    },
}));

export default ({ data }) => {
    const classes = useStyles();
    const [showPicker, setShowPicker] = useState(false);
    const [currColor, setCurrColor] = useState(data.options.current);
    const [tColor, setTColor] = useState(currColor);

    const onClick = () => {
        if (!data.options.disabled) {
            setShowPicker(!showPicker);
        }
    };

    const onChange = (color, event) => {
        if (!data.options.disabled) {
            setTColor(color.rgb);
        }
    };

    const onSave = () => {
        if (!data.options.disabled) {
            setCurrColor(tColor);
            Nui.send('Selected', {
                id: data.id,
                data: { color: tColor },
            });
            onClick();
        }
    };

    const cssClass = data.options.disabled
        ? `${classes.div} disabled`
        : classes.div;
    const style = data.options.disabled
        ? {
              opacity: 0.5,
              background: `rgb(${currColor.r}, ${currColor.g}, ${currColor.b}`,
          }
        : { background: `rgb(${currColor.r}, ${currColor.g}, ${currColor.b}` };

    return (
        <div>
            <Button className={cssClass} style={style} onClick={onClick}>
                <span style={{ textShadow: '2px 2px #000' }}>
                    Select Color : rgb({currColor.r}, {currColor.g},{' '}
                    {currColor.b})
                </span>
            </Button>
            <Dialog fullWidth onClose={onClick} open={showPicker}>
                <DialogTitle onClose={onClick}>Select Color</DialogTitle>
                <DialogContent dividers>
                    <ChromePicker
                        color={tColor}
                        disableAlpha
                        onChange={onChange}
                        width="100%"
                        className={classes.picker}
                    />
                </DialogContent>
                <DialogActions>
                    <Button color="success" onClick={onSave}>
                        Save Color
                    </Button>
                </DialogActions>
            </Dialog>
        </div>
    );
};
