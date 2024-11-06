CREATE DATABASE  IF NOT EXISTS `pms` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `pms`;
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
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `allocation`
--

LOCK TABLES `allocation` WRITE;
/*!40000 ALTER TABLE `allocation` DISABLE KEYS */;
INSERT INTO `allocation` VALUES (4,21,'2023-01-01','2024-11-21',0,_binary '',1,3),(4,22,'2024-09-01','2024-11-05',60,_binary '',2,NULL),(4,26,'2023-06-01','2024-11-05',50,_binary '',3,NULL),(4,27,'2025-02-01',NULL,80,_binary '',4,NULL),(4,31,'2023-11-01',NULL,70,_binary '',5,NULL),(4,36,'2024-04-01',NULL,90,_binary '',6,NULL),(5,21,'2023-02-01',NULL,0,_binary '',7,2),(5,22,'2024-10-01',NULL,90,_binary '',8,NULL),(5,27,'2023-07-01',NULL,100,_binary '',9,NULL),(5,28,'2025-03-01',NULL,60,_binary '',10,NULL),(5,32,'2023-12-01',NULL,50,_binary '',11,NULL),(6,21,'2023-03-01','2025-09-25',0,_binary '',13,1),(6,24,'2024-11-01',NULL,70,_binary '',14,NULL),(6,28,'2023-08-01',NULL,80,_binary '',15,NULL),(6,29,'2025-04-01',NULL,90,_binary '',16,NULL),(6,33,'2024-01-01',NULL,100,_binary '',17,NULL),(6,38,'2024-06-01',NULL,50,_binary '',18,NULL),(7,21,'2023-04-01',NULL,90,_binary '',19,4),(7,25,'2024-12-01',NULL,50,_binary '',20,NULL),(7,22,'2025-05-01',NULL,70,_binary '',22,NULL),(7,34,'2024-02-01',NULL,80,_binary '',23,NULL),(7,39,'2024-07-01',NULL,100,_binary '',24,NULL),(8,21,'2023-05-01',NULL,70,_binary '',25,5),(8,22,'2025-01-01',NULL,100,_binary '',26,NULL),(8,30,'2023-10-01',NULL,90,_binary '',27,NULL),(8,31,'2025-06-01',NULL,50,_binary '',28,NULL),(9,35,'2024-03-01',NULL,60,_binary '',29,NULL),(15,21,'2024-11-03',NULL,0,_binary '',33,1),(11,21,'2024-11-21',NULL,0,_binary '',37,1),(3,21,'2024-11-06',NULL,0,_binary '',38,1),(13,21,'2024-11-12','2024-11-22',0,_binary '',39,1),(14,21,'2024-11-13','2024-11-06',0,_binary '\0',40,3);
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
  `assignee` int NOT NULL,
  `attachfile` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Defect_of_requirement_idx` (`requirementId`),
  KEY `Defect_serveriry_idx` (`serverityId`),
  KEY `Defect_of_project_idx` (`projectId`),
  KEY `Assign_to_idx` (`assignee`),
  CONSTRAINT `Assign_to` FOREIGN KEY (`assignee`) REFERENCES `user` (`id`),
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
  `description` varchar(500) DEFAULT NULL,
  `type` varchar(50) NOT NULL,
  `status` tinyint DEFAULT '1',
  `assignee_id` int DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Issue_of_requirement_idx` (`requirementId`),
  KEY `Issue_of_project_idx` (`projectId`),
  KEY `Issue_assign_to_idx` (`assignee_id`),
  CONSTRAINT `Issue_assign_to` FOREIGN KEY (`assignee_id`) REFERENCES `user` (`id`),
  CONSTRAINT `Issue_of_project` FOREIGN KEY (`projectId`) REFERENCES `project` (`id`),
  CONSTRAINT `Issue_of_requirement` FOREIGN KEY (`requirementId`) REFERENCES `requirement` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=105 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `issue`
--

LOCK TABLES `issue` WRITE;
/*!40000 ALTER TABLE `issue` DISABLE KEYS */;
INSERT INTO `issue` VALUES (1,32,22,'Chief Design Engineer','Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.','Task',4,9,'2023-12-19','2024-03-27'),(2,25,23,'Compensation Analyst','Sed ante. Vivamus tortor. Duis mattis egestas metus.','Task',2,9,'2024-01-21','2024-02-29'),(3,40,22,'Speech Pathologist','Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.','Complaint',2,3,'2024-03-13','2024-10-05'),(4,21,21,'Senior Quality Engineer','In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.','Q&A',5,5,'2024-08-19','2024-04-18'),(5,23,21,'Programmer Analyst I','In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.','Q&A',1,9,'2024-03-17','2024-10-11'),(6,27,22,'Environmental Tech','Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.','Q&A',4,6,'2024-07-28','2024-06-21'),(7,26,23,'Software Consultant','Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.','Complaint',3,5,'2024-07-11','2024-06-06'),(8,43,25,'Budget/Accounting Analyst I','Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.','Complaint',3,7,'2024-10-12','2023-11-11'),(9,45,25,'Quality Control Specialist','Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.','Q&A',4,7,'2023-12-21','2023-12-17'),(10,8,21,'Nurse','Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.','Issue',2,7,'2024-06-23','2024-10-21'),(11,50,23,'Media Manager IV','Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.','Q&A',2,8,'2024-03-09','2024-07-08'),(12,30,24,'Web Developer IV','Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.','Q&A',3,6,'2024-10-11','2024-06-14'),(13,5,24,'Financial Analyst','Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.','Complaint',4,5,'2024-06-05','2024-10-20'),(14,41,21,'Account Representative I','Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.','Issue',3,6,'2023-11-24','2024-10-18'),(15,7,24,'Design Engineer','Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.','Issue',2,10,'2024-02-03','2024-10-18'),(16,35,23,'Staff Accountant III','Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.','Q&A',2,4,'2024-05-11','2023-12-27'),(17,3,24,'Biostatistician IV','Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.','Task',5,6,'2024-10-16','2023-12-20'),(18,26,23,'Design Engineer','Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.','Task',3,4,'2023-12-01','2024-09-17'),(19,24,23,'Human Resources Manager','Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.','Complaint',1,10,'2024-10-09','2024-06-28'),(20,32,24,'Assistant Manager','Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.','Q&A',1,3,'2024-02-15','2024-02-21'),(21,12,25,'Junior Executive','Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.','Complaint',2,6,'2024-07-01','2024-10-24'),(22,38,21,'Product Engineer','Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.','Task',4,3,'2023-12-07','2024-01-14'),(23,35,22,'Executive Secretary','Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.','Task',2,6,'2023-11-18','2023-11-10'),(24,26,24,'Compensation Analyst','Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.','Q&A',5,4,'2024-05-27','2024-04-29'),(25,37,24,'Librarian','Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.','Issue',5,10,'2024-03-10','2023-12-09'),(26,41,23,'Registered Nurse','Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.','Task',1,5,'2024-04-17','2024-07-31'),(27,6,23,'Desktop Support Technician','Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.','Task',3,5,'2023-11-07','2024-04-15'),(28,19,23,'Junior Executive','Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.','Task',4,5,'2024-08-04','2024-08-01'),(29,35,25,'Research Assistant I','Sed ante. Vivamus tortor. Duis mattis egestas metus.','Task',3,9,'2023-12-17','2024-03-08'),(30,37,23,'Research Associate','Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.','Complaint',4,8,'2024-10-21','2024-06-23'),(31,35,24,'Civil Engineer','Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.','Q&A',5,5,'2023-12-18','2024-05-16'),(32,9,25,'Recruiter','Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.','Task',3,8,'2024-07-03','2024-04-01'),(33,2,23,'Design Engineer','Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.','Issue',5,3,'2024-07-26','2024-01-30'),(34,8,21,'Structural Analysis Engineer','In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.','Task',5,5,'2024-06-14','2024-02-13'),(35,45,23,'Geological Engineer','Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.','Task',4,3,'2023-12-24','2024-01-06'),(36,6,22,'Software Consultant','In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.','Complaint',5,3,'2024-08-13','2023-12-08'),(37,6,23,'Software Test Engineer I','Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.','Q&A',3,5,'2024-03-02','2024-07-26'),(38,46,24,'Recruiting Manager','Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.','Task',2,3,'2024-10-08','2024-05-24'),(39,48,24,'Sales Associate','Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.','Complaint',2,3,'2024-07-15','2024-07-01'),(40,10,22,'Senior Quality Engineer','Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.','Task',4,9,'2024-10-24','2024-03-06'),(41,37,24,'Recruiter','Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.','Q&A',3,9,'2024-09-01','2024-05-23'),(42,33,24,'Paralegal','Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.','Issue',4,8,'2024-06-20','2024-02-22'),(43,4,22,'Operator','Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.','Task',1,7,'2024-02-19','2024-05-09'),(44,29,22,'Legal Assistant','Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.','Q&A',1,10,'2023-12-27','2024-07-04'),(45,43,24,'VP Product Management','Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.','Task',5,7,'2024-09-17','2024-08-03'),(46,45,25,'Senior Quality Engineer','Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.','Complaint',4,6,'2023-12-28','2024-05-11'),(47,2,21,'Health Coach IV','Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.','Q&A',2,4,'2023-11-21','2024-09-17'),(48,12,24,'Research Nurse','Phasellus in felis. Donec semper sapien a libero. Nam dui.','Q&A',3,6,'2024-08-08','2024-09-12'),(49,27,24,'Environmental Tech','Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.','Issue',4,4,'2024-05-27','2024-03-05'),(50,27,23,'Developer II','Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.','Task',3,8,'2024-05-23','2024-06-12'),(51,30,24,'Technical Writer','In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.','Complaint',4,5,'2024-09-13','2024-10-19'),(52,20,25,'Nurse Practicioner','Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.','Issue',5,10,'2024-10-11','2024-03-31'),(53,27,25,'Civil Engineer','Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.','Task',4,3,'2024-10-17','2024-02-19'),(54,21,21,'Assistant Manager','Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.','Issue',2,8,'2023-12-05','2024-08-05'),(55,26,24,'Human Resources Assistant III','Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.','Task',3,8,'2023-12-20','2024-01-18'),(56,7,22,'Nuclear Power Engineer','Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.','Complaint',3,5,'2024-05-27','2024-01-23'),(57,39,23,'Product Engineer','Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.','Issue',1,8,'2024-05-04','2024-02-29'),(58,22,25,'Senior Cost Accountant','In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.','Q&A',2,3,'2024-08-11','2024-08-06'),(59,42,23,'Computer Systems Analyst III','Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.','Q&A',5,9,'2023-11-09','2024-06-25'),(60,34,22,'Help Desk Technician','Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.','Task',2,10,'2023-12-13','2024-03-26'),(61,21,25,'Programmer Analyst III','Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.','Task',4,6,'2024-07-06','2024-01-20'),(62,14,24,'Nuclear Power Engineer','Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.','Issue',3,7,'2024-04-14','2023-12-21'),(63,16,24,'Accounting Assistant IV','Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.','Complaint',2,5,'2024-03-09','2024-02-27'),(64,9,23,'Account Coordinator','Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.','Complaint',3,3,'2024-05-26','2024-07-11'),(65,10,23,'Information Systems Manager','Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.','Q&A',1,4,'2024-08-29','2024-10-03'),(66,23,24,'Environmental Tech','Phasellus in felis. Donec semper sapien a libero. Nam dui.','Q&A',3,6,'2024-09-15','2024-10-20'),(67,48,21,'Assistant Professor','Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.','Q&A',3,3,'2024-06-21','2024-09-25'),(68,22,22,'Account Executive','Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.','Task',3,7,'2024-03-20','2024-06-30'),(69,48,25,'Electrical Engineer','Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.','Complaint',3,9,'2024-07-27','2024-01-09'),(70,39,22,'Automation Specialist III','Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.','Task',3,3,'2024-05-14','2024-09-02'),(71,28,23,'Software Engineer I','Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.','Complaint',5,3,'2024-08-15','2024-01-23'),(72,25,25,'Technical Writer','Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.','Complaint',5,6,'2024-09-19','2024-08-04'),(73,37,23,'Administrative Assistant III','In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.','Issue',5,8,'2023-12-05','2024-06-30'),(74,27,25,'Mechanical Systems Engineer','Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.','Task',1,6,'2024-10-02','2023-11-17'),(75,5,23,'Actuary','Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.','Task',3,3,'2024-01-06','2024-05-03'),(76,19,22,'Senior Financial Analyst','Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.','Complaint',1,4,'2024-04-26','2024-09-03'),(77,44,21,'Budget/Accounting Analyst I','Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.','Task',3,6,'2024-09-30','2024-08-28'),(78,47,23,'Design Engineer','Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.','Issue',4,8,'2023-11-05','2024-01-17'),(79,2,23,'Community Outreach Specialist','Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.','Q&A',3,9,'2024-06-21','2024-10-15'),(80,21,21,'Editor','Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.','Issue',4,6,'2023-12-14','2024-05-13'),(81,41,25,'VP Marketing','Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.','Task',4,8,'2024-08-08','2024-05-16'),(82,9,22,'Analyst Programmer','In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.','Issue',4,5,'2024-07-26','2024-01-20'),(83,38,21,'Actuary','In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.','Issue',5,10,'2024-02-16','2024-09-03'),(84,7,22,'Graphic Designer','Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.','Task',1,3,'2024-09-04','2024-09-07'),(85,12,22,'Data Coordinator','Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.','Q&A',3,4,'2024-02-12','2024-10-17'),(86,42,23,'Senior Sales Associate','Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.','Task',5,7,'2024-07-04','2024-09-06'),(87,42,24,'Automation Specialist II','Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.','Issue',1,8,'2024-02-04','2024-06-06'),(88,45,23,'Senior Sales Associate','Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.','Q&A',3,9,'2023-12-24','2024-01-24'),(89,15,21,'Research Assistant IV','Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.','Complaint',2,5,'2024-08-11','2024-07-08'),(90,43,25,'Physical Therapy Assistant','Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.','Issue',4,7,'2024-05-24','2024-01-16'),(91,44,24,'Account Executive','Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.','Complaint',4,6,'2023-12-31','2023-12-21'),(92,31,22,'Quality Control Specialist','Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.','Issue',2,4,'2024-04-12','2023-11-18'),(93,26,24,'Software Consultant','In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.','Q&A',2,7,'2024-05-11','2024-05-12'),(94,24,23,'Technical Writer','Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.','Task',2,8,'2024-08-28','2023-11-17'),(95,17,23,'Internal Auditor','Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.','Complaint',5,6,'2024-09-19','2024-07-26'),(96,31,25,'Structural Analysis Engineer','Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.','Issue',5,7,'2023-12-19','2024-08-23'),(97,18,21,'Financial Analyst','Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.','Task',4,3,'2024-04-03','2024-10-19'),(98,30,25,'Graphic Designer','Fusce consequat. Nulla nisl. Nunc nisl.','Task',1,6,'2024-09-27','2024-06-04'),(99,23,23,'Account Representative I','Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.','Q&A',1,7,'2024-08-05','2024-01-21'),(100,45,25,'Administrative Officer','Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.','Issue',1,3,'2024-10-08','2024-07-26'),(102,32,22,'cxvxcvx','cxvxcvx','Q&A',2,9,'2024-11-05','2024-11-05'),(104,32,22,'test add','test add','Task',0,9,'2024-11-05','2024-11-05');
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
  CONSTRAINT `requirement_by_user` FOREIGN KEY (`userId`) REFERENCES `user` (`id`),
  CONSTRAINT `requirement_of_project` FOREIGN KEY (`projectId`) REFERENCES `project` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=107 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `requirement`
--

LOCK TABLES `requirement` WRITE;
/*!40000 ALTER TABLE `requirement` DISABLE KEYS */;
INSERT INTO `requirement` VALUES (2,25,8,'Recruiting Manager','Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.','Suspendisse potenti.',6,12),(3,21,4,'Nurse Practicioner','In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.','sit',1,11),(4,21,4,'Biostatistician IV','Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.','nisi at',6,13),(5,23,4,'Design Engineer','Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.','nulla nunc',1,10),(6,25,4,'Accounting Assistant IV','In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.','mauris',6,19),(7,23,4,'Accounting Assistant III','Fusce consequat. Nulla nisl. Nunc nisl.','sed',1,11),(8,21,4,'VP Accounting','Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.','porttitor',1,5),(9,25,4,'Environmental Tech','Fusce consequat. Nulla nisl. Nunc nisl.','arcu',4,18),(10,21,4,'Safety Technician I','Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.','a feugiat',6,18),(11,24,4,'Marketing Assistant','In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.','donec',3,1),(12,21,4,'Clinical Specialist','Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.','ullamcorper purus',2,17),(13,25,4,'Information Systems Manager','Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.','scelerisque',1,6),(14,23,4,'Marketing Assistant','In congue. Etiam justo. Etiam pretium iaculis justo.','mi',1,16),(15,25,4,'Electrical Engineer','Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.','interdum',4,14),(16,23,4,'Nuclear Power Engineer','Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.','pede',5,2),(17,21,4,'Account Representative II','In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.','congue eget',2,18),(18,24,4,'Nurse','Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.','arcu sed',6,20),(19,23,4,'Civil Engineer','Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.','quis',3,17),(20,22,4,'Social Worker','Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.','convallis',6,11),(21,25,4,'Registered Nurse','In congue. Etiam justo. Etiam pretium iaculis justo.','vivamus',5,11),(22,22,4,'Editor','Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.','quisque porta',1,1),(23,23,4,'Engineer III','Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.','quis odio',6,14),(24,23,4,'Accounting Assistant IV','Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.','justo',3,14),(25,24,4,'Web Designer I','Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.','elementum',2,8),(26,24,4,'Database Administrator II','Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.','et',3,9),(27,23,4,'Media Manager I','In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.','rutrum ac',1,2),(28,21,4,'Actuary','Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.','pretium nisl',1,7),(29,21,4,'Safety Technician I','Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.','diam in',6,13),(30,23,4,'Clinical Specialist','Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.','cubilia curae',2,6),(31,23,4,'Data Coordinator','Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.','risus dapibus',4,7),(32,25,4,'Environmental Tech','Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.','tempor',5,11),(33,21,4,'Assistant Professor','Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.','donec ut',3,1),(34,21,4,'Social Worker','Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.','nunc viverra',5,8),(35,23,4,'VP Product Management','Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.','maecenas ut',6,4),(36,21,4,'Web Developer II','Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.','ut at',3,16),(37,22,4,'Dental Hygienist','Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.','dictumst',3,11),(38,23,4,'Graphic Designer','In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.','montes',2,16),(39,25,4,'Senior Sales Associate','Sed ante. Vivamus tortor. Duis mattis egestas metus.','vitae',4,4),(40,21,4,'Software Test Engineer IV','Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.','blandit nam',4,5),(41,25,4,'Assistant Manager','Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.','auctor sed',5,13),(42,22,4,'Electrical Engineer','Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.','orci',2,6),(43,24,4,'Administrative Officer','Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.','posuere',4,2),(44,24,4,'Actuary','Sed ante. Vivamus tortor. Duis mattis egestas metus.','morbi vestibulum',6,11),(45,23,4,'Research Assistant III','Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.','et',2,8),(46,21,4,'Financial Advisor','Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.','dignissim',3,20),(47,24,4,'Sales Representative','Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.','eleifend luctus',2,9),(48,24,4,'Senior Editor','Phasellus in felis. Donec semper sapien a libero. Nam dui.','ante ipsum',4,1),(49,21,4,'Automation Specialist II','Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.','consequat',6,16),(50,24,4,'Marketing Assistant','In congue. Etiam justo. Etiam pretium iaculis justo.','pretium',5,20),(51,24,4,'Assistant Media Planner','Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.','consequat dui',1,14),(52,24,4,'Structural Engineer','In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.','donec',2,14),(53,21,4,'Dental Hygienist','Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.','nisi',3,4),(54,23,4,'Registered Nurse','Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.','venenatis',4,2),(55,21,4,'Health Coach III','Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.','non mattis',3,12),(56,21,4,'Legal Assistant','Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.','aliquam',3,13),(57,22,4,'Librarian','Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.','nec sem',1,19),(58,24,4,'Geologist II','In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.','arcu sed',2,12),(59,22,4,'Actuary','In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.','lectus vestibulum',3,20),(60,23,4,'Statistician IV','Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.','quam',2,16),(61,23,4,'Recruiter','Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.','venenatis turpis',3,1),(62,24,4,'Staff Scientist','In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.','aliquet at',1,9),(63,23,4,'Statistician IV','In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.','platea',5,2),(64,21,4,'Actuary','Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.','id pretium',5,7),(65,22,4,'Librarian','Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.','rhoncus dui',4,14),(66,22,4,'Director of Sales','In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.','lobortis',6,18),(67,21,4,'Librarian','Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.','est',1,16),(68,23,4,'Chemical Engineer','Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.','faucibus accumsan',2,13),(69,21,4,'Office Assistant IV','Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.','habitasse platea',1,12),(70,25,4,'Senior Developer','Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.','etiam',2,18),(71,25,4,'Food Chemist','Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.','in faucibus',6,12),(72,21,4,'Legal Assistant','In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.','posuere nonummy',2,16),(73,23,4,'Automation Specialist I','In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.','platea',4,14),(74,23,4,'Programmer III','Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.','integer',5,17),(75,21,4,'Safety Technician I','Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.','nulla',3,11),(76,22,4,'Media Manager II','In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.','velit',5,17),(77,22,4,'Project Manager','Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.','dolor',2,19),(78,22,4,'Librarian','Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.','tortor',2,2),(79,24,4,'Paralegal','Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.','turpis',5,5),(80,23,4,'Administrative Assistant II','Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.','vivamus',4,20),(81,22,4,'Marketing Assistant','Sed ante. Vivamus tortor. Duis mattis egestas metus.','amet',5,20),(82,23,4,'Electrical Engineer','Fusce consequat. Nulla nisl. Nunc nisl.','hendrerit at',1,12),(83,22,4,'Sales Associate','Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.','ornare imperdiet',6,10),(84,22,4,'Director of Sales','Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.','cras mi',3,8),(85,22,4,'Payment Adjustment Coordinator','Fusce consequat. Nulla nisl. Nunc nisl.','ipsum primis',1,2),(86,25,4,'Environmental Specialist','Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.','eros elementum',2,18),(87,25,4,'Help Desk Operator','Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.','vivamus',2,5),(88,25,4,'Chemical Engineer','Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.','pellentesque ultrices',1,12),(89,24,4,'Graphic Designer','Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.','rhoncus aliquam',6,8),(90,23,4,'Design Engineer','Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.','fermentum',4,13),(91,24,4,'Director of Sales','Fusce consequat. Nulla nisl. Nunc nisl.','at',3,20),(92,21,4,'Design Engineer','Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.','urna',5,10),(93,21,4,'Automation Specialist I','Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.','convallis',4,13),(94,24,4,'General Manager','Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.','congue eget',3,10),(95,22,4,'Professor','In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.','luctus et',2,12),(96,25,4,'Cost Accountant','Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.','porttitor id',6,3),(97,25,4,'Media Manager III','Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.','nulla quisque',3,3),(98,24,4,'Assistant Media Planner','Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.','morbi',4,20),(99,25,4,'Executive Secretary','Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.','est',2,20),(100,23,4,'Programmer Analyst I','Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.','elit proin',2,6),(101,25,4,'Senior Financial Analyst','Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.','id',6,13),(102,21,4,'Structural Engineer','Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.','placerat',6,11),(103,24,8,'test update','vxcvx','Low',0,1),(104,21,8,'vcxvxcvxc','vxcvxcvxc','Low',0,1),(105,22,8,'vxcvxc','dasdasdas','Low',0,1),(106,22,8,'bvcbvcbcvbcvbcvbcv','test update','Low',0,12);
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `requirement_milestone`
--

LOCK TABLES `requirement_milestone` WRITE;
/*!40000 ALTER TABLE `requirement_milestone` DISABLE KEYS */;
INSERT INTO `requirement_milestone` VALUES (1,21,2),(3,16,103),(5,7,105),(7,7,106);
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
INSERT INTO `user` VALUES (3,'Admin@gmail.com','admin','0123456790','$2a$10$Q/EtttJ/oZBtJlHQI9JEYOU9xWPuGF0WKlDbN/sV5nte3bm22Fw5S','test',1,1,1,'/PMS/images/3_foo.jpg','Nghe an',1,'2022-10-28','877537','2024-11-04 13:34:58'),(4,'Member@gmail.com','John Doe','0123456789','$2a$10$Skg9.od.l3mHc5Grg61GgOjUVpopu73Vx5kGVlUmAD4Azqc3k92D2','Note 1',2,1,1,'/PMS/images/4_z4677560308042_b074c45de6976cfdf9482049729ad8f9 (2).jpg','Ha Noi',1,'2024-10-29','005062','2024-11-04 13:34:58'),(5,'QA@gmail.com','Jane Smith','0987654321','$2a$10$gnCMkfBp9H5m3Ba73fn2COKXn/xoixvhEO7a3YyIZWWcAhKgJq28.','New employee',3,1,2,'image2.png','TP HCM',1,'2024-10-24',NULL,NULL),(6,'PM@gmail.com','Alice Jones','1122334455','$2a$10$gnCMkfBp9H5m3Ba73fn2COKXn/xoixvhEO7a3YyIZWWcAhKgJq28.','Senior Developer',4,1,3,'image3.png','Nghe An',1,'2024-10-24',NULL,NULL),(7,'dept@gmail.com','Bob Brown','2233445566','$2a$10$gnCMkfBp9H5m3Ba73fn2COKXn/xoixvhEO7a3YyIZWWcAhKgJq28.','Team Lead',5,1,1,'image4.png','Ninh Binh',1,'2024-10-24',NULL,NULL),(8,'PMO@gmail.com','Charlie Davis','3344556677','$2a$10$gnCMkfBp9H5m3Ba73fn2COKXn/xoixvhEO7a3YyIZWWcAhKgJq28.','Project Manager',6,1,5,'image5.png','Tuyen Quang',0,'2024-10-24',NULL,NULL),(9,'david.wilson@example.com','David Wilson','4455667788','$2a$10$gnCMkfBp9H5m3Ba73fn2COKXn/xoixvhEO7a3YyIZWWcAhKgJq28.','HR Manager',2,0,1,'image6.png','Ha Noi',0,'2024-10-24',NULL,NULL),(10,'emma.thomas@example.com','Emma Thomas','5566778899','$2a$10$gnCMkfBp9H5m3Ba73fn2COKXn/xoixvhEO7a3YyIZWWcAhKgJq28.','Marketing Lead',2,0,2,'image7.png','My Tho',0,'2024-10-24',NULL,NULL),(11,'oliver.johnson@example.com','Oliver Johnson','6677889900','$2a$10$gnCMkfBp9H5m3Ba73fn2COKXn/xoixvhEO7a3YyIZWWcAhKgJq28.','Intern',2,1,3,'image8.png','Thanh Hoa',1,'2024-10-24',NULL,NULL),(12,'sophia.lee@example.com','Sophia Lee','7788990011','$2a$10$gnCMkfBp9H5m3Ba73fn2COKXn/xoixvhEO7a3YyIZWWcAhKgJq28.','Product Manager',2,0,4,'image9.png','Nam Dinh',1,'2024-10-24',NULL,NULL),(13,'liam.martin@example.com','Liam Martin','8899001122','$2a$10$gnCMkfBp9H5m3Ba73fn2COKXn/xoixvhEO7a3YyIZWWcAhKgJq28.','CTO',2,1,5,'image10.png','Nghe An',0,'2024-10-24',NULL,NULL),(14,'t@gmail.com','dat nguyen','0123456789','$2a$10$CZ24WD9tKlH1SiHZMdlrrOMqXNS0VN2Skafm9MnCW.DxLCD4OGTXW','',1,1,1,'/PMS_iter_2/images/2021-09-28 (3).png','da',0,'2024-09-12',NULL,NULL),(15,'u@gmail.com','dat nguyen','','$2a$10$SQurBk/.cN.1EZuh/YPRj.Pg3o40lz4gKSPCIqNRKViPUHlwgeMx6','',1,1,1,'','',0,NULL,NULL,NULL),(16,'a@gmail.com','dat ădfafw','','$2a$10$JTOemCTNpHaoPsyt4K8DMu/pWT7kejnhSKMkw5oqaFCUgTM4zc49O','',1,1,1,'','',0,NULL,NULL,NULL);
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

-- Dump completed on 2024-11-06 21:37:34
