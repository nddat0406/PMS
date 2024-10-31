-- MySQL dump 10.13  Distrib 8.0.38, for Win64 (x86_64)
--
-- Host: localhost    Database: pms
-- ------------------------------------------------------
-- Server version	8.0.39

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `allocation`
--

DROP TABLE IF EXISTS `allocation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `allocation` (
  `userId` int NOT NULL,
  `projectId` int NOT NULL,
  `startDate` date NOT NULL,
  `endDate` date DEFAULT NULL,
  `effortRate` int DEFAULT '0',
  `status` bit(1) NOT NULL DEFAULT b'1',
  `id` int NOT NULL AUTO_INCREMENT,
  `role` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Allocation_has_User_idx` (`userId`),
  KEY `Allocation_of_Project_idx` (`projectId`),
  KEY `Role_of_domainsetting_idx` (`role`),
  CONSTRAINT `Allocation_has_User` FOREIGN KEY (`userId`) REFERENCES `user` (`id`),
  CONSTRAINT `Allocation_of_Project` FOREIGN KEY (`projectId`) REFERENCES `project` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `allocation`
--

LOCK TABLES `allocation` WRITE;
/*!40000 ALTER TABLE `allocation` DISABLE KEYS */;
INSERT INTO `allocation` VALUES (4,21,'2023-01-01',NULL,100,_binary '',1,1),(4,22,'2024-09-01','2025-02-01',60,_binary '',2,NULL),(4,26,'2023-06-01','2023-11-01',50,_binary '',3,NULL),(4,27,'2025-02-01','2025-07-01',80,_binary '',4,NULL),(4,31,'2023-11-01','2024-04-01',70,_binary '',5,NULL),(4,36,'2024-04-01','2024-09-01',90,_binary '',6,NULL),(5,21,'2023-02-01','2023-07-01',80,_binary '',7,2),(5,22,'2024-10-01','2025-03-01',90,_binary '',8,NULL),(5,27,'2023-07-01','2023-12-01',100,_binary '',9,NULL),(5,28,'2025-03-01','2025-08-01',60,_binary '',10,NULL),(5,32,'2023-12-01','2024-05-01',50,_binary '',11,NULL),(5,37,'2024-05-01','2024-10-01',70,_binary '',12,NULL),(6,21,'2023-03-01','2023-08-01',60,_binary '',13,3),(6,24,'2024-11-01','2025-04-01',70,_binary '',14,NULL),(6,28,'2023-08-01','2024-01-01',80,_binary '',15,NULL),(6,29,'2025-04-01','2025-09-01',90,_binary '',16,NULL),(6,33,'2024-01-01','2024-06-01',100,_binary '',17,NULL),(6,38,'2024-06-01','2024-11-01',50,_binary '',18,NULL),(7,21,'2023-04-01','2023-09-01',90,_binary '',19,4),(7,25,'2024-12-01','2025-05-01',50,_binary '',20,NULL),(7,22,'2025-05-01','2025-10-01',70,_binary '',22,NULL),(7,34,'2024-02-01','2024-07-01',80,_binary '',23,NULL),(7,39,'2024-07-01','2024-12-01',100,_binary '',24,NULL),(8,21,'2023-05-01','2023-10-01',70,_binary '',25,5),(8,22,'2025-01-01','2025-06-01',100,_binary '',26,NULL),(8,30,'2023-10-01','2024-03-01',90,_binary '',27,NULL),(8,31,'2025-06-01','2025-11-01',50,_binary '',28,NULL),(8,35,'2024-03-01','2024-08-01',60,_binary '',29,NULL),(8,40,'2024-08-01','2025-01-01',80,_binary '',30,NULL);
/*!40000 ALTER TABLE `allocation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `defect`
--

DROP TABLE IF EXISTS `defect`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `defect` (
  `id` int NOT NULL AUTO_INCREMENT,
  `requirementId` int NOT NULL,
  `projectId` int NOT NULL,
  `serverityId` int NOT NULL,
  `title` varchar(50) NOT NULL,
  `leakage` bit(1) NOT NULL DEFAULT b'0',
  `details` varchar(500) DEFAULT NULL,
  `duedate` date DEFAULT NULL,
  `status` tinyint DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `Defect_of_requirement_idx` (`requirementId`),
  KEY `Defect_serveriry_idx` (`serverityId`),
  KEY `Defect_of_project_idx` (`projectId`),
  CONSTRAINT `Defect_of_project` FOREIGN KEY (`projectId`) REFERENCES `project` (`id`),
  CONSTRAINT `Defect_of_requirement` FOREIGN KEY (`requirementId`) REFERENCES `requirement` (`id`),
  CONSTRAINT `Defect_serveriry` FOREIGN KEY (`serverityId`) REFERENCES `setting` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `defect`
--

LOCK TABLES `defect` WRITE;
/*!40000 ALTER TABLE `defect` DISABLE KEYS */;
/*!40000 ALTER TABLE `defect` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `department_user`
--

DROP TABLE IF EXISTS `department_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `department_user` (
  `userId` int NOT NULL,
  `departmentId` int NOT NULL,
  `id` int NOT NULL AUTO_INCREMENT,
  `fromDate` date NOT NULL,
  `toDate` date DEFAULT NULL,
  `status` bit(1) NOT NULL,
  `role` varchar(45) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Department_of_User_idx` (`departmentId`),
  KEY `User_of_Department_idx` (`userId`),
  CONSTRAINT `Department_of_User` FOREIGN KEY (`departmentId`) REFERENCES `group` (`id`),
  CONSTRAINT `User_of_Department` FOREIGN KEY (`userId`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department_user`
--

LOCK TABLES `department_user` WRITE;
/*!40000 ALTER TABLE `department_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `department_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_setting`
--

DROP TABLE IF EXISTS `domain_setting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `domain_setting` (
  `id` int NOT NULL,
  `type` tinyint NOT NULL,
  `name` varchar(50) NOT NULL,
  `details` varchar(500) DEFAULT NULL,
  `priority` tinyint NOT NULL DEFAULT '1',
  `domainId` int NOT NULL,
  `status` bit(1) NOT NULL DEFAULT b'1',
  `value` tinyint DEFAULT NULL,
  `typedetails` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`,`type`),
  KEY `Setting_of_Domain_idx` (`domainId`),
  CONSTRAINT `Setting_of_Domain` FOREIGN KEY (`domainId`) REFERENCES `group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_setting`
--

LOCK TABLES `domain_setting` WRITE;
/*!40000 ALTER TABLE `domain_setting` DISABLE KEYS */;
INSERT INTO `domain_setting` VALUES (1,2,'Project Coordinator','Project A project coordinator helps the project manager and team members with administrative tasks related to the project',1,6,_binary '',NULL,NULL),(1,3,'Budget Constraints','One of the major challenges that involve project management is to stay within budget.',1,6,_binary '',NULL,NULL),(2,2,'Business analysis','Business analysis is a professional discipline focused on identifying business needs and determining solutions to business problems.',1,6,_binary '',NULL,NULL),(2,3,'Scope Creep.','Scope creep is one of the typical issues associated with project management. ',1,6,_binary '',NULL,NULL),(3,2,'Steering committee','Steering committee. Project teams are like a ship, and the steering committee is the captain. ',1,6,_binary '',NULL,NULL),(3,3,'Bug','A bug is a problem which impairs or prevents the functions of a product.',1,6,_binary '',NULL,NULL),(4,2,'Stakeholders','Stakeholders – the interested parties. Unlike other roles in the team, stakeholders include a broad scope of people, internal or external to the project',1,6,_binary '',NULL,NULL),(4,3,'IT help','Requesting help for an IT related problem',1,6,_binary '',NULL,NULL),(5,2,'Member','Project team members. A project team comprises people with different skills and roles in a project',1,6,_binary '',NULL,NULL),(5,3,'New feature','Requesting new capability or software feature.',1,6,_binary '',NULL,NULL);
/*!40000 ALTER TABLE `domain_setting` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_user`
--

DROP TABLE IF EXISTS `domain_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `domain_user` (
  `id` int NOT NULL,
  `userId` int NOT NULL,
  `domainId` int NOT NULL,
  `status` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`id`),
  KEY `Domain_of_User_idx` (`domainId`),
  KEY `User_of_Domain_idx` (`userId`),
  CONSTRAINT `Domain_of_User` FOREIGN KEY (`domainId`) REFERENCES `group` (`id`),
  CONSTRAINT `User_of_Domain` FOREIGN KEY (`userId`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_user`
--

LOCK TABLES `domain_user` WRITE;
/*!40000 ALTER TABLE `domain_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `domain_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `group`
--

DROP TABLE IF EXISTS `group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(10) NOT NULL,
  `name` varchar(50) NOT NULL,
  `details` varchar(200) DEFAULT NULL,
  `parent` int DEFAULT NULL,
  `status` tinyint(1) NOT NULL,
  `type` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_code` (`code`),
  UNIQUE KEY `unique_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `group`
--

LOCK TABLES `group` WRITE;
/*!40000 ALTER TABLE `group` DISABLE KEYS */;
INSERT INTO `group` VALUES (1,'dep1','Exercute Office','dept1 details',NULL,1,0),(2,'dept2','IT Office','dept2 details',1,1,0),(3,'dept3','Finance Office','dept3 details',1,1,0),(4,'dept4','HR Office','dept4 details',1,1,0),(5,'dept5','Resource Office','dept5 details',2,1,0),(6,'D001','DataCorp','Details about DataCorp...',NULL,1,1),(7,'D002','DevSolutions','Details about DevSolutions',NULL,1,1),(8,'D003','DesignHub','Details about DesignHub',NULL,1,1),(9,'D004','DigiTech','Details about DigiTech',NULL,1,1),(10,'D005','DynamicSys','Details about DynamicSys',NULL,1,1);
/*!40000 ALTER TABLE `group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `issue`
--

DROP TABLE IF EXISTS `issue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `issue` (
  `id` int NOT NULL AUTO_INCREMENT,
  `requirementId` int NOT NULL,
  `projectId` int NOT NULL,
  `title` varchar(50) DEFAULT NULL,
  `details` varchar(500) DEFAULT NULL,
  `type` int NOT NULL,
  `status` tinyint DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `Issue_of_requirement_idx` (`requirementId`),
  KEY `Issue_of_type_idx` (`type`),
  KEY `Issue_of_project_idx` (`projectId`),
  CONSTRAINT `Issue_of_project` FOREIGN KEY (`projectId`) REFERENCES `project` (`id`),
  CONSTRAINT `Issue_of_requirement` FOREIGN KEY (`requirementId`) REFERENCES `requirement` (`id`),
  CONSTRAINT `Issue_of_type` FOREIGN KEY (`type`) REFERENCES `domain_setting` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `issue`
--

LOCK TABLES `issue` WRITE;
/*!40000 ALTER TABLE `issue` DISABLE KEYS */;
/*!40000 ALTER TABLE `issue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `milestone`
--

DROP TABLE IF EXISTS `milestone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `milestone` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `priority` tinyint NOT NULL,
  `details` varchar(500) DEFAULT NULL,
  `endDate` date NOT NULL,
  `status` tinyint NOT NULL DEFAULT '1',
  `deliver` varchar(500) NOT NULL,
  `projectId` int NOT NULL,
  `phaseId` int NOT NULL,
  `isFinal` bit(1) DEFAULT b'0',
  PRIMARY KEY (`id`),
  KEY `Projects_Milestone_idx` (`projectId`),
  KEY `Phase_Milestone_idx` (`phaseId`),
  CONSTRAINT `Phase_Milestone` FOREIGN KEY (`phaseId`) REFERENCES `projectphase` (`id`),
  CONSTRAINT `Projects_Milestone` FOREIGN KEY (`projectId`) REFERENCES `project` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `milestone`
--

LOCK TABLES `milestone` WRITE;
/*!40000 ALTER TABLE `milestone` DISABLE KEYS */;
INSERT INTO `milestone` VALUES (1,'Requirement Gathering',1,'Gathering all the requirements for the project.','2024-01-10',1,'Requirement document',21,1,_binary '\0'),(2,'Design Phase',2,'Designing system architecture and database schema.','2024-02-15',1,'Design Document',21,2,_binary '\0'),(3,'Development Phase',3,'Developing core functionalities.','2024-04-01',1,'Working prototype',21,3,_binary '\0'),(4,'Testing Phase',1,'Performing various tests to ensure the quality of the product.','2024-05-15',1,'Test Cases',21,4,_binary '\0'),(5,'Deployment Phase',2,'Deploying the system to the client environment.','2024-06-20',1,'Deployed application',21,5,_binary '\0'),(6,'Requirement Gathering',1,'Gathering all the requirements for the project.','2024-01-15',1,'Requirement document',22,1,_binary '\0'),(7,'Design Phase',2,'Designing system architecture and database schema.','2024-02-20',1,'Design Document',22,2,_binary '\0'),(8,'Development Phase',3,'Developing core functionalities.','2024-04-10',1,'Working prototype',22,3,_binary '\0'),(9,'Testing Phase',1,'Performing various tests to ensure the quality of the product.','2024-05-25',1,'Test Cases',22,4,_binary '\0'),(10,'Deployment Phase',2,'Deploying the system to the client environment.','2024-06-30',1,'Deployed application',22,5,_binary '\0'),(11,'Requirement Gathering',1,'Gathering all the requirements for the project.','2024-01-18',1,'Requirement document',23,1,_binary '\0'),(12,'Design Phase',2,'Designing system architecture and database schema.','2024-02-22',1,'Design Document',23,2,_binary '\0'),(13,'Development Phase',3,'Developing core functionalities.','2024-04-12',1,'Working prototype',23,3,_binary '\0'),(14,'Testing Phase',1,'Performing various tests to ensure the quality of the product.','2024-05-28',1,'Test Cases',23,4,_binary '\0'),(15,'Deployment Phase',2,'Deploying the system to the client environment.','2024-07-02',1,'Deployed application',23,5,_binary '\0'),(16,'Requirement Gathering',1,'Gathering all the requirements for the project.','2024-01-22',1,'Requirement document',24,1,_binary '\0'),(17,'Design Phase',2,'Designing system architecture and database schema.','2024-02-25',1,'Design Document',24,2,_binary '\0'),(18,'Development Phase',3,'Developing core functionalities.','2024-04-15',1,'Working prototype',24,3,_binary '\0'),(19,'Testing Phase',1,'Performing various tests to ensure the quality of the product.','2024-06-01',1,'Test Cases',24,4,_binary '\0'),(20,'Deployment Phase',2,'Deploying the system to the client environment.','2024-07-05',1,'Deployed application',24,5,_binary '\0'),(21,'Requirement Gathering',1,'Gathering all the requirements for the project.','2024-01-25',1,'Requirement document',25,1,_binary '\0'),(22,'Design Phase',2,'Designing system architecture and database schema.','2024-03-01',1,'Design Document',25,2,_binary '\0'),(23,'Development Phase',3,'Developing core functionalities.','2024-04-18',1,'Working prototype',25,3,_binary '\0'),(24,'Testing Phase',1,'Performing various tests to ensure the quality of the product.','2024-06-05',1,'Test Cases',25,4,_binary '\0'),(25,'Deployment Phase',2,'Deploying the system to the client environment.','2024-07-10',1,'Deployed application',25,5,_binary '\0'),(26,'Requirement Gathering',1,'Gathering all the requirements for the project.','2024-01-28',1,'Requirement document',26,1,_binary '\0'),(27,'Design Phase',2,'Designing system architecture and database schema.','2024-03-05',1,'Design Document',26,2,_binary '\0'),(28,'Development Phase',3,'Developing core functionalities.','2024-04-22',1,'Working prototype',26,3,_binary '\0'),(29,'Testing Phase',1,'Performing various tests to ensure the quality of the product.','2024-06-08',1,'Test Cases',26,4,_binary '\0'),(30,'Deployment Phase',2,'Deploying the system to the client environment.','2024-07-12',1,'Deployed application',26,5,_binary '\0'),(31,'Requirement Gathering',1,'Gathering all the requirements for the project.','2024-02-01',1,'Requirement document',27,1,_binary '\0'),(32,'Design Phase',2,'Designing system architecture and database schema.','2024-03-10',1,'Design Document',27,2,_binary '\0'),(33,'Development Phase',3,'Developing core functionalities.','2024-04-25',1,'Working prototype',27,3,_binary '\0'),(34,'Testing Phase',1,'Performing various tests to ensure the quality of the product.','2024-06-12',1,'Test Cases',27,4,_binary '\0'),(35,'Deployment Phase',2,'Deploying the system to the client environment.','2024-07-15',1,'Deployed application',27,5,_binary '\0'),(36,'Requirement Gathering',1,'Gathering all the requirements for the project.','2024-02-05',1,'Requirement document',28,1,_binary '\0'),(37,'Design Phase',2,'Designing system architecture and database schema.','2024-03-15',1,'Design Document',28,2,_binary '\0'),(38,'Development Phase',3,'Developing core functionalities.','2024-04-28',1,'Working prototype',28,3,_binary '\0'),(39,'Testing Phase',1,'Performing various tests to ensure the quality of the product.','2024-06-18',1,'Test Cases',28,4,_binary '\0'),(40,'Deployment Phase',2,'Deploying the system to the client environment.','2024-07-18',1,'Deployed application',28,5,_binary '\0'),(41,'Requirement Gathering',1,'Gathering all the requirements for the project.','2024-02-10',1,'Requirement document',29,1,_binary '\0'),(42,'Design Phase',2,'Designing system architecture and database schema.','2024-03-20',1,'Design Document',29,2,_binary '\0'),(43,'Development Phase',3,'Developing core functionalities.','2024-05-01',1,'Working prototype',29,3,_binary '\0'),(44,'Testing Phase',1,'Performing various tests to ensure the quality of the product.','2024-06-22',1,'Test Cases',29,4,_binary '\0'),(45,'Deployment Phase',2,'Deploying the system to the client environment.','2024-07-22',1,'Deployed application',29,5,_binary '\0'),(46,'Requirement Gathering',1,'Gathering all the requirements for the project.','2024-02-15',1,'Requirement document',30,1,_binary '\0'),(47,'Design Phase',2,'Designing system architecture and database schema.','2024-03-25',1,'Design Document',30,1,_binary '\0'),(48,'Milestone for Planning',1,'Generated milestone for phase: Planning','2024-12-13',0,'Default deliverable',42,1,_binary '\0'),(49,'Milestone for Analysis',2,'Generated milestone for phase: Analysis','2025-03-13',0,'Default deliverable',42,2,_binary '\0'),(50,'Milestone for Design',3,'Generated milestone for phase: Design','2025-07-26',0,'Default deliverable',42,3,_binary '\0'),(51,'Milestone for Development',4,'Generated milestone for phase: Development','2026-01-22',0,'Default deliverable',42,4,_binary '\0'),(52,'Milestone for Testing',5,'Generated milestone for phase: Testing','2026-09-04',0,'Default deliverable',42,5,_binary '\0');
/*!40000 ALTER TABLE `milestone` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project`
--

DROP TABLE IF EXISTS `project`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `project` (
  `id` int NOT NULL AUTO_INCREMENT,
  `bizTerm` int NOT NULL,
  `code` varchar(10) NOT NULL,
  `name` varchar(20) NOT NULL,
  `details` varchar(1000) DEFAULT '',
  `startDate` date NOT NULL,
  `status` tinyint NOT NULL,
  `departmentId` int NOT NULL,
  `domainId` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code_UNIQUE` (`code`),
  UNIQUE KEY `name_UNIQUE` (`name`),
  KEY `ProjectDepartmentManager_idx` (`departmentId`),
  KEY `ProjectDomain_idx` (`domainId`),
  CONSTRAINT `ProjectDepartmentManager` FOREIGN KEY (`departmentId`) REFERENCES `group` (`id`),
  CONSTRAINT `ProjectDomain` FOREIGN KEY (`domainId`) REFERENCES `group` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project`
--

LOCK TABLES `project` WRITE;
/*!40000 ALTER TABLE `project` DISABLE KEYS */;
INSERT INTO `project` VALUES (21,1,'C001','Project Phoenix','Details about Project Phoenix','2023-01-01',1,1,6),(22,2,'C002','AlphaWave','Details about AlphaWave','2023-02-01',1,2,7),(23,3,'C003','QuantumLeap','Details about QuantumLeap','2023-03-01',1,3,8),(24,4,'C004','CodeFusion','Details about CodeFusion','2023-04-01',1,4,9),(25,5,'C005','InnovateX','Details about InnovateX','2023-05-01',1,5,10),(26,3,'C006','Project Titan','Details about Project Titan','2023-06-01',1,1,6),(27,2,'C007','NeuralNet','Details about NeuralNet','2023-07-01',1,2,7),(28,1,'C008','SkyNet','Details about SkyNet','2023-08-01',1,3,8),(29,2,'C009','DeepBlue','Details about DeepBlue','2023-09-01',1,4,9),(30,3,'C010','Project Mercury','Details about Project Mercury','2023-10-01',1,5,10),(31,4,'C011','Project Apollo','Details about Project Apollo','2023-11-01',1,1,6),(32,1,'C012','Project Gemini','Details about Project Gemini','2023-12-01',1,2,7),(33,5,'C013','Project Orion','Details about Project Orion','2024-01-01',1,3,8),(34,1,'C014','Project Vega','Details about Project Vega','2024-02-01',1,4,9),(35,2,'C015','Project Sirius','Details about Project Sirius','2024-03-01',1,5,10),(36,3,'C016','Project Polaris','Details about Project Polaris','2024-04-01',1,1,6),(37,5,'C017','Project Andromeda','Details about Project Andromeda','2024-05-01',2,2,7),(38,5,'C018','Project Nebula','Details about Project Nebula','2024-06-01',3,3,8),(39,2,'C019','Project Cosmos','Details about Project Cosmos','2024-07-01',1,4,9),(40,1,'C020','Project Galaxy','Details about Project Galaxy','2024-08-01',1,5,10),(41,3,'C100','dat','                  123123              \r\n                            ','2024-10-27',1,3,6),(42,3,'C101','awdaw','                                                                                                                  123123              \r\n                            \r\n                            \r\n                            \r\n                            ','2024-10-29',1,3,6);
/*!40000 ALTER TABLE `project` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project_criteria`
--

DROP TABLE IF EXISTS `project_criteria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `project_criteria` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  `weight` tinyint NOT NULL,
  `projectId` int NOT NULL,
  `status` bit(1) NOT NULL DEFAULT b'1',
  `description` varchar(500) DEFAULT NULL,
  `milestoneId` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `criteria_of_project_idx` (`projectId`),
  KEY `Criteria_of_project_milestone_idx` (`milestoneId`),
  CONSTRAINT `criteria_of_project` FOREIGN KEY (`projectId`) REFERENCES `project` (`id`),
  CONSTRAINT `Criteria_of_project_milestone` FOREIGN KEY (`milestoneId`) REFERENCES `milestone` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=319 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_criteria`
--

LOCK TABLES `project_criteria` WRITE;
/*!40000 ALTER TABLE `project_criteria` DISABLE KEYS */;
INSERT INTO `project_criteria` VALUES (254,'dat',13,21,_binary '','Quality of the project documentation.\r\n',3),(255,'Bug Fixing',5,21,_binary '','Effort put into fixing reported bugs.',5),(256,'Code Quality',5,21,_binary '','Evaluate the overall code quality delivered by the team.',5),(257,'design',80,21,_binary '','Assess how well the tasks were completed in the milestone.',2),(258,'Teamwork',19,21,_binary '','Evaluate how well the team collaborated.',3),(259,'Documentation',6,21,_binary '','Quality of the project documentation.',2),(262,'Task Completion',8,21,_binary '','Assess how well the tasks were completed in the milestone.',2),(263,'Teamwork',7,21,_binary '','Evaluate how well the team collaborated.',3),(264,'Documentation',6,21,_binary '','Quality of the project documentation.',1),(265,'Bug Fixing',4,21,_binary '','Effort put into fixing reported bugs.',2),(266,'Code Quality',5,21,_binary '','Evaluate the overall code quality delivered by the team.',1),(267,'Task Completion',8,21,_binary '','Assess how well the tasks were completed in the milestone.',2),(268,'Teamwork',7,21,_binary '','Evaluate how well the team collaborated.',3),(269,'Documentation',6,21,_binary '','Quality of the project documentation.',1),(270,'Bug Fixing',4,21,_binary '','Effort put into fixing reported bugs.',2),(271,'Code Quality',5,21,_binary '','Evaluate the overall code quality delivered by the team.',1),(272,'Task Completion',8,21,_binary '','Assess how well the tasks were completed in the milestone.',2),(273,'Teamwork',7,21,_binary '','Evaluate how well the team collaborated.',3),(274,'Documentation',6,21,_binary '','Quality of the project documentation.',1),(275,'Bug Fixing',4,21,_binary '','Effort put into fixing reported bugs.',2),(276,'Code Quality',5,21,_binary '','Evaluate the overall code quality delivered by the team.',1),(277,'Task Completion',8,21,_binary '','Assess how well the tasks were completed in the milestone.',2),(278,'Teamwork',7,21,_binary '','Evaluate how well the team collaborated.',3),(279,'Documentation',6,21,_binary '','Quality of the project documentation.',1),(280,'Bug Fixing',4,21,_binary '','Effort put into fixing reported bugs.',2),(281,'Code Quality',5,21,_binary '','Evaluate the overall code quality delivered by the team.',1),(282,'Task Completion',8,21,_binary '','Assess how well the tasks were completed in the milestone.',2),(283,'Teamwork',7,21,_binary '','Evaluate how well the team collaborated.',3),(284,'Documentation',6,21,_binary '','Quality of the project documentation.',1),(285,'Bug Fixing',4,21,_binary '','Effort put into fixing reported bugs.',2),(286,'Code Quality',5,21,_binary '','Evaluate the overall code quality delivered by the team.',1),(287,'Task Completion',8,21,_binary '','Assess how well the tasks were completed in the milestone.',2),(288,'Teamwork',7,21,_binary '','Evaluate how well the team collaborated.',3),(289,'Documentation',6,21,_binary '','Quality of the project documentation.',1),(290,'Bug Fixing',4,21,_binary '','Effort put into fixing reported bugs.',2),(291,'Code Quality',5,21,_binary '','Evaluate the overall code quality delivered by the team.',1),(292,'Task Completion',8,21,_binary '','Assess how well the tasks were completed in the milestone.',2),(293,'Teamwork',7,21,_binary '','Evaluate how well the team collaborated.',3),(294,'Documentation',6,21,_binary '','Quality of the project documentation.',1),(295,'Bug Fixing',4,21,_binary '','Effort put into fixing reported bugs.',2),(296,'Code Quality',5,21,_binary '','Evaluate the overall code quality delivered by the team.',1),(297,'Task Completion',8,21,_binary '','Assess how well the tasks were completed in the milestone.',2),(298,'Teamwork',7,21,_binary '','Evaluate how well the team collaborated.',3),(299,'Documentation',6,21,_binary '','Quality of the project documentation.',1),(300,'Bug Fixing',4,21,_binary '','Effort put into fixing reported bugs.',2),(307,'999',12,21,_binary '','1212',1),(311,'dat',12,21,_binary '','122',2),(313,'ădawd',12,21,_binary '','12345',3),(314,'',2,21,_binary '','',1),(315,'',90,21,_binary '','',5),(316,'add',3,21,_binary '','',1),(318,'add',99,22,_binary '','123',6);
/*!40000 ALTER TABLE `project_criteria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `projectphase`
--

DROP TABLE IF EXISTS `projectphase`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `projectphase` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  `priority` tinyint NOT NULL,
  `details` varchar(500) DEFAULT '""',
  `finalPhase` bit(1) DEFAULT b'0',
  `completeRate` tinyint DEFAULT '0',
  `status` bit(1) NOT NULL DEFAULT b'1',
  `domainId` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Domain_Phase_idx` (`domainId`),
  CONSTRAINT `Domain_Phase` FOREIGN KEY (`domainId`) REFERENCES `group` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `projectphase`
--

LOCK TABLES `projectphase` WRITE;
/*!40000 ALTER TABLE `projectphase` DISABLE KEYS */;
INSERT INTO `projectphase` VALUES (1,'Planning',1,'Initial planning and scheduling of tasks.',_binary '\0',20,_binary '',6),(2,'Analysis',2,'Analyzing system requirements and risks.',_binary '\0',40,_binary '',6),(3,'Design',3,'Designing the architecture and the UI of the system.',_binary '\0',60,_binary '',6),(4,'Development',4,'Coding the core features.',_binary '\0',80,_binary '',6),(5,'Testing',5,'Testing and validating the product.',_binary '',100,_binary '',6),(6,'Planning',1,'Initial planning and scheduling of tasks.',_binary '\0',20,_binary '',7),(7,'Analysis',2,'Analyzing system requirements and risks.',_binary '\0',40,_binary '',7),(8,'Design',3,'Designing the architecture and the UI of the system.',_binary '\0',60,_binary '',7),(9,'Development',4,'Coding the core features.',_binary '\0',80,_binary '',7),(10,'Testing',5,'Testing and validating the product.',_binary '',100,_binary '',7),(11,'Planning',1,'Initial planning and scheduling of tasks.',_binary '\0',20,_binary '',8),(12,'Analysis',2,'Analyzing system requirements and risks.',_binary '\0',40,_binary '',8),(13,'Design',3,'Designing the architecture and the UI of the system.',_binary '\0',60,_binary '',8),(14,'Development',4,'Coding the core features.',_binary '\0',80,_binary '',8),(15,'Testing',5,'Testing and validating the product.',_binary '',100,_binary '',8),(16,'Planning',1,'Initial planning and scheduling of tasks.',_binary '\0',20,_binary '',9),(17,'Analysis',2,'Analyzing system requirements and risks.',_binary '\0',40,_binary '',9),(18,'Design',3,'Designing the architecture and the UI of the system.',_binary '\0',60,_binary '',9),(19,'Development',4,'Coding the core features.',_binary '\0',80,_binary '',9),(20,'Testing',5,'Testing and validating the product.',_binary '',100,_binary '',9),(21,'Planning',1,'Initial planning and scheduling of tasks.',_binary '\0',20,_binary '',10),(22,'Analysis',2,'Analyzing system requirements and risks.',_binary '\0',40,_binary '',10),(23,'Design',3,'Designing the architecture and the UI of the system.',_binary '\0',60,_binary '',10),(24,'Development',4,'Coding the core features.',_binary '\0',80,_binary '',10),(25,'Testing',5,'Testing and validating the product.',_binary '',100,_binary '',10);
/*!40000 ALTER TABLE `projectphase` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `projectphase_criteria`
--

DROP TABLE IF EXISTS `projectphase_criteria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `projectphase_criteria` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  `weight` tinyint NOT NULL,
  `status` bit(1) NOT NULL DEFAULT b'1',
  `phaseId` int NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `domainId` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Phase_of_criteria_idx` (`phaseId`),
  KEY `Domain_of_criteria_idx` (`domainId`),
  CONSTRAINT `Domain_of_criteria` FOREIGN KEY (`domainId`) REFERENCES `group` (`id`),
  CONSTRAINT `Phase_of_criteria` FOREIGN KEY (`phaseId`) REFERENCES `projectphase` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `projectphase_criteria`
--

LOCK TABLES `projectphase_criteria` WRITE;
/*!40000 ALTER TABLE `projectphase_criteria` DISABLE KEYS */;
/*!40000 ALTER TABLE `projectphase_criteria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `requirement`
--

DROP TABLE IF EXISTS `requirement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `requirement` (
  `id` int NOT NULL AUTO_INCREMENT,
  `projectId` int NOT NULL,
  `userId` int NOT NULL,
  `title` varchar(50) NOT NULL,
  `details` varchar(500) DEFAULT NULL,
  `complexity` varchar(50) DEFAULT NULL,
  `status` int NOT NULL DEFAULT '1',
  `estimateEffort` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `requirement_of_project_idx` (`projectId`),
  KEY `requirement_by_user_idx` (`userId`),
  KEY `status_idx` (`status`),
  CONSTRAINT `requirement_by_user` FOREIGN KEY (`userId`) REFERENCES `user` (`id`),
  CONSTRAINT `requirement_of_project` FOREIGN KEY (`projectId`) REFERENCES `project` (`id`),
  CONSTRAINT `status_fk` FOREIGN KEY (`status`) REFERENCES `domain_setting` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `requirement`
--

LOCK TABLES `requirement` WRITE;
/*!40000 ALTER TABLE `requirement` DISABLE KEYS */;
/*!40000 ALTER TABLE `requirement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `requirement_milestone`
--

DROP TABLE IF EXISTS `requirement_milestone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `requirement_milestone` (
  `id` int NOT NULL AUTO_INCREMENT,
  `milestoneId` int NOT NULL,
  `requirementId` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Requirement_in_milestone_idx` (`requirementId`),
  KEY `Milestone_of_requirement_idx` (`milestoneId`),
  CONSTRAINT `Milestone_of_requirement` FOREIGN KEY (`milestoneId`) REFERENCES `milestone` (`id`),
  CONSTRAINT `Requirement_in_milestone` FOREIGN KEY (`requirementId`) REFERENCES `requirement` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `requirement_milestone`
--

LOCK TABLES `requirement_milestone` WRITE;
/*!40000 ALTER TABLE `requirement_milestone` DISABLE KEYS */;
/*!40000 ALTER TABLE `requirement_milestone` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `setting`
--

DROP TABLE IF EXISTS `setting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `setting` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `type` tinyint NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `priority` tinyint DEFAULT '0',
  `value` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`,`type`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `setting`
--

LOCK TABLES `setting` WRITE;
/*!40000 ALTER TABLE `setting` DISABLE KEYS */;
INSERT INTO `setting` VALUES (2,'Incentivize','Provide an incentive (a motivation) for using a product or service.',1,1,0,NULL),(3,'Monetize','Make money from a product or activity.',1,1,0,NULL),(4,'Deliverable','A product or service developed by a business.',1,1,0,NULL),(5,'Margin','Profit from a product or service after all expenses have been covered. Often referred to as a percentage.',1,1,0,NULL);
/*!40000 ALTER TABLE `setting` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `team`
--

DROP TABLE IF EXISTS `team`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `team` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  `topic` varchar(100) DEFAULT '',
  `details` varchar(500) DEFAULT '',
  `projectId` int NOT NULL,
  `status` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`id`),
  KEY `TeamProject_idx` (`projectId`),
  CONSTRAINT `TeamProject` FOREIGN KEY (`projectId`) REFERENCES `project` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `team`
--

LOCK TABLES `team` WRITE;
/*!40000 ALTER TABLE `team` DISABLE KEYS */;
INSERT INTO `team` VALUES (1,'Alpha','Backend Development','Responsible for developing APIs and database integration.',21,_binary ''),(2,'Beta','Frontend Design','Design and implement user interfaces using React.',21,_binary ''),(6,'Zeta','Frontend Development','Develop the UI components and UX design.',21,_binary ''),(8,'Theta','Integration Testing','Perform integration tests between different modules.',21,_binary ''),(28,'Alpha','1234','awdawd',22,_binary '');
/*!40000 ALTER TABLE `team` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `team_member`
--

DROP TABLE IF EXISTS `team_member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `team_member` (
  `id` int NOT NULL AUTO_INCREMENT,
  `teamId` int NOT NULL,
  `isLeader` bit(1) NOT NULL DEFAULT b'0',
  `userId` int NOT NULL,
  `milestoneId` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Member_of_Team_idx` (`teamId`),
  KEY `Member_id_idx` (`userId`),
  KEY `Team_of_milestone_idx` (`milestoneId`),
  CONSTRAINT `Member_id` FOREIGN KEY (`userId`) REFERENCES `user` (`id`),
  CONSTRAINT `Member_of_Team` FOREIGN KEY (`teamId`) REFERENCES `team` (`id`) ON DELETE CASCADE,
  CONSTRAINT `Team_member_of_milestone` FOREIGN KEY (`milestoneId`) REFERENCES `milestone` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=286 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `team_member`
--

LOCK TABLES `team_member` WRITE;
/*!40000 ALTER TABLE `team_member` DISABLE KEYS */;
INSERT INTO `team_member` VALUES (277,1,_binary '\0',5,2),(279,1,_binary '\0',4,1),(280,1,_binary '',6,2),(281,2,_binary '\0',7,2),(282,6,_binary '\0',8,1),(283,1,_binary '',5,1),(284,1,_binary '\0',6,1),(285,1,_binary '\0',7,1);
/*!40000 ALTER TABLE `team_member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `team_milestone`
--

DROP TABLE IF EXISTS `team_milestone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `team_milestone` (
  `id` int NOT NULL AUTO_INCREMENT,
  `teamId` int NOT NULL,
  `milestoneId` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Team_of_milestone_idx` (`teamId`),
  KEY `Milestone_of_team_idx` (`milestoneId`),
  CONSTRAINT `Milestone_of_team` FOREIGN KEY (`milestoneId`) REFERENCES `milestone` (`id`) ON DELETE CASCADE,
  CONSTRAINT `Team_of_milestone` FOREIGN KEY (`teamId`) REFERENCES `team` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `team_milestone`
--

LOCK TABLES `team_milestone` WRITE;
/*!40000 ALTER TABLE `team_milestone` DISABLE KEYS */;
INSERT INTO `team_milestone` VALUES (45,2,1),(46,2,2),(49,1,1),(50,1,2),(51,1,3),(52,1,4),(53,1,5),(58,6,1),(59,6,2),(60,6,3),(61,8,1),(62,8,2),(63,8,5);
/*!40000 ALTER TABLE `team_milestone` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `timesheet`
--

DROP TABLE IF EXISTS `timesheet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `timesheet` (
  `id` int NOT NULL,
  `reporter` int NOT NULL,
  `reviewer` int DEFAULT NULL,
  `projectId` int NOT NULL,
  `requirementId` int NOT NULL,
  `timeCreate` datetime NOT NULL,
  `timeComplete` datetime DEFAULT NULL,
  `status` tinyint DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `report_user_idx` (`reporter`),
  KEY `review_user_idx` (`reviewer`),
  KEY `project_workon_idx` (`projectId`),
  KEY `requirement_workon_idx` (`requirementId`),
  CONSTRAINT `project_workon` FOREIGN KEY (`projectId`) REFERENCES `project` (`id`),
  CONSTRAINT `report_user` FOREIGN KEY (`reporter`) REFERENCES `user` (`id`),
  CONSTRAINT `requirement_workon` FOREIGN KEY (`requirementId`) REFERENCES `requirement` (`id`),
  CONSTRAINT `review_user` FOREIGN KEY (`reviewer`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `timesheet`
--

LOCK TABLES `timesheet` WRITE;
/*!40000 ALTER TABLE `timesheet` DISABLE KEYS */;
/*!40000 ALTER TABLE `timesheet` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(50) NOT NULL,
  `fullname` varchar(50) NOT NULL,
  `mobile` varchar(15) DEFAULT '',
  `password` varchar(500) NOT NULL,
  `note` varchar(1000) DEFAULT '',
  `role` tinyint NOT NULL,
  `status` tinyint NOT NULL,
  `departmentId` int NOT NULL,
  `image` varchar(100) DEFAULT '',
  `address` varchar(200) DEFAULT '',
  `gender` tinyint(1) DEFAULT '0',
  `birthdate` date DEFAULT NULL,
  `otp` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `otp_expiry` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email_UNIQUE` (`email`),
  KEY `UserDepartment_idx` (`departmentId`),
  CONSTRAINT `UserDepartment` FOREIGN KEY (`departmentId`) REFERENCES `group` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (3,'nguyendatrip1234@gmail.com','admin','0123456790','$2a$10$Q/EtttJ/oZBtJlHQI9JEYOU9xWPuGF0WKlDbN/sV5nte3bm22Fw5S','test',1,1,1,'/PMS/images/3_foo.jpg','Nghe an',1,'2022-10-28','877537','2024-10-29 18:10:58'),(4,'user@gmail.com','John Doe','0123456789','$2a$10$Skg9.od.l3mHc5Grg61GgOjUVpopu73Vx5kGVlUmAD4Azqc3k92D2','Note 1',2,1,1,'/PMS/images/2021-11-04.png','Ha Noi',1,'2024-10-29',NULL,NULL),(5,'jane.smith@example.com','Jane Smith','0987654321','$2a$10$gnCMkfBp9H5m3Ba73fn2COKXn/xoixvhEO7a3YyIZWWcAhKgJq28.','New employee',3,1,2,'image2.png','TP HCM',1,'2024-10-24',NULL,NULL),(6,'alice.jones@example.com','Alice Jones','1122334455','$2a$10$gnCMkfBp9H5m3Ba73fn2COKXn/xoixvhEO7a3YyIZWWcAhKgJq28.','Senior Developer',4,1,3,'image3.png','Nghe An',1,'2024-10-24',NULL,NULL),(7,'bob.brown@example.com','Bob Brown','2233445566','$2a$10$gnCMkfBp9H5m3Ba73fn2COKXn/xoixvhEO7a3YyIZWWcAhKgJq28.','Team Lead',5,1,4,'image4.png','Ninh Binh',1,'2024-10-24',NULL,NULL),(8,'charlie.davis@example.com','Charlie Davis','3344556677','$2a$10$gnCMkfBp9H5m3Ba73fn2COKXn/xoixvhEO7a3YyIZWWcAhKgJq28.','Project Manager',6,1,5,'image5.png','Tuyen Quang',0,'2024-10-24',NULL,NULL),(9,'david.wilson@example.com','David Wilson','4455667788','$2a$10$gnCMkfBp9H5m3Ba73fn2COKXn/xoixvhEO7a3YyIZWWcAhKgJq28.','HR Manager',2,0,1,'image6.png','Ha Noi',0,'2024-10-24',NULL,NULL),(10,'emma.thomas@example.com','Emma Thomas','5566778899','$2a$10$gnCMkfBp9H5m3Ba73fn2COKXn/xoixvhEO7a3YyIZWWcAhKgJq28.','Marketing Lead',2,0,2,'image7.png','My Tho',0,'2024-10-24',NULL,NULL),(11,'oliver.johnson@example.com','Oliver Johnson','6677889900','$2a$10$gnCMkfBp9H5m3Ba73fn2COKXn/xoixvhEO7a3YyIZWWcAhKgJq28.','Intern',2,1,3,'image8.png','Thanh Hoa',1,'2024-10-24',NULL,NULL),(12,'sophia.lee@example.com','Sophia Lee','7788990011','$2a$10$gnCMkfBp9H5m3Ba73fn2COKXn/xoixvhEO7a3YyIZWWcAhKgJq28.','Product Manager',2,0,4,'image9.png','Nam Dinh',1,'2024-10-24',NULL,NULL),(13,'liam.martin@example.com','Liam Martin','8899001122','$2a$10$gnCMkfBp9H5m3Ba73fn2COKXn/xoixvhEO7a3YyIZWWcAhKgJq28.','CTO',2,1,5,'image10.png','Nghe An',0,'2024-10-24',NULL,NULL),(14,'t@gmail.com','dat nguyen','0123456789','$2a$10$CZ24WD9tKlH1SiHZMdlrrOMqXNS0VN2Skafm9MnCW.DxLCD4OGTXW','',1,1,1,'/PMS_iter_2/images/2021-09-28 (3).png','da',0,'2024-09-12',NULL,NULL),(15,'u@gmail.com','dat nguyen','','$2a$10$SQurBk/.cN.1EZuh/YPRj.Pg3o40lz4gKSPCIqNRKViPUHlwgeMx6','',1,1,1,'','',0,NULL,NULL,NULL),(16,'a@gmail.com','dat ădfafw','','$2a$10$JTOemCTNpHaoPsyt4K8DMu/pWT7kejnhSKMkw5oqaFCUgTM4zc49O','',1,1,1,'','',0,NULL,NULL,NULL);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-10-30 22:24:01
