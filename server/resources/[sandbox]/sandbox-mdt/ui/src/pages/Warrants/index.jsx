import React, { useEffect, useState } from 'react';
import { makeStyles } from '@mui/styles';
import { useLocation } from 'react-router';

import qs from 'qs';
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

    const location = useLocation();
    let qry = qs.parse(location.search.slice(1));
    const isFleetManage = qry["fleet-manage"] == "1";

    useEffect(() => {
        if (isFleetManage && expanded) {
            setExpanded(false);
        };
    }, [isFleetManage]);

    return (
        <div className={classes.wrapper}>
            <SplitView expanded={expanded} setExpanded={state => setExpanded(state)} hideButton={isFleetManage}>
                <Search />
                <View />
            </SplitView>
        </div>
    );
};
