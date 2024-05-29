import React, { useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Menu, MenuItem, ListItem, ListItemButton, ListItemAvatar, ListItemText, Avatar, Badge, Divider } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import Nui from '../../../util/Nui';
import { useQualifications } from '../../../hooks';
import UnitMember from './UnitMember';
import UnitIcon from './UnitIcon';
import UnitTypeMenu from './UnitTypeMenu';

const useStyles = makeStyles((theme) => ({
	ava: {
		transition: 'filter ease-in 0.15s',
		fontSize: 14,
		'&.police': {
			backgroundColor: '#247ba5',
			color: theme.palette.text.main,
		},
		'&.ems': {
			backgroundColor: '#760036',
			color: theme.palette.text.main,
		},
		'&.prison': {
			backgroundColor: '#3EA99F',
			color: theme.palette.text.main,
		},
		'&.invalid': {
			backgroundColor: '#6e1616',
			color: theme.palette.text.main,
		},
		'&.unavailable': {
			backgroundColor: '#D69200',
			color: theme.palette.text.main,
		},
		'&.clickable:hover': {
			filter: 'brightness(0.7)',
			cursor: 'pointer',
		},
	},
	item: {},
	subUnits: {
		marginTop: 5,
	},
	subUnit: {
		fontSize: 16,
		backgroundColor: "rgba(255, 255, 255, 0.1)",
		padding: '2.5px 5px',
		borderRadius: 5,
	},
	radioChannel: {
		cursor: "pointer",
		display: 'flex',
		flexDirection: 'row',
		backgroundColor: "rgba(255, 255, 255, 0.1)",
		padding: '5px 10px',
		borderRadius: 5,
		justifyContent: "center",
		alignItems: "center",
		gap: 7,
	}
}));

export default ({ unitType, unitData, missingCallsign }) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const hasQual = useQualifications();
	const user = useSelector((state) => state.app.user);

	const myUnit = useSelector((state) => state.alerts.myUnit);
	const job = useSelector((state) => state.app.govJob);
	const [anchorEl, setAnchorEl] = useState(null);
	const [open, setOpen] = useState(null);

	const [subOpen, setSubOpen] = useState(null);

	const allUnits = useSelector(state => state.alerts.units);
	const units = allUnits?.[unitType];

	const subUnits = units?.filter(u => u.operatingUnder === unitData.primary) ?? Array();

	const myUnitData = allUnits?.[myUnit.job].find(u => u.primary === myUnit.primary);
	const mySubUnits = units?.filter(u => u.operatingUnder === myUnitData?.primary);

	// Is the primary or is part of the unit
	const withinUnit = (unitData.primary == myUnitData?.primary || myUnitData?.operatingUnder == unitData.primary)

	if (!myUnitData) return null;

	const PursuitModeColor = (mode) => {
		let color = "secondary";
		switch (mode) {
			case "S":
				color = "primary";
				break;
			case "A":
				color = "success";
				break;
			default:
			// code block
		}
		return color;
	}

	const changeUnit = async (newType) => {
		dispatch({
			type: 'ALERTS_CHANGE_UNIT_TYPE',
			payload: {
				job: unitData.job,
				primary: unitData.primary,
				type: newType,
			}
		})
		setOpen(null);
	};

	const toggleAvailability = async () => {
		dispatch({
			type: 'ALERTS_CHANGE_UNIT_AVAILABILITY',
			payload: {
				job: unitData.job,
				primary: unitData.primary,
			}
		})
		setOpen(null);
	};

	const operateUnder = async () => {
		dispatch({
			type: 'ALERTS_OPERATE_UNDER_UNIT',
			payload: {
				job: unitData.job,
				primary: unitData.primary,
				unit: myUnitData.primary,
			}
		})
		setOpen(null);
	};

	const assignTo = async () => {
		try {
			await Nui.send('OperateUnder', {
				job: open.job,
				primary: user.Callsign,
				unit: open.primary,
			});
			setOpen(null);
		} catch (err) {
			console.log(err);
		}
	};

	const breakOff = async () => {
		dispatch({
			type: 'ALERTS_BREAK_OFF_UNIT',
			payload: {
				job: unitData.job,
				primary: unitData.primary,
				unit: myUnitData.primary,
			}
		})
		setOpen(null);
	};

	const removeUnit = async (subUnit) => {
		dispatch({
			type: 'ALERTS_BREAK_OFF_UNIT',
			payload: {
				job: unitData.job,
				primary: unitData.primary,
				unit: subUnit,
			}
		})
		setOpen(null);
		setSubOpen(null);
	};

	const setRadio = (freq) => {
		try {
			Nui.send("SwapToRadio", {
				radio: (+freq).toFixed(1),
			});
		} catch (e) { }
	}

	if (missingCallsign && unitType != 'tow') {
		return (
			<>
				<ListItem className={classes.item}>
					<ListItemAvatar>
						<Avatar className={`${classes.ava} invalid`}>
							<FontAwesomeIcon icon={['fas', 'octagon-exclamation']} />
						</Avatar>
					</ListItemAvatar>
					<ListItemText
						//primary={unitData.primary}
						primary={`${unitData.First[0]}. ${unitData.Last}`}
						secondary="Unset Callsign"
					/>
				</ListItem>
			</>
		);
	}

	return (
		<>
			{unitType === 'police' ? (
				<ListItem divider className={classes.item}>
					<ListItemAvatar>
						{unitData.pursuitMode && <Badge badgeContent={unitData.pursuitMode} color={PursuitModeColor(unitData.pursuitMode)} anchorOrigin={{ vertical: 'top', horizontal: 'right' }}>
							<Avatar
								className={`${classes.ava} police${job.Id == 'police' ? ' clickable' : ''} ${!unitData.available ? 'unavailable' : ''}`}
								onClick={
									job.Id == 'police'
										? (e) => {
											setAnchorEl(e.currentTarget);
											setOpen({
												...unitData,
												job: 'police',
											});
										}
										: null
								}
							>
								<UnitIcon job="police" type={unitData.type} available={unitData.available} />
							</Avatar>
						</Badge>}
						{unitData.pursuitMode == null &&
							<Avatar
								className={`${classes.ava} police${job.Id == 'police' ? ' clickable' : ''} ${!unitData.available ? 'unavailable' : ''}`}
								onClick={
									job.Id == 'police'
										? (e) => {
											setAnchorEl(e.currentTarget);
											setOpen({
												...unitData,
												job: 'police',
											});
										}
										: null
								}
							>
								<UnitIcon job="police" type={unitData.type} available={unitData.available} />
							</Avatar>}
					</ListItemAvatar>
					<ListItemText
						style={{ marginTop: 0 }}
						primary={<UnitMember data={unitData} isPrimary />}
						secondary={
							subUnits.length > 0 ? (
								<span className={classes.subUnits}>
									{subUnits.map((sub, k) => (
										<span className={classes.subUnit} key={k} style={{ marginRight: (k === subUnits.length - 1) ? 0 : 7.5 }} onClick={(e) => {
											setAnchorEl(e.currentTarget);
											setSubOpen(sub);
										}}>
											<UnitMember
												data={sub}
												isLast={k === subUnits.length - 1}
											/>
										</span>
									))}
								</span>
							) : null
						}
					/>
					{unitData.radioChannel && <div className={classes.radioChannel} onClick={() => setRadio(unitData.radioChannel)}>
						<FontAwesomeIcon icon={['fas', 'walkie-talkie']} />
						<Divider orientation="vertical" flexItem />
						{unitData.radioChannel !== "0" ? unitData.radioChannel : "0"}
					</div>}
				</ListItem>
			) : unitType === 'ems' ? (
				<ListItem divider className={classes.item}>
					<ListItemAvatar>
						<Avatar
							className={`${classes.ava} ems${job.Id == 'ems' ? ' clickable' : ''} ${!unitData.available ? 'unavailable' : ''}`}
							onClick={
								job.Id == 'ems'
									? (e) => {
										setAnchorEl(e.currentTarget);
										setOpen({
											...unitData,
											job: 'ems',
										});
									}
									: null
							}
						>
							<UnitIcon job="ems" type={unitData.type} available={unitData.available} />
						</Avatar>
					</ListItemAvatar>
					<ListItemText
						primary={<UnitMember data={unitData} isPrimary />}
						secondary={
							subUnits.length > 0 ? (
								<span className={classes.subUnits}>
									{subUnits.map((sub, k) => (
										<span className={classes.subUnit} key={k} style={{ marginRight: (k === subUnits.length - 1) ? 0 : 7.5 }} onClick={(e) => {
											setAnchorEl(e.currentTarget);
											setSubOpen(sub);
										}}>
											<UnitMember
												data={sub}
												isLast={k === subUnits.length - 1}
											/>
										</span>
									))}
								</span>
							) : null
						}
					/>
					{unitData.radioChannel && <div className={classes.radioChannel} onClick={() => setRadio(unitData.radioChannel)}>
						<FontAwesomeIcon icon={['fas', 'walkie-talkie']} />
						<Divider orientation="vertical" flexItem />
						{unitData.radioChannel !== "0" ? unitData.radioChannel : "0"}
					</div>}
				</ListItem>
			) : unitType === 'prison' ? (
				<ListItem divider className={classes.item}>
					<ListItemAvatar>
						<Avatar
							className={`${classes.ava} prison${job.Id == 'prison' ? ' clickable' : ''} ${!unitData.available ? 'unavailable' : ''}`}
							onClick={
								job.Id == 'prison'
									? (e) => {
										setAnchorEl(e.currentTarget);
										setOpen({
											...unitData,
											job: 'prison',
										});
									}
									: null
							}
						>
							<UnitIcon job="prison" type={unitData.type} available={unitData.available} />
						</Avatar>
					</ListItemAvatar>
					<ListItemText
						primary={<UnitMember data={unitData} isPrimary />}
						secondary={
							subUnits.length > 0 ? (
								<span className={classes.subUnits}>
									{subUnits.map((sub, k) => (
										<span className={classes.subUnit} key={k} style={{ marginRight: (k === subUnits.length - 1) ? 0 : 7.5 }} onClick={(e) => {
											setAnchorEl(e.currentTarget);
											setSubOpen(sub);
										}}>
											<UnitMember
												data={sub}
												isLast={k === subUnits.length - 1}
											/>
										</span>
									))}
								</span>
							) : null
						}
					/>
					{unitData.radioChannel && <div className={classes.radioChannel} onClick={() => setRadio(unitData.radioChannel)}>
						<FontAwesomeIcon icon={['fas', 'walkie-talkie']} />
						<Divider orientation="vertical" flexItem />
						{unitData.radioChannel !== "0" ? unitData.radioChannel : "0"}
					</div>}
				</ListItem>
			) : unitType === 'tow' ? (
				<ListItem divider className={classes.item}>
					<ListItemText
						primary={
							<UnitMember
								isTow={unitData?.character?.SID}
								data={unitData}
								isPrimary
							/>
						}
						secondary={unitData?.character?.Phone}
					/>
				</ListItem>
			) : null}
			<Menu anchorEl={anchorEl} open={open != null} onClose={() => setOpen(null)}>
				{Boolean(open) && (
					<div>
						<ListItem>Unit: {unitData.primary}</ListItem>
						{unitData.primary != myUnitData.primary && myUnitData.operatingUnder === null && (!mySubUnits || mySubUnits?.length === 0) && (
							<ListItemButton onClick={operateUnder}>
								Operate Under
							</ListItemButton>
						)}

						{unitData.primary != myUnitData.primary && myUnitData.operatingUnder == unitData.primary && (
							<ListItemButton onClick={breakOff}>
								Break Off From {unitData.primary}
							</ListItemButton>
						)}

						{/* {unitData.primary != user.Callsign &&
							subUnits.length == 0 &&
							unitData.operatingUnder === null &&
							hasQual('PD_FTO') && (
								<ListItemButton onClick={assignTo}>
									Operate Under Me
								</ListItemButton>
							)} */}

						{withinUnit && <MenuItem onClick={toggleAvailability}>
							Toggle Availability
						</MenuItem>}

						{withinUnit && (
							<UnitTypeMenu current={unitData.type} unit={open} onChange={changeUnit} />
						)}
					</div>
				)}
			</Menu>
			<Menu anchorEl={anchorEl} open={open === null && subOpen !== null} onClose={() => setSubOpen(null)}>
				{Boolean(subOpen) && (
					<div>
						<ListItem>Sub Unit: {subOpen?.primary}</ListItem>

						{unitData.primary != user.Callsign && myUnitData.operatingUnder == unitData.primary && (
							<ListItemButton onClick={breakOff}>
								Break Off From {subOpen?.primary}
							</ListItemButton>
						)}

						{unitData.primary == myUnitData.primary && subUnits.length > 0 && (
							<ListItemButton onClick={() => removeUnit(subOpen?.primary)}>
								Remove Unit
							</ListItemButton>
						)}

						{/* {unitData.primary != user.Callsign &&
							subUnits.length == 0 &&
							unitData.operatingUnder === null &&
							hasQual('PD_FTO') && (
								<ListItemButton onClick={assignTo}>
									Operate Under Me
								</ListItemButton>
							)} */}
					</div>
				)}
			</Menu>
		</>
	);
};
