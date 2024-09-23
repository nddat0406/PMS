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
  `endDate` date NOT NULL,
  `projectRole` varchar(20) NOT NULL,
  `effortRate` int DEFAULT '0',
  `status` tinyint(1) NOT NULL,
  PRIMARY KEY (`userId`,`projectId`),
  KEY `AllocatedProjectId_idx` (`projectId`),
  CONSTRAINT `AllocatedProjectId` FOREIGN KEY (`projectId`) REFERENCES `project` (`id`),
  CONSTRAINT `AllocatedUserId` FOREIGN KEY (`userId`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `allocation`
--

LOCK TABLES `allocation` WRITE;
/*!40000 ALTER TABLE `allocation` DISABLE KEYS */;
INSERT INTO `allocation` VALUES (4,21,'2023-01-01','2023-06-01','Team Leader',100,1),(4,22,'2024-09-01','2025-02-01','Member',60,1),(4,26,'2023-06-01','2023-11-01','Member',50,1),(4,27,'2025-02-01','2025-07-01','Project Manager',80,1),(4,31,'2023-11-01','2024-04-01','Project Manager',70,1),(4,36,'2024-04-01','2024-09-01','Team Leader',90,1),(5,22,'2023-02-01','2023-07-01','Project Manager',80,1),(5,23,'2024-10-01','2025-03-01','Team Leader',90,1),(5,27,'2023-07-01','2023-12-01','Team Leader',100,1),(5,28,'2025-03-01','2025-08-01','Member',60,1),(5,32,'2023-12-01','2024-05-01','Member',50,1),(5,37,'2024-05-01','2024-10-01','Project Manager',70,1),(6,23,'2023-03-01','2023-08-01','Member',60,1),(6,24,'2024-11-01','2025-04-01','Project Manager',70,1),(6,28,'2023-08-01','2024-01-01','Project Manager',80,1),(6,29,'2025-04-01','2025-09-01','Team Leader',90,1),(6,33,'2024-01-01','2024-06-01','Team Leader',100,1),(6,38,'2024-06-01','2024-11-01','Member',50,1),(7,24,'2023-04-01','2023-09-01','Team Leader',90,1),(7,25,'2024-12-01','2025-05-01','Member',50,1),(7,29,'2023-09-01','2024-02-01','Member',60,1),(7,30,'2025-05-01','2025-10-01','Project Manager',70,1),(7,34,'2024-02-01','2024-07-01','Project Manager',80,1),(7,39,'2024-07-01','2024-12-01','Team Leader',100,1),(8,25,'2023-05-01','2023-10-01','Project Manager',70,1),(8,26,'2025-01-01','2025-06-01','Team Leader',100,1),(8,30,'2023-10-01','2024-03-01','Team Leader',90,1),(8,31,'2025-06-01','2025-11-01','Member',50,1),(8,35,'2024-03-01','2024-08-01','Member',60,1),(8,40,'2024-08-01','2025-01-01','Project Manager',80,1);
/*!40000 ALTER TABLE `allocation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `department`
--

DROP TABLE IF EXISTS `department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `department` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(10) NOT NULL,
  `name` varchar(50) NOT NULL,
  `details` varchar(200) DEFAULT NULL,
  `parent` int DEFAULT NULL,
  `status` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_code` (`code`),
  UNIQUE KEY `unique_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department`
--

LOCK TABLES `department` WRITE;
/*!40000 ALTER TABLE `department` DISABLE KEYS */;
INSERT INTO `department` VALUES (1,'dep1','Exercute Office','dept1 details',NULL,1),(2,'dept2','IT Office','dept2 details',1,1),(3,'dept3','Finance Office','dept3 details',1,1),(4,'dept4','HR Office','dept4 details',1,1),(5,'dept5','Resource Office','dept5 details',2,1);
/*!40000 ALTER TABLE `department` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `department_manager`
--

DROP TABLE IF EXISTS `department_manager`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `department_manager` (
  `managerId` int NOT NULL,
  `departmentId` int NOT NULL,
  PRIMARY KEY (`managerId`,`departmentId`),
  KEY `id_idx` (`departmentId`),
  CONSTRAINT `managerUserId` FOREIGN KEY (`managerId`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `mangeredDepartmentId` FOREIGN KEY (`departmentId`) REFERENCES `department` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department_manager`
--

LOCK TABLES `department_manager` WRITE;
/*!40000 ALTER TABLE `department_manager` DISABLE KEYS */;
/*!40000 ALTER TABLE `department_manager` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain`
--

DROP TABLE IF EXISTS `domain`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `domain` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(10) NOT NULL,
  `name` varchar(20) NOT NULL,
  `details` varchar(100) DEFAULT NULL,
  `status` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code_UNIQUE` (`code`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain`
--

LOCK TABLES `domain` WRITE;
/*!40000 ALTER TABLE `domain` DISABLE KEYS */;
INSERT INTO `domain` VALUES (1,'D001','DataCorp','Details about DataCorp',1),(2,'D002','DevSolutions','Details about DevSolutions',1),(3,'D003','DesignHub','Details about DesignHub',1),(4,'D004','DigiTech','Details about DigiTech',1),(5,'D005','DynamicSys','Details about DynamicSys',1);
/*!40000 ALTER TABLE `domain` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_user`
--

DROP TABLE IF EXISTS `domain_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `domain_user` (
  `userId` int NOT NULL,
  `domainId` int NOT NULL,
  PRIMARY KEY (`userId`,`domainId`),
  KEY `Domain_idx` (`domainId`),
  CONSTRAINT `Domain` FOREIGN KEY (`domainId`) REFERENCES `domain` (`id`),
  CONSTRAINT `UserOfDomain` FOREIGN KEY (`userId`) REFERENCES `user` (`id`)
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
-- Table structure for table `project`
--

DROP TABLE IF EXISTS `project`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `project` (
  `id` int NOT NULL AUTO_INCREMENT,
  `bizTerm` int NOT NULL,
  `code` varchar(20) NOT NULL,
  `name` varchar(50) NOT NULL,
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
  CONSTRAINT `ProjectDepartmentManager` FOREIGN KEY (`departmentId`) REFERENCES `department` (`id`),
  CONSTRAINT `ProjectDomain` FOREIGN KEY (`domainId`) REFERENCES `domain` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project`
--

LOCK TABLES `project` WRITE;
/*!40000 ALTER TABLE `project` DISABLE KEYS */;
INSERT INTO `project` VALUES (21,1,'C001','Project Phoenix','Details about Project Phoenix','2023-01-01',1,1,1),(22,2,'C002','AlphaWave','Details about AlphaWave','2023-02-01',2,2,2),(23,3,'C003','QuantumLeap','Details about QuantumLeap','2023-03-01',3,3,3),(24,4,'C004','CodeFusion','Details about CodeFusion','2023-04-01',1,4,4),(25,5,'C005','InnovateX','Details about InnovateX','2023-05-01',2,5,5),(26,3,'C006','Project Titan','Details about Project Titan','2023-06-01',3,1,1),(27,2,'C007','NeuralNet','Details about NeuralNet','2023-07-01',1,2,2),(28,1,'C008','SkyNet','Details about SkyNet','2023-08-01',2,3,3),(29,2,'C009','DeepBlue','Details about DeepBlue','2023-09-01',3,4,4),(30,3,'C010','Project Mercury','Details about Project Mercury','2023-10-01',1,5,5),(31,4,'C011','Project Apollo','Details about Project Apollo','2023-11-01',2,1,1),(32,1,'C012','Project Gemini','Details about Project Gemini','2023-12-01',3,2,2),(33,5,'C013','Project Orion','Details about Project Orion','2024-01-01',1,3,3),(34,1,'C014','Project Vega','Details about Project Vega','2024-02-01',2,4,4),(35,2,'C015','Project Sirius','Details about Project Sirius','2024-03-01',3,5,5),(36,3,'C016','Project Polaris','Details about Project Polaris','2024-04-01',1,1,1),(37,5,'C017','Project Andromeda','Details about Project Andromeda','2024-05-01',2,2,2),(38,5,'C018','Project Nebula','Details about Project Nebula','2024-06-01',3,3,3),(39,2,'C019','Project Cosmos','Details about Project Cosmos','2024-07-01',1,4,4),(40,1,'C020','Project Galaxy','Details about Project Galaxy','2024-08-01',2,5,5);
/*!40000 ALTER TABLE `project` ENABLE KEYS */;
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
INSERT INTO `setting` VALUES (1,'ROI','Return on investment (ROI) refers to all the benefits — monetary or otherwise — received from an investment.',1,1,0,NULL),(2,'Incentivize','Provide an incentive (a motivation) for using a product or service.',1,1,0,NULL),(3,'Monetize','Make money from a product or activity.',1,1,0,NULL),(4,'Deliverable','A product or service developed by a business.',1,1,0,NULL),(5,'Margin','Profit from a product or service after all expenses have been covered. Often referred to as a percentage.',1,1,0,NULL);
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
  `leader` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`),
  KEY `TeamProject_idx` (`projectId`),
  KEY `TeamLeader_idx` (`leader`),
  CONSTRAINT `TeamLeader` FOREIGN KEY (`leader`) REFERENCES `user` (`id`),
  CONSTRAINT `TeamProject` FOREIGN KEY (`projectId`) REFERENCES `project` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `team`
--

LOCK TABLES `team` WRITE;
/*!40000 ALTER TABLE `team` DISABLE KEYS */;
/*!40000 ALTER TABLE `team` ENABLE KEYS */;
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
  `otp_expiry` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email_UNIQUE` (`email`),
  KEY `UserDepartment_idx` (`departmentId`),
  CONSTRAINT `UserDepartment` FOREIGN KEY (`departmentId`) REFERENCES `department` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (3,'admin@gmail.com','admin','0123456790','$2a$10$CZ24WD9tKlH1SiHZMdlrrOMqXNS0VN2Skafm9MnCW.DxLCD4OGTXW','test',1,1,1,'/PMS/assets/images/userImage/z4677560308042_b074c45de6976cfdf9482049729ad8f9 (2).jpg','Ha Noi',0,'2024-10-10',NULL,NULL),(4,'user@gmail.com','John Doe','0123456789','$2a$10$uliB64NGMAkGljc3AYS5zu81xK3dDskP2MmmkuJ2fkKP0fnDvs.wC','Note 1',2,1,1,'/PMS/assets/images/userImage/z4669003056664_dc2fbcca53f37a00e2b1ac979998cec1.jpg','Ha Noi',1,'2024-10-29',NULL,NULL),(5,'jane.smith@example.com','Jane Smith','0987654321','$2a$10$gnCMkfBp9H5m3Ba73fn2COKXn/xoixvhEO7a3YyIZWWcAhKgJq28.','New employee',2,1,2,'image2.png','TP HCM',1,'2024-10-24',NULL,NULL),(6,'alice.jones@example.com','Alice Jones','1122334455','$2a$10$gnCMkfBp9H5m3Ba73fn2COKXn/xoixvhEO7a3YyIZWWcAhKgJq28.','Senior Developer',2,1,3,'image3.png','Nghe An',1,'2024-10-24',NULL,NULL),(7,'bob.brown@example.com','Bob Brown','2233445566','$2a$10$gnCMkfBp9H5m3Ba73fn2COKXn/xoixvhEO7a3YyIZWWcAhKgJq28.','Team Lead',2,1,4,'image4.png','Ninh Binh',1,'2024-10-24',NULL,NULL),(8,'charlie.davis@example.com','Charlie Davis','3344556677','$2a$10$gnCMkfBp9H5m3Ba73fn2COKXn/xoixvhEO7a3YyIZWWcAhKgJq28.','Project Manager',2,0,5,'image5.png','Tuyen Quang',0,'2024-10-24',NULL,NULL),(9,'david.wilson@example.com','David Wilson','4455667788','$2a$10$gnCMkfBp9H5m3Ba73fn2COKXn/xoixvhEO7a3YyIZWWcAhKgJq28.','HR Manager',2,1,1,'image6.png','Ha Noi',0,'2024-10-24',NULL,NULL),(10,'emma.thomas@example.com','Emma Thomas','5566778899','$2a$10$gnCMkfBp9H5m3Ba73fn2COKXn/xoixvhEO7a3YyIZWWcAhKgJq28.','Marketing Lead',2,0,2,'image7.png','My Tho',0,'2024-10-24',NULL,NULL),(11,'oliver.johnson@example.com','Oliver Johnson','6677889900','$2a$10$gnCMkfBp9H5m3Ba73fn2COKXn/xoixvhEO7a3YyIZWWcAhKgJq28.','Intern',2,1,3,'image8.png','Thanh Hoa',1,'2024-10-24',NULL,NULL),(12,'sophia.lee@example.com','Sophia Lee','7788990011','$2a$10$gnCMkfBp9H5m3Ba73fn2COKXn/xoixvhEO7a3YyIZWWcAhKgJq28.','Product Manager',2,0,4,'image9.png','Nam Dinh',1,'2024-10-24',NULL,NULL),(13,'liam.martin@example.com','Liam Martin','8899001122','$2a$10$gnCMkfBp9H5m3Ba73fn2COKXn/xoixvhEO7a3YyIZWWcAhKgJq28.','CTO',2,1,5,'image10.png','Nghe An',0,'2024-10-24',NULL,NULL),(14,'t@gmail.com','dat nguyen','','$2a$10$gnCMkfBp9H5m3Ba73fn2COKXn/xoixvhEO7a3YyIZWWcAhKgJq28.','',1,1,1,'','',0,NULL,NULL,NULL),(15,'u@gmail.com','dat nguyen','','$2a$10$SQurBk/.cN.1EZuh/YPRj.Pg3o40lz4gKSPCIqNRKViPUHlwgeMx6','',1,1,1,'','',0,NULL,NULL,NULL);
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

-- Dump completed on 2024-09-23 12:45:06
