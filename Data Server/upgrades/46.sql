# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2017 Software Assurance Marketplace

# v1.24
use assessment;
drop PROCEDURE if exists upgrade_46;
DELIMITER $$
CREATE PROCEDURE upgrade_46 ()
  BEGIN
    declare script_version_no int;
    declare cur_db_version_no int;
    set script_version_no = 46;

    select max(database_version_no)
      into cur_db_version_no
      from assessment.database_version;

    if cur_db_version_no < script_version_no then
      begin

        # Python Bandit - Update Existing Versions
        update tool_shed.tool_version
           set tool_path = '/swamp/store/SCATools/bandit/bandit-8ba3536-3.tar.gz',
               checksum = '6097a4b9d5b2663c965d1e07bb96e54b75f05e81fc7370652470c6113045720239a428d2f21ea366912b77fb54e77f637a1d741b1cb676ce3d7c067b9209f762'
          where tool_version_uuid = '9cbd0e60-8f9f-11e4-829b-001a4a81450b';
        update tool_shed.specialized_tool_version
           set tool_path = '/swamp/store/SCATools/bandit/bandit-py2-0.14.0-2.tar.gz',
               checksum = '7410c29f5c9b22dd7145642fabbe3153a5f1a97086ea010575ace7ee301f8fc0a0fbe8c1f761600a832741416fd7f708e34eb05eca2e83532e8ae813ab091f9b'
          where specialized_tool_version_uuid = '7774f01a-7449-11e5-865f-001a4a81450b';
        update tool_shed.specialized_tool_version
           set tool_path = '/swamp/store/SCATools/bandit/bandit-py3-0.14.0-2.tar.gz',
               checksum = '88bc97b259ea41630be509100a7e88e3495a846b3cec2257900dc716eefc9405de1538a22363e53082bcf43e105ea4fdcb40bc2e1b6d33b408ad9cef3350f1e3'
          where specialized_tool_version_uuid = '88be0c6b-7449-11e5-865f-001a4a81450b';

        # cppcheck - new version 1.71: 1 version. Not using the specialized tool table Language = C/C++; Platform = All Platforms Except Android
          # tool_uuid:         163e5d8c-156e-11e3-a239-001a4a81450b
          # tool_version_uuid: 7b504c42-bf06-11e5-832a-001a4a81450b
          # tool_shed.tool_platform records already exist. They're for the tool, not specific to tool version.
        delete from tool_shed.tool_language where tool_version_uuid = '7b504c42-bf06-11e5-832a-001a4a81450b';
        delete from tool_shed.tool_version  where tool_version_uuid = '7b504c42-bf06-11e5-832a-001a4a81450b';
        insert into tool_shed.tool_version
          (tool_version_uuid, tool_uuid, version_string, release_date, comment_public, comment_private,
          tool_path, tool_executable, tool_arguments, tool_directory, checksum)
        values
        ('7b504c42-bf06-11e5-832a-001a4a81450b','163e5d8c-156e-11e3-a239-001a4a81450b','1.71', now(), 'Cppcheck 1.71', NULL,
        '/swamp/store/SCATools/cppcheck/cppcheck-1.71.tar', 'bin/cppcheck', '', 'cppcheck-1.71',
        '906dab652b42ebf22170bb673e23bf1f73f1f8b64417e9aedaee3a483e63fc7f6f07fbbf42b4691091b3720c74a96b61a0bb187304cac7222d12e28b892acee5');
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('163e5d8c-156e-11e3-a239-001a4a81450b', '7b504c42-bf06-11e5-832a-001a4a81450b',1);

        # cppcheck - new version 1.72: 1 version. Not using the specialized tool table Language = C/C++; Platform = All Platforms Except Android
          # tool_uuid:         163e5d8c-156e-11e3-a239-001a4a81450b
          # tool_version_uuid: 1c9a1589-bf05-11e5-832a-001a4a81450b
          # tool_shed.tool_platform records already exist. They're for the tool, not specific to tool version.
        delete from tool_shed.tool_language where tool_version_uuid = '1c9a1589-bf05-11e5-832a-001a4a81450b';
        delete from tool_shed.tool_version  where tool_version_uuid = '1c9a1589-bf05-11e5-832a-001a4a81450b';
        insert into tool_shed.tool_version
          (tool_version_uuid, tool_uuid, version_string, release_date, comment_public, comment_private,
          tool_path, tool_executable, tool_arguments, tool_directory, checksum)
        values
        ('1c9a1589-bf05-11e5-832a-001a4a81450b','163e5d8c-156e-11e3-a239-001a4a81450b','1.72', now(), 'Cppcheck 1.72', NULL,
        '/swamp/store/SCATools/cppcheck/cppcheck-1.72.tar', 'bin/cppcheck', '', 'cppcheck-1.72',
        'c35d6eaee59c43d315cf9f9766e9580d22160746883da03e0f5c783c2928118c55149c9f88d18c141e574c1cfccdfbdd124967b93e51a34b41259a86e6f6cb16');
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('163e5d8c-156e-11e3-a239-001a4a81450b', '1c9a1589-bf05-11e5-832a-001a4a81450b',1);

        # Parasoft C/C++test - new version 9.5.6.26
          # tool_uuid:         4bb2644d-6440-11e4-a282-001a4a81450b
          # tool_version_uuid: 92e94ec4-bf07-11e5-832a-001a4a81450b
        delete from tool_shed.tool_language where tool_version_uuid = '92e94ec4-bf07-11e5-832a-001a4a81450b';
        delete from tool_shed.tool_version  where tool_version_uuid = '92e94ec4-bf07-11e5-832a-001a4a81450b';
        insert into tool_shed.tool_version
          (tool_version_uuid, tool_uuid, version_string, release_date, comment_public, comment_private,
          tool_path, tool_executable, tool_arguments, tool_directory, checksum)
        values
        ('92e94ec4-bf07-11e5-832a-001a4a81450b','4bb2644d-6440-11e4-a282-001a4a81450b','9.5.6.26', now(), 'Parasoft C/C++test v9.5.6.26', NULL,
        '/swamp/store/SCATools/parasoft/ps-ctest-9.5.6.26.tar', 'cpptestcli', '', 'parasoft/cpptest/9.5',
        '739650de6d6fe630dbe234ef0e792889831751d2faa4fd4978276f1582405ae69ed04bf6a05347cbb126eebe4026748e7611ff25d50686ef756fada234e6104d');
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('4bb2644d-6440-11e4-a282-001a4a81450b', '92e94ec4-bf07-11e5-832a-001a4a81450b',1);

        # Pkg: gajim needs new version to work with new framework
        update package_store.package_version
           #set package_path = '/swamp/store/SCAPackages/curated/python/gajim-0.16/gajim-0.16.tar.bz2', # DEV
           set package_path = '/swamp/store/SCAPackages/UW/python/gajim-0.16/gajim-0.16.tar.bz2', #INT & PROD
               checksum = 'af2fd6b750e3ffa5770913a93ac5e61e6dab5688a28a26484ba4a097d73cc38b820797b1fedc60a67bf94e9a641cc80264210d0c4cf997047068c6dcb056ca75'
         where package_version_uuid = 'cf1d20dc-dc7f-11e4-b6a7-001a4a81450b';

        # Update existing version of Reek 2.2.1 - Improved Reek reporting
        update tool_shed.tool_version
           set tool_path = '/swamp/store/SCATools/reek/reek-2.2.1-4.tar.gz',
               checksum  = 'cee60115306b62cdab38d2715237b11e5a3c39501ed03728f142398cbd7f33efa9e5965537e9fb5fb6e95fd0a7829dae5cd34a567507364d98793c71218871fe'
         where tool_version_uuid = 'bcbfc7d7-1fbc-11e5-b6a7-001a4a81450b';

        # Update existing version of Reek 3.1 - Improved Reek reporting
        update tool_shed.tool_version
           set tool_path = '/swamp/store/SCATools/reek/reek-3.1-3.tar.gz',
               checksum  = 'ab316867df6b489f5ee5cef8f56896af1bc4f7d62ec4c6842fc1551e87a95bc3cc7a9f18787f82dc623645c82d9b9344edb8295c2679d2bc9c39b51478942644'
         where tool_version_uuid = '7059b296-4c14-11e5-83f1-001a4a81450b';

        # Update existing ruby pkgs
          # apropos-0.1.14
        update package_store.package_version
           set package_path = '/swamp/store/SCAPackages/curated/ruby/apropos-0.1.14/apropos-0.1.14.zip',
               checksum = 'ea99f025f64d1db129d3fde0a53e690836e5b67a001f2e13a2079a63f5e9e919e0d24328c43cf28a56dd83cda791eb4fb3f98cd6e9818bc399693a97d6fe9da9'
         where package_version_uuid = 'de6ff50d-88b2-11e5-865f-001a4a81450b';
          # paperclip-4.3.0
        update package_store.package_version
           set package_path = '/swamp/store/SCAPackages/curated/ruby/paperclip-4.3.0/paperclip-4.3.0.zip',
               checksum = '8b945886ae3dcdb315535b3175c434246a1fec65ddc5dbc14dec3a36889f262bf14e0c6b49641a4439cc18f89058f607fe18b23b4419b362233f4b39c9d12925'
         where package_version_uuid = 'fc3f171e-88b2-11e5-865f-001a4a81450b';
          # puppydev-bed9a953f4
        update package_store.package_version
           set package_path = '/swamp/store/SCAPackages/curated/ruby/puppydev-bed9a953f4/puppydev-bed9a953f4.zip',
               checksum = '3edb87f40399a4968050d639284824971ee4f9cbc0043beba06247e4a973a354504e174b7ef8c068b409704a2ab29cf9dcce6e2c84027df719fc4e788500c179'
         where package_version_uuid = '02353785-88b3-11e5-865f-001a4a81450b';
          # spree-3.0.3
        update package_store.package_version
           set package_path = '/swamp/store/SCAPackages/curated/ruby/spree-3.0.3/spree-3.0.3.zip',
               checksum = '5f27f55079e59ba3f88701867bfcd815d07f2a3509d6b90fbf83c1356451838c5b2fe1f4c659c4f23d861ed7fb2eb1a5d764798cacb7dbff5630f323aeea2392'
         where package_version_uuid = '1a0da934-88b3-11e5-865f-001a4a81450b';
          # railsgoat-9052b4fcf0
        update package_store.package_version
           set package_path = '/swamp/store/SCAPackages/curated/ruby/railsgoat-9052b4fcf0/railsgoat-9052b4fcf0.zip',
               checksum = 'c2b2f991f392f9f20f37c2704dcb452ab1a1cae5962780fbe9832c42144ebd84aae43d36a6ab5db97691a8695717f157d5430fa259d5990f094d290f2cc1d37d'
         where package_version_uuid = '0e216d3a-88b3-11e5-865f-001a4a81450b';

        # These Ruby pkgs are incompatible with Scientific Linux 5.9
          # Pkgs incompatible with Scientific Linux 5.9 32-bit
            # apropos-0.1.14
            # paperclip-4.3.0
            # puppydev-bed9a953f4
            # spree-3.0.3
            # railsgoat-9052b4fcf0
        delete from package_store.package_platform where package_version_uuid = '2bf00c16-88b3-11e5-865f-001a4a81450b' and platform_version_uuid = '35bc77b9-7d3e-11e3-88bb-001a4a81450b';
        delete from package_store.package_platform where package_version_uuid = '49beaa17-88b3-11e5-865f-001a4a81450b' and platform_version_uuid = '35bc77b9-7d3e-11e3-88bb-001a4a81450b';
        delete from package_store.package_platform where package_version_uuid = '4fb4b93c-88b3-11e5-865f-001a4a81450b' and platform_version_uuid = '35bc77b9-7d3e-11e3-88bb-001a4a81450b';
        delete from package_store.package_platform where package_version_uuid = '678d7b86-88b3-11e5-865f-001a4a81450b' and platform_version_uuid = '35bc77b9-7d3e-11e3-88bb-001a4a81450b';
        delete from package_store.package_platform where package_version_uuid = '5ba13433-88b3-11e5-865f-001a4a81450b' and platform_version_uuid = '35bc77b9-7d3e-11e3-88bb-001a4a81450b';
        insert into package_store.package_platform (package_uuid, package_version_uuid, platform_uuid, platform_version_uuid, compatible_flag) values ('de6ff50d-88b2-11e5-865f-001a4a81450b', '2bf00c16-88b3-11e5-865f-001a4a81450b', 'a4f024eb-f317-11e3-8775-001a4a81450b', '35bc77b9-7d3e-11e3-88bb-001a4a81450b', 0); # Apropos 0.1.14
        insert into package_store.package_platform (package_uuid, package_version_uuid, platform_uuid, platform_version_uuid, compatible_flag) values ('fc3f171e-88b2-11e5-865f-001a4a81450b', '49beaa17-88b3-11e5-865f-001a4a81450b', 'a4f024eb-f317-11e3-8775-001a4a81450b', '35bc77b9-7d3e-11e3-88bb-001a4a81450b', 0); # paperclip-4.3.0
        insert into package_store.package_platform (package_uuid, package_version_uuid, platform_uuid, platform_version_uuid, compatible_flag) values ('02353785-88b3-11e5-865f-001a4a81450b', '4fb4b93c-88b3-11e5-865f-001a4a81450b', 'a4f024eb-f317-11e3-8775-001a4a81450b', '35bc77b9-7d3e-11e3-88bb-001a4a81450b', 0); # puppydev-bed9a953f4
        insert into package_store.package_platform (package_uuid, package_version_uuid, platform_uuid, platform_version_uuid, compatible_flag) values ('1a0da934-88b3-11e5-865f-001a4a81450b', '678d7b86-88b3-11e5-865f-001a4a81450b', 'a4f024eb-f317-11e3-8775-001a4a81450b', '35bc77b9-7d3e-11e3-88bb-001a4a81450b', 0); # spree-3.0.3
        insert into package_store.package_platform (package_uuid, package_version_uuid, platform_uuid, platform_version_uuid, compatible_flag) values ('0e216d3a-88b3-11e5-865f-001a4a81450b', '5ba13433-88b3-11e5-865f-001a4a81450b', 'a4f024eb-f317-11e3-8775-001a4a81450b', '35bc77b9-7d3e-11e3-88bb-001a4a81450b', 0); # railsgoat-9052b4fcf0
          # Pkgs incompatible with Scientific Linux 5.9 64-bit
            # apropos-0.1.14
            # paperclip-4.3.0
            # puppydev-bed9a953f4
            # spree-3.0.3
        delete from package_store.package_platform where package_version_uuid = '2bf00c16-88b3-11e5-865f-001a4a81450b' and platform_version_uuid = '27f0588b-209e-11e3-9a3e-001a4a81450b';
        delete from package_store.package_platform where package_version_uuid = '49beaa17-88b3-11e5-865f-001a4a81450b' and platform_version_uuid = '27f0588b-209e-11e3-9a3e-001a4a81450b';
        delete from package_store.package_platform where package_version_uuid = '4fb4b93c-88b3-11e5-865f-001a4a81450b' and platform_version_uuid = '27f0588b-209e-11e3-9a3e-001a4a81450b';
        delete from package_store.package_platform where package_version_uuid = '678d7b86-88b3-11e5-865f-001a4a81450b' and platform_version_uuid = '27f0588b-209e-11e3-9a3e-001a4a81450b';
        insert into package_store.package_platform (package_uuid, package_version_uuid, platform_uuid, platform_version_uuid, compatible_flag) values ('de6ff50d-88b2-11e5-865f-001a4a81450b', '2bf00c16-88b3-11e5-865f-001a4a81450b', 'd95fcb5f-209d-11e3-9a3e-001a4a81450b', '27f0588b-209e-11e3-9a3e-001a4a81450b', 0); # Apropos 0.1.14
        insert into package_store.package_platform (package_uuid, package_version_uuid, platform_uuid, platform_version_uuid, compatible_flag) values ('fc3f171e-88b2-11e5-865f-001a4a81450b', '49beaa17-88b3-11e5-865f-001a4a81450b', 'd95fcb5f-209d-11e3-9a3e-001a4a81450b', '27f0588b-209e-11e3-9a3e-001a4a81450b', 0); # paperclip-4.3.0
        insert into package_store.package_platform (package_uuid, package_version_uuid, platform_uuid, platform_version_uuid, compatible_flag) values ('02353785-88b3-11e5-865f-001a4a81450b', '4fb4b93c-88b3-11e5-865f-001a4a81450b', 'd95fcb5f-209d-11e3-9a3e-001a4a81450b', '27f0588b-209e-11e3-9a3e-001a4a81450b', 0); # puppydev-bed9a953f4
        insert into package_store.package_platform (package_uuid, package_version_uuid, platform_uuid, platform_version_uuid, compatible_flag) values ('1a0da934-88b3-11e5-865f-001a4a81450b', '678d7b86-88b3-11e5-865f-001a4a81450b', 'd95fcb5f-209d-11e3-9a3e-001a4a81450b', '27f0588b-209e-11e3-9a3e-001a4a81450b', 0); # spree-3.0.3

        # update database version number
        delete from assessment.database_version where database_version_no = script_version_no;
        insert into assessment.database_version (database_version_no, description) values (script_version_no, 'upgrade to v1.24');

        commit;
      end;
    end if;
END
$$
DELIMITER ;
