#centos-6.7-32

# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2017 Software Assurance Marketplace

# Insert platform if it doesn't already exist
select count(1) into @platform_already_exists from platform_store.platform where platform_uuid = 'ef10a44c-7c3a-11e6-88bc-001a4a81450b';
SET @s = IF(@platform_already_exists = 0,
            'INSERT INTO platform_store.platform (platform_uuid, platform_sharing_status, name) VALUES (''ef10a44c-7c3a-11e6-88bc-001a4a81450b'',''PUBLIC'',''CentOS Linux 6 32-bit'');',
            'DO SLEEP(0)');
PREPARE stmt1 FROM @s;
EXECUTE stmt1;

# Platform Version
delete from platform_store.platform_version where platform_version_uuid = 'fa5ee864-7c3a-11e6-88bc-001a4a81450b';
INSERT INTO platform_store.platform_version (platform_uuid, platform_version_uuid, version_no, version_string, platform_path) VALUES
  ('ef10a44c-7c3a-11e6-88bc-001a4a81450b','fa5ee864-7c3a-11e6-88bc-001a4a81450b',1,'6.7 32-bit','centos-6.7-32');

# Make Platform user selectable for C/C++ package type
update package_store.package_type
   set platform_user_selectable = 1
 where package_type_id = 1;
