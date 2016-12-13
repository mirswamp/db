# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2016 Software Assurance Marketplace

# v1.28
use assessment;
drop PROCEDURE if exists upgrade_51;
DELIMITER $$
CREATE PROCEDURE upgrade_51 ()
  BEGIN
    declare script_version_no int;
    declare cur_db_version_no int;
    set script_version_no = 51;

    select max(database_version_no)
      into cur_db_version_no
      from assessment.database_version;

    if cur_db_version_no < script_version_no then
      begin

        # Remove Constraint
        if exists (select * from information_schema.key_column_usage where constraint_name = 'fk_tool_platform_p') then
            alter table tool_shed.tool_platform drop foreign key fk_tool_platform_p;
        end if;

        # updated tool versions: drop in replacements of existing version
          # remove Bandit 8ba3536
          # android-lint-0.1.4-2.tar.gz
          # bandit-py2-0.14.0-4.tar.gz
          # bandit-py3-0.14.0-4.tar.gz
          # clang-sa-3.3-1.tar
          # clang-sa-3.7.0-1.tar
          # clang-sa-3.8.0-1.tar
          # cppcheck-1.61-1.tar
          # cppcheck-1.70-1.tar
          # cppcheck-1.71-1.tar
          # cppcheck-1.72-1.tar
          # cppcheck-1.73-1.tar
          # ps-ctest-9.5.4.103-1.tar
          # ps-ctest-9.5.6.26-1.tar
          # ps-ctest-9.6.1.91-1.tar
          # ps-jtest-9.5.13-9.tar
          # ps-jtest-9.5.14-9.tar
          # ps-jtest-9.6.0-9.tar
          # cloc-1.68.tar.gz
          # lizard-1.12.6.tar.gz
          update tool_shed.tool_version set tool_path = '/swamp/store/SCATools/lint/android-lint-0.1.4-2.tar.gz',  checksum = '2c0fe4bfb26dd0d024f4e3107ad9b00d7a9d0aad8d03a82838504228b0c68112d79f8e01d079a382028116c415e41dad840e6d40cff653a8708ea38f3606be74' where tool_version_uuid = 'dcbdab3c-4d8b-11e5-83f1-001a4a81450b';
          update tool_shed.tool_version set tool_path = '/swamp/store/SCATools/clang/clang-sa-3.3-1.tar',          checksum = 'b374f85530bfd3924cfb370bf18538b3bf32cada2ae61471fec419b929a8d6e2ba597340a09a1b7482e078a479f1b343b75ff1307d9e0aec44ced91b858bcda8' where tool_version_uuid = '8ec206ff-f59b-11e3-8775-001a4a81450b';
          update tool_shed.tool_version set tool_path = '/swamp/store/SCATools/clang/clang-sa-3.7.0-1.tar',        checksum = '28aa0f195a7b3880145a2d82cbeeeaed77b3e739f053ae820ad61304be0185d62715c6e4007f063999f02c12de51d375a11aa99f622783e0175286da4a1ef34d' where tool_version_uuid = '90554576-81a0-11e5-865f-001a4a81450b';
          update tool_shed.tool_version set tool_path = '/swamp/store/SCATools/clang/clang-sa-3.8.0-1.tar',        checksum = '58c466f41a1c6b50e006103c3ff034a6722ae27dbf4196ba9bf3e1223924a12bbc5a37f2d311c75d1727682cd87ff741078d7f3b0912adcc801494c455e7d030' where tool_version_uuid = 'ea38477e-16cc-11e6-807f-001a4a81450b';
          update tool_shed.tool_version set tool_path = '/swamp/store/SCATools/cppcheck/cppcheck-1.61-1.tar',      checksum = 'cf58d937ca38184fe89d3b53f68f71f0d0c97bddba40baaee2aab8682e122a6b9938844735eb55c8fe86a211603a7f4e468d5ecdebea6b46bf8f9d8bf47f4035' where tool_version_uuid = '950734d0-f59b-11e3-8775-001a4a81450b';
          update tool_shed.tool_version set tool_path = '/swamp/store/SCATools/cppcheck/cppcheck-1.70-1.tar',      checksum = '45671c14d409f186e431b74140eeb7421d405f233ccd09054663e8f97b002aef0fe7b22a3a51ee4897775a4d4e3286ff47f98e44f01326189eee0473198589de' where tool_version_uuid = 'e9cea65f-833e-11e5-865f-001a4a81450b';
          update tool_shed.tool_version set tool_path = '/swamp/store/SCATools/cppcheck/cppcheck-1.71-1.tar',      checksum = '0ea979ed9498c69ecd51b66d709640da3ad0768e1cdbbb664fb72bb631f17f36a84271069bba87231ec6a46d739e6bac95995337705ce1f8b6fdb0f751d4b9c1' where tool_version_uuid = '7b504c42-bf06-11e5-832a-001a4a81450b';
          update tool_shed.tool_version set tool_path = '/swamp/store/SCATools/cppcheck/cppcheck-1.72-1.tar',      checksum = 'da2c0b736c1850c3e955e7fa19a4ffb9dfb6e97cb482a4df347c8a67424733948d870de0ec25947718ca1feee9271c608fb21883db73808edd1c245bb2cd50b5' where tool_version_uuid = '1c9a1589-bf05-11e5-832a-001a4a81450b';
          update tool_shed.tool_version set tool_path = '/swamp/store/SCATools/cppcheck/cppcheck-1.73-1.tar',      checksum = '035438fc3c61203126b0655d4f3a878d0d82267a9e1a069dc16bc459ae468d2cca3be62f5d884f651c864ba052b47f0c05081d2d69b1feb4dfd2065393d3fe21' where tool_version_uuid = 'b9045569-16cc-11e6-807f-001a4a81450b';
          update tool_shed.tool_version set tool_path = '/swamp/store/SCATools/parasoft/ps-ctest-9.5.4.103-1.tar', checksum = '7c58d3716ee541690cf9a6793f4d83ff8dd9649c9be44063f153ed15bcfc359e4a36b0d0a822f726a77e4961c4b943942789550503f089230e757c43489d9467' where tool_version_uuid = '0b384dc1-6441-11e4-a282-001a4a81450b';
          update tool_shed.tool_version set tool_path = '/swamp/store/SCATools/parasoft/ps-ctest-9.5.6.26-1.tar',  checksum = '55ec45f2cd3158bfe3fd049b0cff8ead30dad051d5af7e2995973730b9995b29ce5bfcabb2b8c3f233ff2658ddbeb17d088f489276694e9afc454ae05d1fccb5' where tool_version_uuid = '92e94ec4-bf07-11e5-832a-001a4a81450b';
          update tool_shed.tool_version set tool_path = '/swamp/store/SCATools/parasoft/ps-ctest-9.6.1.91-1.tar',  checksum = '3693d156b810ea6482761faaed6e5bd6fc5bcbb5536c5ba23123eb6ae63e01c8ac181ecfbf4862a880b5f545c7683da8bebc3e5f15bc725b5cb16b8438a8c508' where tool_version_uuid = '53fc0641-e094-11e5-ae56-001a4a81450b';
          update tool_shed.tool_version set tool_path = '/swamp/store/SCATools/parasoft/ps-jtest-9.5.13-9.tar',    checksum = 'de82d8843e232e61fb7833f819e5ec2576f4594728827d17f9fbd36a552f0744e4a60f574636a9d779baebb14e546ad0389a57d2b63e320061a7dff0e422ce1b' where tool_version_uuid = '18532f08-6441-11e4-a282-001a4a81450b';
          update tool_shed.tool_version set tool_path = '/swamp/store/SCATools/parasoft/ps-jtest-9.5.14-9.tar',    checksum = '2e16e2fb1461470e42f20e36426ad58518ea9f11fc8b5c9fecc1127abc0056019c13d580404444b96d7945695aca79cb3a7ee1c6f1befe2b3c58cd9d1a391b79' where tool_version_uuid = '93334c42-e099-11e5-ae56-001a4a81450b';
          update tool_shed.tool_version set tool_path = '/swamp/store/SCATools/parasoft/ps-jtest-9.6.0-9.tar',     checksum = '55e3355bdab417103d0228b4d42e40d0e743cbca170d45fa19d0de20559033a39c808ed093f1d8f5d3ff75b62d6442edfe6f3a806cb0d555dadc6b54507e2f9b' where tool_version_uuid = 'd08f0ae9-f69b-11e5-ae56-001a4a81450b';
          update metric.metric_tool_version set tool_path = '/swamp/store/SCATools/cloc/cloc-1.68.tar', checksum = 'c49769222abb157083256750ba4ece3b7040cee40ed046ec5b939fe351aab542fb5bbfead91161ccff9c5741449f6e344006b272583bbb13db708409cd27c6c0',
                                                version_string = '1.68' where metric_tool_version_uuid = '129d61a0-3e40-11e6-a6cc-001a4a81450b';
          update metric.metric_tool_version set tool_path = '/swamp/store/SCATools/lizard/lizard-1.12.6.tar.gz', checksum = 'ba04a305549e65d730890ca5a3db0677baa0f1a1a09eed4b0d2740ca79038c56fae5cfda0ff96424da66b801749084423b582cb415d9d2e79fbdeebd84866b47',
                                                version_string = '1.12.6' where metric_tool_version_uuid = 'a6e4d49b-3e43-11e6-a6cc-001a4a81450b';

        # Python Bandit - Remove version 8ba3536 - null out if specified on any assessment_run records
          delete from tool_shed.tool_language where tool_version_uuid = '9cbd0e60-8f9f-11e4-829b-001a4a81450b';
          delete from tool_shed.tool_version where tool_version_uuid = '9cbd0e60-8f9f-11e4-829b-001a4a81450b';
          update assessment.assessment_run set tool_version_uuid = null where tool_version_uuid = '9cbd0e60-8f9f-11e4-829b-001a4a81450b';

        # Python Bandit - Update Existing Versions - specialized_tool_version
        update tool_shed.specialized_tool_version
           set tool_path = '/swamp/store/SCATools/bandit/bandit-py2-0.14.0-4.tar.gz',
               checksum = '643a3f99ec6453a47a24e55d3dd16b65e41268becbba71aac9a897dd088e6f7c5e5c380ef4a13df4e222471847f4dcef491f0c10b8ec4d31352be67322cf6806'
          where specialized_tool_version_uuid = '7774f01a-7449-11e5-865f-001a4a81450b';
        update tool_shed.specialized_tool_version
           set tool_path = '/swamp/store/SCATools/bandit/bandit-py3-0.14.0-4.tar.gz',
               checksum = '38a9e3eb1a0a8a3586808f83b266216c35ef97a9f8015c5640a0ff6c6c50507b7d5e4cefddb34d8f8bbc1a7d8a320459b9a60da81a9c7df951e7e35fd32b8b54'
          where specialized_tool_version_uuid = '88be0c6b-7449-11e5-865f-001a4a81450b';

        # cppcheck - new version 1.74: 1 version. Not using the specialized tool table Language = C/C++; Platform = All Platforms Except Android
          # tool_uuid:         163e5d8c-156e-11e3-a239-001a4a81450b
          # tool_version_uuid: b82a731e-7b79-11e6-88bc-001a4a81450b
          # tool_shed.tool_platform records already exist. They're for the tool, not specific to tool version.
        delete from tool_shed.tool_language where tool_version_uuid = 'b82a731e-7b79-11e6-88bc-001a4a81450b';
        delete from tool_shed.tool_version  where tool_version_uuid = 'b82a731e-7b79-11e6-88bc-001a4a81450b';
        insert into tool_shed.tool_version
          (tool_version_uuid, tool_uuid, version_string, release_date, comment_public, comment_private,
          tool_path, tool_executable, tool_arguments, tool_directory, checksum)
        values
        ('b82a731e-7b79-11e6-88bc-001a4a81450b','163e5d8c-156e-11e3-a239-001a4a81450b','1.74', now(), 'Cppcheck 1.74', NULL,
        '/swamp/store/SCATools/cppcheck/cppcheck-1.74-1.tar', 'bin/cppcheck', '', 'cppcheck-1.74',
        '603297b8584612027152af74e8cfdadd6e20fc31f9135ca4ac4ad1e83b33e12c13172a75c38f2062edda370a92ec9e05d9b309be7d9295e1bacef9ca7d68da46');
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('163e5d8c-156e-11e3-a239-001a4a81450b', 'b82a731e-7b79-11e6-88bc-001a4a81450b',1);

        # cppcheck - new version 1.75: 1 version. Not using the specialized tool table Language = C/C++; Platform = All Platforms Except Android
          # tool_uuid:         163e5d8c-156e-11e3-a239-001a4a81450b
          # tool_version_uuid: edef671e-7b79-11e6-88bc-001a4a81450b
          # tool_shed.tool_platform records already exist. They're for the tool, not specific to tool version.
        delete from tool_shed.tool_language where tool_version_uuid = 'edef671e-7b79-11e6-88bc-001a4a81450b';
        delete from tool_shed.tool_version  where tool_version_uuid = 'edef671e-7b79-11e6-88bc-001a4a81450b';
        insert into tool_shed.tool_version
          (tool_version_uuid, tool_uuid, version_string, release_date, comment_public, comment_private,
          tool_path, tool_executable, tool_arguments, tool_directory, checksum)
        values
        ('edef671e-7b79-11e6-88bc-001a4a81450b','163e5d8c-156e-11e3-a239-001a4a81450b','1.75', now(), 'Cppcheck 1.75', NULL,
        '/swamp/store/SCATools/cppcheck/cppcheck-1.75-1.tar', 'bin/cppcheck', '', 'cppcheck-1.75',
        'c2701b4950a90ebd635c5b181e0b37a176916f4bb2f4d4b68d341c0b7bc08b1da488a4a00603f3d0e25c06c1274ed116a1882af8657cefdfd8520b042574ab05');
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('163e5d8c-156e-11e3-a239-001a4a81450b', 'edef671e-7b79-11e6-88bc-001a4a81450b',1);

        # New Tool OWASP Dependency Check: 1 tool with 1 version. Language = Java & Android; Platform = All Platforms?
          # tool_uuid: d032d8ec-9184-11e6-88bc-001a4a81450b
          # tool_version_uuid: e3466345-9184-11e6-88bc-001a4a81450b
        delete from tool_shed.tool_viewer_incompatibility where tool_uuid = 'd032d8ec-9184-11e6-88bc-001a4a81450b';
        delete from tool_shed.tool_platform where tool_uuid = 'd032d8ec-9184-11e6-88bc-001a4a81450b';
        delete from tool_shed.tool_language where tool_uuid = 'd032d8ec-9184-11e6-88bc-001a4a81450b';
        delete from tool_shed.tool_version  where tool_uuid = 'd032d8ec-9184-11e6-88bc-001a4a81450b';
        delete from tool_shed.tool          where tool_uuid = 'd032d8ec-9184-11e6-88bc-001a4a81450b';
        insert into tool_shed.tool
          (tool_uuid, tool_owner_uuid, name, description, tool_sharing_status, is_build_needed) values
          ('d032d8ec-9184-11e6-88bc-001a4a81450b','80835e30-d527-11e2-8b8b-0800200c9a66','OWASP Dependency Check','Dependency-Check is a utility that identifies project dependencies and checks if there are any known, publicly disclosed, vulnerabilities. <a href="https://www.owasp.org/index.php/OWASP_Dependency_Check">https://www.owasp.org/index.php/OWASP_Dependency_Check</a>', 'PUBLIC',0);
        insert into tool_shed.tool_version
          (tool_version_uuid, tool_uuid, version_string, release_date, comment_public, comment_private,
          tool_path, tool_executable, tool_arguments, tool_directory, checksum)
        values
        ('e3466345-9184-11e6-88bc-001a4a81450b','d032d8ec-9184-11e6-88bc-001a4a81450b','1.4.3', now(), 'OWASP Dependency Check 1.4.3', NULL,
        '/swamp/store/SCATools/dependency-check/dependency-check-1.4.3-3.tar.gz', null, null, null,
        'c65d1e83adbc80f4e2d8c0c8e9340a3baa65983c99a8f0359c5c705bc632ad28d6383ee3dd5d8cbe5acce510904951fc531d9c0c922fb6e1ec55357a45c79b04');
        # insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('d032d8ec-9184-11e6-88bc-001a4a81450b', 'e3466345-9184-11e6-88bc-001a4a81450b',1);  # C/C++
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('d032d8ec-9184-11e6-88bc-001a4a81450b', 'e3466345-9184-11e6-88bc-001a4a81450b',2);  # Java Source Code
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('d032d8ec-9184-11e6-88bc-001a4a81450b', 'e3466345-9184-11e6-88bc-001a4a81450b',3);  # Java Bytecode
        # insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('d032d8ec-9184-11e6-88bc-001a4a81450b', 'e3466345-9184-11e6-88bc-001a4a81450b',4);  # Python2
        # insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('d032d8ec-9184-11e6-88bc-001a4a81450b', 'e3466345-9184-11e6-88bc-001a4a81450b',5);  # Python3
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('d032d8ec-9184-11e6-88bc-001a4a81450b', 'e3466345-9184-11e6-88bc-001a4a81450b',6);  # Android Java Source Code
        # insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('d032d8ec-9184-11e6-88bc-001a4a81450b', 'e3466345-9184-11e6-88bc-001a4a81450b',7);  # Ruby
        # insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('d032d8ec-9184-11e6-88bc-001a4a81450b', 'e3466345-9184-11e6-88bc-001a4a81450b',8);  # Ruby Sinatra
        # insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('d032d8ec-9184-11e6-88bc-001a4a81450b', 'e3466345-9184-11e6-88bc-001a4a81450b',9);  # Ruby on Rails
        # insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('d032d8ec-9184-11e6-88bc-001a4a81450b', 'e3466345-9184-11e6-88bc-001a4a81450b',10); # Ruby Padrino
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('d032d8ec-9184-11e6-88bc-001a4a81450b', 'e3466345-9184-11e6-88bc-001a4a81450b',11); # Android .apk
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('d032d8ec-9184-11e6-88bc-001a4a81450b', 'e3466345-9184-11e6-88bc-001a4a81450b',12); # Java 8 Source Code
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('d032d8ec-9184-11e6-88bc-001a4a81450b', 'e3466345-9184-11e6-88bc-001a4a81450b',13); # Java 8 Bytecode
        insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('d032d8ec-9184-11e6-88bc-001a4a81450b', '48f9a9b0-976f-11e4-829b-001a4a81450b'); # Android
        insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('d032d8ec-9184-11e6-88bc-001a4a81450b', '4604e180-7c3a-11e6-88bc-001a4a81450b'); # CentOS Linux 5 32-bit
        insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('d032d8ec-9184-11e6-88bc-001a4a81450b', '9369ab7a-7c3a-11e6-88bc-001a4a81450b'); # CentOS Linux 5 62-bit
        insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('d032d8ec-9184-11e6-88bc-001a4a81450b', 'ef10a44c-7c3a-11e6-88bc-001a4a81450b'); # CentOS Linux 6 32-bit
        insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('d032d8ec-9184-11e6-88bc-001a4a81450b', '071890c4-7c3b-11e6-88bc-001a4a81450b'); # CentOS Linux 6 64-bit
        insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('d032d8ec-9184-11e6-88bc-001a4a81450b', 'ee2c1193-209b-11e3-9a3e-001a4a81450b'); # Debian Linux
        insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('d032d8ec-9184-11e6-88bc-001a4a81450b', '8a51ecea-209d-11e3-9a3e-001a4a81450b'); # Fedora Linux
        insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('d032d8ec-9184-11e6-88bc-001a4a81450b', 'd531f0f0-f273-11e3-8775-001a4a81450b'); # Red Hat Enterprise Linux 6 32-bit
        insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('d032d8ec-9184-11e6-88bc-001a4a81450b', 'fc55810b-09d7-11e3-a239-001a4a81450b'); # Red Hat Enterprise Linux 6 64-bit
        insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('d032d8ec-9184-11e6-88bc-001a4a81450b', 'a4f024eb-f317-11e3-8775-001a4a81450b'); # Scientific Linux 5 32-bit
        insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('d032d8ec-9184-11e6-88bc-001a4a81450b', '03e6bc67-7c3f-11e6-88bc-001a4a81450b'); # Scientific Linux 5 64-bit
        insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('d032d8ec-9184-11e6-88bc-001a4a81450b', '8d5b61ff-7c3f-11e6-88bc-001a4a81450b'); # Scientific Linux 6 32-bit
        insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('d032d8ec-9184-11e6-88bc-001a4a81450b', 'd95fcb5f-209d-11e3-9a3e-001a4a81450b'); # Scientific Linux 6 64-bit
        insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('d032d8ec-9184-11e6-88bc-001a4a81450b', '1088c3ce-20aa-11e3-9a3e-001a4a81450b'); # Ubuntu Linux
        insert into tool_shed.tool_viewer_incompatibility (tool_uuid, viewer_uuid) values ('d032d8ec-9184-11e6-88bc-001a4a81450b', 'a0e1d0fb-bfb2-11e5-bf72-001a4a814413'); # incompatible with ThreadFix.

        ########
        # Platforms
        delete from platform_store.platform_version;
        delete from platform_store.platform;
        INSERT INTO platform_store.platform (platform_uuid, platform_sharing_status, name) VALUES
        ('48f9a9b0-976f-11e4-829b-001a4a81450b','PUBLIC','Android'),
        ('4604e180-7c3a-11e6-88bc-001a4a81450b','PUBLIC','CentOS Linux 5 32-bit'),
        ('9369ab7a-7c3a-11e6-88bc-001a4a81450b','PUBLIC','CentOS Linux 5 64-bit'),
        ('ef10a44c-7c3a-11e6-88bc-001a4a81450b','PUBLIC','CentOS Linux 6 32-bit'),
        ('071890c4-7c3b-11e6-88bc-001a4a81450b','PUBLIC','CentOS Linux 6 64-bit'),
        ('ee2c1193-209b-11e3-9a3e-001a4a81450b','PUBLIC','Debian Linux'),
        ('8a51ecea-209d-11e3-9a3e-001a4a81450b','PUBLIC','Fedora Linux'),
        ('d531f0f0-f273-11e3-8775-001a4a81450b','PUBLIC','Red Hat Enterprise Linux 6 32-bit'),
        ('fc55810b-09d7-11e3-a239-001a4a81450b','PUBLIC','Red Hat Enterprise Linux 6 64-bit'),
        ('a4f024eb-f317-11e3-8775-001a4a81450b','PUBLIC','Scientific Linux 5 32-bit'),
        ('03e6bc67-7c3f-11e6-88bc-001a4a81450b','PUBLIC','Scientific Linux 5 64-bit'),
        ('8d5b61ff-7c3f-11e6-88bc-001a4a81450b','PUBLIC','Scientific Linux 6 32-bit'),
        ('d95fcb5f-209d-11e3-9a3e-001a4a81450b','PUBLIC','Scientific Linux 6 64-bit'),
        ('1088c3ce-20aa-11e3-9a3e-001a4a81450b','PUBLIC','Ubuntu Linux');

        INSERT INTO platform_store.platform_version (platform_uuid, platform_version_uuid, version_no, version_string, platform_path) VALUES
        # Android
          # Android on Ubuntu 12.04 64-bit
               ('48f9a9b0-976f-11e4-829b-001a4a81450b','8f4878ec-976f-11e4-829b-001a4a81450b',1,'Android on Ubuntu 12.04 64-bit','android-ubuntu-12.04-64'),
        # CentOS Linux 5 32-bit
          # 5.11 32-bit
               ('4604e180-7c3a-11e6-88bc-001a4a81450b','73c7f6be-7c3a-11e6-88bc-001a4a81450b',1,'5.11 32-bit','centos-5.11-32'),
        # CentOS Linux 5 64-bit
          # 5.11 64-bit
               ('9369ab7a-7c3a-11e6-88bc-001a4a81450b','bf9ddb9c-7c3a-11e6-88bc-001a4a81450b',1,'5.11 64-bit','centos-5.11-64'),
        # CentOS Linux 6 32-bit
          # 6.7 32-bit
               ('ef10a44c-7c3a-11e6-88bc-001a4a81450b','fa5ee864-7c3a-11e6-88bc-001a4a81450b',1,'6.7 32-bit','centos-6.7-32'),
        # CentOS Linux 6 64-bit
          # 6.7 64-bit
               ('071890c4-7c3b-11e6-88bc-001a4a81450b','1c5cbe39-7c3b-11e6-88bc-001a4a81450b',1,'6.7 64-bit','centos-6.7-64'),
        # Debian Linux
          # 7.0 64-bit (depricated)
          # 7.11 64-bit
          # 8.5 64-bit
               # ('ee2c1193-209b-11e3-9a3e-001a4a81450b','00f3ff35-209c-11e3-9a3e-001a4a81450b',1,'7.0 64-bit','debian-7.0-64'),
               ('ee2c1193-209b-11e3-9a3e-001a4a81450b','eaa6cf77-7c3b-11e6-88bc-001a4a81450b',1,'7.11 64-bit','debian-7.11-64'),
               ('ee2c1193-209b-11e3-9a3e-001a4a81450b','0cda9b68-7c3c-11e6-88bc-001a4a81450b',2,'8.5 64-bit','debian-8.5-64'),
        # Fedora Linux
          # 18 64-bit
          # 19 64-bit
          # 20 64-bit
          # 21 64-bit
          # 22 64-bit
          # 23 64-bit
          # 24 64-bit
               ('8a51ecea-209d-11e3-9a3e-001a4a81450b','a9cfe21f-209d-11e3-9a3e-001a4a81450b',1,'18 64-bit','fedora-18-64'),
               ('8a51ecea-209d-11e3-9a3e-001a4a81450b','aebc38c3-209d-11e3-9a3e-001a4a81450b',2,'19 64-bit','fedora-19-64'),
               ('8a51ecea-209d-11e3-9a3e-001a4a81450b','89b4f7fd-7c3d-11e6-88bc-001a4a81450b',3,'20 64-bit','fedora-20-64'),
               ('8a51ecea-209d-11e3-9a3e-001a4a81450b','8efe5502-7c3d-11e6-88bc-001a4a81450b',4,'21 64-bit','fedora-21-64'),
               ('8a51ecea-209d-11e3-9a3e-001a4a81450b','9e559543-7c3d-11e6-88bc-001a4a81450b',5,'22 64-bit','fedora-22-64'),
               ('8a51ecea-209d-11e3-9a3e-001a4a81450b','a41798c7-7c3d-11e6-88bc-001a4a81450b',6,'23 64-bit','fedora-23-64'),
               ('8a51ecea-209d-11e3-9a3e-001a4a81450b','b0425ce1-7c3d-11e6-88bc-001a4a81450b',7,'24 64-bit','fedora-24-64'),
        # Red Hat Enterprise Linux 6 32-bit
          # RHEL6.4 32-bit (depricated)
          # 6.7 32-bit
               # ('d531f0f0-f273-11e3-8775-001a4a81450b','051f9447-209e-11e3-9a3e-001a4a81450b',1,'RHEL6.4 32-bit','rhel-6.4-32'),
               ('d531f0f0-f273-11e3-8775-001a4a81450b','f272a429-7c3d-11e6-88bc-001a4a81450b',1,'6.7 32-bit','rhel-6.7-32'),
        # Red Hat Enterprise Linux 6 64-bit
          # RHEL6.4 64-bit (depricated)
          # 6.7 64-bit
               # ('fc55810b-09d7-11e3-a239-001a4a81450b','fc5737ef-09d7-11e3-a239-001a4a81450b',1,'RHEL6.4 64-bit','rhel-6.4-64'),
               ('fc55810b-09d7-11e3-a239-001a4a81450b','a75ddd12-7c3e-11e6-88bc-001a4a81450b',1,'6.7 64-bit','rhel-6.7-64'),
        # Scientific Linux 5 32-bit
          # 5.9 32-bit (depricated)
          # 5.11 32-bit
               #('a4f024eb-f317-11e3-8775-001a4a81450b','35bc77b9-7d3e-11e3-88bb-001a4a81450b',1,'5.9 32-bit','scientific-5.9-32'),
               ('a4f024eb-f317-11e3-8775-001a4a81450b','e7959cde-7c3e-11e6-88bc-001a4a81450b',1,'5.11 32-bit','scientific-5.11-32'),
        # Scientific Linux 5 64-bit
          # 5.9 64-bit (depricated)
          # 5.11 64-bit
               # ('03e6bc67-7c3f-11e6-88bc-001a4a81450b','27f0588b-209e-11e3-9a3e-001a4a81450b',1,'5.9 64-bit','scientific-5.9-64'),
               ('03e6bc67-7c3f-11e6-88bc-001a4a81450b','54053a13-7c3f-11e6-88bc-001a4a81450b',1,'5.11 64-bit','scientific-5.11-64'),
        # Scientific Linux 6 32-bit
          # 6.7 32-bit
               ('8d5b61ff-7c3f-11e6-88bc-001a4a81450b','a72c3ab6-7c3f-11e6-88bc-001a4a81450b',1,'6.7 32-bit','scientific-6.7-32'),
        # Scientific Linux 6 64-bit
          # 6.4 64-bit (depricated)
          # 6.7 64-bit
               #('d95fcb5f-209d-11e3-9a3e-001a4a81450b','e16f4023-209d-11e3-9a3e-001a4a81450b',1,'6.4 64-bit','scientific-6.4-64'),
               ('d95fcb5f-209d-11e3-9a3e-001a4a81450b','eacab258-7c3f-11e6-88bc-001a4a81450b',1,'6.7 64-bit','scientific-6.7-64'),
        # Ubuntu Linux
          # 10.04 LTS 64-bit Lucid Lynx
          # 12.04 LTS 64-bit Precise Pangolin
          # 14.04 LTS 64-bit Trusty Tahr
          # 16.04 LTS 64-bit Xenial Xerus
               ('1088c3ce-20aa-11e3-9a3e-001a4a81450b','f496f2ae-7c40-11e6-88bc-001a4a81450b',1,'10.04 LTS 64-bit Lucid Lynx',      'ubuntu-10.04-64'),
               ('1088c3ce-20aa-11e3-9a3e-001a4a81450b','18f66e9a-20aa-11e3-9a3e-001a4a81450b',2,'12.04 LTS 64-bit Precise Pangolin','ubuntu-12.04-64'),
               ('1088c3ce-20aa-11e3-9a3e-001a4a81450b','fd924363-7c40-11e6-88bc-001a4a81450b',3,'14.04 LTS 64-bit Trusty Tahr',      'ubuntu-14.04-64'),
               ('1088c3ce-20aa-11e3-9a3e-001a4a81450b','03b18efe-7c41-11e6-88bc-001a4a81450b',4,'16.04 LTS 64-bit Xenial Xerus',     'ubuntu-16.04-64');

        # platform tool compatibilities
          # All platforms work with all tools
          # except Android platform only works with android and java tools.
        delete from tool_shed.tool_platform;
        insert into tool_shed.tool_platform (platform_uuid, tool_uuid)
          select p.platform_uuid, t.tool_uuid
            from platform_store.platform p
            join tool_shed.tool t
           where p.platform_uuid != '48f9a9b0-976f-11e4-829b-001a4a81450b' # Platform: Android
             and t.tool_uuid != '9289b560-8f8b-11e4-829b-001a4a81450b'     # Tool: Android lint
             and t.tool_uuid != '738b81f0-a828-11e5-865f-001a4a81450b'     # Tool: RevealDroid
             ;
        insert into tool_shed.tool_platform (platform_uuid, tool_uuid)
          select p.platform_uuid, t.tool_uuid
            from platform_store.platform p
            join tool_shed.tool t
           where p.platform_uuid = '48f9a9b0-976f-11e4-829b-001a4a81450b' # Platform: Android
             and t.tool_uuid in ('9289b560-8f8b-11e4-829b-001a4a81450b',  # Tool: Android lint
                                 '738b81f0-a828-11e5-865f-001a4a81450b',  # Tool: RevealDroid
                                 '163d56a7-156e-11e3-a239-001a4a81450b',  # Tool: Findbugs
                                 '163f2b01-156e-11e3-a239-001a4a81450b',  # Tool: PMD
                                 '6197a593-6440-11e4-a282-001a4a81450b',  # Tool: Parasoft Jtest
                                 '992A48A5-62EC-4EE9-8429-45BB94275A41',  # Tool: checkstyle
                                 '56872C2E-1D78-4DB0-B976-83ACF5424C52'   # Tool: error-prone
             );

        # Set Default platforms for package type
          # All default to Ubuntu Linux (1088c3ce-20aa-11e3-9a3e-001a4a81450b)
          # except Android (6,11) which defaults to Android (48f9a9b0-976f-11e4-829b-001a4a81450b)
        update package_store.package_type set default_platform_uuid = '1088c3ce-20aa-11e3-9a3e-001a4a81450b';
        update package_store.package_type set default_platform_uuid = '48f9a9b0-976f-11e4-829b-001a4a81450b' where package_type_id in (6,11);

        # assessment runs may have a null platform uuid which indicates that the default platform should be used.
        alter table assessment.assessment_run change column platform_uuid platform_uuid VARCHAR(45) NULL COMMENT 'if null, then default platform';

        # convert applicable existing assessments to use default platform. This would be all assessments that use package_type where platform_user_selectable = 0;
        update assessment.assessment_run
           set platform_uuid = null,
               platform_version_uuid = null
         where package_uuid in (select package_uuid
                                  from package_store.package
                                 where package_type_id != 1);

        # update database version number
        delete from assessment.database_version where database_version_no = script_version_no;
        insert into assessment.database_version (database_version_no, description) values (script_version_no, 'upgrade to v1.28');

        commit;
      end;
    end if;
END
$$
DELIMITER ;
