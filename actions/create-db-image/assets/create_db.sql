DROP DATABASE IF EXISTS `addressbook`;

CREATE DATABASE `addressbook`;

USE `addressbook`;

DROP TABLE IF EXISTS `t_other_name`;
DROP TABLE IF EXISTS `t_other_name_type`;
DROP TABLE IF EXISTS `t_person`;

CREATE TABLE `t_other_name_type` (
  `other_name_type_id` int NOT NULL AUTO_INCREMENT,
  `other_name_type` varchar(45) NOT NULL,
  PRIMARY KEY (`other_name_type_id`),
  UNIQUE KEY `other_name_type_UNIQUE` (`other_name_type`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

LOCK TABLES `t_other_name_type` WRITE;

INSERT INTO `t_other_name_type` VALUES (4,'Firstname Alias'),(6,'Firstname at birth'),(9,'Lastname Alias'),(7,'Lastname at birth'),(1,'Middle Name'),(8,'Middle Name at birth'),(5,'Nickname');

UNLOCK TABLES;


CREATE TABLE `t_person` (
  `person_id` int NOT NULL AUTO_INCREMENT,
  `firstname` varchar(45) NOT NULL,
  `lastname` varchar(45) NOT NULL,
  `birth_date` date NOT NULL,
  PRIMARY KEY (`person_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

LOCK TABLES `t_person` WRITE;

INSERT INTO `t_person` VALUES (1,'Edmund','Barton','1849-01-18'),(2,'Alfred','Deakin','1856-08-03'),(3,'Chris','Watson','1867-04-09'),(4,'George','Reid','1845-02-25'),(5,'test-first-name','test-last-name','2020-12-01'),(16,'Mike','Tyson','1965-03-23');

UNLOCK TABLES;




CREATE TABLE `t_other_name` (
  `other_name_id` int NOT NULL AUTO_INCREMENT,
  `other_name` varchar(45) NOT NULL,
  `person_id` int NOT NULL,
  `other_name_type_id` int NOT NULL,
  PRIMARY KEY (`other_name_id`),
  KEY `fk_person_idx` (`person_id`),
  KEY `fk_other_name_type_idx` (`other_name_type_id`),
  CONSTRAINT `fk_other_name_type` FOREIGN KEY (`other_name_type_id`) REFERENCES `t_other_name_type` (`other_name_type_id`),
  CONSTRAINT `fk_person` FOREIGN KEY (`person_id`) REFERENCES `t_person` (`person_id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

LOCK TABLES `t_other_name` WRITE;

INSERT INTO `t_other_name` VALUES (1,'Toby',1,4),(2,'Johans',3,6),(3,'Tanck',3,7),(4,'Cristian',3,8),(5,'Christian',3,1),(6,'Houston',4,1),(23,'Josh',3,4),(24,'tom',5,4),(25,'The Beast',16,5),(26,'Brute Force',16,5);

UNLOCK TABLES;

DROP USER IF EXISTS addrbkuser@localhost;

CREATE USER addrbkuser@localhost IDENTIFIED BY 'addr3ssb00k';

GRANT ALL PRIVILEGES ON addressbook.* TO addrbkuser@localhost;
