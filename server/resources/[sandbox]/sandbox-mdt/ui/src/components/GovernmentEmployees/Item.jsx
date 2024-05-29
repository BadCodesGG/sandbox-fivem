import React, { useState } from "react";
import {
  Avatar,
  List,
  ListItem,
  ListItemAvatar,
  ListItemText,
} from "@mui/material";
import { makeStyles } from '@mui/styles';

const useStyles = makeStyles((theme) => ({
  wrapper: {
    userSelect: "none",
    transition: "background ease-in 0.15s",
    "&:hover": {
      cursor: "pointer",
      background: theme.palette.secondary.dark,
    },
  },
}));

export default ({ data }) => {
  const classes = useStyles();

  return (
    <ListItem className={classes.wrapper}>
      <ListItemText primary={`${data.Grade} ${data.First[0]}. ${data.Last} (${data.Workplace})`} secondary={`State ID: ${data.SID} | Phone: ${data.Phone}`} />
    </ListItem>
  );
};