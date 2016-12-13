#fedora-18-64

# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2016 Software Assurance Marketplace

# Insert platform if it doesn't already exist
select count(1) into @platform_already_exists from platform_store.platform where platform_uuid = '8a51ecea-209d-11e3-9a3e-001a4a81450b';
SET @s = IF(@platform_already_exists = 0,
            'INSERT INTO platform_store.platform (platform_uuid, platform_sharing_status, name) VALUES (''8a51ecea-209d-11e3-9a3e-001a4a81450b'',''PUBLIC'',''Fedora Linux'');',
            'DO SLEEP(0)');
PREPARE stmt1 FROM @s;
EXECUTE stmt1;

# Platform Version
delete from platform_store.platform_version where platform_version_uuid = 'a9cfe21f-209d-11e3-9a3e-001a4a81450b';
INSERT INTO platform_store.platform_version (platform_uuid, platform_version_uuid, version_no, version_string, platform_path) VALUES
  ('8a51ecea-209d-11e3-9a3e-001a4a81450b','a9cfe21f-209d-11e3-9a3e-001a4a81450b',1,'18 64-bit','fedora-18-64');

# platform tool compatibilities
  # Most platforms work with all non-android tools
  # Android platform only works with android and java tools.
delete from tool_shed.tool_platform where platform_uuid = '8a51ecea-209d-11e3-9a3e-001a4a81450b';
insert into tool_shed.tool_platform (platform_uuid, tool_uuid)
select '8a51ecea-209d-11e3-9a3e-001a4a81450b', t.tool_uuid
  from tool_shed.tool t
 where t.tool_uuid != '9289b560-8f8b-11e4-829b-001a4a81450b'     # Tool: Android lint
   and t.tool_uuid != '738b81f0-a828-11e5-865f-001a4a81450b'     # Tool: RevealDroid
   ;

# Make Platform user selectable for C/C++ package type
update package_store.package_type
   set platform_user_selectable = 1
 where package_type_id = 1;
