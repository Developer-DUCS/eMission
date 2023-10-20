# Sprint 4

### Sprint Goals
- [ ] Update Home and Manual UI
- [ ] Restructure NodeJS backend
- [ ] Implement MySQL table connection to application
- [ ] Dockerize Flutter Application
- [ ] Design Application Icon
- [ ] Legal Notes
- [ ] Redefine Target Market
- [ ] Build Challenge Groups Page
- [ ] Build Create Account Page
- [ ] Sprint 4 Review
---

### NodeJS Calls and Routes
* something
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
* something here aswell
  
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
"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
