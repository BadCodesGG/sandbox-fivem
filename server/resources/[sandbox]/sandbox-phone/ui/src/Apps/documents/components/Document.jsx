import React, { useEffect, useState } from 'react';
import { useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';
import {
	ListItem,
	ListItemButton,
	ListItemSecondaryAction,
	ListItemText,
} from '@mui/material';
import { Link } from 'react-router-dom';
import Moment from 'react-moment';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

const useStyles = makeStyles((theme) => ({}));

export default ({ document }) => {
	const classes = useStyles();

	return (
		<ListItemButton
			divider
			component={Link}
			to={`/apps/documents/view/${document.id}`}
		>
			<ListItemText
				primary={`${document.title}`}
				secondary={
					<span>
						Last Edited <Moment unix fromNow date={document.time} />
					</span>
				}
			/>
			{Boolean(document.signature_required) &&
				!Boolean(document.signed) && (
					<ListItemSecondaryAction>
						<FontAwesomeIcon icon={['far', 'signature']} />
					</ListItemSecondaryAction>
				)}
		</ListItemButton>
	);
};
