/*
*   server.js Authors: eCoders members
*   Defines routes for interacting with the mysql database
*   and Carbon Interface
*
*   To Start, run:
*   npm start
*/


const express = require("express");
const vehicleMakes = require("./VehicleMakes.json");
const Database = require("./sql_db_man.js");
const PORT = 3000;
const app = express();
const axios = require("axios");
const API_URL = "https://www.carboninterface.com/api/v1";
const API_KEY = "5p3VT63zAweQ6X3j8OQriw";
const fetch = require('node-fetch');

const dbconfig = {
  host: "mcs.drury.edu",
  port: "3306",
  user: "emission",
  password: "Letmein!eCoders",
  database: "emission",
};
const db = new Database(dbconfig);

app.use(express.json());
const startServer = async()=>{
  try{
      console.log("connected to the database");
      db.connect();
      app.listen(3000,()=>{
        console.log("server is running on port 3000");
      });
  }catch(error){
      console.error("Error connecting to database:", error);
      process.exit(1);
  }
};
const stopServer = async()=>{
  try{
    // make asyncrounous?
      db.disconnect();
      console.log("Disconnected from the database");
  }catch(error){
    console.error('Error disconnecting from the database:', error);
   
  }
  finally{
    process.exit(0);
  }
  
};
process.on('SIGINT', stopServer);
process.on('SIGTERM', stopServer);
// tested
app.post("/insertUser", (request, response) => {
  // insert user
  console.log("Inserting Users");
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

  //
  db.query(insertQuery, values, (error, results) => {
    console.log("Query results:", results);
    if (error) {
      // error with insertQuery
      console.error("Error executing insertQuery", error);
      if (error.errno == 1062) {
        // user already exists
        response.status(401).json({ msg: "user already exists" });
      } else {
        response.status(500).json({ msg: "insertQuery Error" });
      }
    } else {
      // User successfully created
      console.log("user successfully created");
      response.status(200).json({ msg: "account created" });
    }
  });
});

// tested
app.post("/authUser", (request, response) => {
  //authenticate user
  console.log("authenticating user...");
  const loginData = request.body;
  const query =
    "SELECT userID, email, userName, displayName, password FROM emission.Users WHERE email = ?";
  try{
  db.query(query, loginData.email, (error, result) => {
    if (error) {
      console.error("Error executing query:", error);
      response.status(500).json({ msg: "Database Error" });
    } else {
      if (result.length == 0) {
        // The email was not present in database
        console.log("Email was not recognized!");
        response.status(401).json({ msg: "Authentication Failed" });
      } else {
        if (
          result[0].email == loginData["email"] &&
          result[0].password == loginData["password"]
        ) {
          console.log("User Authenticated");
          response.status(200).send(result[0]);
        } else {
          console.log(`Authentication Failed: ${loginData.email}`);
          response.status(401).json({ msg: "Authentication Failed" });
        }
      }
    }
  });
  }
  catch(err){
    response.status(500).json({msg: "Database Connection Error"});
  }
  
});

const updateUserSql =
// don't update with null values check
"UPDATE Users SET userName = COALESCE(?, userName), displayName = COALESCE(?, displayName) WHERE userID = ?;";
app.patch("/user", (req, res) => {
  try{
    const values = [req.body.username, req.body.displayName, req.body.id];
    db.query(updateUserSql, values, (err, results) => {
      if (err) {
        res.status(500).json({ error: "Error updating information." });
      } else {
        res.status(200).send();
      }
    });
  }
  catch(err){
    response.status(500).json({ msg: "Database Connection Error" });
  }
});

const updatePasswordSql =
  "UPDATE Users SET password = ? WHERE userID = ? AND password = ?;";

app.patch("/password", (req, res) => {
  const values = [req.body.newPassword, req.body.id, req.body.oldPassword];
  console.log("request recieved");

  db.query(updatePasswordSql, values, (err, results) => {
    if (err) {
      res.status(500).json({ error: "Error updating information." });
    } else {
      if (results.changedRows == 1) {
        res.status(200).send();
      } else {
        res.status(401).send();
      }
    }
  });
});

// update from /getChallenges - called with userID
// tested
app.post("/getChallenges2", (req, res) => {
  console.log("Get challenge called");
  const userID = req.body.userID;

  const query = `
    SELECT * FROM Challenges
    WHERE challengeID NOT IN (
        SELECT DISTINCT challengeID FROM AcceptedChallenges
        WHERE earnerID = ?
      )`;

  db.query(query, [userID], (err, results) => {

    if (err) {
      console.error("Error executing query:", err);
      return res.status(500).json({ error: "Error getting challenges." });
    } else {
      console.log("Query results:", results);
      return res.status(200).json({ results });
    }
  });
});

// tested
app.get("/getEarnedPoints", (req, res) => {
  console.log("Get earned points called");
  const {userID} = req.query;
  console.log(userID);
  
    const query =
    `   
    SELECT
    COALESCE(dp.userID, cp.userID) AS userID,
    COALESCE(dp.drive_points, 0) + cp.challenge_points AS total_points
    FROM (
        SELECT
            userID,
            COALESCE(SUM(points_earned), 0) AS drive_points
        FROM (
            SELECT
                userID,
                points_earned,
                date_earned,
                ROW_NUMBER() OVER (PARTITION BY userID, DATE(date_earned) ORDER BY date_earned) AS row_num
            FROM
                Drives
            WHERE date_earned IS NOT NULL
        ) t
        WHERE row_num = 1
        GROUP BY userID
    ) dp
    RIGHT OUTER JOIN (
        SELECT
            a.earnerID AS userID,
            COALESCE(SUM(c.points), 0) AS challenge_points
        FROM
            AcceptedChallenges a
        LEFT JOIN
            Challenges c ON c.challengeID = a.challengeID
        WHERE
            a.dateFinished IS NOT NULL
        GROUP BY
            a.earnerID
    ) cp ON dp.userID = cp.userID
    LEFT JOIN
        Users u ON COALESCE(dp.userID, cp.userID) = u.userID
    WHERE
        u.userID = ?;`;

  db.query(query, [userID], (err, results) => {
    if (err) {
      console.error("Error executing query:", err);
      return res.status(500).json({ error: "Error getting sum." });
    } else {
      console.log("Query results:", results);
      return res.status(200).json({ results });
    }
  });
});

//  tested
app.get("/getTopTen", (req, res) => {
  console.log("Get earned points called");
  const {userID} = req.query;
  console.log(userID);
  
    const query =
    `   
    WITH DrivePoints AS (
      SELECT
          userID,
          COALESCE(SUM(points_earned), 0) AS drive_points
      FROM (
          SELECT
              userID,
              points_earned,
              date_earned,
              ROW_NUMBER() OVER (PARTITION BY userID, DATE(date_earned) ORDER BY date_earned) AS row_num
          FROM
              Drives
          WHERE date_earned IS NOT NULL
      ) t
      WHERE row_num = 1
      GROUP BY userID
  ),
  
  ChallengePoints AS (
      SELECT
          a.earnerID AS userID,
          COALESCE(SUM(c.points), 0) AS challenge_points
      FROM
          AcceptedChallenges a
      LEFT JOIN
          Challenges c ON c.challengeID = a.challengeID
      WHERE
          a.dateFinished IS NOT NULL
      GROUP BY
          a.earnerID
  )
  
  SELECT
      COALESCE(dp.userID, cp.userID) AS userID,
      u.username,
      COALESCE(dp.drive_points, 0) AS drive_points,
      cp.challenge_points,
      COALESCE(dp.drive_points, 0) + cp.challenge_points AS total_points
      
  FROM
      DrivePoints dp
  RIGHT OUTER JOIN
      ChallengePoints cp ON dp.userID = cp.userID
  LEFT JOIN
      Users u ON COALESCE(dp.userID, cp.userID) = u.userID
  ORDER BY
      total_points desc,
      userID
      LIMIT 10;`;

  db.query(query, [userID], (err, results) => {
    if (err) {
      console.error("Error executing query:", err);
      return res.status(500).json({ error: "Error getting sum." });
    } else {
      console.log("Query results:", results);
      return res.status(200).json({ results });
    }
  });
});
// make sure all users are represented
app.get("/getUserRank", (req, res) => {
  console.log("Get earned points called");
  const {userID} = req.query;
  console.log(userID);
  
    const query =
    `   
    WITH DrivePoints AS (
      SELECT
          userID,
          COALESCE(SUM(points_earned), 0) AS drive_points
      FROM (
          SELECT
              userID,
              points_earned,
              date_earned,
              ROW_NUMBER() OVER (PARTITION BY userID, DATE(date_earned) ORDER BY date_earned) AS row_num
          FROM
              Drives
          WHERE date_earned IS NOT NULL
      ) t
      WHERE row_num = 1
      GROUP BY userID
  ),
  
  ChallengePoints AS (
      SELECT
          a.earnerID AS userID,
          COALESCE(SUM(c.points), 0) AS challenge_points
      FROM
          AcceptedChallenges a
      LEFT JOIN
          Challenges c ON c.challengeID = a.challengeID
      WHERE
          a.dateFinished IS NOT NULL
      GROUP BY
          a.earnerID
  )
  
  SELECT
      leaderboard_rank,
      userID,
      username,
      drive_points,
      challenge_points,
      total_points
  FROM (
      SELECT
          RANK() OVER (ORDER BY (COALESCE(dp.drive_points, 0) + COALESCE(cp.challenge_points, 0)) DESC) AS leaderboard_rank,
          u.userID,
          u.username,
          COALESCE(dp.drive_points, 0) AS drive_points,
          COALESCE(cp.challenge_points, 0) AS challenge_points,
          COALESCE(dp.drive_points, 0) + COALESCE(cp.challenge_points, 0) AS total_points
      FROM
          Users u
      LEFT JOIN
          DrivePoints dp ON u.userID = dp.userID
      LEFT JOIN
          ChallengePoints cp ON u.userID = cp.userID
      ORDER BY
          total_points DESC,
          u.userID
  ) leaderboard
  WHERE
      userID = ?;
  `;

  db.query(query, [userID], (err, results) => {
    if (err) {
      console.error("Error executing query:", err);
      return res.status(500).json({ error: "Error getting sum." });
    } else {
      console.log("Query results:", results);
      return res.status(200).json({ results });
    }
  });
});

// can be used to get specific challenge - currently not called.
// not used atm- not tested
app.get("/getChallengesByID", (req, res) => {
  console.log("Get challenge by ID called");
  const query = "SELECT * FROM Challenges WHERE challengeID=?";
  const body = req.body;
  console.log(body);
  const id = [body.id];
  db.query(query, id, (err, results) => {
    if (err) {
      console.error("Error executing query:", err);
      res.status(500).json({ error: err });
    } else {
      console.log("Query results:", results);
      res.status(200).json({ results });
    }
  });
});

// User Challenge - a challenge in acceptedChallenges
// short for user Accepted Challege
// tests completed
app.post("/getCurrentUserChallenges", async (req, res) => {
  console.log("Request to get current userChallenges update");
  const body = req.body;
  const id = body.earnerID;
  console.log(id);
  const query =
    "SELECT a.challengeID, a.points, a.description, a.length, a.name, MAX(b.dateAccepted), MAX(b.daysInProgress), MAX(b.dateFinished) FROM Challenges a INNER JOIN AcceptedChallenges b ON a.challengeID = b.challengeID WHERE b.earnerID = ? AND b.challengeID NOT IN ( SELECT DISTINCT challengeID FROM AcceptedChallenges WHERE earnerID = ? AND dateFinished IS NOT NULL ) GROUP BY a.challengeID, a.points, a.description, a.length, a.name;";

  db.query(query, [id, id], (err, results) => {
    console.log("Query entered");
    if (err) {
      console.error("Error executing query:", err);
      res.status(500).json({ error: err });
      console.log("error :(");
    } else {
      console.log("Query results:", results);
      return res.status(200).json({ results });
    }
  });
});

// test completed
app.post("/acceptNewChallenges", async (req, res) => {
  console.log("Accept Challenges called");
  const { UserID, challenges } = req.body;

  console.log("UserID:", UserID);
  console.log("Challenges:", challenges);

  const today = new Date();
  const formattedDate = today.toISOString().split("T")[0];

  const selectQuery =
    "SELECT * FROM AcceptedChallenges WHERE earnerID = ? AND challengeID = ?";
  const insertQuery =
    "INSERT INTO AcceptedChallenges (earnerID, challengeID, dateAccepted, daysInProgress, dateFinished) VALUES (?,?,?,?,?)";

  const challengeDataList = challenges;
  const userID = UserID; 

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

    res.status(200).json(responseMessages);
  } catch (err) {
    console.error("Error connecting to the database:", err);
    res.status(500).send("Internal Server Error");
  }
});



app.get("/makes", (req, res) => {
  res.json(vehicleMakes);
});

app.get("/models", (req, res) => {
  const { makeId } = req.query;

  if (!makeId) return res.status(400).json({ error: "Must provide make ID." });

  fetch(`${API_URL}/vehicle_makes/${makeId}/vehicle_models`, {
    method: "GET",
    headers: {
      Authorization: `Bearer ${API_KEY}`,
      "Content-Type": "application/json",
    },
  })
    .then((apiRes) => {
      if (apiRes.ok) {
        return apiRes.json();
      } else {
        res.status(500).json({ error: "Server error." });
      }
    })
    .then((apiRes) => {
      res.json(apiRes);
    })
    .catch(console.log); //, (err) => res.status(500).json({ error: err }));
});

const getVehicleSql =
  "SELECT make, model, year, carID, carName, modelID, currentMileage FROM Cars WHERE owner = ?;";

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
  "UPDATE Cars SET carName = ?, make = ?, model = ?, year = ?, makeID = ?, modelID = ?, currentMileage = ? WHERE carID = ?;";

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
    parseInt(req.body.mileage),
  ];

  const updateValues = [
    req.body.name,
    req.body.make,
    req.body.model,
    parseInt(req.body.year),
    req.body.makeId,
    req.body.modelId,
    parseInt(req.body.mileage),
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

// tests completed
app.post("/completeChallenges", async (req, res) => {
  console.log("Complete Challenges called");
  console.log(req.body);

  const { UserID, challenges } = req.body;

  const today = new Date();
  const formattedDate = today.toISOString().split("T")[0];

  const query =
    "UPDATE AcceptedChallenges SET dateFinished = ? WHERE earnerID = ? AND challengeID = ?";
  const challengeDataList = challenges;
  const userID = UserID;
  try {

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
    res.status(200).send("Challenges completed successfully!");
  } catch (err) {
    console.error("Error executing query:", err);
    res.status(400).send("Error with input");
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



app.get("/getRecentDrive", async (req,res)=>{
  try{
   
    const { userID } = req.query;
  
    console.log(req.body);
  
    const query = `SELECT c.carName, d.amount, d.unitOfMeasure, d.carbon_lb, d.points_earned, d.date_earned
    from Drives d
    inner join Cars c on c.owner=d.userID and c.carID=d.carID
    where d.userID = ?
    order by d.date_earned desc
    limit 1`;
    values = [userID];

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
        res.status(200).json({ data: results });
      }
    });
  });
}
catch
  (err) {
    console.error("Error getting drive results", err);
    res.status(400).send("Error getting drive results");
}
  
});

app.get("/getDailyDrives", async (req,res)=>{
  try{
   
    const { userID, date } = req.query;
  
    console.log(req.body);
  
    const query = `SELECT COUNT(*) as DayDriveTotal from(SELECT c.carName, d.amount, d.unitOfMeasure, d.carbon_lb, d.points_earned, d.date_earned
      from Drives d
      inner join Cars c on c.owner=d.userID and c.carID=d.carID
      where d.userID = 92 and 
      date_earned like ? 
      order by d.date_earned desc)
      myTable`;

    values = [userID, date];

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
        res.status(200).json({ data: results });
      }
    });
  });
}
catch
  (err) {
    console.error("Error getting drive results", err);
    res.status(400).send("Error getting drive results");
}
});

app.post("/updateDrives", async (req,res)=>{
  try{
    let pointsEarned;
    if (req.body.carbon_lb > 30) {
      pointsEarned = 5;
    } else if (req.body.carbon_lb > 0 && req.body.carbon_lb<30) {
      pointsEarned = 20;
    } else {
      pointsEarned = 0;
    }
  console.log(req.body);
  const insertData = {
    userID: req.body.userID,
    carID: req.body.vehicleID,
    unitOfMeasure: "mi",
    distance: req.body.distance,
    carbon_lb: req.body.carbon_lb,
    carbon_kg: req.body.carbon_kg,
    points_earned: pointsEarned,
    date_earned:  new Date()
  };
  const query =
        "INSERT INTO Drives (userID, carID, unitOfMeasure, amount, carbon_lb, carbon_kg, points_earned, date_earned) VALUES (?, ?, ?, ?, ?, ?,? , ?)";
  const values = [insertData.userID, insertData.carID, insertData.unitOfMeasure, insertData.distance, insertData.carbon_lb, insertData.carbon_kg, insertData.points_earned, insertData.date_earned];
  console.log(values);
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
        res.status(200).json({ data: results });
      }
    });
  });
}
catch
  (err) {
    console.error("Error updating drives table", err);
    res.status(400).send("Error updating drives table");
}

  
});

app.get("/vehicleCarbonReport", (req, res) => {

  const { vehicleId, carID, distance, date } = req.query;

  // Check if the user ID pertaining to this report has too many daily drives
  const query1 =
    `SELECT COUNT(*) as DayDriveTotal
    FROM (
        SELECT c.carName, c.modelID, d.amount, d.unitOfMeasure, d.carbon_lb, d.points_earned, d.date_earned, c.owner
        FROM Drives d
        INNER JOIN Cars c ON c.owner = d.userID AND c.carID = d.carID
        WHERE d.userID = (SELECT owner FROM Cars WHERE carID = ?) AND date_earned LIKE ?
        ORDER BY d.date_earned DESC
    ) myTable`;

  db.query(query1, [carID, `${date}%`], async (err, results) => {
    try {
      if (err) {
        console.error("Error executing query:", err);
        return res.status(500).json({ error: "Error getting drive total." });
      }

      if (results.length > 0 && results[0].DayDriveTotal <= 6) {
        console.log("vehicleId");
        console.log(results[0].DayDriveTotal);

        const requestData = {
          type: "vehicle",
          distance_unit: "mi",
          distance_value: distance,
          vehicle_model_id: vehicleId,
        };

        const jsonData = JSON.stringify(requestData);

        try {
          const data = await fetchData(jsonData);

          if (data) {
            console.log(data);
            res.status(200).json({ data: data });
          } else {
            res.status(500).json({ error: "Server error." });
          }
        } catch (fetchError) {
          console.error("Error in fetching data:", fetchError);
          res.status(500).json({ error: "Error in fetching data." });
        }
      } else {
        console.log(results[0].DayDriveTotal);
        res.status(422).json({ error: "Too many drives for the day, try again later." });
      }
    } catch (error) {
      console.error("Error in route handler:", error);
      res.status(500).json({ error: "Internal server error." });
    }
  });
});


async function fetchData(jsonData) {
  try {
    const response = await fetch("https://www.carboninterface.com/api/v1/estimates", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${API_KEY}`,
        "Content-Type": "application/json",
      },
      body: jsonData,
    });

    if (!response.ok) {
      console.error("Error in fetch:", response.statusText);
      throw new Error("Error in fetch");
    }

    return response.json();
  } catch (error) {
    console.error("Error in fetch:", error.message);
    throw new Error("Error in fetch");
  }
}


app.post("/updateDistance", (req, res) => {
 
  // Unpacking sent data
  const distance = req.body.distance;
  const userCredentials = req.body.userID;
  const submittedVehicle = req.body.vehicle;

  // Query to fetch saved milage
  const query =
    "select currentMileage from emission.Cars where owner = ? and carID = ?;";
  db.query(query, [userCredentials, submittedVehicle], (error, result) => {
    // Catch Errors
    if (error) {
      //console.error("Error executing query:", error);
      response.status(500).json({ msg: "Database Error" });
    } else {
      // Save old mileage
      const currentMilage = result[0]["currentMileage"];
      const travelDist = distance - currentMilage;

      // Check if submitted mileage is greater than the saved mileage.
      // If not, send back an error.
      if (currentMilage >= distance) {
        res
          .status(500)
          .json({ msg: "Submitted Mileage must be greater than old mileage" });
      } else {
        // Query to update saved mileage to submitted mileage
        const updateQuery =
          "UPDATE emission.Cars SET currentMileage = ? WHERE owner = ? AND carID = ?;";
        db.query(
          updateQuery,
          [distance, userCredentials, submittedVehicle],
          (error, result) => {
            // Catch Errors
            if (error) {
              response.status(500).json({ msg: "Database Error" });
            } else {
              res.status(200).json({ data: travelDist });
            }
          }
        );
      }
    }
  });
 
});


app.post("/addDistance", (req, res) => {
  console.log("Add distance called");
  

  const distance = req.body.distance;
  const userCredentials = req.body.userID;
  const submittedVehicle = req.body.vehicle;

  const query =
    "select currentMileage from emission.Cars where owner = ? and carID = ?;";
  db.query(query, [userCredentials, submittedVehicle], (error, result) => {
    // Catch Errors
    if (error) {
      //console.error("Error executing query:", error);
      response.status(500).json({ msg: "Database Error" });
    } else {
      // Save old mileage
      const currentMilage = result[0]["currentMileage"];
      const newMileage = Math.ceil(distance) + parseInt(currentMilage);
      console.log("New mileage");
      console.log(newMileage);
      // Check if submitted mileage is greater than the saved mileage.
      // If not, send back an error.
      
        // Query to update saved mileage to submitted mileage
        const updateQuery =
          "UPDATE emission.Cars SET currentMileage = ? WHERE owner = ? AND carID = ?;";
        db.query(
          updateQuery,
          [newMileage, userCredentials, submittedVehicle],
          (error, result) => {
            // Catch Errors
            if (error) {
              response.status(500).json({ msg: "Database Error" });
            } else {
              res.status(200).json({ data: distance });
            }

          }
        );
        
      }
    
  });
  
});

module.exports = app;

startServer();
