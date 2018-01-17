# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2018 Software Assurance Marketplace

# v1.22
use project;
drop PROCEDURE if exists upgrade_16;
DELIMITER $$
CREATE PROCEDURE upgrade_16 ()
  BEGIN
    declare script_version_no int;
    declare cur_db_version_no int;
    set script_version_no = 16;

    select max(database_version_no)
      into cur_db_version_no
      from project.database_version;

    if cur_db_version_no < script_version_no then
      begin

        # Moved to v1.23 # insert GrammaTech CodeSonar permission
        # Moved to v1.23 insert into project.permission (permission_code, title, description, admin_only_flag, policy_code) values ('codesonar-user', 'CodeSonar User', 'GrammaTech CodeSonar User', 0, 'codesonar-user-policy');
        # Moved to v1.23 # insert GrammaTech policy
        # Moved to v1.23 insert into project.policy (policy_code, description, policy) values ('codesonar-user-policy', 'GrammaTech CodeSonar EULA', '<div style=\"white-space: pre-wrap;\">\r\n\r\nSOFTWARE END USER LICENCE TERMS\r\n\r\nGrammaTech CodeSonar EULA</div>');

        # Add forcepwreset_flag column to the user_account table
        ALTER TABLE project.user_account
          ADD COLUMN forcepwreset_flag tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Force password reset on next login: 0=false 1=true' AFTER email_verified_flag;

        # Record history of changes to forcepwreset_flag column
        # Add user_forcepwreset_history table
        CREATE TABLE project.user_forcepwreset_history (
          user_forcepwreset_history_id INT  NOT NULL AUTO_INCREMENT                 COMMENT 'internal id',
          user_uid                     VARCHAR(45) NOT NULL                         COMMENT 'user uuid',
          old_forcepwreset_flag        tinyint(1)                                   COMMENT 'old value',
          new_forcepwreset_flag        tinyint(1)                                   COMMENT 'new new',
          change_date                  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record changed',
          PRIMARY KEY (user_forcepwreset_history_id)
         )COMMENT='user forcepwreset history';

        # Remove Admin Dashboard Access permission record
        delete from project.permission where permission_code = 'dashboard-access';

        # Add hibernate_flag column to the user_account table
        ALTER TABLE project.user_account
          ADD COLUMN hibernate_flag tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Acct hibernate due to inactivity: 0=false 1=true' AFTER forcepwreset_flag;

        # update database version number
        insert into project.database_version (database_version_no, description) values (script_version_no, 'upgrade to v1.22');
        commit;
      end;
    end if;
END
$$
DELIMITER ;
