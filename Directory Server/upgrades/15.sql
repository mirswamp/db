# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2018 Software Assurance Marketplace

# v1.21
use project;
drop PROCEDURE if exists upgrade_15;
DELIMITER $$
CREATE PROCEDURE upgrade_15 ()
  BEGIN
    declare script_version_no int;
    declare cur_db_version_no int;
    set script_version_no = 15;

    select max(database_version_no)
      into cur_db_version_no
      from project.database_version;

    if cur_db_version_no < script_version_no then
      begin

        # insert Red Lizard Goanna permission
        insert into project.permission (permission_code, title, description, admin_only_flag) values ('red-lizard-admin', 'Red Lizard Admin', 'Red Lizard Administrator', 1);
        insert into project.permission (permission_code, title, description, admin_only_flag, policy_code) values ('red-lizard-user', 'Red Lizard Goanna User', 'Permission to access and use the Goanna static analysis tool for C/C++ from Red Lizard.', 0, 'red-lizard-user-policy');

        # Add Red Lizard Goanna EULA
        insert into project.policy (policy_code, description, policy) values ('red-lizard-user-policy', 'Red Lizard Goanna EULA', '<div style=\"white-space: pre-wrap;\">\r\n\r\nPARTIAL SUMMARY OF SOFTWARE END USER LICENCE TERMS\r\n\r\nLicensor: Goanna Software Pty Limited (ABN 63 136 479 448) trading as Red Lizard Software\r\n\r\nLicensee: End User (referred to as "You" in the EULA)\r\n\r\nSoftware: GOANNA Software\r\n\r\nPermitted Purpose: Solely to use the Software as part of a SWAMP Project\r\n\r\nFor Users of GOANNA software, under the Software Assurance Marketplace ("SWAMP") operated by Morgridge Research Institute at University of Wisconsin\r\n\r\nRed Lizard Software requires all users of their Software to agree to the terms of their End User License Agreement (EULA) as a pre-condition before those users can gain access to the Software. You should read all of the terms of the EULA. In case you don''t, it is important that you should understand:\r\n\r\n1. The Software can only be used as part of your participation in an accredited SWAMP Project. You cannot use the Software for any other purpose that is not directly part of the SWAMP project. You cannot make copies or redistribute it or use it after the SWAMP project terminates.\r\n\r\n2. Red Lizards may use and publicly reveal some information arising from your use of the Goanna software in the SWAMP Project. That could include your name and company logo. Red Lizards may contact you to obtain your feedback too.\r\n\r\n3. The license could terminate without notice if Red Lizard Software ceases to participate in the SWAMP. If that happened, you could no longer use the Software.\r\n\r\n4. This version of the Software is provided free of charge for educational, experimental and comparative purposes as part of the SWAMP. You should not rely upon the Software for any critical or commercial functions.\r\n\r\n5. For more details about these matters and to understand the other terms of the license, please read the full EULA: <a href="https://continuousassurance.org/swamp/eula_goanna_swamp.pdf" target="_blank">https://continuousassurance.org/swamp/eula_goanna_swamp.pdf</a>\r\n\r\n</div>');

        # Add exclude_public_tools_flag to project table
        ALTER TABLE project.project
          ADD COLUMN exclude_public_tools_flag tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Exclude public tools from project: 0=false 1=true' AFTER trial_project_flag;

        # Resize columns on user_permission table
        ALTER TABLE project.user_permission
          CHANGE COLUMN user_comment     user_comment      VARCHAR(500) COMMENT 'why requested by user',
          CHANGE COLUMN admin_comment    admin_comment     VARCHAR(500) COMMENT 'why granted or denied by admin',
          CHANGE COLUMN meta_information meta_information  VARCHAR(500) COMMENT 'user info specific to request';

        # Create user_permission_history table
        CREATE TABLE project.user_permission_history (
          user_permission_history_id  INT  NOT NULL AUTO_INCREMENT               COMMENT 'internal id',
          user_permission_uid       VARCHAR(45)  NOT NULL                        COMMENT 'internal id',
          permission_code           VARCHAR(100) NOT NULL                        COMMENT 'permission being granted',
          user_uid                  VARCHAR(45)  NOT NULL                        COMMENT 'user uuid',
          user_comment              VARCHAR(500)                                 COMMENT 'why requested by user',
          admin_comment             VARCHAR(500)                                 COMMENT 'why granted or denied by admin',
          meta_information          VARCHAR(500)                                 COMMENT 'user info specific to request',
          request_date              DATETIME                                     COMMENT 'date requested',
          grant_date                DATETIME                                     COMMENT 'date granted',
          denial_date               DATETIME                                     COMMENT 'date denied',
          expiration_date           DATETIME                                     COMMENT 'date expires',
          delete_date               DATETIME                                     COMMENT 'date revoked',
          change_date               TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record changed',
          PRIMARY KEY (user_permission_history_id)
         )COMMENT='user permission history';

        # update database version number
        insert into project.database_version (database_version_no, description) values (script_version_no, 'upgrade to v1.21');
        commit;
      end;
    end if;
END
$$
DELIMITER ;
