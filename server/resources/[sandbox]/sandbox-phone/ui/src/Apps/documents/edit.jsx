import React, { useEffect, useState, useMemo, Fragment } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles, withStyles } from '@mui/styles';
import { useNavigate, useParams } from 'react-router-dom';
import { Tooltip, IconButton, Tab, Tabs } from '@mui/material';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import _ from 'lodash';

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
	const { id } = useParams();
	const document = useSelector(
		(state) => state.data.data.myDocuments.filter((d) => d.id == id)[0],
	);

	const [error, setError] = useState(null);
	const [loading, setLoading] = useState(true);
	const [canSave, setCanSave] = useState(false);
	const [state, setState] = useState({
		title: '',
		content: '',
	});

	useEffect(() => {
		if (Boolean(document))
			setState({ title: document.title, content: document.content });
		else setError('Unable To Find Document');

		setLoading(false);
	}, [document]);

	useEffect(() => {
		setCanSave(
			!_.isEqual(state, {
				title: document.title,
				content: document.content,
			}),
		);
	}, [state, document]);

	const onChange = (e) => {
		setState({
			...state,
			[e.target.name]: e.target.value,
		});
	};

	const onEdit = async () => {
		try {
			if (!canSave) return;

			setLoading(true);
			let res = await (
				await Nui.send('EditDocument', {
					id,
					data: state,
				})
			).json();

			if (res) {
				showAlert('Document Edited Successfully');
				history(`/apps/documents/view/${id}`, { replace: true });
			} else {
				showAlert('Failed Editing Document');
			}
		} catch (err) {
			console.error(err);
			showAlert('Error Editing Document');
		}
		setLoading(false);
	};

	return (
		<AppContainer
			appId="documents"
			titleOverride="Create New Document"
			actionShow={canSave}
			actions={
				<Fragment>
					<IconButton disabled={loading} onClick={onEdit}>
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
				{!loading && (
					<Editor
						appData={appData}
						name="content"
						disabled={loading}
						value={state.content}
						onChange={(e) => {
							setState({ ...state, content: e.target.value });
						}}
						placeholder="Write Stuff Here"
					/>
				)}
			</div>
		</AppContainer>
	);
};
