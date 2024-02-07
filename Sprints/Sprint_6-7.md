# Sprint 6-7

### Sprint Goals
- [x] Vehicle to SQL Database
- [x] Local Storage (UserID) + Vehicle Info
- [x] Test Server Routes
- [x] Manual UI Update + Manual API Calculation 
- [ ] Connect points SQL tables
- [x] Complete Leaderboard Page
- [x] Design Application Icon

---
### Local Storage Proccesses
* Stored in SharedUserPreferences
* User information is set on login, which can be retrieved on any page 

---
### Unit Test Details
* Used Chai and Sinon packages to test the server routes
* Use assert to check if the expected response was thrown given mocked data
* No calls to the database nor Carbon API happen in tests
  
---
### Leaderboard
* Leaderboard is at a UI only stage
  
---
### App Icon / Splash
* Designed in Inkscape, now a part of the project

---
### Points
* Canceled this task - use AcceptedChallenges as it's the only source of points at the moment
* Points is now displayed on the home page instead of the status bar

---
### Functioning Vehicle and Manual Input Pages
* Moved from UI only to functioning
* User can have up to 2 vehicles as to not spend too many of our API calls
* Vehicle information includes Make, Model, Year, Mileage, and Nickname
* Manual Input page takes in current mileage, if a user enters number of miles driven they will get an error

---
### Sprint Retrospective
* Ran into a lot of problems near the end with individuals uploading directly to development
* User Testing helped guide some quality updates

