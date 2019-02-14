# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2019 Software Assurance Marketplace

# v1.34
use assessment;
drop PROCEDURE if exists upgrade_60;
DELIMITER $$
CREATE PROCEDURE upgrade_60 ()
  BEGIN
    declare script_version_no int;
    declare cur_db_version_no int;
    declare system_type varchar(200);
    set script_version_no = 60;

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

        # Add secret_token to package table
        if exists (select * from information_schema.columns
                    where table_schema = 'package_store'
                      and table_name = 'package'
                      and column_name = 'secret_token') then
            alter table package_store.package drop column secret_token;
        end if;
        alter TABLE package_store.package add column secret_token VARCHAR(1024) COMMENT 'secret token to validate GitHub push requests' AFTER external_url;

        # Allow null project_uuid on run_request table
        alter table assessment.run_request change column project_uuid project_uuid VARCHAR(45) NULL COMMENT 'owned by a project, if null then public';

        # Add hidden_flag to run_request table
        if exists (select * from information_schema.columns
                    where table_schema = 'assessment'
                      and table_name = 'run_request'
                      and column_name = 'hidden_flag') then
            alter table assessment.run_request drop column hidden_flag;
        end if;
        alter TABLE assessment.run_request add column hidden_flag tinyint(1) NOT NULL DEFAULT 0 COMMENT 'hide from UI: 0=false 1=true' AFTER project_uuid;

        # Update One-time Run Request
        update assessment.run_request set project_uuid = null, hidden_flag = 1 where run_request_uuid = '6bef7825-1b2d-11e3-af14-001a4a81450b';

        # New Run Request
        if exists (select * from assessment.run_request where run_request_uuid = 'f18550dd-fdca-11e3-8775-001a4a81450b')
          then
            update assessment.run_request
               set project_uuid = null,
                   name = 'On push',
                   description = 'Run when creation of a new package version is triggered by a GitHub Webhook'
             where run_request_uuid = 'f18550dd-fdca-11e3-8775-001a4a81450b';
        else
          insert into assessment.run_request (run_request_uuid, project_uuid, name, description)
          values ('f18550dd-fdca-11e3-8775-001a4a81450b', null, 'On push', 'Run when creation of a new package version is triggered by a GitHub Webhook');
        end if;

        # Add platform_image to viewer_instance table
        if exists (select * from information_schema.columns
                    where table_schema = 'viewer_store'
                      and table_name = 'viewer_instance'
                      and column_name = 'platform_image') then
            alter table viewer_store.viewer_instance drop column platform_image;
        end if;
        alter TABLE viewer_store.viewer_instance add column platform_image VARCHAR(100) COMMENT 'vm image' AFTER status;

        # Add platform_image to viewer_instance table
        if exists (select * from information_schema.columns
                    where table_schema = 'viewer_store'
                      and table_name = 'viewer_instance'
                      and column_name = 'code_dx_version') then
            alter table viewer_store.viewer_instance drop column code_dx_version;
        end if;
        alter TABLE viewer_store.viewer_instance add column code_dx_version VARCHAR(100) COMMENT 'version of code dx' AFTER platform_image;

        # New table to store package downloads
        drop table if exists package_store.package_download_log;
        CREATE TABLE package_store.package_download_log (
          package_download_log_id INT  NOT NULL  AUTO_INCREMENT                COMMENT 'internal id',
          package_uuid            VARCHAR(45) NOT NULL                         COMMENT 'package uuid',
          package_version_uuid    VARCHAR(45) NOT NULL                         COMMENT 'version uuid',
          user_uuid               VARCHAR(45) NOT NULL                         COMMENT 'user download',
          name                    VARCHAR(100) NOT NULL                        COMMENT 'package name',
          version_string          VARCHAR(100) NOT NULL                        COMMENT 'eg version 5.0 stable release for Windows 7 64-bit',
          create_user             VARCHAR(25)                                  COMMENT 'db user that inserted record',
          create_date             TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
          update_user             VARCHAR(25)                                  COMMENT 'db user that last updated record',
          update_date             TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record last updated',
          PRIMARY KEY (package_download_log_id)
         )COMMENT='contains all packages';

        # New Package Type
          # metric.metric_tool_language records are created by populate_tool_metadata.sql
        delete from package_store.package_type where package_type_id = 15;
        insert into package_store.package_type (package_type_id, name, package_type_enabled, platform_user_selectable, default_platform_uuid)
          values (15, '.NET', 1, 0, '1088c3ce-20aa-11e3-9a3e-001a4a81450b'); # .NET            - Ubuntu Linux

        # Add package_build_settings to package_version table
        if exists (select * from information_schema.columns
                    where table_schema = 'package_store'
                      and table_name = 'package_version'
                      and column_name = 'package_build_settings') then
            alter table package_store.package_version drop column package_build_settings;
        end if;
        alter TABLE package_store.package_version add column package_build_settings TEXT NULL DEFAULT NULL COMMENT '.Net info' AFTER exclude_paths;

        # Add package_info to package_version table
        if exists (select * from information_schema.columns
                    where table_schema = 'package_store'
                      and table_name = 'package_version'
                      and column_name = 'package_info') then
            alter table package_store.package_version drop column package_info;
        end if;
        alter TABLE package_store.package_version add column package_info TEXT NULL DEFAULT NULL COMMENT '.Net info' AFTER package_build_settings;

        # Revoke schema level permissions
        REVOKE DELETE ON project.* FROM 'web'@'%';
        REVOKE DELETE ON assessment.* FROM 'web'@'%';
        REVOKE DELETE ON package_store.* FROM 'web'@'%';
        REVOKE DELETE ON platform_store.* FROM 'web'@'%';
        REVOKE DELETE ON tool_shed.* FROM 'web'@'%';
        REVOKE DELETE ON viewer_store.* FROM 'web'@'%';

        # update database version number
        delete from assessment.database_version where database_version_no = script_version_no;
        insert into assessment.database_version (database_version_no, description) values (script_version_no, 'upgrade to v1.34');

        commit;
      end;
    end if;
END
$$
DELIMITER ;
