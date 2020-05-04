# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2020 Software Assurance Marketplace

# v1.34.5
use assessment;
drop PROCEDURE if exists upgrade_61;
DELIMITER $$
CREATE PROCEDURE upgrade_61 ()
  BEGIN
    declare script_version_no int;
    declare cur_db_version_no int;
    declare system_type varchar(200);
    set script_version_no = 61;

    select max(database_version_no)
      into cur_db_version_no
      from assessment.database_version;

    if cur_db_version_no < script_version_no then
      begin

        # system_type
        if not exists (select * from assessment.system_setting where system_setting_code = 'SYSTEM_TYPE') then
            insert into assessment.system_setting (system_setting_code, system_setting_value) values ('SYSTEM_TYPE', 'SWAMP_IN_A_BOX');
        end if;
        select system_setting_value
          into system_type
          from assessment.system_setting
         where system_setting_code = 'SYSTEM_TYPE';

        # Add policy_code to assessment_result table
        if exists (select * from information_schema.columns
                    where table_schema = 'assessment'
                      and table_name = 'assessment_result'
                      and column_name = 'policy_code') then
            alter table assessment.assessment_result drop column policy_code;
        end if;
        alter TABLE assessment.assessment_result add column policy_code VARCHAR(100) COMMENT 'if tool requires policy' AFTER tool_uuid;

        # populate policy_code for MIR SWAMP only. Up to this point, Swamp in a Box policy codes have always been null.
        if (system_type = 'MIR_SWAMP') then
          update assessment.assessment_result
             set policy_code = case when tool_uuid = '5540d2be-72b2-11e5-865f-001a4a81450b' then 'codesonar-user-policy'       # GrammaTech CodeSonar
                                    when tool_uuid = '4bb2644d-6440-11e4-a282-001a4a81450b' then 'parasoft-user-c-test-policy' # Parasoft C/C++test
                                    when tool_uuid = '6197a593-6440-11e4-a282-001a4a81450b' then 'parasoft-user-j-test-policy' # Parasoft Jtest
                                    when tool_uuid = '0fac7ff8-4c2e-11e5-83f1-001a4a81450b' then 'red-lizard-user-policy'      # Red Lizard Goanna
                                    when tool_uuid = '1297b728-4a1c-11e7-a337-001a4a81450b' then 'sonatype-user-policy'        # Sonatype Application Health Check
                                    else null end;
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
        delete from assessment.database_version where database_version_no = script_version_no;
        insert into assessment.database_version (database_version_no, description) values (script_version_no, 'upgrade to v1.34.5');

        commit;
      end;
    end if;
END
$$
DELIMITER ;
