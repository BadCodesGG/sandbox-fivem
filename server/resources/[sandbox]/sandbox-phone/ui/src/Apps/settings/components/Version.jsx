import React, { useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { makeStyles } from '@mui/styles';

const useStyles = makeStyles((theme) => ({
	phoneVers: {
		height: 40,
		lineHeight: '40px',
		textAlign: 'center',
		fontFamily: 'Aclonica',
		width: '100%',
		userSelect: 'none',
		'-webkit-user-select': 'none',
	},
}));

export default (props) => {
	const classes = useStyles();
	const history = useNavigate();

	let clickHoldTimer = null;
	useEffect(() => {
		return () => {
			clearTimeout(clickHoldTimer);
		};
	}, []);

	const versionStart = () => {
		clickHoldTimer = setTimeout(() => {
			history(`/apps/settings/software`);
		}, 2000);
	};

	const versionEnd = () => {
		clearTimeout(clickHoldTimer);
	};

	return (
		<div
			className={classes.phoneVers}
			onMouseDown={versionStart}
			onMouseUp={versionEnd}
			onMouseLeave={versionEnd}
		>
			Angry Boi OS <small>v{__APPVERSION__}</small>
		</div>
	);
};
