# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2018 Software Assurance Marketplace

# v1.33.3
use assessment;
drop PROCEDURE if exists upgrade_58;
DELIMITER $$
CREATE PROCEDURE upgrade_58 ()
  BEGIN
    declare script_version_no int;
    declare cur_db_version_no int;
    declare system_type varchar(200);
    set script_version_no = 58;

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

        # Add fields to assessment.assessment_result
          #   run_date                     TIMESTAMP    NULL DEFAULT NULL               COMMENT 'run begin timestamp',
          #   execute_node_architecture_id VARCHAR(128)                                 COMMENT 'execute note id',
          #   vm_hostname                  VARCHAR(100)                                 COMMENT 'vm ssh hostname',
          #   vm_ip_address                VARCHAR(50)                                  COMMENT 'vm ip address',
        if exists (select * from information_schema.columns
                    where table_schema = 'assessment'
                      and table_name = 'assessment_result'
                      and column_name = 'run_date') then
            alter table assessment.assessment_result drop column run_date;
        end if;
        alter TABLE assessment.assessment_result add column run_date TIMESTAMP NULL DEFAULT NULL COMMENT 'run begin timestamp' AFTER tool_uuid;
        if exists (select * from information_schema.columns
                    where table_schema = 'assessment'
                      and table_name = 'assessment_result'
                      and column_name = 'execute_node_architecture_id') then
            alter table assessment.assessment_result drop column execute_node_architecture_id;
        end if;
        alter TABLE assessment.assessment_result add column execute_node_architecture_id VARCHAR(128) COMMENT 'execute note id' AFTER run_date;
        if exists (select * from information_schema.columns
                    where table_schema = 'assessment'
                      and table_name = 'assessment_result'
                      and column_name = 'vm_hostname') then
            alter table assessment.assessment_result drop column vm_hostname;
        end if;
        alter TABLE assessment.assessment_result add column vm_hostname VARCHAR(100) COMMENT 'vm ssh hostname' AFTER execute_node_architecture_id;
        if exists (select * from information_schema.columns
                    where table_schema = 'assessment'
                      and table_name = 'assessment_result'
                      and column_name = 'vm_ip_address') then
            alter table assessment.assessment_result drop column vm_ip_address;
        end if;
        alter TABLE assessment.assessment_result add column vm_ip_address VARCHAR(50) COMMENT 'vm ip address' AFTER vm_hostname;

        # Add status_out_error_msg to assessment.assessment_result
        if exists (select * from information_schema.columns
                    where table_schema = 'assessment'
                      and table_name = 'assessment_result'
                      and column_name = 'status_out_error_msg') then
            alter table assessment.assessment_result drop column status_out_error_msg;
        end if;
        alter TABLE assessment.assessment_result add column status_out_error_msg VARCHAR(200) COMMENT 'first failed step from status.out' AFTER status_out;

        # Add status_out_error_msg to metric.metric_run
        if exists (select * from information_schema.columns
                    where table_schema = 'metric'
                      and table_name = 'metric_run'
                      and column_name = 'status_out_error_msg') then
            alter table metric.metric_run drop column status_out_error_msg;
        end if;
        alter TABLE metric.metric_run add column status_out_error_msg VARCHAR(200) COMMENT 'first failed step from status.out' AFTER status_out;

        # update database version number
        delete from assessment.database_version where database_version_no = script_version_no;
        insert into assessment.database_version (database_version_no, description) values (script_version_no, 'upgrade to v1.33.3');

        commit;
      end;
    end if;
END
$$
DELIMITER ;
