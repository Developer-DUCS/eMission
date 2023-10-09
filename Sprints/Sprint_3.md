# Sprint 3

### Sprint 3 Goals
- [ ] Design/Implement Backend Infrastructure (Nodejs)
- [ ] Investigate DevOps Technologies (Docker)
- [X] Investigate Ability to Allow Direct Device Testing
- [ ] Merge Splash Screen & Login Page
- [X] Designing SQL Tables (MySQL)
- [X] SSH Server Connection
- [ ] Leaderboard Page
- [ ] Mileage Input Page
- [X] Carbon Report Page
- [ ] Settings Subpages 
- [X] Sprint 3 Midterm Video Presentation



## Backend Infrastructure

### NodeJS Server
The application's backed server will be built using Nodejs. Make sure to install Node using Homebrew (MacOS) or Chocolatey (Windows). The project relies on Node version 18.18.0 and npm version 9.8.1. 

* [Install Node](https://nodejs.org/en/download)

1. To Create the Node environment on your machine use ```npm init``` in the project folder.
   1. This will create your package.json file and confirm any important dependencies (express)
2. Create your _server.js_ file and use express to create the example server here: [Node-to-Flutter](https://thiagoevoa.medium.com/creating-an-end-to-end-project-from-node-js-backend-to-flutter-app-a8df8ffdde5b)
3. To test your app, run ```npm start``` in your terminal

**_Note_**: Details for these steps are outlined in the resources below. 

**Helpful Resources**
- [freeCodeCamp - Video](https://www.youtube.com/watch?v=ylJz7N-dv1E)
- [Node-to-Flutter](https://thiagoevoa.medium.com/creating-an-end-to-end-project-from-node-js-backend-to-flutter-app-a8df8ffdde5b)


---
### SSH Server Connection
* Connection to MCS Server is required for installation and setup of Docker & MySQL

**Helpful Resources**
* Windows Installation: https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse?tabs=gui
* Mac Installation: https://jumpcloud.com/blog/how-to-enable-ssh-mac

---
### Initial SQL Tables Design

<img width="626" alt="Screenshot 2023-10-08 at 9 37 25 PM" src="https://github.com/Developer-DUCS/eMission/assets/78003140/9f949e8c-32de-4e38-aee5-a0d2bc0e7e26">


**Helpful Resources**
- run the sudo /usr/local/mysql/support-files/mysql.server start 
- mysql@8.0 for work with mysqlworkbench
- [install mysql guide](https://medium.com/@imamun/installing-a-local-mysql-server-bdfb0af88666)

---
### DevOps Technologies (Docker)
#### Installation & Setup
1. Install Docker Desktop on your Machine
   - Be sure to choose the correct platform for installation.
   - [install docker](https://docs.docker.com/get-docker/)
  
**_Note_**: Windows users will need to Download WSL 2 backend prior to installing Docker Desktop.

2. Open Docker 
   - After restarting your machine, open the docker desktop application to begin using/editing images & containers.
3. Editor Extensions
   - Install the helpful Docker extensions for whatever code editor you are using (Vuses Docker
     - plugin for Android Studio and VSCode is called _Docker_.
4. Downloading Docker Parent Image
   - Open Docker Hub (link in resources) and click on _Explore_ in the top right corner.
   - Open search bar and type in  _node_.
   - Click on the Node _Docker Official Image_ result
   - **_Note_**: We will need to specify which version of node and which linux distribution we want in our image.
   - type and run ```docker pull node``` in a terminal. 


#### Starting Project Container
1. Finding Docker Hub Repository
   -  Lorem ipsum
2. Pull image from Repository 
   - Lorem ipsum
3. Run Docker Image
   - Lorem ipsum


**Helpful Resources**
- [Docker Hub](https://hub.docker.com/)
- [Docker Docs](https://docs.docker.com/)
- [Docker Crash Course](https://www.youtube.com/watch?v=31ieHmcTUOk&list=PL4cUxeGkcC9hxjeEtdHFNYMtCpjNBm3h7&index=1)


---
### Direct-to-Device Testing
* We've successfully tested our application on an apple device. Further research is requrired for Android testing.


---
### Sprint 3 Screens
* [Carbon Report Page](https://github.com/Developer-DUCS/eMission/wiki/App-Screens-Documentation#carbon-report-page)
* [Leaderboard Page](https://github.com/Developer-DUCS/eMission/wiki/App-Screens-Documentation#leaderboard-page)
* [Mileage Input Page](https://github.com/Developer-DUCS/eMission/wiki/App-Screens-Documentation#manual-drive-input-page)
* [Settings Subpages](https://github.com/Developer-DUCS/eMission/wiki/App-Screens-Documentation#settings-page)
---
### Sprint 3 Retrospective
"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
