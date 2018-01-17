# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2018 Software Assurance Marketplace

# drop and recreate ENTIRE database, including data
drop database if exists project;
create database project;

use project;

##############################################
CREATE TABLE project (
  project_id                 INT  NOT NULL  AUTO_INCREMENT       COMMENT 'internal id',
  project_uid                VARCHAR(45)                         COMMENT 'project uuid',
  project_owner_uid          VARCHAR(45)                         COMMENT 'project owner uuid',
  full_name                  VARCHAR(100)                        COMMENT 'name of project',
  short_name                 VARCHAR(20)                         COMMENT 'short name of project',
  description                VARCHAR(500)                        COMMENT 'description of project',
  affiliation                VARCHAR(45)                         COMMENT 'name of affiliated organization',
  trial_project_flag         tinyint(1) NOT NULL DEFAULT 0       COMMENT 'Is project a trial project: 0=false 1=true',
  exclude_public_tools_flag  tinyint(1) NOT NULL DEFAULT 0       COMMENT 'Exclude public tools from project: 0=false 1=true',
  create_date                TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'date project created',
  denial_date                TIMESTAMP NULL DEFAULT NULL         COMMENT 'date project denied',
  deactivation_date          TIMESTAMP NULL DEFAULT NULL         COMMENT 'date of retirement',
  delete_date            TIMESTAMP NULL DEFAULT NULL             COMMENT 'soft delete',
  PRIMARY KEY (project_id)
 ) COMMENT='contains project info';

# index required for foreign keys to reference project_uid
CREATE INDEX project_project_uid ON project ( project_uid );

CREATE TABLE project_owner_history (
  project_owner_history_id  INT  NOT NULL AUTO_INCREMENT                 COMMENT 'internal id',
  project_id                INT                                          COMMENT 'project id',
  project_uid               VARCHAR(45) NOT NULL                         COMMENT 'project uuid',
  old_project_owner_uid     VARCHAR(45)                                  COMMENT 'old project owner uuid',
  new_project_owner_uid     VARCHAR(45)                                  COMMENT 'new project owner uuid',
  change_date               TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record changed',
  PRIMARY KEY (project_owner_history_id)
 )COMMENT='project owner history';

CREATE TABLE project_user (
  id                     INT  NOT NULL  AUTO_INCREMENT                COMMENT 'internal id',
  project_uid            VARCHAR(45)                                  COMMENT 'project uuid',
  user_uid               VARCHAR(45)                                  COMMENT 'user uuid',
  membership_uid         VARCHAR(45)                                  COMMENT 'id for membership, used by front end',
  admin_flag             tinyint(1) NOT NULL DEFAULT 0                COMMENT 'Is user a project admin: 0=false 1=true',
  create_date            TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date user joined project',
  delete_date            TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date user left project',
  expire_date            TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date membership expires',
  PRIMARY KEY (id),
    CONSTRAINT fk_project_user FOREIGN KEY (project_uid) REFERENCES project (project_uid),
    INDEX idx_project_user_user_uid (user_uid)
 ) COMMENT='Project-user cross reference';

CREATE TABLE project_invitation (
  invitation_id          INT  NOT NULL  AUTO_INCREMENT           COMMENT 'internal id',
  project_uid            VARCHAR(45)  NOT NULL                   COMMENT 'project uuid',
  invitation_key         VARCHAR(100) NOT NULL                   COMMENT 'invitation key',
  invitee_email          VARCHAR(100)                            COMMENT 'invitee email address',
  inviter_uid            VARCHAR(45)                             COMMENT 'inviter user uuid',
  invitee_uid            VARCHAR(45)                             COMMENT 'invitee user uuid',
  invitee_name           VARCHAR(100)                            COMMENT 'name of invitee',
  invitee_username       VARCHAR(100)                            COMMENT 'username of invitee',
  create_date            TIMESTAMP DEFAULT CURRENT_TIMESTAMP     COMMENT 'date invitation created',
  accept_date            TIMESTAMP NULL DEFAULT NULL             COMMENT 'date invitation accepted',
  decline_date           TIMESTAMP NULL DEFAULT NULL             COMMENT 'date invitation declined',
  delete_date            TIMESTAMP NULL DEFAULT NULL             COMMENT 'soft delete',
  PRIMARY KEY (invitation_id),
    CONSTRAINT fk_project_invitation FOREIGN KEY (project_uid) REFERENCES project (project_uid)
 ) COMMENT='Project invitations';

CREATE TABLE user_account (
  user_uid                  VARCHAR(45)                                  COMMENT 'user uuid',
  enabled_flag              tinyint(1) NOT NULL DEFAULT 1                COMMENT 'Is account enabled: 0=false 1=true',
  admin_flag                tinyint(1) NOT NULL DEFAULT 0                COMMENT 'Is user a sys admin: 0=false 1=true',
  email_verified_flag       tinyint(1) NOT NULL DEFAULT 0                COMMENT 'Is email verified: 0=false 1=true',
  forcepwreset_flag         tinyint(1) NOT NULL DEFAULT 0                COMMENT 'Force password reset on next login: 0=false 1=true',
  hibernate_flag            tinyint(1) NOT NULL DEFAULT 0                COMMENT 'Acct hibernate due to inactivity: 0=false 1=true',
  user_type                 VARCHAR(25)                                  COMMENT 'Type of user',
  ldap_profile_update_date  TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date of last ldap profile update',
  ultimate_login_date       TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date of most recent login',
  penultimate_login_date    TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date of 2nd to last login',
  promo_code_id             INT                                          COMMENT 'promo code id',
  create_user               VARCHAR(25)                                  COMMENT 'db user that inserted record',
  create_date               TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
  update_user               VARCHAR(25)                                  COMMENT 'db user that last updated record',
  update_date               TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record last updated',
  delete_date               TIMESTAMP NULL DEFAULT NULL                  COMMENT 'soft delete',
  PRIMARY KEY (user_uid)
 )COMMENT='user account info';

CREATE TABLE user_forcepwreset_history (
  user_forcepwreset_history_id INT  NOT NULL AUTO_INCREMENT                 COMMENT 'internal id',
  user_uid                     VARCHAR(45) NOT NULL                         COMMENT 'user uuid',
  old_forcepwreset_flag        tinyint(1)                                   COMMENT 'old value',
  new_forcepwreset_flag        tinyint(1)                                   COMMENT 'new new',
  change_date                  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record changed',
  PRIMARY KEY (user_forcepwreset_history_id)
 )COMMENT='user forcepwreset history';

CREATE TABLE user_event (
  user_event_id             INT  NOT NULL  AUTO_INCREMENT                COMMENT 'internal id',
  user_uid                  VARCHAR(45)                                  COMMENT 'user uuid',
  event_type                VARCHAR(255)                                 COMMENT 'event type',
  value                     VARCHAR(8000)                                COMMENT 'event value',
  create_user               VARCHAR(25)                                  COMMENT 'db user that inserted record',
  create_date               TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
  update_user               VARCHAR(25)                                  COMMENT 'db user that last updated record',
  update_date               TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record last updated',
  PRIMARY KEY (user_event_id)
 )COMMENT='user events';

CREATE TABLE permission (
  permission_code           VARCHAR(100) NOT NULL                        COMMENT 'permission code',
  title                     VARCHAR(100)                                 COMMENT 'display name',
  description               VARCHAR(200)                                 COMMENT 'explanation of permission',
  admin_only_flag           tinyint(1) NOT NULL DEFAULT 0                COMMENT 'Is visible to admins only: 0=false 1=true',
  auto_approve_flag         tinyint(1) NOT NULL DEFAULT 0                COMMENT 'Is automatically approved: 0=false 1=true',
  policy_code               VARCHAR(100)                                 COMMENT 'links to policy',
  user_info                 VARCHAR (5000)                               COMMENT 'what user info is gathered',
  user_info_policy_text     VARCHAR (5000)                               COMMENT 'what will be done with user info',
  create_user               VARCHAR(25)                                  COMMENT 'db user that inserted record',
  create_date               TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
  update_user               VARCHAR(25)                                  COMMENT 'db user that last updated record',
  update_date               TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record last updated',
  delete_date               TIMESTAMP NULL DEFAULT NULL                  COMMENT 'soft delete',
  PRIMARY KEY (permission_code)
 )COMMENT='lists all possible user permissions';

CREATE TABLE user_permission (
  user_permission_uid       VARCHAR(45)  NOT NULL                        COMMENT 'internal id',
  permission_code           VARCHAR(100) NOT NULL                        COMMENT 'permission being granted',
  user_uid                  VARCHAR(45)  NOT NULL                        COMMENT 'user uuid',
  user_comment              VARCHAR(500)                                 COMMENT 'why requested by user',
  admin_comment             VARCHAR(500)                                 COMMENT 'why granted or denied by admin',
  meta_information          VARCHAR(500)                                 COMMENT 'user info specific to request',
  request_date              TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date requested',
  grant_date                TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date granted',
  denial_date               TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date denied',
  expiration_date           TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date expires',
  delete_date               TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date revoked',
  create_user               VARCHAR(25)                                  COMMENT 'db user that inserted record',
  create_date               TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
  update_user               VARCHAR(25)                                  COMMENT 'db user that last updated record',
  update_date               TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record last updated',
  PRIMARY KEY (user_permission_uid)
 )COMMENT='user permission info';

CREATE TABLE user_permission_history (
  user_permission_history_id  INT  NOT NULL AUTO_INCREMENT               COMMENT 'internal id',
  user_permission_uid       VARCHAR(45)  NOT NULL                        COMMENT 'internal id',
  permission_code           VARCHAR(100) NOT NULL                        COMMENT 'permission being granted',
  user_uid                  VARCHAR(45)  NOT NULL                        COMMENT 'user uuid',
  user_comment              VARCHAR(500)                                 COMMENT 'why requested by user',
  admin_comment             VARCHAR(500)                                 COMMENT 'why granted or denied by admin',
  meta_information          VARCHAR(500)                                 COMMENT 'user info specific to request',
  request_date              DATETIME                                     COMMENT 'date requested',
  grant_date                DATETIME                                     COMMENT 'date granted',
  denial_date               DATETIME                                     COMMENT 'date denied',
  expiration_date           DATETIME                                     COMMENT 'date expires',
  delete_date               DATETIME                                     COMMENT 'date revoked',
  change_date               TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record changed',
  PRIMARY KEY (user_permission_history_id)
 )COMMENT='user permission history';

CREATE TABLE user_permission_project (
  user_permission_project_uid VARCHAR(45)  NOT NULL                        COMMENT 'internal id',
  user_permission_uid         VARCHAR(45)  NOT NULL                        COMMENT 'references user_permission table',
  project_uid                 VARCHAR(45)  NOT NULL                        COMMENT 'project to which user permission applies',
  create_user                 VARCHAR(25)                                  COMMENT 'db user that inserted record',
  create_date                 TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
  update_user                 VARCHAR(25)                                  COMMENT 'db user that last updated record',
  update_date                 TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record last updated',
  delete_date                 TIMESTAMP NULL DEFAULT NULL                  COMMENT 'soft delete',
  PRIMARY KEY (user_permission_project_uid),
    CONSTRAINT fk_usr_prmssn_prjct FOREIGN KEY (user_permission_uid) REFERENCES user_permission (user_permission_uid) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_usr_prmssn_prjct_to_prjct FOREIGN KEY (project_uid) REFERENCES project (project_uid) ON DELETE CASCADE ON UPDATE CASCADE
 )COMMENT='projects to which user permission applies';

CREATE TABLE user_permission_package (
  user_permission_package_uid VARCHAR(45)  NOT NULL                        COMMENT 'internal id',
  user_permission_uid         VARCHAR(45)  NOT NULL                        COMMENT 'references user_permission table',
  package_uuid                VARCHAR(45)  NOT NULL                        COMMENT 'package to which user permission applies',
  create_user                 VARCHAR(25)                                  COMMENT 'db user that inserted record',
  create_date                 TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
  update_user                 VARCHAR(25)                                  COMMENT 'db user that last updated record',
  update_date                 TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record last updated',
  delete_date                 TIMESTAMP NULL DEFAULT NULL                  COMMENT 'soft delete',
  PRIMARY KEY (user_permission_package_uid),
    CONSTRAINT fk_usr_prmssn_pkg FOREIGN KEY (user_permission_uid) REFERENCES user_permission (user_permission_uid) ON DELETE CASCADE ON UPDATE CASCADE
 )COMMENT='packages to which user permission applies';

CREATE TABLE policy (
  policy_code               VARCHAR(100) NOT NULL                        COMMENT 'policy code',
  description               VARCHAR(200)                                 COMMENT 'explanation of policy',
  policy                    TEXT                                         COMMENT 'Use Policy or License Agreement',
  create_user               VARCHAR(25)                                  COMMENT 'db user that inserted record',
  create_date               TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
  update_user               VARCHAR(25)                                  COMMENT 'db user that last updated record',
  update_date               TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record last updated',
  delete_date               TIMESTAMP NULL DEFAULT NULL                  COMMENT 'soft delete',
  PRIMARY KEY (policy_code)
 )COMMENT='Use Policies or License Agreements';

CREATE TABLE user_policy (
  user_policy_uid           VARCHAR(45) NOT NULL                         COMMENT 'internal id',
  user_uid                  VARCHAR(45) NOT NULL                         COMMENT 'user uuid',
  policy_code               VARCHAR(100) NOT NULL                        COMMENT 'policy code',
  accept_flag               tinyint(1)                                   COMMENT 'Did user accept or decline: 0=decline 1=accept',
  create_user               VARCHAR(25)                                  COMMENT 'db user that inserted record',
  create_date               TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
  update_user               VARCHAR(25)                                  COMMENT 'db user that last updated record',
  update_date               TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record last updated',
  delete_date               TIMESTAMP NULL DEFAULT NULL                  COMMENT 'soft delete',
  PRIMARY KEY (user_policy_uid)
 )COMMENT='user policy info';

CREATE TABLE admin_invitation (
  admin_invitation_id    INT  NOT NULL  AUTO_INCREMENT           COMMENT 'internal id',
  invitation_key         VARCHAR(100)                            COMMENT 'invitation key',
  inviter_uid            VARCHAR(45)                             COMMENT 'inviter user uuid',
  invitee_uid            VARCHAR(45)                             COMMENT 'invitee user uuid',
  create_date            TIMESTAMP DEFAULT CURRENT_TIMESTAMP     COMMENT 'date invitation created',
  accept_date            TIMESTAMP NULL DEFAULT NULL             COMMENT 'date invitation accepted',
  decline_date           TIMESTAMP NULL DEFAULT NULL             COMMENT 'date invitation declined',
  delete_date            TIMESTAMP NULL DEFAULT NULL             COMMENT 'soft delete',
  PRIMARY KEY (admin_invitation_id)
 ) COMMENT='Admin invitations';

# could be replaced by user_account table
CREATE TABLE email_verification (
  email_verification_id  INT  NOT NULL  AUTO_INCREMENT       COMMENT 'internal id',
  user_uid               VARCHAR(45)                         COMMENT 'user uuid',
  verification_key       VARCHAR(100)                        COMMENT 'verification key',
  email                  VARCHAR(100)                        COMMENT 'email address',
  create_date            TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
  verify_date            TIMESTAMP NULL DEFAULT NULL         COMMENT 'date email verified, null if not verified',
  delete_date            TIMESTAMP NULL DEFAULT NULL         COMMENT 'soft delete',
  PRIMARY KEY (email_verification_id)
 ) COMMENT='email verifications';

CREATE TABLE password_reset (
  password_reset_uuid    VARCHAR(45)                         COMMENT 'internal id',
  user_uid               VARCHAR(45)                         COMMENT 'user uuid',
  password_reset_key     VARCHAR(100)                        COMMENT 'reset key',
  create_date            TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
  delete_date            TIMESTAMP NULL DEFAULT NULL         COMMENT 'soft delete',
  PRIMARY KEY (password_reset_uuid)
 ) COMMENT='Password Reset keys';

CREATE TABLE restricted_domains (
  restricted_domain_id   INT  NOT NULL  AUTO_INCREMENT       COMMENT 'internal id',
  domain_name            VARCHAR(127)                        COMMENT 'domain name',
  description            VARCHAR(255)                        COMMENT 'domain description',
  create_date             TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'date created',
  update_date             TIMESTAMP NULL DEFAULT NULL         COMMENT 'date updated',
  delete_date             TIMESTAMP NULL DEFAULT NULL         COMMENT 'date deleted',
  PRIMARY KEY (restricted_domain_id)
 ) COMMENT='Restricted Domains';

CREATE TABLE countries (
  id int(11) NOT NULL AUTO_INCREMENT,
  iso char(2) NOT NULL,
  name varchar(80) NOT NULL DEFAULT '',
  iso3 char(3) DEFAULT NULL,
  num_code smallint(6) DEFAULT NULL,
  phone_code int(5) NOT NULL,
  PRIMARY KEY (id)
);

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

CREATE TABLE promo_code (
  promo_code_id   INT  NOT NULL  AUTO_INCREMENT                COMMENT 'internal id',
  promo_code      VARCHAR(45)                                  COMMENT 'promo code',
  display_name    VARCHAR(45)                                  COMMENT 'display name',
  description     VARCHAR(200)                                 COMMENT 'description',
  expiration_date TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date promo code expires',
  create_user     VARCHAR(50)                                  COMMENT 'db user that inserted record',
  create_date     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
  update_user     VARCHAR(50)                                  COMMENT 'db user that last updated record',
  update_date     TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record last updated',
  PRIMARY KEY (promo_code_id)
 )COMMENT='promo_code';

CREATE TABLE linked_account_provider (
  linked_account_provider_code  VARCHAR(100) NOT NULL                        COMMENT 'linked account provider code',
  title                         VARCHAR(256)                                 COMMENT 'display name',
  description                   VARCHAR(2000)                                COMMENT 'description',
  enabled_flag                  tinyint(1) NOT NULL DEFAULT 1                COMMENT 'Is provider enabled: 0=false 1=true',
  create_user                   VARCHAR(50)                                  COMMENT 'db user that inserted record',
  create_date                   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
  update_user                   VARCHAR(50)                                  COMMENT 'db user that last updated record',
  update_date                   TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record last updated',
  PRIMARY KEY (linked_account_provider_code)
 )COMMENT='linked account providers';

CREATE TABLE linked_account (
  linked_account_id             INT  NOT NULL  AUTO_INCREMENT                COMMENT 'internal id',
  user_uid                      VARCHAR(45) NOT NULL                         COMMENT 'user uuid',
  linked_account_provider_code  VARCHAR(100) NOT NULL                        COMMENT 'linked account provider code',
  user_external_id              VARCHAR(1000)                                COMMENT 'user id in remote system',
  enabled_flag                  tinyint(1) NOT NULL DEFAULT 1                COMMENT 'Is provider enabled: 0=false 1=true',
  create_user                   VARCHAR(50)                                  COMMENT 'db user that inserted record',
  create_date                   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
  update_user                   VARCHAR(50)                                  COMMENT 'db user that last updated record',
  update_date                   TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record last updated',
  PRIMARY KEY (linked_account_id),
    CONSTRAINT fk_linked_account FOREIGN KEY (linked_account_provider_code) REFERENCES linked_account_provider (linked_account_provider_code)
 )COMMENT='linked accounts';

CREATE TABLE app_passwords (
  app_password_id   INT          NOT NULL AUTO_INCREMENT            COMMENT 'internal id',
  app_password_uuid VARCHAR(45)  NOT NULL                           COMMENT 'app password uuid',
  user_uid          VARCHAR(127) NOT NULL                           COMMENT 'user uuid',
  password          VARCHAR(127) NOT NULL                           COMMENT 'password hash',
  label             VARCHAR(63)                                     COMMENT 'optional label',
  create_date       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'creation date',
  update_date       TIMESTAMP    NULL DEFAULT NULL                  COMMENT 'update date',
  PRIMARY KEY (app_password_id)
) COMMENT='application passwords';
