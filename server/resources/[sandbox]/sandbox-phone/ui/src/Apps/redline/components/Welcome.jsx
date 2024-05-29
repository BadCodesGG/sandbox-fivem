import React, { useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Fade, TextField, InputAdornment, IconButton } from '@mui/material';
import { makeStyles, withStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import Typist from 'react-typist';

import Nui from '../../../util/Nui';
import { useAlert, useAppData } from '../../../hooks';
import { AppInput } from '../../../components';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '80%',
		width: '100%',
		background: theme.palette.secondary.main,
		position: 'absolute',
	},
	inner: {
		width: '100%',
		height: 'fit-content',
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
		textAlign: 'center',
	},
	header: {
		fontSize: 28,
		fontWeight: 'bold',
		color: (app) => app.color,
	},
	body: {
		padding: '0px 30px',
	},
}));

export default (props) => {
	const appData = useAppData('redline');
	const classes = useStyles(appData);
	const showAlert = useAlert();
	const dispatch = useDispatch();
	const player = useSelector((state) => state.data.data.player);

	const [show, setShow] = useState(false);
	const onAnimEnd = () => {
		setShow(true);
	};

	const onSubmit = async (e) => {
		e.preventDefault();
		let ta = e.target.alias.value;
		try {
			let res = await (
				await Nui.send('UpdateProfile', {
					app: 'redline',
					name: ta,
					picture: '',
				})
			).json();
			showAlert(res ? 'Alias Created' : 'Unable to Create Alias');

			if (res) {
				dispatch({
					type: 'UPDATE_DATA',
					payload: {
						type: 'player',
						id: 'Profiles',
						key: 'redline',
						data: {
							sid: player.SID,
							app: 'redline',
							name: ta,
							picture: '',
							meta: {},
						},
					},
				});
			}
		} catch (err) {
			console.error(err);
			showAlert('Unable to Create Alias');
		}
	};

	return (
		<div className={classes.wrapper}>
			<div className={classes.inner}>
				<div className={classes.header}>
					<Typist onTypingDone={onAnimEnd}>
						<span>Welcome Racer</span>
					</Typist>
				</div>
				<Fade in={show}>
					<div className={classes.body}>
						<p>Set your alias to get started</p>
						<form onSubmit={onSubmit}>
							<AppInput
								app={appData}
								className={classes.creatorInput}
								fullWidth
								label="Alias"
								name="alias"
								variant="outlined"
								required
								InputProps={{
									endAdornment: (
										<InputAdornment position="end">
											<IconButton type="submit">
												<FontAwesomeIcon
													icon={[
														'far',
														'octagon-check',
													]}
												/>
											</IconButton>
										</InputAdornment>
									),
								}}
								inputProps={{
									maxLength: 32,
								}}
							/>
						</form>
						<p>
							<code>Think hard, you may not change this</code>
						</p>
					</div>
				</Fade>
			</div>
		</div>
	);
};
