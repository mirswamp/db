# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2016 Software Assurance Marketplace

# drop and recreate ENTIRE database, including data
drop database if exists package_store;
create database package_store;

use package_store;

##############################################
CREATE TABLE package (
  package_uuid            VARCHAR(45) NOT NULL                         COMMENT 'package uuid',
  package_owner_uuid      VARCHAR(45) NOT NULL                         COMMENT 'package owner uuid',
  name                    VARCHAR(100)  NOT NULL                       COMMENT 'package name',
  description             VARCHAR(500)                                 COMMENT 'description',
  package_type_id         INT                                          COMMENT 'package_type_id',
  package_sharing_status  VARCHAR(25) NOT NULL DEFAULT 'PRIVATE'       COMMENT 'private, shared, public or retired',
  external_url            VARCHAR(2000)                                COMMENT 'external url, eg GitHub',
  create_user             VARCHAR(25)                                  COMMENT 'db user that inserted record',
  create_date             TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
  update_user             VARCHAR(25)                                  COMMENT 'db user that last updated record',
  update_date             TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record last updated',
  PRIMARY KEY (package_uuid),
  CONSTRAINT package_owner_fk FOREIGN KEY (package_owner_uuid) REFERENCES project.user_account (user_uid)
 )COMMENT='contains all packages';

CREATE TABLE package_version (
  package_version_uuid   VARCHAR(45) NOT NULL                COMMENT 'version uuid',
  package_uuid           VARCHAR(45) NOT NULL                COMMENT 'each version belongs to a package; links to package',
  version_no             INT                                 COMMENT 'incremental integer version number',
  platform_id            INT                                 COMMENT 'Each version works with only one platform',
  version_sharing_status VARCHAR(25) NOT NULL DEFAULT 'PRIVATE' COMMENT 'private, shared, public or retired',
  version_string         VARCHAR(100) NOT NULL  DEFAULT ''   COMMENT 'eg version 5.0 stable release for Windows 7 64-bit',
  release_date           TIMESTAMP NULL DEFAULT NULL         COMMENT 'date version is released',
  retire_date            TIMESTAMP NULL DEFAULT NULL         COMMENT 'date version is retired',
  notes                  VARCHAR(200)                        COMMENT 'Comment visible to users.',
  package_path           VARCHAR(200)                        COMMENT 'cannonical path of package',
  checksum               VARCHAR(200)                        COMMENT 'checksum of package',
  source_path            VARCHAR(200)                        COMMENT 'location of source in package',
  build_file             VARCHAR(200)                        COMMENT '',
  build_system           VARCHAR(200)                        COMMENT 'specify build system',
  build_cmd              VARCHAR(200)                        COMMENT 'populated only if build_system is other',
  build_target           VARCHAR(200)                        COMMENT '',
  build_dir              VARCHAR(200) NULL DEFAULT '.'       COMMENT 'path within the package where the build step should occur',
  build_opt              VARCHAR(200) NULL DEFAULT NULL      COMMENT 'specifies additional options to pass to the build tool that may be package specific',
  config_cmd             VARCHAR(200) NULL DEFAULT NULL      COMMENT 'command to run to configure a package prior to building the package',
  config_opt             VARCHAR(200) NULL DEFAULT NULL      COMMENT 'options to provide to the config_cmd',
  config_dir             VARCHAR(200) NULL DEFAULT '.'       COMMENT 'path where the configure step should occur within the package tree',
  bytecode_class_path    VARCHAR(1000) NULL DEFAULT NULL     COMMENT 'used for java bytecode only',
  bytecode_aux_class_path VARCHAR(1000) NULL DEFAULT NULL    COMMENT 'used for java bytecode only',
  bytecode_source_path   VARCHAR(1000) NULL DEFAULT NULL     COMMENT 'used for java bytecode only',
  android_sdk_target     VARCHAR(255) NULL DEFAULT NULL      COMMENT 'used for android java source code only',
  android_lint_target    VARCHAR(255) NULL DEFAULT NULL      COMMENT 'used for android java source code only',
  android_redo_build     tinyint(1) NULL DEFAULT NULL        COMMENT 'used for android java source code only',
  use_gradle_wrapper     tinyint(1) NULL DEFAULT 0           COMMENT 'Use gradle wrapper: 0=false 1=true',
  language_version       VARCHAR(25) NULL DEFAULT NULL       COMMENT 'version of language',
  maven_version          VARCHAR(25) NULL DEFAULT NULL       COMMENT 'maven-version',
  android_maven_plugin   VARCHAR(255) NULL DEFAULT NULL      COMMENT 'android-maven-plugin',
  create_user            VARCHAR(25)                         COMMENT 'user that inserted record',
  create_date            TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
  update_user            VARCHAR(25)                         COMMENT 'user that last updated record',
  update_date            TIMESTAMP NULL DEFAULT NULL         COMMENT 'date record last changed',
  PRIMARY KEY (package_version_uuid),
    CONSTRAINT fk_version_package FOREIGN KEY (package_uuid) REFERENCES package (package_uuid) ON DELETE CASCADE ON UPDATE CASCADE
 )COMMENT='Package can have many versions';

CREATE TABLE package_version_dependency (
  package_version_dependency_id INT  NOT NULL  AUTO_INCREMENT       COMMENT 'internal id',
  package_version_uuid          VARCHAR(45)                         COMMENT 'pkg version uuid',
  platform_version_uuid         VARCHAR(45)                         COMMENT 'platform version uuid',
  dependency_list               VARCHAR(8000)                        COMMENT 'list of dependencies',
  create_user                   VARCHAR(25)                         COMMENT 'user that inserted record',
  create_date                   TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
  update_user                   VARCHAR(25)                         COMMENT 'user that last updated record',
  update_date                   TIMESTAMP NULL DEFAULT NULL         COMMENT 'date record last changed',
  PRIMARY KEY (package_version_dependency_id)
  )COMMENT='Dependencies for given pkg on given platform';

CREATE TABLE package_sharing (
  package_sharing_id   INT  NOT NULL AUTO_INCREMENT  COMMENT 'internal id',
  package_uuid         VARCHAR(45) NOT NULL          COMMENT 'package uuid',
  project_uuid          VARCHAR(45)                   COMMENT 'project uuid',
  PRIMARY KEY (package_sharing_id),
     CONSTRAINT fk_package_sharing FOREIGN KEY (package_uuid) REFERENCES package (package_uuid) ON DELETE CASCADE ON UPDATE CASCADE,
     CONSTRAINT package_sharing_uc UNIQUE (package_uuid,project_uuid)
 )COMMENT='contains packages shared with specific projects';

CREATE TABLE package_version_sharing (
  package_version_sharing_id   INT  NOT NULL AUTO_INCREMENT  COMMENT 'internal id',
  package_version_uuid         VARCHAR(45) NOT NULL          COMMENT 'package version uuid',
  project_uuid                 VARCHAR(45)                   COMMENT 'project uuid',
  PRIMARY KEY (package_version_sharing_id),
     CONSTRAINT fk_package_version_sharing FOREIGN KEY (package_version_uuid) REFERENCES package_version (package_version_uuid) ON DELETE CASCADE ON UPDATE CASCADE,
     CONSTRAINT package_sharing_uc UNIQUE (package_version_uuid,project_uuid)
 )COMMENT='contains package versions shared with specific projects';

CREATE TABLE package_platform (
  package_platform_id   INT  NOT NULL AUTO_INCREMENT                 COMMENT 'internal id',
  package_uuid          VARCHAR(45)                                  COMMENT 'package uuid',
  package_version_uuid  VARCHAR(45)                                  COMMENT 'version uuid',
  platform_uuid         VARCHAR(45)                                  COMMENT 'platform uuid',
  platform_version_uuid VARCHAR(45)                                  COMMENT 'version uuid',
  compatible_flag       tinyint(1) NOT NULL DEFAULT 1                COMMENT 'Is combo compatible: 0=false 1=true',
  create_user           VARCHAR(50)                                  COMMENT 'db user that inserted record',
  create_date           TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
  update_user           VARCHAR(50)                                  COMMENT 'db user that last updated record',
  update_date           TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record last updated',
  PRIMARY KEY (package_platform_id)
 )COMMENT='Lists known package platform compatibilities';

CREATE TABLE package_owner_history (
  package_owner_history_id  INT  NOT NULL AUTO_INCREMENT                 COMMENT 'internal id',
  package_uuid              VARCHAR(45) NOT NULL                         COMMENT 'package uuid',
  old_package_owner_uuid     VARCHAR(45)                                  COMMENT 'package owner uuid',
  new_package_owner_uuid     VARCHAR(45)                                  COMMENT 'package owner uuid',
  change_date               TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record changed',
  PRIMARY KEY (package_owner_history_id)
 )COMMENT='package owner history';

CREATE TABLE package_type (
  package_type_id                INT  NOT NULL  AUTO_INCREMENT                COMMENT 'internal id',
  name                           VARCHAR(50)                                  COMMENT 'display name',
  package_type_enabled           tinyint(1) NOT NULL DEFAULT 1                COMMENT 'Is enabled: 0=false 1=true',
  platform_user_selectable       tinyint(1) NOT NULL DEFAULT 1                COMMENT 'Is user selectable: 0=false 1=true',
  default_platform_uuid          VARCHAR(45)                                  COMMENT 'default platform',
  default_platform_version_uuid  VARCHAR(45)                                  COMMENT 'default platform version',
  create_user                    VARCHAR(50)                                  COMMENT 'db user that inserted record',
  create_date                    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
  update_user                    VARCHAR(50)                                  COMMENT 'db user that last updated record',
  update_date                    TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record last updated',
  PRIMARY KEY (package_type_id)
 )COMMENT='package types';
