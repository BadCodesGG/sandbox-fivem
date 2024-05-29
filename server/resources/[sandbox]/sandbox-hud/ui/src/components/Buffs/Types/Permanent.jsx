import React from 'react';
import { useSelector } from 'react-redux';
import { makeStyles, withTheme } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

const useStyles = makeStyles((theme) => ({
    container: {
        width: 36,
        height: 36,
        lineHeight: '26px',
        fontSize: 22,
        marginBottom: 4,
        textAlign: 'center',
    },
    icon: {
        width: '100%',
        height: '100%',
        fontSize: 22,
        background: `${theme.palette.secondary.dark}80`,
        padding: 5,
        position: 'relative',
        borderBottom: `4px solid ${theme.palette.text.alt}`,
    },
    fa: {
        position: 'absolute',
        top: 0,
        bottom: 0,
        left: 0,
        right: 0,
        margin: 'auto',
    },
    txt: {
        position: 'absolute',
        top: 0,
        bottom: 0,
        left: 0,
        right: 0,
        margin: 'auto',
        lineHeight: '35px',
        fontSize: (buff) =>
            Boolean(buff.override) && `${buff?.override ?? ''}`.length > 2
                ? '0.85rem'
                : '1rem',
    },
}));

export default withTheme(({ buff }) => {
    const classes = useStyles(buff);
    const buffDefs = useSelector((state) => state.status.buffDefs);
    const buffDef = buffDefs[buff?.buff];

    return (
        <div className={classes.container}>
            <div className={classes.icon}>
                {Boolean(buff.override) ? (
                    <span className={classes.txt}>{buff.override}</span>
                ) : (
                    <FontAwesomeIcon
                        className={classes.fa}
                        icon={buffDef.icon}
                    />
                )}
            </div>
        </div>
    );
});
