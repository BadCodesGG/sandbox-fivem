import React, { useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Grid, Avatar, List, ListItem, ListItemText, ListItemAvatar, Menu, MenuItem, Alert } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import Nui from '../../../util/Nui';
import { usePermissions, useQualifications } from '../../../hooks';

import Unit from './Unit';

const useStyles = makeStyles((theme) => ({
    wrapper: {
        display: 'flex',
        flexDirection: 'column',
        justifyContent: 'flex-end',
        //background: `${theme.palette.secondary.dark}CC`,
        height: 'calc(100% - 40px)',
    },
    title: {
        display: 'flex',
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
        background: `${theme.palette.secondary.dark}CC`,
        cursor: 'pointer',
        '& h3': {
            height: '100%',
            padding: '0 15px',
            marginBlockEnd: 0,
            '& small': {
                fontSize: 15,
                color: theme.palette.text.alt,
                fontWeight: 400,
            },
        },
        '& span': {
            transition: 'all 0.25s ease-in-out',
            margin: '0 10px',
        },
    },
    list: {
        background: `${theme.palette.secondary.dark}CC`,
        overflow: 'auto',
        padding: 0,
        transition: 'all 0.25s linear',
    },
    alert: {
        width: 'fit-content',
        margin: 'auto',
    },
}));

const typeNames = {
    police: "Police",
    ems: "EMS",
    prison: "DOC",
    tow: "Tow",
}

export default ({ width, type, units, fullHeight }) => {
    const classes = useStyles();
    const dispatch = useDispatch();
    const tName = typeNames[type];
    const allUnits = useSelector((state) => state.alerts.units);
    const typeUnits = allUnits?.[type] ?? Array();
    const expanded = useSelector((state) => state.alerts.rosterSections)?.[type];

    const expandRoster = () => {
        dispatch({
            type: 'TOGGLE_ROSTER_SECTION',
            payload: { type },
        })
    }

    return (<Grid item xs={width} className={classes.wrapper} style={{ height: fullHeight ? "100%" : null }}>
        <div className={classes.title} onClick={expandRoster}>
            <h3>
                {tName}
                {typeUnits.length > 0 && (
                    <small>
                        {' - On Duty: '}
                        <b>{typeUnits.length}</b>
                    </small>
                )}
                {(type === "police" || type === "ems") && units.length > 0 && (
                    <small>
                        {`  (${units.length} ${units.length === 1 ? "Unit" : "Units"})`}
                    </small>
                )}
            </h3>
            <span style={{
                transform: expanded ? "rotateZ(180deg)" : "rotateZ(0deg)",
            }}>
                <FontAwesomeIcon icon={['fas', 'chevron-up']} />
            </span>
        </div>
        {units.length > 0 ? (
            <List
                className={classes.list}
                style={{
                    maxHeight: expanded ? "85%" : "0%",
                    minHeight: expanded ? "85%" : "0%",
                    padding: expanded ? "10px 0" : "0"
                }}
            >
                {units.length > 0 &&
                    units
                        .sort((a, b) => a.primary - b.primary)
                        .map((unit, k) => {
                            return <Unit key={`unit-${k}`} unitData={unit} unitType={type} missingCallsign={unit.primary === null} />;
                        })}
            </List>
        ) : (
            <List
                className={classes.list}
                style={{
                    maxHeight: expanded ? "85%" : "0%",
                    minHeight: expanded ? "85%" : "0%",
                    padding: expanded ? "10px 0" : "0"
                }}
            >
                <Alert className={classes.alert} variant="outlined" severity="info">
                    No {tName} On Duty
                </Alert>
            </List>
        )}
    </Grid>)
}