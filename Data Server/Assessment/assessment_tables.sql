# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2018 Software Assurance Marketplace

# drop and recreate ENTIRE database, including data
drop database if exists assessment;
create database assessment;

use assessment;

##############################################
CREATE TABLE assessment_run (
  assessment_run_id         INT  NOT NULL AUTO_INCREMENT                 COMMENT 'internal id',
  assessment_run_uuid       VARCHAR(45) NOT NULL                         COMMENT 'assessment run uuid',
  project_uuid              VARCHAR(45) NOT NULL                         COMMENT 'owned by a project',
  platform_uuid             VARCHAR(45)                                  COMMENT 'if null, then default platform',
  tool_uuid                 VARCHAR(45) NOT NULL                         COMMENT 'specifies one tool',
  package_uuid              VARCHAR(45) NOT NULL                         COMMENT 'specifies one package',
  platform_version_id       INT                                          COMMENT 'if null, then most recent',
  tool_version_id           INT                                          COMMENT 'if null, then most recent',
  package_version_id        INT                                          COMMENT 'if null, then most recent',
  platform_version_uuid     VARCHAR(45)                                  COMMENT 'version uuid',
  tool_version_uuid         VARCHAR(45)                                  COMMENT 'version uuid',
  package_version_uuid      VARCHAR(45)                                  COMMENT 'version uuid',
  create_user               VARCHAR(25)                                  COMMENT 'db user that inserted record',
  create_date               TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
  update_user               VARCHAR(25)                                  COMMENT 'db user that last updated record',
  update_date               TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record last updated',
  PRIMARY KEY (assessment_run_id),
    CONSTRAINT assessment_run_uuid_uc  UNIQUE (assessment_run_uuid),
    CONSTRAINT fk_assessment_run_proj FOREIGN KEY (project_uuid) REFERENCES project.project (project_uid) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_assessment_run_pkg FOREIGN KEY (package_uuid) REFERENCES package_store.package (package_uuid) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_assessment_run_pkg_ver FOREIGN KEY (package_version_uuid) REFERENCES package_store.package_version (package_version_uuid) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_assessment_run_proj_uuid (project_uuid)
 )COMMENT='assessment run definition';

########################
CREATE TABLE run_request (
  run_request_id         INT  NOT NULL AUTO_INCREMENT                 COMMENT 'internal id',
  run_request_uuid       VARCHAR(45) NOT NULL                         COMMENT 'run request uuid',
  project_uuid           VARCHAR(45) NOT NULL                         COMMENT 'owned by a project',
  end_on_date            TIMESTAMP NULL DEFAULT NULL                  COMMENT 'recurance end date, YYYY-MM-DD',
  name                   VARCHAR(25)                                  COMMENT 'name of schedule, monthly',
  description            VARCHAR(100)                                 COMMENT 'desc of schedule, eg Wed & Fri @ 3pm',
  create_user            VARCHAR(25)                                  COMMENT 'db user that inserted record',
  create_date            TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
  update_user            VARCHAR(25)                                  COMMENT 'db user that last updated record',
  update_date            TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record last updated',
  PRIMARY KEY (run_request_id),
    CONSTRAINT run_request_uuid_uc  UNIQUE (run_request_uuid),
    INDEX idx_run_request_proj_uuid (project_uuid)
 )COMMENT='run request owns one or more schedules';

#################################
CREATE TABLE run_request_schedule (
  run_request_schedule_id         INT  NOT NULL  AUTO_INCREMENT                COMMENT 'internal id',
  run_request_schedule_uuid       VARCHAR(45) NOT NULL                         COMMENT 'run request schedule uuid',
  run_request_uuid                VARCHAR(45) NOT NULL                         COMMENT 'owned by a run request',
  recurrence_type                 VARCHAR(12) NOT NULL                         COMMENT 'once, daily, weekly, monthly',
  recurrence_day                  INT                                          COMMENT 'day of week 1-7, day of month 1-31',
  time_of_day                     TIME NOT NULL DEFAULT '00:00:00'             COMMENT 'time of day to run, HH:MM',
  create_user                     VARCHAR(25)                                  COMMENT 'db user that inserted record',
  create_date                     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
  update_user                     VARCHAR(25)                                  COMMENT 'db user that last updated record',
  update_date                     TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record last updated',
  PRIMARY KEY (run_request_schedule_id),
    CONSTRAINT fk_schedule_run_request FOREIGN KEY (run_request_uuid) REFERENCES run_request (run_request_uuid) ON DELETE CASCADE ON UPDATE CASCADE
 )COMMENT='run request can have many schedules';

#########################################
CREATE TABLE assessment_run_request (
  assessment_run_request_id       INT  NOT NULL  AUTO_INCREMENT                COMMENT 'internal id',
  assessment_run_id               INT  NOT NULL                                COMMENT 'assessment run id',
  run_request_id                  INT  NOT NULL                                COMMENT 'run request id',
  user_uuid                       VARCHAR(45)                                  COMMENT 'user that requested run',
  notify_when_complete_flag       tinyint(1) NOT NULL DEFAULT 0                COMMENT 'Notify user when run finishes: 0=false 1=true',
  create_user                     VARCHAR(25)                                  COMMENT 'db user that inserted record',
  create_date                     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
  update_user                     VARCHAR(25)                                  COMMENT 'db user that last updated record',
  update_date                     TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record last updated',
  delete_date                     TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record deleted',
  PRIMARY KEY (assessment_run_request_id),
    CONSTRAINT fk_assessment_run_request_aru FOREIGN KEY (assessment_run_id) REFERENCES assessment_run (assessment_run_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_assessment_run_request_rru FOREIGN KEY (run_request_id) REFERENCES run_request (run_request_id) ON DELETE CASCADE ON UPDATE CASCADE
 )COMMENT='association between assessment runs and run requests';

#############################
CREATE TABLE execution_record (
  execution_record_id          INT  NOT NULL  AUTO_INCREMENT                    COMMENT 'internal id',
  execution_record_uuid        VARCHAR(45)  NOT NULL                            COMMENT 'execution record uuid',
  assessment_run_uuid          VARCHAR(45)  NOT NULL                            COMMENT 'assessment run uuid',
  run_request_uuid             VARCHAR(45)  NOT NULL                            COMMENT 'run request uuid',
  user_uuid                    VARCHAR(45)                                      COMMENT 'user that requested run',
  launch_flag                  tinyint(1)   NOT NULL DEFAULT 1                  COMMENT 'Launch Run: 0=false 1=true',
  launch_counter               INT(1)       UNSIGNED NOT NULL DEFAULT 0         COMMENT 'Count of launches',
  launch_countdown             INT(1)       UNSIGNED NOT NULL DEFAULT 0         COMMENT 'Countdown to next launch',
  submitted_to_condor_flag     tinyint(1)   NOT NULL DEFAULT 0                  COMMENT 'Submitted to Condor: 0=false 1=true',
  complete_flag                tinyint(1)   NOT NULL DEFAULT 0                  COMMENT 'Is run complete: 0=false 1=true',
  notify_when_complete_flag    tinyint(1)   NOT NULL DEFAULT 0                  COMMENT 'Notify user when run finishes: 0=false 1=true',
  project_uuid                 VARCHAR(45)  NOT NULL                            COMMENT 'projects owns',
  platform_version_uuid        VARCHAR(45)  NOT NULL                            COMMENT 'version uuid',
  tool_version_uuid            VARCHAR(45)  NOT NULL                            COMMENT 'version uuid',
  package_version_uuid         VARCHAR(45)  NOT NULL                            COMMENT 'version uuid',
  status                       VARCHAR(100) NOT NULL DEFAULT 'WAITING TO START' COMMENT 'status of execution record',
  run_date                     TIMESTAMP    NULL DEFAULT NULL                   COMMENT 'run begin timestamp',
  completion_date              TIMESTAMP    NULL DEFAULT NULL                   COMMENT 'run completion timestamp',
  queued_duration              VARCHAR(12)                                      COMMENT 'string run date minus create date',
  execution_duration           VARCHAR(12)                                      COMMENT 'string completion date minus run date',
  execute_node_architecture_id VARCHAR(128)                                     COMMENT 'execute note id',
  slot_size_start              VARCHAR(128)                                     COMMENT 'space used in slots dir',
  slot_size_end                VARCHAR(128)                                     COMMENT 'space used in slots dir',
  total_lines                  INT                                              COMMENT 'total LOC',
  code_lines                   INT                                              COMMENT 'LOC minus blanks and comments',
  cpu_utilization              VARCHAR(32)                                      COMMENT 'cpu utilization',
  vm_hostname                  VARCHAR(100)                                     COMMENT 'vm ssh hostname',
  vm_username                  VARCHAR(50)                                      COMMENT 'vm ssh username',
  vm_password                  VARCHAR(50)                                      COMMENT 'vm ssh password',
  vm_ip_address                VARCHAR(50)                                      COMMENT 'vm ip address',
  vm_image                     VARCHAR(100)                                     COMMENT 'vm image',
  tool_filename                VARCHAR(100)                                     COMMENT 'tool filename',
  create_user                  VARCHAR(25)                                      COMMENT 'db user that inserted record',
  create_date                  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP  COMMENT 'date record inserted',
  update_user                  VARCHAR(25)                                      COMMENT 'db user that last updated record',
  update_date                  TIMESTAMP    NULL DEFAULT NULL                   COMMENT 'date record last updated',
  delete_date                  TIMESTAMP    NULL DEFAULT NULL                   COMMENT 'date record deleted',
  PRIMARY KEY (execution_record_id),
    CONSTRAINT execution_record_uuid_uc  UNIQUE (execution_record_uuid),
    INDEX idx_execution_record_proj_uuid (project_uuid),
    INDEX idx_execution_record_user_uuid (user_uuid),
    INDEX idx_execution_record_ar_uuid (assessment_run_uuid),
    INDEX idx_execution_record_complete (complete_flag)
 )COMMENT='execution records';

##############################
CREATE TABLE assessment_result (
  assessment_result_uuid       VARCHAR(45)  NOT NULL                        COMMENT 'assessment result uuid',
  execution_record_uuid        VARCHAR(45)                                  COMMENT 'null if imported result',
  project_uuid                 VARCHAR(45)  NOT NULL                        COMMENT 'projects owns',
  weakness_cnt                 INT                                          COMMENT 'count reported by framework',
  file_host                    VARCHAR(200) NOT NULL                        COMMENT 'host of file',
  file_path                    VARCHAR(200) NOT NULL                        COMMENT 'cannonical path of result file',
  checksum                     VARCHAR(200)                                 COMMENT 'result file checksum',
  source_archive_path          VARCHAR(200)                                 COMMENT 'cannonical path of source file',
  source_archive_checksum      VARCHAR(200)                                 COMMENT 'source file checksum',
  log_path                     VARCHAR(200)                                 COMMENT 'cannonical path of log file',
  log_checksum                 VARCHAR(200)                                 COMMENT 'log file checksum',
  status_out                   TEXT                                         COMMENT 'contents of status.out file',
  status_out_error_msg         VARCHAR(200)                                 COMMENT 'first failed step from status.out',
  platform_name                VARCHAR(100)                                 COMMENT 'platform name',
  platform_version             VARCHAR(100)                                 COMMENT 'platform version',
  tool_name                    VARCHAR(100)                                 COMMENT 'tool name',
  tool_version                 VARCHAR(100)                                 COMMENT 'tool version',
  package_name                 VARCHAR(100)                                 COMMENT 'package name',
  package_version              VARCHAR(100)                                 COMMENT 'package version',
  platform_version_uuid        VARCHAR(45)                                  COMMENT 'version uuid',
  tool_version_uuid            VARCHAR(45)                                  COMMENT 'version uuid',
  package_version_uuid         VARCHAR(45)                                  COMMENT 'version uuid',
  tool_uuid                    VARCHAR(45)                                  COMMENT 'tool uuid',
  run_date                     TIMESTAMP    NULL DEFAULT NULL               COMMENT 'run begin timestamp',
  execute_node_architecture_id VARCHAR(128)                                 COMMENT 'execute note id',
  vm_hostname                  VARCHAR(100)                                 COMMENT 'vm ssh hostname',
  vm_ip_address                VARCHAR(50)                                  COMMENT 'vm ip address',
  create_user                  VARCHAR(25)                                  COMMENT 'db user that inserted record',
  create_date                  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
  update_user                  VARCHAR(25)                                  COMMENT 'db user that last updated record',
  update_date                  TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record last updated',
  delete_date                  TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record deleted',
  PRIMARY KEY (assessment_result_uuid),
    CONSTRAINT fk_assessment_result_exec FOREIGN KEY (execution_record_uuid) REFERENCES execution_record (execution_record_uuid) ON DELETE SET NULL ON UPDATE CASCADE,
    INDEX idx_assessment_result_proj_uuid (project_uuid)
 )COMMENT='execution records';

##############################
CREATE TABLE assessment_result_viewer_history (
  assessment_result_viewer_history_id  INT  NOT NULL  AUTO_INCREMENT                COMMENT 'internal id',
  assessment_result_uuid               VARCHAR(45) NOT NULL                         COMMENT 'assessment result uuid',
  viewer_instance_uuid                 VARCHAR(45) NOT NULL                         COMMENT 'viewer instance uuid',
  viewer_version_uuid                  VARCHAR(45)                                  COMMENT 'viewer version uuid',
  create_user                          VARCHAR(25)                                  COMMENT 'db user that inserted record',
  create_date                          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
  update_user                          VARCHAR(25)                                  COMMENT 'db user that last updated record',
  update_date                          TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record last updated',
  PRIMARY KEY (assessment_result_viewer_history_id)
 )COMMENT='assessment result viewer history';

CREATE TABLE sys_exec_cmd_log (
  sys_exec_cmd_log_id          INT  NOT NULL  AUTO_INCREMENT       COMMENT 'internal id',
  cmd                          VARCHAR(5000),
  caller                       VARCHAR(100),
  create_user                  VARCHAR(25)                                  COMMENT 'db user that inserted record',
  create_date                  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
  update_user                  VARCHAR(25)                                  COMMENT 'db user that last updated record',
  update_date                  TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record last updated',
  PRIMARY KEY (sys_exec_cmd_log_id)
 )COMMENT='sys exec command log';

CREATE TABLE system_setting (
  system_setting_id      INT  NOT NULL  AUTO_INCREMENT                COMMENT 'internal id',
  system_setting_code    VARCHAR(50)                                  COMMENT 'setting code name',
  system_setting_value   VARCHAR(200)                                 COMMENT 'setting value',
  system_setting_value2  VARCHAR(200)                                 COMMENT 'setting value2',
  create_user            VARCHAR(50)                                  COMMENT 'db user that inserted record',
  create_date            TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
  update_user            VARCHAR(50)                                  COMMENT 'db user that last updated record',
  update_date            TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record last updated',
  PRIMARY KEY (system_setting_id)
 )COMMENT='system config values';

CREATE TABLE database_version (
  database_version_id   INT  NOT NULL  AUTO_INCREMENT                COMMENT 'internal id',
  database_version_no   INT                                          COMMENT 'version number',
  description           VARCHAR(200)                                 COMMENT 'description',
  create_user           VARCHAR(50)                                  COMMENT 'db user that inserted record',
  create_date           TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
  update_user           VARCHAR(50)                                  COMMENT 'db user that last updated record',
  update_date           TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record last updated',
  PRIMARY KEY (database_version_id)
 )COMMENT='database version';

CREATE TABLE group_list (
  group_uuid       VARCHAR(45)  NOT NULL                        COMMENT 'group uuid',
  name             VARCHAR(45)                                  COMMENT 'display name of group',
  group_type       VARCHAR(45)                                  COMMENT 'group type',
  uuid_list        VARCHAR(5000)                                COMMENT 'group elements',
  create_user      VARCHAR(25)                                  COMMENT 'db user that inserted record',
  create_date      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
  update_user      VARCHAR(25)                                  COMMENT 'db user that last updated record',
  update_date      TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record last updated',
  PRIMARY KEY (group_uuid)
 )COMMENT='group records';

CREATE TABLE notification (
  notification_uuid       VARCHAR(45)  NOT NULL                        COMMENT 'group uuid',
  user_uuid               VARCHAR(45)                                  COMMENT 'recipient',
  notification_impetus    VARCHAR(100)                                 COMMENT 'eg Assessment result available',
  relevant_uuid           VARCHAR(45)                                  COMMENT 'eg assessment_result uuid of a-run',
  transmission_medium     VARCHAR(45)                                  COMMENT 'eg email, SMS',
  sent_date               TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date msg sent',
  create_user             VARCHAR(25)                                  COMMENT 'db user that inserted record',
  create_date             TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
  update_user             VARCHAR(25)                                  COMMENT 'db user that last updated record',
  update_date             TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record last updated',
  PRIMARY KEY (notification_uuid)
 )COMMENT='notifications';

CREATE TABLE system_status (
  status_key   VARCHAR(100) NOT NULL                        COMMENT 'key value',
  value        VARCHAR(500)                                 COMMENT 'status value',
  update_date  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record last updated',
  PRIMARY KEY (status_key)
 )COMMENT='system status records';

CREATE TABLE ssh_request (
  ssh_request_id         INT  NOT NULL  AUTO_INCREMENT                COMMENT 'internal id',
  user_uuid              VARCHAR(45)                                  COMMENT 'user',
  execution_record_uuid  VARCHAR(45)                                  COMMENT 'execution record uuid',
  source_ip              VARCHAR(50)                                  COMMENT 'db user that inserted record',
  destination_ip         VARCHAR(50)                                  COMMENT 'db user that inserted record',
  destination_hostname   VARCHAR(100)                                 COMMENT 'db user that inserted record',
  create_user            VARCHAR(50)                                  COMMENT 'db user that inserted record',
  create_date            TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
  update_user            VARCHAR(50)                                  COMMENT 'db user that last updated record',
  update_date            TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record last updated',
  PRIMARY KEY (ssh_request_id)
 )COMMENT='ssh request log';

CREATE TABLE execution_run_status_log (
  execution_run_status_log_id  INT  NOT NULL AUTO_INCREMENT COMMENT 'internal id',
  execution_record_uuid        VARCHAR(45),
  status                       VARCHAR(25),
  run_start_time               DATETIME,
  run_end_time                 DATETIME,
  exec_node_architecture_id    VARCHAR(128),
  lines_of_code                INT,
  cpu_utilization              VARCHAR(32),
  vm_hostname                  VARCHAR(100),
  vm_username                  VARCHAR(50),
  vm_password                  VARCHAR(50),
  vm_ip_address                VARCHAR(50),
  create_date                  TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
  PRIMARY KEY (execution_run_status_log_id),
    CONSTRAINT fk_execution_run_status_log FOREIGN KEY (execution_record_uuid) REFERENCES execution_record (execution_record_uuid) ON DELETE SET NULL ON UPDATE CASCADE
 );

CREATE TABLE scheduler_log (
  scheduler_log_id           INT  NOT NULL AUTO_INCREMENT COMMENT 'internal id',
  msg                        VARCHAR(100),
  assessment_run_uuid        VARCHAR(45),
  run_request_uuid           VARCHAR(45),
  notify_when_complete_flag  tinyint(1),
  user_uuid                  VARCHAR(45),
  return_msg                 VARCHAR(100),
  create_date                TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
  PRIMARY KEY (scheduler_log_id)
  );

CREATE TABLE scheduler_logging (
  id INT  NOT NULL AUTO_INCREMENT,
  msg VARCHAR(25),
  create_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
  );

CREATE TABLE usage_stats (
  usage_stats_id  INT NOT NULL AUTO_INCREMENT,
  enabled_users   INT COMMENT 'enabled_flag = 1, excludes test users',
  package_uploads INT COMMENT 'excludes curated pkgs and test users',
  assessments     INT COMMENT 'excludes runs by test users',
  loc             INT COMMENT 'excludes runs by test users',
  create_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (usage_stats_id)
  );


###################
## Events
##  Events in assessment_tables.sql will only be created on install, but untouched during upgrades.
##  Events in assessment_procs.sql will created on installs, as well as dropped and recreated during upgrades.
drop EVENT if exists scheduler;
CREATE EVENT scheduler
  ON SCHEDULE EVERY 30 SECOND
  DO CALL assessment.scheduler();

