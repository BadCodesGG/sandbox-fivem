export const initialState = {
	data: {
		character: null,
		accounts: Array(),
		transactions: Object(),
		loans: Array(),
		credit: null,
		character:
			process.env.NODE_ENV == 'production'
				? {}
				: {
						ID: '123',
						SID: 123,
						First: 'Big',
						Last: 'Pogs',
						Cash: 100000,
				  },
		accounts:
			process.env.NODE_ENV == 'production'
				? []
				: [
						{
							Name: '994094 994094 994094 994094 994094 994094',
							Account: 994094,
							Balance: 0,
							Type: 'personal',
							Owner: 25,
							Permissions: {
								MANAGE: true,
								BALANCE: true,
								TRANSACTIONS: true,
								DEPOSIT: true,
								WITHDRAW: true,
							},
						},
						{
							Name: '994095',
							Account: 994095,
							Balance: 5000,
							Type: 'personal_savings',
							Owner: 123,
							Permissions: {
								MANAGE: true,
								BALANCE: true,
								TRANSACTIONS: true,
								DEPOSIT: true,
								WITHDRAW: true,
							},
							JointOwners: [3],
						},
						{
							Name: '994095',
							Account: 994095,
							Balance: 5000,
							Type: 'personal_savings',
							Owner: 123,
							Permissions: {
								MANAGE: true,
								BALANCE: true,
								TRANSACTIONS: true,
								DEPOSIT: true,
								WITHDRAW: true,
							},
							JointOwners: [3],
						},
						{
							Name: '994095',
							Account: 994095,
							Balance: 5000,
							Type: 'personal_savings',
							Owner: 123,
							Permissions: {
								MANAGE: true,
								BALANCE: true,
								TRANSACTIONS: true,
								DEPOSIT: true,
								WITHDRAW: true,
							},
							JointOwners: [3],
						},
						{
							Name: '994095',
							Account: 994095,
							Balance: 5000,
							Type: 'personal_savings',
							Owner: 123,
							Permissions: {
								MANAGE: true,
								BALANCE: true,
								TRANSACTIONS: true,
								DEPOSIT: true,
								WITHDRAW: true,
							},
							JointOwners: [3],
						},
						{
							Name: '994095',
							Account: 994095,
							Balance: 5000,
							Type: 'personal_savings',
							Owner: 123,
							Permissions: {
								MANAGE: true,
								BALANCE: true,
								TRANSACTIONS: true,
								DEPOSIT: true,
								WITHDRAW: true,
							},
							JointOwners: [3],
						},
						{
							Name: '994095',
							Account: 994095,
							Balance: 5000,
							Type: 'personal_savings',
							Owner: 123,
							Permissions: {
								MANAGE: true,
								BALANCE: true,
								TRANSACTIONS: true,
								DEPOSIT: true,
								WITHDRAW: true,
							},
							JointOwners: [3],
						},
						{
							Name: '994095',
							Account: 994095,
							Balance: 5000,
							Type: 'personal_savings',
							Owner: 123,
							Permissions: {
								MANAGE: true,
								BALANCE: true,
								TRANSACTIONS: true,
								DEPOSIT: true,
								WITHDRAW: true,
							},
							JointOwners: [3],
						},
						{
							Name: '994095',
							Account: 994095,
							Balance: 5000,
							Type: 'personal_savings',
							Owner: 123,
							Permissions: {
								MANAGE: true,
								BALANCE: true,
								TRANSACTIONS: true,
								DEPOSIT: true,
								WITHDRAW: true,
							},
							JointOwners: [3],
						},
						{
							Name: '994095',
							Account: 994095,
							Balance: 5000,
							Type: 'personal_savings',
							Owner: 123,
							Permissions: {
								MANAGE: true,
								BALANCE: true,
								TRANSACTIONS: true,
								DEPOSIT: true,
								WITHDRAW: true,
							},
							JointOwners: [3],
						},
						{
							Name: '994095',
							Account: 994095,
							Balance: 5000,
							Type: 'personal_savings',
							Owner: 123,
							Permissions: {
								MANAGE: true,
								BALANCE: true,
								TRANSACTIONS: true,
								DEPOSIT: true,
								WITHDRAW: true,
							},
							JointOwners: [3],
						},
						{
							Name: '994095',
							Account: 994095,
							Balance: 5000,
							Type: 'personal_savings',
							Owner: 123,
							Permissions: {
								MANAGE: true,
								BALANCE: true,
								TRANSACTIONS: true,
								DEPOSIT: true,
								WITHDRAW: true,
							},
							JointOwners: [3],
						},
				  ],
		transactions:
			process.env.NODE_ENV == 'production'
				? {}
				: {
						994094: [
							{
								Amount: 100,
								Type: 'transfer',
								TransactionAccount: 796368,
								Title: 'Bank Transfer',
								Data: {
									character: 1,
								},
								Account: 100000,
								Timestamp: 1629722906,
								Description: 'Transfer from Account: 796368',
							},
							{
								Amount: 100,
								Type: 'withdraw',
								TransactionAccount: 796368,
								Title: 'Bank Transfer',
								Data: {
									character: 1,
								},
								Account: 100000,
								Timestamp: 1629722906,
								Description: 'Transfer from Account: 796368',
							},
							{
								Amount: 100,
								Type: 'deposit',
								TransactionAccount: 796368,
								Title: 'Bank Transfer',
								Data: {
									character: 1,
								},
								Account: 100000,
								Timestamp: 1629722906,
								Description: 'Transfer from Account: 796368',
							},
							{
								Amount: 100,
								Type: 'fine',
								TransactionAccount: 796368,
								Title: 'Bank Transfer',
								Data: {
									character: 1,
								},
								Account: 100000,
								Timestamp: 1629722906,
								Description: 'Transfer from Account: 796368',
							},
							{
								Amount: 100,
								Type: 'transfer',
								TransactionAccount: 796368,
								Title: 'Bank Transfer',
								Data: {
									character: 1,
								},
								Account: 100000,
								Timestamp: 1629722906,
								Description: 'Transfer from Account: 796368',
							},
							{
								Amount: 100,
								Type: 'withdraw',
								TransactionAccount: 796368,
								Title: 'Bank Transfer',
								Data: {
									character: 1,
								},
								Account: 100000,
								Timestamp: 1629722906,
								Description: 'Transfer from Account: 796368',
							},
							{
								Amount: 100,
								Type: 'deposit',
								TransactionAccount: 796368,
								Title: 'Bank Transfer',
								Data: {
									character: 1,
								},
								Account: 100000,
								Timestamp: 1629722906,
								Description: 'Transfer from Account: 796368',
							},
							{
								Amount: 100,
								Type: 'fine',
								TransactionAccount: 796368,
								Title: 'Bank Transfer',
								Data: {
									character: 1,
								},
								Account: 100000,
								Timestamp: 1629722906,
								Description: 'Transfer from Account: 796368',
							},
						],
				  },
	},
};

export default (state = initialState, action) => {
	switch (action.type) {
		case 'SET_DATA':
			return {
				...state,
				data: {
					...state.data,
					[action.payload.type]: action.payload.data,
				},
			};
		case 'RESET_DATA':
			return initialState;
		case 'ADD_DATA':
			return {
				...state,
				data: {
					...state.data,
					[action.payload.type]:
						state.data[action.payload.type] != null
							? Object.prototype.toString.call(
									state.data[action.payload.type],
							  ) == '[object Array]'
								? action.payload.first
									? [
											action.payload.data,
											...state.data[action.payload.type],
									  ]
									: [
											...state.data[action.payload.type],
											action.payload.data,
									  ]
								: action.payload.key
								? {
										...state.data[action.payload.type],
										[action.payload.key]:
											action.payload.data,
								  }
								: {
										...state.data[action.payload.type],
										...action.payload.data,
								  }
							: [action.payload.data],
				},
			};
		case 'UPDATE_DATA':
			return {
				...state,
				data: {
					...state.data,
					[action.payload.type]:
						Object.prototype.toString.call(
							state.data[action.payload.type],
						) == '[object Array]'
							? state.data[action.payload.type].map((data) =>
									data.Account == action.payload.id
										? { ...action.payload.data }
										: data,
							  )
							: (state.data[action.payload.type] = action.payload
									.key
									? {
											...state.data[action.payload.type],
											[action.payload.id]: {
												...state.data[
													action.payload.type
												][action.payload.id],
												[action.payload.key]:
													action.payload.data,
											},
									  }
									: {
											...state.data[action.payload.type],
											[action.payload.id]:
												action.payload.data,
									  }),
				},
			};
		case 'REMOVE_DATA':
			return {
				...state,
				data: {
					...state.data,
					[action.payload.type]:
						Object.prototype.toString.call(
							state.data[action.payload.type],
						) == '[object Array]'
							? state.data[action.payload.type].filter((data) => {
									return Object.prototype.toString.call(
										data,
									) == '[object Object]'
										? action.payload.key
											? data[action.payload.key] !=
											  action.payload.id
											: data.Account != action.payload.id
										: data != action.payload.id;
							  })
							: (state.data[action.payload.type] = Object.keys(
									state.data[action.payload.type],
							  ).reduce((result, key) => {
									if (key != action.payload.id) {
										result[key] =
											state.data[action.payload.type][
												key
											];
									}
									return result;
							  }, {})),
				},
			};
		default:
			return state;
	}
};
