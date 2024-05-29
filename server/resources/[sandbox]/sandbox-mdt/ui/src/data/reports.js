export const ReportTypes = [
	{
		label: 'Incident Report',
		short: 'Incident',
		value: 0,
		requiredViewPermission: 'MDT_INCIDENT_REPORT_VIEW', // Req. Permission to View
		requiredCreatePermission: 'MDT_INCIDENT_REPORT_CREATE', // Req. Permission to Create
		hasEvidence: true,
		allowAttorney: true,
	},
	{
		label: 'Investigative Report',
		short: 'Investigation',
		value: 1,
		requiredViewPermission: 'MDT_INVESTIGATIVE_REPORT_VIEW',
		requiredCreatePermission: 'MDT_INVESTIGATIVE_REPORT_CREATE',
		hasEvidence: true,
		allowAttorney: true,
	},
	{
		label: 'Civilian Report',
		short: 'Civ. Report',
		value: 2,
		requiredViewPermission: 'MDT_CIVILIAN_REPORT_VIEW',
		requiredCreatePermission: 'MDT_CIVILIAN_REPORT_CREATE',
		hasEvidence: true,
		allowAttorney: true,
	},
	{
		label: 'PD Field Training Reports',
		short: 'PD FTO',
		value: 3,
		requiredViewPermission: 'MDT_POLICE_FTO_REPORTS',
		requiredCreatePermission: 'MDT_POLICE_FTO_REPORTS',
	},
	{
		label: 'PD Disciplinary Reports',
		short: 'Disciplinary',
		value: 4,
		requiredViewPermission: 'MDT_POLICE_DISCIPLINARY_REPORTS',
		requiredCreatePermission: 'MDT_POLICE_DISCIPLINARY_REPORTS',
	},
	{
		label: 'PD Command Documents',
		short: 'PD Command',
		value: 5,
		requiredViewPermission: 'PD_COMMAND',
		requiredCreatePermission: 'PD_COMMAND',
	},
	{
		label: 'PD High Command Documents',
		short: 'PD HC',
		value: 6,
		requiredViewPermission: 'PD_HIGH_COMMAND',
		requiredCreatePermission: 'PD_HIGH_COMMAND',
	},
	{
		label: 'Medical Report',
		short: 'Medical',
		value: 10,
		requiredCreatePermission: 'MDT_MEDICAL_REPORTS', // Req. Permission to Create
		requiredViewPermission: 'MDT_MEDICAL_REPORTS',
		officerName: 'Medic',
		officerType: 'ems',
	},
	{
		label: 'EMS Documents',
		short: 'EMS Docs',
		value: 11,
		requiredCreatePermission: 'MDT_MEDICAL_REPORTS', // Req. Permission to Create
		requiredViewPermission: 'MDT_MEDICAL_REPORTS',
		officerName: 'Medic',
		officerType: 'ems',
	},
	{
		label: 'EMS HC Documents',
		short: 'EMS HC',
		value: 12,
		requiredCreatePermission: 'SAFD_HIGH_COMMAND', // Req. Permission to Create
		requiredViewPermission: 'SAFD_HIGH_COMMAND',
		officerName: 'Medic',
		officerType: 'ems',
	},
	{
		label: 'Trial Findings (Public)',
		short: 'Trial',
		value: 20,
		requiredCreatePermission: 'DOJ_TRIAL_FINDINGS_CREATE', // Req. Permission to Create
		officerName: 'Judges',
		officerType: 'government',
	},
	{
		label: 'Judge Private Documents',
		short: 'DOJ Judge',
		value: 21,
		requiredViewPermission: 'MDT_JUDGE_REPORTS',
		requiredCreatePermission: 'MDT_JUDGE_REPORTS', // Req. Permission to Create
		officerName: 'Judges',
		officerType: 'government',
	},
	{
		label: 'DOJ Documents',
		short: 'DOJ',
		value: 22,
		requiredViewPermission: 'DOJ_DOCUMENTS_VIEW',
		requiredCreatePermission: 'DOJ_DOCUMENTS_CREATE', // Req. Permission to Create
		officerName: 'Judges',
		officerType: 'government',
		allowAttorney: true,
	},
	{
		label: "DA's Office Reports",
		short: 'DA',
		value: 25,
		requiredViewPermission: 'MDT_DA_REPORTS',
		requiredCreatePermission: 'MDT_DA_REPORTS', // Req. Permission to Create
		officerName: 'Prosecutors',
		officerType: 'government',
	},
	{
		label: 'Pub. Defender Reports',
		short: 'Pub. Defender',
		value: 26,
		requiredViewPermission: 'MDT_PUBDEFENDER_REPORTS',
		requiredCreatePermission: 'MDT_PUBDEFENDER_REPORTS', // Req. Permission to Create
		officerName: 'Public Defenders',
		officerType: 'government',
	},
	{
		label: 'DOC Reports',
		short: 'DOC Reports',
		value: 30,
		requiredViewPermission: 'DOC_REPORTS_VIEW',
		requiredCreatePermission: 'DOC_REPORTS_CREATE', // Req. Permission to Create
		officerName: 'Officer',
		officerType: 'prison',
		hasEvidence: true,
	},
	{
		label: 'DOC Documents',
		short: 'DOC Documents',
		value: 31,
		requiredViewPermission: 'DOC_DOCUMENTS_VIEW',
		requiredCreatePermission: 'DOC_DOCUMENTS_CREATE', // Req. Permission to Create
		officerName: 'Officer',
		officerType: 'prison',
	},
];

export const GetOfficerNameFromReportType = (reportType) => {
	return ReportTypes.find((r) => r.value == reportType)?.officerName ?? 'Officers';
};

export const GetOfficerJobFromReportType = (reportType) => {
	return ReportTypes.find((r) => r.value == reportType)?.officerType ?? 'police';
};
