# Sprint 10: Production Pipeline

### Sprint Goals
- [X] Complete Product License
- [X] Testing Leaderboard
- [X] Merge Sprint 9 Changes
- [X] Flutter UI Update (Darkmode and Stylesheet)
- [X] Flutter UI Testing Research

      * Widget Testing
- [ ] Deployment Configuration
      
      * GitHub Action
      * PM2 Server Management
- [X] Application Deployment Testing
- [ ] Make User Login Info Lowercase
---


### Flutter UI Update 
* The applications UI needed some revamping. This included color schemes, wigdets, a dark mode, and redesigning pages. 
  
#### Stylesheet
* A newly formed color scheme was created for the application, eliminating extreme contrast and enhancing user experience.
* Alongside this color scheme stylesheet is a darkmode per the user's requests 


#### App Screens
| Leaderboard Page |  Carbon Report page|
|--|--|
| <img width="150" alt="new_leadboard" src="https://github.com/Developer-DUCS/eMission/assets/78006078/1c63b499-7088-4c96-8cc6-99b8d013baa2">|  <img width="150" alt="new_report" src="https://github.com/Developer-DUCS/eMission/assets/78006078/ab1e25f2-12a5-4b2a-871f-3f6b71d099ba">|
---


### Flutter UI Testing Strategies
* Widget Testing Technologies
---

### Server Deployment
* **Github Action** will be used to streamline the testing and deploying process

Steps for action:
* Checkout server branch
* Run npm install
* Run npm test
* If tests pass, ssh into server
* Kill server
* Clone down server branch
* Start server
  

---



### Sprint Retrospective
* This sprint saw the optimization of our deployment and production pipeline. Improved tests and server connections were researched in order to implement a more robust application. Alongside the research was a massive UI update. Many pages (including the leaderboard and carbon report page) were changed to better support the intended functions and features. We also created a style sheet for the app with which we can efficiently change color schemes and implement a dark mode. The next sprint will prioritize beta testing and finalizing our deployment strategies alongside any remaining features that need to be completed. 
