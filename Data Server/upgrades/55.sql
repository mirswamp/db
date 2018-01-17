# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2018 Software Assurance Marketplace

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
