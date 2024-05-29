import React, { Fragment } from 'react';
import { useSelector } from 'react-redux';
import { makeStyles, withTheme } from '@mui/styles';

import TimedBuff from '../Types/Circles/Timed';
import ValueBuff from '../Types/Circles/Value';
import PermBuff from '../Types/Circles/Permanent';

const useStyles = makeStyles((theme) => ({}));

export default withTheme(() => {
    const classes = useStyles();

    const buffDefs = useSelector((state) => state.status.buffDefs);
    const buffs = useSelector((state) => state.status.buffs);

    return (
        <Fragment>
            {buffs.map((s, i) => {
                if (!Boolean(s)) return null;
                const buffDef = buffDefs[s?.buff];
                switch (buffDef.type) {
                    case 'timed':
                        return <TimedBuff key={`buff-${i}`} buff={s} />;
                    case 'value':
                        return <ValueBuff key={`buff-${i}`} buff={s} />;
                    default:
                        return <PermBuff key={`buff-${i}`} buff={s} />;
                }
            })}
        </Fragment>
    );
});
