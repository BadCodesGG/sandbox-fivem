import React, { useState } from 'react';
import { useSelector } from 'react-redux';
import { Menu, MenuItem } from '@mui/material';
import { makeStyles } from '@mui/styles';
//import NestedMenuItem from 'material-ui-nested-menu-item';

const useStyles = makeStyles((theme) => ({
	container: {
		height: '30%',
		width: '100%',
		overflowY: 'hidden',
		overflowX: 'auto',
		background: theme.palette.secondary.dark,
	},
	wrapper: {
		height: '100%',
	},
	list: {
		maxHeight: '75%',
		overflow: 'auto',
	},
	ava: {
		transition: 'filter ease-in 0.15s',
		fontSize: 14,
		'&.police': {
			backgroundColor: theme.palette.info.main,
			color: theme.palette.text.main,
		},
		'&.ems': {
			backgroundColor: '#760036',
			color: theme.palette.text.main,
		},
		'&.clickable:hover': {
			filter: 'brightness(0.7)',
			cursor: 'pointer',
		},
	},
}));

export default ({ current, unit, onChange }) => {
	const classes = useStyles();

	const [anchorEl, setAnchorEl] = useState(null);
	const [open, setOpen] = useState(null);

	switch (unit.job) {
		case 'police':
			return (
				<>
					<MenuItem onClick={(e) => {
						setAnchorEl(e.currentTarget);
						setOpen(true);
					}}>
						Change Type
					</MenuItem>
					<Menu
						anchorEl={anchorEl}
						open={open != null}
						onClose={() => setOpen(null)}
						PaperProps={{
							style: {
								maxHeight: 100,
								width: '20ch',
							},
						}}
					>
						{Boolean(open) && (
							<div>
								<MenuItem
									disabled={current == 'car'}
									onClick={() => onChange('car')}
								>
									Ground Unit
								</MenuItem>
								<MenuItem
									disabled={current == 'heat'}
									onClick={() => onChange('heat')}
								>
									Heat Unit
								</MenuItem>
								<MenuItem
									disabled={current == 'motorcycle'}
									onClick={() => onChange('motorcycle')}
								>
									Motorcycle Unit
								</MenuItem>
								<MenuItem
									disabled={current == 'air1'}
									onClick={() => onChange('air1')}
								>
									Air Unit
								</MenuItem>
							</div>
						)}
					</Menu>
				</>
			);
		case 'ems':
			return (
				<>
					<MenuItem onClick={(e) => {
						setAnchorEl(e.currentTarget);
						setOpen(true);
					}}>
						Change To
					</MenuItem>
					<Menu
						anchorEl={anchorEl}
						open={open != null}
						onClose={() => setOpen(null)}
						PaperProps={{
							style: {
								maxHeight: 100,
								width: '20ch',
							},
						}}
					>
						{Boolean(open) && (
							<div>
								<MenuItem
									button
									disabled={current == "bus"}
									onClick={() => onChange('bus')}
								>
									Ambulance
								</MenuItem>
								<MenuItem
									button
									disabled={current == "car"}
									onClick={() => onChange('car')}
								>
									Rapid Response
								</MenuItem>
								<MenuItem
									button
									disabled={current == "lifeflight"}
									onClick={() => onChange('lifeflight')}
								>
									Life Flight
								</MenuItem>
							</div>
						)}
					</Menu>
				</>
			);
		default:
			return null;
	}
};
