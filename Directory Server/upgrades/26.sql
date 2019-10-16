# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2019 Software Assurance Marketplace

# v1.34.4
USE project;
DROP PROCEDURE IF EXISTS upgrade_26;
DELIMITER $$
CREATE PROCEDURE upgrade_26 ()
  BEGIN
    DECLARE script_version_no INT;
    DECLARE cur_db_version_no INT;
    declare system_type varchar(200);
    SET script_version_no = 26;

    SELECT max(database_version_no)
      INTO cur_db_version_no
      FROM project.database_version;

    IF cur_db_version_no < script_version_no THEN
      BEGIN

        # system_type
        # Check if system_setting table exists
        if exists (select * from information_schema.tables
                    where table_schema = 'assessment'
                      and table_name = 'system_setting')
        then
          # check if system_setting table contains a SYSTEM_TYPE value
          if not exists (select * from assessment.system_setting where system_setting_code = 'SYSTEM_TYPE') then
              insert into assessment.system_setting (system_setting_code, system_setting_value) values ('SYSTEM_TYPE', 'SWAMP_IN_A_BOX');
          end if;
          select system_setting_value
            into system_type
            from assessment.system_setting
           where system_setting_code = 'SYSTEM_TYPE';
        else
          set system_type = 'MIR_SWAMP';
        end if;

        # New sessions table
        DROP TABLE IF EXISTS project.sessions;
        CREATE TABLE project.sessions (
          id varchar(255) NOT NULL,
          user_id varchar(36) DEFAULT NULL,
          ip_address varchar(45) DEFAULT NULL,
          user_agent text,
          payload text NOT NULL,
          last_activity int(11) NOT NULL,
          PRIMARY KEY (id)
        );

        # update database version number
        INSERT INTO project.database_version (database_version_no, description) values (script_version_no, 'upgrade to v1.34.5');
        COMMIT;

      END;
    END IF;
  END
$$
DELIMITER ;
