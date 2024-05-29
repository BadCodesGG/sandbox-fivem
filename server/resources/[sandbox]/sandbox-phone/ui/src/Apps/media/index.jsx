import React, { useEffect, useState, useMemo } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { useNavigate } from 'react-router-dom';
import { makeStyles } from '@mui/styles';
import { throttle } from 'lodash';
import {
	List,
	ListItem,
	IconButton,
	Grid,
	ListItemText,
	ListSubheader,
	ImageListItem,
	ImageList,
	ImageListItemBar,
	Typography,
} from '@mui/material';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { CopyToClipboard } from 'react-copy-to-clipboard';
import { LightboxImage } from '../../components';
import Nui from '../../util/Nui';
import { useAlert } from '../../hooks';
import { AppContainer } from '../../components';
import Moment from 'react-moment';
import { Modal } from '../../components';

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
	summary: {
		//backgroundColor: 'red',
	},
	highlight: {
		color: theme.palette.success.main,
		transition: 'color ease-in 0.15s',

		'&:hover': {
			color: theme.palette.success.dark,
			cursor: 'pointer',
		},
	},
	image: {
		objectFit: "cover",
		width: "100%",
		height: "auto",
		display: "block",
		flexGrow: 1,
	},
}));

export default (props) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const media = useSelector((state) => state.data.data.media);
	const [loading, setLoading] = useState(false);
	const [isSetToDelete, setDeleteMedia] = useState(false);
	const [mediaToDelete, setDeleteMediaToDelete] = useState('');
	const showAlert = useAlert();

	const DeleteMedia = async () => {
		setDeleteMedia(false);
		try {
			let res = await (
				await Nui.send('Media:DeleteMedia', {
					id: mediaToDelete,
				})
			).json();
			if (res) {
				showAlert('Media deleted successfully!');
				fetch();
				setDeleteMediaToDelete('');
			} else {
				showAlert('Unable to delete media!');
				setDeleteMediaToDelete('');
			}
		} catch (err) {
			showAlert('Unable to delete media!');
			setDeleteMediaToDelete('');
		}
	};

	const PreparePhotoDelete = async (id) => {
		setDeleteMedia(true);
		setDeleteMediaToDelete(id);
	};
	
	const fetch = useMemo(
		() =>
			throttle(async () => {
				if (loading) return;
				setLoading(true);
				try {
					let res = await (
						await Nui.send('Media:GetMedia')
					).json();
					if (res) {
						dispatch({
							type: 'SET_DATA',
							payload: {
								type: 'media',
								data: res,
							},
						});
					} else {
						// dispatch({
						// 	type: 'SET_DATA',
						// 	payload: {
						// 		type: 'media',
						// 		data: Array(),
						// 	},
						// });
					}
				} catch (err) {
					console.error(err);
					// dispatch({
					// 	type: 'SET_DATA',
					// 	payload: {
					// 		type: 'media',
					// 		data: Array(),
					// 	},
					// });
				}
				setLoading(false);
			}, 1000),
		[],
	);

	useEffect(() => {
		fetch();
	}, []);

	return (
		<AppContainer appId="media">
			{Boolean(media) && media.length > 0 ? (
				<>
					<ImageList sx={{ width: "100%", height: "100%" }}>
						{/* <ImageListItem key="Subheader" cols={2}>
							<ListSubheader component="div">December</ListSubheader>
						</ImageListItem> */}
						{media.map((item) => (
							<ImageListItem key={item.id} sx={{ height: "200px !important" }}>
								<LightboxImage
									src={item.image_url}
									className={classes.image}
									loading="lazy"
									alt={item.sid}
								/>
								<ImageListItemBar
									title={`Photo: ${item.id}`}
									// subtitle={<Moment
									// 	unix
									// 	format="L LT"
									// 	date={item.time}
									// />}
									actionIcon={
										<>
											<CopyToClipboard
												text={item.image_url}
												key={item.image_url}
												onCopy={() => showAlert('Photo Link Copied!')}
											>
												<IconButton aria-label={`Copy link to ${item.id}`}>
													<FontAwesomeIcon
														icon={[
															'fas',
															'link',
														]}
														style={{fontSize: "14px"}}
													/>
												</IconButton>
											</CopyToClipboard>
											<IconButton
												aria-label={`Delete Photo ${item.id}`}
												onClick={() => PreparePhotoDelete(item.id)}
											>
												<FontAwesomeIcon
													icon={[
														'fas',
														'trash',
													]}
													style={{fontSize: "14px"}}
												/>
											</IconButton>
										</>
									}
								/>
							</ImageListItem>
						))}
					</ImageList>
					<p style={{fontSize: 12, textAlign: "center"}}>*only pulls the latest 10 until further update</p>
				</>
			) : (
				<List sx={{ width: '100%' }}>
					<ListItem>
						<ListItemText>
							No media items are available at this time
						</ListItemText>
					</ListItem>
				</List>
			)}
			<Modal
                form
				open={isSetToDelete}
				title={`Delete Photo: ${mediaToDelete}?`}
				onAccept={DeleteMedia}
                submitLang="Delete"
				onClose={() => setDeleteMedia(false)}
			>
				<p>
					Are you sure you want to delete? <br/>Photo cannot be restored once deleted.
				</p>
			</Modal>
		</AppContainer>
	);
};
