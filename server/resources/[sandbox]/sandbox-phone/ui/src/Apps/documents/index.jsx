import React, { Fragment } from 'react';
import { useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';
import { useNavigate } from 'react-router-dom';
import { Tooltip, IconButton } from '@mui/material';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { AppContainer } from '../../components';
import Document from './components/Document';

const useStyles = makeStyles((theme) => ({
	emptyMsg: {
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
		marginTop: '25%',
	},
	list: {
		height: '100%',
		overflow: 'auto',
	},
}));

export default (props) => {
	const classes = useStyles();
	const history = useNavigate();
	const documents = useSelector((state) => state.data.data.myDocuments);

	const createNew = () => {
		history(`/apps/documents/new`);
	};

	return (
		<AppContainer
			appId="documents"
			actions={
				<Fragment>
					<Tooltip title="Create">
						<span>
							<IconButton
								className={classes.headerAction}
								onClick={createNew}
							>
								<FontAwesomeIcon
									className={'fa'}
									icon={['fas', 'plus']}
								/>
							</IconButton>
						</span>
					</Tooltip>
				</Fragment>
			}
		>
			{Boolean(documents) && documents.length > 0 ? (
				documents
					.sort((a, b) => b.time - a.time)
					.map((document) => {
						return (
							<Document
								key={`doc-${document.id}`}
								document={document}
							/>
						);
					})
			) : (
				<div className={classes.emptyMsg}>No Documents</div>
			)}
		</AppContainer>
	);
};
