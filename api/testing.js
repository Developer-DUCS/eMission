const express = require('express');
const Database  = require('./sql_db_man');
const vehicleMakes = require('./VehicleMakes.json');
const PORT = 3000;
const axios = require('axios');
const chai = require('chai');
const sinon = require('sinon');
const chaiHttp=require('chai-http');
const app = require('./server.js');
const request = require('supertest');
const fetch = require('node-fetch');
const expect = chai.expect;
chai.use(chaiHttp);
const API_URL = 'https://www.carboninterface.com/api/v1/estimates';
const API_KEY = '5p3VT63zAweQ6X3j8OQriw';

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
  
          sinon.assert.calledOnce(connectStub);
           sinon.assert.calledWith(
            queryStub,
            'INSERT INTO Users (email, username, password, profilePicture, levelStatus, displayName) VALUES (?, ?, ?, ?, ?, ?)',
            ['Test@gmail.com', 'MyNewUser', 'MyNewPassword', 0, 0, 'Jane Doe']
          );
          sinon.assert.calledOnce(disconnectStub); 
  
          if (err) {
            return done(err);
          }
  
          done();
        });
    });

    it('duplicate error attempting to insert a user and return a failure message', (done) => {
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
    
          sinon.assert.calledOnce(connectStub);
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
    
              sinon.assert.calledTwice(connectStub); 
              sinon.assert.calledWith(
                queryStub,
                'INSERT INTO Users (email, username, password, profilePicture, levelStatus, displayName) VALUES (?, ?, ?, ?, ?, ?)',
                ['Test@gmail.com', 'MyNewUser', 'MyNewPassword', 0, 0, 'Jane Doe']
              );
              sinon.assert.calledTwice(disconnectStub); 
    
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
    
          sinon.assert.calledOnce(connectStub);
          sinon.assert.calledWith(
            queryStub,
            'INSERT INTO Users (email, username, password, profilePicture, levelStatus, displayName) VALUES (?, ?, ?, ?, ?, ?)',
            [123, 'MyNewUser', 'MyNewPassword', 0, 0, 'Jane Doe'] // Incorrect field type for 'email'
          );
          sinon.assert.calledOnce(disconnectStub);
    
          if (err) {
            return done(err);
          }
    
          done();
        });
    });
    
    
  // place for more insert user tests  
  
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
      .post('/getCurentUserChallenges')
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
        .post('/getCurentUserChallenges')
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
    

      /* describe('Test /makeId',  () => {

        it('user successfully gets makeId', (done)=>{
            chai.request(app)
            .get('/makeId')
            .query({make: 'Ferrari'})
            .end((err, res)=>{
              expect(res).to.have.status(200);
              expect(res.body).to.have.property('id');
              done();
            })
        });
        it('returns an error for missing make parameter', (done) => {
          chai.request(app)
              .get('/makeId')
              .end((err, res) => {
                  expect(res).to.have.status(404);
                  expect(res.body).to.have.property('error', 'Must provide make of vehicle.');
                  done();
              });
      });
  
      it('returns an error for a non-existent make', (done) => {
          chai.request(app)
              .get('/makeId')
              .query({ make: 'NonExistentMake' })
              .end((err, res) => {
                  expect(res).to.have.status(404);
                  expect(res.body).to.have.property('error', 'A car with that make could not be found.');
                  done();
              });
      });
      }); */

    describe('Test /vehicleCarbonReport',()=>{
      

      it('should return vehicle carbon report successfully', async () => {
        const mockApiResponse = {
          ok: true,
          json: () => ({ result: '240 units' }),
        };
    
         const fetchStub = sinon.stub(global, 'fetch');
        fetchStub.resolves(mockApiResponse);
    
        const response = await chai.request(app)
          .get('/vehicleCarbonReport')
          .query({ vehicleId: '123', distance: '100' });
    
        expect(response).to.have.status(200);
        expect(response.body).to.deep.equal({ result: '240 units' });
    
        fetchStub.restore();
      });

      it('should return vehicle carbon report unsuccessfully', async () => {
        const mockApiResponse = {
          ok: false,
        };
    
         const fetchStub = sinon.stub(global, 'fetch');
        fetchStub.resolves(mockApiResponse);
    
        const response = await chai.request(app)
          .get('/vehicleCarbonReport')
          .query({ vehicleId: '123', distance: '100' });
    
        expect(response).to.have.status(500);
        expect(response.body).to.have.property('error');
        expect(response.body).to.deep.equal({error:'Server error.'});
        //expect(response.body).to.deep.equal({ result: '240 units' });
    
        fetchStub.restore();
      });
      it('should return 400 if vehicleId is missing', async () => {
        const response = await chai.request(app)
            .get('/vehicleCarbonReport')
            .query({ distance: '100' });

        expect(response).to.have.status(400);
        expect(response.body).to.deep.equal({ error: 'Must provide vehicle id.' });
    });

    it('should return 400 if distance is missing', async () => {
        const response = await chai.request(app)
            .get('/vehicleCarbonReport')
            .query({ vehicleId: '123' });

        expect(response).to.have.status(400);
        expect(response.body).to.deep.equal({ error: 'Must provide distance.' });
    });


    });


    describe('Test /getChallenges', () => {
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

      it('should return challenges successfully', (done) => {
        const mockResults = [
          {
            challengeID: 1,
            points: 20,
            description: 'Use reusable coffee mugs at your local coffee shop.',
            length: '7',
            expirationDate: null,
            name: 'ReUse Coffee Cups'
          }
        ];
    
        queryStub.yields(null, mockResults);
    
        chai.request(app)
          .get('/getChallenges')
          .end((err, res) => {
            console.log(res.status);
            console.log(res.body);
            expect(res.status).to.equal(200);
            expect(res.body).to.deep.equal({ results: mockResults });
    
            expect(connectStub.calledOnce).to.be.true;
            expect(queryStub.calledOnce).to.be.true;
            expect(disconnectStub.calledOnce).to.be.true;
    
            done(); 
          });
      });

      it('should handle database error', (done) => {
        const errorMessage = 'Database error';
        queryStub.yields(new Error(errorMessage), null);
    
        chai.request(app)
          .get('/getChallenges')
          .end((err, res) => {
            expect(res.status).to.equal(500);
            expect(res.body).to.deep.equal({ error: 'Error getting challenges.' });
    
            expect(connectStub.calledOnce).to.be.true;
            expect(queryStub.calledOnce).to.be.true;
            expect(disconnectStub.calledOnce).to.be.true;
    
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

  