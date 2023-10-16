const express = require('express');
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