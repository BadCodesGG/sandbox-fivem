import { useSelector } from 'react-redux';

export default (id = null) => {
	const apps = useSelector((state) => state.phone.apps);

	if (Boolean(id) && Boolean(apps[id])) return apps[id];
	else return null;
};
