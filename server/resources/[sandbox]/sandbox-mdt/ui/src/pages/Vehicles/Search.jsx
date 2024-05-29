import React, { useEffect, useMemo, useState } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import {
	TextField,
	InputAdornment,
	IconButton,
	Pagination,
	List,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import { throttle } from 'lodash';
import qs from 'qs';

import Nui from '../../util/Nui';
import { usePerPage } from '../../hooks';
import { Loader } from '../../components';
import Item from './components/Vehicle';
import { useNavigate, useLocation } from 'react-router';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { Vehicle } from '../testdata';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		display: 'flex',
		flexDirection: 'column',
		padding: '10px 5px 10px 5px',
		height: '100%',
	},
	search: {

	},
	results: {
		flexGrow: 1,
	},
	items: {
		maxHeight: '95%',
		height: '95%',
		overflowY: 'auto',
		overflowX: 'hidden',
	},
	noResults: {
		margin: '15% 0',
		textAlign: 'center',
		fontSize: 22,
		color: theme.palette.text.main,
	},
}));

export default (props) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const history = useNavigate();
	const location = useLocation();
	const getPerPage = usePerPage();
	const type = 'vehicle';
	const searchTerm = useSelector((state) => state.search.searchTerms[type]);
	let qry = qs.parse(location.search.slice(1));

	const [searched, setSearched] = useState(null);
	const [pages, setPages] = useState(1);
	const [page, setPage] = useState(1);
	const [loading, setLoading] = useState(false);
	const [err, setErr] = useState(false);
	const [results, setResults] = useState(Array());

	useEffect(() => {
		if (qry.search) {
			dispatch({
				type: 'UPDATE_SEARCH_TERM',
				payload: {
					type: type,
					term: qry.search,
				},
			});
			setSearched(qry.search);
			fetch(qry.search, 1, true);
		}
	}, []);

	const fetch = useMemo(
		() =>
			throttle(async (value, page, initial) => {
				let s = qs.parse(location.search.slice(1));
				s.search = value;
				history({
					path: location.pathname,
					search: qs.stringify(s),
				});
				setLoading(true);

				try {
					let res = await (
						await Nui.send('Search', {
							type: type,
							term: value,
							page: page ?? 1,
							initial: initial,
							perPage: getPerPage(),
						})
					).json();

					if (res?.data) {
						if (res?.total) {
							setPages(Math.ceil(res.total / getPerPage()));
						}

						setResults(res.data);
					} else {
						setErr(true);
					}

					setLoading(false);
				} catch (err) {
					console.log(err);
					if (process.env.NODE_ENV != 'production') {
						setResults(Vehicle)
					} else {
						setErr(true);
					}
					setLoading(false);
				}
			}, 1000),
		[],
	);

	const onSubmit = (e) => {
		e.preventDefault();
		if (searched == searchTerm) return;
		setSearched(searchTerm);
		if (searchTerm == '') {
			let s = qs.parse(location.search.slice(1));
			delete s.search;
			history({
				path: location.pathname,
				search: qs.stringify(s),
			});
			dispatch({
				type: 'CLEAR_SEARCH',
				payload: { type },
			});
		} else {
			fetch(searchTerm, 1, true);
		}
	};

	const onSearchChange = (e) => {
		dispatch({
			type: 'UPDATE_SEARCH_TERM',
			payload: {
				type: type,
				term: e.target.value,
			},
		});
	};

	const onClear = () => {
		let s = qs.parse(location.search.slice(1));
		delete s.search;
		history({
			path: location.pathname,
			search: qs.stringify(s),
		});
		dispatch({
			type: 'CLEAR_SEARCH',
			payload: { type },
		});
	};

	const onPagi = (e, p) => {
		setPage(p);
		fetch(searchTerm, p, false);
	};

	return (
		<div className={classes.wrapper}>
			<div className={classes.search}>
				<form autoComplete="off" onSubmit={onSubmit}>
					<TextField
						fullWidth
						variant="standard"
						name="search"
						value={searchTerm}
						onChange={onSearchChange}
						error={err}
						helperText={err ? 'Error Performing Search' : null}
						label="Search By Plate or VIN or Owner State ID (IF Prefixed with SID: e.g. SID: 100)"
						InputProps={{
							endAdornment: (
								<InputAdornment position="end">
									{searchTerm != '' && (
										<IconButton
											type="button"
											size="small"
											onClick={onClear}
										>
											<FontAwesomeIcon
												icon={['fas', 'xmark']}
											/>
										</IconButton>
									)}
									<IconButton
										type="submit"
										size="small"
										disabled={
											searchTerm == '' ||
											searched == searchTerm
										}
									>
										<FontAwesomeIcon
											icon={['fas', 'magnifying-glass']}
										/>
									</IconButton>
								</InputAdornment>
							),
						}}
					/>
				</form>
			</div>
			<div className={classes.results}>
				{loading ? (
					<Loader text="Loading" />
				) : results?.length > 0 ? (
					<>
						<List className={classes.items}>
							{results
								.map((result) => {
									return (
										<Item
											key={result.VIN}
											vehicle={result}
										/>
									);
								})}
						</List>
						{pages > 1 && (
							<Pagination
								variant="outlined"
								shape="rounded"
								color="primary"
								page={page}
								count={pages}
								onChange={onPagi}
							/>
						)}
					</>
				) : (
					<p className={classes.noResults}>No Vehicles Found</p>
				)}
			</div>
		</div>
	);
};
