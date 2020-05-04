# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2020 Software Assurance Marketplace

# v1.26
use assessment;
drop PROCEDURE if exists upgrade_48;
DELIMITER $$
CREATE PROCEDURE upgrade_48 ()
  BEGIN
    declare script_version_no int;
    declare cur_db_version_no int;
    set script_version_no = 48;

    select max(database_version_no)
      into cur_db_version_no
      from assessment.database_version;

    if cur_db_version_no < script_version_no then
      begin

        # Ensure all membership records have UUID
        update project.project_user set membership_uid = uuid() where membership_uid is null;

        # create table viewer_launch_time_history
        CREATE TABLE viewer_store.viewer_launch_time_history (
          viewer_launch_time_history_id INT  NOT NULL AUTO_INCREMENT                 COMMENT 'internal id',
          viewer_instance_uuid          VARCHAR(45)                                  COMMENT 'viewer instance uuid',
          event                         VARCHAR(25)                                  COMMENT 'event',
          description                   VARCHAR(100)                                 COMMENT 'description',
          create_user                   VARCHAR(25)                                  COMMENT 'db user that inserted record',
          create_date                   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
          update_user                   VARCHAR(25)                                  COMMENT 'db user that last updated record',
          update_date                   TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record last updated',
          PRIMARY KEY (viewer_launch_time_history_id)
         )COMMENT='viewer_launch_time_history';

        # Clang - new version 3.8.0: 1 version. Not using the specialized tool table Language = C/C++; Platform = All Platforms Except Android
          # tool_uuid: f212557c-3050-11e3-9a3e-001a4a81450b
          # tool_version_uuid: ea38477e-16cc-11e6-807f-001a4a81450b
          # tool_shed.tool_platform records already exist. They're for the tool, not specific to tool version.
        delete from tool_shed.tool_language where tool_version_uuid = 'ea38477e-16cc-11e6-807f-001a4a81450b';
        delete from tool_shed.tool_version  where tool_version_uuid = 'ea38477e-16cc-11e6-807f-001a4a81450b';
        insert into tool_shed.tool_version
          (tool_version_uuid, tool_uuid, version_string, release_date, comment_public, comment_private,
          tool_path, tool_executable, tool_arguments, tool_directory, checksum)
        values
        ('ea38477e-16cc-11e6-807f-001a4a81450b','f212557c-3050-11e3-9a3e-001a4a81450b','3.8', now(), 'Clang Static Analyzer 3.8', NULL,
        '/swamp/store/SCATools/clang/clang-sa-3.8.0.tar', 'bin/scan-build/scan-build', '', 'clang-sa-3.8.0',
        '7029bca05b89bdc7bc93354d4d52caf9d84ef3a78de5b66584617641e98a33a0d2dcac2c848fe870f92fe999847ed37a9fcd6cc52b113d160513d4fa1aaed27e');
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('f212557c-3050-11e3-9a3e-001a4a81450b', 'ea38477e-16cc-11e6-807f-001a4a81450b',1);

        # cppcheck - new version 1.73: 1 version. Not using the specialized tool table Language = C/C++; Platform = All Platforms Except Android
          # tool_uuid:         163e5d8c-156e-11e3-a239-001a4a81450b
          # tool_version_uuid: b9045569-16cc-11e6-807f-001a4a81450b
          # tool_shed.tool_platform records already exist. They're for the tool, not specific to tool version.
        delete from tool_shed.tool_language where tool_version_uuid = 'b9045569-16cc-11e6-807f-001a4a81450b';
        delete from tool_shed.tool_version  where tool_version_uuid = 'b9045569-16cc-11e6-807f-001a4a81450b';
        insert into tool_shed.tool_version
          (tool_version_uuid, tool_uuid, version_string, release_date, comment_public, comment_private,
          tool_path, tool_executable, tool_arguments, tool_directory, checksum)
        values
        ('b9045569-16cc-11e6-807f-001a4a81450b','163e5d8c-156e-11e3-a239-001a4a81450b','1.73', now(), 'Cppcheck 1.73', NULL,
        '/swamp/store/SCATools/cppcheck/cppcheck-1.73.tar', 'bin/cppcheck', '', 'cppcheck-1.73',
        '0f2ee90abd81d71ba04de350d97c4fbcbcf7e93b8866b7cc07f06055547629e743e37c5573917430cd4c8d985962425e4be2a09e1b5666d7d317bd3aa29aa8eb');
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('163e5d8c-156e-11e3-a239-001a4a81450b', 'b9045569-16cc-11e6-807f-001a4a81450b',1);

        # dawnscanner - updated version of 1.3.5: drop in replacement of existing version
        update tool_shed.tool_version
           set tool_path = '/swamp/store/SCATools/dawn/dawnscanner-1.3.5-3.tar',
               checksum = 'c54046542e08746bdcd251d7464461f989271aebecdc0d286ed4f5bcbfffb5cb96a8025f3403db6e3b83ceb0194d15970708b79aa603d136a028762455898a92'
          where tool_version_uuid = 'ca1608e1-4057-11e5-83f1-001a4a81450b';

        # Modifications for Scheduler
        # drop column if exist
        if exists (select * from information_schema.columns
                    where table_schema = 'assessment'
                      and table_name = 'scheduler_log'
                      and column_name = 'now_time') then
            alter table assessment.scheduler_log drop column now_time;
        end if;
        alter TABLE assessment.scheduler_log add column now_time DATETIME;
        delete from assessment.system_status where status_key = 'CURRENTLY_RUNNING_SCHEDULER';
        insert into assessment.system_status (status_key, value) values ('CURRENTLY_RUNNING_SCHEDULER', 'N');

        # update database version number
        delete from assessment.database_version where database_version_no = script_version_no;
        insert into assessment.database_version (database_version_no, description) values (script_version_no, 'upgrade to v1.26');

        commit;
      end;
    end if;
END
$$
DELIMITER ;
