# R&D-SemesterProject


## Project Description
&nbsp;&nbsp;The eMission’s project will consist of research and design for the carbon footprint application with an emphasis on an individual’s car emissions. We will identify a target market for our app and design its features around what our users would like to see in the app. Users are encouraged to actively participate in climate action and the problems associated with it. The rationale behind this project is that if individuals are more conscientious about their impact on the earth, the sustainability goal of climate action can also be encouraged.



## Installation & Setup

1. Install Android Studio, Visual Studio Code or any text editor of your choice.
   - Android Studio installation
   - Be sure to install the **Flutter** plugin after downloading Android Studio.
   - [install android studio](https://developer.android.com/studio)
   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**_Note_**: To run this application in VSCode (using emulator), you'll need to install two extensions (Android iOS Emulator & Fluter)

2. install git
   - click the link below, choose your operating system and follow the steps.
   - [install git](https://git-scm.com/downloads) 

3. install flutter
   - This project is written in and primarily uses flutter. To make changes to the codebase, you will need to install flutter onto your machine.
   - [install flutter](https://docs.flutter.dev/get-started/install)

4. Additional steps
   - Be sure to update Android Studio SDK Manager & Emulator by following the steps in the _install flutter_ link in step 3.
   - Accept Android Licenses
     - This can be done by typing the following into your command line. ``` flutter doctor --android-licenses ```


5. Testing
   - run ```flutter doctor``` in your commandline interface
   - This will let you know if flutter is properly installed and list any issues that need to be resolved. 


### Need more installation help?
**_installation video links_**
* installing flutter for macOS - [click me](https://www.youtube.com/watch?v=fzAg7lOWqVE)

* installing flutter for windows - [click me](https://www.youtube.com/watch?v=1ukSR1GRtMU&list=PL4cUxeGkcC9jLYyp2Aoh6hcWuxFDX6PBJ&index=2)



## Development
**_Note_**: These steps are for those who've completed the installation and setup steps above. 

1. Clone repository

```
$ git clone https://github.com/Developer-DUCS/eMission.git
 ```

2. Open Device Emulator
   1. **Android Studio**
      - Click Device Manager tab or icon (top right)
        - <img src="https://github.com/Developer-DUCS/eMission/assets/78006078/d9c92bd1-d49c-4a26-a8bf-cacf3c58b9c8" alt="android_device_manager" width="400" height="200"/>
        
      - Choose/Play Device emulator
        - <img src="https://github.com/Developer-DUCS/eMission/assets/78006078/241e6249-ea4c-40d6-b8ad-e02702bd3f97" alt="android_choose_device" width="400" height="200"/>
        
   2. **Visual Studio Code**
      - Click devices in VSCode (bottom right)
        * <img src="https://github.com/Developer-DUCS/eMission/assets/78006078/a2740e08-41db-4536-b8b6-537050ec16d6" alt="vscode_device_manager" width="400" height="200"/>
      - Choose a device emulator
        * <img src="https://github.com/Developer-DUCS/eMission/assets/78006078/10e69d95-522f-44cf-8a29-a3d1c86edad0" alt="vscode_choose_device" width="400" height="200"/>
      
3. Open command line in your local repository and run ``` flutter run ```



## Documentation
For an in-depth look at the processes, user stories, and progress thus far, take a look at the project documentation. 

[Project Wiki](https://github.com/Developer-DUCS/eMission/wiki)

<details><summary>Sprint Workflow</summary>

1. [Sprint 1](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_1.md)
   1. [Sprint Goals](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_1.md#sprint-1-goals)
   2. [Team Organization](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_1.md#team-organization)
      1. [Team Dynamics](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_1.md#team-dynamics)
      2. [Conflict Resolution](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_1.md#conflict-resolution)
      3. [Team Roles](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_1.md#roles-application-development)
   3. [Processes](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_1.md#processes)
      1. [Version Control](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_1.md#version-control)
      2. [Technologies](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_1.md#technology)
      3. [Tools](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_1.md#tools)
   4. [Sprint Retrospective](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_1.md#sprint-retrospective)
2. [Sprint 2](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_2.md)
   1. [Sprint Goals](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_2.md#sprint-2-goals)
   2. [Sprint 2 Screens](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_2.md#sprint-2-screens)
   3. [Additional Roles](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_2.md#additional-sprint-2-roles)
   4. [Sprint Retrospective](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_2.md#sprint-retrospective)
3. [Sprint 3](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_3.md) 
   1. [Sprint Goals](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_3.md#sprint-3-goals)
   2. [Sprint 3 Screens](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_3.md#sprint-3-screens)
   3. [Backend Infrastructure](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_3.md#backend-infrastructure)
      1. [NodeJS Server](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_3.md#nodejs-server)
      2. [SSH Server Connection](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_3.md#ssh-server-connection)
      3. [SQL Tables Design](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_3.md#sql-tables-design)
      4. [Docker (DevOps)](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_3.md#devops-technologies-docker)
         1. [Installation Guide](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_3.md#installation--setup)
         2. [Deployment Guide](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_3.md#starting-project-container)
   5. [Direct-to-Device Testing](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_3.md#direct-to-device-testing)
   6. [Sprint Retrospective](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_3.md#sprint-3-retrospective)
4. [Sprint 4](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_4.md)
   1. [Sprint Goals](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_4.md#sprint-goals)
   2. [API Calls & SQL Tables](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_4.md#nodejs-calls-and-mysql-tables)
      1. [MySQL Database](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_4.md#mysql-database)
      2. [API Calls](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_4.md#api-calls)
   3. [Dockerfile](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_4.md#dockerfile--images--containers)
   4. [Legal Notes](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_4.md#legal-notes)
   5. [Target Market](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_4.md#target-market)
   6. [Sprint Retrospective](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_4.md#sprint-retrospective)
5. [Sprint 5](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_5.md)
   1. [Sprint Goals](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_5.md#sprint-goals)
   2. [Completed API Calls](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_5.md#api-calls)
   3. [Password Encryption](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_5.md#password-encryption)
   4. [Challenge Page UI Update](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_5.md#challenge-page-ui-update)
   5. [Vehicle Management](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_5.md#vehicle-management)
   6. [Sprint Retrospective](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_5.md#sprint-retrospective)
6. [Sprint 6-7](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_6-7.md)
   1. [Sprint Goals](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_6-7.md#sprint-goals)
   2. [Sprint Retrospective](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_6-7.md#sprint-retrospective)
7. [Sprint 8](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_8.md)
   1. [Sprint Goals](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_8.md#sprint-goals) 
   2. [Workflow & Project Board](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_8.md#workflow--project-board-updates)
   3. [Sprint Retrospective](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_8.md#sprint-retrospective)
8. [Sprint 9](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_9.md)
    1. [Sprint Goals](https://github.com/Developer-DUCS/eMission/blob/main/Sprints/Sprint_9.md#sprint-goals)
9. [Sprint 10]


</details>
   



## Helpful Links
* [flutter documentation](https://docs.flutter.dev/)
* [dart documentation](https://dart.dev/guides)
* [android studio documentation](https://developer.android.com/docs)
* [git documentation](https://git-scm.com/doc)
