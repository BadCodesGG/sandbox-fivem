import React, { useState, useRef } from 'react';
import { useSelector } from 'react-redux';
import { Menu, ListItemButton, Divider } from '@mui/material';
import { makeStyles } from '@mui/styles';

import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

const useStyles = makeStyles((theme) => ({
    icon: {
        margin: 'auto',
        marginRight: 5,
    },
    radioItem: {
        display: 'flex',
        flexDirection: 'row',
        justifyContent: 'center',
        alignContent: 'center',
        height: '100%',
        backgroundColor: 'rgba(255, 255, 255, 0.1)',
        borderRadius: 5,
        padding: '2.5px 5px',
        cursor: 'pointer',
        marginRight: '5px',
    },
    text: {
        marginLeft: 5,
        width: '100%',
        wordWrap: 'keep-all',
        whiteSpace: 'nowrap',
        wordBreak: 'keep-all',
        marginTop: 'auto',
        marginBottom: 'auto',
    },
}));

export default ({ freq, icon, text, onClick, onJoin, onDelete, add }) => {
    const classes = useStyles();
    const [open, setOpen] = useState(null);

    return <>
        <div className={classes.radioItem} onClick={add ? onClick : (e) => setOpen(e.currentTarget)}>
            <FontAwesomeIcon className={classes.icon} icon={['fas', icon ?? 'walkie-talkie']} />
            <Divider orientation="vertical" flexItem />
            <span className={classes.text}>{text}</span>
        </div>
        <Menu anchorEl={open} open={Boolean(open)} onClose={() => setOpen(false)}>
            {Boolean(open) && (
                <div>
                    <ListItemButton onClick={() => {
                        setOpen(null);
                        onJoin();
                    }}>
                        Switch to Channel
                    </ListItemButton>
                    <ListItemButton onClick={() => {
                        setOpen(null);
                        onClick();
                    }}>
                        Edit
                    </ListItemButton>
                    <ListItemButton onClick={() => {
                        setOpen(null);
                        onDelete();
                    }}>
                        Delete
                    </ListItemButton>
                </div>
            )}
        </Menu>
    </>
};
