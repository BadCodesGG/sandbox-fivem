import React, { useEffect } from 'react';
import { connect, useSelector } from 'react-redux';
import { Slide } from '@mui/material';
import { makeStyles } from '@mui/styles';

import Slot from './Slot';
import { getItemImage } from './item';
import HotbarSlot from './HotbarSlot';

const useStyles = makeStyles((theme) => ({
	slide: {
		position: 'absolute',
		bottom: 0,
		top: 0,
		left: 0,
		justifyContent: 'center',
		gap: 8,
		display: 'flex',
		flexFlow: 'column',
		height: 'fit-content',
		margin: 'auto',
	},
	equipped: {
		marginRight: 20,
	},
}));

export default connect()((props) => {
	const classes = useStyles();
	const hidden = useSelector((state) => state.app.showHotbar);
	const showing = useSelector((state) => state.app.showing);
	const hbItems = useSelector((state) => state.app.hotbarItems);
	const equipped = useSelector((state) => state.app.equipped);
	const items = useSelector((state) => state.inventory.items);
	const itemsLoaded = useSelector((state) => state.inventory.itemsLoaded);
	const playerInventory = useSelector((state) => state.inventory.player);

	const mode = useSelector((state) => state.app.mode);

	useEffect(() => {
		let tmr = null;
		if (hidden) {
			tmr = setTimeout(() => {
				props.dispatch({
					type: 'HOTBAR_HIDE',
				});
			}, 5000);

			return () => {
				clearTimeout(tmr);
			};
		}
	}, [hidden]);

	if (mode === 'crafting') {
		return null;
	}

	if (!itemsLoaded || !Boolean(hbItems) || Object.keys(items).length == 0)
		return null;
	return (
		<Slide direction="right" in={hidden} className={classes.slide}>
			<div>
				{[...Array(5).keys()].map((value) => {
					return (
						<HotbarSlot
							key={value + 1}
							slot={value + 1}
							item={
								hbItems.filter((s) => s.Slot == value + 1)
									? hbItems.filter(
											(s) => s.Slot == value + 1,
									  )[0]
									: {}
							}
						/>
					);
				})}
				{Boolean(equipped) && (
					<HotbarSlot equipped inHotbar={true} item={equipped} />
				)}
			</div>
		</Slide>
	);
});
