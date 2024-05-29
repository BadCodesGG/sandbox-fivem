const crypto = require("crypto");
const socket = require("socket.io");
const jwt = require("jsonwebtoken");
const path = require("path");

const fs = require("fs");
const https = require("https");

const conv = GetConvar("WS_MDT_ALERTS", "http://localhost:4002");
const printDevToken = GetConvar("WS_PRINT_TOKEN", "false");

const httpsServer = https.createServer({
  key: fs.readFileSync(
    path.join(GetResourcePath(GetCurrentResourceName()), "privkey.pem")
  ),
  cert: fs.readFileSync(
    path.join(GetResourcePath(GetCurrentResourceName()), "cert.pem")
  ),
});

const io = new socket.Server(conv.includes("https") ? httpsServer : 4002, {
  cors: {
    origin: "http://localhost:8080",
    methods: ["GET", "POST"],
    credentials: true,
  },
});

if (conv.includes("https")) {
  httpsServer.listen(4002);
}

io.on("connection", (socket) => {
  socket.disconnect();
});

let privateSigningKey = null;

crypto.generateKeyPair(
  "rsa",
  {
    modulusLength: 4096,
    publicKeyEncoding: {
      type: "spki",
      format: "pem",
    },
    privateKeyEncoding: {
      type: "pkcs8",
      format: "pem",
    },
  },
  (err, _, privateKey) => {
    if (err) {
      console.log("WS: Failed to Generate Private Signing Key");
    } else {
      privateSigningKey = privateKey;
    }
  }
);

function generateSocketToken(namespace, data) {
  if (!privateSigningKey) return false;

  // TODO: Add Override Flag
  if (GlobalState.IsProduction) {
    const token = jwt.sign(
      {
        namespace,
        ...data,
      },
      privateSigningKey,
      { algorithm: "RS256", expiresIn: "1h" }
    );

    return token;
  } else {
    const token = jwt.sign(
      {
        namespace,
        ...data,
      },
      "dev-testing-qi5%z%#dku4$bm**i9ie"
    );

    return token;
  }
}

function verifySocketToken(namespace, token) {
  if (GlobalState.IsProduction) {
    try {
      const res = jwt.verify(token, privateSigningKey, {});

      if (res && res?.namespace === namespace) {
        return res;
      }
    } catch (e) {}
  } else {
    try {
      const res = jwt.verify(token, "dev-testing-qi5%z%#dku4$bm**i9ie", {});

      if (res && res?.namespace === namespace) {
        return res;
      }
    } catch (e) {}
  }
}

exports("emitServer", (namespace, event, ...data) => {
  io.of(namespace).serverSideEmit(event, ...data);
});

exports("emit", (namespace, event, ...data) => {
  io.of(namespace).emit(event, ...data);
});

exports("generateSocketToken", generateSocketToken);

on("Core:Shared:Ready", () => {
  setTimeout(() => {
    const token = generateSocketToken("mdt-alerts", {
      source: 99,
      job: "police",
      callsign: "101",
      development: true,
    });

    if (printDevToken) {
      console.log("WebSocket Dev Token (Source 99): ", token);
    }

    console.log(
      `WebSocket Server Listening On: 4002 (${
        conv.includes("https") ? "HTTPS" : "HTTP"
      }) Sending URL: ${conv}`
    );
  }, 10000);
});
