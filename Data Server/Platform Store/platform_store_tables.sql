# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2016 Software Assurance Marketplace

drop database if exists platform_store;
create database platform_store;

use platform_store;

CREATE TABLE platform (
  platform_uuid           VARCHAR(45) NOT NULL                         COMMENT 'platform uuid',
  platform_owner_uuid     VARCHAR(45)                                  COMMENT 'platform owner uuid',
  name                    VARCHAR(100)  NOT NULL                       COMMENT 'Platform name',
  description             VARCHAR(500)                                 COMMENT 'description',
  platform_sharing_status VARCHAR(25) NOT NULL DEFAULT 'PRIVATE'       COMMENT 'private, shared, public or retired',
  create_user             VARCHAR(25)                                  COMMENT 'db user that inserted record',
  create_date             TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
  update_user             VARCHAR(25)                                  COMMENT 'db user that last updated record',
  update_date             TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record last updated',
  PRIMARY KEY (platform_uuid)
 )COMMENT='contains all platforms';

CREATE TABLE platform_version (
  platform_version_uuid  VARCHAR(45) NOT NULL                COMMENT 'version uuid',
  platform_uuid          VARCHAR(45) NOT NULL                COMMENT 'each version belongs to a platform; links to platform',
  version_no             INT                                 COMMENT 'incremental integer version number',
  version_string         VARCHAR(100)                        COMMENT 'eg version 5.0 stable release for Windows 7 64-bit',
  release_date           TIMESTAMP NULL DEFAULT NULL         COMMENT 'date version is released',
  retire_date            TIMESTAMP NULL DEFAULT NULL         COMMENT 'date version is retired',
  comment_public         VARCHAR(200)                        COMMENT 'Comment visible to users.',
  comment_private        VARCHAR(200)                        COMMENT 'comment for platform owner and admins only',
  platform_path          VARCHAR(200)                        COMMENT 'cannonical path of platform',
  checksum               VARCHAR(200)                        COMMENT 'checksum of platform',
  invocation_cmd         VARCHAR(200)                        COMMENT 'command to invoke platform',
  deployment_cmd         VARCHAR(200)                        COMMENT 'command to deploy platform',
  create_user            VARCHAR(25)                         COMMENT 'user that inserted record',
  create_date            TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
  update_user            VARCHAR(25)                         COMMENT 'user that last updated record',
  update_date            TIMESTAMP NULL DEFAULT NULL         COMMENT 'date record last changed',
  PRIMARY KEY (platform_version_uuid),
    CONSTRAINT fk_version_platform FOREIGN KEY (platform_uuid) REFERENCES platform (platform_uuid) ON DELETE CASCADE ON UPDATE CASCADE
 )COMMENT='Platform can have many versions';

CREATE TABLE platform_sharing (
  platform_sharing_id  INT  NOT NULL AUTO_INCREMENT  COMMENT 'internal id',
  platform_uuid       VARCHAR(45) NOT NULL           COMMENT 'platform uuid',
  project_uuid          VARCHAR(45)                   COMMENT 'project uuid',
  PRIMARY KEY (platform_sharing_id),
     CONSTRAINT fk_platform_sharing FOREIGN KEY (platform_uuid) REFERENCES platform (platform_uuid) ON DELETE CASCADE ON UPDATE CASCADE,
     CONSTRAINT platform_sharing_uc UNIQUE (platform_uuid,project_uuid)
 )COMMENT='contains platforms shared with specific projects';

CREATE TABLE platform_owner_history (
  platform_owner_history_id  INT  NOT NULL AUTO_INCREMENT                 COMMENT 'internal id',
  platform_uuid              VARCHAR(45) NOT NULL                         COMMENT 'platform uuid',
  old_platform_owner_uuid    VARCHAR(45)                                  COMMENT 'platform owner uuid',
  new_platform_owner_uuid    VARCHAR(45)                                  COMMENT 'platform owner uuid',
  change_date                TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record changed',
  PRIMARY KEY (platform_owner_history_id)
 )COMMENT='platform owner history';
