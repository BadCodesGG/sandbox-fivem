const uuid = require("uuid");
const mdtAlerts = io.of("/mdt-alerts");

let MDT = null;
let EmergencyAlerts = null;

const alertGroupStyles = {
  police_alerts: 1,
  ems_alerts: 2,
  tow_alerts: 3,
};

const defaultTypes = {
  police: "car",
  ems: "bus",
  tow: "truck-tow",
  prison: "car",
};

const logColors = {
  ems: "#2b0215",
  prison: "#52c7b8",
};

const jobNames = {
  police: "PD",
  ems: "EMS",
  prison: "DOC",
};

const typeNames = {
  car: "Ground",
  motorcycle: "Motorcycle",
  air1: "Air",
  bus: "Ambo",
  lifeflight: "Life Flight",
  heat: "Heat",
};

AddEventHandler("Database:Shared:DependencyUpdate", RetrieveComponents);

function RetrieveComponents() {
  MDT = exports["sandbox-base"].FetchComponent("MDT");
  EmergencyAlerts = exports["sandbox-base"].FetchComponent("EmergencyAlerts");
}

AddEventHandler("Core:Shared:Ready", () => {
  exports["sandbox-base"].RequestDependencies(
    "WebSockets",
    ["MDT", "EmergencyAlerts"],
    (error) => {
      if (error.length > 0) return;
      RetrieveComponents();
    }
  );
});

let units = {
  police: [
    // {
    //   source: 2,
    //   job: "police",
    //   primary: "102",
    //   type: "car",
    //   character: {
    //     First: "Robert",
    //     Last: "Johnson",
    //     SID: 2,
    //     Phone: "!!!",
    //   },
    //   operatingUnder: null,
    // },
    // {
    //   source: 3,
    //   job: "police",
    //   primary: "103",
    //   type: "car",
    //   character: {
    //     First: "Cunt",
    //     Last: "Face",
    //     SID: 3,
    //     Phone: "!!!",
    //   },
    //   operatingUnder: "101",
    // },
  ],
  ems: Array(),
  prison: Array(),
  tow: Array(),
};

let alerts = [];
let radioNames = [
  {
    radio: "1",
    text: "EMS",
  },
  {
    radio: "2",
    text: "DOC",
  },
  {
    radio: "3",
    text: "PD #1",
  },
];
let dispatchLog = Array();

let alertShit = {};

function addDispatchLog(type, title, message, color) {
  if (dispatchLog.length > 50) {
    dispatchLog.shift();
  }

  const log = {
    time: Date.now(),
    type,
    title,
    message,
    color,
  };

  dispatchLog.push(log);
  mdtAlerts.emit("dispatchLog", log);
}

mdtAlerts.on("connection", (socket) => {
  const token = socket?.handshake?.query?.token;
  if (token) {
    const tData = verifySocketToken("mdt-alerts", token);
    if (tData && tData.source && tData.job && tData.callsign) {
      if (
        units[tData.job] &&
        units[tData.job].find((u) => u.source === tData.source)
      ) {
        units[tData.job] = units[tData.job].filter(
          (unit) => unit.source !== tData.source
        );
        mdtAlerts.emit("unitRemove", tData.job, tData.source);
      }

      socket.data.source = tData.source;
      socket.data.job = tData.job;
      socket.data.callsign = tData.callsign;

      const playerData = EmergencyAlerts.GetUnitData(
        EmergencyAlerts,
        tData.source,
        tData.job
      );

      let character = playerData?.character;

      if (tData.development) {
        character = {
          First: "Test",
          Last: "Data",
          SID: 1,
          Phone: "###-###-####",
        };
      }

      socket.data.name = `${character?.First?.[0]}. ${character?.Last}`;

      const newUnit = {
        source: socket.data.source,
        job: socket.data.job,
        primary: socket.data.callsign,
        available: true,
        type: defaultTypes[tData.job],
        character: character,
        operatingUnder: null,
        pursuitMode: null,
        radioChannel: null,
      };

      units[socket.data.job].push(newUnit);

      socket.emit(
        "init",
        tData,
        alerts.filter((alert) => {
          return (
            tData.development ||
            (typeof alert.type === "string" &&
              playerData.alerts.includes(alert.type)) ||
            (typeof alert.type === "object" &&
              alert.type.some((t) => playerData.alerts.includes(t)) &&
              (alert.time >= Date.now() - 900000 || alert.attached.length > 0))
          );
        }),
        units,
        newUnit,
        radioNames,
        dispatchLog
      );

      socket.broadcast.emit("unitAdd", newUnit);

      if (tData.development) {
        socket.join("police_alerts");
      } else {
        socket.join(playerData.alerts);
      }

      socket.on("disconnect", () => {
        units[socket.data.job] = units[socket.data.job].filter(
          (unit) => unit.source !== socket.data.source
        );

        units[socket.data.job] = units[socket.data.job].map((u) => {
          if (u.operatingUnder == socket.data.callsign) {
            mdtAlerts.emit("unitUpdateData", {
              job: u.job,
              primary: u.primary,
              key: "operatingUnder",
              value: null,
            });
            return {
              ...u,
              operatingUnder: null,
            };
          } else {
            return u;
          }
        });

        mdtAlerts.emit("unitRemove", socket.data.job, socket.data.source);
      });

      socket.on("changeUnit", (job, primary, type) => {
        try {
          const unitIndex = units[job].findIndex((u) => u.primary === primary);
          if (unitIndex > -1) {
            units[job][unitIndex].type = type;

            mdtAlerts.emit("unitUpdateData", {
              job,
              primary,
              key: "type",
              value: type,
            });

            addDispatchLog(
              "unitChange",
              null,
              `${primary} Transitioning to ${typeNames[type]} Unit`,
              logColors[job]
            );
          }
        } catch (e) {}
      });

      socket.on("changeAvailability", (job, primary) => {
        try {
          const unitIndex = units[job].findIndex((u) => u.primary === primary);
          if (unitIndex > -1) {
            units[job][unitIndex].available = !units[job][unitIndex].available;

            mdtAlerts.emit("unitUpdateData", {
              job,
              primary,
              key: "available",
              value: units[job][unitIndex].available,
            });

            if (units[job][unitIndex].available) {
              addDispatchLog(
                "availabilityChange",
                null,
                `${primary} is now 10-8 (Available)`,
                logColors[job]
              );
            } else {
              addDispatchLog(
                "availabilityChange",
                null,
                `${primary} is now 10-6 (Unavailable)`,
                logColors[job]
              );
            }
          }
        } catch (e) {}
      });

      socket.on("operateUnderUnit", (job, primary, unit) => {
        try {
          const unitIndex = units[job].findIndex((u) => u.primary === unit);
          if (unitIndex > -1) {
            units[job][unitIndex].operatingUnder = primary;

            mdtAlerts.emit("unitOperateUnder", job, unit, primary);

            addDispatchLog(
              "subUnitChanges",
              null,
              `${unit} Now Operating Under ${primary}`,
              logColors[job]
            );
          }
        } catch (e) {}
      });

      socket.on("breakOffUnit", (job, primary, unit) => {
        try {
          const unitIndex = units[job].findIndex((u) => u.primary === unit);
          if (unitIndex > -1) {
            units[job][unitIndex].operatingUnder = null;

            mdtAlerts.emit("unitBreakOff", job, unit);

            addDispatchLog(
              "subUnitChanges",
              null,
              `${unit} Breaking Off From ${primary}`,
              logColors[job]
            );
          }
        } catch (e) {}
      });

      socket.on("changeRadioChannel", (channel) => {
        try {
          const unitIndex = units[socket.data.job].findIndex(
            (u) => u.primary === socket.data.callsign
          );
          if (unitIndex > -1) {
            units[socket.data.job][unitIndex].radioChannel = channel;

            mdtAlerts.emit("unitUpdateData", {
              job: socket.data.job,
              primary: socket.data.callsign,
              key: "radioChannel",
              value: channel,
            });
          }
        } catch (e) {}
      });

      socket.on("changePursuitMode", (job, primary, pursuitMode) => {
        try {
          const unitIndex = units[job].findIndex((u) => u.primary === primary);
          if (unitIndex > -1) {
            units[job][unitIndex].pursuitMode = pursuitMode;

            mdtAlerts.emit("unitUpdateData", {
              job,
              primary,
              key: "pursuitMode",
              value: pursuitMode,
            });
          }
        } catch (e) {}
      });

      socket.on("updateAlertUnits", (alertId, units) => {
        try {
          const alertIndex = alerts.findIndex((a) => a.id === alertId);
          if (alertIndex > -1 && units.length >= 0) {
            alerts[alertIndex].attached = [...new Set(units)];

            mdtAlerts.emit(
              "alertUpdateUnits",
              alertId,
              alerts[alertIndex].attached
            );

            alerts[alertIndex].attached.forEach((att) => {
              if (!alertShit[alertId][att]) {
                alertShit[alertId][att] = true;
                addDispatchLog(
                  "attaching",
                  null,
                  `${att} Attached to ${alerts[alertIndex].code} | ${alerts[alertIndex].title}`,
                  "#5D348B"
                );
              }
            });

            Object.keys(alertShit[alertId]).forEach((att) => {
              if (
                alertShit[alertId][att] &&
                !alerts[alertIndex].attached.includes(att)
              ) {
                alertShit[alertId][att] = false;
                addDispatchLog(
                  "attaching",
                  null,
                  `${att} Detached From ${alerts[alertIndex].code} | ${alerts[alertIndex].title}`,
                  "#5D348B"
                );
              }
            });
          }
        } catch (e) {}
      });

      socket.on("addRadioInfo", (data) => {
        radioNames.push(data);
        mdtAlerts.emit("radioInfoUpdate", radioNames);

        addDispatchLog(
          "radioUpdate",
          null,
          `Radio Added: ${data.radio} | ${data.text}`,
          "#6e6e6e"
        );
      });

      socket.on("updateRadioInfo", (id, data) => {
        radioNames = radioNames.map((m, k) => {
          if (k === id && m.radio === data.radio) {
            m.text = data.text;
            return m;
          } else {
            return m;
          }
        });

        mdtAlerts.emit("radioInfoUpdate", radioNames);
      });

      socket.on("removeRadioInfo", (id, data) => {
        radioNames = radioNames.filter((m, k) => {
          return !(k === id && m.radio === data.radio);
        });

        mdtAlerts.emit("radioInfoUpdate", radioNames);

        addDispatchLog(
          "radioUpdate",
          null,
          `Radio Removed: ${data.radio}`,
          "#6e6e6e"
        );
      });

      socket.on("logMessage", (message) => {
        addDispatchLog(
          "message",
          `${jobNames[socket.data.job]} Message | [${socket.data.callsign}] ${
            socket.data.name
          }`,
          message,
          logColors[socket.data.job]
        );
      });

      socket.on("removeAlert", (alertId) => {
        alerts = alerts.filter((alert) => alert.id !== alertId);
        mdtAlerts.emit("alertRemove", alertId);
      });

      return;
    }
  }

  socket.disconnect(true);
});

on(
  "ws:mdt-alerts:createAlert",
  (
    code,
    title,
    alertGroup, // string or array of strings [police_alerts, ems_alerts]
    location, // { street1: string, x: int, y: int, z: int }
    description, // { icon: string, details: string }
    isPanic, // boolean
    blip, // { size, icon, duration, color }
    styleOverride,
    isArea,
    camera
  ) => {
    let style = null;

    if (styleOverride) {
      style = styleOverride;
    } else if (typeof alertGroup === "string" && alertGroupStyles[alertGroup]) {
      style = alertGroupStyles[alertGroup];
    }

    const alert = {
      id: uuid.v4(),
      code,
      title,
      type: alertGroup,
      location,
      description,
      panic: isPanic,
      blip,
      style,
      isArea,
      camera,
      attached: Array(),
      time: Date.now(),
    };

    alertShit[alert.id] = {};

    if (alert.length > 50) {
      alerts.splice();
    }

    alerts.push(alert);
    mdtAlerts.to(alertGroup).emit("alert", alert);
  }
);

on("ws:mdt-alerts:addDispatchLog", (type, title, message, color, jobColor) => {
  addDispatchLog(type, title, message, jobColor ? logColors[jobColor] : color);
});
