# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2018 Software Assurance Marketplace

# v1.20
use assessment;
drop PROCEDURE if exists upgrade_42;
DELIMITER $$
CREATE PROCEDURE upgrade_42 ()
  BEGIN
    declare script_version_no int;
    declare cur_db_version_no int;
    set script_version_no = 42;

    select max(database_version_no)
      into cur_db_version_no
      from assessment.database_version;

    if cur_db_version_no < script_version_no then
      begin

        # Updated versions of Parasoft JTest
        # 5.0.4
        update tool_shed.tool_version
           set tool_path = '/swamp/store/SCATools/parasoft/ps-jtest-9.5.13-6.tar',
               checksum  = '147e162f3b16e4e7bce288f381c1fb06479920bf5f36b77b53f7d421985f3f74da0d775bb9e2ff4536b54f9e491d5e284305e616f7dabb42bd7c7404d8960829'
         where tool_version_uuid = '18532f08-6441-11e4-a282-001a4a81450b';

        # Add New Tool Reek 2.2.1 for Ruby: 1 tool with 1 version. Language = Ruby; Platform = Scientific Linux 64-bit
        insert into tool_shed.tool
          (tool_uuid, tool_owner_uuid, name, description, tool_sharing_status, is_build_needed) values
          ('8157e489-1fbc-11e5-b6a7-001a4a81450b','80835e30-d527-11e2-8b8b-0800200c9a66','Reek','Code smell detector for Ruby. <a href="https://github.com/troessner/reek">https://github.com/troessner/reek</a>', 'PUBLIC',0);
        insert into tool_shed.tool_version
          (tool_version_uuid, tool_uuid, version_string, release_date, comment_public, comment_private,
          tool_path, tool_executable, tool_arguments, tool_directory, checksum)
        values
        ('bcbfc7d7-1fbc-11e5-b6a7-001a4a81450b','8157e489-1fbc-11e5-b6a7-001a4a81450b','2.2.1', now(), 'Reek 2.2.1 for Ruby', NULL,
        '/swamp/store/SCATools/reek/reek-2.2.1.tar.gz', 'reek', '', 'reek-2.2.1',
        'd0804a26ebfdb9052455e7cd3f408205b9d73357141dbb8cc0c73c9fc7ef83bf0de577491857d7fe9dffa1f75dce9da74caf193f741946b4f6efd2d2b6e8c484');
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('8157e489-1fbc-11e5-b6a7-001a4a81450b', 'bcbfc7d7-1fbc-11e5-b6a7-001a4a81450b',7);
        insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values
          ('8157e489-1fbc-11e5-b6a7-001a4a81450b', 'd95fcb5f-209d-11e3-9a3e-001a4a81450b'); # Scientific Linux 64-bit

        # update database version number
        insert into assessment.database_version (database_version_no, description) values (script_version_no, 'upgrade to v1.20');

        commit;
      end;
    end if;
END
$$
DELIMITER ;
