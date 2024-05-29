import React, { useState, Fragment } from 'react';
import { useDispatch } from 'react-redux';
import { makeStyles } from '@mui/styles';
import { useNavigate } from 'react-router-dom';
import { IconButton } from '@mui/material';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { AppContainer, AppInput, Editor, Loader } from '../../components';
import { useAlert, useAppData } from '../../hooks';
import Nui from '../../util/Nui';

const useStyles = makeStyles((theme) => ({
	form: {
		padding: 10,
	},
	creatorInput: {
		marginBottom: 8,
	},
}));

export default (props) => {
	const appData = useAppData('documents');
	const classes = useStyles(appData);
	const dispatch = useDispatch();
	const history = useNavigate();
	const showAlert = useAlert();

	const [loading, setLoading] = useState(false);
	const [state, setState] = useState({
		title: '',
		content: '',
	});

	const onChange = (e) => {
		setState({
			...state,
			[e.target.name]: e.target.value,
		});
	};

	const onCreate = async () => {
		try {
			setLoading(true);
			let res = await (await Nui.send('CreateDocument', state)).json();

			if (res) {
				dispatch({
					type: 'ADD_DATA',
					payload: {
						type: 'myDocuments',
						data: res,
					},
				});

				showAlert('Document Created Successfully');
				history(`/apps/documents/view/${res.id}`, { replace: true });
			} else {
				showAlert('Failed Creating Document');
			}
		} catch (err) {
			console.error(err);
			showAlert('Error Creating Document');
		}
		setLoading(false);
	};

	return (
		<AppContainer
			appId="documents"
			titleOverride="Create New Document"
			actionShow={state?.title != '' && state?.content != ''}
			actions={
				<Fragment>
					<IconButton disabled={loading} onClick={onCreate}>
						<FontAwesomeIcon icon={['far', 'floppy-disk']} />
					</IconButton>
				</Fragment>
			}
		>
			<div className={classes.form}>
				{loading && <Loader static text="Submitting Document" />}
				<AppInput
					app={appData}
					className={classes.creatorInput}
					fullWidth
					label="Title"
					name="title"
					disabled={loading}
					onChange={onChange}
					value={state.title}
					inputProps={{
						maxLength: 100,
					}}
				/>
				<Editor
					appData={appData}
					disabled={loading}
					value={state.content}
					onChange={onChange}
					name="content"
					placeholder="Write Stuff Here"
				/>
			</div>
		</AppContainer>
	);
};
