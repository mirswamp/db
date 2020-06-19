# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2020 Software Assurance Marketplace

# v1.35
use assessment;
drop PROCEDURE if exists upgrade_63;
DELIMITER $$
CREATE PROCEDURE upgrade_63 ()
  BEGIN
    declare script_version_no int;
    declare cur_db_version_no int;
    declare system_type varchar(200);
    set script_version_no = 63;

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

        # rename column platform_path to platform_identifier
        if exists (select * from information_schema.columns
                    where table_schema = 'platform_store'
                      and table_name = 'platform_version'
                      and column_name = 'platform_path') then
          ALTER TABLE platform_store.platform_version CHANGE COLUMN platform_path platform_identifier VARCHAR(200) COMMENT 'pointer to platform';
        end if;

        # update database version number
        delete from assessment.database_version where database_version_no = script_version_no;
        insert into assessment.database_version (database_version_no, description) values (script_version_no, 'upgrade to v1.35');

        commit;
      end;
    end if;
END
$$
DELIMITER ;