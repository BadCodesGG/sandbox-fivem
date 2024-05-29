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
import Item from './components/Warrant';
import { useNavigate, useLocation } from 'react-router';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

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
	form: {},
	formControl: {},
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
	const type = 'warrant';
	const searchTerm = useSelector((state) => state.search.searchTerms[type]);
	let qry = qs.parse(location.search.slice(1));

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
			fetch(qry.search);
		} else fetch(searchTerm, 1, 1);
	}, []);

	const fetch = useMemo(() => throttle(async (value, page, currentPages) => {
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
					perPage: getPerPage(),
				})
			).json();
			if (res?.data) {
				// Only update pages if not going backwards
				if (res?.pages && res.pages > currentPages) {
					setPages(Math.ceil(res.pages));
				};
				setResults(res.data);
			} else throw res;

			setLoading(false);
		} catch (err) {
			console.log(err);
			if (process.env.NODE_ENV != 'production') {
				setResults([
					{
						id: 2,
						state: "active",
						title: "Warrant for Bob Bobson (2)",
						suspect: 222, // Suspect ID (Not SID)
						creatorSID: 1,
						creatorName: "Bob Bobson",
						creatorCallsign: "101",
						report: 1,
						expires: Date.now() + 120000,
						notes: "bla bla bla",
					}
				])
			} else {
				setErr(true);
			}
			setLoading(false);
		}
	}, 1000), []);

	const onSubmit = (e) => {
		e.preventDefault();
		setPage(1);
		setPages(1);
		fetch(searchTerm, 1, 1);
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

		fetch(searchTerm, p, pages);
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
						label="Search Suspect Name or Warrant Number"
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
											key={result.id}
											warrant={result}
										/>
									);
								})}
						</List>
					</>
				) : <p className={classes.noResults}>No Results Found</p>}
			</div>
			{pages > 1 && <div>
				<Pagination
					variant="outlined"
					shape="rounded"
					color="primary"
					page={page}
					count={pages}
					onChange={onPagi}
				/>
			</div>}
		</div>
	);
};
