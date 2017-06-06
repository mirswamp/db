# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2017 Software Assurance Marketplace

# v1.30
USE project;
DROP PROCEDURE IF EXISTS upgrade_20;
DELIMITER $$
CREATE PROCEDURE upgrade_20 ()
  BEGIN
    DECLARE script_version_no INT;
    DECLARE cur_db_version_no INT;
    SET script_version_no = 20;

    SELECT max(database_version_no)
      INTO cur_db_version_no
      FROM project.database_version;

    IF cur_db_version_no < script_version_no THEN
      BEGIN

        # add new table for application passwords
        CREATE TABLE IF NOT EXISTS project.app_passwords (
          app_password_id   INT          NOT NULL AUTO_INCREMENT            COMMENT 'internal id',
          app_password_uuid VARCHAR(45)  NOT NULL                           COMMENT 'app password uuid',
          user_uid          VARCHAR(127) NOT NULL                           COMMENT 'user uuid',
          password          VARCHAR(127) NOT NULL                           COMMENT 'password hash',
          label             VARCHAR(63)                                     COMMENT 'optional label',
          create_date       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'creation date',
          update_date       TIMESTAMP    NULL DEFAULT NULL                  COMMENT 'update date',
          PRIMARY KEY (app_password_id)
        ) COMMENT='application passwords';

        # update database version number
        INSERT INTO project.database_version (database_version_no, description) values (script_version_no, 'upgrade to v1.30');
        COMMIT;

      END;
    END IF;
  END
$$
DELIMITER ;
