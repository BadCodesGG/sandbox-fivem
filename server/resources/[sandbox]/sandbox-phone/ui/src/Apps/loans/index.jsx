import React, { useEffect, useState, useMemo, Fragment } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles, withStyles } from '@mui/styles';
import { throttle } from 'lodash';
import { Tabs, Tab, IconButton, Tooltip } from '@mui/material';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import Loans from './Loans';
import Nui from '../../util/Nui';
import { AppContainer, Loader } from '../../components';
import { Modal } from '../../components';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
	header: {
		background: '#30518c',
		fontSize: 20,
		padding: 15,
		lineHeight: '50px',
		height: 78,
	},
	headerAction: {},
	content: {
		height: '92%',
		padding: 15,
		overflowY: 'auto',
		overflowX: 'hidden',
		padding: 10,
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
	highlight: {
		color: theme.palette.info.light,
	},
	editField: {
		marginTop: 0,
		marginBottom: 10,
		width: '100%',
	},
}));

const LoanTabs = withStyles((theme) => ({
	root: {
		borderBottom: '1px solid #30518c',
	},
	indicator: {
		backgroundColor: '#30518c',
	},
}))((props) => <Tabs {...props} />);

const LoanTab = withStyles((theme) => ({
	root: {
		width: '50%',
		'&:hover': {
			color: '#30518c',
			transition: 'color ease-in 0.15s',
		},
		'&$selected': {
			color: '#30518c',
			transition: 'color ease-in 0.15s',
		},
		'&:focus': {
			color: '#30518c',
			transition: 'color ease-in 0.15s',
		},
	},
	selected: {},
}))((props) => <Tab {...props} />);

export default (props) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const activeTab = useSelector((state) => state.loans.tab);
	const loadedData = useSelector((state) => state.data.data.bankLoans);
	const creditScore = useSelector(
		(state) => state.data.data.bankLoans?.creditScore,
	);
	const [loading, setLoading] = useState(false);
	const [viewingCredit, setViewingCredit] = useState(false);

	const fetch = useMemo(
		() =>
			throttle(async () => {
				if (loading) return;
				setLoading(true);
				try {
					let res = await (await Nui.send('Loans:GetData')).json();
					if (res) {
						dispatch({
							type: 'SET_DATA',
							payload: {
								type: 'bankLoans',
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
					// 		type: 'bankLoans',
					// 		data: Array(),
					// 	},
					// });
				}
				setLoading(false);
			}, 3500),
		[],
	);

	useEffect(() => {
		fetch();
	}, []);

	const viewCredit = () => {
		setViewingCredit(true);
	};

	return (
		<AppContainer
			appId="loans"
			actions={
				<Fragment>
					<Tooltip title="Credit Score">
						<span>
							<IconButton
								onClick={viewCredit}
								disabled={loading || viewingCredit}
								className={classes.headerAction}
							>
								<FontAwesomeIcon icon={['fas', 'award']} />
							</IconButton>
						</span>
					</Tooltip>
					<Tooltip title="Refresh">
						<span>
							<IconButton
								onClick={fetch}
								disabled={loading}
								className={classes.headerAction}
							>
								<FontAwesomeIcon
									className={`fa ${loading ? 'fa-spin' : ''}`}
									icon={['fas', 'arrows-rotate']}
								/>
							</IconButton>
						</span>
					</Tooltip>
				</Fragment>
			}
		>
			{loading || !loadedData ? (
				<Loader static text="Loading Loans" />
			) : (
				<>
					<Loans onFetch={fetch} />
					<Modal
						open={viewingCredit}
						title={`Credit Score`}
						onClose={() => setViewingCredit(false)}
					>
						<p className={classes.editField}>
							Your Credit Score is{' '}
							<span className={classes.highlight}>
								{creditScore ?? 0}
							</span>
							<br />
							<br />
							You can improve your credit score by paying loans on
							time or in advanced. Missing loan payments will
							decrease your credit score.
						</p>
					</Modal>
				</>
			)}
		</AppContainer>
	);
};
