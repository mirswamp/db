# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2016 Software Assurance Marketplace

use platform_store;

/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

LOCK TABLES `platform` WRITE;
INSERT INTO `platform` (`platform_uuid`, `platform_owner_uuid`, `name`, `description`, `platform_sharing_status`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES ('03e6bc67-7c3f-11e6-88bc-001a4a81450b',NULL,'Scientific Linux 5 64-bit',NULL,'PUBLIC','pschell@pschell.mirsam.or','2016-09-16 20:19:59',NULL,NULL);
INSERT INTO `platform` (`platform_uuid`, `platform_owner_uuid`, `name`, `description`, `platform_sharing_status`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES ('071890c4-7c3b-11e6-88bc-001a4a81450b',NULL,'CentOS Linux 6 64-bit',NULL,'PUBLIC','pschell@pschell.mirsam.or','2016-09-16 20:19:59',NULL,NULL);
INSERT INTO `platform` (`platform_uuid`, `platform_owner_uuid`, `name`, `description`, `platform_sharing_status`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES ('1088c3ce-20aa-11e3-9a3e-001a4a81450b',NULL,'Ubuntu Linux',NULL,'PUBLIC','pschell@pschell.mirsam.or','2016-09-16 20:19:59',NULL,NULL);
INSERT INTO `platform` (`platform_uuid`, `platform_owner_uuid`, `name`, `description`, `platform_sharing_status`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES ('4604e180-7c3a-11e6-88bc-001a4a81450b',NULL,'CentOS Linux 5 32-bit',NULL,'PUBLIC','pschell@pschell.mirsam.or','2016-09-16 20:19:59',NULL,NULL);
INSERT INTO `platform` (`platform_uuid`, `platform_owner_uuid`, `name`, `description`, `platform_sharing_status`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES ('48f9a9b0-976f-11e4-829b-001a4a81450b',NULL,'Android',NULL,'PUBLIC','pschell@pschell.mirsam.or','2016-09-16 20:19:59',NULL,NULL);
INSERT INTO `platform` (`platform_uuid`, `platform_owner_uuid`, `name`, `description`, `platform_sharing_status`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES ('8a51ecea-209d-11e3-9a3e-001a4a81450b',NULL,'Fedora Linux',NULL,'PUBLIC','pschell@pschell.mirsam.or','2016-09-16 20:19:59',NULL,NULL);
INSERT INTO `platform` (`platform_uuid`, `platform_owner_uuid`, `name`, `description`, `platform_sharing_status`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES ('8d5b61ff-7c3f-11e6-88bc-001a4a81450b',NULL,'Scientific Linux 6 32-bit',NULL,'PUBLIC','pschell@pschell.mirsam.or','2016-09-16 20:19:59',NULL,NULL);
INSERT INTO `platform` (`platform_uuid`, `platform_owner_uuid`, `name`, `description`, `platform_sharing_status`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES ('9369ab7a-7c3a-11e6-88bc-001a4a81450b',NULL,'CentOS Linux 5 62-bit',NULL,'PUBLIC','pschell@pschell.mirsam.or','2016-09-16 20:19:59',NULL,NULL);
INSERT INTO `platform` (`platform_uuid`, `platform_owner_uuid`, `name`, `description`, `platform_sharing_status`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES ('a4f024eb-f317-11e3-8775-001a4a81450b',NULL,'Scientific Linux 5 32-bit',NULL,'PUBLIC','pschell@pschell.mirsam.or','2016-09-16 20:19:59',NULL,NULL);
INSERT INTO `platform` (`platform_uuid`, `platform_owner_uuid`, `name`, `description`, `platform_sharing_status`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES ('d531f0f0-f273-11e3-8775-001a4a81450b',NULL,'Red Hat Enterprise Linux 6 32-bit',NULL,'PUBLIC','pschell@pschell.mirsam.or','2016-09-16 20:19:59',NULL,NULL);
INSERT INTO `platform` (`platform_uuid`, `platform_owner_uuid`, `name`, `description`, `platform_sharing_status`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES ('d95fcb5f-209d-11e3-9a3e-001a4a81450b',NULL,'Scientific Linux 6 64-bit',NULL,'PUBLIC','pschell@pschell.mirsam.or','2016-09-16 20:19:59',NULL,NULL);
INSERT INTO `platform` (`platform_uuid`, `platform_owner_uuid`, `name`, `description`, `platform_sharing_status`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES ('ee2c1193-209b-11e3-9a3e-001a4a81450b',NULL,'Debian Linux',NULL,'PUBLIC','pschell@pschell.mirsam.or','2016-09-16 20:19:59',NULL,NULL);
INSERT INTO `platform` (`platform_uuid`, `platform_owner_uuid`, `name`, `description`, `platform_sharing_status`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES ('ef10a44c-7c3a-11e6-88bc-001a4a81450b',NULL,'CentOS Linux 6 32-bit',NULL,'PUBLIC','pschell@pschell.mirsam.or','2016-09-16 20:19:59',NULL,NULL);
INSERT INTO `platform` (`platform_uuid`, `platform_owner_uuid`, `name`, `description`, `platform_sharing_status`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES ('fc55810b-09d7-11e3-a239-001a4a81450b',NULL,'Red Hat Enterprise Linux 6 64-bit',NULL,'PUBLIC','pschell@pschell.mirsam.or','2016-09-16 20:19:59',NULL,NULL);
UNLOCK TABLES;

LOCK TABLES `platform_version` WRITE;
INSERT INTO `platform_version` (`platform_version_uuid`, `platform_uuid`, `version_no`, `version_string`, `release_date`, `retire_date`, `comment_public`, `comment_private`, `platform_path`, `checksum`, `invocation_cmd`, `deployment_cmd`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES ('03b18efe-7c41-11e6-88bc-001a4a81450b','1088c3ce-20aa-11e3-9a3e-001a4a81450b',4,'16.04 LTS 64-bit Xenial Xerus',NULL,NULL,NULL,NULL,'ubuntu-16.04-64',NULL,NULL,NULL,'pschell@pschell.mirsam.or','2016-09-16 20:19:59',NULL,NULL);
INSERT INTO `platform_version` (`platform_version_uuid`, `platform_uuid`, `version_no`, `version_string`, `release_date`, `retire_date`, `comment_public`, `comment_private`, `platform_path`, `checksum`, `invocation_cmd`, `deployment_cmd`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES ('0cda9b68-7c3c-11e6-88bc-001a4a81450b','ee2c1193-209b-11e3-9a3e-001a4a81450b',2,'8.5 64-bit',NULL,NULL,NULL,NULL,'debian-8.5-64',NULL,NULL,NULL,'pschell@pschell.mirsam.or','2016-09-16 20:19:59',NULL,NULL);
INSERT INTO `platform_version` (`platform_version_uuid`, `platform_uuid`, `version_no`, `version_string`, `release_date`, `retire_date`, `comment_public`, `comment_private`, `platform_path`, `checksum`, `invocation_cmd`, `deployment_cmd`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES ('18f66e9a-20aa-11e3-9a3e-001a4a81450b','1088c3ce-20aa-11e3-9a3e-001a4a81450b',2,'12.04 LTS 64-bit Precise Pangolin',NULL,NULL,NULL,NULL,'ubuntu-12.04-64',NULL,NULL,NULL,'pschell@pschell.mirsam.or','2016-09-16 20:19:59',NULL,NULL);
INSERT INTO `platform_version` (`platform_version_uuid`, `platform_uuid`, `version_no`, `version_string`, `release_date`, `retire_date`, `comment_public`, `comment_private`, `platform_path`, `checksum`, `invocation_cmd`, `deployment_cmd`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES ('1c5cbe39-7c3b-11e6-88bc-001a4a81450b','071890c4-7c3b-11e6-88bc-001a4a81450b',1,'6.7 64-bit',NULL,NULL,NULL,NULL,'centos-6.7-64',NULL,NULL,NULL,'pschell@pschell.mirsam.or','2016-09-16 20:19:59',NULL,NULL);
INSERT INTO `platform_version` (`platform_version_uuid`, `platform_uuid`, `version_no`, `version_string`, `release_date`, `retire_date`, `comment_public`, `comment_private`, `platform_path`, `checksum`, `invocation_cmd`, `deployment_cmd`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES ('35bc77b9-7d3e-11e3-88bb-001a4a81450b','a4f024eb-f317-11e3-8775-001a4a81450b',1,'5.9 32-bit',NULL,NULL,NULL,NULL,'scientific-5.9-32',NULL,NULL,NULL,'pschell@pschell.mirsam.or','2016-09-16 20:19:59',NULL,NULL);
INSERT INTO `platform_version` (`platform_version_uuid`, `platform_uuid`, `version_no`, `version_string`, `release_date`, `retire_date`, `comment_public`, `comment_private`, `platform_path`, `checksum`, `invocation_cmd`, `deployment_cmd`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES ('54053a13-7c3f-11e6-88bc-001a4a81450b','03e6bc67-7c3f-11e6-88bc-001a4a81450b',1,'5.11 64-bit',NULL,NULL,NULL,NULL,'scientific-5.11-64',NULL,NULL,NULL,'pschell@pschell.mirsam.or','2016-09-16 20:19:59',NULL,NULL);
INSERT INTO `platform_version` (`platform_version_uuid`, `platform_uuid`, `version_no`, `version_string`, `release_date`, `retire_date`, `comment_public`, `comment_private`, `platform_path`, `checksum`, `invocation_cmd`, `deployment_cmd`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES ('73c7f6be-7c3a-11e6-88bc-001a4a81450b','4604e180-7c3a-11e6-88bc-001a4a81450b',1,'5.11 32-bit',NULL,NULL,NULL,NULL,'centos-5.11-32',NULL,NULL,NULL,'pschell@pschell.mirsam.or','2016-09-16 20:19:59',NULL,NULL);
INSERT INTO `platform_version` (`platform_version_uuid`, `platform_uuid`, `version_no`, `version_string`, `release_date`, `retire_date`, `comment_public`, `comment_private`, `platform_path`, `checksum`, `invocation_cmd`, `deployment_cmd`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES ('89b4f7fd-7c3d-11e6-88bc-001a4a81450b','8a51ecea-209d-11e3-9a3e-001a4a81450b',3,'20 64-bit',NULL,NULL,NULL,NULL,'fedora-20-64',NULL,NULL,NULL,'pschell@pschell.mirsam.or','2016-09-16 20:19:59',NULL,NULL);
INSERT INTO `platform_version` (`platform_version_uuid`, `platform_uuid`, `version_no`, `version_string`, `release_date`, `retire_date`, `comment_public`, `comment_private`, `platform_path`, `checksum`, `invocation_cmd`, `deployment_cmd`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES ('8efe5502-7c3d-11e6-88bc-001a4a81450b','8a51ecea-209d-11e3-9a3e-001a4a81450b',4,'21 64-bit',NULL,NULL,NULL,NULL,'fedora-21-64',NULL,NULL,NULL,'pschell@pschell.mirsam.or','2016-09-16 20:19:59',NULL,NULL);
INSERT INTO `platform_version` (`platform_version_uuid`, `platform_uuid`, `version_no`, `version_string`, `release_date`, `retire_date`, `comment_public`, `comment_private`, `platform_path`, `checksum`, `invocation_cmd`, `deployment_cmd`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES ('8f4878ec-976f-11e4-829b-001a4a81450b','48f9a9b0-976f-11e4-829b-001a4a81450b',1,'Android on Ubuntu 12.04 64-bit',NULL,NULL,NULL,NULL,'android-ubuntu-12.04-64',NULL,NULL,NULL,'pschell@pschell.mirsam.or','2016-09-16 20:19:59',NULL,NULL);
INSERT INTO `platform_version` (`platform_version_uuid`, `platform_uuid`, `version_no`, `version_string`, `release_date`, `retire_date`, `comment_public`, `comment_private`, `platform_path`, `checksum`, `invocation_cmd`, `deployment_cmd`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES ('9e559543-7c3d-11e6-88bc-001a4a81450b','8a51ecea-209d-11e3-9a3e-001a4a81450b',5,'22 64-bit',NULL,NULL,NULL,NULL,'fedora-22-64',NULL,NULL,NULL,'pschell@pschell.mirsam.or','2016-09-16 20:19:59',NULL,NULL);
INSERT INTO `platform_version` (`platform_version_uuid`, `platform_uuid`, `version_no`, `version_string`, `release_date`, `retire_date`, `comment_public`, `comment_private`, `platform_path`, `checksum`, `invocation_cmd`, `deployment_cmd`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES ('a41798c7-7c3d-11e6-88bc-001a4a81450b','8a51ecea-209d-11e3-9a3e-001a4a81450b',6,'23 64-bit',NULL,NULL,NULL,NULL,'fedora-23-64',NULL,NULL,NULL,'pschell@pschell.mirsam.or','2016-09-16 20:19:59',NULL,NULL);
INSERT INTO `platform_version` (`platform_version_uuid`, `platform_uuid`, `version_no`, `version_string`, `release_date`, `retire_date`, `comment_public`, `comment_private`, `platform_path`, `checksum`, `invocation_cmd`, `deployment_cmd`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES ('a72c3ab6-7c3f-11e6-88bc-001a4a81450b','8d5b61ff-7c3f-11e6-88bc-001a4a81450b',1,'6.7 32-bit',NULL,NULL,NULL,NULL,'scientific-6.7-32',NULL,NULL,NULL,'pschell@pschell.mirsam.or','2016-09-16 20:19:59',NULL,NULL);
INSERT INTO `platform_version` (`platform_version_uuid`, `platform_uuid`, `version_no`, `version_string`, `release_date`, `retire_date`, `comment_public`, `comment_private`, `platform_path`, `checksum`, `invocation_cmd`, `deployment_cmd`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES ('a75ddd12-7c3e-11e6-88bc-001a4a81450b','fc55810b-09d7-11e3-a239-001a4a81450b',1,'6.7 64-bit',NULL,NULL,NULL,NULL,'rhel-6.7-64',NULL,NULL,NULL,'pschell@pschell.mirsam.or','2016-09-16 20:19:59',NULL,NULL);
INSERT INTO `platform_version` (`platform_version_uuid`, `platform_uuid`, `version_no`, `version_string`, `release_date`, `retire_date`, `comment_public`, `comment_private`, `platform_path`, `checksum`, `invocation_cmd`, `deployment_cmd`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES ('a9cfe21f-209d-11e3-9a3e-001a4a81450b','8a51ecea-209d-11e3-9a3e-001a4a81450b',1,'18 64-bit',NULL,NULL,NULL,NULL,'fedora-18-64',NULL,NULL,NULL,'pschell@pschell.mirsam.or','2016-09-16 20:19:59',NULL,NULL);
INSERT INTO `platform_version` (`platform_version_uuid`, `platform_uuid`, `version_no`, `version_string`, `release_date`, `retire_date`, `comment_public`, `comment_private`, `platform_path`, `checksum`, `invocation_cmd`, `deployment_cmd`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES ('aebc38c3-209d-11e3-9a3e-001a4a81450b','8a51ecea-209d-11e3-9a3e-001a4a81450b',2,'19 64-bit',NULL,NULL,NULL,NULL,'fedora-19-64',NULL,NULL,NULL,'pschell@pschell.mirsam.or','2016-09-16 20:19:59',NULL,NULL);
INSERT INTO `platform_version` (`platform_version_uuid`, `platform_uuid`, `version_no`, `version_string`, `release_date`, `retire_date`, `comment_public`, `comment_private`, `platform_path`, `checksum`, `invocation_cmd`, `deployment_cmd`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES ('b0425ce1-7c3d-11e6-88bc-001a4a81450b','8a51ecea-209d-11e3-9a3e-001a4a81450b',7,'24 64-bit',NULL,NULL,NULL,NULL,'fedora-24-64',NULL,NULL,NULL,'pschell@pschell.mirsam.or','2016-09-16 20:19:59',NULL,NULL);
INSERT INTO `platform_version` (`platform_version_uuid`, `platform_uuid`, `version_no`, `version_string`, `release_date`, `retire_date`, `comment_public`, `comment_private`, `platform_path`, `checksum`, `invocation_cmd`, `deployment_cmd`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES ('bf9ddb9c-7c3a-11e6-88bc-001a4a81450b','9369ab7a-7c3a-11e6-88bc-001a4a81450b',1,'5.11 64-bit',NULL,NULL,NULL,NULL,'centos-5.11-64',NULL,NULL,NULL,'pschell@pschell.mirsam.or','2016-09-16 20:19:59',NULL,NULL);
INSERT INTO `platform_version` (`platform_version_uuid`, `platform_uuid`, `version_no`, `version_string`, `release_date`, `retire_date`, `comment_public`, `comment_private`, `platform_path`, `checksum`, `invocation_cmd`, `deployment_cmd`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES ('e7959cde-7c3e-11e6-88bc-001a4a81450b','a4f024eb-f317-11e3-8775-001a4a81450b',2,'5.11 32-bit',NULL,NULL,NULL,NULL,'scientific-5.11-32',NULL,NULL,NULL,'pschell@pschell.mirsam.or','2016-09-16 20:19:59',NULL,NULL);
INSERT INTO `platform_version` (`platform_version_uuid`, `platform_uuid`, `version_no`, `version_string`, `release_date`, `retire_date`, `comment_public`, `comment_private`, `platform_path`, `checksum`, `invocation_cmd`, `deployment_cmd`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES ('eaa6cf77-7c3b-11e6-88bc-001a4a81450b','ee2c1193-209b-11e3-9a3e-001a4a81450b',1,'7.11 64-bit',NULL,NULL,NULL,NULL,'debian-7.11-64',NULL,NULL,NULL,'pschell@pschell.mirsam.or','2016-09-16 20:19:59',NULL,NULL);
INSERT INTO `platform_version` (`platform_version_uuid`, `platform_uuid`, `version_no`, `version_string`, `release_date`, `retire_date`, `comment_public`, `comment_private`, `platform_path`, `checksum`, `invocation_cmd`, `deployment_cmd`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES ('eacab258-7c3f-11e6-88bc-001a4a81450b','d95fcb5f-209d-11e3-9a3e-001a4a81450b',2,'6.7 64-bit',NULL,NULL,NULL,NULL,'scientific-6.7-64',NULL,NULL,NULL,'pschell@pschell.mirsam.or','2016-09-16 20:19:59',NULL,NULL);
INSERT INTO `platform_version` (`platform_version_uuid`, `platform_uuid`, `version_no`, `version_string`, `release_date`, `retire_date`, `comment_public`, `comment_private`, `platform_path`, `checksum`, `invocation_cmd`, `deployment_cmd`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES ('f272a429-7c3d-11e6-88bc-001a4a81450b','d531f0f0-f273-11e3-8775-001a4a81450b',1,'6.7 32-bit',NULL,NULL,NULL,NULL,'rhel-6.7-32',NULL,NULL,NULL,'pschell@pschell.mirsam.or','2016-09-16 20:19:59',NULL,NULL);
INSERT INTO `platform_version` (`platform_version_uuid`, `platform_uuid`, `version_no`, `version_string`, `release_date`, `retire_date`, `comment_public`, `comment_private`, `platform_path`, `checksum`, `invocation_cmd`, `deployment_cmd`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES ('f496f2ae-7c40-11e6-88bc-001a4a81450b','1088c3ce-20aa-11e3-9a3e-001a4a81450b',1,'10.04 LTS 64-bit Lucid Lynx',NULL,NULL,NULL,NULL,'ubuntu-10.04-64',NULL,NULL,NULL,'pschell@pschell.mirsam.or','2016-09-16 20:19:59',NULL,NULL);
INSERT INTO `platform_version` (`platform_version_uuid`, `platform_uuid`, `version_no`, `version_string`, `release_date`, `retire_date`, `comment_public`, `comment_private`, `platform_path`, `checksum`, `invocation_cmd`, `deployment_cmd`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES ('fa5ee864-7c3a-11e6-88bc-001a4a81450b','ef10a44c-7c3a-11e6-88bc-001a4a81450b',1,'6.7 32-bit',NULL,NULL,NULL,NULL,'centos-6.7-32',NULL,NULL,NULL,'pschell@pschell.mirsam.or','2016-09-16 20:19:59',NULL,NULL);
INSERT INTO `platform_version` (`platform_version_uuid`, `platform_uuid`, `version_no`, `version_string`, `release_date`, `retire_date`, `comment_public`, `comment_private`, `platform_path`, `checksum`, `invocation_cmd`, `deployment_cmd`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES ('fd924363-7c40-11e6-88bc-001a4a81450b','1088c3ce-20aa-11e3-9a3e-001a4a81450b',3,'14.04 LTS 64-bit Trusty Tahr',NULL,NULL,NULL,NULL,'ubuntu-14.04-64',NULL,NULL,NULL,'pschell@pschell.mirsam.or','2016-09-16 20:19:59',NULL,NULL);
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
