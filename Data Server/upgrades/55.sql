# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2020 Software Assurance Marketplace

# v1.31
use assessment;
drop PROCEDURE if exists upgrade_55;
DELIMITER $$
CREATE PROCEDURE upgrade_55 ()
  BEGIN
    declare script_version_no int;
    declare cur_db_version_no int;
    declare system_type varchar(200);
    set script_version_no = 55;

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

        # Add column to table
        if exists (select * from information_schema.columns
                    where table_schema = 'project'
                      and table_name = 'permission'
                      and column_name = 'user_info') then
            alter table project.permission drop column user_info;
        end if;
        alter TABLE project.permission add column user_info VARCHAR (5000) COMMENT 'what user info is gathered' AFTER policy_code;

        # Add column to table
        if exists (select * from information_schema.columns
                    where table_schema = 'project'
                      and table_name = 'permission'
                      and column_name = 'user_info_policy_text') then
            alter table project.permission drop column user_info_policy_text;
        end if;
        alter TABLE project.permission add column user_info_policy_text VARCHAR (5000) COMMENT 'what will be done with user info' AFTER user_info;

        # populate user_info_policy_text
        update project.permission
           set user_info = '{\n \"name\": {\n           \"type\": \"text\",\n           \"placeholder\": \"First Last\",\n              \"help\": \"Your full name for tool usage.\",\n         \"required\": true\n    },\n\n  \"email\": {\n          \"type\": \"text\",\n           \"placeholder\": \"name@domain\",\n             \"help\": \"The email address that you would like to use with this tool.\",\n           \"required\": true\n    },\n\n  \"organization\": {\n           \"type\": \"text\",\n           \"placeholder\": \"Your organization here\",\n          \"help\": \"This is the name of the organization, university, or company that you are affiliated with.\",\n             \"required\": true\n    },\n\n  \"project url\": {\n            \"type\": \"text\",\n           \"placeholder\": \"http://\",\n         \"help\": \"A URL to a web page about the project that you wish to use this tool for.\",\n              \"required\": false\n   },\n\n  \"user type\": {\n              \"type\":       \"enum\",\n             \"values\": [\"open source\", \"educational\", \"government\", \"commercial\"],\n        \"help\": \"The category of user that you belong to.\"\n        }\n}',
               user_info_policy_text = 'I understand that if I am a Commercial user, Government user or I cannot be sufficiently vetted as an Education User or Open Source Developer, my name and contact information will be shared with Grammatech for approval purposes only.',
               description = 'Permission to access and use the CodeSonar static analysis tool for C/C++ from GrammaTech.'
         where permission_code = 'codesonar-user';

        # Add column to table
        if exists (select * from information_schema.columns
                    where table_schema = 'project'
                      and table_name = 'permission'
                      and column_name = 'auto_approve_flag') then
            alter table project.permission drop column auto_approve_flag;
        end if;
        alter TABLE project.permission add column auto_approve_flag tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Is automatically approved: 0=false 1=true' AFTER admin_only_flag;

        # Remove Project Ownership permission
        delete from project.permission where permission_code = 'project-owner';
        delete from project.user_policy where policy_code = 'project-owner-policy';
        delete from project.user_permission where permission_code = 'project-owner';

        if (system_type = 'MIR_SWAMP') then
          # insert coverity permission
          delete from project.permission where permission_code = 'coverity-user';
          insert into project.permission (permission_code, title, description, admin_only_flag, auto_approve_flag,
                                          user_info,
                                          user_info_policy_text,
                                          policy_code)
                                  values ('coverity-user', 'Synopsys Static Analysis (Coverity) User', 'Permission to access and use the Synopsys Static Analysis (Coverity) static analysis tool for C/C++ from Synopsis.', 0, 0,
                                          '{\n \"name\": {\n           \"type\": \"text\",\n           \"placeholder\": \"First Last\",\n              \"help\": \"Your full name for tool usage.\",\n         \"required\": true\n    },\n\n  \"email\": {\n          \"type\": \"text\",\n           \"placeholder\": \"name@domain\",\n             \"help\": \"The email address that you would like to use with this tool.\",\n           \"required\": true\n    },\n\n  \"organization\": {\n           \"type\": \"text\",\n           \"placeholder\": \"Your organization here\",\n          \"help\": \"This is the name of the organization, university, or company that you are affiliated with.\",\n             \"required\": true\n    },\n\n  \"project url\": {\n            \"type\": \"text\",\n           \"placeholder\": \"http://\",\n         \"help\": \"A URL to a web page about the project that you wish to use this tool for.\",\n              \"required\": false\n   },\n\n  \"user type\": {\n              \"type\":       \"enum\",\n             \"values\": [\"open source\", \"educational\", \"government\", \"commercial\"],\n        \"help\": \"The category of user that you belong to.\"\n        }\n}',
                                          'I understand that if I am an Open Source Developer, Commercial user, Government user or I cannot be sufficiently vetted as an Education User, my name and contact information will be shared with Synopsys for approval purposes only.',
                                          'coverity-user-policy');
          # insert coverity policy
          delete from project.policy where policy_code = 'coverity-user-policy';
          insert into project.policy (policy_code, description, policy) values ('coverity-user-policy', 'Synopsys Static Analysis (Coverity) EULA', '<div style=\"white-space: pre-wrap;\">\r\n\r\nSOFTWARE END USER LICENCE TERMS\r\n\r\n<a href="https://www.swampinabox.org/doc/eula_coverity.pdf" target="_blank">https://www.swampinabox.org/doc/eula_coverity.pdf</a></div>');
          # update Parasoft user_info
          update project.permission
            set user_info = '{\r\n  \"name\": {\r\n            \"type\": \"text\",\r\n            \"placeholder\": \"First Last\",\r\n               \"help\": \"Your full name for tool usage.\",\r\n          \"required\": true\r\n     },\r\n \r\n   \"email\": {\r\n           \"type\": \"text\",\r\n            \"placeholder\": \"name@domain\",\r\n              \"help\": \"The email address that you would like to use with this tool.\",\r\n            \"required\": true\r\n     },\r\n \r\n   \"organization\": {\r\n            \"type\": \"text\",\r\n            \"placeholder\": \"Your organization here\",\r\n           \"help\": \"This is the name of the organization, university, or company that you are affiliated with.\",\r\n              \"required\": true\r\n     },\r\n \r\n   \"project url\": {\r\n             \"type\": \"text\",\r\n            \"placeholder\": \"http://\",\r\n          \"help\": \"A URL to a web page about the project that you wish to use this tool for.\",\r\n               \"required\": false\r\n    },\r\n \r\n   \"user type\": {\r\n               \"type\":       \"enum\",\r\n              \"values\": [\"open source\", \"educational\", \"government\", \"commercial\"],\r\n         \"help\": \"The category of user that you belong to.\"\r\n         }\r\n }' ,
                user_info_policy_text = 'I understand that if I am a Commercial user, Government user or I cannot be sufficiently vetted as an Education User or Open Source Developer, my name and contact information will be shared with Parasoft for approval purposes only.'
          where permission_code in ('parasoft-user-c-test','parasoft-user-j-test');
        end if;

        # New password_reset table
        DROP TABLE IF EXISTS project.password_reset;
        CREATE TABLE project.password_reset (
          password_reset_uuid    VARCHAR(45)                         COMMENT 'internal id',
          user_uid               VARCHAR(45)                         COMMENT 'user uuid',
          password_reset_key     VARCHAR(100)                        COMMENT 'reset key',
          create_date            TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
          PRIMARY KEY (password_reset_uuid)
         ) COMMENT='Password Reset keys';

        # removing unused system_status values
        delete from assessment.system_status where status_key not in ('CURRENTLY_PROCESSING_EXECUTION_RECORDS', 'CURRENTLY_RUNNING_SCHEDULER');

        # remove unused execution_event table
        drop table if exists assessment.execution_event;

        # Add column to table
        if exists (select * from information_schema.columns
                    where table_schema = 'assessment'
                      and table_name = 'assessment_result'
                      and column_name = 'delete_date') then
            alter table assessment.assessment_result drop column delete_date;
        end if;
        alter TABLE assessment.assessment_result add column delete_date TIMESTAMP NULL DEFAULT NULL COMMENT 'date record deleted' AFTER update_date;

        # Add column to table
        if exists (select * from information_schema.columns
                    where table_schema = 'assessment'
                      and table_name = 'assessment_result'
                      and column_name = 'status_out') then
            alter table assessment.assessment_result drop column status_out;
        end if;
        alter TABLE assessment.assessment_result add column status_out TEXT COMMENT 'contents of status.out file' AFTER log_checksum;

        # Add column to table
        if exists (select * from information_schema.columns
                    where table_schema = 'metric'
                      and table_name = 'metric_run'
                      and column_name = 'status_out') then
            alter table metric.metric_run drop column status_out;
        end if;
        alter TABLE metric.metric_run add column status_out TEXT COMMENT 'contents of status.out file' AFTER log_checksum;

        # Add column to table
        if exists (select * from information_schema.columns
                    where table_schema = 'assessment'
                      and table_name = 'execution_record'
                      and column_name = 'launch_flag') then
            alter table assessment.execution_record drop column launch_flag;
        end if;
        alter TABLE assessment.execution_record add column launch_flag tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Launch Run: 0=false 1=true' AFTER user_uuid;

        # Add column to table
        if exists (select * from information_schema.columns
                    where table_schema = 'assessment'
                      and table_name = 'execution_record'
                      and column_name = 'launch_counter') then
            alter table assessment.execution_record drop column launch_counter;
        end if;
        alter TABLE assessment.execution_record add column launch_counter tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Launch counter' AFTER launch_flag;

        # Add column to table
        if exists (select * from information_schema.columns
                    where table_schema = 'assessment'
                      and table_name = 'execution_record'
                      and column_name = 'complete_flag') then
            alter table assessment.execution_record drop column complete_flag;
        end if;
        alter TABLE assessment.execution_record add column complete_flag tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Is run complete: 0=false 1=true' AFTER launch_counter;

        # populate new fields
        update assessment.execution_record
           set launch_flag = 0,
               complete_flag = 1;

        # Increase Package Version Field Sizes
        ALTER TABLE package_store.package_version
          CHANGE COLUMN source_path source_path VARCHAR(1000) NULL DEFAULT NULL COMMENT 'location of source in package' ,
          CHANGE COLUMN build_file  build_file  VARCHAR(1000) NULL DEFAULT NULL ,
          CHANGE COLUMN build_cmd   build_cmd   VARCHAR(4000) NULL DEFAULT NULL COMMENT 'populated only is build_system is other' ,
          CHANGE COLUMN build_dir   build_dir   VARCHAR(1000) NULL DEFAULT '.'  COMMENT 'path with the package where the build step should occur' ,
          CHANGE COLUMN build_opt   build_opt   VARCHAR(4000) NULL DEFAULT NULL COMMENT 'specifies additional options to pass to the build tool that may be package specific' ,
          CHANGE COLUMN config_cmd  config_cmd  VARCHAR(4000) NULL DEFAULT NULL ,
          CHANGE COLUMN config_opt  config_opt  VARCHAR(4000) NULL DEFAULT NULL COMMENT 'options to provide to the config_cmd' ,
          CHANGE COLUMN config_dir  config_dir  VARCHAR(1000) NULL DEFAULT '.'  COMMENT 'path where the configure step should occur within the package tree' ;

        # rename column
        if exists (select * from information_schema.columns
                    where table_schema = 'assessment'
                      and table_name = 'execution_record'
                      and column_name = 'lines_of_code') then
          ALTER TABLE assessment.execution_record CHANGE COLUMN lines_of_code total_lines INT COMMENT 'total LOC';
        end if;
        # Add column to table
        if exists (select * from information_schema.columns
                    where table_schema = 'assessment'
                      and table_name = 'execution_record'
                      and column_name = 'code_lines') then
            alter table assessment.execution_record drop column code_lines;
        end if;
        alter TABLE assessment.execution_record add column code_lines INT COMMENT 'LOC minus blanks and comments' after total_lines;

        # rename column
        if exists (select * from information_schema.columns
                    where table_schema = 'metric'
                      and table_name = 'metric_run'
                      and column_name = 'lines_of_code') then
          ALTER TABLE metric.metric_run CHANGE COLUMN lines_of_code total_lines INT COMMENT 'total LOC';
        end if;
        # Add column to table
        if exists (select * from information_schema.columns
                    where table_schema = 'metric'
                      and table_name = 'metric_run'
                      and column_name = 'code_lines') then
            alter table metric.metric_run drop column code_lines;
        end if;
        alter TABLE metric.metric_run add column code_lines INT COMMENT 'LOC minus blanks and comments' after total_lines;

        # update database version number
        delete from assessment.database_version where database_version_no = script_version_no;
        insert into assessment.database_version (database_version_no, description) values (script_version_no, 'upgrade to v1.31');

        commit;
      end;
    end if;
END
$$
DELIMITER ;
