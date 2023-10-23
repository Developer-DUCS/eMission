const express = require('express');
const Database = require( './sql_db_man.js');
const vehicleMakes = require('./VehicleMakes.json');
const PORT = 3000;
const app = express();
let messageJson = {message: 'Hello world'};

const API_URL = 'https://www.carboninterface.com/api/v1/estimates';
const API_KEY = '5p3VT63zAweQ6X3j8OQriw';

app.use(express.json());
app.get('/message', (request, response)=>{
    response.send(messageJson);
});

app.post('/insertUser', (request, response)=>{
    // insert user
    console.log("Insertting Users");
    console.log(request.body);
    const dbconfig = {
        host:     "mcs.drury.edu",
        port:     "3306",
        user:     "emission",
        password: "Letmein!eCoders",
        database: "emission"
    };
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
    //db.disconnect();

});


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