import React, { useState, useEffect } from 'react';
import { useSelector } from 'react-redux';
import { Tabs, Tab } from '@mui/material';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { useNavigate } from 'react-router-dom';
import { useLocation } from 'react-router';
import { usePermissions } from '../../hooks';

export default ({ links }) => {
	const location = useLocation();
	const history = useNavigate();
	const hasPerm = usePermissions();
	const user = useSelector((state) => state.app.user);

	const [value, setValue] = useState("/");
	const handleChange = (e, newValue) => {
		history(newValue);
	};

	useEffect(() => {
		const test = links.find(l => l.path === location.pathname || (l.path.startsWith(location.pathname) && location.pathname.charAt(location.pathname.length) === "/"));
		setValue(test?.path);
	}, [location.pathname]);

	return (
		<div>
			<Tabs
				value={value}
				onChange={handleChange}
				variant="scrollable"
				scrollButtons="auto"
			>
				{links.filter(l => !l.restrict || (Boolean(user) && hasPerm(l.restrict.permission))).map(l =>
					<Tab
						key={l.path}
						value={l.path}
						label={l.label}
						icon={<FontAwesomeIcon icon={l.icon} />}
					/>
				)}
			</Tabs>
		</div>
	);
};
