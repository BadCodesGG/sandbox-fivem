import React, { useState } from 'react';
import { makeStyles } from '@mui/styles';
import { SplitView } from '../../components';
import Search from './Search';
import View from './View';

const useStyles = makeStyles((theme) => ({
    wrapper: {
        padding: 10,
        height: '100%',
        overflow: 'hidden',
    },
}));

export default () => {
    const classes = useStyles();
    const [expanded, setExpanded] = useState(true);

    return (
        <div className={classes.wrapper}>
            <SplitView expanded={expanded} setExpanded={state => setExpanded(state)}>
                <Search />
                <View />
            </SplitView>
        </div>
    );
};
