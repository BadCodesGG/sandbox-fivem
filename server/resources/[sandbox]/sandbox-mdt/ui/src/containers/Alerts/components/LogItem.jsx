import React, { useState } from 'react';
import { useSelector } from 'react-redux';
import { Divider, MenuItem } from '@mui/material';
import { makeStyles } from '@mui/styles';
import Moment from 'react-moment';
import Truncate from '@nosferatu500/react-truncate';

const useStyles = makeStyles((theme) => ({
    color: {
        height: '100%',
        width: 5,
    },
    messageContainer: {
        display: 'flex',
        flexDirection: 'row',
        alignItems: 'center',
        fontSize: 12,
        gap: 10,
        padding: 5,
        fontWeight: 500,
        maxWidth: '100%',
        marginBottom: 5,
        paddingLeft: 5,
        borderLeft: `3px solid ${theme.palette.info.dark}`,
    },
    time: {
        color: theme.palette.text.alt,
    },
    messageText: {
        maxWidth: '80%',
        flexGrow: 1,
        '& h3': {
            fontSize: 13,
            margin: 0,
            fontWeight: 600,
            whiteSpace: 'nowrap',
            overflow: 'hidden',
            textOverflow: 'ellipsis',
            width: '100%',
        }
    }
}));

export default ({ log }) => {
    const classes = useStyles();

    return <div className={classes.messageContainer} style={{
        borderLeft: log.color ? `3px solid ${log.color}` : null,
    }}>
        <div className={classes.time}><Moment date={log.time} interval={60000} format={"HH:mm"} /></div>
        <Divider orientation="vertical" flexItem />
        <div className={classes.messageText}>
            <h3>{log.title}</h3>

            <Truncate lines={3}>{log.message}</Truncate>
        </div>
    </div>
};
