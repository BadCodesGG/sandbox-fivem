import React from 'react';
import { ListItemButton, ListItemText, Grid } from '@mui/material';
import { makeStyles } from '@mui/styles';
import qs from 'qs';
import { useNavigate, useLocation } from 'react-router';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: '5px 10px 5px 10px',
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		'&:first-of-type': {
			borderTop: `1px solid ${theme.palette.border.divider}`,
		},
	},
	alt: {
		color: theme.palette.text.alt,
	}
}));

export default ({ firearm }) => {
	const classes = useStyles();
	const location = useLocation();
	const history = useNavigate();

	const onClick = () => {
		let s = qs.parse(location.search.slice(1));
		s.firearm = firearm.serial;
		history({
			path: location.pathname,
			search: qs.stringify(s),
		});
	};

	return (
		<ListItemButton className={classes.wrapper} onClick={onClick}>
			<Grid container>
				<Grid item xs={4}>
					<ListItemText primary="Serial Number" secondary={firearm.serial} />
				</Grid>
				<Grid item xs={4}>
					<ListItemText primary="Firearm Model" secondary={firearm.model ?? 'Unknown'} />
				</Grid>
				<Grid item xs={4}>
					<ListItemText
						primary="Registered Owner"
						secondary={
							Boolean(firearm.owner_sid)
								? `${firearm.owner_name} (${firearm.owner_sid})`
								: firearm.owner_name
						}
					/>
				</Grid>
			</Grid>
		</ListItemButton>
	);
};
