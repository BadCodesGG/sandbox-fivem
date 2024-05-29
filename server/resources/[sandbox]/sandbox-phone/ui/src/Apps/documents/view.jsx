import React, { useState, useEffect, Fragment } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { useNavigate, useParams } from 'react-router-dom';
import {
	Select,
	MenuItem,
	IconButton,
	Tooltip,
	TextField,
	FormControlLabel,
	Checkbox,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { CopyToClipboard } from 'react-copy-to-clipboard';
import ReactPlayer from 'react-player';
import Moment from 'react-moment';
import JsxParser from 'react-jsx-parser';

import {
	AppContainer,
	Confirm,
	EventListener,
	Loader,
	Modal,
} from '../../components';
import { LightboxImage } from '../../components';
import { useAlert } from '../../hooks';
import Nui from '../../util/Nui';

const useStyles = makeStyles((theme) => ({
	body: {
		padding: '10px 20px',
		height: (app) => (app.signature_required ? '88%' : '100%'),
		overflowX: 'hidden',
		overflowY: 'auto',
	},
	emptyMsg: {
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
		marginTop: '25%',
	},
	editField: {
		marginTop: 20,
		width: '100%',
	},
	signature: {
		padding: '15px 35px',
		height: '12%',
		overflowX: 'hidden',
		overflowY: 'auto',
		textAlign: 'center',
	},
	messageImg: {
		display: 'block',
		maxWidth: 200,
	},
	documentContainer: {
		overflowWrap: 'break-word',
		'& .ql-size-huge': {
			fontSize: '2.5em',
		},
		'& .ql-size-large': {
			fontSize: '1.5em',
		},
		'& .ql-size-small': {
			fontSize: '0.75em',
		},
		'& .ql-font-serif': {
			fontFamily: 'Georgia, Times New Roman, serif',
		},
		'& .ql-font-monospace': {
			fontFamily: 'Monaco, Courier New, monospace',
		},
		'& .ql-align-center': {
			textAlign: 'center',
		},
		'& .ql-align-right': {
			textAlign: 'right',
		},
		'& .ql-align-justify': {
			textAlign: 'justify',
		},
		'& .ql-syntax': {
			color: '#f8f8f2',
			overflow: 'visible',
			backgroundColor: '#23241f !important',
		},
	},
}));

export default (props) => {
	const dispatch = useDispatch();
	const history = useNavigate();
	const showAlert = useAlert();
	const params = useParams();
	const { id } = params;

	const player = useSelector((state) => state.data.data.player);
	const myDocs = useSelector((state) => state.data.data.myDocuments);
	const document = myDocs.find((d) => d.id == id);
	const classes = useStyles({
		signature_required: Boolean(document?.signature_required),
	});

	const [sharing, setSharing] = useState(null);
	const [deleting, setDeleteing] = useState(null);
	const [signed, setSigned] = useState(false);
	const [viewSignatures, setViewSignatures] = useState(false);
	const [signingDoc, setSigningDoc] = useState(false);
	const [loadingSigs, setLoadingSigs] = useState(false);
	const [docSigners, setDocSigners] = useState(Array());

	useEffect(() => {
		if (Boolean(document)) {
			if (Boolean(document?.signed)) {
				setSigned(true);
			} else {
				setSigned(false);
			}

			onFetchSignatures();
		}
	}, [id, document]);

	const onDelete = async () => {
		try {
			let res = await (
				await Nui.send('DeleteDocument', {
					id,
				})
			).json();

			if (res) {
				dispatch({
					type: 'REMOVE_DATA',
					payload: { type: 'myDocuments', id },
				});

				showAlert('Document Deleted Successfully');
				history(`/apps/documents`, { replace: true });
			} else {
				showAlert('Failed Deleting Document');
			}
		} catch (err) {
			console.error(err);
			showAlert('Error Deleting Document');
		}
	};

	const onShare = async (isNearby) => {
		setSharing({
			target: '',
			type: 1,
			nearby: isNearby,
		});
	};

	const onConfirmShare = async () => {
		const sending = {
			...sharing,
			target: +sharing.target,
			document,
		};

		setSharing(null);

		try {
			let res = await (await Nui.send('ShareDocument', sending)).json();
			showAlert(res ? 'Document Shared' : 'Unable to Share Document');
		} catch (err) {
			console.error(err);
			showAlert('Unable to Share Document');
		}
	};

	const onSignature = async (e) => {
		try {
			setSigningDoc(true);
			let res = await (
				await Nui.send('SignDocument', document?.id)
			).json();
			if (res) {
				showAlert('Document Signed');
				setSigned(true);
			} else {
				showAlert('Unable to Sign Document');
			}
		} catch (err) {
			console.error(err);
			showAlert('Unable to Sign Document');
		}
		setSigningDoc(false);
	};

	const onFetchSignatures = async () => {
		try {
			setLoadingSigs(true);
			let res = await (
				await Nui.send('Documents:GetSignatures', id)
			).json();

			if (Boolean(res)) {
				setDocSigners(res);
			}
		} catch (err) {
			console.error(err);
		}
		setLoadingSigs(false);
	};

	const config = [
		{
			regex: /((https?:\/\/(www\.)?(i\.)?imgur\.com\/[a-zA-Z\d]+)(\.png|\.jpg|\.jpeg|\.gif)?)/gim,
			replace: `<LightboxImage className={classes.messageImg} src={"$1"} />`,
		},
		{
			regex: /(http|https):\/\/(\S+)\.([a-z]{2,}?)(.*?)( |\,|$|\.)(mp4)/gim,
			replace: `<div>
    			<ReactPlayer
    				key={key}
    				volume={0.25}
    				width="100%"
    				controls={true}
    				url={"$1"}
    			/>
    		</div>`,
		},
	];

	let cont = document?.content ?? '';
	config.forEach((c) => {
		cont = cont.replace(c.regex, c.replace);
	});

	const onDeleted = (data) => {
		if (data.id != +id) return;
		dispatch({
			type: 'REMOVE_DATA',
			payload: { type: 'myDocuments', id: data.id },
		});
		showAlert('Document Deleted');
		history('/apps/documents', { replace: true });
	};

	const onReceiveSignature = (data) => {
		if (data.id != +id) return;

		if (
			docSigners?.length > 0 &&
			docSigners.filter((s) => s?.sid == data?.signature?.sid).length > 0
		) {
			setDocSigners([
				...docSigners.map((s) => {
					if (s.sid == data.signature.sid)
						return { ...s, ...data.signature };
					else return s;
				}),
			]);
		} else {
			setDocSigners([...docSigners, data.signature]);
		}
	};

	return (
		<EventListener
			event="DOCUMENTS_DOCUMENT_DELETED"
			onEvent={onDeleted}
			state={{ document, id, docSigners }}
		>
			<EventListener
				event="DOCUMENTS_RECEIVED_SIGNATURE"
				onEvent={onReceiveSignature}
				state={{ document, id, docSigners }}
			>
				<AppContainer
					appId="documents"
					titleOverride={
						Boolean(document) ? document?.title : 'Invalid Document'
					}
					actions={
						<Fragment>
							{document?.sid == player.SID && (
								<Tooltip title="Edit">
									<span>
										<IconButton
											className={classes.headerAction}
											onClick={() =>
												history(
													`/apps/documents/edit/${id}`,
												)
											}
										>
											<FontAwesomeIcon
												className={'fa'}
												icon={['fas', 'pen-to-square']}
											/>
										</IconButton>
									</span>
								</Tooltip>
							)}
							<Tooltip title="Delete">
								<span>
									<IconButton
										className={classes.headerAction}
										onClick={() => setDeleteing(true)}
									>
										<FontAwesomeIcon
											className={'fa'}
											icon={['fas', 'trash-can-xmark']}
										/>
									</IconButton>
								</span>
							</Tooltip>
							{!loadingSigs && docSigners.length > 0 && (
								<Tooltip title="View Signatures">
									<span>
										<IconButton
											className={classes.headerAction}
											onClick={() =>
												setViewSignatures(true)
											}
										>
											<FontAwesomeIcon
												className={'fa'}
												icon={['fas', 'signature']}
											/>
										</IconButton>
									</span>
								</Tooltip>
							)}
							<Tooltip title="Share">
								<span>
									<IconButton
										className={classes.headerAction}
										onClick={() => onShare(false)}
									>
										<FontAwesomeIcon
											className={'fa'}
											icon={['fas', 'share']}
										/>
									</IconButton>
								</span>
							</Tooltip>
							<Tooltip title="Nearby Share">
								<span>
									<IconButton
										className={classes.headerAction}
										onClick={() => onShare(true)}
									>
										<FontAwesomeIcon
											className={'fa'}
											icon={['fas', 'tower-broadcast']}
										/>
									</IconButton>
								</span>
							</Tooltip>
						</Fragment>
					}
				>
					{Boolean(document) ? (
						<Fragment>
							<div className={classes.body}>
								<JsxParser
									autoCloseVoidElements
									bindings={{
										classes,
									}}
									className={classes.documentContainer}
									components={{
										LightboxImage,
										ReactPlayer,
										CopyToClipboard,
									}}
									jsx={cont}
									blacklistedTags={[
										'iframe',
										'script',
										'link',
										'applet',
										'style',
									]}
								/>
							</div>
							{Boolean(document?.signature_required) && (
								<div className={classes.signature}>
									<FormControlLabel
										control={
											<Checkbox
												disabled={
													Boolean(document?.signed) ||
													signingDoc
												}
												checked={signed}
												onChange={(e) => onSignature(e)}
											/>
										}
										label={`${
											signed
												? 'Document Signed'
												: 'Sign Document'
										} (as ${
											signed
												? document?.signed_name
												: `${player.First[0]}. ${player.Last}`
										})`}
									/>
								</div>
							)}

							{sharing != null && (
								<Modal
									open={sharing != null}
									title="Share This Document"
									onAccept={onConfirmShare}
									onClose={() => setSharing(null)}
									acceptLang="Share"
									closeLang="Cancel"
								>
									<div>
										Sharing without making a copy will allow
										the recipient to see any changes you
										make to the document!
										<Select
											id="targetType"
											name="targetType"
											className={classes.editField}
											value={sharing.type}
											onChange={(e) => {
												setSharing({
													...sharing,
													type: e.target.value,
												});
											}}
										>
											<MenuItem value={1}>
												Share a Copy
											</MenuItem>
											<MenuItem
												value={2}
												disabled={
													document?.sid !== player.SID
												}
											>
												Share
											</MenuItem>
											<MenuItem
												value={3}
												disabled={
													document?.sid !== player.SID
												}
											>
												Share w/ Signature Request
											</MenuItem>
										</Select>
										{!sharing.nearby && (
											<TextField
												required
												fullWidth
												className={classes.editField}
												label="State ID"
												name="target"
												type="text"
												value={sharing.target}
												helperText={
													'The State ID of who you want to share the document with.'
												}
												inputProps={{
													maxLength: 6,
												}}
												onChange={(e) => {
													setSharing({
														...sharing,
														target: e.target.value,
													});
												}}
											/>
										)}
									</div>
								</Modal>
							)}
							{viewSignatures && (
								<Modal
									open={viewSignatures}
									title="Document Signatures"
									onClose={() => setViewSignatures(false)}
									closeLang="Close"
								>
									{loadingSigs ? (
										<Loader text="Loading Signers" />
									) : (
										<div>
											{docSigners.map((s) => {
												if (Boolean(s.signed)) {
													return (
														<p key={s.sid}>
															{`${s.signed_name} (State ID: ${s.sid}) on `}
															<Moment
																unix
																format="L LT"
																date={s.signed}
															/>
														</p>
													);
												} else {
													return (
														<p key={s.sid}>
															{`${s.signed_name} (State ID: ${s.sid}) Not Yet Signed`}
														</p>
													);
												}
											})}
										</div>
									)}
								</Modal>
							)}
							<Confirm
								title="Delete Document?"
								open={deleting}
								confirm="Yes"
								decline="No"
								onConfirm={onDelete}
								onDecline={() => setDeleteing(null)}
							/>
						</Fragment>
					) : (
						<div className={classes.emptyMsg}>
							Document Doesn't Exist
						</div>
					)}
				</AppContainer>
			</EventListener>
		</EventListener>
	);
};
