const express = require("express");
const Database = require("./sql_db_man.js");
const vehicleMakes = require("./VehicleMakes.json");
const PORT = 3000;
const app = express();
let messageJson = { message: "Hello world" };

const API_URL = "https://www.carboninterface.com/api/v1";
const API_KEY = "5p3VT63zAweQ6X3j8OQriw";

const dbconfig = {
  host: "mcs.drury.edu",
  port: "3306",
  user: "emission",
  password: "Letmein!eCoders",
  database: "emission",
};
const db = new Database(dbconfig);
db.connect();

app.use(express.json());
app.get("/message", (request, response) => {
  response.send(messageJson);
});

app.post("/insertUser", (request, response) => {
  // insert user
  console.log("Insertting Users");
  console.log(request.body);

  const userData = request.body;
  userData.profilePicture =
    userData.profilePicture === null ? 0 : userData.profilePicture;
  const insertQuery =
    "INSERT INTO Users (email, username, password, profilePicture, levelStatus, displayName) VALUES (?, ?, ?, ?, ?, ?)";
  const values = [
    userData.email,
    userData.username,
    userData.password,
    0,
    0,
    userData.displayName,
  ];

  db.query(insertQuery, values, (err, results) => {
    if (err) {
      console.error("Error executing query:", err);
    } else {
      console.log("Query results:", results);
    }
  });
  //db.disconnect();
});

app.get("/makes", (req, res) => {
  res.json(vehicleMakes);
});

app.get("/models", (req, res) => {
  const { makeId } = req.query;

  if (!makeId) return res.status(400).json({ error: "Must provide make ID." });

  return res.json([
    {
      data: {
        id: "7268a9b7-17e8-4c8d-acca-57059252afe9",
        type: "vehicle_model",
        attributes: {
          name: "Corolla",
          year: 1993,
          vehicle_make: "Toyota",
        },
      },
    },
    {
      data: {
        id: "7268a9b7-17e8-4c8d-acca-57059252afe9",
        type: "vehicle_model",
        attributes: {
          name: "Corolla",
          year: 1994,
          vehicle_make: "Toyota",
        },
      },
    },
    {
      data: {
        id: "a2d97d19-14c0-4c60-870c-e734796e014e",
        type: "vehicle_model",
        attributes: {
          name: "Camry",
          year: 1993,
          vehicle_make: "Toyota",
        },
      },
    },
    {
      data: {
        id: "14949244-b6d1-4a11-970f-73f75408f931",
        type: "vehicle_model",
        attributes: {
          name: "Corolla Wagon",
          year: 1993,
          vehicle_make: "Toyota",
        },
      },
    },
  ]);

  fetch({
    url: `${API_URL}/vehicle_make/${makeId}/vehicle_models`,
    method: "POST",
    headers: {
      Authorization: `Bearer ${API_KEY}`,
      "Content-Type": "application/json",
    },
    body: {
      type: "vehicle",
      distance_unit: "mi",
      distance_value: distance,
      vehicle_model_id: vehicleId,
    },
  })
    .then((apiRes) => {
      if (res.ok) {
        res.json(apiRes.json());
      } else {
        res.status(500).json({ error: "Server error." });
      }
    })
    .catch((err) => res.status(500).json({ error: err }));
});

const getVehicleSql =
  "SELECT make, model, year, carID, carName, modelID FROM Cars WHERE owner = ?;";

app.get("/vehicles", (req, res) => {
  const { owner } = req.query;

  db.query(getVehicleSql, [owner], (err, results) => {
    if (err) {
      res.status(500).json({ error: "Server error." });
    } else {
      res.status(200).json(results);
    }
  });
});

const insertVehicleSql =
  "INSERT INTO Cars (owner, carName, make, model, year, makeID, modelID, currentMileage) VALUES (?, ?, ?, ?, ?, ?, ?, ?);";
const updateVehicleSql =
  "UPDATE Cars SET carName = ?, make = ?, model = ?, year = ?, makeID = ?, modelID = ? WHERE carID = ?;";

app.post("/vehicles", (req, res) => {
  const isEdit = JSON.parse(req.query.isEdit);

  const insertValues = [
    parseInt(req.body.owner),
    req.body.name,
    req.body.make,
    req.body.model,
    parseInt(req.body.year),
    req.body.makeId,
    req.body.modelId,
    0,
  ];

  const updateValues = [
    req.body.name,
    req.body.make,
    req.body.model,
    parseInt(req.body.year),
    req.body.makeId,
    req.body.modelId,
    req.body.id,
  ];

  db.query(
    isEdit ? updateVehicleSql : insertVehicleSql,
    isEdit ? updateValues : insertValues,
    (err, results) => {
      if (err) {
        res.status(500).json({ error: "Server error." });
      } else {
        res.status(200).send();
      }
    }
  );
});

const deleteVehicleSql = "DELETE FROM Cars WHERE carID = ?;";

app.delete("/vehicles", (req, res) => {
  const id = parseInt(req.query.id);

  db.query(deleteVehicleSql, [id], (err, results) => {
    if (err) {
      res.status(500).json({ error: "Server error." });
    } else {
      res.status(200).send();
    }
  });
});

app.get("/vehicleCarbonReport", (req, res) => {
  const { vehicleId, distance } = req.query;

  if (!vehicleId)
    return res.status(400).json({ error: "Must provide vehicled id." });
  if (!distance)
    return res.status(400).json({ error: "Must provide distance." });

  fetch({
    url: `${API_URL}/estimates`,
    method: "POST",
    headers: {
      Authorization: `Bearer ${API_KEY}`,
      "Content-Type": "application/json",
    },
    body: {
      type: "vehicle",
      distance_unit: "mi",
      distance_value: distance,
      vehicle_model_id: vehicleId,
    },
  })
    .then((apiRes) => {
      if (res.ok) {
        res.json(apiRes.json());
      } else {
        res.status(500).json({ error: "Server error." });
      }
    })
    .catch((err) => res.status(500).json({ error: err }));
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
