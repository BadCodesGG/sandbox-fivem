import React from 'react';
import { Alert, Grid, List, ListItem } from '@mui/material';
import { makeStyles } from '@mui/styles';
import Item from './Item';

const useStyles = makeStyles((theme) => ({
	container: {
		padding: 10,
	},
	block: {
		padding: 10,
		background: theme.palette.secondary.main,
		border: `1px solid ${theme.palette.border.divider}`,
	},
	header: {
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		color: theme.palette.primary.main,
		fontSize: 18,
		marginBottom: 10,
		position: 'relative',
	},
	list: {
		maxHeight: "30vh",
		overflowY: "auto",
	}
}));

export default ({ govWorkers = {} }) => {
	const classes = useStyles();

	return (
		<Grid item xs={6} className={classes.container}>
			<div className={classes.block}>
				<div className={classes.header}>
					Available DOJ
				</div>
				<List className={classes.list}>
					{govWorkers && govWorkers.length > 0 ? (
						govWorkers
							.sort((a, b) => a.Workplace.localeCompare(b.Workplace) || a.Last.localeCompare(b.Last))
							.map((data, k) => {
								return <Item key={`govWorkers-${k}`} data={data} />;
							})
					) : (
						<ListItem>
							<Alert variant="outlined" severity="info">
								No DOJ
							</Alert>
						</ListItem>
					)}
				</List>
			</div>
		</Grid>
	);
};
