# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2018 Software Assurance Marketplace

use metric;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

LOCK TABLES `metric_tool` WRITE;
INSERT INTO `metric_tool` (`metric_tool_uuid`, `metric_tool_owner_uuid`, `name`, `description`, `tool_sharing_status`, `is_build_needed`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES ('0726f1df-3e40-11e6-a6cc-001a4a81450b','80835e30-d527-11e2-8b8b-0800200c9a66','cloc','cloc counts blank lines, comment lines, and physical lines of source code in many programming languages. https://github.com/AlDanial/cloc','PUBLIC',1,NULL,'2016-07-28 15:01:33',NULL,NULL);
INSERT INTO `metric_tool` (`metric_tool_uuid`, `metric_tool_owner_uuid`, `name`, `description`, `tool_sharing_status`, `is_build_needed`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES ('9692f64b-3e43-11e6-a6cc-001a4a81450b','80835e30-d527-11e2-8b8b-0800200c9a66','Lizard','A code analyzer. https://pypi.python.org/pypi/lizard','PUBLIC',1,NULL,'2016-07-28 15:01:33',NULL,NULL);
UNLOCK TABLES;

LOCK TABLES `metric_tool_version` WRITE;
INSERT INTO `metric_tool_version` (`metric_tool_version_uuid`, `metric_tool_uuid`, `version_no`, `version_string`, `tool_path`, `checksum`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES ('336e327a-de98-11e6-bf70-001a4a81450b','0726f1df-3e40-11e6-a6cc-001a4a81450b',2,'1.70','/swamp/store/SCATools/cloc-1.70.tar.gz','0548025672e536d2c03e385690bdab17d8ae25394581e5d1c821e30936dca21210491c1d9fed662ea732fd7ccea772b30db4717e74c5ab36096273d383a02ec7','root@localhost','2017-01-30 16:17:35',NULL,NULL);
INSERT INTO `metric_tool_version` (`metric_tool_version_uuid`, `metric_tool_uuid`, `version_no`, `version_string`, `tool_path`, `checksum`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES ('3bd56e00-de98-11e6-bf70-001a4a81450b','9692f64b-3e43-11e6-a6cc-001a4a81450b',2,'1.12.7','/swamp/store/SCATools/lizard-1.12.7.tar.gz','b71c323e52b5bf665b9b0596bc709da3ec82c0c64c3836148f987b704947fbb5bea892a30e712533391168fc061a61b7e76d7e554a2103a4b507bf2c620b7fb7','root@localhost','2017-01-30 16:17:36',NULL,NULL);
UNLOCK TABLES;

LOCK TABLES `metric_tool_language` WRITE;
INSERT INTO `metric_tool_language` (`metric_tool_language_id`, `metric_tool_uuid`, `package_type_id`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES (1,'0726f1df-3e40-11e6-a6cc-001a4a81450b',1,NULL,'2016-07-28 15:01:33',NULL,NULL);
INSERT INTO `metric_tool_language` (`metric_tool_language_id`, `metric_tool_uuid`, `package_type_id`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES (2,'0726f1df-3e40-11e6-a6cc-001a4a81450b',2,NULL,'2016-07-28 15:01:33',NULL,NULL);
INSERT INTO `metric_tool_language` (`metric_tool_language_id`, `metric_tool_uuid`, `package_type_id`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES (3,'0726f1df-3e40-11e6-a6cc-001a4a81450b',4,NULL,'2016-07-28 15:01:33',NULL,NULL);
INSERT INTO `metric_tool_language` (`metric_tool_language_id`, `metric_tool_uuid`, `package_type_id`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES (4,'0726f1df-3e40-11e6-a6cc-001a4a81450b',5,NULL,'2016-07-28 15:01:33',NULL,NULL);
INSERT INTO `metric_tool_language` (`metric_tool_language_id`, `metric_tool_uuid`, `package_type_id`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES (5,'0726f1df-3e40-11e6-a6cc-001a4a81450b',6,NULL,'2016-07-28 15:01:33',NULL,NULL);
INSERT INTO `metric_tool_language` (`metric_tool_language_id`, `metric_tool_uuid`, `package_type_id`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES (6,'0726f1df-3e40-11e6-a6cc-001a4a81450b',7,NULL,'2016-07-28 15:01:33',NULL,NULL);
INSERT INTO `metric_tool_language` (`metric_tool_language_id`, `metric_tool_uuid`, `package_type_id`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES (7,'0726f1df-3e40-11e6-a6cc-001a4a81450b',8,NULL,'2016-07-28 15:01:33',NULL,NULL);
INSERT INTO `metric_tool_language` (`metric_tool_language_id`, `metric_tool_uuid`, `package_type_id`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES (8,'0726f1df-3e40-11e6-a6cc-001a4a81450b',9,NULL,'2016-07-28 15:01:33',NULL,NULL);
INSERT INTO `metric_tool_language` (`metric_tool_language_id`, `metric_tool_uuid`, `package_type_id`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES (9,'0726f1df-3e40-11e6-a6cc-001a4a81450b',10,NULL,'2016-07-28 15:01:33',NULL,NULL);
INSERT INTO `metric_tool_language` (`metric_tool_language_id`, `metric_tool_uuid`, `package_type_id`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES (10,'0726f1df-3e40-11e6-a6cc-001a4a81450b',12,NULL,'2016-07-28 15:01:33',NULL,NULL);
INSERT INTO `metric_tool_language` (`metric_tool_language_id`, `metric_tool_uuid`, `package_type_id`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES (11,'9692f64b-3e43-11e6-a6cc-001a4a81450b',1,NULL,'2016-07-28 15:01:33',NULL,NULL);
INSERT INTO `metric_tool_language` (`metric_tool_language_id`, `metric_tool_uuid`, `package_type_id`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES (12,'9692f64b-3e43-11e6-a6cc-001a4a81450b',2,NULL,'2016-07-28 15:01:33',NULL,NULL);
INSERT INTO `metric_tool_language` (`metric_tool_language_id`, `metric_tool_uuid`, `package_type_id`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES (13,'9692f64b-3e43-11e6-a6cc-001a4a81450b',4,NULL,'2016-07-28 15:01:33',NULL,NULL);
INSERT INTO `metric_tool_language` (`metric_tool_language_id`, `metric_tool_uuid`, `package_type_id`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES (14,'9692f64b-3e43-11e6-a6cc-001a4a81450b',5,NULL,'2016-07-28 15:01:33',NULL,NULL);
INSERT INTO `metric_tool_language` (`metric_tool_language_id`, `metric_tool_uuid`, `package_type_id`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES (15,'9692f64b-3e43-11e6-a6cc-001a4a81450b',6,NULL,'2016-07-28 15:01:33',NULL,NULL);
INSERT INTO `metric_tool_language` (`metric_tool_language_id`, `metric_tool_uuid`, `package_type_id`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES (16,'9692f64b-3e43-11e6-a6cc-001a4a81450b',7,NULL,'2016-07-28 15:01:33',NULL,NULL);
INSERT INTO `metric_tool_language` (`metric_tool_language_id`, `metric_tool_uuid`, `package_type_id`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES (17,'9692f64b-3e43-11e6-a6cc-001a4a81450b',8,NULL,'2016-07-28 15:01:33',NULL,NULL);
INSERT INTO `metric_tool_language` (`metric_tool_language_id`, `metric_tool_uuid`, `package_type_id`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES (18,'9692f64b-3e43-11e6-a6cc-001a4a81450b',9,NULL,'2016-07-28 15:01:33',NULL,NULL);
INSERT INTO `metric_tool_language` (`metric_tool_language_id`, `metric_tool_uuid`, `package_type_id`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES (19,'9692f64b-3e43-11e6-a6cc-001a4a81450b',10,NULL,'2016-07-28 15:01:33',NULL,NULL);
INSERT INTO `metric_tool_language` (`metric_tool_language_id`, `metric_tool_uuid`, `package_type_id`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES (20,'9692f64b-3e43-11e6-a6cc-001a4a81450b',12,NULL,'2016-07-28 15:01:33',NULL,NULL);
INSERT INTO `metric_tool_language` (`metric_tool_language_id`, `metric_tool_uuid`, `package_type_id`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES (21,'0726f1df-3e40-11e6-a6cc-001a4a81450b',14,'root@localhost','2017-01-30 16:17:35',NULL,NULL);
INSERT INTO `metric_tool_language` (`metric_tool_language_id`, `metric_tool_uuid`, `package_type_id`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES (22,'9692f64b-3e43-11e6-a6cc-001a4a81450b',14,'root@localhost','2017-01-30 16:17:35',NULL,NULL);
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

