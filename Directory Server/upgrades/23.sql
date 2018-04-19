# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2018 Software Assurance Marketplace

# v1.32 Classes
USE project;
DROP PROCEDURE IF EXISTS upgrade_23;
DELIMITER $$
CREATE PROCEDURE upgrade_23 ()
  BEGIN
    DECLARE script_version_no INT;
    DECLARE cur_db_version_no INT;
    declare system_type varchar(200);
    SET script_version_no = 23;

    SELECT max(database_version_no)
      INTO cur_db_version_no
      FROM project.database_version;

    IF cur_db_version_no < script_version_no THEN
      BEGIN

        # New class table
        DROP TABLE IF EXISTS project.class;
        CREATE TABLE project.class (
          class_uuid                 VARCHAR(45) NOT NULL                         COMMENT 'uuid',
          class_code                 VARCHAR(45) NOT NULL                         COMMENT 'class id',
          description                VARCHAR(500)                                 COMMENT 'description',
          start_date                 TIMESTAMP NULL DEFAULT NULL                  COMMENT 'class start date',
          end_date                   TIMESTAMP NULL DEFAULT NULL                  COMMENT 'class end date',
          commercial_tool_access     tinyint(1) NOT NULL DEFAULT 0                COMMENT '0=false 1=true',
          create_user                VARCHAR(25)                                  COMMENT 'db user that inserted record',
          create_date                TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
          update_user                VARCHAR(25)                                  COMMENT 'db user that last updated record',
          update_date                TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record last updated',
          delete_date                TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record deleted',
          PRIMARY KEY (class_uuid),
          CONSTRAINT class_code_unique UNIQUE (class_code)
         ) COMMENT='class';

        # New class_user table
        DROP TABLE IF EXISTS project.class_user;
        CREATE TABLE project.class_user (
          class_user_uuid            VARCHAR(45) NOT NULL                         COMMENT 'uuid',
          class_code                 VARCHAR(45) NOT NULL                         COMMENT 'class id',
          user_uid                   VARCHAR(45)                                  COMMENT 'user uuid',
          admin_flag                 tinyint(1) NOT NULL DEFAULT 0                COMMENT 'Is user a class admin: 0=false 1=true',
          create_user                VARCHAR(25)                                  COMMENT 'db user that inserted record',
          create_date                TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
          update_user                VARCHAR(25)                                  COMMENT 'db user that last updated record',
          update_date                TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record last updated',
          delete_date                TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record deleted',
          PRIMARY KEY (class_user_uuid)
          #,CONSTRAINT class_user_unique UNIQUE (class_code, user_uid)
         ) COMMENT='class-user cross reference';

        # update database version number
        INSERT INTO project.database_version (database_version_no, description) values (script_version_no, 'upgrade to v1.32-2');
        COMMIT;

      END;
    END IF;
  END
$$
DELIMITER ;
