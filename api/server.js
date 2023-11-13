const express = require('express');
const Database = require( './sql_db_man.js');
const vehicleMakes = require('./VehicleMakes.json');
const PORT = 3000;
const app = express();
const axios = require('axios');

const API_URL = 'https://www.carboninterface.com/api/v1/estimates';
const API_KEY = '5p3VT63zAweQ6X3j8OQriw';
const dbconfig = {
    host:     "mcs.drury.edu",
    port:     "3306",
    user:     "emission",
    password: "Letmein!eCoders",
    database: "emission"
};
app.use(express.json());


app.post('/insertUser', (request, response)=>{
    // insert user
    console.log("Insertting Users");
    console.log(request.body);
    
    const db = new Database(dbconfig);
    db.connect();

    const userData = request.body;
    userData.profilePicture = userData.profilePicture === null ? 0 : userData.profilePicture;
    const insertQuery = "INSERT INTO Users (email, username, password, profilePicture, levelStatus, displayName) VALUES (?, ?, ?, ?, ?, ?)";
    const values=[userData.email, userData.username, userData.password, 0,0, userData.displayName];

    db.query(insertQuery, values, (err,results)=>{
        if(err){
            console.error("Error executing query:", err);
        }else{
            console.log("Query results:", results);
        }
    })
    db.disconnect();

});




// eventually update this so that it doesn't display ones that a user has already accepted
app.get('/getChallenges', (req,res)=>{
    console.log("Get challenge called");
    const query = "SELECT * FROM Challenges WHERE expirationDate IS NULL OR expirationDate > NOW()";
    const db = new Database(dbconfig);
    db.connect();
    console.log(db.status);
    db.query(query, (err,results)=>{
        if(err){
            console.error("Error executing query:", err);
            return res.status(500).json({ error: 'Error getting challenges.' });
        }else{
            console.log("Query results:", results);
            return res.status(200).json({results});
        }
    })
    db.disconnect();
});

app.get('/getChallengesByID', (req,res)=>{
    console.log("Get challenge by ID called");
    const query = "SELECT * FROM Challenges WHERE challengeID=?";
    const body = req.body;
    console.log(body);
    const id = [body.id];
    const db = new Database(dbconfig);
    db.connect();
    db.query(query, id, (err,results)=>{
        if(err){
            console.error("Error executing query:", err);
            res.status(500).json({ error: err });
        }else{
            console.log("Query results:", results);
            res.status(200).json({results});
        }
    })
    db.disconnect();
});

app.get('/getUserChallenges', async (req, res) => {
    const body = req.body;
    const id = 1;
    const db = new Database(dbconfig);
    db.connect();
    //const query = "SELECT DISTINCT challengeID FROM AcceptedChallenges WHERE userID=? and dateFinished=null ORDER BY CASE WHEN dateAccepted IS NOT NULL THEN 0 ELSE 1 END, dateAccepted DESC;";
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
/* app.post('/acceptChallenges', async (req, res) => {
    console.log("Accepted Challenges called");
    console.log(req.body);
    const today = new Date();
    const formattedDate = today.toISOString().split('T')[0];
    const query = "INSERT INTO AcceptedChallenges (userID, challengeID, dateAccepted, daysInProgress, dateFinished) VALUES (?,?,?,?,?)";
    const challengeDataList = req.body;
    const userID = 1;

    try {
        const db = new Database(dbconfig);
        await db.connect();

        for (var challengeData of challengeDataList) {
            const values = [userID, challengeData.challengeID, formattedDate, 0, null];

            await new Promise((resolve, reject) => {
                db.query(query, values, (err, results) => {
                    if (err) {
                        console.error("Error executing query:", err);
                        reject(err);
                        res.status(500).json({ error: err });
                    } else {
                        console.log("Query results:", results);
                        //const acceptedChallenges = results.map(result => parseInt(result.challengeID, 10));
                        //console.log(acceptedChallenges);
                        //resolve(acceptedChallenges);
                    }
                });
            });
        }

        db.disconnect();
        res.status(200).send("Challenges accepted successfully!");
    } catch (err) {
        console.error("Error executing query:", err);
        res.status(500).send("Internal Server Error");
    }
});
 */
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

/* app.post('/completeChallenges', async (req, res) => {
    console.log("Complete Challenges called");
    console.log(req.body);
    const today = new Date();
    const formattedDate = today.toISOString().split('T')[0];
    // for now it's just inserting a new row instead of updating.
    const query = "INSERT INTO AcceptedChallenges (userID, challengeID, dateAccepted, daysInProgress, dateFinished) VALUES (?,?,?,?,?)";
    const challengeDataList = req.body;
    const userID = 1;

    try {
        const db = new Database(dbconfig);
        await db.connect();

        for (var challengeData of challengeDataList) {
            const values = [userID, challengeData.challengeID, formattedDate, 0, formattedDate];

            await new Promise((resolve, reject) => {
                db.query(query, values, (err, results) => {
                    if (err) {
                        console.error("Error executing query:", err);
                        reject(err);
                        res.status(500).json({ error: err });
                    } else {
                        console.log("Query results:", results);
                        //const acceptedChallenges = results.map(result => parseInt(result.challengeID, 10));
                        //console.log(acceptedChallenges);
                        //resolve(acceptedChallenges);
                    }
                });
            });
        }

        db.disconnect();
        res.status(200).send("Challenges accepted successfully!");
    } catch (err) {
        console.error("Error executing query:", err);
        res.status(500).send("Internal Server Error");
    }
});
 */
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

/* 
app.post('/acceptChallenges', async (req, res) => {
    console.log("Accepted Challenges called");
    console.log(req.body);
    const today = new Date();
    const formattedDate = today.toISOString().split('T')[0];
    const query = "INSERT INTO AcceptedChallenges (userID, challengeID, dateAccepted, daysInProgress, dateFinished) VALUES (?,?,?,?,?)";
    const challengeDataList = req.body;
    const userID = 1;

    
        const db = new Database(dbconfig);
        await db.connect();

        /* const query2 = "SELECT DISTINCT challengeID FROM AcceptedChallenges WHERE userID=?";
        const results = await new Promise((resolve, reject) => {
            db.query(query2, userID, (err, results) => {
                if (err) {
                    console.error("Error executing query:", err);
                    reject(err);
                } else {
                    console.log("Query results:", results);
                    const acceptedChallenges = results.map(result => parseInt(result.challengeID, 10));
                    console.log(acceptedChallenges);
                    resolve(acceptedChallenges);
                }
            });
        });
    
        //db.disconnect();

        for (var challengeData of challengeDataList) {
            console.log(results);
            if (!results.includes(challengeData.challengeID)) {
                const values = [userID, challengeData.challengeID, formattedDate, 0, null]; 
                for(var challengeData of challengeDataList){
                const values = [userID, challengeData.challengeID, formattedDate, 0, null];
                db.query(query, values, (err, results) => {
                    if (err) {
                        console.error("Error executing query:", err);
                        reject(err);
                        res.status(500).json({ error: err });
                    } else {
                        console.log("Query results:", results);
                        //res.status(200).send("Challenges accepted successfully!");
                        const acceptedChallenges = results.map(result => parseInt(result.challengeID, 10));
                        console.log(acceptedChallenges);
                        resolve(acceptedChallenges);
                    }
                });
            }
            db.disconnect();
             } else {
                console.log("Challenge already accepted by the user:", challengeData.challengeID);
            }
        }

        db.disconnect();
        res.status(200).send("Challenges accepted successfully!"); 
    
});*/



app.get('/makeId', (req, res) => {
    const { make } = req.query;
    if (!make) return res.status(400).json({ error: 'Must provide make of vehicle.' });
    for (makeEntry of vehicleMakes) {
        if (makeEntry.data.attributes.name.toLowerCase() === make.toLowerCase()) {
            res.json({ id: makeEntry.data.id});
            return;
        }
    }
    res.status(404).json({ error: 'A car with that make could not be found.' })
});

app.get('/vehicleCarbonReport', (req, res) => {
    const { vehicleId, distance } = req.query;

    if (!vehicleId) return res.status(400).json({ error: 'Must provide vehicled id.' });
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
        if (res.ok) {
            res.json(apiRes.json());
        } else {
            res.status(500).json({ error: 'Server error.' })
        }
    })
    .catch(err => res.status(500).json({ error: err }));
})

app.listen(PORT,()=>{
    console.log(`Server running on port ${PORT}`);
});