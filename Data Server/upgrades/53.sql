# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2017 Software Assurance Marketplace

# v1.29
use assessment;
drop PROCEDURE if exists upgrade_53;
DELIMITER $$
CREATE PROCEDURE upgrade_53 ()
  BEGIN
    declare script_version_no int;
    declare cur_db_version_no int;
    declare system_type varchar(200);
    set script_version_no = 53;

    select max(database_version_no)
      into cur_db_version_no
      from assessment.database_version;

    if cur_db_version_no < script_version_no then
      begin

        # system_type
        if not exists (select * from assessment.system_setting where system_setting_code = 'SYSTEM_TYPE') then
            insert into assessment.system_setting (system_setting_code, system_setting_value) values ('SYSTEM_TYPE', 'SWAMP_IN_A_BOX');
        end if;
        select system_setting_value
          into system_type
          from assessment.system_setting
         where system_setting_code = 'SYSTEM_TYPE';

       # Add column to package table
        if exists (select * from information_schema.columns
                    where table_schema = 'package_store'
                      and table_name = 'package'
                      and column_name = 'package_language') then
            alter table package_store.package drop column package_language;
        end if;
        alter TABLE package_store.package add column package_language VARCHAR(200) NULL DEFAULT NULL COMMENT 'languages package contains' AFTER package_type_id;

       # Add column to table
        if exists (select * from information_schema.columns
                    where table_schema = 'package_store'
                      and table_name = 'package_version'
                      and column_name = 'checkout_argument') then
            alter table package_store.package_version drop column checkout_argument;
        end if;
        alter TABLE package_store.package_version add column checkout_argument VARCHAR(100) NULL DEFAULT NULL COMMENT 'git checkout argument' AFTER android_maven_plugin;

       # Add column to table
        if exists (select * from information_schema.columns
                    where table_schema = 'assessment'
                      and table_name = 'execution_record'
                      and column_name = 'vm_image') then
            alter table assessment.execution_record drop column vm_image;
        end if;
        alter TABLE assessment.execution_record add column vm_image VARCHAR(100) COMMENT 'vm image' AFTER vm_ip_address;

       # Add column to table
        if exists (select * from information_schema.columns
                    where table_schema = 'assessment'
                      and table_name = 'execution_record'
                      and column_name = 'tool_filename') then
            alter table assessment.execution_record drop column tool_filename;
        end if;
        alter TABLE assessment.execution_record add column tool_filename VARCHAR(100) COMMENT 'tool filename' AFTER vm_image;

       # Add column to table
        if exists (select * from information_schema.columns
                    where table_schema = 'metric'
                      and table_name = 'metric_run'
                      and column_name = 'vm_image') then
            alter table metric.metric_run drop column vm_image;
        end if;
        alter TABLE metric.metric_run add column vm_image VARCHAR(100) COMMENT 'vm image' AFTER vm_ip_address;

       # Add column to table
        if exists (select * from information_schema.columns
                    where table_schema = 'metric'
                      and table_name = 'metric_run'
                      and column_name = 'tool_filename') then
            alter table metric.metric_run drop column tool_filename;
        end if;
        alter TABLE metric.metric_run add column tool_filename VARCHAR(100) COMMENT 'tool filename' AFTER vm_image;

        # Alter column
          # increase status size from 25 to 100
          # change default from SCHEDULED to WAITING TO START
        if exists (select * from information_schema.columns
                    where table_schema = 'assessment'
                      and table_name = 'execution_record'
                      and column_name = 'status') then
            alter table assessment.execution_record change status status VARCHAR(100) NOT NULL DEFAULT 'WAITING TO START' COMMENT 'status of execution record';
        end if;

        # Alter column
          # increase status size from 25 to 100
          # change default from SCHEDULED to WAITING TO START
        if exists (select * from information_schema.columns
                    where table_schema = 'metric'
                      and table_name = 'metric_run'
                      and column_name = 'status') then
            alter table metric.metric_run change status status VARCHAR(100) NOT NULL DEFAULT 'WAITING TO START' COMMENT 'status of execution record';
        end if;

        # New Package Type
        delete from metric.metric_tool_language where package_type_id = 14;
        delete from package_store.package_type where package_type_id = 14;
        insert into package_store.package_type (package_type_id, name, package_type_enabled, platform_user_selectable, default_platform_uuid, default_platform_version_uuid)
          values (14,  'Web Scripting', 1, 0, '1088c3ce-20aa-11e3-9a3e-001a4a81450b', null);
        insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) select metric_tool_uuid, 14 from metric.metric_tool;

        # New Tool ESLint: 1 tool with 1 version. Language = Web Scripting; Platform = All Platforms
          # tool_uuid: 3309c1e0-b741-11e6-bf70-001a4a81450b
          # tool_version_uuid: 68b0cb72-b741-11e6-bf70-001a4a81450b
        delete from tool_shed.tool_viewer_incompatibility where tool_uuid = '3309c1e0-b741-11e6-bf70-001a4a81450b';
        delete from tool_shed.tool_platform where tool_uuid = '3309c1e0-b741-11e6-bf70-001a4a81450b';
        delete from tool_shed.tool_language where tool_uuid = '3309c1e0-b741-11e6-bf70-001a4a81450b';
        delete from tool_shed.tool_version  where tool_uuid = '3309c1e0-b741-11e6-bf70-001a4a81450b';
        delete from tool_shed.tool          where tool_uuid = '3309c1e0-b741-11e6-bf70-001a4a81450b';
        insert into tool_shed.tool
          (tool_uuid, tool_owner_uuid, name, description, tool_sharing_status, is_build_needed) values
          ('3309c1e0-b741-11e6-bf70-001a4a81450b','80835e30-d527-11e2-8b8b-0800200c9a66','ESLint','Pluggable JavaScript linter. <a href="http://eslint.org/">http://eslint.org/</a>', 'PUBLIC',0);
        insert into tool_shed.tool_version
          (tool_version_uuid, tool_uuid, version_string, release_date, comment_public, comment_private,
          tool_path, tool_executable, tool_arguments, tool_directory, checksum)
        values
        ('68b0cb72-b741-11e6-bf70-001a4a81450b','3309c1e0-b741-11e6-bf70-001a4a81450b','3.10.1', now(), NULL, NULL,
        '/swamp/store/SCATools/eslint-3.10.1.tar.gz', null, null, null,
        'a2f1d434e35220bf1ab86e8b494cd8b2bb1e4cb13277016be710341c2b3495619dd78f9ac1f0e18b11f3f569346a8bea266f557164e8398a2b5cfcdbe3ce3bd7');
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('3309c1e0-b741-11e6-bf70-001a4a81450b', '68b0cb72-b741-11e6-bf70-001a4a81450b',14); # Web Scripting
        insert into tool_shed.tool_platform (tool_uuid, platform_uuid) select '3309c1e0-b741-11e6-bf70-001a4a81450b', platform_uuid from platform_store.platform; # Compatible with all platforms
        insert into tool_shed.tool_viewer_incompatibility (tool_uuid, viewer_uuid) values ('3309c1e0-b741-11e6-bf70-001a4a81450b', 'a0e1d0fb-bfb2-11e5-bf72-001a4a814413'); # incompatible with ThreadFix.

        # New Tool JSHint: 1 tool with 1 version. Language = Web Scripting; Platform = All Platforms
          # tool_uuid: 39001e1f-b741-11e6-bf70-001a4a81450b
          # tool_version_uuid: 6ea71506-b741-11e6-bf70-001a4a81450b
        delete from tool_shed.tool_viewer_incompatibility where tool_uuid = '39001e1f-b741-11e6-bf70-001a4a81450b';
        delete from tool_shed.tool_platform where tool_uuid = '39001e1f-b741-11e6-bf70-001a4a81450b';
        delete from tool_shed.tool_language where tool_uuid = '39001e1f-b741-11e6-bf70-001a4a81450b';
        delete from tool_shed.tool_version  where tool_uuid = '39001e1f-b741-11e6-bf70-001a4a81450b';
        delete from tool_shed.tool          where tool_uuid = '39001e1f-b741-11e6-bf70-001a4a81450b';
        insert into tool_shed.tool
          (tool_uuid, tool_owner_uuid, name, description, tool_sharing_status, is_build_needed) values
          ('39001e1f-b741-11e6-bf70-001a4a81450b','80835e30-d527-11e2-8b8b-0800200c9a66','JSHint','A JavaScript code quality tool. <a href="http://jshint.com/">http://jshint.com/</a>', 'PUBLIC',0);
        insert into tool_shed.tool_version
          (tool_version_uuid, tool_uuid, version_string, release_date, comment_public, comment_private,
          tool_path, tool_executable, tool_arguments, tool_directory, checksum)
        values
        ('6ea71506-b741-11e6-bf70-001a4a81450b','39001e1f-b741-11e6-bf70-001a4a81450b','2.9.4', now(), NULL, NULL,
        '/swamp/store/SCATools/jshint-2.9.4.tar.gz', null, null, null,
        '648f1ce802b4738e4d3d16a6a67e5bef525cd1b8b2a23bb67ca0c33c6256b428004ab5d43ae1553740f71d9740983455a6711cc4cc36cfb1d2535ba9845511be');
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('39001e1f-b741-11e6-bf70-001a4a81450b', '6ea71506-b741-11e6-bf70-001a4a81450b',14); # Web Scripting
        insert into tool_shed.tool_platform (tool_uuid, platform_uuid) select '39001e1f-b741-11e6-bf70-001a4a81450b', platform_uuid from platform_store.platform; # Compatible with all platforms
        insert into tool_shed.tool_viewer_incompatibility (tool_uuid, viewer_uuid) values ('39001e1f-b741-11e6-bf70-001a4a81450b', 'a0e1d0fb-bfb2-11e5-bf72-001a4a814413'); # incompatible with ThreadFix.

        # New Tool Flow: 1 tool with 1 version. Language = Web Scripting; Platform = All Platforms
          # tool_uuid: 3ef639d4-b741-11e6-bf70-001a4a81450b
          # tool_version_uuid: 749d3edd-b741-11e6-bf70-001a4a81450b
        delete from tool_shed.tool_viewer_incompatibility where tool_uuid = '3ef639d4-b741-11e6-bf70-001a4a81450b';
        delete from tool_shed.tool_platform where tool_uuid = '3ef639d4-b741-11e6-bf70-001a4a81450b';
        delete from tool_shed.tool_language where tool_uuid = '3ef639d4-b741-11e6-bf70-001a4a81450b';
        delete from tool_shed.tool_version  where tool_uuid = '3ef639d4-b741-11e6-bf70-001a4a81450b';
        delete from tool_shed.tool          where tool_uuid = '3ef639d4-b741-11e6-bf70-001a4a81450b';
        insert into tool_shed.tool
          (tool_uuid, tool_owner_uuid, name, description, tool_sharing_status, is_build_needed) values
          ('3ef639d4-b741-11e6-bf70-001a4a81450b','80835e30-d527-11e2-8b8b-0800200c9a66','Flow','A static analysis tool for JavaScript that verifies type correctness. <a href="https://flowtype.org/">https://flowtype.org/</a>', 'PUBLIC',0);
        insert into tool_shed.tool_version
          (tool_version_uuid, tool_uuid, version_string, release_date, comment_public, comment_private,
          tool_path, tool_executable, tool_arguments, tool_directory, checksum)
        values
        ('749d3edd-b741-11e6-bf70-001a4a81450b','3ef639d4-b741-11e6-bf70-001a4a81450b','0.37.4', now(), NULL, NULL,
        '/swamp/store/SCATools/flow-0.37.4.tar.gz', null, null, null,
        'a25ab9c67d0e2e206e07931988cce380005e605470dc0df5a93ebfd19816525af257aae7006f730ac414fe95f6164c314df2bb476980d6187f87283cf2af6506');
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('3ef639d4-b741-11e6-bf70-001a4a81450b', '749d3edd-b741-11e6-bf70-001a4a81450b',14); # Web Scripting
        insert into tool_shed.tool_platform (tool_uuid, platform_uuid) select '3ef639d4-b741-11e6-bf70-001a4a81450b', platform_uuid from platform_store.platform; # Compatible with all platforms
        insert into tool_shed.tool_viewer_incompatibility (tool_uuid, viewer_uuid) values ('3ef639d4-b741-11e6-bf70-001a4a81450b', 'a0e1d0fb-bfb2-11e5-bf72-001a4a814413'); # incompatible with ThreadFix.

        # New Tool HTML Tidy: 1 tool with 1 version. Language = Web Scripting; Platform = All Platforms
          # tool_uuid: 44ec433d-b741-11e6-bf70-001a4a81450b
          # tool_version_uuid: 7a93738b-b741-11e6-bf70-001a4a81450b
        delete from tool_shed.tool_viewer_incompatibility where tool_uuid = '44ec433d-b741-11e6-bf70-001a4a81450b';
        delete from tool_shed.tool_platform where tool_uuid = '44ec433d-b741-11e6-bf70-001a4a81450b';
        delete from tool_shed.tool_language where tool_uuid = '44ec433d-b741-11e6-bf70-001a4a81450b';
        delete from tool_shed.tool_version  where tool_uuid = '44ec433d-b741-11e6-bf70-001a4a81450b';
        delete from tool_shed.tool          where tool_uuid = '44ec433d-b741-11e6-bf70-001a4a81450b';
        insert into tool_shed.tool
          (tool_uuid, tool_owner_uuid, name, description, tool_sharing_status, is_build_needed) values
          ('44ec433d-b741-11e6-bf70-001a4a81450b','80835e30-d527-11e2-8b8b-0800200c9a66','HTML Tidy','The granddaddy of HTML tools. <a href="http://www.html-tidy.org/">http://www.html-tidy.org/</a>', 'PUBLIC',0);
        insert into tool_shed.tool_version
          (tool_version_uuid, tool_uuid, version_string, release_date, comment_public, comment_private,
          tool_path, tool_executable, tool_arguments, tool_directory, checksum)
        values
        ('7a93738b-b741-11e6-bf70-001a4a81450b','44ec433d-b741-11e6-bf70-001a4a81450b','5.2.0', now(), NULL, NULL,
        '/swamp/store/SCATools/tidy-html5-5.2.0-2.tar.gz', null, null, null,
        '21b10daa3a40f04415aae1c297f1de33d49ff3bde4f9566ddb60b867af74a3d711f2c172cb60975be233066a8bb4c611bb000d7530898453278bcd67470dc317');
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('44ec433d-b741-11e6-bf70-001a4a81450b', '7a93738b-b741-11e6-bf70-001a4a81450b',14); # Web Scripting
        insert into tool_shed.tool_platform (tool_uuid, platform_uuid) select '44ec433d-b741-11e6-bf70-001a4a81450b', platform_uuid from platform_store.platform; # Compatible with all platforms
        insert into tool_shed.tool_viewer_incompatibility (tool_uuid, viewer_uuid) values ('44ec433d-b741-11e6-bf70-001a4a81450b', 'a0e1d0fb-bfb2-11e5-bf72-001a4a814413'); # incompatible with ThreadFix.

        # New Tool CSS Lint: 1 tool with 1 version. Language = Web Scripting; Platform = All Platforms
          # tool_uuid: 4ae25a9c-b741-11e6-bf70-001a4a81450b
          # tool_version_uuid: 808990dd-b741-11e6-bf70-001a4a81450b
        delete from tool_shed.tool_viewer_incompatibility where tool_uuid = '4ae25a9c-b741-11e6-bf70-001a4a81450b';
        delete from tool_shed.tool_platform where tool_uuid = '4ae25a9c-b741-11e6-bf70-001a4a81450b';
        delete from tool_shed.tool_language where tool_uuid = '4ae25a9c-b741-11e6-bf70-001a4a81450b';
        delete from tool_shed.tool_version  where tool_uuid = '4ae25a9c-b741-11e6-bf70-001a4a81450b';
        delete from tool_shed.tool          where tool_uuid = '4ae25a9c-b741-11e6-bf70-001a4a81450b';
        insert into tool_shed.tool
          (tool_uuid, tool_owner_uuid, name, description, tool_sharing_status, is_build_needed) values
          ('4ae25a9c-b741-11e6-bf70-001a4a81450b','80835e30-d527-11e2-8b8b-0800200c9a66','CSS Lint','Automated linting of Cascading Stylesheets. <a href="http://csslint.net/">http://csslint.net/</a>', 'PUBLIC',0);
        insert into tool_shed.tool_version
          (tool_version_uuid, tool_uuid, version_string, release_date, comment_public, comment_private,
          tool_path, tool_executable, tool_arguments, tool_directory, checksum)
        values
        ('808990dd-b741-11e6-bf70-001a4a81450b','4ae25a9c-b741-11e6-bf70-001a4a81450b','1.0.4', now(), NULL, NULL,
        '/swamp/store/SCATools/csslint-1.0.4.tar.gz', null, null, null,
        '5f47baa57c8d8e44ba4f7b3d4da327fa85e9c4c91d0aa41492ead7c1a8eb70102bcbd4be5334ae813960ec54bf13975a306588138e4ce15da81a7792f38d9ffd');
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('4ae25a9c-b741-11e6-bf70-001a4a81450b', '808990dd-b741-11e6-bf70-001a4a81450b',14); # Web Scripting
        insert into tool_shed.tool_platform (tool_uuid, platform_uuid) select '4ae25a9c-b741-11e6-bf70-001a4a81450b', platform_uuid from platform_store.platform; # Compatible with all platforms
        insert into tool_shed.tool_viewer_incompatibility (tool_uuid, viewer_uuid) values ('4ae25a9c-b741-11e6-bf70-001a4a81450b', 'a0e1d0fb-bfb2-11e5-bf72-001a4a814413'); # incompatible with ThreadFix.

        # New Tool XML Lint: 1 tool with 1 version. Language = Web Scripting; Platform = All Platforms
          # tool_uuid: 50d8714c-b741-11e6-bf70-001a4a81450b
          # tool_version_uuid: 867fa2de-b741-11e6-bf70-001a4a81450b
        delete from tool_shed.tool_viewer_incompatibility where tool_uuid = '50d8714c-b741-11e6-bf70-001a4a81450b';
        delete from tool_shed.tool_platform where tool_uuid = '50d8714c-b741-11e6-bf70-001a4a81450b';
        delete from tool_shed.tool_language where tool_uuid = '50d8714c-b741-11e6-bf70-001a4a81450b';
        delete from tool_shed.tool_version  where tool_uuid = '50d8714c-b741-11e6-bf70-001a4a81450b';
        delete from tool_shed.tool          where tool_uuid = '50d8714c-b741-11e6-bf70-001a4a81450b';
        insert into tool_shed.tool
          (tool_uuid, tool_owner_uuid, name, description, tool_sharing_status, is_build_needed) values
          ('50d8714c-b741-11e6-bf70-001a4a81450b','80835e30-d527-11e2-8b8b-0800200c9a66','XML Lint','XML Lint. <a href="http://xmlsoft.org">http://xmlsoft.org</a>', 'PUBLIC',0);
        insert into tool_shed.tool_version
          (tool_version_uuid, tool_uuid, version_string, release_date, comment_public, comment_private,
          tool_path, tool_executable, tool_arguments, tool_directory, checksum)
        values
        ('867fa2de-b741-11e6-bf70-001a4a81450b','50d8714c-b741-11e6-bf70-001a4a81450b','2.9.4', now(), NULL, NULL,
        '/swamp/store/SCATools/xmllint-2.9.4-2.tar.gz', null, null, null,
        'c0d069f0c25c556f44c9ec5c3b8792baf809456222b1f59736e664c52c9c39ca56b63e69450007e5c8d8b4041b49797d9b2aacebeb8759f0e9cd21367f3a0709');
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('50d8714c-b741-11e6-bf70-001a4a81450b', '867fa2de-b741-11e6-bf70-001a4a81450b',14); # Web Scripting
        insert into tool_shed.tool_platform (tool_uuid, platform_uuid) select '50d8714c-b741-11e6-bf70-001a4a81450b', platform_uuid from platform_store.platform; # Compatible with all platforms
        insert into tool_shed.tool_viewer_incompatibility (tool_uuid, viewer_uuid) values ('50d8714c-b741-11e6-bf70-001a4a81450b', 'a0e1d0fb-bfb2-11e5-bf72-001a4a814413'); # incompatible with ThreadFix.

        # New Tool PHPMD: 1 tool with 1 version. Language = Web Scripting; Platform = All Platforms
          # tool_uuid: 56ce7899-b741-11e6-bf70-001a4a81450b
          # tool_version_uuid: 8c75d607-b741-11e6-bf70-001a4a81450b
        delete from tool_shed.tool_viewer_incompatibility where tool_uuid = '56ce7899-b741-11e6-bf70-001a4a81450b';
        delete from tool_shed.tool_platform where tool_uuid = '56ce7899-b741-11e6-bf70-001a4a81450b';
        delete from tool_shed.tool_language where tool_uuid = '56ce7899-b741-11e6-bf70-001a4a81450b';
        delete from tool_shed.tool_version  where tool_uuid = '56ce7899-b741-11e6-bf70-001a4a81450b';
        delete from tool_shed.tool          where tool_uuid = '56ce7899-b741-11e6-bf70-001a4a81450b';
        insert into tool_shed.tool
          (tool_uuid, tool_owner_uuid, name, description, tool_sharing_status, is_build_needed) values
          ('56ce7899-b741-11e6-bf70-001a4a81450b','80835e30-d527-11e2-8b8b-0800200c9a66','PHPMD','PHP Mess Detector. <a href="https://phpmd.org/">https://phpmd.org/</a>', 'PUBLIC',0);
        insert into tool_shed.tool_version
          (tool_version_uuid, tool_uuid, version_string, release_date, comment_public, comment_private,
          tool_path, tool_executable, tool_arguments, tool_directory, checksum)
        values
        ('8c75d607-b741-11e6-bf70-001a4a81450b','56ce7899-b741-11e6-bf70-001a4a81450b','2.5.0', now(), NULL, NULL,
        '/swamp/store/SCATools/phpmd-2.5.0.tar.gz', null, null, null,
        '906f5b7491ff23a92c50306532c6e84ef9ef06cceeb4ae7fb086189a6d1a3fff4d573285e703e91df83cff6145e0cd72733550974caa9bfca2a43be7c46572a2');
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('56ce7899-b741-11e6-bf70-001a4a81450b', '8c75d607-b741-11e6-bf70-001a4a81450b',14); # Web Scripting
        insert into tool_shed.tool_platform (tool_uuid, platform_uuid) select '56ce7899-b741-11e6-bf70-001a4a81450b', platform_uuid from platform_store.platform; # Compatible with all platforms
        insert into tool_shed.tool_viewer_incompatibility (tool_uuid, viewer_uuid) values ('56ce7899-b741-11e6-bf70-001a4a81450b', 'a0e1d0fb-bfb2-11e5-bf72-001a4a814413'); # incompatible with ThreadFix.

        # New Tool PHP_CodeSniffer: 1 tool with 2 versions. Language = Web Scripting; Platform = All Platforms
          # tool_uuid: 5cc49bb0-b741-11e6-bf70-001a4a81450b
          # tool_version_uuid: 927193af-b741-11e6-bf70-001a4a81450b
        delete from tool_shed.tool_viewer_incompatibility where tool_uuid = '5cc49bb0-b741-11e6-bf70-001a4a81450b';
        delete from tool_shed.tool_platform where tool_uuid = '5cc49bb0-b741-11e6-bf70-001a4a81450b';
        delete from tool_shed.tool_language where tool_uuid = '5cc49bb0-b741-11e6-bf70-001a4a81450b';
        delete from tool_shed.tool_version  where tool_uuid = '5cc49bb0-b741-11e6-bf70-001a4a81450b';
        delete from tool_shed.tool          where tool_uuid = '5cc49bb0-b741-11e6-bf70-001a4a81450b';
        insert into tool_shed.tool
          (tool_uuid, tool_owner_uuid, name, description, tool_sharing_status, is_build_needed) values
          ('5cc49bb0-b741-11e6-bf70-001a4a81450b','80835e30-d527-11e2-8b8b-0800200c9a66','PHP_CodeSniffer','PHP_CodeSniffer tokenizes PHP, JavaScript and CSS files to detect and fix violations of a defined set of coding standards. <a href="http://pear.php.net/package/PHP_CodeSniffer">http://pear.php.net/package/PHP_CodeSniffer</a>', 'PUBLIC',0);
        insert into tool_shed.tool_version
          (tool_version_uuid, tool_uuid, version_string, release_date, comment_public, comment_private,
          tool_path, tool_executable, tool_arguments, tool_directory, checksum)
        values
        ('927193af-b741-11e6-bf70-001a4a81450b','5cc49bb0-b741-11e6-bf70-001a4a81450b','2.7.1', now(), NULL, NULL,
        '/swamp/store/SCATools/php_codesniffer-2.7.1.tar.gz', null, null, null,
        'f1d70bfd4cddcb958eee59ad7353607eaa9a7ca31eecaeb15b59dc57ac38e36a21552a8e0193cef69d6d9a0ad2a5ac67565cff1ce34b20f4f72fab430f99ad49');
        insert into tool_shed.tool_version
          (tool_version_uuid, tool_uuid, version_string, release_date, comment_public, comment_private,
          tool_path, tool_executable, tool_arguments, tool_directory, checksum)
        values
        ('932a2260-d9d5-11e6-bf70-001a4a81450b','5cc49bb0-b741-11e6-bf70-001a4a81450b','3.0.0', now(), NULL, NULL,
        '/swamp/store/SCATools/php_codesniffer-3.0.0rc2.tar.gz', null, null, null,
        'acf48dceb5eea96776c34723da4eca5de42aa64dfe120ed84907cee9ed578c13b0d4e48e96b14ede10e5188fab6401de8e0fc64d58979a5c5f8adfb4fccc834f');
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('5cc49bb0-b741-11e6-bf70-001a4a81450b', '927193af-b741-11e6-bf70-001a4a81450b',14); # Web Scripting
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('5cc49bb0-b741-11e6-bf70-001a4a81450b', '932a2260-d9d5-11e6-bf70-001a4a81450b',14); # Web Scripting
        insert into tool_shed.tool_platform (tool_uuid, platform_uuid) select '5cc49bb0-b741-11e6-bf70-001a4a81450b', platform_uuid from platform_store.platform; # Compatible with all platforms
        insert into tool_shed.tool_viewer_incompatibility (tool_uuid, viewer_uuid) values ('5cc49bb0-b741-11e6-bf70-001a4a81450b', 'a0e1d0fb-bfb2-11e5-bf72-001a4a814413'); # incompatible with ThreadFix.

        # New Tool Retire.js: 1 tool with 1 version. Language = Web Scripting; Platform = All Platforms
          # tool_uuid: 62babae5-b741-11e6-bf70-001a4a81450b
          # tool_version_uuid: 9867c824-b741-11e6-bf70-001a4a81450b
        delete from tool_shed.tool_viewer_incompatibility where tool_uuid = '62babae5-b741-11e6-bf70-001a4a81450b';
        delete from tool_shed.tool_platform where tool_uuid = '62babae5-b741-11e6-bf70-001a4a81450b';
        delete from tool_shed.tool_language where tool_uuid = '62babae5-b741-11e6-bf70-001a4a81450b';
        delete from tool_shed.tool_version  where tool_uuid = '62babae5-b741-11e6-bf70-001a4a81450b';
        delete from tool_shed.tool          where tool_uuid = '62babae5-b741-11e6-bf70-001a4a81450b';
        insert into tool_shed.tool
          (tool_uuid, tool_owner_uuid, name, description, tool_sharing_status, is_build_needed) values
          ('62babae5-b741-11e6-bf70-001a4a81450b','80835e30-d527-11e2-8b8b-0800200c9a66','Retire.js','Scanner detecting the use of JavaScript libraries with known vulnerabilities. <a href="http://retirejs.github.io/retire.js/">http://retirejs.github.io/retire.js/</a>', 'PUBLIC',0);
        insert into tool_shed.tool_version
          (tool_version_uuid, tool_uuid, version_string, release_date, comment_public, comment_private,
          tool_path, tool_executable, tool_arguments, tool_directory, checksum)
        values
        ('9867c824-b741-11e6-bf70-001a4a81450b','62babae5-b741-11e6-bf70-001a4a81450b','1.2.10', now(), NULL, NULL,
        '/swamp/store/SCATools/retire-js-1.2.10.tar.gz', null, null, null,
        'e28dc49719fbed4143085c22170c982957a694c0ee0e9fe56bbc5faf6ba71331acd78eac8a0a4032068b9b412819d92bf5b8e3c2331f6fc54ade892176e9f8c7');
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('62babae5-b741-11e6-bf70-001a4a81450b', '9867c824-b741-11e6-bf70-001a4a81450b',14); # Web Scripting
        insert into tool_shed.tool_platform (tool_uuid, platform_uuid) select '62babae5-b741-11e6-bf70-001a4a81450b', platform_uuid from platform_store.platform; # Compatible with all platforms
        insert into tool_shed.tool_viewer_incompatibility (tool_uuid, viewer_uuid) values ('62babae5-b741-11e6-bf70-001a4a81450b', 'a0e1d0fb-bfb2-11e5-bf72-001a4a814413'); # incompatible with ThreadFix.

        if (system_type = 'MIR_SWAMP') then
          # New Tool Grammatech: 1 tool with 1 version. Language = C/C++; Platform = All Platforms
            # tool_uuid: 5540d2be-72b2-11e5-865f-001a4a81450b
            # tool_version_uuid: 68f4a0c7-72b2-11e5-865f-001a4a81450b
          delete from tool_shed.tool_viewer_incompatibility where tool_uuid = '5540d2be-72b2-11e5-865f-001a4a81450b';
          delete from tool_shed.tool_platform where tool_uuid = '5540d2be-72b2-11e5-865f-001a4a81450b';
          delete from tool_shed.tool_language where tool_uuid = '5540d2be-72b2-11e5-865f-001a4a81450b';
          delete from tool_shed.tool_version  where tool_uuid = '5540d2be-72b2-11e5-865f-001a4a81450b';
          delete from tool_shed.tool          where tool_uuid = '5540d2be-72b2-11e5-865f-001a4a81450b';
          insert into tool_shed.tool
            (tool_uuid, tool_owner_uuid, name, description, tool_sharing_status, is_build_needed) values
            ('5540d2be-72b2-11e5-865f-001a4a81450b','80835e30-d527-11e2-8b8b-0800200c9a66','GrammaTech CodeSonar','GrammaTech''s flagship static analysis SAST tool. <a href="https://www.grammatech.com/products/codesonar">https://www.grammatech.com/products/codesonar</a>', 'PUBLIC',0);
          insert into tool_shed.tool_version
            (tool_version_uuid, tool_uuid, version_string, release_date, comment_public, comment_private,
            tool_path, tool_executable, tool_arguments, tool_directory, checksum)
          values
          ('68f4a0c7-72b2-11e5-865f-001a4a81450b','5540d2be-72b2-11e5-865f-001a4a81450b','4.4', now(), NULL, NULL,
          '/swamp/store/SCATools/gt-csonar-4.4p0.tar', null, null, null,
          'e17fb9b1c5e9892528a2962955c57c923ff0cb9e7dfdbb451a23773724fec644038bac1cafdc17d3f2e4694b28a5e13100b3dcc4b29b24f4ac0bc3ecd416b7a6');
          insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('5540d2be-72b2-11e5-865f-001a4a81450b', '68f4a0c7-72b2-11e5-865f-001a4a81450b',1); # C/C++
          insert into tool_shed.tool_platform (tool_uuid, platform_uuid) select '5540d2be-72b2-11e5-865f-001a4a81450b', platform_uuid from platform_store.platform; # Compatible with all platforms
          insert into tool_shed.tool_viewer_incompatibility (tool_uuid, viewer_uuid) values ('5540d2be-72b2-11e5-865f-001a4a81450b', 'a0e1d0fb-bfb2-11e5-bf72-001a4a814413'); # incompatible with ThreadFix.
          update tool_shed.tool set policy_code = 'codesonar-user-policy' where tool_uuid = '5540d2be-72b2-11e5-865f-001a4a81450b';
        end if;

        # New Python Tool Versions
          # bandit-py2-1.3.0.tar.gz
          # bandit-py3-1.3.0.tar.gz
          # flake8-py2-3.2.1.tar.gz
          # flake8-py3-3.2.1.tar.gz
          # pylint-py3-1.6.4.tar.gz
          # pylint-py2-1.6.4.tar.gz

        # Python Bandit - Add New Version
        # One tool version with two specialized tool versions for Python2 and Python3.
        delete from tool_shed.tool_language             where tool_version_uuid = '5f258cae-de8e-11e6-bf70-001a4a81450b';
        delete from tool_shed.specialized_tool_version  where tool_version_uuid = '5f258cae-de8e-11e6-bf70-001a4a81450b';
        delete from tool_shed.tool_version              where tool_version_uuid = '5f258cae-de8e-11e6-bf70-001a4a81450b';
        insert into tool_shed.tool_version (tool_version_uuid, tool_uuid, version_string, release_date, comment_public, comment_private, tool_path, tool_executable, tool_arguments, tool_directory, checksum)
          values ('5f258cae-de8e-11e6-bf70-001a4a81450b','7fbfa454-8f9f-11e4-829b-001a4a81450b','1.3.0', now(), 'Bandit for Python 2 & 3', NULL, NULL, NULL, NULL, NULL, NULL);
        insert into tool_shed.specialized_tool_version
            (specialization_type, specialized_tool_version_uuid, tool_uuid, tool_version_uuid, package_type_id, tool_path, tool_executable, tool_arguments, tool_directory, checksum) values
            ('LANGUAGE', '72755a93-de8e-11e6-bf70-001a4a81450b', '7fbfa454-8f9f-11e4-829b-001a4a81450b', '5f258cae-de8e-11e6-bf70-001a4a81450b', 4,
             '/swamp/store/SCATools/bandit-py2-1.3.0.tar.gz', 'bandit', '--format json --output ${REPORTS_DIR}/report.json', 'bandit-py2-1.3.0',
             '36d404bbd09cfa0173483d8dafc7c3277e8c120fa9330eaf1bb9c554a325ef3e87ca36ae9b4371b9e436f613d0c31048f11eca1e417e53daf9cd2d260bbdde53'),
            ('LANGUAGE', '994ebd53-de8e-11e6-bf70-001a4a81450b', '7fbfa454-8f9f-11e4-829b-001a4a81450b', '5f258cae-de8e-11e6-bf70-001a4a81450b', 5,
             '/swamp/store/SCATools/bandit-py3-1.3.0.tar.gz', 'bandit', '--format json --output ${REPORTS_DIR}/report.json', 'bandit-py3-1.3.0',
             'd0066a24e63e75febfeaee62cd6093396413fbf3c2b29194c67f99c090c86bd98a6a24454c4844f036acff54272a1eab5592cbc4208fd902db5f56d59fdc3b27');
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('7fbfa454-8f9f-11e4-829b-001a4a81450b', '5f258cae-de8e-11e6-bf70-001a4a81450b',4);
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('7fbfa454-8f9f-11e4-829b-001a4a81450b', '5f258cae-de8e-11e6-bf70-001a4a81450b',5);

        # Python Flake - Add New Version
        # One tool version with two specialized tool versions for Python2 and Python3.
        delete from tool_shed.tool_language             where tool_version_uuid = '0a01266d-de92-11e6-bf70-001a4a81450b';
        delete from tool_shed.specialized_tool_version  where tool_version_uuid = '0a01266d-de92-11e6-bf70-001a4a81450b';
        delete from tool_shed.tool_version              where tool_version_uuid = '0a01266d-de92-11e6-bf70-001a4a81450b';
        insert into tool_shed.tool_version (tool_version_uuid, tool_uuid, version_string, release_date, comment_public, comment_private, tool_path, tool_executable, tool_arguments, tool_directory, checksum)
          values ('0a01266d-de92-11e6-bf70-001a4a81450b','63695cd8-a73e-11e4-a335-001a4a81450b','3.2.1', now(), 'Flake8 v3.2.1 for Python 2 & 3', NULL, NULL, NULL, NULL, NULL, NULL);
        insert into tool_shed.specialized_tool_version
            (specialization_type, specialized_tool_version_uuid, tool_uuid, tool_version_uuid, package_type_id, tool_path, tool_executable, tool_arguments, tool_directory, checksum) values
            ('LANGUAGE', '16f864d4-de92-11e6-bf70-001a4a81450b', '63695cd8-a73e-11e4-a335-001a4a81450b', '0a01266d-de92-11e6-bf70-001a4a81450b', 4,
             '/swamp/store/SCATools/flake8-py2-3.2.1.tar.gz', 'flake8', '--verbose --exit-zero --format=pylint --output-file=${REPORTS_DIR}/report.txt', 'flake8-3.2.1',
             '6060fa3f811d3c57226e2799cb950ee31cc80206a88bebe3f45be1216f5f1dc05f34aeb0d504c03f1829611a8424419d2b60b88a8372c10c0cee49a4c30867b3'),
            ('LANGUAGE', '492d1272-de92-11e6-bf70-001a4a81450b', '63695cd8-a73e-11e4-a335-001a4a81450b', '0a01266d-de92-11e6-bf70-001a4a81450b', 5,
             '/swamp/store/SCATools/flake8-py3-3.2.1.tar.gz', 'flake8', '--verbose --exit-zero --format=pylint --output-file=${REPORTS_DIR}/report.txt', 'flake8-3.2.1',
             'b335c96fa7f8f9c3df08a741d4e5671e0b0920f917c794fd6b390d7ac39e1471c4c0da6504c74ae5ee0a20e00057e1e66127f36e7dde04c0f6164066c8b968b3');
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('63695cd8-a73e-11e4-a335-001a4a81450b', '0a01266d-de92-11e6-bf70-001a4a81450b',4);
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('63695cd8-a73e-11e4-a335-001a4a81450b', '0a01266d-de92-11e6-bf70-001a4a81450b',5);

        # Pylint - Add New Version
        # One tool version with two specialized tool versions for Python2 and Python3.
        delete from tool_shed.tool_language             where tool_version_uuid = '1e288d3e-de82-11e6-bf70-001a4a81450b';
        delete from tool_shed.specialized_tool_version  where tool_version_uuid = '1e288d3e-de82-11e6-bf70-001a4a81450b';
        delete from tool_shed.tool_version              where tool_version_uuid = '1e288d3e-de82-11e6-bf70-001a4a81450b';
        insert into tool_shed.tool_version (tool_version_uuid, tool_uuid, version_string, release_date, comment_public, comment_private, tool_path, tool_executable, tool_arguments, tool_directory, checksum)
          values ('1e288d3e-de82-11e6-bf70-001a4a81450b','0f668fb0-4421-11e4-a4f3-001a4a81450b','1.6.4', now(), 'Pylint v1.6.4 for Python 2 & 3', NULL, NULL, NULL, NULL, NULL, NULL);
        insert into tool_shed.specialized_tool_version
            (specialization_type, specialized_tool_version_uuid, tool_uuid, tool_version_uuid, package_type_id, tool_path, tool_executable, tool_arguments, tool_directory, checksum) values
            ('LANGUAGE', '2bbff525-de82-11e6-bf70-001a4a81450b', '0f668fb0-4421-11e4-a4f3-001a4a81450b', '1e288d3e-de82-11e6-bf70-001a4a81450b', 4,
             '/swamp/store/SCATools/pylint-py2-1.6.4.tar.gz', 'pylint', '-f parseable --disable=C --disable=R', 'pylint-py2-1.6.4',
             'c66418905582eaeb294312e506a4c0a9af4030b18702a1ea61412ffd7275184a12694d6631a2a09517b82b5babc2c4cfa08dcdf0220c515da4c2fd064dd9f104'),
            ('LANGUAGE', '331f24ca-de82-11e6-bf70-001a4a81450b', '0f668fb0-4421-11e4-a4f3-001a4a81450b', '1e288d3e-de82-11e6-bf70-001a4a81450b', 5,
             '/swamp/store/SCATools/pylint-py3-1.6.4.tar.gz', 'pylint', '-f parseable --disable=C --disable=R', 'pylint-py3-1.6.4',
             'f78aac13a7b918d55bfcb3c82ceaf009e298e16a300b8bc490f134674b683289e16a1d4e20f283ac3cb3e95322cd73e35c19ab62d754700054401ca677f0e190');
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('0f668fb0-4421-11e4-a4f3-001a4a81450b', '1e288d3e-de82-11e6-bf70-001a4a81450b',4);
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('0f668fb0-4421-11e4-a4f3-001a4a81450b', '1e288d3e-de82-11e6-bf70-001a4a81450b',5);

        # Python Tools: drop in replacements of existing version
          # bandit-py2-0.14.0-6.tar.gz
          # bandit-py3-0.14.0-6.tar.gz
          # flake8-py2-2.4.1-3.tar.gz
          # flake8-py3-2.4.1-3.tar.gz
          # flake8-py2-2.3.0-3.tar.gz
          # flake8-py3-2.3.0-3.tar.gz
          # pylint-py3-1.4.4-3.tar.gz
          # pylint-py2-1.4.4-3.tar.gz
          # pylint-py3-1.3.1-3.tar.gz
          # pylint-py2-1.3.1-3.tar.gz

        # Python Bandit - Update Existing Versions - specialized_tool_version
        update tool_shed.specialized_tool_version
           set tool_path = '/swamp/store/SCATools/bandit-py2-0.14.0-6.tar.gz',
               checksum = '41bfd11dc2c73f1725cb3c35f77f77c5cd2431c5d780188bda77d9a63e343d77d0f7006d38ad783ad714308e142fa0849c4b8e7d3a77da392811bdb38a1a49a6'
          where specialized_tool_version_uuid = '7774f01a-7449-11e5-865f-001a4a81450b';
        update tool_shed.specialized_tool_version
           set tool_path = '/swamp/store/SCATools/bandit-py3-0.14.0-6.tar.gz',
               checksum = '3ca493b72e3134dd5ec0614913bc811711195c8508c80567da71b6182953c54beaccee8bd6d33ade7dbe32cb4e7f29f2bb25756d96f560c60b81daecaaf3a8ae'
          where specialized_tool_version_uuid = '88be0c6b-7449-11e5-865f-001a4a81450b';

        # Python Flake - Update Existing Versions
        update tool_shed.specialized_tool_version
           set tool_path = '/swamp/store/SCATools/flake8-py2-2.3.0-3.tar.gz',
               checksum = '72ed5997b50d37c111446b1105f96de5f4f29d82179184b7e788ef9041cdf3e27d915e6fa63951ea75a2f1a9ac611ba191f1f4e45a283db49c061d0f46dd78fb'
          where specialized_tool_version_uuid = '134873d9-a7e4-11e4-a335-001a4a81450b';
        update tool_shed.specialized_tool_version
           set tool_path = '/swamp/store/SCATools/flake8-py3-2.3.0-3.tar.gz',
               checksum = '2853d562a1d3281ff25b815bd2ef87c481275a588c1d7ad43ea884d19c7b40d3b0492d5fd4eb560075f21e2d0a84cdc10a384303ccf03b3e5e9fa4a7dd6cf960'
          where specialized_tool_version_uuid = '1e58fe0c-a7e4-11e4-a335-001a4a81450b';
        update tool_shed.specialized_tool_version
           set tool_path = '/swamp/store/SCATools/flake8-py2-2.4.1-3.tar.gz',
               checksum = 'fe8a2737444cf87cf8f7c63fac3d2c0580e21a3321532c0db84dd03752d0b0582ab695a8f1f51118c3e5e0406cb66c86db95de7578f26d4e09abaea77223d3af'
          where specialized_tool_version_uuid = '5b7d6fde-71d5-11e5-865f-001a4a81450b';
        update tool_shed.specialized_tool_version
           set tool_path = '/swamp/store/SCATools/flake8-py3-2.4.1-3.tar.gz',
               checksum = '59a618379578c4f98423ad551e133a0cbdab24d0778f1c5130d847c7d72e66edbf9258e297bb2ffc47b24b5d835b3bf3b1575ce8c3677dfca21c244d63b093ac'
          where specialized_tool_version_uuid = '813b30f3-71d5-11e5-865f-001a4a81450b';

        # Pylint - Update Existing Version
        update tool_shed.specialized_tool_version
           set tool_path = '/swamp/store/SCATools/pylint-py2-1.3.1-3.tar.gz',
               checksum = 'c4faf19de7784505ea098029c596fc585ef8c7c8531b29c0c5eb3c6054b961cb8b6df3fd9e6d5348d6b6aa9fa70786b840667de8774307bf8ca34947870004cf'
          where specialized_tool_version_uuid = '364e8718-480a-11e4-a4f3-001a4a81450b';
        update tool_shed.specialized_tool_version
           set tool_path = '/swamp/store/SCATools/pylint-py3-1.3.1-3.tar.gz',
               checksum = 'd091d02d5365075cd1db24db543d30bf208fcf8b73d4ff96da00a9be699df72cae8dc32532b21e6048bcbe0a70b96ddf499e289eb3f649e985ce8239ef2888af'
          where specialized_tool_version_uuid = 'eccdd194-480a-11e4-a4f3-001a4a81450b';
        update tool_shed.specialized_tool_version
           set tool_path = '/swamp/store/SCATools/pylint-py2-1.4.4-3.tar.gz',
               checksum = '61cc19a610106f710bf725121726313fc87d6a82846a6f2e63e160635e5c7f8d1107f3cfc18af1d34202e34ba39878ed6ddac1178aa316c6f92239386d399dc3'
          where specialized_tool_version_uuid = 'dab2f27b-71d7-11e5-865f-001a4a81450b';
        update tool_shed.specialized_tool_version
           set tool_path = '/swamp/store/SCATools/pylint-py3-1.4.4-3.tar.gz',
               checksum = 'f6e8a8b4ae480722e9a4364946e273875fedb1e5f7e79d4cc3d4c4a6e64031ce439aa4f493f279dfae3975ac93a395d7494e363ff5dcf83ee7262707795a71d3'
          where specialized_tool_version_uuid = 'e4fb2c6f-71d7-11e5-865f-001a4a81450b';

        # New Java Tool Versions
          # checkstyle-7.4.tar.gz
          # dependency-check-1.4.4.tar.gz
          # error-prone-2.0.15.tar.gz
          # pmd-5.5.2.tar.gz
        # Drop in replacement of existing tool version
          # findbugs-3.0.1-2.tar.gz

        # checkstyle - new version 7.4
          # tool_uuid:         992A48A5-62EC-4EE9-8429-45BB94275A41
          # tool_version_uuid: dde35138-e275-11e6-bf70-001a4a81450b
        delete from tool_shed.tool_language             where tool_version_uuid = 'dde35138-e275-11e6-bf70-001a4a81450b';
        delete from tool_shed.tool_version              where tool_version_uuid = 'dde35138-e275-11e6-bf70-001a4a81450b';
        insert into tool_shed.tool_version
          (tool_version_uuid, tool_uuid, version_string, release_date, comment_public, comment_private,
          tool_path, tool_executable, tool_arguments, tool_directory, checksum)
        values
        ('dde35138-e275-11e6-bf70-001a4a81450b','992A48A5-62EC-4EE9-8429-45BB94275A41','7.4', now(), 'Checkstyle v7.4', NULL,
        '/swamp/store/SCATools/checkstyle-7.4.tar.gz', 'checkstyle-7.4-all.jar', '', 'checkstyle-7.4',
        'dc2601eff015f378f9e9841cfc4b082dd5efdeb6d8de3be5d36a65d717f1d4a9fd14bcde796d97dcd492f4786665535600c1418fc657cadf557d6a9aae8b14a8');
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('992A48A5-62EC-4EE9-8429-45BB94275A41', 'dde35138-e275-11e6-bf70-001a4a81450b',2);
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('992A48A5-62EC-4EE9-8429-45BB94275A41', 'dde35138-e275-11e6-bf70-001a4a81450b',6);
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('992A48A5-62EC-4EE9-8429-45BB94275A41', 'dde35138-e275-11e6-bf70-001a4a81450b',12);

        # OWASP Dependency Check - new version
          # tool_uuid: d032d8ec-9184-11e6-88bc-001a4a81450b
          # tool_version_uuid: 37565211-e27f-11e6-bf70-001a4a81450b
        delete from tool_shed.tool_language             where tool_version_uuid = '37565211-e27f-11e6-bf70-001a4a81450b';
        delete from tool_shed.tool_version              where tool_version_uuid = '37565211-e27f-11e6-bf70-001a4a81450b';
        insert into tool_shed.tool_version
          (tool_version_uuid, tool_uuid, version_string, release_date, comment_public, comment_private,
          tool_path, tool_executable, tool_arguments, tool_directory, checksum)
        values
        ('37565211-e27f-11e6-bf70-001a4a81450b','d032d8ec-9184-11e6-88bc-001a4a81450b','1.4.4', now(), 'OWASP Dependency Check 1.4.4', NULL,
        '/swamp/store/SCATools/dependency-check-1.4.4.tar.gz', null, null, null,
        '4565b10faeb8730b6d03e46e5f8878d48326fe2fe5745bcb729b5e32611940f44dc20ed717729327ffc6ea15264716e91a7eac2128eb9b8bdc3cbc7ed4ac5e04');
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('d032d8ec-9184-11e6-88bc-001a4a81450b', '37565211-e27f-11e6-bf70-001a4a81450b',2);  # Java Source Code
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('d032d8ec-9184-11e6-88bc-001a4a81450b', '37565211-e27f-11e6-bf70-001a4a81450b',3);  # Java Bytecode
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('d032d8ec-9184-11e6-88bc-001a4a81450b', '37565211-e27f-11e6-bf70-001a4a81450b',6);  # Android Java Source Code
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('d032d8ec-9184-11e6-88bc-001a4a81450b', '37565211-e27f-11e6-bf70-001a4a81450b',11); # Android .apk
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('d032d8ec-9184-11e6-88bc-001a4a81450b', '37565211-e27f-11e6-bf70-001a4a81450b',12); # Java 8 Source Code
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('d032d8ec-9184-11e6-88bc-001a4a81450b', '37565211-e27f-11e6-bf70-001a4a81450b',13); # Java 8 Bytecode

        # error-prone - new version 2.0.15
          # tool_uuid:         56872C2E-1D78-4DB0-B976-83ACF5424C52
          # tool_version_uuid: 13a1ceb5-e280-11e6-bf70-001a4a81450b
        delete from tool_shed.tool_language             where tool_version_uuid = '13a1ceb5-e280-11e6-bf70-001a4a81450b';
        delete from tool_shed.tool_version              where tool_version_uuid = '13a1ceb5-e280-11e6-bf70-001a4a81450b';
        insert into tool_shed.tool_version
          (tool_version_uuid, tool_uuid, version_string, release_date, comment_public, comment_private,
          tool_path, tool_executable, tool_arguments, tool_directory, checksum)
        values
        ('13a1ceb5-e280-11e6-bf70-001a4a81450b','56872C2E-1D78-4DB0-B976-83ACF5424C52','2.0.15', now(), 'error-prone v2.0.15', NULL,
        '/swamp/store/SCATools/error-prone-2.0.15.tar.gz', 'error_prone_ant-2.0.15.jar', '', 'error-prone-2.0.15',
        '6ae8439ee0c4ca9b37488786ca676f24a517ae6e89ea14832bc7d192a2efbbeed5d66cfe13770508ce53e047d7d441eea830004c6f5f98db053aee94d4d06363');
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('56872C2E-1D78-4DB0-B976-83ACF5424C52', '13a1ceb5-e280-11e6-bf70-001a4a81450b',2);
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('56872C2E-1D78-4DB0-B976-83ACF5424C52', '13a1ceb5-e280-11e6-bf70-001a4a81450b',6);
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('56872C2E-1D78-4DB0-B976-83ACF5424C52', '13a1ceb5-e280-11e6-bf70-001a4a81450b',12);

        # PMD - new version 5.5.2
          # tool_uuid:         163f2b01-156e-11e3-a239-001a4a81450b
          # tool_version_uuid: 6a2a40d8-e281-11e6-bf70-001a4a81450b
        delete from tool_shed.tool_language             where tool_version_uuid = '6a2a40d8-e281-11e6-bf70-001a4a81450b';
        delete from tool_shed.tool_version              where tool_version_uuid = '6a2a40d8-e281-11e6-bf70-001a4a81450b';
        insert into tool_shed.tool_version
          (tool_version_uuid, tool_uuid, version_string, release_date, comment_public, comment_private,
          tool_path, tool_executable, tool_arguments, tool_directory, checksum)
        values
        ('6a2a40d8-e281-11e6-bf70-001a4a81450b','163f2b01-156e-11e3-a239-001a4a81450b','5.5.2', now(), 'PMD v5.5.2', NULL,
        '/swamp/store/SCATools/pmd-5.5.2.tar.gz', 'net.sourceforge.pmd.PMD', '', 'pmd-bin-5.5.2',
        '9b1232288c80801b2f66491fd0f65cdb7b17cac062ac61589d69785074f7673886b768bcad6d7710931a6b92caaffcb11c5582838f997dd54c6638639066ba4a');
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('163f2b01-156e-11e3-a239-001a4a81450b', '6a2a40d8-e281-11e6-bf70-001a4a81450b',2);
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('163f2b01-156e-11e3-a239-001a4a81450b', '6a2a40d8-e281-11e6-bf70-001a4a81450b',6);

        # Findbugs - drop in replacement of existing version
        update tool_shed.tool_version
           set tool_path = '/swamp/store/SCATools/findbugs-3.0.1-2.tar.gz',
               checksum = '9a3002d8207e1fb86571800c4b63511965b1a0686d73e9976d8b3ed967e0a5fa5a457556edbe378dc245e0f32946b3146441c55d39589bbef0f648ecb5bdc1f4'
         where tool_version_uuid = '9c48c4ad-e098-11e5-ae56-001a4a81450b';

        # New Versions of metric tools
          # cloc-1.70.tar.gz
          # lizard-1.12.7.tar.gz
        delete from metric.metric_tool_version where metric_tool_version_uuid = '336e327a-de98-11e6-bf70-001a4a81450b';
        delete from metric.metric_tool_version where metric_tool_version_uuid = '3bd56e00-de98-11e6-bf70-001a4a81450b';
        insert into metric.metric_tool_version
          (metric_tool_version_uuid, metric_tool_uuid, version_no, version_string, tool_path, checksum)
        values
        ('336e327a-de98-11e6-bf70-001a4a81450b','0726f1df-3e40-11e6-a6cc-001a4a81450b', 2, '1.70', '/swamp/store/SCATools/cloc-1.70.tar.gz',
        '0548025672e536d2c03e385690bdab17d8ae25394581e5d1c821e30936dca21210491c1d9fed662ea732fd7ccea772b30db4717e74c5ab36096273d383a02ec7');
        insert into metric.metric_tool_version
          (metric_tool_version_uuid, metric_tool_uuid, version_no, version_string, tool_path, checksum)
        values
        ('3bd56e00-de98-11e6-bf70-001a4a81450b','9692f64b-3e43-11e6-a6cc-001a4a81450b', 2, '1.12.7', '/swamp/store/SCATools/lizard-1.12.7.tar.gz',
        'b71c323e52b5bf665b9b0596bc709da3ec82c0c64c3836148f987b704947fbb5bea892a30e712533391168fc061a61b7e76d7e554a2103a4b507bf2c620b7fb7');

        # update build system of python packages
        update package_store.package_version set build_system = 'python-setuptools' where build_system = 'setuptools' and package_uuid in (select package_uuid from package_store.package where package_type_id in (4,5));
        update package_store.package_version set build_system = 'python-distutils'  where build_system = 'distutils'  and package_uuid in (select package_uuid from package_store.package where package_type_id in (4,5));

        # Make Web Scripting Pkgs Public
        update package_store.package set package_sharing_status = 'PUBLIC' where package_type_id = 14 and package_owner_uuid = '80835e30-d527-11e2-8b8b-0800200c9a66';
        update package_store.package_version
           set version_sharing_status = 'PUBLIC'
         where package_uuid in (select package_uuid from package_store.package where package_owner_uuid = '80835e30-d527-11e2-8b8b-0800200c9a66' and package_type_id = 14);

        # Fix platform - debian-8.5-64 is now debian-8.6-64
        update platform_store.platform_version
           set version_string = '8.6 64-bit',
               platform_path  = 'debian-8.6-64'
         where platform_version_uuid = '0cda9b68-7c3c-11e6-88bc-001a4a81450b';

        # update database version number
        delete from assessment.database_version where database_version_no = script_version_no;
        insert into assessment.database_version (database_version_no, description) values (script_version_no, 'upgrade to v1.29');

        commit;
      end;
    end if;
END
$$
DELIMITER ;
