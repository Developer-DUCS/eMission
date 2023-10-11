CREATE DATABASE `EmissionDatabase` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

CREATE TABLE `Cars` (
  `owner` int NOT NULL,
  `make` varchar(45) NOT NULL,
  `model` varchar(45) NOT NULL,
  `year` varchar(45) NOT NULL,
  `carID` int NOT NULL AUTO_INCREMENT,
  `carName` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`carID`),
  UNIQUE KEY `carID_UNIQUE` (`carID`),
  KEY `owner_idx` (`owner`),
  CONSTRAINT `owner` FOREIGN KEY (`owner`) REFERENCES `Users` (`userID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `Challenges` (
  `challengeID` int NOT NULL,
  `points` int NOT NULL,
  `description` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`challengeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `Points` (
  `pointID` int NOT NULL,
  `pointTotal` int NOT NULL,
  `pointType` varchar(45) NOT NULL,
  `pointTypeID` varchar(45) NOT NULL,
  `earnerID` int NOT NULL,
  PRIMARY KEY (`pointID`),
  KEY `earnerID_idx` (`earnerID`),
  CONSTRAINT `earnerID` FOREIGN KEY (`earnerID`) REFERENCES `Users` (`userID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `Users` (
  `userID` int NOT NULL AUTO_INCREMENT,
  `email` varchar(45) NOT NULL,
  `password` varchar(45) NOT NULL,
  `profilePicture` varchar(45) DEFAULT NULL,
  `levelStatus` varchar(45) NOT NULL,
  `firstName` varchar(45) NOT NULL,
  `lastName` varchar(45) NOT NULL,
  PRIMARY KEY (`userID`),
  UNIQUE KEY `userID_UNIQUE` (`userID`),
  UNIQUE KEY `email_UNIQUE` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `emissiondatabase`.`pointtypeview` AS select `emissiondatabase`.`points`.`pointTypeID` AS `pointTypeID`,`emissiondatabase`.`points`.`pointType` AS `pointType` from `emissiondatabase`.`points`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `emissiondatabase`.`userpoints` AS select sum(`emissiondatabase`.`points`.`pointTotal`) AS `sumPoints`,`emissiondatabase`.`points`.`earnerID` AS `earnerID`,`emissiondatabase`.`users`.`email` AS `email` from (`emissiondatabase`.`points` join `emissiondatabase`.`users` on((`emissiondatabase`.`points`.`earnerID` = `emissiondatabase`.`users`.`userID`)));
