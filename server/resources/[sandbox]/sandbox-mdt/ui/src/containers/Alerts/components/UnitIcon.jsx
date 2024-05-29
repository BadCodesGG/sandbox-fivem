import React from 'react';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

const useStyles = makeStyles((theme) => ({}));

export default ({ job, type, available }) => {
	if (job !== "tow" && !available) {
		return <FontAwesomeIcon icon={['fas', 'hourglass-half']} />;
	};

	switch (job) {
		case 'police':
			switch (type) {
				case 'car':
					return <FontAwesomeIcon icon={['fas', 'car-side']} />;
				case 'air1':
					return <FontAwesomeIcon icon={['fas', 'helicopter']} />;
				case 'heat':
					return <FontAwesomeIcon icon={['fas', 'dumpster-fire']} />;
				case 'motorcycle':
					return <FontAwesomeIcon icon={['fas', 'motorcycle']} />;
				default:
					return (
						<FontAwesomeIcon icon={['fas', 'circle-question']} />
					);
			}
		case 'ems':
			switch (type) {
				case 'bus':
					return <FontAwesomeIcon icon={['fas', 'truck-medical']} />;
				case 'car':
					return <FontAwesomeIcon icon={['fas', 'car-side']} />;
				case 'lifeflight':
					return <FontAwesomeIcon icon={['fas', 'helicopter']} />;
				default:
					return (
						<FontAwesomeIcon icon={['fas', 'circle-question']} />
					);
			}
		case 'tow':
			return <FontAwesomeIcon icon={['fas', 'truck-ramp']} />;
		case 'prison':
			return <FontAwesomeIcon icon={['fas', 'handcuffs']} />;
		default:
			return <FontAwesomeIcon icon={['fas', 'circle-question']} />;
	}
};
