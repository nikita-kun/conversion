# ************************************************************
# Sequel Pro SQL dump
# Version 4135
#
# http://www.sequelpro.com/
# http://code.google.com/p/sequel-pro/
#
# Host: localhost (MySQL 5.5.42)
# Database: test_database
# Generation Time: 2016-10-29 20:14:39 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table clients
# ------------------------------------------------------------

CREATE TABLE `clients` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `surname` tinytext,
  `name` tinytext,
  `phone` varchar(15) NOT NULL DEFAULT '',
  `status` enum('new','registered','refused','unreachable') DEFAULT 'new',
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `time_index` (`time`),
  KEY `name_index` (`surname`(12),`name`(12),`phone`),
  KEY `phone_index` (`phone`),
  KEY `status_index` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;




--
-- Dumping routines (PROCEDURE) for database 'test_database'
--
DELIMITER ;;

# Dump of PROCEDURE conversion
# ------------------------------------------------------------

/*!50003 DROP PROCEDURE IF EXISTS `conversion` */;;
/*!50003 SET SESSION SQL_MODE=""*/;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `conversion`(interval_days INT)
BEGIN
	DECLARE start_date, end_date DATE;
	DECLARE total_sum, registered_sum INT DEFAULT 0;
	
	#Set up start date from the earliest client 
	#and calculate end date accordingly
	SET start_date = (SELECT MIN(`time`) FROM `clients`);
	SET end_date = start_date + INTERVAL interval_days DAY;
	
	#Create temp table to store conversion
	CREATE TEMPORARY TABLE IF NOT EXISTS `date_range` (`date` DATE NOT NULL, `registered` INT, `total` INT, `conversion` FLOAT);
	
	#Check and correct the parameter
	IF (interval_days <= 0) THEN 
		SET interval_days = 1;
	END IF;
	
	#Loop while incrementing start and end dates
	#Calculate registered and total users and
	#put statistics into the temporary table
   WHILE end_date <= CURRENT_TIMESTAMP() DO
    	
    	#getting a sum of previously registered users and users registered in interval
		SET registered_sum = registered_sum + 
			(SELECT COUNT(*) FROM `clients` WHERE `time` >= start_date AND `time` <= end_date AND `status`='registered');
		
		#getting a sum of all previous users and new interval	users
    	SET total_sum = total_sum + 
    		(SELECT COUNT(*) FROM `clients` WHERE `time` >= start_date AND `time` <= end_date);
    	
    	#insert interval conversion	
      INSERT INTO `date_range` VALUES (end_date, registered_sum, total_sum, registered_sum / total_sum);
      
      #setup new interval
      SET start_date = end_date;
      SET end_date = end_date + INTERVAL interval_days DAY;
	END WHILE;

	#output result 
	SELECT * FROM `date_range`;
	
	#drop temp table
	DROP TEMPORARY TABLE IF EXISTS `date_range`;

END */;;

/*!50003 SET SESSION SQL_MODE=@OLD_SQL_MODE */;;
DELIMITER ;

/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
