import React, { memo } from 'react';

import AppRoutes from './AppRoutes';
import { useMyApps } from '../../hooks';
import PhoneCase from './PhoneCase';

export default memo(() => {
	const apps = useMyApps();

	return (
		<PhoneCase>
			<AppRoutes apps={apps} />
		</PhoneCase>
	);
});
