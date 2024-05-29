import React from 'react';
import { connect, useDispatch, useSelector } from 'react-redux';
import { useNavigate } from 'react-router-dom';
import { makeStyles } from '@mui/styles';

import Nui from '../../util/Nui';
import { useAlert } from '../../hooks';
import { Modal } from '../../components';
import { install } from '../../Apps/store/action';

const useStyles = makeStyles((theme) => ({}));

export default connect(null, { install })((props) => {
	const showAlert = useAlert();
	const classes = useStyles();
	const history = useNavigate();
	const dispatch = useDispatch();
	const open = useSelector((state) => state.usb.open);
	const usb = useSelector((state) => state.usb.usb);

	const onClose = () => {
		dispatch({
			type: 'USE_USB',
			payload: false,
		});
	};

	const onInstall = async () => {
		try {
			props.install(usb.app);
			dispatch({
				type: 'USE_USB',
				payload: false,
			});
		} catch (err) {}
	};

	const onEject = async () => {
		try {
			//let res = await (await Nui.send('EjectUSB')).json();
			let res = true;

			if (res) {
				dispatch({
					type: 'REMOVE_USB',
				});
				showAlert('Ejected USB');
			} else {
				dispatch({
					type: 'USE_USB',
					payload: false,
				});
				showAlert('Unable to Eject USB');
			}
		} catch (err) {
			console.error(err);
			dispatch({
				type: 'USE_USB',
				payload: false,
			});
			showAlert('Unable to Eject USB');
		}
	};

	return (
		<>
			{usb != null && (
				<Modal
					open={open}
					title={`USB: ${usb.app}`}
					onClose={onClose}
					onAccept={onInstall}
					onDelete={onEject}
					acceptLang="Install"
					deleteLang="Eject USB"
				/>
			)}
		</>
	);
});
