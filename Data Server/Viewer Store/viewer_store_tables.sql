# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2016 Software Assurance Marketplace

# drop and recreate ENTIRE database, including data
drop database if exists viewer_store;
create database viewer_store;

use viewer_store;

##############################################
CREATE TABLE viewer (
  viewer_uuid             VARCHAR(45) NOT NULL                         COMMENT 'viewer uuid',
  viewer_owner_uuid       VARCHAR(45)                                  COMMENT 'viewer owner uuid',
  name                    VARCHAR(100)  NOT NULL                       COMMENT 'viewer name',
  description             VARCHAR(500)                                 COMMENT 'description',
  viewer_sharing_status   VARCHAR(25) NOT NULL DEFAULT 'PRIVATE'       COMMENT 'private, shared, public or retired',
  create_user             VARCHAR(25)                                  COMMENT 'db user that inserted record',
  create_date             TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
  update_user             VARCHAR(25)                                  COMMENT 'db user that last updated record',
  update_date             TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record last updated',
  PRIMARY KEY (viewer_uuid)
 )COMMENT='contains all viewers';

CREATE TABLE viewer_version (
  viewer_version_uuid    VARCHAR(45) NOT NULL                COMMENT 'version uuid',
  viewer_uuid            VARCHAR(45) NOT NULL                COMMENT 'each version belongs to a viewer; links to viewer',
  version_no             INT                                 COMMENT 'incremental integer version number',
  version_string         VARCHAR(100)                        COMMENT 'eg version 5.0 stable release for Windows 7 64-bit',
  invocation_cmd         VARCHAR(200)                        COMMENT 'command to invoke viewer',
  sign_in_cmd            VARCHAR(200)                        COMMENT 'command to sign in user to viewer',
  add_user_cmd           VARCHAR(200)                        COMMENT 'command to add user to viewer',
  add_result_cmd         VARCHAR(200)                        COMMENT 'command to add results to viewer',
  viewer_path            VARCHAR(200)                        COMMENT 'cannonical path of viewer',
  viewer_checksum        VARCHAR(200)                        COMMENT 'checksum of viewer',
  viewer_db_path         VARCHAR(200)                        COMMENT 'cannonical path of viewer',
  viewer_db_checksum     VARCHAR(200)                        COMMENT 'checksum of viewer',
  create_user            VARCHAR(25)                         COMMENT 'user that inserted record',
  create_date            TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
  update_user            VARCHAR(25)                         COMMENT 'user that last updated record',
  update_date            TIMESTAMP NULL DEFAULT NULL         COMMENT 'date record last changed',
  PRIMARY KEY (viewer_version_uuid),
    CONSTRAINT fk_version_viewer FOREIGN KEY (viewer_uuid) REFERENCES viewer (viewer_uuid) ON DELETE CASCADE ON UPDATE CASCADE
 )COMMENT='viewer can have many versions';

CREATE TABLE viewer_owner_history (
  viewer_owner_history_id  INT  NOT NULL AUTO_INCREMENT                 COMMENT 'internal id',
  viewer_uuid              VARCHAR(45) NOT NULL                         COMMENT 'viewer uuid',
  old_viewer_owner_uuid    VARCHAR(45)                                  COMMENT 'viewer owner uuid',
  new_viewer_owner_uuid    VARCHAR(45)                                  COMMENT 'viewer owner uuid',
  change_date              TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record changed',
  PRIMARY KEY (viewer_owner_history_id)
 )COMMENT='viewer owner history';

CREATE TABLE project_default_viewer (
  project_uuid         VARCHAR(45) NOT NULL                         COMMENT 'project uuid',
  viewer_uuid          VARCHAR(45)                                  COMMENT 'viewer uuid',
  viewer_version_uuid  VARCHAR(45)                                  COMMENT 'version uuid',
  create_user          VARCHAR(25)                                  COMMENT 'db user that inserted record',
  create_date          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
  update_user          VARCHAR(25)                                  COMMENT 'db user that last updated record',
  update_date          TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record last updated',
  PRIMARY KEY (project_uuid)
 )COMMENT='each project can have one default viewer';

CREATE TABLE viewer_instance (
  viewer_instance_uuid  VARCHAR(45)                                  COMMENT 'viewer instance uuid',
  viewer_version_uuid   VARCHAR(45)                                  COMMENT 'viewer uuid',
  project_uuid          VARCHAR(45) NOT NULL                         COMMENT 'project uuid',
  viewer_db_path        VARCHAR(200)                                 COMMENT 'cannonical path of viewer',
  viewer_db_checksum    VARCHAR(200)                                 COMMENT 'checksum of viewer',
  vm_ip_address         VARCHAR(50)                                  COMMENT 'ip address of vm',
  proxy_url             VARCHAR(100)                                 COMMENT 'proxy url',
  status_code           INT                                          COMMENT 'status: 0=good nonzero=error',
  status                VARCHAR(100)                                 COMMENT 'status of viewer',
  create_user           VARCHAR(25)                                  COMMENT 'db user that inserted record',
  create_date           TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
  update_user           VARCHAR(25)                                  COMMENT 'db user that last updated record',
  update_date           TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record last updated',
  PRIMARY KEY (viewer_instance_uuid),
    CONSTRAINT fk_viewer_instance FOREIGN KEY (viewer_version_uuid) REFERENCES viewer_version (viewer_version_uuid) ON DELETE CASCADE ON UPDATE CASCADE
 )COMMENT='storage and ref count for each viewer instance';

CREATE TABLE viewer_sharing (
  viewer_sharing_id  INT  NOT NULL AUTO_INCREMENT                 COMMENT 'internal id',
  viewer_uuid        VARCHAR(45) NOT NULL                         COMMENT 'viewer uuid',
  project_uuid       VARCHAR(45)                                  COMMENT 'project uuid',
  create_user        VARCHAR(25)                                  COMMENT 'db user that inserted record',
  create_date        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
  update_user        VARCHAR(25)                                  COMMENT 'db user that last updated record',
  update_date        TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record last updated',
  PRIMARY KEY (viewer_sharing_id),
     CONSTRAINT fk_viewer_sharing FOREIGN KEY (viewer_uuid) REFERENCES viewer (viewer_uuid) ON DELETE CASCADE ON UPDATE CASCADE,
     CONSTRAINT viewer_sharing_uc UNIQUE (viewer_uuid,project_uuid)
 )COMMENT='contains viewers shared with specific projects';

CREATE TABLE viewer_launch_history (
  viewer_launch_history_id  INT  NOT NULL AUTO_INCREMENT                 COMMENT 'internal id',
  viewer_version_uuid       VARCHAR(45)                                  COMMENT 'viewer_version_uuid',
  project_uuid              VARCHAR(45)                                  COMMENT 'project uuid',
  viewer_instance_uuid      VARCHAR(45)                                  COMMENT 'viewer instance uuid',
  assessment_result_uuid    VARCHAR(45)                                  COMMENT 'assessment result uuid',
  user_uuid                 VARCHAR(45)                                  COMMENT 'user that launched viewer',
  run_date                  DATETIME                                     COMMENT 'launch date',
  create_user               VARCHAR(25)                                  COMMENT 'db user that inserted record',
  create_date               TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
  update_user               VARCHAR(25)                                  COMMENT 'db user that last updated record',
  update_date               TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record last updated',
  PRIMARY KEY (viewer_launch_history_id)
 )COMMENT='viewer_launch_history';

CREATE TABLE viewer_launch_time_history (
  viewer_launch_time_history_id INT  NOT NULL AUTO_INCREMENT                 COMMENT 'internal id',
  viewer_instance_uuid          VARCHAR(45)                                  COMMENT 'viewer instance uuid',
  event                         VARCHAR(25)                                  COMMENT 'event',
  description                   VARCHAR(100)                                 COMMENT 'description',
  create_user                   VARCHAR(25)                                  COMMENT 'db user that inserted record',
  create_date                   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
  update_user                   VARCHAR(25)                                  COMMENT 'db user that last updated record',
  update_date                   TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record last updated',
  PRIMARY KEY (viewer_launch_time_history_id)
 )COMMENT='viewer_launch_time_history';
