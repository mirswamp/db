# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2019 Software Assurance Marketplace

# v1.32
USE project;
DROP PROCEDURE IF EXISTS upgrade_22;
DELIMITER $$
CREATE PROCEDURE upgrade_22 ()
  BEGIN
    DECLARE script_version_no INT;
    DECLARE cur_db_version_no INT;
    declare system_type varchar(200);
    SET script_version_no = 22;

    SELECT max(database_version_no)
      INTO cur_db_version_no
      FROM project.database_version;

    IF cur_db_version_no < script_version_no THEN
      BEGIN


        # Add column - delete_date
          # project
          # project_invitation
          # user_account
          # permission
          # user_permission_project
          # user_permission_package
          # policy
          # user_policy
          # admin_invitation
          # email_verification
          # password_reset
          # restricted_domains - rename columns
        if exists (select * from information_schema.columns where table_schema = 'project' and table_name = 'project'                 and column_name = 'delete_date') then
                                                                                         alter table project.project                  drop column delete_date; end if;
                                                                                         alter TABLE project.project                  add column delete_date TIMESTAMP NULL DEFAULT NULL COMMENT 'soft delete';
        if exists (select * from information_schema.columns where table_schema = 'project' and table_name = 'project_invitation'      and column_name = 'delete_date') then
                                                                                         alter table project.project_invitation       drop column delete_date; end if;
                                                                                         alter TABLE project.project_invitation       add column delete_date TIMESTAMP NULL DEFAULT NULL COMMENT 'soft delete';
        if exists (select * from information_schema.columns where table_schema = 'project' and table_name = 'user_account'            and column_name = 'delete_date') then
                                                                                         alter table project.user_account             drop column delete_date; end if;
                                                                                         alter TABLE project.user_account             add column delete_date TIMESTAMP NULL DEFAULT NULL COMMENT 'soft delete';
        if exists (select * from information_schema.columns where table_schema = 'project' and table_name = 'permission'              and column_name = 'delete_date') then
                                                                                         alter table project.permission               drop column delete_date; end if;
                                                                                         alter TABLE project.permission               add column delete_date TIMESTAMP NULL DEFAULT NULL COMMENT 'soft delete';
        if exists (select * from information_schema.columns where table_schema = 'project' and table_name = 'user_permission_project' and column_name = 'delete_date') then
                                                                                         alter table project.user_permission_project  drop column delete_date; end if;
                                                                                         alter TABLE project.user_permission_project  add column delete_date TIMESTAMP NULL DEFAULT NULL COMMENT 'soft delete';
        if exists (select * from information_schema.columns where table_schema = 'project' and table_name = 'user_permission_package' and column_name = 'delete_date') then
                                                                                         alter table project.user_permission_package  drop column delete_date; end if;
                                                                                         alter TABLE project.user_permission_package  add column delete_date TIMESTAMP NULL DEFAULT NULL COMMENT 'soft delete';
        if exists (select * from information_schema.columns where table_schema = 'project' and table_name = 'policy'                  and column_name = 'delete_date') then
                                                                                         alter table project.policy                   drop column delete_date; end if;
                                                                                         alter TABLE project.policy                   add column delete_date TIMESTAMP NULL DEFAULT NULL COMMENT 'soft delete';
        if exists (select * from information_schema.columns where table_schema = 'project' and table_name = 'user_policy'             and column_name = 'delete_date') then
                                                                                         alter table project.user_policy              drop column delete_date; end if;
                                                                                         alter TABLE project.user_policy              add column delete_date TIMESTAMP NULL DEFAULT NULL COMMENT 'soft delete';
        if exists (select * from information_schema.columns where table_schema = 'project' and table_name = 'admin_invitation'        and column_name = 'delete_date') then
                                                                                         alter table project.admin_invitation         drop column delete_date; end if;
                                                                                         alter TABLE project.admin_invitation         add column delete_date TIMESTAMP NULL DEFAULT NULL COMMENT 'soft delete';
        if exists (select * from information_schema.columns where table_schema = 'project' and table_name = 'email_verification'      and column_name = 'delete_date') then
                                                                                         alter table project.email_verification       drop column delete_date; end if;
                                                                                         alter TABLE project.email_verification       add column delete_date TIMESTAMP NULL DEFAULT NULL COMMENT 'soft delete';
        if exists (select * from information_schema.columns where table_schema = 'project' and table_name = 'password_reset'          and column_name = 'delete_date') then
                                                                                         alter table project.password_reset           drop column delete_date; end if;
                                                                                         alter TABLE project.password_reset           add column delete_date TIMESTAMP NULL DEFAULT NULL COMMENT 'soft delete';
        if exists (select * from information_schema.columns
                    where table_schema = 'project'
                      and table_name = 'restricted_domains'
                      and column_name = 'created_at') then
          ALTER TABLE project.restricted_domains CHANGE COLUMN created_at create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'date created';
        end if;
        if exists (select * from information_schema.columns
                    where table_schema = 'project'
                      and table_name = 'restricted_domains'
                      and column_name = 'updated_at') then
          ALTER TABLE project.restricted_domains CHANGE COLUMN updated_at update_date TIMESTAMP NULL DEFAULT NULL COMMENT 'date updated';
        end if;
        if exists (select * from information_schema.columns
                    where table_schema = 'project'
                      and table_name = 'restricted_domains'
                      and column_name = 'deleted_at') then
          ALTER TABLE project.restricted_domains CHANGE COLUMN deleted_at delete_date TIMESTAMP NULL DEFAULT NULL COMMENT 'date deleted';
        end if;


        # update database version number
        INSERT INTO project.database_version (database_version_no, description) values (script_version_no, 'upgrade to v1.32');
        COMMIT;

      END;
    END IF;
  END
$$
DELIMITER ;
