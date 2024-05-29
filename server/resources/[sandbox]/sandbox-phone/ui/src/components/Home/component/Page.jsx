import React from 'react';
import { makeStyles } from '@mui/styles';
import { GridContextProvider, GridDropZone, GridItem } from 'react-grid-dnd';

import { useMyApps } from '../../../hooks';
import AppButton from './AppButton';
import EncryptedButton from './EncryptedButton';

const useStyles = makeStyles((theme) => ({
	icon: {
		width: '25% !important',
	},
	page: {
		height: '100%',
		width: '95%',
		margin: 'auto',
		display: 'flex',
		flexWrap: 'wrap',
		justifyContent: 'start',
		alignContent: 'flex-start',
		overflow: 'hidden',
	},
}));

export default ({
	page,
	isEditing,
	onStartEdit,
	onClick,
	onRightClick,
	onAppDrag,
	onDragState,
	contextApp = null,
	contextDock = false,
}) => {
	const classes = useStyles();
	const apps = useMyApps();

	return (
		<GridContextProvider onChange={onAppDrag}>
			<GridDropZone
				id="home"
				className={`${classes.page} dropzone`}
				boxesPerRow={4}
				rowHeight={120}
				disableDrag={!isEditing}
			>
				{page.map((app, i) => {
					if (app != '' && Boolean(apps[app])) {
						let data = apps[app];
						return (
							<GridItem
								key={`home-${i}-${app}`}
								className={classes.icon}
							>
								<AppButton
									docked={false}
									appId={app}
									app={data}
									isEdit={isEditing}
									isEditing={isEditing}
									onClick={onClick}
									onRightClick={onRightClick}
									onStartEdit={onStartEdit}
									onDragState={onDragState}
									isContext={
										contextApp === app && !contextDock
									}
								/>
							</GridItem>
						);
					} else
						return (
							<GridItem
								key={`home-${i}-${app}`}
								className={classes.icon}
							>
								<EncryptedButton
									docked={false}
									appId={app}
									isEdit={isEditing}
									isEditing={isEditing}
									onClick={onClick}
									onRightClick={onRightClick}
									onStartEdit={onStartEdit}
									onDragState={onDragState}
									isContext={
										contextApp === app && !contextDock
									}
								/>
							</GridItem>
						);
				})}
			</GridDropZone>
		</GridContextProvider>
	);
};
