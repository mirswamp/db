# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2018 Software Assurance Marketplace

# v1.28.1
use assessment;
drop PROCEDURE if exists upgrade_52;
DELIMITER $$
CREATE PROCEDURE upgrade_52 ()
  BEGIN
    declare script_version_no int;
    declare cur_db_version_no int;
    declare system_type varchar(200);
    set script_version_no = 52;

    select max(database_version_no)
      into cur_db_version_no
      from assessment.database_version;

    if cur_db_version_no < script_version_no then
      begin

        # setup system_type
        if not exists (select * from assessment.system_setting where system_setting_code = 'SYSTEM_TYPE') then
            insert into assessment.system_setting (system_setting_code, system_setting_value) values ('SYSTEM_TYPE', 'SWAMP_IN_A_BOX');
        end if;

        # system_type
        select system_setting_value
          into system_type
          from assessment.system_setting
         where system_setting_code = 'SYSTEM_TYPE';

        if (system_type = 'SWAMP_IN_A_BOX') then
          # only platform should be Ubuntu Linux 16.04 LTS 64-bit Xenial Xerus
          delete from platform_store.platform_version;
          delete from platform_store.platform;
          INSERT INTO platform_store.platform (platform_uuid, platform_sharing_status, name) VALUES ('1088c3ce-20aa-11e3-9a3e-001a4a81450b','PUBLIC','Ubuntu Linux');
          INSERT INTO platform_store.platform_version (platform_uuid, platform_version_uuid, version_no, version_string, platform_path) VALUES
                 ('1088c3ce-20aa-11e3-9a3e-001a4a81450b','03b18efe-7c41-11e6-88bc-001a4a81450b',4,'16.04 LTS 64-bit Xenial Xerus',     'ubuntu-16.04-64');

          # Set Default platforms for package type
            # All default to Ubuntu Linux (1088c3ce-20aa-11e3-9a3e-001a4a81450b)
            # except Android (6,11) which defaults to Android (48f9a9b0-976f-11e4-829b-001a4a81450b)
          update package_store.package_type set default_platform_uuid = '1088c3ce-20aa-11e3-9a3e-001a4a81450b';
          update package_store.package_type set default_platform_uuid = '48f9a9b0-976f-11e4-829b-001a4a81450b' where package_type_id in (6,11);

          # Make sure Android is disabled
          update package_store.package_type set package_type_enabled = 0 where package_type_id in (6,11);

          # Make all package types not user selectable
          update package_store.package_type set platform_user_selectable = 0;

          # convert applicable existing assessments to use default platform.
          update assessment.assessment_run
             set platform_uuid = null,
                 platform_version_uuid = null;
        end if;

        # update database version number
        delete from assessment.database_version where database_version_no = script_version_no;
        insert into assessment.database_version (database_version_no, description) values (script_version_no, 'upgrade to v1.28.1');

        commit;
      end;
    end if;
END
$$
DELIMITER ;
