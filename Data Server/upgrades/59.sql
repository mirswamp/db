# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2020 Software Assurance Marketplace

# v1.33.4
use assessment;
drop PROCEDURE if exists upgrade_59;
DELIMITER $$
CREATE PROCEDURE upgrade_59 ()
  BEGIN
    declare script_version_no int;
    declare cur_db_version_no int;
    declare system_type varchar(200);
    set script_version_no = 59;

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

        if (system_type = 'SWAMP_IN_A_BOX') then
          # delete sonatype permission & policy - Could have been inserted with a 1.33.3 install of SWAMP-IN-A-BOX
          delete from project.permission where permission_code = 'sonatype-user';
          delete from project.policy where policy_code = 'sonatype-user-policy';
        end if;

        # Increase package_version.notes from 200 to 1000
        ALTER TABLE package_store.package_version CHANGE COLUMN notes notes VARCHAR(1000) NULL DEFAULT NULL COMMENT 'Comment visible to users.';

        # Add column execution_record.slot_size_start
        if exists (select * from information_schema.columns
                    where table_schema = 'assessment'
                      and table_name = 'execution_record'
                      and column_name = 'slot_size_start') then
            alter table assessment.execution_record drop column slot_size_start;
        end if;
        alter TABLE assessment.execution_record add column slot_size_start VARCHAR(128) COMMENT 'space used in slots dir' AFTER execute_node_architecture_id;

        # Add column execution_record.slot_size_start
        if exists (select * from information_schema.columns
                    where table_schema = 'assessment'
                      and table_name = 'execution_record'
                      and column_name = 'slot_size_end') then
            alter table assessment.execution_record drop column slot_size_end;
        end if;
        alter TABLE assessment.execution_record add column slot_size_end VARCHAR(128) COMMENT 'space used in slots dir' AFTER slot_size_start;

        # Add column metric_run.slot_size_start
        if exists (select * from information_schema.columns
                    where table_schema = 'metric'
                      and table_name = 'metric_run'
                      and column_name = 'slot_size_start') then
            alter table metric.metric_run drop column slot_size_start;
        end if;
        alter TABLE metric.metric_run add column slot_size_start VARCHAR(128) COMMENT 'space used in slots dir' AFTER execute_node_architecture_id;

        # Add column metric_run.slot_size_start
        if exists (select * from information_schema.columns
                    where table_schema = 'metric'
                      and table_name = 'metric_run'
                      and column_name = 'slot_size_end') then
            alter table metric.metric_run drop column slot_size_end;
        end if;
        alter TABLE metric.metric_run add column slot_size_end VARCHAR(128) COMMENT 'space used in slots dir' AFTER slot_size_start;

        # update database version number
        delete from assessment.database_version where database_version_no = script_version_no;
        insert into assessment.database_version (database_version_no, description) values (script_version_no, 'upgrade to v1.33.4');

        commit;
      end;
    end if;
END
$$
DELIMITER ;
