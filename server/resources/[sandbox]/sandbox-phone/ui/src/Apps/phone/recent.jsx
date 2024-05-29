import React, { useState, Fragment } from 'react';
import { useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';

import { AppContainer } from '../../components';
import Call from './component/Call';
import { IconButton } from '@mui/material';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { useNavigate } from 'react-router';

const useStyles = makeStyles((theme) => ({
	emptyMsg: {
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
		marginTop: '25%',
	},
}));

export default (props) => {
	const classes = useStyles();
	const navigate = useNavigate();
	const calls = useSelector((state) => state.data.data.calls);
	const [expanded, setExpanded] = useState(-1);

	const handleClick = (index) => (event, newExpanded) => {
		setExpanded(newExpanded ? index : -1);
	};

	return (
		<AppContainer
			appId="phone"
			actions={
				<Fragment>
					<IconButton onClick={() => navigate('/apps/phone')}>
						<FontAwesomeIcon icon={['far', 'phone']} />
					</IconButton>
				</Fragment>
			}
		>
			{calls.filter((c) => Boolean(c)).length > 0 ? (
				calls
					.filter((c) => Boolean(c))
					.sort((a, b) => b.time - a.time)
					.map((call, key) => {
						return (
							<Call
								key={key}
								expanded={expanded}
								index={key}
								call={call}
								onClick={handleClick(key)}
							/>
						);
					})
			) : (
				<div className={classes.emptyMsg}>You Have No Recent Calls</div>
			)}
		</AppContainer>
	);
};
