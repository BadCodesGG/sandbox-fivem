import { useSelector } from 'react-redux';

import SASeal from '../assets/img/seals/seal.webp';
import DOJSeal from '../assets/img/seals/doj_seal.webp';
import LSSeal from '../assets/img/seals/ls_seal.webp';

import StateBadge from '../assets/img/seals/sast.webp';
import SheriffBadge from '../assets/img/seals/bcso_seal.webp';
import Guardius2 from '../assets/img/seals/guardius2.webp';

//import StarOfLife from '../assets/img/seals/StarOfLife.webp';
import MedicalServices from '../assets/img/seals/MedicalServices.webp';
import DOCLogo from '../assets/img/seals/corrections.webp';

export default () => {
	const govJob = useSelector((state) => state.app.govJob);
	const attorney = useSelector((state) => state.app.attorney);

	return () => {
		if (attorney && !govJob) {
			return DOJSeal;
		}

		switch (govJob?.Id) {
			case 'police':
				switch (govJob?.Workplace?.Id) {
					case 'lspd':
						return LSSeal;
					case 'bcso':
						return SheriffBadge;
					case 'sast':
						return StateBadge;
					case 'guardius':
						return Guardius2;
					default:
						return SASeal;
				}
			case 'prison':
				return DOCLogo;
			case 'government':
				return DOJSeal;
			case 'ems':
				return MedicalServices;
			default:
				return SASeal;
		}
	};
};
