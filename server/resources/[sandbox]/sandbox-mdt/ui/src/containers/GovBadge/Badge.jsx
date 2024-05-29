import React from 'react';
import { useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';

import DOJ from '../../assets/img/seals/doj_seal.webp';
import LSPDBadge from '../../assets/img/seals/lspd_badge.webp';
import StateBadge from '../../assets/img/seals/sast.webp';
import MedicalServices from '../../assets/img/seals/MedicalServices.webp';
import SheriffBadge from '../../assets/img/seals/bcso_seal.webp';
import GuardiusBadge from '../../assets/img/seals/guardius.webp';
import DOCBadge from '../../assets/img/seals/corrections.webp';

const useStyles = makeStyles((theme) => ({
    container: {
        width: '100%',
        height: '100%',
        padding: '10%',
    },
    image: {
        margin: 'auto',
        width: '100%',
        left: 0,
        right: 0,
    }
}));

export default ({ badge }) => {
    const classes = useStyles();

    const getBadge = (id) => {
        switch (id) {
            case 'lspd':
                return LSPDBadge;
            case 'bcso':
                return SheriffBadge;
            case 'sast':
                return StateBadge;
            case 'guardius':
                return GuardiusBadge;
            case 'safd':
                return MedicalServices;
            case 'corrections':
                return DOCBadge;
            case 'doj':
            default:
                return DOJ;
        }
    };

    return (
        <div className={classes.container}>
            <img src={getBadge(badge)} className={classes.image} />
        </div>
    );
};
