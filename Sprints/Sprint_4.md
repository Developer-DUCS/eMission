# Sprint 4

### Sprint Goals
- [X] Update Home and Manual UI
- [X] Restructure NodeJS backend
- [X] Implement MySQL table connection to application
- [X] Dockerize Flutter Application
- [ ] Design Application Icon
- [X] Legal Notes
- [X] Redefine Target Market
- [ ] Build Challenge Groups Page
- [ ] Build Create Account Page
- [X] Sprint 4 Review
---

### NodeJS Calls and MySQL Tables

#### MySQL Database
* Current table count: 5
  * Users
  * Challenges
  * Cars
  * Points
  * AcceptedChallenges
* Current view Count: 2
  * pointType - see pointType and pointTypeID, where pointID can be treated as the primary key for earner (userID) and pointType
  * userpoints - current points calculated for each user, where the Points table is all users and all points earned
<img src="https://github.com/Developer-DUCS/eMission/assets/78006078/35124b10-8706-471a-b14e-fc0bf3ba1b66" alt="emission_sql" width="400" height="500"/>


#### API Calls

* Complete: insert user to the Users table
  * Work to be done: input verification, password encryption
* Used sql_db_man.js to create a method to connect, disconnect, and query to the SQL database
* Proof of concepts stages - using one car manufacturer to limit API calls to lookup make/model IDs
* /makeID - get makeID from a list of one type of model - currently stored in json format to save on our free monthly API calls
* /vehicleCarbonReport - get carbon report from vehicleID, distance unit, distance driven
  * Work to be done: implement using the user's own car information
  * Create /modelID to get list of models
 
<img src="https://github.com/Developer-DUCS/eMission/assets/78006078/b4c6eef1-c456-4a73-b74a-9821fcd8c368" alt="api_call" width="900" height="200"/>


---
### Dockerfile- Images & Containers
* The application's Dockerfile will be responsible for installing all necessary technologies and dependencies for running a container. The image builds on
the Ubuntu (version 20.04) image and uses that linux environment to create the project environment. The following are a list of the technologies installed:
  * Android SDK
  * Gradle
  * Flutter
  * Chrome WebDriver (used to run the app in chrome)
  * Additional dependencies (openJDK, git, ssh, cmake, etc)
  
* Lastly, the Dockerfile clones this github repository before running the application.

**Starting Project Container**
1. Finding Docker Hub Repository
   -  Login to Docker Hub and find the project image repository
2. Pull image from Repository 
   - Use the command on this page to pull the image to your local machine
3. Run Docker Image
   - Use ```docker run``` to run image as a container.
     - More specifically use: ```docker run --name <NEW_CONTAINER_NAME> -d -p <LOCAL_PORT:APP_PORT> <IMAGE_NAME>``` to ensure your local machine is looking out for the correct port used by the application.

**_Note_**: ensure docker desktop is running before you run your container. Docker will not work otherwise. 


---
### Legal Notes
* [Terms and Conditions](https://github.com/Developer-DUCS/eMission/wiki/Product-Legal-Notes#terms-and-conditions)

**_Note_**: These terms and conditions should appear in our application. Preferably right after creating an account where they can accept any terms. 

---
### Application Icon

**_Note_**: Design for Application Icon moved to Sprint 5
  
---
### Target Market 
* Environmentally conscious millennials (& Gen Z) who are concerned about their role in climate change. 
* Primary users will most likely live in urban and suburban areas and already practice environmentally friendly habits. (Recycling, Vegetarians, Waste Reduction, Biking)
* The S.E.S (Socio-economic status) of our target market will be middle and upper middle class individuals. People who can afford to make and pursue healthier lifestyle changes.
* To thrive in this application, the ideal user is competitive enough to engage in friendly climate-based challenges.
* They will also be regular social media users, eager to share their environmental accomplishments with like-minded people.  
* We plan to reach out to environmental groups like ThinkGreen to test the application.
  
---
### Sprint Retrospective
Sprint 4 picks up where the previous sprint left off with the backend design and implementation. 

* Both the primary API calls and MySQL Tables were created.
* Dockerfile was created and application was Dockerized
* Product Legal Notes were created
* Target Market was redefined

Backend Server connections and API routes will be the focus of Sprint 5, leading us to a Minimum Viable Product that can be tested. Until this is complete, Docker developing will be put on hold. 
