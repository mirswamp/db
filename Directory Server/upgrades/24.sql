# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2019 Software Assurance Marketplace

# v1.33
USE project;
DROP PROCEDURE IF EXISTS upgrade_24;
DELIMITER $$
CREATE PROCEDURE upgrade_24 ()
  BEGIN
    DECLARE script_version_no INT;
    DECLARE cur_db_version_no INT;
    declare system_type varchar(200);
    SET script_version_no = 24;

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

        if (system_type = 'MIR_SWAMP') then
          # insert sonatype permission
          delete from project.permission where permission_code = 'sonatype-user';
          insert into project.permission (permission_code, title, description, admin_only_flag, auto_approve_flag,
                                          user_info,
                                          user_info_policy_text,
                                          policy_code)
                                  values ('sonatype-user', 'Sonatype User', 'Permission to access and use the Application Health Check analysis tool of Java from Sonatype.', 0, 1,
                                          '{\n \"name\": {\n           \"type\": \"text\",\n           \"placeholder\": \"First Last\",\n              \"help\": \"Your full name for tool usage.\",\n         \"required\": true\n    },\n\n  \"email\": {\n          \"type\": \"text\",\n           \"placeholder\": \"name@domain\",\n             \"help\": \"The email address that you would like to use with this tool.\",\n           \"required\": true\n    },\n\n  \"organization\": {\n           \"type\": \"text\",\n           \"placeholder\": \"Your organization here\",\n          \"help\": \"This is the name of the organization, university, or company that you are affiliated with.\",\n             \"required\": true\n    },\n\n  \"project url\": {\n            \"type\": \"text\",\n           \"placeholder\": \"http://\",\n         \"help\": \"A URL to a web page about the project that you wish to use this tool for.\",\n              \"required\": false\n   },\n\n  \"user type\": {\n              \"type\":       \"enum\",\n             \"values\": [\"open source\", \"educational\", \"government\", \"commercial\"],\n        \"help\": \"The category of user that you belong to.\"\n        }\n}',
                                          'I understand that my contact information will be sent to Sonatype.',
                                          'sonatype-user-policy');
          # insert sonatype policy
          delete from project.policy where policy_code = 'sonatype-user-policy';
          insert into project.policy (policy_code, description, policy) values ('sonatype-user-policy', 'Sonatype Application Health Check EULA', '<div style=\"white-space: pre-wrap;\">\r\n\r\nSOFTWARE END USER LICENCE TERMS\r\n\r\n<a href="https://www.swampinabox.org/doc/eula_sonatype.pdf" target="_blank">https://www.swampinabox.org/doc/eula_sonatype.pdf</a></div>');
        end if;

        # update database version number
        INSERT INTO project.database_version (database_version_no, description) values (script_version_no, 'upgrade to v1.33');
        COMMIT;

      END;
    END IF;
  END
$$
DELIMITER ;
