# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2019 Software Assurance Marketplace

# v1.33
use assessment;
drop PROCEDURE if exists upgrade_57;
DELIMITER $$
CREATE PROCEDURE upgrade_57 ()
  BEGIN
    declare script_version_no int;
    declare cur_db_version_no int;
    declare system_type varchar(200);
    set script_version_no = 57;

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

        # Add the following fields:
            # launch_flag                  tinyint(1)   NOT NULL DEFAULT 1                  COMMENT 'Launch Run: 0=false 1=true',
            # launch_counter               INT(1)       UNSIGNED NOT NULL DEFAULT 0         COMMENT 'Count of launches',
            # launch_countdown             INT(1)       UNSIGNED NOT NULL DEFAULT 0         COMMENT 'Countdown to next launch',
            # submitted_to_condor_flag     tinyint(1)   NOT NULL DEFAULT 0                  COMMENT 'Submitted to Condor: 0=false 1=true',
            # complete_flag                tinyint(1)   NOT NULL DEFAULT 0                  COMMENT 'Is run complete: 0=false 1=true',
          # To the following tables:
            # assessment.execution_record
            # metric.metric_run
          # Some of them were added in 1.31, but never utilized. If they already exist they will be dropped and re-added for a clean start
        if exists (select * from information_schema.columns
                    where table_schema = 'assessment'
                      and table_name = 'execution_record'
                      and column_name = 'launch_flag') then
            alter table assessment.execution_record drop column launch_flag;
        end if;
        alter TABLE assessment.execution_record add column launch_flag tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Launch Run: 0=false 1=true' AFTER user_uuid;
        if exists (select * from information_schema.columns
                    where table_schema = 'assessment'
                      and table_name = 'execution_record'
                      and column_name = 'launch_counter') then
            alter table assessment.execution_record drop column launch_counter;
        end if;
        alter TABLE assessment.execution_record add column launch_counter INT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Count of launches' AFTER launch_flag;
        if exists (select * from information_schema.columns
                    where table_schema = 'assessment'
                      and table_name = 'execution_record'
                      and column_name = 'launch_countdown') then
            alter table assessment.execution_record drop column launch_countdown;
        end if;
        alter TABLE assessment.execution_record add column launch_countdown INT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Countdown to next launch' AFTER launch_counter;
        if exists (select * from information_schema.columns
                    where table_schema = 'assessment'
                      and table_name = 'execution_record'
                      and column_name = 'submitted_to_condor_flag') then
            alter table assessment.execution_record drop column submitted_to_condor_flag;
        end if;
        alter TABLE assessment.execution_record add column submitted_to_condor_flag tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Submitted to Condor: 0=false 1=true' AFTER launch_countdown;
        if exists (select * from information_schema.columns
                    where table_schema = 'assessment'
                      and table_name = 'execution_record'
                      and column_name = 'complete_flag') then
            alter table assessment.execution_record drop column complete_flag;
        end if;
        alter TABLE assessment.execution_record add column complete_flag tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Is run complete: 0=false 1=true' AFTER submitted_to_condor_flag;
        if exists (select * from information_schema.columns
                    where table_schema = 'metric'
                      and table_name = 'metric_run'
                      and column_name = 'launch_flag') then
            alter table metric.metric_run drop column launch_flag;
        end if;
        alter TABLE metric.metric_run add column launch_flag tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Launch Run: 0=false 1=true' AFTER package_owner_uuid;
        if exists (select * from information_schema.columns
                    where table_schema = 'metric'
                      and table_name = 'metric_run'
                      and column_name = 'launch_counter') then
            alter table metric.metric_run drop column launch_counter;
        end if;
        alter TABLE metric.metric_run add column launch_counter INT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Count of launches' AFTER launch_flag;
        if exists (select * from information_schema.columns
                    where table_schema = 'metric'
                      and table_name = 'metric_run'
                      and column_name = 'launch_countdown') then
            alter table metric.metric_run drop column launch_countdown;
        end if;
        alter TABLE metric.metric_run add column launch_countdown INT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Countdown to next launch' AFTER launch_counter;
        if exists (select * from information_schema.columns
                    where table_schema = 'metric'
                      and table_name = 'metric_run'
                      and column_name = 'submitted_to_condor_flag') then
            alter table metric.metric_run drop column submitted_to_condor_flag;
        end if;
        alter TABLE metric.metric_run add column submitted_to_condor_flag tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Submitted to Condor: 0=false 1=true' AFTER launch_countdown;
        if exists (select * from information_schema.columns
                    where table_schema = 'metric'
                      and table_name = 'metric_run'
                      and column_name = 'complete_flag') then
            alter table metric.metric_run drop column complete_flag;
        end if;
        alter TABLE metric.metric_run add column complete_flag tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Is run complete: 0=false 1=true' AFTER submitted_to_condor_flag;

        # create index
        if exists (select * from information_schema.statistics
                    where table_schema = 'assessment'
                      and table_name = 'execution_record'
                      and index_name = 'idx_execution_record_complete') then
          alter table assessment.execution_record drop index idx_execution_record_complete ;
        end if;
        alter table assessment.execution_record add index idx_execution_record_complete (complete_flag asc);

        # create index
        if exists (select * from information_schema.statistics
                    where table_schema = 'metric'
                      and table_name = 'metric_run'
                      and index_name = 'idx_metric_run_complete') then
          alter table metric.metric_run drop index idx_metric_run_complete ;
        end if;
        alter table metric.metric_run add index idx_metric_run_complete (complete_flag asc);

        # populate new fields
        update assessment.execution_record set launch_flag = 0, complete_flag = 1;
        update metric.metric_run           set launch_flag = 0, complete_flag = 1;

        # Add user_add_on_flag to tool_version table
        if exists (select * from information_schema.columns
                    where table_schema = 'tool_shed'
                      and table_name = 'tool_version'
                      and column_name = 'user_add_on_flag') then
            alter table tool_shed.tool_version drop column user_add_on_flag;
        end if;
        alter TABLE tool_shed.tool_version add column user_add_on_flag tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Was tool added by user: 0=false 1=true' AFTER tool_uuid;

        # Add exclude_paths to package_version table
        if exists (select * from information_schema.columns
                    where table_schema = 'package_store'
                      and table_name = 'package_version'
                      and column_name = 'exclude_paths') then
            alter table package_store.package_version drop column exclude_paths;
        end if;
        alter TABLE package_store.package_version add column exclude_paths VARCHAR(2000) NULL DEFAULT NULL COMMENT 'exclude paths' AFTER checkout_argument;


        # Mark user add-on tools
        if (system_type = 'SWAMP_IN_A_BOX') then
          update tool_shed.tool_version
             set user_add_on_flag = 1
           where tool_uuid in (
            '5540d2be-72b2-11e5-865f-001a4a81450b', # Code Sonar
            'e7a00759-82a4-11e7-9baa-001a4a81450b', # Coverity
            '4bb2644d-6440-11e4-a282-001a4a81450b', # Parasoft C/C++test
            '6197a593-6440-11e4-a282-001a4a81450b'  # Parasoft Jtest
            );
          update tool_shed.tool_version
             set user_add_on_flag = 1
           where tool_uuid = 'd032d8ec-9184-11e6-88bc-001a4a81450b'
             and tool_version_uuid not in (
                  'e3466345-9184-11e6-88bc-001a4a81450b', # OWASP Dependency Check 1.4.3
                  '37565211-e27f-11e6-bf70-001a4a81450b'  # OWASP Dependency Check 1.4.4
                  );
        end if;

        # New Table: usage_stats
        drop table if exists assessment.usage_stats;
        CREATE TABLE assessment.usage_stats (
          usage_stats_id  INT NOT NULL AUTO_INCREMENT,
          enabled_users   INT COMMENT 'enabled_flag = 1, excludes test users',
          package_uploads INT COMMENT 'excludes curated pkgs and test users',
          assessments     INT COMMENT 'excludes runs by test users',
          loc             INT COMMENT 'excludes runs by test users',
          create_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
          PRIMARY KEY (usage_stats_id)
          );

        # Add LOC fields to metric_run
        if exists (select * from information_schema.columns
                    where table_schema = 'metric'
                      and table_name = 'metric_run'
                      and column_name = 'pkg_code_lines') then
            alter table metric.metric_run drop column pkg_code_lines;
        end if;
        alter TABLE metric.metric_run add column pkg_code_lines INT COMMENT 'Metric CLOC Output' AFTER code_lines;

        if exists (select * from information_schema.columns
                    where table_schema = 'metric'
                      and table_name = 'metric_run'
                      and column_name = 'pkg_comment_lines') then
            alter table metric.metric_run drop column pkg_comment_lines;
        end if;
        alter TABLE metric.metric_run add column pkg_comment_lines INT COMMENT 'Metric CLOC Output' AFTER pkg_code_lines;

        if exists (select * from information_schema.columns
                    where table_schema = 'metric'
                      and table_name = 'metric_run'
                      and column_name = 'pkg_blank_lines') then
            alter table metric.metric_run drop column pkg_blank_lines;
        end if;
        alter TABLE metric.metric_run add column pkg_blank_lines INT COMMENT 'Metric CLOC Output' AFTER pkg_comment_lines;

        if exists (select * from information_schema.columns
                    where table_schema = 'metric'
                      and table_name = 'metric_run'
                      and column_name = 'pkg_total_lines') then
            alter table metric.metric_run drop column pkg_total_lines;
        end if;
        alter TABLE metric.metric_run add column pkg_total_lines INT COMMENT 'Metric CLOC Output' AFTER pkg_blank_lines;

        # update database version number
        delete from assessment.database_version where database_version_no = script_version_no;
        insert into assessment.database_version (database_version_no, description) values (script_version_no, 'upgrade to v1.33');

        commit;
      end;
    end if;
END
$$
DELIMITER ;
