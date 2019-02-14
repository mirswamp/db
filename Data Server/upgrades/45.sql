# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2019 Software Assurance Marketplace

# v1.23.1
use assessment;
drop PROCEDURE if exists upgrade_45;
DELIMITER $$
CREATE PROCEDURE upgrade_45 ()
  BEGIN
    declare script_version_no int;
    declare cur_db_version_no int;
    set script_version_no = 45;

    select max(database_version_no)
      into cur_db_version_no
      from assessment.database_version;

    if cur_db_version_no < script_version_no then
      begin

        # Android .apk Package Type
        insert into package_store.package_type (package_type_id, name) values (11,  'Android .apk');

        # New Tool revealdroid-2015.11.05: 1 tool with 1 version. Language = Android .apk; Platform = All Platforms?
          # tool_uuid: 738b81f0-a828-11e5-865f-001a4a81450b
          # tool_version_uuid: 8666e176-a828-11e5-865f-001a4a81450b
        insert into tool_shed.tool
          (tool_uuid, tool_owner_uuid, name, description, tool_sharing_status, is_build_needed) values
          ('738b81f0-a828-11e5-865f-001a4a81450b','80835e30-d527-11e2-8b8b-0800200c9a66','RevealDroid','RevealDroid finds malware in Android applications.', 'PUBLIC',0);
        insert into tool_shed.tool_version
          (tool_version_uuid, tool_uuid, version_string, release_date, comment_public, comment_private,
          tool_path, tool_executable, tool_arguments, tool_directory, checksum)
        values
        ('8666e176-a828-11e5-865f-001a4a81450b','738b81f0-a828-11e5-865f-001a4a81450b','2015.11.05', now(), 'RevealDroid 2015.11.05', NULL,
        '/swamp/store/SCATools/revealdroid/revealdroid-2015.11.05.tar', null, null, null,
        '46df3fe4e7b5865409ff8732aea15bb0f5af968f3e605ded8c6706ac16b6860b4f21f69d3d908add7b94927e0bd12210d9b6a23030808bf7cafe22081b7197bc');
        # insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('738b81f0-a828-11e5-865f-001a4a81450b', '8666e176-a828-11e5-865f-001a4a81450b',1);  # C/C++
        # insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('738b81f0-a828-11e5-865f-001a4a81450b', '8666e176-a828-11e5-865f-001a4a81450b',2);  # Java Source Code
        # insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('738b81f0-a828-11e5-865f-001a4a81450b', '8666e176-a828-11e5-865f-001a4a81450b',3);  # Java Bytecode
        # insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('738b81f0-a828-11e5-865f-001a4a81450b', '8666e176-a828-11e5-865f-001a4a81450b',4);  # Python2
        # insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('738b81f0-a828-11e5-865f-001a4a81450b', '8666e176-a828-11e5-865f-001a4a81450b',5);  # Python3
        # insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('738b81f0-a828-11e5-865f-001a4a81450b', '8666e176-a828-11e5-865f-001a4a81450b',6);  # Android Java Source Code
        # insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('738b81f0-a828-11e5-865f-001a4a81450b', '8666e176-a828-11e5-865f-001a4a81450b',7);  # Ruby
        # insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('738b81f0-a828-11e5-865f-001a4a81450b', '8666e176-a828-11e5-865f-001a4a81450b',8);  # Ruby Sinatra
        # insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('738b81f0-a828-11e5-865f-001a4a81450b', '8666e176-a828-11e5-865f-001a4a81450b',9);  # Ruby on Rails
        # insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('738b81f0-a828-11e5-865f-001a4a81450b', '8666e176-a828-11e5-865f-001a4a81450b',10); # Ruby Padrino
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('738b81f0-a828-11e5-865f-001a4a81450b', '8666e176-a828-11e5-865f-001a4a81450b',11); # Android .apk
        insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('738b81f0-a828-11e5-865f-001a4a81450b', '48f9a9b0-976f-11e4-829b-001a4a81450b'); # Android
        # insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('738b81f0-a828-11e5-865f-001a4a81450b', 'ee2c1193-209b-11e3-9a3e-001a4a81450b'); # Debian Linux
        # insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('738b81f0-a828-11e5-865f-001a4a81450b', '8a51ecea-209d-11e3-9a3e-001a4a81450b'); # Fedora Linux
        # insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('738b81f0-a828-11e5-865f-001a4a81450b', 'd531f0f0-f273-11e3-8775-001a4a81450b'); # Red Hat Enterprise Linux 32-bit
        # insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('738b81f0-a828-11e5-865f-001a4a81450b', 'fc55810b-09d7-11e3-a239-001a4a81450b'); # Red Hat Enterprise Linux 64-bit
        # insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('738b81f0-a828-11e5-865f-001a4a81450b', 'a4f024eb-f317-11e3-8775-001a4a81450b'); # Scientific Linux 32-bit
        # insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('738b81f0-a828-11e5-865f-001a4a81450b', 'd95fcb5f-209d-11e3-9a3e-001a4a81450b'); # Scientific Linux 64-bit
        # insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('738b81f0-a828-11e5-865f-001a4a81450b', '1088c3ce-20aa-11e3-9a3e-001a4a81450b'); # Ubuntu Linux

        # update database version number
        insert into assessment.database_version (database_version_no, description) values (script_version_no, 'upgrade to v1.23.1');

        commit;
      end;
    end if;
END
$$
DELIMITER ;
