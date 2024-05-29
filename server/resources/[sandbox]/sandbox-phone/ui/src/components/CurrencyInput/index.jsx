import React from 'react';
import { NumericFormat } from 'react-number-format';

export default (props) => {
	const { inputRef, onChange, ...other } = props;

	return (
		<NumericFormat
			{...other}
			getInputRef={inputRef}
			onValueChange={(values) => {
				onChange({
					target: {
						name: props.name,
						value: values.floatValue,
					},
				});
			}}
			thousandSeparator
			isNumericString
			prefix="$"
		/>
	);
};
