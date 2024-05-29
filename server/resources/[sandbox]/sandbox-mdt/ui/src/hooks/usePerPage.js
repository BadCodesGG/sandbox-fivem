import useMediaQuery from '@mui/material/useMediaQuery';

export default () => {
	const is1080h = useMediaQuery('(min-height:1080px)');
	const is1440h = useMediaQuery('(min-height:1440px)');
	const is2160h = useMediaQuery('(min-height:2160px)');

	return () => {
		if (is2160h) {
			return 20;
		} else if (is1440h) {
			return 12;
		} else if (is1080h) {
			return 6;
		} else {
			return 3;
		}
	};
};
