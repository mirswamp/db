# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2016 Software Assurance Marketplace

# v1.21
use assessment;
drop PROCEDURE if exists upgrade_43;
DELIMITER $$
CREATE PROCEDURE upgrade_43 ()
  BEGIN
    declare script_version_no int;
    declare cur_db_version_no int;
    set script_version_no = 43;

    select max(database_version_no)
      into cur_db_version_no
      from assessment.database_version;

    if cur_db_version_no < script_version_no then
      begin

        # Additional Android Fields on package version
        ALTER TABLE package_store.package_version ADD COLUMN use_gradle_wrapper tinyint(1) NULL DEFAULT 0 COMMENT 'Use gradle wrapper: 0=false 1=true' AFTER android_redo_build;
        ALTER TABLE package_store.package_version ADD COLUMN android_lint_target VARCHAR(255) NULL DEFAULT NULL COMMENT 'used for android java source code only' AFTER android_sdk_target;
        ALTER TABLE package_store.package_version ADD COLUMN language_version VARCHAR(25) NULL DEFAULT NULL COMMENT 'version of language' AFTER use_gradle_wrapper;
        ALTER TABLE package_store.package_version ADD COLUMN maven_version VARCHAR(25) NULL DEFAULT NULL COMMENT 'maven-version' AFTER language_version;
        ALTER TABLE package_store.package_version ADD COLUMN android_maven_plugin VARCHAR(255) NULL DEFAULT NULL COMMENT 'android-maven-plugin' AFTER maven_version;

        # Ruby Package Type
        insert into package_store.package_type (package_type_id, name) values (8,  'Ruby Sinatra');
        insert into package_store.package_type (package_type_id, name) values (9,  'Ruby on Rails');
        insert into package_store.package_type (package_type_id, name) values (10, 'Ruby Padrino');

        # Remove Android Lint Version 0.0.1
        # convert any assessments that point specifically to android lint version 0.0.1 to "latest"
        update assessment.assessment_run set tool_version_uuid = null where tool_version_uuid = '32eb19f7-8f8c-11e4-829b-001a4a81450b';
        delete from tool_shed.tool_language where tool_version_uuid = '32eb19f7-8f8c-11e4-829b-001a4a81450b';
        delete from tool_shed.tool_version  where tool_version_uuid = '32eb19f7-8f8c-11e4-829b-001a4a81450b';

        # Android Lint: New Version 0.1.4; Language = Android Java Source Code; Platform = Android;
        insert into tool_shed.tool_version
          (tool_version_uuid, tool_uuid, version_string, release_date, comment_public, comment_private,
          tool_path, tool_executable, tool_arguments, tool_directory, checksum)
        values
        ('dcbdab3c-4d8b-11e5-83f1-001a4a81450b','9289b560-8f8b-11e4-829b-001a4a81450b','0.1.4', now(), 'Android Lint 0.1.4', NULL,
        '/swamp/store/SCATools/lint/android-lint-0.1.4.tar.gz', '', '', 'android-lint-0.1.4',
        'c5c8e3cef7ecaab43090189e4a3b3dff45eb5e2909f375180784b041c14a8513cc15f27a505ef79a462536529ba4d5188e854f78afcb3e96773964d5a858082f');
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('9289b560-8f8b-11e4-829b-001a4a81450b', 'dcbdab3c-4d8b-11e5-83f1-001a4a81450b',6);

        # Add New Tool Brakeman 3.05 for Ruby: 1 tool with 1 version. Language = Ruby on Rails; Platform = Scientific Linux 64-bit
          # tool_uuid: 5cd726a5-4053-11e5-83f1-001a4a81450b
          # tool_version_uuid: 6b06aaa6-4053-11e5-83f1-001a4a81450b
        insert into tool_shed.tool
          (tool_uuid, tool_owner_uuid, name, description, tool_sharing_status, is_build_needed) values
          ('5cd726a5-4053-11e5-83f1-001a4a81450b','80835e30-d527-11e2-8b8b-0800200c9a66','Brakeman','An open source vulnerability scanner specifically designed for Ruby on Rails applications. <a href="http://brakemanscanner.org/">http://brakemanscanner.org/</a>', 'PUBLIC',0);
        insert into tool_shed.tool_version
          (tool_version_uuid, tool_uuid, version_string, release_date, comment_public, comment_private,
          tool_path, tool_executable, tool_arguments, tool_directory, checksum)
        values
        ('6b06aaa6-4053-11e5-83f1-001a4a81450b','5cd726a5-4053-11e5-83f1-001a4a81450b','3.05', now(), 'Brakeman 3.05 for Ruby', NULL,
        '/swamp/store/SCATools/brakeman/brakeman-3.0.5.tar.gz', 'brakeman', '', 'brakeman-3.0.5',
        '4ebb31632c96a59e140bcdfc5a400ff92d5d2b50078359fe8b7a0be71d38adeb082e141625dc6278daafafbf0e74a6f805bbb34dd7a075d85ea10f642ad56301');
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('5cd726a5-4053-11e5-83f1-001a4a81450b', '6b06aaa6-4053-11e5-83f1-001a4a81450b',9);
        insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values
          ('5cd726a5-4053-11e5-83f1-001a4a81450b', 'd95fcb5f-209d-11e3-9a3e-001a4a81450b'); # Scientific Linux 64-bit

        # Add New Tool Dawn 1.3.5 for Ruby: 1 tool with 1 version. Languages = Ruby Sinatra, Ruby on Rails, Ruby Padrino; Platform = Scientific Linux 64-bit
          # tool_uuid: b9560648-4057-11e5-83f1-001a4a81450b
          # tool_version_uuid: ca1608e1-4057-11e5-83f1-001a4a81450b
        insert into tool_shed.tool
          (tool_uuid, tool_owner_uuid, name, description, tool_sharing_status, is_build_needed) values
          ('b9560648-4057-11e5-83f1-001a4a81450b','80835e30-d527-11e2-8b8b-0800200c9a66','Dawn','A static analysis security scanner for ruby written web applications. It supports Sinatra, Padrino and Ruby on Rails frameworks. <a href="https://github.com/thesp0nge/dawnscanner">https://github.com/thesp0nge/dawnscanner/</a>', 'PUBLIC',0);
        insert into tool_shed.tool_version
          (tool_version_uuid, tool_uuid, version_string, release_date, comment_public, comment_private,
          tool_path, tool_executable, tool_arguments, tool_directory, checksum)
        values
        ('ca1608e1-4057-11e5-83f1-001a4a81450b','b9560648-4057-11e5-83f1-001a4a81450b','1.3.5', now(), 'Dawn 1.3.5 for Ruby', NULL,
        '/swamp/store/SCATools/dawn/dawnscanner-1.3.5.tar.gz', 'dawn', '', 'dawnscanner-1.3.5',
        '681cafb6433840b24d85a2946815bec50ede17db1306d0afb342d903909192e3fb7106608726d6ba61d609707638c3f0cde738bfbdb06be1947d262f3c5d17f7');
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('b9560648-4057-11e5-83f1-001a4a81450b', 'ca1608e1-4057-11e5-83f1-001a4a81450b',8);
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('b9560648-4057-11e5-83f1-001a4a81450b', 'ca1608e1-4057-11e5-83f1-001a4a81450b',9);
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('b9560648-4057-11e5-83f1-001a4a81450b', 'ca1608e1-4057-11e5-83f1-001a4a81450b',10);
        insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values
          ('b9560648-4057-11e5-83f1-001a4a81450b', 'd95fcb5f-209d-11e3-9a3e-001a4a81450b'); # Scientific Linux 64-bit

        # Update existing version of Reek 2.2.1 - Now compatible with more ruby languages
        update tool_shed.tool_version
           set tool_path = '/swamp/store/SCATools/reek/reek-2.2.1-3.tar.gz',
               checksum  = '7d620aca31234bfcfbd882d49e454ec4a3b7e4bd1c887b062d20ab26a301c38fffafaea47caf1e187345ca818c8cc112788b50141b46aca012d193cb6c436e53'
         where tool_version_uuid = 'bcbfc7d7-1fbc-11e5-b6a7-001a4a81450b';
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('8157e489-1fbc-11e5-b6a7-001a4a81450b', 'bcbfc7d7-1fbc-11e5-b6a7-001a4a81450b',8);
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('8157e489-1fbc-11e5-b6a7-001a4a81450b', 'bcbfc7d7-1fbc-11e5-b6a7-001a4a81450b',9);
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('8157e489-1fbc-11e5-b6a7-001a4a81450b', 'bcbfc7d7-1fbc-11e5-b6a7-001a4a81450b',10);


        # Add New version Reek: 3.1: 1 tool with 1 version. Language = Ruby; Platform = Scientific Linux 64-bit
        insert into tool_shed.tool_version
          (tool_version_uuid, tool_uuid, version_string, release_date, comment_public, comment_private,
          tool_path, tool_executable, tool_arguments, tool_directory, checksum)
        values
        ('7059b296-4c14-11e5-83f1-001a4a81450b','8157e489-1fbc-11e5-b6a7-001a4a81450b','3.1', now(), 'Reek 3.1 for Ruby', NULL,
        '/swamp/store/SCATools/reek/reek-3.1-2.tar.gz', 'reek', '', 'reek-3.1',
        'efdf9e60310d12297c35cf0924f132dd5738e11f7767689efc8aa03b2e4c2d6a0d3d4eecb6b7d4209c12de4b1e4812349e6b02403a51bf9324e9d4000fe53e6f');
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('8157e489-1fbc-11e5-b6a7-001a4a81450b', '7059b296-4c14-11e5-83f1-001a4a81450b',7);
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('8157e489-1fbc-11e5-b6a7-001a4a81450b', '7059b296-4c14-11e5-83f1-001a4a81450b',8);
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('8157e489-1fbc-11e5-b6a7-001a4a81450b', '7059b296-4c14-11e5-83f1-001a4a81450b',9);
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('8157e489-1fbc-11e5-b6a7-001a4a81450b', '7059b296-4c14-11e5-83f1-001a4a81450b',10);

        # Update existing version of RuboCop 0.31 - Now compatible with more ruby languages
        update tool_shed.tool_version
           set tool_path = '/swamp/store/SCATools/rubocop/rubocop-0.31.0-2.tar.gz',
               checksum  = '7d80620f7fd9079fa510f9cff83e0b5aef4602f4d87b8ba271d56481e765ad4251df65dcb72ec6b96623302b11e0cbb69b230b1f1934ea217bcde10c77866bae'
         where tool_version_uuid = 'f5c26a51-0935-11e5-b6a7-001a4a81450b';
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('ebcab7f6-0935-11e5-b6a7-001a4a81450b', 'f5c26a51-0935-11e5-b6a7-001a4a81450b',8);
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('ebcab7f6-0935-11e5-b6a7-001a4a81450b', 'f5c26a51-0935-11e5-b6a7-001a4a81450b',9);
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('ebcab7f6-0935-11e5-b6a7-001a4a81450b', 'f5c26a51-0935-11e5-b6a7-001a4a81450b',10);

        # Add New version RuboCop: 0.33: 1 tool with 1 version. Language = All Ruby Languages; Platform = Scientific Linux 64-bit
        insert into tool_shed.tool_version
          (tool_version_uuid, tool_uuid, version_string, release_date, comment_public, comment_private,
          tool_path, tool_executable, tool_arguments, tool_directory, checksum)
        values
        ('ea1f9693-46ac-11e5-83f1-001a4a81450b','ebcab7f6-0935-11e5-b6a7-001a4a81450b','0.33', now(), 'RuboCop 0.33 for Ruby', NULL,
        '/swamp/store/SCATools/rubocop/rubocop-0.33.0.tar.gz', 'rubocop', '', 'rubocop-0.33.0',
        'af0d107584bf12f3e6e30da75a00e5e45a0adc0a4c3215a04408c649987f432bb4b8e3fd3e7c5382edfab8ebd2d2eedb5269f63d7d5bfde39c29ec3b17397789');
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('ebcab7f6-0935-11e5-b6a7-001a4a81450b', 'ea1f9693-46ac-11e5-83f1-001a4a81450b',7);
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('ebcab7f6-0935-11e5-b6a7-001a4a81450b', 'ea1f9693-46ac-11e5-83f1-001a4a81450b',8);
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('ebcab7f6-0935-11e5-b6a7-001a4a81450b', 'ea1f9693-46ac-11e5-83f1-001a4a81450b',9);
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('ebcab7f6-0935-11e5-b6a7-001a4a81450b', 'ea1f9693-46ac-11e5-83f1-001a4a81450b',10);

        # Add New Tool Red Lizard Goanna: 1 tool with 1 version. Languages = C/C++; Platform = all platforms except android
          # tool_uuid: 0fac7ff8-4c2e-11e5-83f1-001a4a81450b
          # tool_version_uuid: 16dac397-4c2e-11e5-83f1-001a4a81450b
          # tool owner INT: 8b7ff3d7-a334-6b59-54ee-d06bc034745f instead of swa admin: 80835e30-d527-11e2-8b8b-0800200c9a66
          # tool owner PROD: e3bda198-755f-cfae-6fd7-df9b58c5218b
        insert into tool_shed.tool
          (tool_uuid, tool_owner_uuid, name, description, tool_sharing_status, is_build_needed, policy_code) values
          ('0fac7ff8-4c2e-11e5-83f1-001a4a81450b','8b7ff3d7-a334-6b59-54ee-d06bc034745f','Red Lizard Goanna','Red Lizard Goanna for C/C++. <a href="http://redlizards.com/">http://redlizards.com</a>', 'PRIVATE',0, 'red-lizard-user-policy');
        insert into tool_shed.tool_version
          (tool_version_uuid, tool_uuid, version_string, release_date, comment_public, comment_private,
          tool_path, tool_executable, tool_arguments, tool_directory, checksum)
        values
        ('16dac397-4c2e-11e5-83f1-001a4a81450b','0fac7ff8-4c2e-11e5-83f1-001a4a81450b','3.6.1', now(), 'Red Lizard Goanna', NULL,
        '/swamp/store/SCATools/redlizard/rl-goanna-3.6.1.tar', 'goanna-central-linux-release-3.6.1-e1502f9/install-goanna', '--accept --ignore-dashboard --install-dir=goanna-3.6.1-e1502f9 --arch-auto', 'goanna-3.6.1-e1502f9',
        '29082beaf5dda2c241ddd7cd5679ad52242aa618bb57e6296c0c3c40db873dc7887da3c7bf987e27c1c1ceca722a982af73f5ffc3967f516986c7356bd68cce6');
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('0fac7ff8-4c2e-11e5-83f1-001a4a81450b', '16dac397-4c2e-11e5-83f1-001a4a81450b',1);
        insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('0fac7ff8-4c2e-11e5-83f1-001a4a81450b', '1088c3ce-20aa-11e3-9a3e-001a4a81450b'); #cppcheck
        insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('0fac7ff8-4c2e-11e5-83f1-001a4a81450b', '8a51ecea-209d-11e3-9a3e-001a4a81450b'); #cppcheck
        insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('0fac7ff8-4c2e-11e5-83f1-001a4a81450b', 'a4f024eb-f317-11e3-8775-001a4a81450b'); #cppcheck
        insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('0fac7ff8-4c2e-11e5-83f1-001a4a81450b', 'd531f0f0-f273-11e3-8775-001a4a81450b'); #cppcheck
        insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('0fac7ff8-4c2e-11e5-83f1-001a4a81450b', 'd95fcb5f-209d-11e3-9a3e-001a4a81450b'); #Scientific Linux 64-bit
        insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('0fac7ff8-4c2e-11e5-83f1-001a4a81450b', 'ee2c1193-209b-11e3-9a3e-001a4a81450b'); #cppcheck
        insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('0fac7ff8-4c2e-11e5-83f1-001a4a81450b', 'fc55810b-09d7-11e3-a239-001a4a81450b'); #cppcheck

        # Ruby Lint compatilbe with all ruby languages. Was only compatibel with 7, now 8, 9, 10
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('59612f24-0946-11e5-b6a7-001a4a81450b', '6b5624a0-0946-11e5-b6a7-001a4a81450b',8);
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('59612f24-0946-11e5-b6a7-001a4a81450b', '6b5624a0-0946-11e5-b6a7-001a4a81450b',9);
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('59612f24-0946-11e5-b6a7-001a4a81450b', '6b5624a0-0946-11e5-b6a7-001a4a81450b',10);

        # update database version number
        insert into assessment.database_version (database_version_no, description) values (script_version_no, 'upgrade to v1.21');

        commit;
      end;
    end if;
END
$$
DELIMITER ;
