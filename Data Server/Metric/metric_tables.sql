# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2018 Software Assurance Marketplace

# drop and recreate ENTIRE database, including data
drop database if exists metric;
create database metric;

use metric;

CREATE TABLE metric_tool (
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

CREATE TABLE metric_tool_version (
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

CREATE TABLE metric_tool_language (
  metric_tool_language_id INT  NOT NULL AUTO_INCREMENT                 COMMENT 'internal id',
  metric_tool_uuid        VARCHAR(45)                                  COMMENT 'tool uuid',
  package_type_id         INT                                          COMMENT 'references package_store.package_type',
  create_user             VARCHAR(50)                                  COMMENT 'db user that inserted record',
  create_date             TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
  update_user             VARCHAR(50)                                  COMMENT 'db user that last updated record',
  update_date             TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record last updated',
  PRIMARY KEY (metric_tool_language_id)
 )COMMENT='Lists languages that each tool is capable of assessing';

CREATE TABLE metric_run (
  metric_run_uuid              VARCHAR(45)  NOT NULL                            COMMENT 'metric run uuid',
  package_uuid                 VARCHAR(45)  NOT NULL                            COMMENT 'package uuid',
  package_version_uuid         VARCHAR(45)                                      COMMENT 'package version uuid',
  tool_uuid                    VARCHAR(45)  NOT NULL                            COMMENT 'tool uuid',
  tool_version_uuid            VARCHAR(45)                                      COMMENT 'tool version uuid',
  platform_uuid                VARCHAR(45)  NOT NULL                            COMMENT 'platform uuid',
  platform_version_uuid        VARCHAR(45)                                      COMMENT 'platform version uuid',
  package_owner_uuid           VARCHAR(45)  NOT NULL                            COMMENT 'package owner uuid',
  launch_flag                  tinyint(1)   NOT NULL DEFAULT 1                  COMMENT 'Launch Run: 0=false 1=true',
  launch_counter               INT(1)       UNSIGNED NOT NULL DEFAULT 0         COMMENT 'Count of launches',
  launch_countdown             INT(1)       UNSIGNED NOT NULL DEFAULT 0         COMMENT 'Countdown to next launch',
  submitted_to_condor_flag     tinyint(1)   NOT NULL DEFAULT 0                  COMMENT 'Submitted to Condor: 0=false 1=true',
  complete_flag                tinyint(1)   NOT NULL DEFAULT 0                  COMMENT 'Is run complete: 0=false 1=true',
  status                       VARCHAR(100) NOT NULL DEFAULT 'WAITING TO START' COMMENT 'status of execution record',
  run_date                     TIMESTAMP    NULL DEFAULT NULL                   COMMENT 'run begin timestamp',
  completion_date              TIMESTAMP    NULL DEFAULT NULL                   COMMENT 'run completion timestamp',
  queued_duration              VARCHAR(12)                                      COMMENT 'string run date minus create date',
  execution_duration           VARCHAR(12)                                      COMMENT 'string completion date minus run date',
  execute_node_architecture_id VARCHAR(128)                                     COMMENT 'execute note id',
  total_lines                  INT                                              COMMENT 'total LOC',
  code_lines                   INT                                              COMMENT 'LOC minus blanks and comments',
  pkg_code_lines               INT                                              COMMENT 'Metric CLOC Output',
  pkg_comment_lines            INT                                              COMMENT 'Metric CLOC Output',
  pkg_blank_lines              INT                                              COMMENT 'Metric CLOC Output',
  pkg_total_lines              INT                                              COMMENT 'Metric CLOC Output',
  cpu_utilization              VARCHAR(32)                                      COMMENT 'cpu utilization',
  vm_hostname                  VARCHAR(100)                                     COMMENT 'vm ssh hostname',
  vm_username                  VARCHAR(50)                                      COMMENT 'vm ssh username',
  vm_password                  VARCHAR(50)                                      COMMENT 'vm ssh password',
  vm_ip_address                VARCHAR(50)                                      COMMENT 'vm ip address',
  vm_image                     VARCHAR(100)                                     COMMENT 'vm image',
  tool_filename                VARCHAR(100)                                     COMMENT 'tool filename',
  file_host                    VARCHAR(200) NOT NULL                            COMMENT 'host of file',
  result_path                  VARCHAR(200) NOT NULL                            COMMENT 'cannonical path of result file',
  result_checksum              VARCHAR(200)                                     COMMENT 'result file checksum',
  log_path                     VARCHAR(200)                                     COMMENT 'cannonical path of log file',
  log_checksum                 VARCHAR(200)                                     COMMENT 'log file checksum',
  status_out                   TEXT                                             COMMENT 'contents of status.out file',
  create_user                  VARCHAR(25)                                      COMMENT 'db user that inserted record',
  create_date                  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP  COMMENT 'date record inserted',
  update_user                  VARCHAR(25)                                      COMMENT 'db user that last updated record',
  update_date                  TIMESTAMP    NULL DEFAULT NULL                   COMMENT 'date record last updated',
  PRIMARY KEY (metric_run_uuid),
    INDEX idx_metric_run_package_version (package_version_uuid),
    INDEX idx_metric_run_complete (complete_flag)
 )COMMENT='metric run';

###################
## Events
SET GLOBAL event_scheduler = ON;

drop EVENT if exists initiate_metric_runs;
CREATE EVENT initiate_metric_runs
  ON SCHEDULE EVERY 1 MINUTE
  DO CALL metric.initiate_metric_runs();
