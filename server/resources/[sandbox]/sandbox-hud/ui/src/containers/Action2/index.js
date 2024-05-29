/* eslint-disable react/no-danger */
import React, { useEffect, useState } from 'react';
import { useSelector } from 'react-redux';
import ReactHtmlParser from 'react-html-parser';
import { Grow } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

const useStyles = makeStyles((theme) => ({
    container: {
        width: 80,
        padding: 5,
        lineHeight: '25px',
        display: 'flex',
        color: theme.palette.text.main,
        background: `${theme.palette.secondary.dark}80`,
        borderLeft: `4px solid ${theme.palette.info.main}`,
        borderTopLeftRadius: 4,
        borderBottomLeftRadius: 4,
        height: 'fit-content',
        position: 'absolute',
        bottom: 240,
        right: 0,
        left: 0,
        textShadow: '0 0 3px #000000',
        margin: 'auto',
        width: 'fit-content',
        fontSize: 24,
    },
    icon: {
        display: 'block',
        padding: 5,
        paddingLeft: 0,
        borderRight: `1px solid ${theme.palette.border.divider}`,
    },
    text: {
        padding: 5,
        '&.low': {
            animation: '$flash linear 1s infinite',
        },
    },
    wrapper: {
        color: theme.palette.text.main,
        textShadow: '0 0 3px #000000',
        borderBottom: `3px solid ${theme.palette.info.main}`,
        padding: 10,
        height: 'fit-content',
        position: 'absolute',
        bottom: '15%',
        right: 0,
        left: 0,
        margin: 'auto',
        width: 'fit-content',
        fontSize: 20,
        '& svg': {
            position: 'absolute',
            left: -15,
            bottom: -15,
            color: theme.palette.info.main,
            fontSize: 28,
            zIndex: 100,
        },
    },
    highlight: {
        color: '#3aaaf9',
        fontWeight: 500,
    },
    '.highlight': {
        color: '#3aaaf9',
        fontWeight: 500,
    },
    highlightSplit: {
        color: '#ffffff',
        fontWeight: 500,
    },
    key: {
        padding: 5,
        color: theme.palette.primary.main,
        borderRadius: 2,
        textTransform: 'capitalize',
        '&::before': {
            content: '"("',
        },
        '&::after': {
            content: '")"',
        },
    },
}));

export default () => {
    const classes = useStyles();
    const actions = useSelector((state) => state.action2.actions);

    const [action, setAction] = useState(
        actions.length > 0 ? actions[actions.length - 1] : null,
    );

    useEffect(() => {
        setAction(actions.length > 0 ? actions[actions.length - 1] : null);
    }, [actions]);

    const ParseButtonText = (text) => {
        let v = text;
        v = v.replace(/\{key\}/g, `<span class=${classes.key}>`);

        v = v.replace(/\{\/key\}/g, `</span>`);

        return v;
    };

    if (!Boolean(action)) return null;
    return (
        <Grow in={Boolean(action)}>
            <div className={classes.container}>
                <div className={classes.icon}>
                    <FontAwesomeIcon
                        icon="circle-info"
                        className={classes.iconTxt}
                    />
                </div>
                <div className={classes.text}>
                    {ReactHtmlParser(ParseButtonText(action.message))}
                </div>
            </div>
        </Grow>
    );
};
