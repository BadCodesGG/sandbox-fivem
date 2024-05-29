import Nui from '../../util/Nui';

export const createContact = (contact) => (dispatch) => {
	Nui.send('CreateContact', contact).then(async (res) => {
		if (res != null) {
			dispatch({
				type: 'ADD_DATA',
				payload: {
					type: 'contacts',
					data: {
						...contact,
						id: await res.json(),
					},
				},
			});
		} else {
			// Things?
		}
	});
};

export const updateContact = (id, contact) => (dispatch) => {
	Nui.send('UpdateContact', {
		...contact,
		id: id,
	}).then((res) => {
		if (res) {
			dispatch({
				type: 'UPDATE_DATA',
				payload: { type: 'contacts', id: id, data: contact },
			});
		} else {
			// Things?
		}
	});
};

export const deleteContact = (id) => (dispatch) => {
	Nui.send('DeleteContact', id).then((res) => {
		if (res) {
			dispatch({
				type: 'REMOVE_DATA',
				payload: { type: 'contacts', id: id },
			});
		} else {
			// Things?
		}
	});
};
