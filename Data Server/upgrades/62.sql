# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2020 Software Assurance Marketplace

# v1.34.6
use assessment;
drop PROCEDURE if exists upgrade_62;
DELIMITER $$
CREATE PROCEDURE upgrade_62 ()
  BEGIN
    declare script_version_no int;
    declare cur_db_version_no int;
    declare system_type varchar(200);
    set script_version_no = 62;

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

        DROP TABLE IF EXISTS project.class_auto_approve_permission;
        CREATE TABLE project.class_auto_approve_permission (
          class_auto_approve_permission_uuid  VARCHAR(45) NOT NULL                         COMMENT 'uuid',
          class_code                          VARCHAR(45) NOT NULL                         COMMENT 'class id',
          permission_code                     VARCHAR(100) NOT NULL                        COMMENT 'permission being granted',
          user_info                           VARCHAR (5000)                               COMMENT 'meta info for permission',
          create_user                         VARCHAR(25)                                  COMMENT 'db user that inserted record',
          create_date                         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
          update_user                         VARCHAR(25)                                  COMMENT 'db user that last updated record',
          update_date                         TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record last updated',
          PRIMARY KEY (class_auto_approve_permission_uuid)
         ) COMMENT='class permission auto approve';

        # pdf version of parasoft ctest eula
        update project.policy
           set policy = '<div style=\"white-space: pre-wrap;\">\r\n\r\nSOFTWARE END USER LICENCE TERMS\r\n\r\n<a href="https://www.swampinabox.org/doc/eula_parasoft_ctest.pdf" target="_blank">https://www.swampinabox.org/doc/eula_parasoft_ctest.pdf</a></div>'
         where policy_code = 'parasoft-user-c-test-policy';

        # pdf version of parasoft jtest eula
        update project.policy
           set policy = '<div style=\"white-space: pre-wrap;\">\r\n\r\nSOFTWARE END USER LICENCE TERMS\r\n\r\n<a href="https://www.swampinabox.org/doc/eula_parasoft_jtest.pdf" target="_blank">https://www.swampinabox.org/doc/eula_parasoft_jtest.pdf</a></div>'
         where policy_code = 'parasoft-user-j-test-policy';

        # Add external_url_type to package table
        if exists (select * from information_schema.columns
                    where table_schema = 'package_store'
                      and table_name = 'package'
                      and column_name = 'external_url_type') then
            alter table package_store.package drop column external_url_type;
        end if;
        alter TABLE package_store.package add column external_url_type VARCHAR(45) COMMENT 'external url type' AFTER external_url;

        # populate new external_url_type field
        update package_store.package
           set external_url_type = case when external_url like '%.tar%' then 'download'
                                        when external_url like '%.zip' then 'download'
                                        else 'git' end
         where external_url is not null and external_url != '';

        # update database version number
        delete from assessment.database_version where database_version_no = script_version_no;
        insert into assessment.database_version (database_version_no, description) values (script_version_no, 'upgrade to v1.34.6');

        commit;
      end;
    end if;
END
$$
DELIMITER ;
