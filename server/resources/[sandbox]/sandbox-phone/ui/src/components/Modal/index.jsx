import React, { useRef } from 'react';
import { DialogActions, IconButton, Button } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

const useStyles = makeStyles((theme) => ({
	closer: {
		position: 'absolute',
		right: 0,
		left: 0,
		top: 0,
		margin: 'auto',
		height: '98%',
		width: '100%',
		background: '#000',
		opacity: 0.75,
		zIndex: 10000,
		borderRadius: 40,
	},
	modal: {
		height: 'fit-content',
		width: '90%',
		position: 'absolute',
		top: 0,
		bottom: 0,
		right: 0,
		left: 0,
		margin: 'auto',
		background: `${theme.palette.secondary.dark}d1`,
		backdropFilter: 'blur(10px)',
		padding: 10,
		zIndex: 10001,
		borderRadius: 15,
	},
	header: {
		position: 'relative',
		'& span': {
			fontSize: 16,
			lineHeight: '20px',
		},
	},
	body: {
		padding: 5,
		maxHeight: 600,
		overflow: 'auto',
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
	closeBtn: {
		position: 'absolute',
		right: 0,
		height: 'fit-content',
		width: 'fit-content',
		top: 0,
		bottom: 0,
		margin: 'auto',
		fontSize: 14,
	},
}));

export default ({
	className,
	open,
	title,
	onClose,
	hideClose = false,
	disabled = false,
	form = false,
	formStyle = null,
	onAccept = null,
	onDelete = null,
	submitLang = 'Submit',
	deleteLang = 'Delete',
	acceptLang = 'Accept',
	closeLang = 'Close',
	children = null,
}) => {
	const classes = useStyles();

	const internalSubmit = (e) => {
		e.preventDefault();
		onAccept(e);
	};

	if (!open) return null;

	if (form) {
		return (
			<div>
				<div className={classes.closer} onClick={onClose}></div>
				<div
					className={`${classes.modal} ${
						className != null ? className : ''
					}`}
				>
					<div className={classes.header}>
						{Boolean(title) && <span>{title}</span>}
						<IconButton
							className={classes.closeBtn}
							onClick={onClose}
						>
							<FontAwesomeIcon icon={['fas', 'x']} />
						</IconButton>
					</div>
					<form onSubmit={internalSubmit} style={formStyle}>
						<div className={classes.body}></div>
						{Boolean(children) && <>{children}</>}
						<DialogActions style={{ paddingBottom: 0 }}>
							{!hideClose && (
								<Button
									color="inherit"
									onClick={onClose}
									disabled={disabled}
								>
									{closeLang}
								</Button>
							)}
							{Boolean(onDelete) && (
								<Button onClick={onDelete} disabled={disabled}>
									{deleteLang}
								</Button>
							)}
							<Button type="submit" disabled={disabled}>
								{submitLang}
							</Button>
						</DialogActions>
					</form>
				</div>
			</div>
		);
	} else {
		return (
			<div>
				<div className={classes.closer} onClick={onClose}></div>
				<div
					className={`${classes.modal} ${
						className != null ? className : ''
					}`}
				>
					<div className={classes.header}>
						{Boolean(title) && <span>{title}</span>}
						<IconButton
							className={classes.closeBtn}
							onClick={onClose}
						>
							<FontAwesomeIcon icon={['fas', 'x']} />
						</IconButton>
					</div>
					<div className={classes.body} style={formStyle}>
						{Boolean(children) && <>{children}</>}
					</div>
					<DialogActions style={{ paddingBottom: 0 }}>
						{!hideClose && (
							<Button
								color="inherit"
								onClick={onClose}
								disabled={disabled}
							>
								{closeLang}
							</Button>
						)}
						{Boolean(onDelete) && (
							<Button onClick={onDelete} disabled={disabled}>
								{deleteLang}
							</Button>
						)}
						{Boolean(onAccept) && (
							<Button onClick={onAccept} disabled={disabled}>
								{acceptLang}
							</Button>
						)}
					</DialogActions>
				</div>
			</div>
		);
	}
};
