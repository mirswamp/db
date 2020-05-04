# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2020 Software Assurance Marketplace

# v1.30
use assessment;
drop PROCEDURE if exists upgrade_54;
DELIMITER $$
CREATE PROCEDURE upgrade_54 ()
  BEGIN
    declare script_version_no int;
    declare cur_db_version_no int;
    declare system_type varchar(200);
    set script_version_no = 54;

    select max(database_version_no)
      into cur_db_version_no
      from assessment.database_version;

    if cur_db_version_no < script_version_no then
      begin

        # system_type
        if not exists (select * from assessment.system_setting where system_setting_code = 'SYSTEM_TYPE') then
            insert into assessment.system_setting (system_setting_code, system_setting_value) values ('SYSTEM_TYPE', 'SWAMP_IN_A_BOX');
        end if;
        select system_setting_value
          into system_type
          from assessment.system_setting
         where system_setting_code = 'SYSTEM_TYPE';

        # add new table for application passwords
        CREATE TABLE IF NOT EXISTS project.app_passwords (
          app_password_id   INT          NOT NULL AUTO_INCREMENT            COMMENT 'internal id',
          app_password_uuid VARCHAR(45)  NOT NULL                           COMMENT 'app password uuid',
          user_uid          VARCHAR(127) NOT NULL                           COMMENT 'user uuid',
          password          VARCHAR(127) NOT NULL                           COMMENT 'password hash',
          label             VARCHAR(63)                                     COMMENT 'optional label',
          create_date       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'creation date',
          update_date       TIMESTAMP    NULL DEFAULT NULL                  COMMENT 'update date',
          PRIMARY KEY (app_password_id)
        ) COMMENT='application passwords';

        # drop specialized_tool_version table
        drop table if exists tool_shed.specialized_tool_version;

        # drop foreign key constraints for tool (in)compatibility tables
        if exists (select * from information_schema.table_constraints
                      where table_schema = 'tool_shed'
                        and table_name = 'tool_platform'
                        and constraint_type = 'foreign key'
                        and constraint_name = 'fk_tool_platform_t')
        then
            alter table tool_shed.tool_platform drop foreign key fk_tool_platform_t;
        end if;
        if exists (select * from information_schema.table_constraints
                      where table_schema = 'tool_shed'
                        and table_name = 'tool_viewer_incompatibility'
                        and constraint_type = 'foreign key'
                        and constraint_name = 'fk_tool_viewer_t')
        then
            alter table tool_shed.tool_viewer_incompatibility drop foreign key fk_tool_viewer_t;
        end if;

        # update database version number
        delete from assessment.database_version where database_version_no = script_version_no;
        insert into assessment.database_version (database_version_no, description) values (script_version_no, 'upgrade to v1.30');

        commit;
      end;
    end if;
END
$$
DELIMITER ;
