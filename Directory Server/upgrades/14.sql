# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2016 Software Assurance Marketplace

# v1.18
use project;
drop PROCEDURE if exists upgrade_14;
DELIMITER $$
CREATE PROCEDURE upgrade_14 ()
  BEGIN
    declare script_version_no int;
    declare cur_db_version_no int;
    set script_version_no = 14;

    select max(database_version_no)
      into cur_db_version_no
      from project.database_version;

    if cur_db_version_no < script_version_no then
      begin

        # Flag for test users
        ALTER TABLE project.user_account ADD COLUMN user_type VARCHAR(25) COMMENT 'Type of user' AFTER email_verified_flag;

        # User Support Request Policy
        insert into project.policy (policy_code, description, create_user, policy)
          values ('support-consent', 'User Support Consent', user(),
                  CONCAT('In submitting a support request, you authorize SWAMP support staff to access data associated with your SWAMP account only to the extent required to resolve your support request.',
                         'This authorization is valid only for the duration of your support request and will terminate upon resolution of your support request.'));

        # update database version number
        insert into project.database_version (database_version_no, description) values (script_version_no, 'upgrade to v1.18');
        commit;
      end;
    end if;
END
$$
DELIMITER ;
