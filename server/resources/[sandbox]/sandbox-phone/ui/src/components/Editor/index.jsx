import React, { useState } from 'react';
import { CKEditor } from '@ckeditor/ckeditor5-react';
import ClassicEditor from '@ckeditor/ckeditor5-build-classic';
import { makeStyles } from '@mui/styles';

const useStyles = makeStyles((theme) => ({
	editor: {
		marginTop: 10,

		'&': {
			'--ck-focus-ring': (app) =>
				`1px solid ${Boolean(app?.color) ? app.color : theme.palette.primary.main
				} !important`,
		},
	},
}));

export default ({
	name,
	value,
	onChange,
	placeholder = '<div></div>',
	appData = null,
}) => {
	const classes = useStyles(appData ?? {});

	const [ready, setReady] = useState(false);

	const onReady = () => {
		setReady(true);
	};

	const onEditorChange = (_, editor) => {
		if (!ready) return;
		let value = editor.getData();
		const reg = /src=\"data:image\/([a-zA-Z]*);base64,([^\"]*)\"/g
		onChange({ target: { name: name, value: value.replace(reg, "src=\"https://i.ibb.co/x1vt3YY/ph.webp\"") } });
	};

	const config = {
		placeholder,
		removePlugins: ['Title', 'MediaEmbedToolbar'],
		toolbar: [
			'heading',
			'|',
			'bold',
			'italic',
			'|',
			'bulletedList',
			'numberedList',
			'blockquote',
			'|',
			'link',
		],
	};

	return (
		<div className={classes.editor}>
			<CKEditor
				ignoreEmptyParagraph
				config={config}
				editor={ClassicEditor}
				data={value}
				onChange={onEditorChange}
				onReady={onReady}
			/>
		</div>
	);
};
