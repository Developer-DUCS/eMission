
const express = require('express');
const { Database } = require('./sql_db_man');
const vehicleMakes = require('./VehicleMakes.json');
//const Database = require("./sql_db_man.js");
const PORT = 3000;
const app = express();
const axios = require("axios");

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

app.post('/insertUser', (request, response)=>{
    // insert user
    console.log("Inserting Users");
    console.log(request.body);
    
    const db = new Database(dbconfig);
    db.connect();

    const userData = request.body;
    userData.profilePicture = userData.profilePicture === null ? 0 : userData.profilePicture;
    const insertQuery = "INSERT INTO Users (email, username, password, profilePicture, levelStatus, displayName) VALUES (?, ?, ?, ?, ?, ?)";
    const values=[userData.email, userData.username, userData.password, 0,0, userData.displayName];

    //
    db.query(insertQuery, values, (error, results) => {
        console.log("Query results:", results);
        if(error){
            // error with insertQuery
            console.error("Error executing insertQuery", error);
            if (error.errno == 1062){
                // user already exists
                response.status(401).json({msg: "user already exists"});
            } else {
                response.status(500).json({msg: "insertQuery Error"});
            }
        } else {
            // User successfully created 
            console.log("user successfully created");
            response.status(200).json({msg: "account created"});
        }

    })
    db.disconnect();

    });
    //db.disconnect();
app.post("/authUser", (request, response) => {
  //authenticate user
  console.log("authenticating user...");
  //
  const dbconfig = {
    host: "mcs.drury.edu",
    port: "3306",
    user: "emission",
    password: "Letmein!eCoders",
    database: "emission",
  };
  const db = new Database(dbconfig);
  db.connect();

  //
  //
  const loginData = request.body;
  console.log(loginData);
  const query = "SELECT email, password FROM emission.Users WHERE email = ?";

  //
  //
  db.query(query, loginData.email, (error, result) => {
    if (error) {
      console.error("Error executing query:", error);
      response.status(500).json({ msg: "Database Error" });
    } else {
      console.log(result);
      if (result.length == 0) {
        // The email was not present in database
        console.log(`${result[0].email} was not recognized!`);
        response.status(401).json({ msg: "Authentication Failed" });
      } else {
        if (
          result[0].email == loginData["email"] &&
          result[0].password == loginData["password"]
        ) {
          console.log("User Authenticated");
          response.status(200).json({ msg: "Authentication Successful" });
        } else {
          console.log("Authentication Failed");
          response.status(401).json({ msg: "Authentication Failed" });
        }
      }
    }
  });
});

// eventually update this so that it doesn't display ones that a user has already accepted
app.get("/getChallenges", (req, res) => {
  console.log("Get challenge called");
  const query =
    "SELECT * FROM Challenges WHERE expirationDate IS NULL OR expirationDate > NOW()";
  const db = new Database(dbconfig);
  db.connect();
  console.log(db.status);
  db.query(query, (err, results) => {
    if (err) {
      console.error("Error executing query:", err);
      return res.status(500).json({ error: "Error getting challenges." });
    } else {
      console.log("Query results:", results);
      return res.status(200).json({ results });
    }
  });
  db.disconnect();
});

app.get("/getChallengesByID", (req, res) => {
  console.log("Get challenge by ID called");
  const query = "SELECT * FROM Challenges WHERE challengeID=?";
  const body = req.body;
  console.log(body);
  const id = [body.id];
  const db = new Database(dbconfig);
  db.connect();
  db.query(query, id, (err, results) => {
    if (err) {
      console.error("Error executing query:", err);
      res.status(500).json({ error: err });
    } else {
      console.log("Query results:", results);
      res.status(200).json({ results });
    }
  });
  db.disconnect();
});

app.get("/getUserChallenges", async (req, res) => {
  const body = req.body;
  const id = 1;
  const db = new Database(dbconfig);
  db.connect();
  query = "SELECT * from AcceptedChallenges where userID = ?";
  db.query(query, [id], (err, results) => {
    db.disconnect(); // Disconnect from the database after the query

    if (err) {
      console.error("Error executing query:", err);
      res.status(500).json({ error: err });
    } else {
      console.log("Query results:", results);
      //const challengeIDs = results.map(result => result.challengeID);
      res.status(200).json(results);
    }
  });
});
app.get('/getCurrentUserChallenges', async (req, res) => {
    console.log("Request to get current userChallenges");
    const body = req.body;
    const id = 1;
    const db = new Database(dbconfig);
    db.connect();
    const query = "SELECT a.challengeID, a.points,a.description, a.length, a.name, MAX(b.dateAccepted), MAX(b.daysInProgress), MAX(b.dateFinished) FROM Challenges a INNER JOIN AcceptedChallenges b ON a.challengeID = b.challengeID WHERE b.userID = ? AND b.challengeID NOT IN ( SELECT DISTINCT challengeID FROM AcceptedChallenges WHERE userID = 1 AND dateFinished IS NOT NULL ) GROUP BY a.challengeID, a.points, a.description, a.length, a.name;";
    
    db.query(query, [id], (err, results) => {
        console.log("Query entered");
        db.disconnect(); // Disconnect from the database after the query

        if (err) {
            console.error("Error executing query:", err);
            res.status(500).json({ error: err });
            console.log("error :(")
        } else {
            console.log("Query results:", results);
            //const challengeIDs = results.map(result => result.challengeID);
            return res.status(200).json({results});
        }
    });
});

app.post("/acceptNewChallenges", async (req, res) => {
  console.log("Accept Challenges called");
  console.log(req.body);

  const today = new Date();
  const formattedDate = today.toISOString().split("T")[0];

  const selectQuery =
    "SELECT * FROM AcceptedChallenges WHERE userID = ? AND challengeID = ?";
  const insertQuery =
    "INSERT INTO AcceptedChallenges (userID, challengeID, dateAccepted, daysInProgress, dateFinished) VALUES (?,?,?,?,?)";

  const challengeDataList = req.body;
  const userID = 1; // Replace with actual userID from the request or authentication

  const queryPromise = (db, queryString, values) => {
    return new Promise((resolve, reject) => {
      db.query(queryString, values, (err, results) => {
        if (err) {
          reject(err);
        } else {
          resolve(results);
        }
      });
    });
  };

  try {
    const db = new Database(dbconfig);
    await db.connect();

    const responseMessages = [];

    for (const challengeData of challengeDataList) {
      // Check if a row exists
      const selectValues = [userID, challengeData.challengeID];
      try {
        const existingRow = await queryPromise(db, selectQuery, selectValues);

        if (existingRow.length > 0) {
          responseMessages.push({
            status: "Challenge already accepted",
            challengeData: existingRow[0],
          });
        } else {
          const insertValues = [
            userID,
            challengeData.challengeID,
            formattedDate,
            0,
            null,
          ];
          await queryPromise(db, insertQuery, insertValues);
          responseMessages.push({
            status: "Challenge accepted successfully",
            challengeData: challengeData,
          });
        }
      } catch (err) {
        console.error("Error executing queries:", err);
        res.status(500).send("Internal Server Error");
        return;
      }
    }

    db.disconnect();

    // Send the response with the array of status messages
    res.status(200).json(responseMessages);
  } catch (err) {
    console.error("Error connecting to the database:", err);
    res.status(500).send("Internal Server Error");
  }
});

// not in use: deletes rows before inserting them
app.post("/acceptChallenges", async (req, res) => {
  console.log("Complete Challenges called");
  console.log(req.body);

  const today = new Date();
  const formattedDate = today.toISOString().split("T")[0];

  const deleteQuery =
    "DELETE FROM AcceptedChallenges WHERE userID = ? AND challengeID = ?";
  const insertQuery =
    "INSERT INTO AcceptedChallenges (userID, challengeID, dateAccepted, daysInProgress, dateFinished) VALUES (?,?,?,?,?)";

  const challengeDataList = req.body;
  const userID = 1;

  try {
    const db = new Database(dbconfig);
    await db.connect();

    for (const challengeData of challengeDataList) {
      // Delete existing row
      const deleteValues = [userID, challengeData.challengeID];
      await new Promise((resolve, reject) => {
        db.query(deleteQuery, deleteValues, (deleteErr, deleteResults) => {
          if (deleteErr) {
            console.error("Error executing delete query:", deleteErr);
            reject(deleteErr);
            res.status(500).json({ error: deleteErr });
          } else {
            console.log("Delete query results:", deleteResults);
            // Insert new row
            const insertValues = [
              userID,
              challengeData.challengeID,
              formattedDate,
              0,
              null,
            ];
            db.query(insertQuery, insertValues, (insertErr, insertResults) => {
              if (insertErr) {
                console.error("Error executing insert query:", insertErr);
                reject(insertErr);
                res.status(500).json({ error: insertErr });
              } else {
                console.log("Insert query results:", insertResults);
                // Handle results if needed
                resolve();
              }
            });
          }
        });
      });
    }

    db.disconnect();
    res.status(200).send("Challenges completed successfully!");
  } catch (err) {
    console.error("Error executing queries:", err);
    res.status(500).send("Internal Server Error");
  }
});

// removed /getUserChallenges

app.get('/getCurrentUserChallenges', async (req, res) => {
    console.log("Request to get current userChallenges");
    const body = req.body;
    const id = 1;
    const db = new Database(dbconfig);
    db.connect();
    const query = "SELECT a.challengeID, a.points,a.description, a.length, a.name, MAX(b.dateAccepted), MAX(b.daysInProgress), MAX(b.dateFinished) FROM Challenges a INNER JOIN AcceptedChallenges b ON a.challengeID = b.challengeID WHERE b.userID = ? AND b.challengeID NOT IN ( SELECT DISTINCT challengeID FROM AcceptedChallenges WHERE userID = 1 AND dateFinished IS NOT NULL ) GROUP BY a.challengeID, a.points, a.description, a.length, a.name;";
    
    db.query(query, [id], (err, results) => {
        console.log("Query entered");
        db.disconnect(); // Disconnect from the database after the query

        if (err) {
            console.error("Error executing query:", err);
            res.status(500).json({ error: err });
            console.log("error :(")
        } else {
            console.log("Query results:", results);
            //const challengeIDs = results.map(result => result.challengeID);
            return res.status(200).json({results});
        }
    });
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

        

// not in use: deletes rows before inserting them
app.post('/acceptChallenges', async (req, res) => {
    console.log("Complete Challenges called");
    console.log(req.body);
    
    const today = new Date();
    const formattedDate = today.toISOString().split('T')[0];
    
    const deleteQuery = "DELETE FROM AcceptedChallenges WHERE userID = ? AND challengeID = ?";
    const insertQuery = "INSERT INTO AcceptedChallenges (userID, challengeID, dateAccepted, daysInProgress, dateFinished) VALUES (?,?,?,?,?)";
    
    const challengeDataList = req.body;
    const userID = 1;

    try {
        const db = new Database(dbconfig);
        await db.connect();

        for (const challengeData of challengeDataList) {
            // Delete existing row
            const deleteValues = [userID, challengeData.challengeID];
            await new Promise((resolve, reject) => {
                db.query(deleteQuery, deleteValues, (deleteErr, deleteResults) => {
                    if (deleteErr) {
                        console.error("Error executing delete query:", deleteErr);
                        reject(deleteErr);
                        res.status(500).json({ error: deleteErr });
                    } else {
                        console.log("Delete query results:", deleteResults);
                        // Insert new row
                        const insertValues = [userID, challengeData.challengeID, formattedDate, 0, null];
                        db.query(insertQuery, insertValues, (insertErr, insertResults) => {
                            if (insertErr) {
                                console.error("Error executing insert query:", insertErr);
                                reject(insertErr);
                                res.status(500).json({ error: insertErr });
                            } else {
                                console.log("Insert query results:", insertResults);
                                resolve();
                            }
                        });
                    }
                });
            });
        }

        db.disconnect();
        res.status(200).send("Challenges completed successfully!");
    } catch (err) {
        console.error("Error executing queries:", err);
        res.status(500).send("Internal Server Error");
    }
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


app.post('/completeChallenges', async (req, res) => {
    console.log("Complete Challenges called");
    console.log(req.body);
    
    const today = new Date();
    const formattedDate = today.toISOString().split('T')[0];
    
    const query = "UPDATE AcceptedChallenges SET dateFinished = ? WHERE userID = ? AND challengeID = ?";
    const challengeDataList = req.body;
    const userID = 1;

    try {
        const db = new Database(dbconfig);
        await db.connect();

        for (const challengeData of challengeDataList) {
            const values = [formattedDate, userID, challengeData.challengeID];

            await new Promise((resolve, reject) => {
                db.query(query, values, (err, results) => {
                    if (err) {
                        console.error("Error executing query:", err);
                        reject(err);
                        res.status(500).json({ error: err });
                    } else {
                        console.log("Query results:", results);
                        // Handle results if needed
                        resolve();
                    }
                });
            });
        }

        db.disconnect();
        res.status(200).send("Challenges completed successfully!");
    } catch (err) {
        console.error("Error executing query:", err);
        res.status(500).send("Internal Server Error");
    }
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


app.get('/vehicleCarbonReport', (req, res) => {
    const { vehicleId, distance } = req.query;
  
    if (!vehicleId) return res.status(400).json({ error: 'Must provide vehicle id.' });
    if (!distance) return res.status(400).json({ error: 'Must provide distance.' });
  
    fetch({
      url: API_URL,
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${API_KEY}`,
        'Content-Type': 'application/json',
      },
      body: {
        "type": "vehicle",
        "distance_unit": "mi",
        "distance_value": distance,
        "vehicle_model_id": vehicleId,
      }
    })
      .then(apiRes => {
        if (apiRes.ok) {
          return apiRes.json(); 
        } else {
          res.status(500).json({ error: 'Server error.' });
        }
      })
      .then(data => res.json(data)) // added line to send the data
      .catch(err => res.status(500).json({ error: err }));
  });

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

module.exports=app;