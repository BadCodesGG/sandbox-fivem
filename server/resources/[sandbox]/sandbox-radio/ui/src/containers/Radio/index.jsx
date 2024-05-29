import React, { Fragment, useEffect, useState } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import {
	Slide,
	Fade,
	Tooltip,
	TextField,
	InputAdornment,
	IconButton,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { library } from '@fortawesome/fontawesome-svg-core';
import { far } from '@fortawesome/pro-regular-svg-icons';

import Nui from '../../util/Nui';
import frame from '../../radio_frame.webp';
import wallpaper from '../../background.webp';

library.add(far);

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: 700,
		width: 360,
		position: 'absolute',
		bottom: '0%',
		right: '2%',
		overflow: 'hidden',
	},
	radioImg: {
		zIndex: 200,
		background: `transparent no-repeat center`,
		height: '100%',
		width: '100%',
		position: 'absolute',
		pointerEvents: 'none',
	},
	radio: {
		height: '100%',
		width: '100%',
		padding: '0 69px',
		overflow: 'hidden',
	},
	screen: {
		zIndex: 101,
		width: 204,
		height: 314,
		position: 'absolute',
		bottom: 85,
		left: 78,
		overflow: 'hidden',
		border: '4px solid #000',
		background: '#000',
		backgroundImage: (power) =>
			Boolean(power) ? `url(${wallpaper})` : null,
		backgroundSize: 'cover',
		backgroundRepeat: 'no-repeat',
		backgroundPosition: 'center',
	},
	volumeUp: {
		zIndex: 101,
		position: 'absolute',
		top: 150,
		left: 180,
		height: '10%',
		width: '7%',
		cursor: 'pointer',
	},
	volumeDown: {
		zIndex: 101,
		position: 'absolute',
		top: 150,
		left: 155,
		height: '10%',
		width: '7%',
		cursor: 'pointer',
	},
	clickVolumeUp: {
		zIndex: 101,
		position: 'absolute',
		top: 170,
		left: 94,
		height: '8%',
		width: '7%',
		cursor: 'pointer',
	},
	clickVolumeDown: {
		zIndex: 101,
		position: 'absolute',
		top: 170,
		left: 70,
		height: '8%',
		width: '7%',
		cursor: 'pointer',
	},
	power: {
		zIndex: 101,
		position: 'absolute',
		bottom: 14,
		left: 90,
		height: '5%',
		width: '50%',
		cursor: 'pointer',
	},
	radioHeaderInfo: {
		textAlign: 'center',
		width: '100%',
		lineHeight: '25px',
		height: 25,
		fontSize: '12px',
	},
	radioChannelNumber: {
		width: 'fit-content',
		lineHeight: '35px',
		height: 'fit-content',
		position: 'absolute',
		top: 100,
		left: 0,
		right: 0,
		margin: 'auto',
		fontSize: 18,
	},
	input: {
		width: '100%',
		height: 'fit-content',
		position: 'absolute',
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
		padding: '12px 6px',
		background: `#000`,
	},
	radioType: {
		width: 'fit-content',
		height: 'fit-content',
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		fontSize: 10,
	},
}));

const volumeUp = (e) => {
	Nui.send('VolumeUp', {});
};

const volumeDown = (e) => {
	Nui.send('VolumeDown', {});
};

const clickVolumeUp = (e) => {
	Nui.send('ClickVolumeUp', {});
};

const clickVolumeDown = (e) => {
	Nui.send('ClickVolumeDown', {});
};

const powerToggle = (e) => {
	Nui.send('TogglePower', {});
};

export default (props) => {
	const hidden = useSelector((state) => state.app.hidden);
	const power = useSelector((state) => state.app.power);
	const frequency = useSelector((state) => state.app.frequency);
	const volume = useSelector((state) => state.app.volume);
	const radioType = useSelector((state) => state.app.type);
	const freqName = useSelector((state) => state.app.frequencyName);

	const classes = useStyles(power);

	const [freq, setFreq] = useState(frequency);

	useEffect(() => {
		return () => {
			if (freq != frequency) setFreq(frequency);
		};
	}, []);

	const onChange = (e) => {
		setFreq(+e.target.value);
	};

	const setChannel = (e) => {
		e.preventDefault();
		Nui.send('SetChannel', {
			frequency: (+freq).toFixed(1),
		});
		setFreq((+freq).toFixed(1));
	};

	return (
		<Slide direction="up" in={!hidden} mountOnEnter unmountOnExit>
			<div className={classes.wrapper}>
				<img className={classes.radioImg} src={frame} />
				<div className={classes.radio}>
					<Tooltip
						title="Volume Up"
						aria-label="volup"
						placement="top"
					>
						<div
							className={classes.volumeUp}
							onClick={volumeUp}
						></div>
					</Tooltip>
					<Tooltip
						title="Volume Down"
						aria-label="voldown"
						placement="top"
					>
						<div
							className={classes.volumeDown}
							onClick={volumeDown}
						></div>
					</Tooltip>
					<Tooltip
						title="Clicks Volume Up"
						aria-label="volup"
						placement="top"
					>
						<div
							className={classes.clickVolumeUp}
							onClick={clickVolumeUp}
						></div>
					</Tooltip>
					<Tooltip
						title="Clicks Volume Down"
						aria-label="voldown"
						placement="top"
					>
						<div
							className={classes.clickVolumeDown}
							onClick={clickVolumeDown}
						></div>
					</Tooltip>
					<Tooltip title="Power" aria-label="power" placement="top">
						<div
							className={classes.power}
							onClick={powerToggle}
						></div>
					</Tooltip>
					<div className={classes.screen}>
						<Fade in={Boolean(power)}>
							<div
								style={{
									width: '100%',
									height: '100%',
									position: 'relative',
								}}
							>
								<div className={classes.radioType}>
									{radioType}
								</div>
								<div className={classes.radioHeaderInfo}>
									<FontAwesomeIcon icon={['far', 'volume']} />
									{`: ${volume}%`}
								</div>

								<div className={classes.radioChannelNumber}>
									{power
										? frequency > 0
											? freqName === ''
												? `Channel #${frequency}`
												: `${freqName}`
											: 'No Active Channel'
										: 'Powered Off'}
								</div>

								<form
									className={classes.input}
									onSubmit={setChannel}
								>
									<TextField
										fullWidth
										id="frequency"
										type="number"
										disabled={!power}
										InputProps={{
											inputProps: {
												step: 0.1,
												min: 0,
												max: 999,
											},

											endAdornment: (
												<InputAdornment position="end">
													<IconButton type="submit">
														<FontAwesomeIcon
															icon={[
																'far',
																'walkie-talkie',
															]}
														/>
													</IconButton>
												</InputAdornment>
											),
										}}
										value={freq}
										onChange={onChange}
										label="Frequency"
									/>
								</form>
							</div>
						</Fade>
					</div>
				</div>
			</div>
		</Slide>
	);
};
