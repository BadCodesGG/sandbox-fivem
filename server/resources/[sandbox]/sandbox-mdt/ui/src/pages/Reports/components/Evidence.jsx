import React, { useState } from 'react';
import { Chip, Grid, IconButton, Tooltip } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { EvidenceTypes } from './EvidenceForm';
import Evidenceitem from './EvidenceItem';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		borderBottom: `1px solid rgba(255, 255, 255, 0.7)`,
		margin: 0,
		marginBottom: 10,
		display: 'inline-flex',
		minWidth: '100%',
		position: 'relative',
		flexDirection: 'column',
		verticalAlign: 'top',
		wordBreak: 'break-all',
	},
	label: {
		color: 'rgba(255, 255, 255, 0.7)',
		fontSize: '0.8rem',
		padding: '0 4px',
	},
	body: {},
	item: {
		margin: 4,
	},
}));

export default ({ evidence, onClick, onDelete }) => {
	const classes = useStyles();

	const [hover, setHover] = useState(false);

	if (evidence && evidence.length > 0) {
		return (
			<div className={classes.wrapper}>
				<div className={classes.label}>Evidence</div>
				<div className={classes.body}>
					{evidence.map((item, k) => {
						return (
							<Evidenceitem
								key={`evidence-${k}`}
								item={item}
								onView={() => onClick(k)}
								onDelete={onDelete}
							/>
						);
					})}
				</div>
			</div>
		);
	} else return null;
};
