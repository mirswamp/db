# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2017 Software Assurance Marketplace

# v1.27
use project;
drop PROCEDURE if exists upgrade_18;
DELIMITER $$
CREATE PROCEDURE upgrade_18 ()
  BEGIN
    declare script_version_no int;
    declare cur_db_version_no int;
    set script_version_no = 18;

    select max(database_version_no)
      into cur_db_version_no
      from project.database_version;

    if cur_db_version_no < script_version_no then
      begin

        # Rename project_invitation email to invitee_email and make nullable
        if exists (select * from information_schema.columns
                    where table_schema = 'project'
                      and table_name = 'project_invitation'
                      and column_name = 'email') then
            alter table project.project_invitation change email invitee_email VARCHAR(100) COMMENT 'invitee email address';
        end if;

        # Add invitee_uid to project_invitation table
        # drop column if exist
        if exists (select * from information_schema.columns
                    where table_schema = 'project'
                      and table_name = 'project_invitation'
                      and column_name = 'invitee_uid') then
            alter table project.project_invitation drop column invitee_uid;
        end if;
        alter TABLE project.project_invitation add column invitee_uid VARCHAR(45) COMMENT 'invitee user uuid' AFTER inviter_uid;

        # Add username to project_invitation table
        # drop column if exist
        if exists (select * from information_schema.columns
                    where table_schema = 'project'
                      and table_name = 'project_invitation'
                      and column_name = 'invitee_username') then
            alter table project.project_invitation drop column invitee_username;
        end if;
        alter TABLE project.project_invitation add column invitee_username VARCHAR(100) COMMENT 'username of invitee' AFTER invitee_name;

        # update database version number
        insert into project.database_version (database_version_no, description) values (script_version_no, 'upgrade to v1.27');
        commit;
      end;
    end if;
END
$$
DELIMITER ;
