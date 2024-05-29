import React from 'react';
import { useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';
import { AppContainer } from '../../components';
import Email from './Email';

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
	const emails = useSelector((state) =>
		state.data.data.emails.filter(
			(e) => !Boolean(e.expires) || e.expires > Date.now() / 1000,
		),
	);

	return (
		<AppContainer appId="email">
			{emails.length > 0 ? (
				emails
					.sort((a, b) => b.time - a.time)
					.map((email, index) => {
						return <Email key={`email-${index}`} email={email} />;
					})
			) : (
				<div className={classes.emptyMsg}>You Have No Emails</div>
			)}
		</AppContainer>
	);
};
