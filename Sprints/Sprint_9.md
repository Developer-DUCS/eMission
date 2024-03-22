# Sprint 9: Verification Planning

### Sprint Goals
- [ ] Complete Product License
- [X] Draft Test Plan w/ Requirements
- [X] Make Leaderboard Interactive
- [X] Design GPS/Map Technologies
- [X] Deployment Strategies w/ Sigman
- [X] Review Emission Calculation
- [X] Review Point C02 Score Calculation & Point Strategy
- [X] Merging Development Codebase

---

### Draft Test Plan
* Understanding what it means to be finished means testing against requirements. The focus here is on acceptance testing. 

**Development**
  * Create a series of tests for the more important functions of our applications
  * Includes Account Creation, Login, Manual Input, Add Vehicle.

**Test**
  * Run the tests, making sure each one is robust and covers as many possibilities as is reasonable.
  * Cover most common use cases, and cases that could break things such as 0,1,-1,null,etc.

**DEBUG**
* Find and resolve issues that arise from failed tests, adjust/add/remove test as needed.

**Decision**
  * Decide if passed tests are sufficient in determinining the completeness of the application.
  * If not, find what changes are required to determine application completeness
    
**Deadline**
* The first project deadline is on March 20th at the end of Sprint 9. This date marks the Beta release for the product and requires the primary features to be complete.
* The second deadline is on May 1st at the end of Sprint 15. This date marks the Final release of the product. Deployment, testing and documentation will be the focus of this sprint. Any additions to the codebase should only be bug fixes. 

**Done**
* Table below outlines the user stories necessary to be considered “done”. Any user stories not in the first column are either not necessary or are recognized as stretch goals.



---
### Deployment Strategies

**Design Decisions** 
* To preserve space on the MCS Server, we've decided to separate the api & server files from the codebase and make them it's own branch. This branch will be cloned onto the server and it will expose the necessary port for the application to run. 

**MCS Server Connection**
1. ssh into the mcs server
2. clone & run server.
3. pm2 to run on mcs port.


**Server Management**
* We will use PM2 to manage our emission service running on the mcs server. 


---
### Updated Leaderboard Page
* The leaderboard will now be interactive, allowing accounts that show up to be ranked based on their points. 


---
### GPS/Map Technologies
* GPS and map technologies are implemented using the [Flutter Geolocator Plugin](https://pub.dev/packages/geolocator)

* This package will track the user's location during their drive. The distance will be used to calculate the user's carbon footprint. The Geolocator is designed to only be used when a drive has been started.  


---
### Sprint Retrospective
* In this sprint, the team discussed and planned what our finished product will look like. This included dividing user stories by their level of importance and deciding which ones must be done to say our product is done. The Draft Test Plan outlines the iterative processes used ensure all necesssary user stories are satisfied. While unit testing was the primary form of debugging and development, acceptance testing will be the next step for this process.
  
* This sprint also saw the inception of a deployment strategy w/ the help of Professor Sigman. With his help, we were able to connect our server and application to the MCS server and run it aswell. Our next steps will be to streamline this processes by splitting our server and app branches and refactoring our codebase.
  
* GPS/Map Technologies were implemented using the Flutter Geolocator Plugin. This package allows the application to track the location of the user when they are using the driving features.
  
* Our leaderboard page experienced an update primarily in it's functionality. The page is interactive, constantly checking for the highest scores amongst the users and displaying the one in first place. 
---
