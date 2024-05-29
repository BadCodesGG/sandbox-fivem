import React from 'react';
import { makeStyles } from '@mui/styles';

const useStyles = makeStyles((theme) => ({
    wrapper: {

    },
}));

export default () => {
    const classes = useStyles();

    return (
        <div className={classes.wrapper}>

        </div>
    );
};
