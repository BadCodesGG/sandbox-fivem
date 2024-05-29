import { TextField } from '@mui/material';
import { withStyles } from '@mui/styles';

export default withStyles((theme) => ({
	root: {
		'& label.Mui-focused': {
			color: ({ app }) => app?.color ?? 'inherit',
		},
		'& .MuiInput-underline:after': {
			borderBottomColor: ({ app }) => app?.color ?? 'inherit',
		},
		'& .MuiOutlinedInput-root': {
			'& fieldset': {
				borderColor: 'white',
			},
			'&:hover fieldset': {
				borderColor: 'white',
			},
			'&.Mui-focused fieldset': {
				borderColor: ({ app }) => app?.color ?? 'inherit',
			},
		},
	},
}))(TextField);
