# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2017 Software Assurance Marketplace

# v1.29
use project;
drop PROCEDURE if exists upgrade_19;
DELIMITER $$
CREATE PROCEDURE upgrade_19 ()
  BEGIN
    declare script_version_no int;
    declare cur_db_version_no int;
    declare system_type varchar(200);
    set script_version_no = 19;

    select max(database_version_no)
      into cur_db_version_no
      from project.database_version;

    if cur_db_version_no < script_version_no then
      begin

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
          # insert GrammaTech CodeSonar permission
          delete from project.permission where permission_code = 'codesonar-user';
          insert into project.permission (permission_code, title, description, admin_only_flag, policy_code) values ('codesonar-user', 'CodeSonar User', 'Permission to access and use the CodeSonar static analysis tool for C/C++ from GrammaTech.', 0, 'codesonar-user-policy');
          # insert GrammaTech policy
          delete from project.policy where policy_code = 'codesonar-user-policy';
          insert into project.policy (policy_code, description, policy) values ('codesonar-user-policy', 'GrammaTech CodeSonar EULA', '<div style=\"white-space: pre-wrap;\">\r\n\r\nSOFTWARE END USER LICENCE TERMS\r\n\r\nOpen Source Developers: <a href="https://www.swampinabox.org/doc/eula_codesonar_oss.pdf" target="_blank">https://www.swampinabox.org/doc/eula_codesonar_oss.pdf</a>\r\n\r\nAcademic Users: <a href="https://www.swampinabox.org/doc/eula_codesonar_academic.pdf" target="_blank">https://www.swampinabox.org/doc/eula_codesonar_academic.pdf</a></div>');
        end if;

        # update database version number
        insert into project.database_version (database_version_no, description) values (script_version_no, 'upgrade to v1.29');
        commit;
      end;
    end if;
END
$$
DELIMITER ;
