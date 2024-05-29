import React, { useEffect, useState, createRef,  } from 'react';
import loadscript from 'load-script'
import { makeStyles } from '@mui/styles';
import { useDispatch } from 'react-redux';
import { AppBar } from '@mui/material';
import Nui from '../../util/Nui';
import useCountDown from 'react-countdown-hook';
import parseMilliseconds from 'parse-ms';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
	content: {
		height: '93.5%',
		padding: '0 0px 0 10px',
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
	header: {
		background: theme.palette.primary.main,
		fontSize: 20,
		padding: '0 15px',
		lineHeight: '55px',
		height: 55,
		padding: '0 8px',
	},
	headerInner: {
		display: 'flex',
	},
	headerAction: {
		textAlign: 'right',
		display: 'flex',
		'&:hover': {
			color: theme.palette.text.main,
			transition: 'color ease-in 0.15s',
		},

		'& .MuiIconButton-root': {
			width: 40,
			height: 40,
			margin: 'auto',
			position: 'relative',
		},
	},
	summary: {
		//backgroundColor: 'red',
	},
	musicContainer: {
		display: "flex",
		"flex-direction": "column",
		height: "80%"
	},
	musicWrapper: {
		"flex-grow": "1"
	},
	iframeMusic: {
		"height": "100%",
		"border": "none",
		"width": "100%"
	},
	volumeControl: {
		"text-align": "center",
		"margin-top": "25px"
	},
	volumeLabel: {
		margin: 0
	},
}));

const MusicPlayer = (props) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const [isPlaying, setIsPlaying] = useState(false)
	const [playlistIndex, setPlaylistIndex] = useState(0)
	const [trackInfo, setTrackInfo] = useState(false);
	const [currentVolume, setCurrentVolume] = useState(50);
	const [player, setPlayer] = useState(false)
	const iframeRef = createRef()

	useEffect(() => {

		loadscript('https://w.soundcloud.com/player/api.js', () => {
			
			const player = window.SC.Widget(iframeRef.current)
			setPlayer(player);
			player.setVolume(currentVolume);
			const { PLAY, PLAY_PROGRESS, PAUSE, FINISH, ERROR } = window.SC.Widget.Events

			player.bind( PLAY, () => {
				setIsPlaying(true);
				player.getCurrentSoundIndex( (playerPlaylistIndex) => {            
					setPlaylistIndex(playerPlaylistIndex)
				})
				player.getCurrentSound(function(currentSound) {
					setTrackInfo({
						label_name: currentSound.label_name,
						title: currentSound.title,
						genre: currentSound.genre,
						release_date: currentSound.release_date,
						id: currentSound.id
					})
					dispatch({
						type: 'MUSIC_PROGRESS',
						payload: {
							music: {
								label_name: currentSound.label_name,
								title: currentSound.title,
								id: currentSound.id,
								isPlaying: true,
							},
						},
					});
				});
			})

			// player.bind( PLAY_PROGRESS, () => {
			// 	player.getPosition(function(retval){
			// 		setCurrentDuration(retval);
			// 	})
			// })

			player.bind( PAUSE, () => {
				player.isPaused( (playerIsPaused) => {
					if (playerIsPaused) {
						setIsPlaying(false)
						player.getCurrentSound(function(currentSound) {
							dispatch({
								type: 'MUSIC_PROGRESS',
								payload: {
									music: {
										label_name: currentSound.label_name,
										title: currentSound.title,
										id: currentSound.id,
										isPlaying: false,
									},
								},
							});
						});
					}
				})
			})

			player.bind( FINISH, () => {
				player.getCurrentSound(function(currentSound) {
					dispatch({
						type: 'MUSIC_PROGRESS',
						payload: {
							music: {
								label_name: currentSound.label_name,
								title: currentSound.title,
								id: currentSound.id,
								isPlaying: false,
							},
						},
					});
					SendRoyalties(currentSound);
					setTrackInfo(false);
				});
			})
		})

	}, [])

	useEffect(() => {
	
		if (!player) return

		player.isPaused( (playerIsPaused) => {
			if (isPlaying && playerIsPaused) {
				player.play();
			} else if (!isPlaying && !playerIsPaused) {
				player.pause();
			}
		})
		
	},[isPlaying])

	useEffect(() => {
		
		if (!player) return

		player.getCurrentSoundIndex( (playerPlaylistIndex) => {            
			if (playerPlaylistIndex !== playlistIndex) {
				player.skip(playlistIndex)
			}
		})
		
	},[playlistIndex])

	const togglePlayback = () => {
		setIsPlaying(!isPlaying)
	}

	const changePlaylistIndex = (skipForward = true) => {
		player.getSounds( (playerSongList) => {      

			let nextIndex = (skipForward) ? playlistIndex + 1 : playlistIndex - 1

			if (nextIndex < 0) {
				nextIndex = 0
			} else if (nextIndex >= playerSongList.length) {
				nextIndex = playerSongList.length - 1
			}

			setPlaylistIndex(nextIndex)

		})
	}

	const changeMusicVolume = (value) => {
		setCurrentVolume(value);
		player.setVolume(currentVolume);
	}

	const SendRoyalties = async (e) => {
		let hasSent = false; 
		try {
			if (e && !hasSent) {
				hasSent = true;
				let res = await (
					await Nui.send('Music:SendRoyalties', {
						label_name: e.label_name,
						title: e.title,
						id: e.id
					})
				).json();

				if (res) {
					console.info('royalties successfully sent.');
				} else {
					console.log('error sending royalties.');
				}
				setTimeout(() => {
					hasSent = false;
				}, 1000);
			} else {
				console.info('Song isnt over yet.');
			}
		} catch (err) {
			console.error(err);
		}
	};

	return (
		<div style={{visibility: props.show ? 'visible' : 'hidden', height: props.show ? '100%' : '0'}}>
			{/* <AppContainer appId="music"> */}
				<div style={{backgroundColor: "#252726", height: "100%"}}>
					<AppBar
							position="static"
							className={classes.header}
							elevation={0}
							style={{background: "#63e6be"}}
						>
							<div className={classes.headerInner}>
								<div className={classes.appTitle}>
									Music
								</div>
							</div>
					</AppBar>
					<div className={classes.musicContainer}>
						<div className={classes.musicWrapper}>
							<iframe ref={iframeRef} className={classes.iframeMusic} scrolling="no" allow="autoplay" 
							src={ "https://w.soundcloud.com/player/?url=https://soundcloud.com/badcodes/sets/sandboxrp-city-music" }>
							</iframe>
						</div>
					</div>
					
					<div className={classes.volumeControl}>
						{/* <p>isPlaying: { (isPlaying) ? 'true' : 'false'}</p>
						<p>Playlist Index: {playlistIndex}</p>
						<p>Track Info: <br/>Label: {trackInfo.label_name} <br/>Title: {trackInfo.title} <br/>Genre: {trackInfo.genre} <br/>Release Date:{trackInfo.release_date}</p>
						<p>Controls:</p>
						<button onClick={ () => changePlaylistIndex(false) }>{'<'}</button>
						<button onClick={ togglePlayback }>{ (isPlaying) ? 'Pause' : 'Play' }</button>
						<button onClick={ () => changePlaylistIndex(true) }>{'>'}</button> */}
						<p className={classes.volumeLabel}>Volume Control</p>
						<input type="range" min="0" step="5" max="100" className={classes.volumeRange} value={currentVolume} onChange={ (e) => changeMusicVolume(e.target.value) } onClick={ (e) => changeMusicVolume(e.target.value) } ></input>
					</div>
				</div>
			{/* </AppContainer> */}
		</div>
	);
};

export default MusicPlayer;