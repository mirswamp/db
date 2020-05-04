# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2020 Software Assurance Marketplace

drop database if exists tool_shed;
create database tool_shed;

use tool_shed;

CREATE TABLE tool (
  tool_uuid            VARCHAR(45) NOT NULL                         COMMENT 'tool uuid',
  tool_owner_uuid      VARCHAR(45)                                  COMMENT 'tool owner uuid',
  name                 VARCHAR(100) NOT NULL                        COMMENT 'tool name',
  description          VARCHAR(500)                                 COMMENT 'description',
  tool_sharing_status  VARCHAR(25) NOT NULL DEFAULT 'PRIVATE'       COMMENT 'private, shared, public or retired',
  is_build_needed      TINYINT                                      COMMENT 'Does tool analyze build output instead of source',
  policy_code          VARCHAR(100)                                 COMMENT 'if tool requires policy',
  exclude_when_user_selects_all tinyint(1) NOT NULL DEFAULT 0       COMMENT 'Exclude when user selects all tools: 0=false 1=true',
  create_user          VARCHAR(25)                                  COMMENT 'db user that inserted record',
  create_date          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
  update_user          VARCHAR(25)                                  COMMENT 'db user that last updated record',
  update_date          TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record last updated',
  PRIMARY KEY (tool_uuid)
 )COMMENT='contains all tools';

CREATE TABLE tool_version (
  tool_version_uuid      VARCHAR(45) NOT NULL                COMMENT 'version uuid',
  tool_uuid              VARCHAR(45) NOT NULL                COMMENT 'each version belongs to a tool; links to tool',
  user_add_on_flag       tinyint(1) NOT NULL DEFAULT 0       COMMENT 'Was tool added by user: 0=false 1=true',
  version_no             INT                                 COMMENT 'incremental integer version number',
  version_string         VARCHAR(100)                        COMMENT 'eg version 5.0 stable release for Windows 7 64-bit',
  release_date           TIMESTAMP NULL DEFAULT NULL         COMMENT 'date version is released',
  retire_date            TIMESTAMP NULL DEFAULT NULL         COMMENT 'date version is retired',
  comment_public         VARCHAR(200)                        COMMENT 'Comment visible to users.',
  comment_private        VARCHAR(200)                        COMMENT 'comment for tool owner and admins only',
  tool_path              VARCHAR(200)                        COMMENT 'cannonical path of tool in swamp storage',
  checksum               VARCHAR(200)                        COMMENT 'checksum of tool',
  tool_executable        VARCHAR(200)                        COMMENT 'command to invoke tool',
  tool_arguments         VARCHAR(200)                        COMMENT 'arguments to pass to the tool',
  tool_directory         VARCHAR(200)                        COMMENT 'top level directory within the archive',
  create_user            VARCHAR(25)                         COMMENT 'user that inserted record',
  create_date            TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
  update_user            VARCHAR(25)                         COMMENT 'user that last updated record',
  update_date            TIMESTAMP NULL DEFAULT NULL         COMMENT 'date record last changed',
  PRIMARY KEY (tool_version_uuid),
    CONSTRAINT fk_version_tool FOREIGN KEY (tool_uuid) REFERENCES tool (tool_uuid) ON DELETE CASCADE ON UPDATE CASCADE
 )COMMENT='Tool can have many versions';

CREATE TABLE tool_sharing (
  tool_sharing_id   INT  NOT NULL AUTO_INCREMENT  COMMENT 'internal id',
  tool_uuid         VARCHAR(45)                   COMMENT 'tool uuid',
  project_uuid      VARCHAR(45)                   COMMENT 'project uuid',
  PRIMARY KEY (tool_sharing_id),
     CONSTRAINT fk_tool_sharing FOREIGN KEY (tool_uuid) REFERENCES tool (tool_uuid) ON DELETE CASCADE ON UPDATE CASCADE,
     CONSTRAINT tool_sharing_uc UNIQUE (tool_uuid,project_uuid)
 )COMMENT='contains tools shared with specific projects';

CREATE TABLE tool_language (
  tool_language_id   INT  NOT NULL AUTO_INCREMENT                 COMMENT 'internal id',
  tool_uuid          VARCHAR(45)                                  COMMENT 'tool uuid',
  tool_version_uuid  VARCHAR(45)                                  COMMENT 'version uuid',
  package_type_id    INT                                          COMMENT 'references package_store.package_type',
  create_user        VARCHAR(50)                                  COMMENT 'db user that inserted record',
  create_date        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
  update_user        VARCHAR(50)                                  COMMENT 'db user that last updated record',
  update_date        TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record last updated',
  PRIMARY KEY (tool_language_id)
 )COMMENT='Lists languages that each tool is capable of assessing';

CREATE TABLE tool_platform (
  tool_platform_id      INT  NOT NULL AUTO_INCREMENT                 COMMENT 'internal id',
  tool_uuid             VARCHAR(45)                                  COMMENT 'tool uuid',
  platform_uuid         VARCHAR(45)                                  COMMENT 'platform uuid',
  create_user           VARCHAR(50)                                  COMMENT 'db user that inserted record',
  create_date           TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
  update_user           VARCHAR(50)                                  COMMENT 'db user that last updated record',
  update_date           TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record last updated',
  PRIMARY KEY (tool_platform_id),
    INDEX idx_tool_platform_p (platform_uuid)
 )COMMENT='Lists tool platform compatibilities';

CREATE TABLE tool_viewer_incompatibility (
  tool_viewer_id        INT  NOT NULL AUTO_INCREMENT                 COMMENT 'internal id',
  tool_uuid             VARCHAR(45)                                  COMMENT 'tool uuid',
  viewer_uuid           VARCHAR(45)                                  COMMENT 'viewer uuid',
  create_user           VARCHAR(50)                                  COMMENT 'db user that inserted record',
  create_date           TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
  update_user           VARCHAR(50)                                  COMMENT 'db user that last updated record',
  update_date           TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record last updated',
  PRIMARY KEY (tool_viewer_id),
    INDEX idx_tool_viewer_v (viewer_uuid)
 )COMMENT='Lists tool viewer incompatibilities';


CREATE TABLE tool_owner_history (
  tool_owner_history_id  INT  NOT NULL AUTO_INCREMENT                 COMMENT 'internal id',
  tool_uuid              VARCHAR(45) NOT NULL                         COMMENT 'tool uuid',
  old_tool_owner_uuid     VARCHAR(45)                                  COMMENT 'old tool owner uuid',
  new_tool_owner_uuid     VARCHAR(45)                                  COMMENT 'new tool owner uuid',
  change_date            TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record changed',
  PRIMARY KEY (tool_owner_history_id)
 )COMMENT='tool owner history';
