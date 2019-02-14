# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2019 Software Assurance Marketplace

# v1.33.4
USE project;
DROP PROCEDURE IF EXISTS upgrade_25;
DELIMITER $$
CREATE PROCEDURE upgrade_25 ()
  BEGIN
    DECLARE script_version_no INT;
    DECLARE cur_db_version_no INT;
    declare system_type varchar(200);
    SET script_version_no = 25;

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

        if (system_type = 'SWAMP_IN_A_BOX') then
          # delete sonatype permission & policy - Could have been inserted with a 1.33.3 install of SWAMP-IN-A-BOX
          delete from project.permission where permission_code = 'sonatype-user';
          delete from project.policy where policy_code = 'sonatype-user-policy';
        end if;

        # update database version number
        INSERT INTO project.database_version (database_version_no, description) values (script_version_no, 'upgrade to v1.33.4');
        COMMIT;

      END;
    END IF;
  END
$$
DELIMITER ;
