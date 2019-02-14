# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2019 Software Assurance Marketplace

use package_store;
# base install includes no packages

# Install package types
  # C/C++ platforms are user selectable, all others are not
  # All default to Ubuntu Linux (1088c3ce-20aa-11e3-9a3e-001a4a81450b)
  # except Android (6,11) which defaults to Android (48f9a9b0-976f-11e4-829b-001a4a81450b)
delete from package_store.package_type;
insert into package_store.package_type (package_type_id, name, package_type_enabled, platform_user_selectable, default_platform_uuid) values (1,  'C/C++',                    1, 1, '1088c3ce-20aa-11e3-9a3e-001a4a81450b'); # C/C++           - Ubuntu Linux
insert into package_store.package_type (package_type_id, name, package_type_enabled, platform_user_selectable, default_platform_uuid) values (2,  'Java 7 Source Code',       1, 0, '1088c3ce-20aa-11e3-9a3e-001a4a81450b'); # Java 7 Src Code - Ubuntu Linux
insert into package_store.package_type (package_type_id, name, package_type_enabled, platform_user_selectable, default_platform_uuid) values (3,  'Java 7 Bytecode',          1, 0, '1088c3ce-20aa-11e3-9a3e-001a4a81450b'); # Java 7 Bytecode - Ubuntu Linux
insert into package_store.package_type (package_type_id, name, package_type_enabled, platform_user_selectable, default_platform_uuid) values (4,  'Python2',                  1, 0, '1088c3ce-20aa-11e3-9a3e-001a4a81450b'); # Python2         - Ubuntu Linux
insert into package_store.package_type (package_type_id, name, package_type_enabled, platform_user_selectable, default_platform_uuid) values (5,  'Python3',                  1, 0, '1088c3ce-20aa-11e3-9a3e-001a4a81450b'); # Python3         - Ubuntu Linux
insert into package_store.package_type (package_type_id, name, package_type_enabled, platform_user_selectable, default_platform_uuid) values (6,  'Android Java Source Code', 1, 0, '48f9a9b0-976f-11e4-829b-001a4a81450b'); # Android JavaSrc - Android
insert into package_store.package_type (package_type_id, name, package_type_enabled, platform_user_selectable, default_platform_uuid) values (7,  'Ruby',                     1, 0, '1088c3ce-20aa-11e3-9a3e-001a4a81450b'); # Ruby            - Ubuntu Linux
insert into package_store.package_type (package_type_id, name, package_type_enabled, platform_user_selectable, default_platform_uuid) values (8,  'Ruby Sinatra',             1, 0, '1088c3ce-20aa-11e3-9a3e-001a4a81450b'); # Ruby Sinatra    - Ubuntu Linux
insert into package_store.package_type (package_type_id, name, package_type_enabled, platform_user_selectable, default_platform_uuid) values (9,  'Ruby on Rails',            1, 0, '1088c3ce-20aa-11e3-9a3e-001a4a81450b'); # Ruby on Rails   - Ubuntu Linux
insert into package_store.package_type (package_type_id, name, package_type_enabled, platform_user_selectable, default_platform_uuid) values (10, 'Ruby Padrino',             1, 0, '1088c3ce-20aa-11e3-9a3e-001a4a81450b'); # Ruby Padrino    - Ubuntu Linux
insert into package_store.package_type (package_type_id, name, package_type_enabled, platform_user_selectable, default_platform_uuid) values (11, 'Android .apk',             1, 0, '48f9a9b0-976f-11e4-829b-001a4a81450b'); # Android .apk    - Android
insert into package_store.package_type (package_type_id, name, package_type_enabled, platform_user_selectable, default_platform_uuid) values (12, 'Java 8 Source Code',       1, 0, '1088c3ce-20aa-11e3-9a3e-001a4a81450b'); # Java 8 Src Code - Ubuntu Linux
insert into package_store.package_type (package_type_id, name, package_type_enabled, platform_user_selectable, default_platform_uuid) values (13, 'Java 8 Bytecode',          1, 0, '1088c3ce-20aa-11e3-9a3e-001a4a81450b'); # Java 8 Bytecode - Ubuntu Linux
insert into package_store.package_type (package_type_id, name, package_type_enabled, platform_user_selectable, default_platform_uuid) values (14, 'Web Scripting',            1, 0, '1088c3ce-20aa-11e3-9a3e-001a4a81450b'); # Web Scripting   - Ubuntu Linux
insert into package_store.package_type (package_type_id, name, package_type_enabled, platform_user_selectable, default_platform_uuid) values (15, '.NET',                     1, 0, '1088c3ce-20aa-11e3-9a3e-001a4a81450b'); # .NET            - Ubuntu Linux
