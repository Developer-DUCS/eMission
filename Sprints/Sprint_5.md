# Sprint 5: API Testing & Redesign

### Sprint Goals
- [X] Connect API Routes & Carbon Interface

      getModelID
      getVehicleID
      make call on manual input page or drive button
- [X] Make API route for Challenge Page

      /getChallenges on page load from the SQL database
      Future updates include only getting the challenges that haven't been accepted
      /completeChallenges complete selected on my challenges page
      /getUserChallenges get the challenges the user has accepted
      Update Challenge Page Frontend
- [X] Make API route for User Authentication

      update login page
      clear text compare
- [X] Password Encryption
- [X] Create insert vehicle info page

      /insertCarInfo to SQL table
      update SQL
- [ ] Update Manual Input Page
- [ ] Complete Leaderboard Page
- [ ] Design Application Icon
- [X] Meet with Business/Legal Professor
- [ ] Complete Legal Notes
- [ ] Research/Begin Unit Testing
- [X] Sprint 5 Review
---

### API Calls

#### Completed API Calls
* /getMakeID - completed in Sprint 4
* /vehicleCarbonReport - takes vehicleID and amount driven info as input, completed in Sprint 4
* /authUser - authenticates users trying to login to the application, completed in Sprint 5
* /getModelID
* /getChallenges
* /acceptChallenges
* NOTE - error handling may not be implemented yet

**_Note_**: Any API calls not completed in this sprint will be pushed to Sprint 6.


---
### Password Encryption
* Using Crypto flutter package
  * [crypto dart package](https://pub.dev/packages/crypto)
* Updates every 6-12 months

**Supports the following hashing algorithms**
* SHA-1
* SHA-224
* SHA-256
* SHA-384
* SHA-512
* SHA-512/224
* HD5
* HMAC (i.e. HMAC-MD5, HMAC-SHA1, HMAC-SHA256)


---
### Challenge Page UI Update
* Challenge Page now displays challenges that we put in the database
  * User can select a challenge to add it to their current challenges
* Past Challenge Page is now My Challenges
  * Selecting the challenge will complete the challenge
 
see page documentation
* [Updated Challenge Page]()

https://github.com/Developer-DUCS/eMission/assets/78006078/584e58a7-e894-4907-8f52-023bccd24eee


--- 
### Vehicle Management
* Page for managing a users vehicles
* UI is complete, needs to be connected with backend
* Next is to implement deleting and editing vehicles

see page documentation
* [Vehicle Management]()


---
### Sprint Retrospective
This sprint saw the completion of multiple routes and api calls that flesh out the functionality of the application. These calls include  ```/vehicleCarbonReport```, ```/authUser```, ```/getChallenges``` , just to name a few. In this sprint the challenge page and vehicle input pages were changed to accomodate the backend/database connection. We also implemented a password encryption system to secure our app traffic a little more. 
