import React, { Fragment, useEffect, useMemo, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { throttle } from 'lodash';
import { IconButton, Tooltip } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { useNavigate } from 'react-router';

import { AppContainer } from '../../components';
import Nui from '../../util/Nui';
import Bills from './Bills';

const useStyles = makeStyles((theme) => ({
	accList: {
		padding: '4px 8px',
	},
	logo: {
		zIndex: 0,
		width: 350,
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
		opacity: 0.15,
		transform: 'rotate(-45deg)',
		userSelect: 'none',
		userDrag: 'none',
	},
	btns: {
		position: 'relative',
	},
	billCount: {
		position: 'absolute',
		fontSize: 12,
		bottom: 0,
		right: 0,
		zIndex: 10,
		background: theme.palette.error.main,
		padding: '2px 6px',
		borderRadius: 20,
	},
}));

export default (props) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const navigate = useNavigate();

	const [loading, setLoading] = useState(false);

	const fetch = useMemo(
		() =>
			throttle(async () => {
				if (loading) return;
				setLoading('Loading Accounts');
				try {
					let res = await (await Nui.send('Banking:GetData')).json();
					if (res) {
						dispatch({
							type: 'SET_DATA',
							payload: {
								type: 'bankAccounts',
								data: res,
							},
						});
					} else {
						throw res;
					}
				} catch (err) {
					// dispatch({
					// 	type: 'SET_DATA',
					// 	payload: {
					// 		type: 'bankAccounts',
					// 		data: {
					// 			accounts: Array(),
					// 			transactions: Object(),
					// 			pendingBills: Array()
					// 		},
					// 	},
					// });
				}
				setLoading(false);
			}, 2000),
		[],
	);

	useEffect(() => {
		fetch();
	}, []);

	return (
		<AppContainer
			appId="bank"
			actions={
				<Fragment>
					<Tooltip title="View Bills">
						<IconButton onClick={() => navigate(-1)}>
							<FontAwesomeIcon icon={['far', 'chevron-left']} />
						</IconButton>
					</Tooltip>
					<Tooltip title="Refresh Accounts">
						<IconButton
							onClick={() => fetch()}
							disabled={Boolean(loading)}
						>
							<FontAwesomeIcon
								className={`fa ${loading ? 'fa-spin' : ''}`}
								icon={['fas', 'arrows-rotate']}
							/>
						</IconButton>
					</Tooltip>
				</Fragment>
			}
		>
			<div className={classes.accList}>
				<Bills setLoading={setLoading} refreshAccounts={fetch} />
			</div>
		</AppContainer>
	);
};
