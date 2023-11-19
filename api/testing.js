const express = require('express');
const { Database } = require('./sql_db_man');
const vehicleMakes = require('./VehicleMakes.json');
const PORT = 3000;
const axios = require('axios');
const chai = require('chai');
const sinon = require('sinon');
const chaiHttp=require('chai-http');
const app = require('./server.js');

const expect = chai.expect;
chai.use(chaiHttp);

const dbconfig = {
    host:     "mcs.drury.edu",
    port:     "3306",
    user:     "emission",
    password: "Letmein!eCoders",
    database: "emission"
};

describe('Test /insertUser', () => {
    console.log(Database);
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
      console.log(userData.email);
  
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
              console.log("Second request results:", res.body);
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
          console.log("Error request results:", res.body);
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
    console.log(Database);
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

    it('user is succesfully authenticated.', (done)=>{

        const validLoginData = {
          email: 'test@example.com',
          password: 'password123'
        };
    
        const queryResult = [
          { email: 'test@example.com', password: 'password123' }
        ];
    
        queryStub.callsArgWith(2, null, queryResult);
    
        chai.request(app)
          .post('/authUser')
          .send(validLoginData)
          .end((err, res) => {
            expect(res).to.have.status(200);
            expect(res.body).to.deep.equal({ msg: 'Authentication Successful' });
    
            sinon.assert.calledWith(
              queryStub,
              'SELECT email, password FROM emission.Users WHERE email = ?',
              validLoginData.email
            );
    
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
            console.log("Error request results:", res.body); 
            expect(res).to.have.status(401);
            expect(res.body).to.deep.equal({ msg: 'Authentication Failed' });

            sinon.assert.calledWith(
              queryStub,
              'SELECT email, password FROM emission.Users WHERE email = ?',
              invalidLoginData.email
            );

            done();
          });
      });

      it('should return an "Server Error" message for invalid credentials', (done) => {
        const invalidLoginData = {
          email: 'test@example.com',
          password: 'wrongpassword'
        };

        queryStub.callsArgWith(2, null, []);

        chai.request(app)
          .post('/authUser')
          .send(invalidLoginData)
          .end((err, res) => {
            console.log("Error request results:", res.body); 
            expect(res).to.have.status(500);

            sinon.assert.calledWith(
              queryStub,
              'SELECT email, password FROM emission.Users WHERE email = ?',
              invalidLoginData.email
            );

            done();
          });
      });
  


  });