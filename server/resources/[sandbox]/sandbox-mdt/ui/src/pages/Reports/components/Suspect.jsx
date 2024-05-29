import React, { useState, useEffect } from 'react';
import { Chip, Grid, IconButton, Tooltip } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { useSelector } from 'react-redux';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { CurrencyFormat } from '../../../util/Parser';
import { PleaTypes } from './SuspectForm';
import Truncate from '@nosferatu500/react-truncate';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: 10,
		borderRadius: 4,
		border: `1px solid ${theme.palette.border.input}`,
		margin: 0,
		marginBottom: 10,
		display: 'inline-flex',
		minWidth: '100%',
		position: 'relative',
		flexDirection: 'column',
		verticalAlign: 'top',
		boxShadow:
			'inset 0 0 14px 0 rgba(0,0,0,.3), inset 0 2px 0 rgba(0,0,0,.2)',
	},
	title: {
		fontSize: 18,
		lineHeight: '48px',
		'& small': {
			'&::before': {
				content: '" - "',
				color: theme.palette.text.alt,
			},
			fontSize: 14,
			color: theme.palette.primary.main,
		},
	},
	body: {
		padding: 10,
		borderTop: `1px solid ${theme.palette.border.input}`,
	},
	charge: {
		margin: 4,
		'&.type-1': {
			backgroundColor: theme.palette.info.main,
		},
		'&.type-2': {
			backgroundColor: theme.palette.warning.main,
		},
		'&.type-3': {
			backgroundColor: theme.palette.error.main,
		},
	},
	points: {
		position: 'relative',
	},
	flags: {
		position: 'absolute',
		height: 'fit-content',
		width: 'fit-content',
		right: 0,
		top: 0,
		bottom: 0,
		margin: 'auto',
	},
	flag: {
		fontSize: 18,
		height: 32,
		width: 32,
		color: theme.palette.error.light,
		'&:not(:last-of-type)': {
			marginRight: 5,
		},
	},
}));

export default ({ data, onEdit, onDelete }) => {
	const classes = useStyles();
	const charges = useSelector((state) => state.data.data.charges);

	const [susCharges, setSusCharges] = useState(Array());

	useEffect(() => {
		if (data.charges) {
			setSusCharges(
				data.charges
					.filter((c) => charges.find(ch => ch.id === c.id))
					.map(c => ({
						...charges.find(ch => ch.id == c.id),
						id: c.id,
						count: c.count,
					}))
			);
		}
	}, [data]);

	const months = susCharges
		.filter((c) => c.jail)
		.reduce((a, b) => +a + +b.jail, 0);
	//.reduce((a, b) => +a + +b.jail * b.count, 0);
	const fine = susCharges
		.filter((c) => c.fine)
		.reduce((a, b) => +a + +b.fine * b.count, 0);
	const points = susCharges
		.filter((c) => c.points)
		.reduce((a, b) => +a + +b.points * b.count, 0);
	const isFelony = susCharges.filter((c) => c.type > 2).length > 0;

	return (
		<div className={classes.wrapper}>
			<Grid container>
				<Grid item xs={10} className={classes.title}>
					{data.First} {data.Last}
					<small>
						{PleaTypes.filter((p) => p.value == data.plea)[0].label}
					</small>
				</Grid>
				<Grid item xs={2} style={{ textAlign: 'right' }}>
					<IconButton onClick={onEdit} disabled={data.sentenced}>
						<FontAwesomeIcon icon={['fas', 'pen-to-square']} />
					</IconButton>
					<IconButton onClick={onDelete} disabled={data.sentenced}>
						<FontAwesomeIcon icon={['fas', 'trash-can-xmark']} />
					</IconButton>
				</Grid>
				<Grid item xs={12} className={classes.body}>
					{susCharges
						.sort((a, b) => b.jail + b.fine - (a.jail - a.fine))
						.map((c, k) => {
							return (
								<Chip
									key={`charge-${k}`}
									className={`${classes.charge} type-${c.type}`}
									label={<Truncate lines={1}>{`${c.title} x${c.count}`}</Truncate>}
								/>
							);
						})}
				</Grid>
				<Grid item xs={12} className={classes.body}>
					<Grid container>
						<Grid item xs={4}>
							Months: <small>{data.sentenced ? data.jail : months}</small>
						</Grid>
						<Grid item xs={4}>
							Fine: <small>{data.sentenced ? CurrencyFormat.format(data.fine) : CurrencyFormat.format(fine)}</small>
						</Grid>
						<Grid item xs={4} className={classes.points}>
							<div>
								Points: <small>{data.sentenced ? data.points : points}</small>
								{!data.sentenced && <div className={classes.flags}>
									{isFelony && !data.Licenses?.Weapons?.Suspended &&
										(
											<Tooltip title="This will result in this persons weapons permit being revoked">
												<IconButton
													className={classes.flag}
												>
													<FontAwesomeIcon
														icon={['fas', 'dagger']}
													/>
												</IconButton>
											</Tooltip>
										)}
									{(!data.Licenses?.Drivers?.Suspended && data.Licenses?.Drivers?.Points + points >= 12) && (
										<Tooltip title="This will result in this persons drivers license being revoked">
											<IconButton
												className={classes.flag}
											>
												<FontAwesomeIcon
													icon={['fas', 'id-badge']}
												/>
											</IconButton>
										</Tooltip>
									)}
								</div>}
							</div>
						</Grid>
					</Grid>
				</Grid>
			</Grid>
		</div>
	);
};
