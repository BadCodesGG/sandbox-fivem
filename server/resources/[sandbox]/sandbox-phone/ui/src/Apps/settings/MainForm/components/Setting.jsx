import React, { useState } from 'react';
import { useSelector } from 'react-redux';
import { Grid, Avatar, Button, ButtonGroup, Paper } from '@mui/material';
import { makeStyles } from '@mui/styles';

import { blue } from '@mui/material/colors';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

const useStyles = makeStyles((theme) => ({
	rowWrapper: {
		background: theme.palette.secondary.main,
		padding: '25px 12px',
		width: '100%',
		height: 'fit-content',
		userSelect: 'none',
		'-webkit-user-select': 'none',
		'&:hover': {
			background: theme.palette.secondary.light,
			transition: 'background ease-in 0.15s',
			cursor: 'pointer',
		},
	},
	rowWrapperNoHov: {
		background: theme.palette.secondary.main,
		padding: '25px 12px',
		width: '100%',
		height: 'fit-content',
		userSelect: 'none',
		'-webkit-user-select': 'none',
	},
	rowHeader: {
		background: theme.palette.secondary.dark,
		fontSize: 18,
		padding: 15,
		color: theme.palette.text.main,
		fontWeight: 'bold',
		fontFamily: 'Aclonica',
	},
	settingsList: {
		height: '95%',
		overflowY: 'auto',
		overflowX: 'hidden',
		'&::-webkit-scrollbar': {
			width: 6,
		},
		'&::-webkit-scrollbar-thumb': {
			background: '#ffffff52',
		},
		'&::-webkit-scrollbar-thumb:hover': {
			background: theme.palette.primary.main,
		},
		'&::-webkit-scrollbar-track': {
			background: 'transparent',
		},
	},
	avatar: {
		color: theme.palette.text.light,
		background: theme.palette.primary.main,
		height: 55,
		width: 55,
		fontSize: 35,
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
	},
	avatarIcon: {
		fontSize: 25,
	},
	sectionHeader: {
		display: 'block',
		fontSize: 20,
		fontWeight: 'bold',
		lineHeight: '35px',
	},
	arrow: {
		fontSize: 20,
		position: 'absolute',
		top: 0,
		bottom: 0,
		right: 0,
		margin: 'auto',
	},
	mute: {
		color: theme.palette.error.main,
	},
	unmute: {
		color: theme.palette.error.main,
	},
}));

export default ({ UpdateSetting }) => {
	const classes = useStyles();
	const zoom = useSelector(
		(state) => state.data.data.player.PhoneSettings.zoom,
	);
	const [zoomInfo, setZoomInfo] = useState(false);

	const zoomAdd = (e) => {
		e.preventDefault();
		if (zoom < 100) UpdateSetting('zoom', zoom + 10);
	};

	const zoomMinus = (e) => {
		e.preventDefault();
		if (zoom >= 60) UpdateSetting('zoom', zoom - 10);
	};

	return (
		<Paper className={classes.rowWrapperNoHov}>
			<Grid item xs={12}>
				<Grid container>
					<Grid item xs={2} style={{ position: 'relative' }}>
						<Avatar
							className={classes.avatar}
							style={{ background: blue[500] }}
						>
							<FontAwesomeIcon
								className={classes.avatarIcon}
								icon={['fas', 'magnifying-glass']}
							/>
						</Avatar>
					</Grid>
					<Grid
						item
						xs={5}
						style={{ paddingLeft: 5, position: 'relative' }}
					>
						<span className={classes.sectionHeader}>Zoom</span>
					</Grid>
					<Grid item xs={5} style={{ position: 'relative' }}>
						<ButtonGroup className={classes.arrow}>
							<Button onClick={() => setZoomInfo(true)}>
								<FontAwesomeIcon icon={['fas', 'question']} />
							</Button>
							<Button onClick={zoomMinus}>
								<FontAwesomeIcon icon={['fas', 'minus']} />
							</Button>
							<Button disabled>{zoom}%</Button>
							<Button onClick={zoomAdd}>
								<FontAwesomeIcon icon={['fas', 'plus']} />
							</Button>
						</ButtonGroup>
					</Grid>
				</Grid>
			</Grid>
		</Paper>
	);
};
