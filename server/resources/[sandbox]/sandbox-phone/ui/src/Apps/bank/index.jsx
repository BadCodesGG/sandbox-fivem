import React, { Fragment, useEffect, useMemo, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { throttle } from 'lodash';
import { IconButton, Tooltip } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { AppContainer, Loader } from '../../components';
import Nui from '../../util/Nui';
import Accounts from './Accounts';
import { useNavigate } from 'react-router';

const useStyles = makeStyles((theme) => ({
	accList: {
		padding: '4px 8px',
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

	const bankData = useSelector((state) => state.data.data.bankAccounts);
	const pendingBills = bankData?.pendingBills;

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
					<IconButton
						className={classes.btns}
						onClick={() => navigate('/apps/bank/bill')}
					>
						{Boolean(pendingBills) && pendingBills.length > 0 && (
							<span className={classes.billCount}>
								{pendingBills.length}
							</span>
						)}
						<FontAwesomeIcon icon={['far', 'file-invoice']} />
					</IconButton>
					<IconButton
						onClick={() => fetch()}
						disabled={Boolean(loading)}
					>
						<FontAwesomeIcon icon={['fas', 'arrows-rotate']} />
					</IconButton>
				</Fragment>
			}
		>
			{loading ? (
				<Loader static text={loading} />
			) : (
				<div className={classes.accList}>
					<Accounts />
				</div>
			)}
		</AppContainer>
	);
};
