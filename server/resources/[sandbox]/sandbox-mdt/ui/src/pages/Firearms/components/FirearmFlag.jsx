import React, { useState } from 'react';
import {
	Chip,
	List,
	ListItem,
	ListItemText,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import Moment from 'react-moment';
import { Modal } from '../../../components';

const useStyles = makeStyles((theme) => ({
	item: {
		margin: 4,
		'&.info': {
			backgroundColor: theme.palette.info.main,
		},
		'&.warning': {
			backgroundColor: theme.palette.warning.main,
			color: theme.palette.secondary.dark,
		},
		'&.error': {
			backgroundColor: theme.palette.error.main,
		},
		'&.success': {
			backgroundColor: theme.palette.success.main,
		},
	},
}));

export default ({ flag, onDismiss, ...rest }) => {
	const classes = useStyles();

	const [open, setOpen] = useState(false);

	const inDismiss = async () => {
		onDismiss(flag.id);
	};

	return (
		<div {...rest} style={{ display: 'inline-flex' }}>
			<Chip
				className={`${classes.item} error`}
				label={flag.title}
				onDelete={inDismiss}
				onClick={() => setOpen(true)}
			/>
			<Modal
				open={open}
				maxWidth="sm"
				title="Firearm Flag"
				deleteLang="Remove Flag"
				onDelete={inDismiss}
				onClose={() => setOpen(false)}
			>
				<List>
					<ListItem>
						<ListItemText primary="Title" secondary={flag.title} />
					</ListItem>
					<ListItem>
						<ListItemText
							primary="Issued"
							secondary={<Moment date={flag.date} format="LLL" />}
						/>
					</ListItem>
					<ListItem>
						<ListItemText
							primary="Issued By"
							secondary={
								Boolean(flag.author_sid)
									? <span>{`[${flag.author_callsign}] ${flag.author_first} ${flag.author_last} (${flag.author_sid})`}</span>
									: <span>Robbery Investigation</span>
							}
						/>
					</ListItem>
					<ListItem>
						<ListItemText
							style={{ whiteSpace: 'pre-line' }}
							primary="Issued Reason"
							secondary={flag.description}
						/>
					</ListItem>
				</List>
			</Modal>
		</div>
	);
};
