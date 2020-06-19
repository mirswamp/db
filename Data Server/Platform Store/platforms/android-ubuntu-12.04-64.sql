# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2020 Software Assurance Marketplace

# Insert platform if it doesn't already exist
select count(1) into @platform_already_exists from platform_store.platform where platform_uuid = '48f9a9b0-976f-11e4-829b-001a4a81450b';
SET @s = IF(@platform_already_exists = 0,
            'INSERT INTO platform_store.platform (platform_uuid, platform_sharing_status, name) VALUES (''48f9a9b0-976f-11e4-829b-001a4a81450b'',''PUBLIC'',''Android'');',
            'DO SLEEP(0)');
PREPARE stmt1 FROM @s;
EXECUTE stmt1;

# Platform Version
delete from platform_store.platform_version where platform_version_uuid = '8f4878ec-976f-11e4-829b-001a4a81450b';
INSERT INTO platform_store.platform_version (platform_uuid, platform_version_uuid, version_no, version_string, platform_identifier) VALUES
  ('48f9a9b0-976f-11e4-829b-001a4a81450b','8f4878ec-976f-11e4-829b-001a4a81450b',1,'Android on Ubuntu 12.04 64-bit','android-ubuntu-12.04-64');
