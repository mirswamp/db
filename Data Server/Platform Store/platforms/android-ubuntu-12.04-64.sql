#android.android-ubuntu-12.04-64

# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2017 Software Assurance Marketplace

# Insert platform if it doesn't already exist
select count(1) into @platform_already_exists from platform_store.platform where platform_uuid = '48f9a9b0-976f-11e4-829b-001a4a81450b';
SET @s = IF(@platform_already_exists = 0,
            'INSERT INTO platform_store.platform (platform_uuid, platform_sharing_status, name) VALUES (''48f9a9b0-976f-11e4-829b-001a4a81450b'',''PUBLIC'',''Android'');',
            'DO SLEEP(0)');
PREPARE stmt1 FROM @s;
EXECUTE stmt1;

# Platform Version
delete from platform_store.platform_version where platform_version_uuid = '8f4878ec-976f-11e4-829b-001a4a81450b';
INSERT INTO platform_store.platform_version (platform_uuid, platform_version_uuid, version_no, version_string, platform_path) VALUES
  ('48f9a9b0-976f-11e4-829b-001a4a81450b','8f4878ec-976f-11e4-829b-001a4a81450b',1,'Android on Ubuntu 12.04 64-bit','android-ubuntu-12.04-64');

# platform tool compatibilities
  # Most platforms work with all non-android tools
  # Android platform only works with android and java tools.
delete from tool_shed.tool_platform where platform_uuid = '48f9a9b0-976f-11e4-829b-001a4a81450b';
insert into tool_shed.tool_platform (platform_uuid, tool_uuid) VALUES
('48f9a9b0-976f-11e4-829b-001a4a81450b', '9289b560-8f8b-11e4-829b-001a4a81450b'), # Tool: Android lint
('48f9a9b0-976f-11e4-829b-001a4a81450b', '738b81f0-a828-11e5-865f-001a4a81450b'), # Tool: RevealDroid
('48f9a9b0-976f-11e4-829b-001a4a81450b', '163d56a7-156e-11e3-a239-001a4a81450b'), # Tool: Findbugs
('48f9a9b0-976f-11e4-829b-001a4a81450b', '163f2b01-156e-11e3-a239-001a4a81450b'), # Tool: PMD
('48f9a9b0-976f-11e4-829b-001a4a81450b', '6197a593-6440-11e4-a282-001a4a81450b'), # Tool: Parasoft Jtest
('48f9a9b0-976f-11e4-829b-001a4a81450b', '992A48A5-62EC-4EE9-8429-45BB94275A41'), # Tool: checkstyle
('48f9a9b0-976f-11e4-829b-001a4a81450b', '56872C2E-1D78-4DB0-B976-83ACF5424C52')  # Tool: error-prone
;

# Make Platform user selectable for C/C++ package type
update package_store.package_type
   set platform_user_selectable = 1
 where package_type_id = 1;
