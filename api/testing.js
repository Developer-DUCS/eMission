/*
*     testing.js
*
*       Meant for unit testing routes found in server.js
*       Includes classes for mocking a connection to the mysql db.
*       To run the tests
*         run npm test
*/

const express = require('express');
const Database  = require('./sql_db_man');
const vehicleMakes = require('./VehicleMakes.json');
const PORT = 3000;
const axios = require('axios');
const chai = require('chai');
const sinon = require('sinon');
const chaiHttp=require('chai-http');
const app = require('./server.js');
const server = require('./server.js');
const request = require('supertest');
const {fetchData} = require('./server.js');
//const jest = require('jest');
//import {jest} from '@jest/globals';
const expect = chai.expect;
//const fetch = require('jest-fetch-mock');
chai.use(chaiHttp);
//require('jest-fetch-mock').enableMocks();
//const fetch = require('node-fetch');
const fetch = require('node-fetch');



const API_URL = 'https://www.carboninterface.com/api/v1/estimates';
const API_KEY = '1234asffake';
const nock = require('nock');
const dbconfig = {
    host:     "mcs.drury.edu",
    port:     "3306",
    user:     "emission",
    password: "Letmein!eCoders",
    database: "emission"
};
//jest.mock('node-fetch');

describe('Test /insertUser', () => {
    let connectStub;
    let queryStub;
    let disconnectStub;
  
    beforeEach(() => {
      // Create stubs for Database class methods
      connectStub = sinon.stub(Database.prototype, 'connect');
      queryStub = sinon.stub(Database.prototype, 'query');
      disconnectStub = sinon.stub(Database.prototype, 'disconnect');
    });
  
    afterEach(() => {
      sinon.restore();
    });
  
  
    it('should insert a user and return a success message', (done) => {
      connectStub.callsFake();
      const fakeResults = {
        fieldCount: 0,
        affectedRows: 1,
        insertId: 123,
        serverStatus: 2,
        warningCount: 0,
        message: '',
        protocol41: true,
        changedRows: 0
      };
  
      queryStub.callsArgWith(2, null, fakeResults);
  
  
      const userData={
        "email":"Test@gmail.com",
        "username": "MyNewUser",
        "password":"MyNewPassword",
        "displayName":"Jane Doe"
      }
  
      chai.request(app)
        .post('/insertUser')
        .send(userData)
        .end((err, res) => {
          expect(res).to.have.status(200);
          expect(res.body).to.deep.equal({ msg: 'account created' });
  
           sinon.assert.calledWith(
            queryStub,
            'INSERT INTO Users (email, username, password, profilePicture, levelStatus, displayName) VALUES (?, ?, ?, ?, ?, ?)',
            ['Test@gmail.com', 'MyNewUser', 'MyNewPassword', 0, 0, 'Jane Doe']
          );
  
          if (err) {
            return done(err);
          }
  
          done();
        });
    });

    it('duplicate error attempting to insert a user and return a failure message', (done) => {
    
      const fakeResults = {
        fieldCount: 0,
        affectedRows: 1,
        insertId: 123,
        serverStatus: 2,
        warningCount: 0,
        message: '',
        protocol41: true,
        changedRows: 0
      };
    
      queryStub
        .onFirstCall().callsArgWith(2, null, fakeResults) // First insertion succeeds
        .onSecondCall().callsArgWith(2, { errno: 1062, message: 'Duplicate entry for key \'email\'' }, null); // Second insertion simulates a duplicate entry
    
      const userData = {
        "email": "Test@gmail.com",
        "username": "MyNewUser",
        "password": "MyNewPassword",
        "displayName": "Jane Doe"
      };
    
      chai.request(app)
        .post('/insertUser')
        .send(userData)
        .end((err, res) => {
          expect(res).to.have.status(200);
          expect(res.body).to.deep.equal({ msg: 'account created' });
    
         
          sinon.assert.calledWith(
            queryStub,
            'INSERT INTO Users (email, username, password, profilePicture, levelStatus, displayName) VALUES (?, ?, ?, ?, ?, ?)',
            ['Test@gmail.com', 'MyNewUser', 'MyNewPassword', 0, 0, 'Jane Doe']
          );
    
          chai.request(app)
            .post('/insertUser')
            .send(userData)
            .end((err, res) => {
              expect(res).to.have.status(401); 
              expect(res.body).to.deep.equal({ msg: 'user already exists' }); 
    
              sinon.assert.calledWith(
                queryStub,
                'INSERT INTO Users (email, username, password, profilePicture, levelStatus, displayName) VALUES (?, ?, ?, ?, ?, ?)',
                ['Test@gmail.com', 'MyNewUser', 'MyNewPassword', 0, 0, 'Jane Doe']
              );
    
              if (err) {
                return done(err);
              }
    
              done();
            });
        });
    });

    it('error attempting to insert a user with incorrect field type and return a failure message', (done) => {
      connectStub.callsFake();
    
      const incorrectFieldTypeError = new Error('Incorrect field type for column \'email\'');
      queryStub.callsArgWith(2, incorrectFieldTypeError, null);
    
      const userData = {
        "email": 123, // Incorrect field type, should be a string
        "username": "MyNewUser",
        "password": "MyNewPassword",
        "displayName": "Jane Doe"
      };
    
      chai.request(app)
        .post('/insertUser')
        .send(userData)
        .end((err, res) => {
          expect(res).to.have.status(500);
          expect(res.body).to.deep.equal({ msg: 'insertQuery Error' }); 
    
          sinon.assert.calledWith(
            queryStub,
            'INSERT INTO Users (email, username, password, profilePicture, levelStatus, displayName) VALUES (?, ?, ?, ?, ?, ?)',
            [123, 'MyNewUser', 'MyNewPassword', 0, 0, 'Jane Doe'] // Incorrect field type for 'email'
          );
    
          if (err) {
            return done(err);
          }
    
          done();
        });
    });
    
    
  
  });

  describe('Test /authUser', () => {
    let connectStub;
    let queryStub;
    let disconnectStub;

  before(() => {
    connectStub = sinon.stub(Database.prototype, 'connect');
    queryStub = sinon.stub(Database.prototype, 'query');
    disconnectStub = sinon.stub(Database.prototype, 'disconnect');
  });

  after(() => {
    sinon.restore();
  });

  it('user is successfully authenticated.', (done) => {
    const validLoginData = {
      email: 'test@example.com',
      password: 'password123',
    };

    const queryResult = [
      { email: 'test@example.com', password: 'password123' },
    ];

    queryStub.callsArgWith(2, null, queryResult);

    chai.request(app)
      .post('/authUser')
      .send(validLoginData)
      .end((err, res) => {
        expect(res).to.have.status(200);

        done();
      });
  });

    it('should return an "Authentication Failed" message for invalid credentials', (done) => {
        const invalidLoginData = {
          email: 'test@example.com',
          password: 'wrongpassword'
        };

        const queryResult = [
          { email: 'test@example.com', password: 'password123' }
        ];


        queryStub.callsArgWith(2, null, queryResult);

        chai.request(app)
          .post('/authUser')
          .send(invalidLoginData)
          .end((err, res) => {
            expect(res).to.have.status(401);
            expect(res.body).to.deep.equal({ msg: 'Authentication Failed' });

            done();
          });
      });

      it('should return a "Server Error" message for query not returning with any data', (done) => {
        const invalidLoginData = {
          email: 'test@example.com',
          password: 'wrongpassword'
        };
      
        queryStub.callsArgWith(2, new Error('Database error'), []);
      
        chai.request(app)
          .post('/authUser')
          .send(invalidLoginData)
          .end((err, res) => {
            expect(res).to.have.status(500);
      
            done();
          });
      });
      
  


  });


describe('Test /getCurrentUserChallenges', () => {
  let connectStub;
  let queryStub;
  let disconnectStub;

  beforeEach(() => {
    connectStub = sinon.stub(Database.prototype, 'connect');
    queryStub = sinon.stub(Database.prototype, 'query');
    disconnectStub = sinon.stub(Database.prototype, 'disconnect');
  });

  afterEach(() => {
    sinon.restore();
  });

  it('should return user challenges successfully', (done) => {
    const expectedResult ={
      fieldCount: 0,
      affectedRows: 1,
      insertId: 0,
      serverStatus: 2,
      warningCount: 0,
      message: '(Rows matched: 1  Changed: 1  Warnings: 0',
      protocol41: true,
      changedRows: 1
    }
  
    queryStub.callsArgWith(2, null, expectedResult);
  
    chai.request(app)
      .post('/getCurrentUserChallenges')
      .send({ "userID": 1 })
      .end((err, res) => {
        expect(res).to.have.status(200);
        expect(res.body).to.deep.equal({ results: expectedResult });
  
      
  
        done();
      });
  });
  

   it('should handle incorrect userID format', (done) => {
  
    const invalidUserId = 'invalid'; 

      queryStub.callsArgWith(2, new Error('Incorrect userID format'), null);

      chai.request(app)
        .post('/getCurrentUserChallenges')
        .send({ userID: invalidUserId }) 
        .end((err, res) => {
          expect(res).to.have.status(500);

          

          done();
          });
        }); 
      });

      describe('Test /completeChallenges', () => {
        let connectStub;
        let queryStub;
        let disconnectStub;
    
        beforeEach(() => {
            connectStub = sinon.stub(Database.prototype, 'connect');
            queryStub = sinon.stub(Database.prototype, 'query');
            disconnectStub = sinon.stub(Database.prototype, 'disconnect');
        });
    
        afterEach(() => {
            sinon.restore();
        });
    
        it('user successfully completes challenges.', (done) => {
            connectStub.callsFake();
            const expectedResult = {
                fieldCount: 0,
                affectedRows: 1,
                insertId: 0,
                serverStatus: 2,
                warningCount: 0,
                message: '(Rows matched: 1  Changed: 1  Warnings: 0',
                protocol41: true,
                changedRows: 1
            };
            queryStub.callsArgWith(2, null, expectedResult);
    
            request(app)
                .post('/completeChallenges')
                .send({
                  "UserID": 49,
                  "challenges": [
                    {
                      "challengeID": 5,
                      "userID": 1,
                      "daysInProgress": '0'
                    }
                  ]
                })
                
                .expect(200)
                .end((err, res) => {
                    if (err) return done(err);
                    done();
                });
        });
    
        it('user unsuccessfully completes challenges.', (done) => {
            connectStub.callsFake();
            queryStub.callsArgWith(2, new Error(), null);
    
            request(app)
                .post('/completeChallenges')
                .send({
                  "UserID": 49,
                  "challenges": [
                    {
                      "challengeID": 5,
                      "userID": 1,
                      "daysInProgress": '0'
                    }
                  ]
                })
                
                .expect(500)
                .end((err, res) => {
                    if (err) return done(err);
                    done();
                });
        });
    
        it('user enters wrong input data.', (done) => {
            // No need to use connectStub or queryStub for this test
    
            request(app)
                .post('/completeChallenges')
                .send()
                .expect(400)
                .end((err, res) => {
                    if (err) return done(err);
                    done();
                });
        });
    });
    

    describe('Test /makes', () => {
      it('should return vehicle makes successfully.', (done) => {
        request(app)
          .get('/makes')
          .expect(200)
          .end((err, res) => {
            if (err) return done(err);
            expect(res.body).to.be.an('array');
            done();
          });
      });
    });

    

    describe('Test /acceptNewChallenges', () => {
      let connectStub;
      let queryStub;
      let disconnectStub;
  
      beforeEach(() => {
          connectStub = sinon.stub(Database.prototype, 'connect');
          queryStub = sinon.stub(Database.prototype, 'query');
          disconnectStub = sinon.stub(Database.prototype, 'disconnect');
      });
  
      afterEach(() => {
          sinon.restore();
      });
  
      it('should accept challenges successfully.', (done) => {
          connectStub.callsFake();
  
          const expectedResult = {
              fieldCount: 0,
              affectedRows: 1,
              insertId: 0,
              serverStatus: 2,
              warningCount: 0,
              message: '(Rows matched: 1  Changed: 1  Warnings: 0',
              protocol41: true,
              changedRows: 1
          };
  
          queryStub.onCall(0).callsArgWith(2, null, []);
          queryStub.onCall(1).callsArgWith(2, null, expectedResult);
  
          request(app)
              .post('/acceptNewChallenges')
              .send({
                  "UserID": 49,
                  "challenges": [{ challengeID: 5, userID: 1 }]
              })
              .expect(200)
              .end((err, res) => {
                  if (err) return done(err);
                  expect(res.body).to.deep.equal([
                      { status: 'Challenge accepted successfully', challengeData: { challengeID: 5, userID: 1 } }
                  ]);
                  done();
              });
      });
  
      it('should handle already accepted challenge.', (done) => {
          connectStub.callsFake();
  
          const existingRow = [{ challengeID: 5, userID: 1, dateAccepted: '2023-01-01', daysInProgress: 0 }];
  
          queryStub.onCall(0).callsArgWith(2, null, existingRow);
  
          request(app)
              .post('/acceptNewChallenges')
              .send({
                  "UserID": 49,
                  "challenges": [{ challengeID: 5, userID: 1 }]
              })
              .expect(200)
              .end((err, res) => {
                  if (err) return done(err);
                  expect(res.body).to.deep.equal([
                      { status: 'Challenge already accepted', challengeData: existingRow[0] }
                  ]);
                  done();
              });
      });
  
      it('should handle database error.', (done) => {
          connectStub.callsFake();
  
          queryStub.onCall(0).callsArgWith(2, new Error('Database error'), null);
  
          request(app)
              .post('/acceptNewChallenges')
              .send({
                  "UserID": 49,
                  "challenges": [{ challengeID: 5, userID: 1 }]
              })
              .expect(500)
              .end((err, res) => {
                  if (err) return done(err);
                  done();
              });
      });
  
      it('should handle user error (invalid input).', (done) => {
  
        request(app)
        .post('/acceptNewChallenges')
        .send()
        .expect(500)
        .end((err, res) => {
            if (err) return done(err);
            done();
        });
      });
  });

  describe('Test /getChallenges2', () => {
    let connectStub;
    let queryStub;
    let disconnectStub;

    beforeEach(() => {
        connectStub = sinon.stub(Database.prototype, 'connect');
        queryStub = sinon.stub(Database.prototype, 'query');
        disconnectStub = sinon.stub(Database.prototype, 'disconnect');
    });

    afterEach(() => {
        sinon.restore();
    });

    it('should get challenges successfully.', (done) => {
        connectStub.callsFake();

        const userID = 49;
        const expectedResult = [
            { challengeID: 1, title: 'Challenge 1' },
            { challengeID: 2, title: 'Challenge 2' }
            // Add more expected results as needed
        ];

        queryStub.callsArgWith(2, null, expectedResult);

        request(app)
            .post('/getChallenges2')
            .send({ userID })
            .expect(200)
            .end((err, res) => {
                if (err) return done(err);
                expect(res.body.results).to.deep.equal(expectedResult);
                done();
            });
    });

    it('should handle database error.', (done) => {
        connectStub.callsFake();

        queryStub.callsArgWith(2, new Error('Database error'), null);

        request(app)
            .post('/getChallenges2')
            .send({ userID: 49 })
            .expect(500)
            .end((err, res) => {
                if (err) return done(err);
                done();
            });
    });
});

describe('Test /getEarnedPoints', () => {
  let connectStub;
  let queryStub;
  let disconnectStub;

  beforeEach(() => {
    connectStub = sinon.stub(Database.prototype, 'connect');
    queryStub = sinon.stub(Database.prototype, 'query');
    disconnectStub = sinon.stub(Database.prototype, 'disconnect');
  });

  afterEach(() => {
    sinon.restore();
  });

  it('should get earned points successfully with challenges and drives.', (done) => {
    connectStub.callsFake();

    const userID = 49;
    const expectedResult = [{ total_points: 100 }]; // Update with your expected result

    queryStub.callsArgWith(2, null, expectedResult);

    request(app)
      .get('/getEarnedPoints')
      .query({ userID })
      .expect(200)
      .end((err, res) => {
        if (err) return done(err);
        expect(res.body.results).to.deep.equal(expectedResult);
        done();
      });
  });

  it('should get earned points successfully with no challenges or drives.', (done) => {
    connectStub.callsFake();

    const userID = 50;
    const expectedResult = [{ total_points: 0}]; 
    // expected result = 0
    queryStub.callsArgWith(2, null, expectedResult);

    request(app)
      .get('/getEarnedPoints')
      .query({ userID })
      .expect(200)
      .end((err, res) => {
        if (err) return done(err);
        expect(res.body.results).to.deep.equal(expectedResult);
        done();
      });
  });


  it('should handle database error.', (done) => {
    connectStub.callsFake();

    queryStub.callsArgWith(2, new Error('Database error'), null);

    request(app)
      .get('/getEarnedPoints')
      .query({ userID: 49 })
      .expect(500)
      .end((err, res) => {
        if (err) return done(err);
        done();
      });
  });
});

describe('Test /models', () => {
  let fetchStub;

  beforeEach(() => {
    fetchStub = sinon.stub();

  });

  afterEach(() => {
    sinon.restore();
  });

  it('should return vehicle models successfully.', (done) => {
    const makeId = '5f266411-5bb1-4b91-b044-9707426df630';
    const expectedResponse = [{ model: 'Model1' }, { model: 'Model2' }];
    fetchStub.resolves({
      ok: true,
      json: () => expectedResponse,
    }); 

    request(app)
      .get(`/models?makeId=${makeId}`)
      .expect(200)
      .end((err, res) => {
        if (err) return done(err);
        done();
      });
  });

  it('should handle missing makeId.', (done) => {
    request(app)
      .get('/models')
      .expect(400)
      .end((err, res) => {
        if (err) return done(err);
        expect(res.body.error).to.equal('Must provide make ID.');
        done();
      });
  });

  it('should handle API server error.', (done) => {
    const makeId = '123';
    fetchStub.resolves({
      ok: false,
    });

    request(app)
      .get(`/models?makeId=${makeId}`)
      .expect(500)
      .end((err, res) => {
        if (err) return done(err);
        expect(res.body.error).to.equal('Server error.');
        done();
      });
  });
});
describe('Test /vehicles', () => {
  let connectStub;
  let queryStub;
  let disconnectStub;

  beforeEach(() => {
    connectStub = sinon.stub(Database.prototype, 'connect');
    queryStub = sinon.stub(Database.prototype, 'query');
    disconnectStub = sinon.stub(Database.prototype, 'disconnect');
  });

  afterEach(() => {
    sinon.restore();
  });

  it('should get vehicles successfully.', (done) => {
    connectStub.callsFake();

    const owner = '1';
    const expectedResult = [
      { make: 'Toyota', model: 'Camry', year: 1993, carID: 4, carName: 'Work Car', currentMileage: 1401, modelID: 'a2d97d19-14c0-4c60-870c-e734796e014e', makeID: '2b1d0cd5-59be-4010-83b3-b60c5e5342da' }
    ];

    queryStub.callsArgWith(2, null, expectedResult);

    request(app)
      .get(`/vehicles?owner=${owner}`)
      .expect(200)
      .end((err, res) => {
        if (err) return done(err);
        expect(res.body).to.deep.equal(expectedResult);
        done();
      });
  });

  it('should handle database error.', (done) => {
    connectStub.callsFake();

    queryStub.callsArgWith(2, new Error('Database error'), null);

    request(app)
      .get('/vehicles?owner=1')
      .expect(500)
      .end((err, res) => {
        if (err) return done(err);
        done();
      });
  });
});

describe('Test /vehicles', () => {
  let connectStub;
  let queryStub;
  let disconnectStub;

  beforeEach(() => {
    connectStub = sinon.stub(Database.prototype, 'connect');
    queryStub = sinon.stub(Database.prototype, 'query');
    disconnectStub = sinon.stub(Database.prototype, 'disconnect');
  });

  afterEach(() => {
    sinon.restore();
  });

  it('should insert a new vehicle successfully.', (done) => {
    connectStub.callsFake();

    const requestBody = {
      owner: '1',
      name: 'Work Car',
      make: 'Toyota',
      model: 'Camry',
      year: '1993',
      makeId: '2b1d0cd5-59be-4010-83b3-b60c5e5342da',
      modelId: 'a2d97d19-14c0-4c60-870c-e734796e014e',
      mileage: '1401',
    };

    queryStub.callsArgWith(2, null, {}); // Assuming an empty object for successful insert

    request(app)
      .post('/vehicles?isEdit=false')
      .send(requestBody)
      .expect(200)
      .end((err, res) => {
        if (err) return done(err);
        done();
      });
  });

  it('should update an existing vehicle successfully.', (done) => {
    connectStub.callsFake();

    const requestBody = {
      id: '1',
      name: 'Work Car',
      make: 'Toyota',
      model: 'Camry',
      year: '1993',
      makeId: '2b1d0cd5-59be-4010-83b3-b60c5e5342da',
      modelId: 'a2d97d19-14c0-4c60-870c-e734796e014e',
      mileage: '1401',
    };

    queryStub.callsArgWith(2, null, {}); // Assuming an empty object for successful update

    request(app)
      .post('/vehicles?isEdit=true')
      .send(requestBody)
      .expect(200)
      .end((err, res) => {
        if (err) return done(err);
        done();
      });
  });

  it('should handle database error.', (done) => {
    connectStub.callsFake();

    queryStub.callsArgWith(2, new Error('Database error'), null);

    request(app)
      .post('/vehicles?isEdit=false')
      .send({
        owner: '1',
        name: 'Work Car',
        make: 'Toyota',
        model: 'Camry',
        year: '1993',
        makeId: '2b1d0cd5-59be-4010-83b3-b60c5e5342da',
        modelId: 'a2d97d19-14c0-4c60-870c-e734796e014e',
        mileage: '1401',
      })
      .expect(500)
      .end((err, res) => {
        if (err) return done(err);
        done();
      });
  });
  
}); 

describe('Test /updateDrives', () => {
  let queryStub;
  let connectStub;
  let disconnectStub;

  beforeEach(() => {
    connectStub = sinon.stub(Database.prototype, 'connect');
    queryStub = sinon.stub(Database.prototype, 'query');
    disconnectStub = sinon.stub(Database.prototype, 'disconnect');
  });

  afterEach(() => {
    sinon.restore();
  });

  it('should update drives successfully and earn 5 points', async () => {
    connectStub.callsFake();

    const requestBody = {
      userID: 1,
      vehicleID: 2,
      unitOfMeasure: 'mi',
      distance: 50,
      carbon_lb: 40,
      carbon_kg: 18.14,
    };

    const expectedPointsEarned = 5;

    queryStub.callsArgWith(2, null, { insertId: 123 }); // Assuming successful insert

    const res = await chai
      .request(app)
      .post('/updateDrives')
      .send(requestBody);

    expect(res).to.have.status(200);
    expect(res.body.data).to.deep.equal({ insertId: 123 });
   
  });

  it('should update drives successfully and earn 20 points', async () => {
    connectStub.callsFake();

    const requestBody = {
      userID: 1,
      vehicleID: 2,
      unitOfMeasure: 'mi',
      distance: 50,
      carbon_lb: 20,
      carbon_kg: 9.07,
    };

    const expectedPointsEarned = 20;

    queryStub.callsArgWith(2, null, { insertId: 456 }); // Assuming successful insert

    const res = await chai
      .request(app)
      .post('/updateDrives')
      .send(requestBody);

    expect(res).to.have.status(200);
    expect(res.body.data).to.deep.equal({ insertId: 456 });
   
  });

  it('should handle database error.', async () => {
    connectStub.callsFake();

    const requestBody = {
      userID: 1,
      vehicleID: 2,
      unitOfMeasure: 'mi',
      distance: 50,
      carbon_lb: 40,
      carbon_kg: 18.14,
    };

    queryStub.callsArgWith(2, new Error('Database error'), null);

    const res = await chai
      .request(app)
      .post('/updateDrives')
      .send(requestBody);

    expect(res).to.have.status(500);
  });
});
/* global.fetch = jest.fn(() =>
  Promise.resolve({
    json: () => Promise.reject({"Error Message"}),
  })
); */
async function mockFetchData(jsonData) {
  return { mockedResponse: 'success' };
}

// test are WIP
describe('Test /vehicleCarbonReport', () => {
  let connectStub;
  let queryStub;
  let disconnectStub;

  beforeEach(() => {
    connectStub = sinon.stub(Database.prototype, 'connect');
    queryStub = sinon.stub(Database.prototype, 'query');
    disconnectStub = sinon.stub(Database.prototype, 'disconnect');
  });

  afterEach(() => {
    sinon.restore();
    nock.cleanAll();
  });

  it('should find user that has over 6 daily drives.', (done) => {
    connectStub.callsFake(() => {});
    queryStub.callsFake((query, values, callback) => {
      const results = [{ DayDriveTotal: 7 }];
      callback(null, results);
    });

    request(app)
      .get('/vehicleCarbonReport?vehicleId=12d93fhq93jd&carID=2&distance=20&date=2024-02-02')
      .send()
      .expect(422)
      .end((err, res) => {
        if (err) return done(err);
        done();
      });
  });

   it('should find user that has less than 6 daily drives.', (done) => {
    // Stub the database query
    queryStub.callsFake((query, values, callback) => {
      const results = [{ DayDriveTotal: 5 }];
      callback(null, results);
    });

    const requestData = {
      type: "vehicle",
      distance_unit: "mi",
      distance_value: 20,
      vehicle_model_id: "12d93fhq93jd-fake",
    };
    const jsonData = JSON.stringify(requestData);

    //const fetchDataStub = sinon.stub(global, 'fetchData').resolves({ mockedResponse: 'success' });
    //const fetchDataStub = sinon.stub(global, 'fetchData').resolves({ mockedResponse: 'success' });
    const fetchDataStub = sinon.stub(app, 'fetchData').resolves({ mockedResponse: 'success' });

    request(app)
      .get('/vehicleCarbonReport?vehicleId=12d93fhq93jd&carID=2&distance=20&date=2024-02-02')
      .expect(200)
      .end((err, res) => {
        if (err) return done(err);
        sinon.assert.calledWith(fetchDataStub, jsonData);
        fetchDataStub.restore();
        done();
      });
  }); 
});

  
  // not working as expected - is actually calling carbon interface.
  /* it('should handle carbon interface error', (done) => {
    //connectStub.callsFake();
    connectStub.callsFake(()=>{});

    queryStub.callsFake((query, values, callback)=>{
        const results = [{DayDriveTotal: 5}];
        callback(null, results);
    });
    const distance = 20;
    const vehicleId="a2d97d19-14c0-4c60-870c-e734796e014e";
    //[ 1, 2, 'mi', 50, 40, 18.14, 5, 2024-02-14T14:39:53.177Z ]
    const requestData = {
      type: "vehicle",
      distance_unit: "mi",
      distance_value: distance,
      vehicle_model_id: vehicleId,
    };
    const jsonData = JSON.stringify(requestData);
    fetch.mockImplementationOnce(() => Promise.reject("API is down"));

    
    /* nock('https://www.carboninterface.com/api/v1/estimates')
    .post(jsonData) 
    //.matchHeader('Authorization', `Bearer ${"5p3VT63zAweQ6X3j8OQriw"}`)  
    //.matchHeader('Content-Type', 'application/json')  
    .reply(500);  

    // const { vehicleId,carID, distance, date } = req.query;
    request(app)
      .get('/vehicleCarbonReport?vehicleId=a2d97d19-14c0-4c60-870c-e734796e014e&carID=2&distance=20&date=2024-02-02')
      .send()
      .expect(500)
      .end((err, res) => {
        if (err) return done(err);
        done();
      });
  }); */ 
  


describe('Test /getDailyDrives', () => {
  let queryStub;
  let connectStub;
  let disconnectStub;

  beforeEach(() => {
    connectStub = sinon.stub(Database.prototype, 'connect');
    queryStub = sinon.stub(Database.prototype, 'query');
    disconnectStub = sinon.stub(Database.prototype, 'disconnect');
  });

  afterEach(() => {
    sinon.restore();
  });

  it('should get daily drives successfully', async () => {
    connectStub.callsFake();

    const userID = 92;
    const date = '2024-02-02';

    const expectedResult = [{ DayDriveTotal: 5 }]; // Update with your expected result

    queryStub.callsArgWith(2, null, expectedResult);

    const res = await chai
      .request(app)
      .get(`/getDailyDrives?userID=${userID}&date=${date}`)
      .send();

    expect(res).to.have.status(200);
    
  });

  it('should handle database error.', async () => {
    connectStub.callsFake();

    const userID = 92;
    const date = '2024-02-02';

    queryStub.callsArgWith(2, new Error('Database error'), null);

    const res = await chai
      .request(app)
      .get(`/getDailyDrives?userID=${userID}&date=${date}`)
      .send();

    expect(res).to.have.status(500);
  });
});

describe('Test /getTopTen', () => {
  let queryStub;
  let connectStub;
  let disconnectStub;

  beforeEach(() => {
    connectStub = sinon.stub(Database.prototype, 'connect');
    queryStub = sinon.stub(Database.prototype, 'query');
    disconnectStub = sinon.stub(Database.prototype, 'disconnect');
  });

  afterEach(() => {
    sinon.restore();
  });

  it('should get top ten successfully', async () => {
    connectStub.callsFake();
    var expectedResult = {
      "results": [
          {
              "userID": 92,
              "username": "username",
              "drive_points": 80,
              "challenge_points": 70,
              "total_points": 150
          },
          {
              "userID": 1,
              "username": "username",
              "drive_points": 0,
              "challenge_points": 120,
              "total_points": 120
          },
          {
              "userID": 80,
              "username": "user",
              "drive_points": 0,
              "challenge_points": 115,
              "total_points": 115
          },
          {
              "userID": 49,
              "username": "New",
              "drive_points": 0,
              "challenge_points": 105,
              "total_points": 105
          },
          {
              "userID": 51,
              "username": "User",
              "drive_points": 0,
              "challenge_points": 85,
              "total_points": 85
          },
          {
              "userID": 86,
              "username": "meganiscool",
              "drive_points": 0,
              "challenge_points": 54,
              "total_points": 54
          },
          {
              "userID": 85,
              "username": "hi",
              "drive_points": 0,
              "challenge_points": 50,
              "total_points": 50
          },
          {
              "userID": 55,
              "username": "username",
              "drive_points": 0,
              "challenge_points": 40,
              "total_points": 40
          },
          {
              "userID": 91,
              "username": "Jenny_is_cool",
              "drive_points": 0,
              "challenge_points": 32,
              "total_points": 32
          },
          {
              "userID": 76,
              "username": "check",
              "drive_points": 0,
              "challenge_points": 20,
              "total_points": 20
          }
      ]
  }
    
    queryStub.callsArgWith(2, null, expectedResult);

    const res = await chai
      .request(app)
      .get(`/getTopTen`)
      .send();

    expect(res).to.have.status(200);
    expect(res.body).to.deep.equal({ results: expectedResult});
    
    
  });
  it('should get top ten successfully when 9 users', async () => {
    connectStub.callsFake();
    var expectedResult = {
      "results": [
          {
              "userID": 92,
              "username": "username",
              "drive_points": 80,
              "challenge_points": 70,
              "total_points": 150
          },
          {
              "userID": 1,
              "username": "username",
              "drive_points": 0,
              "challenge_points": 120,
              "total_points": 120
          },
          {
              "userID": 80,
              "username": "user",
              "drive_points": 0,
              "challenge_points": 115,
              "total_points": 115
          },
          {
              "userID": 49,
              "username": "New",
              "drive_points": 0,
              "challenge_points": 105,
              "total_points": 105
          },
          {
              "userID": 51,
              "username": "User",
              "drive_points": 0,
              "challenge_points": 85,
              "total_points": 85
          },
          {
              "userID": 86,
              "username": "meganiscool",
              "drive_points": 0,
              "challenge_points": 54,
              "total_points": 54
          },
          {
              "userID": 85,
              "username": "hi",
              "drive_points": 0,
              "challenge_points": 50,
              "total_points": 50
          },
          {
              "userID": 55,
              "username": "username",
              "drive_points": 0,
              "challenge_points": 40,
              "total_points": 40
          },
          {
              "userID": 91,
              "username": "Jenny_is_cool",
              "drive_points": 0,
              "challenge_points": 32,
              "total_points": 32
          }
      ]
  }
    
    queryStub.callsArgWith(2, null, expectedResult);

    const res = await chai
      .request(app)
      .get(`/getTopTen`)
      .send();

    expect(res).to.have.status(200);
    expect(res.body).to.deep.equal({ results: expectedResult});
    
    
  });

  /* it('should handle database error.', async () => {
    connectStub.callsFake();

    const userID = 92;
    const date = '2024-02-02';

    queryStub.callsArgWith(2, new Error('Database error'), null);

    const res = await chai
      .request(app)
      .get(`/getDailyDrives?userID=${userID}&date=${date}`)
      .send();

    expect(res).to.have.status(500);
  }); */
});