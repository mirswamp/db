# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2016 Software Assurance Marketplace

use project;

CREATE TABLE project.user (
  user_id int(11) unsigned NOT NULL AUTO_INCREMENT,
  user_uid varchar(36) DEFAULT NULL,
  username varchar(255) DEFAULT NULL,
  password varchar(255) DEFAULT NULL,
  first_name varchar(255) DEFAULT NULL,
  last_name varchar(255) DEFAULT NULL,
  preferred_name varchar(255) DEFAULT NULL,
  email varchar(255) DEFAULT NULL,
  address varchar(255) DEFAULT NULL,
  phone varchar(255) DEFAULT NULL,
  affiliation varchar(255) DEFAULT NULL,
  admin tinyint(1) DEFAULT NULL,
  enabled_flag tinyint(1) DEFAULT NULL,
  create_date datetime DEFAULT NULL,
  update_date datetime DEFAULT NULL,
  delete_date datetime DEFAULT NULL,
  PRIMARY KEY (user_id)
);

# Remove ssh access
delete from project.permission where permission_code = 'ssh-access';

# Remove Code Dx
delete from viewer_store.viewer_version where viewer_uuid = '4221533e-865a-11e3-88bb-001a4a81450b';
delete from viewer_store.viewer where viewer_uuid = '4221533e-865a-11e3-88bb-001a4a81450b';

# Remove ThreadFix
delete from viewer_store.viewer_version where viewer_uuid = 'a0e1d0fb-bfb2-11e5-bf72-001a4a814413';
delete from viewer_store.viewer where viewer_uuid = 'a0e1d0fb-bfb2-11e5-bf72-001a4a814413';

# Remove Android Lint
delete from tool_shed.tool_platform where tool_uuid = '9289b560-8f8b-11e4-829b-001a4a81450b';
delete from tool_shed.tool_language where tool_uuid = '9289b560-8f8b-11e4-829b-001a4a81450b';
delete from tool_shed.specialized_tool_version where tool_uuid = '9289b560-8f8b-11e4-829b-001a4a81450b';
delete from tool_shed.tool_version where tool_uuid = '9289b560-8f8b-11e4-829b-001a4a81450b';
delete from tool_shed.tool where tool_uuid = '9289b560-8f8b-11e4-829b-001a4a81450b';

# Remove RevealDroid
delete from tool_shed.tool_platform where tool_uuid = '738b81f0-a828-11e5-865f-001a4a81450b';
delete from tool_shed.tool_language where tool_uuid = '738b81f0-a828-11e5-865f-001a4a81450b';
delete from tool_shed.specialized_tool_version where tool_uuid = '738b81f0-a828-11e5-865f-001a4a81450b';
delete from tool_shed.tool_version where tool_uuid = '738b81f0-a828-11e5-865f-001a4a81450b';
delete from tool_shed.tool where tool_uuid = '738b81f0-a828-11e5-865f-001a4a81450b';

# Disable metric runs
ALTER EVENT metric.initiate_metric_runs DISABLE; # disables M-Runs

# Set platform not user selectable
  # By default, swamp in a box only comes with one platform. So, the platform isnt user selectable
  # If additional platforms are installed, the platform install script changes this flag.
update package_store.package_type set platform_user_selectable = 0;

# Set Default platforms for package type
  # All default to Ubuntu Linux (1088c3ce-20aa-11e3-9a3e-001a4a81450b)
  # except Android (6,11) which defaults to Android (48f9a9b0-976f-11e4-829b-001a4a81450b)
update package_store.package_type set default_platform_uuid = '1088c3ce-20aa-11e3-9a3e-001a4a81450b' where package_type_id = 1; # C/C++           - Ubuntu Linux
update package_store.package_type set default_platform_uuid = '1088c3ce-20aa-11e3-9a3e-001a4a81450b' where package_type_id = 2; # Java 7 Src Code - Ubuntu Linux
update package_store.package_type set default_platform_uuid = '1088c3ce-20aa-11e3-9a3e-001a4a81450b' where package_type_id = 3; # Java 7 Bytecode - Ubuntu Linux
update package_store.package_type set default_platform_uuid = '1088c3ce-20aa-11e3-9a3e-001a4a81450b' where package_type_id = 4; # Python2         - Ubuntu Linux
update package_store.package_type set default_platform_uuid = '1088c3ce-20aa-11e3-9a3e-001a4a81450b' where package_type_id = 5; # Python3         - Ubuntu Linux
update package_store.package_type set default_platform_uuid = '48f9a9b0-976f-11e4-829b-001a4a81450b' where package_type_id = 6; # Android JavaSrc - Android
update package_store.package_type set default_platform_uuid = '1088c3ce-20aa-11e3-9a3e-001a4a81450b' where package_type_id = 7; # Ruby            - Ubuntu Linux
update package_store.package_type set default_platform_uuid = '1088c3ce-20aa-11e3-9a3e-001a4a81450b' where package_type_id = 8; # Ruby Sinatra    - Ubuntu Linux
update package_store.package_type set default_platform_uuid = '1088c3ce-20aa-11e3-9a3e-001a4a81450b' where package_type_id = 9; # Ruby on Rails   - Ubuntu Linux
update package_store.package_type set default_platform_uuid = '1088c3ce-20aa-11e3-9a3e-001a4a81450b' where package_type_id = 10;# Ruby Padrino    - Ubuntu Linux
update package_store.package_type set default_platform_uuid = '48f9a9b0-976f-11e4-829b-001a4a81450b' where package_type_id = 11;# Android .apk    - Android
update package_store.package_type set default_platform_uuid = '1088c3ce-20aa-11e3-9a3e-001a4a81450b' where package_type_id = 12;# Java 8 Src Code - Ubuntu Linux
update package_store.package_type set default_platform_uuid = '1088c3ce-20aa-11e3-9a3e-001a4a81450b' where package_type_id = 13;# Java 8 Bytecode - Ubuntu Linux

# Disable Android Pkg Type
update package_store.package_type set package_type_enabled = 0 where package_type_id in (6,11);

# setup system_type
insert into assessment.system_setting (system_setting_code, system_setting_value) values ('SYSTEM_TYPE', 'SWAMP_IN_A_BOX');

