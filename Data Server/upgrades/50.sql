# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2020 Software Assurance Marketplace

# v1.27.1
use assessment;
drop PROCEDURE if exists upgrade_50;
DELIMITER $$
CREATE PROCEDURE upgrade_50 ()
  BEGIN
    declare script_version_no int;
    declare cur_db_version_no int;
    set script_version_no = 50;

    select max(database_version_no)
      into cur_db_version_no
      from assessment.database_version;

    if cur_db_version_no < script_version_no then
      begin

        # Add index
        if exists (select * from information_schema.statistics
                    where table_schema = 'assessment'
                      and table_name = 'execution_record'
                      and index_name = 'idx_execution_record_ar_uuid') then
            ALTER TABLE assessment.execution_record DROP INDEX idx_execution_record_ar_uuid;
        end if;
        ALTER TABLE assessment.execution_record ADD INDEX idx_execution_record_ar_uuid (assessment_run_uuid ASC);

       # Add columns to package_type table
        if exists (select * from information_schema.columns
                    where table_schema = 'package_store'
                      and table_name = 'package_type'
                      and column_name = 'package_type_enabled') then
            alter table package_store.package_type drop column package_type_enabled;
        end if;
        if exists (select * from information_schema.columns
                    where table_schema = 'package_store'
                      and table_name = 'package_type'
                      and column_name = 'platform_user_selectable') then
            alter table package_store.package_type drop column platform_user_selectable;
        end if;
        if exists (select * from information_schema.columns
                    where table_schema = 'package_store'
                      and table_name = 'package_type'
                      and column_name = 'default_platform_uuid') then
            alter table package_store.package_type drop column default_platform_uuid;
        end if;
        if exists (select * from information_schema.columns
                    where table_schema = 'package_store'
                      and table_name = 'package_type'
                      and column_name = 'default_platform_version_uuid') then
            alter table package_store.package_type drop column default_platform_version_uuid;
        end if;
        alter TABLE package_store.package_type add column package_type_enabled tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Is enabled: 0=false 1=true' AFTER name;
        alter TABLE package_store.package_type add column platform_user_selectable tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Is user selectable: 0=false 1=true' AFTER package_type_enabled;
        alter TABLE package_store.package_type add column default_platform_uuid VARCHAR(45) COMMENT 'default platform' AFTER platform_user_selectable;
        alter TABLE package_store.package_type add column default_platform_version_uuid VARCHAR(45) COMMENT 'default platform version' AFTER default_platform_uuid;

        # Set Up Package Type
        delete from assessment.system_setting where system_setting_code = 'METRIC_RUN_PLATFORM_UUID';
        delete from assessment.system_setting where system_setting_code = 'DEFAULT_PLATFORM_FOR_PKG_TYPE';
        update package_store.package_type set default_platform_uuid = 'fc55810b-09d7-11e3-a239-001a4a81450b' where package_type_id = 1; # C/C++           - Red Hat Enterprise Linux 64-bit
        update package_store.package_type set default_platform_uuid = 'fc55810b-09d7-11e3-a239-001a4a81450b' where package_type_id = 2; # Java 7 Src Code - Red Hat Enterprise Linux 64-bit
        update package_store.package_type set default_platform_uuid = 'fc55810b-09d7-11e3-a239-001a4a81450b' where package_type_id = 3; # Java 7 Bytecode - Red Hat Enterprise Linux 64-bit
        update package_store.package_type set default_platform_uuid = 'd95fcb5f-209d-11e3-9a3e-001a4a81450b' where package_type_id = 4; # Python2         - Scientific Linux 64-bit
        update package_store.package_type set default_platform_uuid = 'd95fcb5f-209d-11e3-9a3e-001a4a81450b' where package_type_id = 5; # Python3         - Scientific Linux 64-bit
        update package_store.package_type set default_platform_uuid = '48f9a9b0-976f-11e4-829b-001a4a81450b' where package_type_id = 6; # Android JavaSrc - Android
        update package_store.package_type set default_platform_uuid = 'd95fcb5f-209d-11e3-9a3e-001a4a81450b' where package_type_id = 7; # Ruby            - Scientific Linux 64-bit
        update package_store.package_type set default_platform_uuid = 'd95fcb5f-209d-11e3-9a3e-001a4a81450b' where package_type_id = 8; # Ruby Sinatra    - Scientific Linux 64-bit
        update package_store.package_type set default_platform_uuid = 'd95fcb5f-209d-11e3-9a3e-001a4a81450b' where package_type_id = 9; # Ruby on Rails   - Scientific Linux 64-bit
        update package_store.package_type set default_platform_uuid = 'd95fcb5f-209d-11e3-9a3e-001a4a81450b' where package_type_id = 10;# Ruby Padrino    - Scientific Linux 64-bit
        update package_store.package_type set default_platform_uuid = '48f9a9b0-976f-11e4-829b-001a4a81450b' where package_type_id = 11;# Android .apk    - Android
        update package_store.package_type set default_platform_uuid = 'fc55810b-09d7-11e3-a239-001a4a81450b' where package_type_id = 12;# Java 8 Src Code - Red Hat Enterprise Linux 64-bit
        update package_store.package_type set default_platform_uuid = 'fc55810b-09d7-11e3-a239-001a4a81450b' where package_type_id = 13;# Java 8 Bytecode - Red Hat Enterprise Linux 64-bit

        update package_store.package_type set platform_user_selectable = 1 where package_type_id = 1; # C/C++ platforms are user selectable
        update package_store.package_type set platform_user_selectable = 0 where package_type_id in (2,3,4,5,6,7,8,9,10,11,12,13); # All others are not user selectable

        # update database version number
        delete from assessment.database_version where database_version_no = script_version_no;
        insert into assessment.database_version (database_version_no, description) values (script_version_no, 'upgrade to v1.27.1');

        commit;
      end;
    end if;
END
$$
DELIMITER ;
