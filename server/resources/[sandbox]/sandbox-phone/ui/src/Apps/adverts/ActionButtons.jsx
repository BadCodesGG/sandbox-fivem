import React, { Fragment, useEffect, useState } from 'react';
import { useSelector } from 'react-redux';
import { useNavigate } from 'react-router-dom';
import { IconButton, Tooltip } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { useAlert } from '../../hooks';
import Nui from '../../util/Nui';

const useStyles = makeStyles((theme) => ({
	add: {
		position: 'absolute',
		bottom: '12%',
		right: '10%',
		backgroundColor: '#f9a825',
		fontSize: 22,
		opacity: 0.3,
		'&:hover': {
			backgroundColor: '#f9a825',
			opacity: 1,
			transition: 'opacity ease-in 0.3s',
		},
	},
	delete: {
		position: 'absolute',
		bottom: '19%',
		right: '10%',
		backgroundColor: theme.palette.error.main,
		fontSize: 22,
		opacity: 0.3,
		'&:hover': {
			backgroundColor: theme.palette.error.main,
			opacity: 1,
			transition: 'opacity ease-in 0.3s',
		},
	},
	bump: {
		position: 'absolute',
		bottom: '26%',
		right: '10%',
		backgroundColor: theme.palette.error.light,
		fontSize: 22,
		opacity: 0.3,
		'&:hover': {
			backgroundColor: theme.palette.error.light,
			opacity: 1,
			transition: 'opacity ease-in 0.3s',
		},
	},
}));

export default (props) => {
	const showAlert = useAlert();
	const classes = useStyles();
	const history = useNavigate();
	const myAdvertId = useSelector((state) => state.data.data.player.Source);
	const myAdvert = useSelector((state) => state.data.data.adverts)[
		myAdvertId
	];

	const [del, setDel] = useState(false);
	const onDelete = () => {
		setDel(true);

		setTimeout(() => {
			Nui.send('DeleteAdvert')
				.then((res) => {
					showAlert('Advertisement Deleted');
				})
				.catch((err) => {});
		}, 500);
	};
	const onBump = () => {
		Nui.send('UpdateAdvert', {
			...myAdvert,
			time: Date.now(),
		})
			.then((res) => {
				showAlert('Advertisement Bumped');
			})
			.catch((err) => {
				showAlert('Failed Bumping Advertisement');
			});
	};

	return (
		<Fragment>
			{myAdvert != null && !del ? (
				<>
					{myAdvert.time < Date.now() - 1000 * 60 * 30 ? (
						<Tooltip title="Bump Ad">
							<IconButton onClick={onBump} disabled={del}>
								<FontAwesomeIcon icon={['fas', 'upload']} />
							</IconButton>
						</Tooltip>
					) : undefined}
					<Tooltip title="Edit Ad">
						<IconButton
							onClick={() => history('/apps/adverts/edit')}
						>
							<FontAwesomeIcon icon={['fas', 'pen-to-square']} />
						</IconButton>
					</Tooltip>
					<Tooltip title="Delete Ad">
						<IconButton onClick={onDelete} disabled={del}>
							<FontAwesomeIcon icon={['fas', 'trash']} />
						</IconButton>
					</Tooltip>
				</>
			) : (
				<Tooltip title="Delete Ad">
					<IconButton onClick={() => history('/apps/adverts/add')}>
						<FontAwesomeIcon icon={['fas', 'plus']} />
					</IconButton>
				</Tooltip>
			)}
		</Fragment>
	);
};
