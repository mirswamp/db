# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2016 Software Assurance Marketplace

# v1.27
use assessment;
drop PROCEDURE if exists upgrade_49;
DELIMITER $$
CREATE PROCEDURE upgrade_49 ()
  BEGIN
    declare script_version_no int;
    declare cur_db_version_no int;
    set script_version_no = 49;

    select max(database_version_no)
      into cur_db_version_no
      from assessment.database_version;

    if cur_db_version_no < script_version_no then
      begin

        # New Viewer Threadfix
          # Only compatible with clang tool
        delete from tool_shed.tool_viewer_incompatibility where viewer_uuid = 'a0e1d0fb-bfb2-11e5-bf72-001a4a814413';
        delete from viewer_store.viewer_version where viewer_uuid = 'a0e1d0fb-bfb2-11e5-bf72-001a4a814413';
        delete from viewer_store.viewer where viewer_uuid = 'a0e1d0fb-bfb2-11e5-bf72-001a4a814413';
        insert into viewer_store.viewer (viewer_uuid, viewer_owner_uuid, name, viewer_sharing_status)
          values ('a0e1d0fb-bfb2-11e5-bf72-001a4a814413', '80835e30-d527-11e2-8b8b-0800200c9a66', 'Threadfix', 'PUBLIC');
        insert into viewer_store.viewer_version (viewer_version_uuid, viewer_uuid, version_string)
                    values ('b0e931d7-bfb2-11e5-bf72-001a4a814413', 'a0e1d0fb-bfb2-11e5-bf72-001a4a814413', '1');
        # List as incompatible with all installed tools except clang
        insert into tool_shed.tool_viewer_incompatibility (tool_uuid, viewer_uuid)
          select tool_uuid, 'a0e1d0fb-bfb2-11e5-bf72-001a4a814413' from tool_shed.tool where tool_uuid != 'f212557c-3050-11e3-9a3e-001a4a81450b';

        # Create Metric DB
        drop database if exists metric;
        create database metric;

        CREATE TABLE metric.metric_tool (
          metric_tool_uuid       VARCHAR(45) NOT NULL                         COMMENT 'tool uuid',
          metric_tool_owner_uuid VARCHAR(45)                                  COMMENT 'tool owner uuid',
          name                   VARCHAR(100) NOT NULL                        COMMENT 'tool name',
          description            VARCHAR(500)                                 COMMENT 'description',
          tool_sharing_status    VARCHAR(25) NOT NULL DEFAULT 'PRIVATE'       COMMENT 'private, shared, public or retired',
          is_build_needed        TINYINT                                      COMMENT 'Does tool analyze build output instead of source',
          create_user            VARCHAR(25)                                  COMMENT 'db user that inserted record',
          create_date            TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
          update_user            VARCHAR(25)                                  COMMENT 'db user that last updated record',
          update_date            TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record last updated',
          PRIMARY KEY (metric_tool_uuid)
         )COMMENT='contains all tools';

        CREATE TABLE metric.metric_tool_version (
          metric_tool_version_uuid VARCHAR(45) NOT NULL                COMMENT 'version uuid',
          metric_tool_uuid         VARCHAR(45) NOT NULL                COMMENT 'each version belongs to a tool; links to tool',
          version_no               INT                                 COMMENT 'incremental integer version number',
          version_string           VARCHAR(100)                        COMMENT 'eg version 5.0 stable release for Windows 7 64-bit',
          tool_path                VARCHAR(200)                        COMMENT 'cannonical path of tool in swamp storage',
          checksum                 VARCHAR(200)                        COMMENT 'checksum of tool',
          create_user              VARCHAR(25)                         COMMENT 'user that inserted record',
          create_date              TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
          update_user              VARCHAR(25)                         COMMENT 'user that last updated record',
          update_date              TIMESTAMP NULL DEFAULT NULL         COMMENT 'date record last changed',
          PRIMARY KEY (metric_tool_version_uuid),
            CONSTRAINT fk_version_tool FOREIGN KEY (metric_tool_uuid) REFERENCES metric_tool (metric_tool_uuid) ON DELETE CASCADE ON UPDATE CASCADE
         )COMMENT='Tool can have many versions';

        CREATE TABLE metric.metric_tool_language (
          metric_tool_language_id INT  NOT NULL AUTO_INCREMENT                 COMMENT 'internal id',
          metric_tool_uuid        VARCHAR(45)                                  COMMENT 'tool uuid',
          package_type_id         INT                                          COMMENT 'references package_store.package_type',
          create_user             VARCHAR(50)                                  COMMENT 'db user that inserted record',
          create_date             TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
          update_user             VARCHAR(50)                                  COMMENT 'db user that last updated record',
          update_date             TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record last updated',
          PRIMARY KEY (metric_tool_language_id)
         )COMMENT='Lists languages that each tool is capable of assessing';

        CREATE TABLE metric.metric_run (
          metric_run_uuid              VARCHAR(45) NOT NULL                         COMMENT 'metric run uuid',
          package_uuid                 VARCHAR(45) NOT NULL                         COMMENT 'package uuid',
          package_version_uuid         VARCHAR(45)                                  COMMENT 'package version uuid',
          tool_uuid                    VARCHAR(45) NOT NULL                         COMMENT 'tool uuid',
          tool_version_uuid            VARCHAR(45)                                  COMMENT 'tool version uuid',
          platform_uuid                VARCHAR(45) NOT NULL                         COMMENT 'platform uuid',
          platform_version_uuid        VARCHAR(45)                                  COMMENT 'platform version uuid',
          package_owner_uuid           VARCHAR(45) NOT NULL                         COMMENT 'package owner uuid',
          status                       VARCHAR(25) NOT NULL DEFAULT 'SCHEDULED'     COMMENT 'status of execution record',
          run_date                     TIMESTAMP NULL DEFAULT NULL                  COMMENT 'run begin timestamp',
          completion_date              TIMESTAMP NULL DEFAULT NULL                  COMMENT 'run completion timestamp',
          queued_duration              VARCHAR(12)                                  COMMENT 'string run date minus create date',
          execution_duration           VARCHAR(12)                                  COMMENT 'string completion date minus run date',
          execute_node_architecture_id VARCHAR(128)                                 COMMENT 'execute note id',
          lines_of_code                INT                                          COMMENT 'loc analyzed',
          cpu_utilization              VARCHAR(32)                                  COMMENT 'cpu utilization',
          vm_hostname                  VARCHAR(100)                                 COMMENT 'vm ssh hostname',
          vm_username                  VARCHAR(50)                                  COMMENT 'vm ssh username',
          vm_password                  VARCHAR(50)                                  COMMENT 'vm ssh password',
          vm_ip_address                VARCHAR(50)                                  COMMENT 'vm ip address',
          file_host                    VARCHAR(200) NOT NULL                        COMMENT 'host of file',
          result_path                  VARCHAR(200) NOT NULL                        COMMENT 'cannonical path of result file',
          result_checksum              VARCHAR(200)                                 COMMENT 'result file checksum',
          log_path                     VARCHAR(200)                                 COMMENT 'cannonical path of log file',
          log_checksum                 VARCHAR(200)                                 COMMENT 'log file checksum',
          create_user                  VARCHAR(25)                                  COMMENT 'db user that inserted record',
          create_date                  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
          update_user                  VARCHAR(25)                                  COMMENT 'db user that last updated record',
          update_date                  TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record last updated',
          PRIMARY KEY (metric_run_uuid),
            INDEX idx_metric_run_package_version (package_version_uuid)
         )COMMENT='metric run';


        # Add system_setting_value2 to system_setting table
        # drop column if exist
        if exists (select * from information_schema.columns
                    where table_schema = 'assessment'
                      and table_name = 'system_setting'
                      and column_name = 'system_setting_value2') then
            alter table assessment.system_setting drop column system_setting_value2;
        end if;
        alter TABLE assessment.system_setting add column system_setting_value2 VARCHAR(200) COMMENT 'setting value2' AFTER system_setting_value;

        # Alter system_setting.system_setting_code
        if exists (select * from information_schema.columns
                    where table_schema = 'assessment'
                      and table_name = 'system_setting'
                      and column_name = 'system_setting_code') then
            alter table assessment.system_setting change system_setting_code system_setting_code VARCHAR(50) COMMENT 'setting code name';
        end if;

        # Populate Metric DB
        #delete from assessment.system_setting where system_setting_code = 'METRIC_RUN_PLATFORM_UUID';
        delete from assessment.system_setting where system_setting_code = 'DEFAULT_PLATFORM_FOR_PKG_TYPE';
        insert into assessment.system_setting (system_setting_code, system_setting_value, system_setting_value2) values ('DEFAULT_PLATFORM_FOR_PKG_TYPE', '1',  'fc55810b-09d7-11e3-a239-001a4a81450b'); # C/C++           - Red Hat Enterprise Linux 64-bit
        insert into assessment.system_setting (system_setting_code, system_setting_value, system_setting_value2) values ('DEFAULT_PLATFORM_FOR_PKG_TYPE', '2',  'fc55810b-09d7-11e3-a239-001a4a81450b'); # Java 7 Src Code - Red Hat Enterprise Linux 64-bit
        insert into assessment.system_setting (system_setting_code, system_setting_value, system_setting_value2) values ('DEFAULT_PLATFORM_FOR_PKG_TYPE', '3',  'fc55810b-09d7-11e3-a239-001a4a81450b'); # Java 7 Bytecode - Red Hat Enterprise Linux 64-bit
        insert into assessment.system_setting (system_setting_code, system_setting_value, system_setting_value2) values ('DEFAULT_PLATFORM_FOR_PKG_TYPE', '4',  'd95fcb5f-209d-11e3-9a3e-001a4a81450b'); # Python2         - Scientific Linux 64-bit
        insert into assessment.system_setting (system_setting_code, system_setting_value, system_setting_value2) values ('DEFAULT_PLATFORM_FOR_PKG_TYPE', '5',  'd95fcb5f-209d-11e3-9a3e-001a4a81450b'); # Python3         - Scientific Linux 64-bit
        insert into assessment.system_setting (system_setting_code, system_setting_value, system_setting_value2) values ('DEFAULT_PLATFORM_FOR_PKG_TYPE', '6',  '48f9a9b0-976f-11e4-829b-001a4a81450b'); # Android JavaSrc - Android
        insert into assessment.system_setting (system_setting_code, system_setting_value, system_setting_value2) values ('DEFAULT_PLATFORM_FOR_PKG_TYPE', '7',  'd95fcb5f-209d-11e3-9a3e-001a4a81450b'); # Ruby            - Scientific Linux 64-bit
        insert into assessment.system_setting (system_setting_code, system_setting_value, system_setting_value2) values ('DEFAULT_PLATFORM_FOR_PKG_TYPE', '8',  'd95fcb5f-209d-11e3-9a3e-001a4a81450b'); # Ruby Sinatra    - Scientific Linux 64-bit
        insert into assessment.system_setting (system_setting_code, system_setting_value, system_setting_value2) values ('DEFAULT_PLATFORM_FOR_PKG_TYPE', '9',  'd95fcb5f-209d-11e3-9a3e-001a4a81450b'); # Ruby on Rails   - Scientific Linux 64-bit
        insert into assessment.system_setting (system_setting_code, system_setting_value, system_setting_value2) values ('DEFAULT_PLATFORM_FOR_PKG_TYPE', '10', 'd95fcb5f-209d-11e3-9a3e-001a4a81450b'); # Ruby Padrino    - Scientific Linux 64-bit
        insert into assessment.system_setting (system_setting_code, system_setting_value, system_setting_value2) values ('DEFAULT_PLATFORM_FOR_PKG_TYPE', '11', '48f9a9b0-976f-11e4-829b-001a4a81450b'); # Android .apk    - Android
        insert into assessment.system_setting (system_setting_code, system_setting_value, system_setting_value2) values ('DEFAULT_PLATFORM_FOR_PKG_TYPE', '12', 'fc55810b-09d7-11e3-a239-001a4a81450b'); # Java 8 Src Code - Red Hat Enterprise Linux 64-bit
        insert into assessment.system_setting (system_setting_code, system_setting_value, system_setting_value2) values ('DEFAULT_PLATFORM_FOR_PKG_TYPE', '13', 'fc55810b-09d7-11e3-a239-001a4a81450b'); # Java 8 Bytecode - Red Hat Enterprise Linux 64-bit

        # Cloc - new metric tool. version 1.64: 1 version. Language = All, except "Android .apk" "Java 7 Bytecode" and "Java 8 Bytecode"
          # tool_uuid: 0726f1df-3e40-11e6-a6cc-001a4a81450b
          # tool_version_uuid: 129d61a0-3e40-11e6-a6cc-001a4a81450b
        # delete if exists
        delete from metric.metric_tool_language where metric_tool_uuid = '0726f1df-3e40-11e6-a6cc-001a4a81450b';
        delete from metric.metric_tool_version where metric_tool_uuid = '0726f1df-3e40-11e6-a6cc-001a4a81450b';
        delete from metric.metric_tool where metric_tool_uuid = '0726f1df-3e40-11e6-a6cc-001a4a81450b';

        insert into metric.metric_tool (
            metric_tool_uuid,
            metric_tool_owner_uuid,
            name,
            description,
            tool_sharing_status,
            is_build_needed)
          values (
            '0726f1df-3e40-11e6-a6cc-001a4a81450b',
            '80835e30-d527-11e2-8b8b-0800200c9a66',
            'cloc',
            'cloc counts blank lines, comment lines, and physical lines of source code in many programming languages. https://github.com/AlDanial/cloc',
            'PUBLIC',
            1);

        insert into metric.metric_tool_version
          (metric_tool_version_uuid, metric_tool_uuid, version_no, version_string, tool_path, checksum)
        values
        ('129d61a0-3e40-11e6-a6cc-001a4a81450b','0726f1df-3e40-11e6-a6cc-001a4a81450b', 1, '1.64', '/swamp/store/SCATools/cloc/cloc-1.64-3.tar',
        '30006a1eb5899ab9957010c3acf4c76715a6e4e8445ad8b6296a7e637d2e2f8d0359c39e21dd68c70d811610786b068f7204dbec59a5eb19c2be6c7f6fb65126');

        insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('0726f1df-3e40-11e6-a6cc-001a4a81450b', 1);  # C/C++
        insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('0726f1df-3e40-11e6-a6cc-001a4a81450b', 2);  # Java 7 Source Code
        #insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('0726f1df-3e40-11e6-a6cc-001a4a81450b', 3);  # Java 7 Bytecode
        insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('0726f1df-3e40-11e6-a6cc-001a4a81450b', 4);  # Python2
        insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('0726f1df-3e40-11e6-a6cc-001a4a81450b', 5);  # Python3
        insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('0726f1df-3e40-11e6-a6cc-001a4a81450b', 6);  # Android Java Source Code
        insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('0726f1df-3e40-11e6-a6cc-001a4a81450b', 7);  # Ruby
        insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('0726f1df-3e40-11e6-a6cc-001a4a81450b', 8);  # Ruby Sinatra
        insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('0726f1df-3e40-11e6-a6cc-001a4a81450b', 9);  # Ruby on Rails
        insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('0726f1df-3e40-11e6-a6cc-001a4a81450b', 10); # Ruby Padrino
        #insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('0726f1df-3e40-11e6-a6cc-001a4a81450b', 11); # Android .apk
        insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('0726f1df-3e40-11e6-a6cc-001a4a81450b', 12); # Java 8 Source Code
        #insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('0726f1df-3e40-11e6-a6cc-001a4a81450b', 13); # Java 8 Bytecode


        # Lizard - new metric tool. version 1.10.4: 1 version. Language = All, except "Android .apk" "Java 7 Bytecode" and "Java 8 Bytecode"
          # tool_uuid: 9692f64b-3e43-11e6-a6cc-001a4a81450b
          # tool_version_uuid: a6e4d49b-3e43-11e6-a6cc-001a4a81450b
        # delete if exists
        delete from metric.metric_tool_language where metric_tool_uuid = '9692f64b-3e43-11e6-a6cc-001a4a81450b';
        delete from metric.metric_tool_version where metric_tool_uuid = '9692f64b-3e43-11e6-a6cc-001a4a81450b';
        delete from metric.metric_tool where metric_tool_uuid = '9692f64b-3e43-11e6-a6cc-001a4a81450b';

        insert into metric.metric_tool (
            metric_tool_uuid,
            metric_tool_owner_uuid,
            name,
            description,
            tool_sharing_status,
            is_build_needed)
          values (
            '9692f64b-3e43-11e6-a6cc-001a4a81450b',
            '80835e30-d527-11e2-8b8b-0800200c9a66',
            'Lizard',
            'A code analyzer. https://pypi.python.org/pypi/lizard',
            'PUBLIC',
            1);

        insert into metric.metric_tool_version
          (metric_tool_version_uuid, metric_tool_uuid, version_no, version_string, tool_path, checksum)
        values
        ('a6e4d49b-3e43-11e6-a6cc-001a4a81450b','9692f64b-3e43-11e6-a6cc-001a4a81450b', 1, '1.10.4', '/swamp/store/SCATools/lizard/lizard-1.10.4-3.tar',
        '29c8691399e5fd56e8a460b32966f2d2264263da3cad0fe3e5b2dfcfe84061f70433c543183ce943f69c2c794011adb9739835c44ccba5cbcd23946f8b92a3c0');

        insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('9692f64b-3e43-11e6-a6cc-001a4a81450b', 1);  # C/C++
        insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('9692f64b-3e43-11e6-a6cc-001a4a81450b', 2);  # Java 7 Source Code
        #insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('9692f64b-3e43-11e6-a6cc-001a4a81450b', 3);  # Java 7 Bytecode
        insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('9692f64b-3e43-11e6-a6cc-001a4a81450b', 4);  # Python2
        insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('9692f64b-3e43-11e6-a6cc-001a4a81450b', 5);  # Python3
        insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('9692f64b-3e43-11e6-a6cc-001a4a81450b', 6);  # Android Java Source Code
        insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('9692f64b-3e43-11e6-a6cc-001a4a81450b', 7);  # Ruby
        insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('9692f64b-3e43-11e6-a6cc-001a4a81450b', 8);  # Ruby Sinatra
        insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('9692f64b-3e43-11e6-a6cc-001a4a81450b', 9);  # Ruby on Rails
        insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('9692f64b-3e43-11e6-a6cc-001a4a81450b', 10); # Ruby Padrino
        #insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('9692f64b-3e43-11e6-a6cc-001a4a81450b', 11); # Android .apk
        insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('9692f64b-3e43-11e6-a6cc-001a4a81450b', 12); # Java 8 Source Code
        #insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('9692f64b-3e43-11e6-a6cc-001a4a81450b', 13); # Java 8 Bytecode


        # update database version number
        delete from assessment.database_version where database_version_no = script_version_no;
        insert into assessment.database_version (database_version_no, description) values (script_version_no, 'upgrade to v1.27');

        commit;
      end;
    end if;
END
$$
DELIMITER ;
