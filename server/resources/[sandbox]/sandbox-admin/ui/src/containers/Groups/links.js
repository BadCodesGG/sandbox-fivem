export default (type) => {
  switch (type) {
    case "dev":
    case "management":
      return admin;
    default:
      return staff;
  }
};

const staff = [
  {
    name: "home",
    icon: ["fas", "house"],
    label: "Dashboard",
    path: "/",
    exact: true,
  },
  {
    name: "players",
    icon: ["fas", "user-large"],
    label: "Players",
    path: "/players",
    exact: true,
  },
  {
    name: "disconnected-players",
    icon: ["fas", "user-large-slash"],
    label: "Disconnected Players",
    path: "/disconnected-players",
    exact: true,
  },
  {
    name: "characters",
    icon: ["fas", "people"],
    label: "Find Characters",
    path: "/players-characters",
    exact: true,
  },
  // {
  // 	name: 'current-vehicle',
  // 	icon: ['fas', 'car-side'],
  // 	label: 'Current Vehicle',
  // 	path: '/current-vehicle',
  // 	exact:  true,
  // }
];

const admin = [
  {
    name: "home",
    icon: ["fas", "house"],
    label: "Dashboard",
    path: "/",
    exact: true,
  },
  {
    name: "players",
    icon: ["fas", "user-large"],
    label: "Online Players",
    path: "/players",
    exact: true,
  },
  {
    name: "disconnected-players",
    icon: ["fas", "user-large-slash"],
    label: "Disconnected Players",
    path: "/disconnected-players",
    exact: true,
  },
  {
    name: "characters",
    icon: ["fas", "people"],
    label: "Find Characters",
    path: "/players-characters",
    exact: true,
  },
  {
    name: "vehicles",
    icon: ["fas", "car"],
    label: "Active Owned Vehicles",
    path: "/vehicles",
    exact: true,
  },
  {
    name: "current-vehicle",
    icon: ["fas", "car-side"],
    label: "Current Vehicle",
    path: "/current-vehicle",
    exact: true,
  },
];
