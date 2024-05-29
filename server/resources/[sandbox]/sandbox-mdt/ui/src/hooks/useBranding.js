export default (cJob, isAttorney) => {
	if (isAttorney && !cJob) {
		return {
			primary: 'Electronic Records System',
			secondary: 'San Andreas Department of Justice',
		};
	}

	switch (cJob?.Id) {
		case 'police':
			return {
				primary: cJob?.Workplace?.Name,
				secondary: 'Electronic Records System',
			};
		case 'prison':
			return {
				primary: 'San Andreas Department of Corrections',
				secondary: 'Electronic Records System',
			};
		case 'government':
			switch (cJob?.Workplace?.Id) {
				case 'doj':
					return {
						primary: 'San Andreas Department of Justice',
						secondary: 'Electronic Records System',
					};
				default:
					return {
						primary: 'State of San Andreas',
						secondary: 'Public Records Repository',
					};
			}
		case 'ems':
			return {
				primary: 'State of San Andreas Medical Services',
				secondary: 'Electronic Records System',
			};
		default:
			return {
				primary: 'State of San Andreas',
				secondary: 'Public Records Repository',
			};
	}
};
