# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2020 Software Assurance Marketplace

# Insert platform if it doesn't already exist
select count(1) into @platform_already_exists from platform_store.platform where platform_uuid = 'ee2c1193-209b-11e3-9a3e-001a4a81450b';
SET @s = IF(@platform_already_exists = 0,
            'INSERT INTO platform_store.platform (platform_uuid, platform_sharing_status, name) VALUES (''ee2c1193-209b-11e3-9a3e-001a4a81450b'',''PUBLIC'',''Debian'');',
            'DO SLEEP(0)');
PREPARE stmt1 FROM @s;
EXECUTE stmt1;

# Platform Version
delete from platform_store.platform_version where platform_version_uuid = 'eaa6cf77-7c3b-11e6-88bc-001a4a81450b';
INSERT INTO platform_store.platform_version (platform_uuid, platform_version_uuid, version_no, version_string, platform_identifier) VALUES
  ('ee2c1193-209b-11e3-9a3e-001a4a81450b','eaa6cf77-7c3b-11e6-88bc-001a4a81450b',1,'7 64-bit','debian-7.minorversion-64');
