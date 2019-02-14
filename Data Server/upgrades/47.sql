# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2019 Software Assurance Marketplace

# v1.25
use assessment;
drop PROCEDURE if exists upgrade_47;
DELIMITER $$
CREATE PROCEDURE upgrade_47 ()
  BEGIN
    declare script_version_no int;
    declare cur_db_version_no int;
    set script_version_no = 47;

    select max(database_version_no)
      into cur_db_version_no
      from assessment.database_version;

    if cur_db_version_no < script_version_no then
      begin

        # 6 new tool versions
          # checkstyle-6.17.tar.gz
          # error-prone-2.0.9.tar.gz
          # findbugs-3.0.1.tar.gz
          # pmd-5.4.1.tar.gz
          # ps-ctest-9.6.1.91.tar
          # ps-jtest-9.5.14-2.tar
          # ps-jtest-9.6.0.tar
        # 18 tool version updates
          # brakeman-3.0.5-2.tar.gz
          # checkstyle-5.7-5.tar.gz
          # checkstyle-6.2-3.tar.gz
          # dawnscanner-1.3.5-2.tar.gz
          # error-prone-1.1.1-5.tar.gz
          # findbugs-2.0.2-3.tar.gz
          # findbugs-2.0.3-5.tar.gz
          # findbugs-3.0.0-3.tar.gz
          # pmd-5.0.4-4.tar.gz
          # pmd-5.1.0-4.tar.gz
          # pmd-5.2.3-4.tar.gz
          # ps-jtest-9.5.13-8.tar
          # reek-2.2.1-5.tar.gz
          # reek-3.1-4.tar.gz
          # revealdroid-2015.11.05-1.tar
          # rubocop-0.31.0-3.tar.gz
          # rubocop-0.33.0-2.tar.gz
          # ruby-lint-2.0.4-2.tar.gz
        ###
        # delete if exists
        delete from tool_shed.tool_language where tool_version_uuid in
          ('b5115bdd-e095-11e5-ae56-001a4a81450b', # checkstyle-6.17.tar.gz
           '4fcb04a8-e096-11e5-ae56-001a4a81450b', # error-prone-2.0.9.tar.gz
           '9c48c4ad-e098-11e5-ae56-001a4a81450b', # findbugs-3.0.1.tar.gz
           '04be7ddc-e099-11e5-ae56-001a4a81450b', # pmd-5.4.1.tar.gz
           '53fc0641-e094-11e5-ae56-001a4a81450b', # ps-ctest-9.6.1.91.tar
           '93334c42-e099-11e5-ae56-001a4a81450b', # ps-jtest-9.5.14-2.tar
           'd08f0ae9-f69b-11e5-ae56-001a4a81450b'  # ps-jtest-9.6.0.tar
           );
        delete from tool_shed.tool_version where tool_version_uuid in
          ('b5115bdd-e095-11e5-ae56-001a4a81450b', # checkstyle-6.17.tar.gz
           '4fcb04a8-e096-11e5-ae56-001a4a81450b', # error-prone-2.0.9.tar.gz
           '9c48c4ad-e098-11e5-ae56-001a4a81450b', # findbugs-3.0.1.tar.gz
           '04be7ddc-e099-11e5-ae56-001a4a81450b', # pmd-5.4.1.tar.gz
           '53fc0641-e094-11e5-ae56-001a4a81450b', # ps-ctest-9.6.1.91.tar
           '93334c42-e099-11e5-ae56-001a4a81450b', # ps-jtest-9.5.14-2.tar
           'd08f0ae9-f69b-11e5-ae56-001a4a81450b'  # ps-jtest-9.6.0.tar
           );
        # checkstyle - new version 6.17
          # tool_uuid:         992A48A5-62EC-4EE9-8429-45BB94275A41
          # tool_version_uuid: b5115bdd-e095-11e5-ae56-001a4a81450b
        insert into tool_shed.tool_version
          (tool_version_uuid, tool_uuid, version_string, release_date, comment_public, comment_private,
          tool_path, tool_executable, tool_arguments, tool_directory, checksum)
        values
        ('b5115bdd-e095-11e5-ae56-001a4a81450b','992A48A5-62EC-4EE9-8429-45BB94275A41','6.17', now(), 'Checkstyle v6.17', NULL,
        '/swamp/store/SCATools/checkstyle/checkstyle-6.17.tar.gz', 'checkstyle-6.17-all.jar', '', 'checkstyle-6.17',
        'f522a04b57ecca06a7701d147768d092096735a9cab4f50d1b16a0c0a890b6b59af751ec99c06052b259119fad7fe28698e93c0ee4614ed751f89f09ddd64dc0');
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('992A48A5-62EC-4EE9-8429-45BB94275A41', 'b5115bdd-e095-11e5-ae56-001a4a81450b',2);
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('992A48A5-62EC-4EE9-8429-45BB94275A41', 'b5115bdd-e095-11e5-ae56-001a4a81450b',6);
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('992A48A5-62EC-4EE9-8429-45BB94275A41', 'b5115bdd-e095-11e5-ae56-001a4a81450b',12);
        # error-prone - new version 2.0.9
          # tool_uuid:         56872C2E-1D78-4DB0-B976-83ACF5424C52
          # tool_version_uuid: 4fcb04a8-e096-11e5-ae56-001a4a81450b
        insert into tool_shed.tool_version
          (tool_version_uuid, tool_uuid, version_string, release_date, comment_public, comment_private,
          tool_path, tool_executable, tool_arguments, tool_directory, checksum)
        values
        ('4fcb04a8-e096-11e5-ae56-001a4a81450b','56872C2E-1D78-4DB0-B976-83ACF5424C52','2.0.9', now(), 'error-prone v2.0.9', NULL,
        '/swamp/store/SCATools/error-prone/error-prone-2.0.9.tar.gz', 'error_prone_ant-2.0.9.jar', '', 'error-prone-2.0.9',
        'a90c1ed3c6b36294bdf4e8d65f37e3301fd3b2931b7e9ae9285e4ca1e3b5f929af198c15bc1383f11958ac6ffabad9dbf98ded0d75785c0f8bfa9661aaeed13b');
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('56872C2E-1D78-4DB0-B976-83ACF5424C52', '4fcb04a8-e096-11e5-ae56-001a4a81450b',2);
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('56872C2E-1D78-4DB0-B976-83ACF5424C52', '4fcb04a8-e096-11e5-ae56-001a4a81450b',6);
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('56872C2E-1D78-4DB0-B976-83ACF5424C52', '4fcb04a8-e096-11e5-ae56-001a4a81450b',12);
        # Findbugs - new version 3.0.1 (FindSecurityBugs 1.4.5)
          # tool_uuid:         163d56a7-156e-11e3-a239-001a4a81450b
          # tool_version_uuid: 9c48c4ad-e098-11e5-ae56-001a4a81450b
        insert into tool_shed.tool_version
          (tool_version_uuid, tool_uuid, version_string, release_date, comment_public, comment_private,
          tool_path, tool_executable, tool_arguments, tool_directory, checksum)
        values
        ('9c48c4ad-e098-11e5-ae56-001a4a81450b','163d56a7-156e-11e3-a239-001a4a81450b','3.0.1', now(), 'Findbugs 3.0.1 (with FindSecurityBugs-1.4.5 plugin)', NULL,
        '/swamp/store/SCATools/findbugs/findbugs-3.0.1.tar.gz', 'lib/findbugs.jar', '', 'findbugs-3.0.1',
        'dafe7784c38038c8e38ca6e0ddb8882a99005da615cae0ee95734729484271b2dd4659142a612196941a080f39a73aac704c4047a9c14e01dbd0f13615ac9039');
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('163d56a7-156e-11e3-a239-001a4a81450b', '9c48c4ad-e098-11e5-ae56-001a4a81450b',2);
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('163d56a7-156e-11e3-a239-001a4a81450b', '9c48c4ad-e098-11e5-ae56-001a4a81450b',3);
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('163d56a7-156e-11e3-a239-001a4a81450b', '9c48c4ad-e098-11e5-ae56-001a4a81450b',6);
        # PMD - new version 5.4.1
          # tool_uuid:         163f2b01-156e-11e3-a239-001a4a81450b
          # tool_version_uuid: 04be7ddc-e099-11e5-ae56-001a4a81450b
        insert into tool_shed.tool_version
          (tool_version_uuid, tool_uuid, version_string, release_date, comment_public, comment_private,
          tool_path, tool_executable, tool_arguments, tool_directory, checksum)
        values
        ('04be7ddc-e099-11e5-ae56-001a4a81450b','163f2b01-156e-11e3-a239-001a4a81450b','5.4.1', now(), 'PMD v5.4.1', NULL,
        '/swamp/store/SCATools/pmd/pmd-5.4.1.tar.gz', 'net.sourceforge.pmd.PMD', '', 'pmd-bin-5.4.1',
        'd559586eb16b0e1d1d1f1f9ccfc60583ba8b35ca8776dce7b7c297b684e6197e94563ceae328af86a8e51fa64c698709ee85cb8fe1582a198f8727f83781ac75');
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('163f2b01-156e-11e3-a239-001a4a81450b', '04be7ddc-e099-11e5-ae56-001a4a81450b',2);
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('163f2b01-156e-11e3-a239-001a4a81450b', '04be7ddc-e099-11e5-ae56-001a4a81450b',6);
        # Parasoft Jtest - new version 9.5.14
          # tool_uuid:         6197a593-6440-11e4-a282-001a4a81450b
          # tool_version_uuid: 93334c42-e099-11e5-ae56-001a4a81450b
        insert into tool_shed.tool_version
          (tool_version_uuid, tool_uuid, version_string, release_date, comment_public, comment_private,
          tool_path, tool_executable, tool_arguments, tool_directory, checksum)
        values
        ('93334c42-e099-11e5-ae56-001a4a81450b','6197a593-6440-11e4-a282-001a4a81450b','9.5.14', now(), 'Parasoft Jtest v9.5.14', NULL,
        '/swamp/store/SCATools/parasoft/ps-jtest-9.5.14-2.tar', 'jtest/9.5/jtestcli', '', 'parasoft',
        '78d866adc5d7e9937b972f6b2bc5b064b552bfb84655d96c01fa9c6ece5bf7799cb09ee8a6a671148229dc30d7c3ba465b3f11007b164e70a85417c4ed21c027');
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('6197a593-6440-11e4-a282-001a4a81450b', '93334c42-e099-11e5-ae56-001a4a81450b',2);
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('6197a593-6440-11e4-a282-001a4a81450b', '93334c42-e099-11e5-ae56-001a4a81450b',6);
        # Parasoft Jtest - new version 9.6.0
          # tool_uuid:         6197a593-6440-11e4-a282-001a4a81450b
          # tool_version_uuid: d08f0ae9-f69b-11e5-ae56-001a4a81450b
        insert into tool_shed.tool_version
          (tool_version_uuid, tool_uuid, version_string, release_date, comment_public, comment_private,
          tool_path, tool_executable, tool_arguments, tool_directory, checksum)
        values
        ('d08f0ae9-f69b-11e5-ae56-001a4a81450b','6197a593-6440-11e4-a282-001a4a81450b','9.6.0', now(), 'Parasoft Jtest v9.6.0', NULL,
        '/swamp/store/SCATools/parasoft/ps-jtest-9.6.0.tar', 'jtest/9.6/jtestcli', '', 'parasoft',
        'd002c2456fd51d223217cab8ed4eb36451aadd32eddaa34ee37ac73459ebee33d9ca20509911e3c8fb101e4aaf9450012b54f459858ccaceade0970c43fd0f52');
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('6197a593-6440-11e4-a282-001a4a81450b', 'd08f0ae9-f69b-11e5-ae56-001a4a81450b',2);
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('6197a593-6440-11e4-a282-001a4a81450b', 'd08f0ae9-f69b-11e5-ae56-001a4a81450b',6);
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('6197a593-6440-11e4-a282-001a4a81450b', 'd08f0ae9-f69b-11e5-ae56-001a4a81450b',12);
        # Parasoft C/C++test - new version 9.6.1.91
          # tool_uuid:         4bb2644d-6440-11e4-a282-001a4a81450b
          # tool_version_uuid: 53fc0641-e094-11e5-ae56-001a4a81450b
        insert into tool_shed.tool_version
          (tool_version_uuid, tool_uuid, version_string, release_date, comment_public, comment_private,
          tool_path, tool_executable, tool_arguments, tool_directory, checksum)
        values
        ('53fc0641-e094-11e5-ae56-001a4a81450b','4bb2644d-6440-11e4-a282-001a4a81450b','9.6.1.91', now(), 'Parasoft C/C++test v9.6.1.91', NULL,
        '/swamp/store/SCATools/parasoft/ps-ctest-9.6.1.91.tar', 'cpptestcli', '', 'parasoft/cpptest/9.6',
        'aa4e83e3a1f305f797175492427f83930f14af820fa8828998725fe34bc38d40fbfce65d552f5438328c368dc3adf9d80ef3838ae9c12fcd63bcd220bcb5eec4');
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('4bb2644d-6440-11e4-a282-001a4a81450b', '53fc0641-e094-11e5-ae56-001a4a81450b',1);
        # Update existing version of Brakeman 3.05
        update tool_shed.tool_version
           set tool_path = '/swamp/store/SCATools/brakeman/brakeman-3.0.5-2.tar.gz',
               checksum  = '778bd9ed4d3c4cdc875b6e464a2473ad617e14e8c734bad3280d7b8e1686b448d94e2a23158ddde535e3bcc44279ad1c949c44f9f9c74fab93ab5770d3fce058'
         where tool_version_uuid = '6b06aaa6-4053-11e5-83f1-001a4a81450b';
        # Update existing version of checkstyle 5.7
        update tool_shed.tool_version
           set tool_path = '/swamp/store/SCATools/checkstyle/checkstyle-5.7-5.tar.gz',
               checksum  = '48e3fdd4d87077785fdc8c2d0344dc39d94d0ff5a561a75f7af0528d04e5cfd3d2479f496fad5c4666d4f386c5436b1e30dfb159c7e30db11d593b39899d5b7c'
         where tool_version_uuid = '09449DE5-8E63-44EA-8396-23C64525D57C';
        # Update existing version of checkstyle 6.2
        update tool_shed.tool_version
           set tool_path = '/swamp/store/SCATools/checkstyle/checkstyle-6.2-3.tar.gz',
               checksum  = 'c497e59baf1f1008052bba0dcf176f1394429d156b911d910da6750fe925262ad75d34e778838a806bd3d501d6ef80f877880551658ca549e7c4e39bbce67b91'
         where tool_version_uuid = '0667d30a-a7f0-11e4-a335-001a4a81450b';
        # Update existing version of Dawn 1.3.5
        update tool_shed.tool_version
           set tool_path = '/swamp/store/SCATools/dawn/dawnscanner-1.3.5-2.tar.gz',
               checksum  = '1d5221c5a85dc3c243cf5860b5c53d6094987861eb1b44bb1ea1e5d3856287521cf9daa3b470d7b38333068b7ac71948651df16f7e183375bb98efa870e1e8af'
         where tool_version_uuid = 'ca1608e1-4057-11e5-83f1-001a4a81450b';
        # Update existing version of error-prone  1.1.1
        update tool_shed.tool_version
           set tool_path = '/swamp/store/SCATools/error-prone/error-prone-1.1.1-5.tar.gz',
               checksum  = '3e083afea07ec714e9e107c17c1c9870b1d2bb6c01973ae904451be9ce0ad8595a35c71148ba84f90df519dbe0ead6fa041011adb052e27b85140724e1f7c65f'
         where tool_version_uuid = '5230FE76-E658-4B3A-AD40-7D55F7A21955';
        # Update existing version of Findbugs 2.0.2 (FindSecurityBugs 1.1.0)
        update tool_shed.tool_version
           set tool_path = '/swamp/store/SCATools/findbugs/findbugs-2.0.2-3.tar.gz',
               checksum  = '13c29fff911b7a9eb9e9670591263b89878b5321d49122689377f37790e8b9673d253f24d7c9d64161a8cb4a2ffdb135e4f0edf3f58d06f5e1d83b9415b4bbd7'
         where tool_version_uuid = '163fe1e7-156e-11e3-a239-001a4a81450b';
        # Update existing version of Findbugs 2.0.3 (FindSecurityBugs 1.2)
        update tool_shed.tool_version
           set tool_path = '/swamp/store/SCATools/findbugs/findbugs-2.0.3-5.tar.gz',
               checksum  = '83a1e973a7a674e58c211432d5ac4977866d33edfb0d83e4e21c0f47271375c969934788fb246da13ea0a6aae7b69f9b42a806278ba59d60df37609e3279fa33'
         where tool_version_uuid = '4c1ec754-cb53-11e3-8775-001a4a81450b';
        # Update existing version of Findbugs 3.0.0 (FindSecurityBugs 1.3)
        update tool_shed.tool_version
           set tool_path = '/swamp/store/SCATools/findbugs/findbugs-3.0.0-3.tar.gz',
               checksum  = '07df890ceeb48a409a98843513cf53db26ad3ed0d1af75965958872c460dddf50de4873564baaa98e98b21a1cc6f02e0ecc095ba51ebed696bd0bb9077204d47'
         where tool_version_uuid = '27ea7f63-a813-11e4-a335-001a4a81450b';
        # Update existing version of PMD 5.0.4
        update tool_shed.tool_version
           set tool_path = '/swamp/store/SCATools/pmd/pmd-5.0.4-4.tar.gz',
               checksum  = 'f01675549772197a96ec85445f30622a5588a1d25ecc1e2be6485d3e722a2f15052979a3b83ab84c809156f543207ae1f00f9435f5053f82bc19f10e5db88ae4'
         where tool_version_uuid = '16414980-156e-11e3-a239-001a4a81450b';
        # Update existing version of PMD 5.1.0
        update tool_shed.tool_version
           set tool_path = '/swamp/store/SCATools/pmd/pmd-5.1.0-4.tar.gz',
               checksum  = '97ef43dc4435c412cd7174745946e210b707b41064c33f14aba687b2bea7a477938aa6c1ac00e736fc2b8c6280ed6ef7b42dc3af3d1df9ead461803a6a0e74cb'
         where tool_version_uuid = 'a2d949ef-cb53-11e3-8775-001a4a81450b';
        # Update existing version of PMD 5.2.3
        update tool_shed.tool_version
           set tool_path = '/swamp/store/SCATools/pmd/pmd-5.2.3-4.tar.gz',
               checksum  = '2c0a50aaa65c473368cdd018f4cf5dd9d2f69a3c604a241e6f5932d4e2107373e21c418308cf8af06de20dacd0c1f02db4d1a0b3211585154cb0776d0fd60293'
         where tool_version_uuid = 'bdaf4b93-a811-11e4-a335-001a4a81450b';
        # Update existing version of Parasoft Jtest 9.5.13
        update tool_shed.tool_version
           set tool_path = '/swamp/store/SCATools/parasoft/ps-jtest-9.5.13-8.tar',
               checksum  = 'e7777d784d467e5dd91fc7eb7f57fdb4b9045a3280c24b3b8efda5e846b5f4193cb27989e1ab44989689f765e628d9f59cf2f1d4209baede9a163abedb53143b'
         where tool_version_uuid = '18532f08-6441-11e4-a282-001a4a81450b';
        # Update existing version of Reek 2.2.1
        update tool_shed.tool_version
           set tool_path = '/swamp/store/SCATools/reek/reek-2.2.1-5.tar.gz',
               checksum  = 'c737e87c6383dd6a6f1582d2d02ec4caaf088541c2c61a2d5773a0da2fbe221f4122483f2ffa80aef1d0ad5e71df8cfa628923db9c7dff64ad16094ce019fe4a'
         where tool_version_uuid = 'bcbfc7d7-1fbc-11e5-b6a7-001a4a81450b';
        # Update existing version of Reek 3.1
        update tool_shed.tool_version
           set tool_path = '/swamp/store/SCATools/reek/reek-3.1-4.tar.gz',
               checksum  = '9596455db7985e5dc520034b6f4e01b9fb4a96885f5810ef2b4affa3e97e68473302918a4816e9126affd7d2d9822ddf6d1fad2f9d5749ae85eba55274e6b951'
         where tool_version_uuid = '7059b296-4c14-11e5-83f1-001a4a81450b';
        # Update existing version of RevealDroid 2015.11.05
        update tool_shed.tool_version
           set tool_path = '/swamp/store/SCATools/revealdroid/revealdroid-2015.11.05-1.tar',
               checksum  = '1a0d4a9e0696db42a37fdba6dd0304b83c7450e1ef5a2873347ecc87320b9e24008a66c058fd9969eddbe5dd1b20eb61b705845ff49b69897946b3095ca3d4a8'
         where tool_version_uuid = '8666e176-a828-11e5-865f-001a4a81450b';
        # Update existing version of RuboCop 0.31
        update tool_shed.tool_version
           set tool_path = '/swamp/store/SCATools/rubocop/rubocop-0.31.0-3.tar.gz',
               checksum  = 'd4be964d430eee4dbbe63c8aa67d3ad55c520ed2bf1fd85d79a0dd53a0f35e1b3fdd29f2ff868addbc8ea6c9758e667098b4e4b811615080f8dab392b0ba837f'
         where tool_version_uuid = 'f5c26a51-0935-11e5-b6a7-001a4a81450b';
        # Update existing version of RuboCop 0.33
        update tool_shed.tool_version
           set tool_path = '/swamp/store/SCATools/rubocop/rubocop-0.33.0-2.tar.gz',
               checksum  = '4ced934bbcfef8e08eef17fd4071337b073a7c00d370c3c4ed63aabeeeba2b843ee0cd0975e3b81850699c9b28575c5f5e49d20daff2356f0ed06ca4080395da'
         where tool_version_uuid = 'ea1f9693-46ac-11e5-83f1-001a4a81450b';
        # Update existing version of ruby-lint 2.0.4
        update tool_shed.tool_version
           set tool_path = '/swamp/store/SCATools/ruby-lint/ruby-lint-2.0.4-2.tar.gz',
               checksum  = '09b445f60c94d96bd8f4a354a8d1574265210c1dfb3a95ca335a83ec9bba397a7bc5356308c9d10affbb9957e9251dd6cd9c2c79ef3ce24a016a12c1b7b12a97'
         where tool_version_uuid = '6b5624a0-0946-11e5-b6a7-001a4a81450b';

        # Add tool_viewer_incompatibility table
        drop table if exists tool_shed.tool_viewer_incompatibility;
        CREATE TABLE tool_shed.tool_viewer_incompatibility (
          tool_viewer_id        INT  NOT NULL AUTO_INCREMENT                 COMMENT 'internal id',
          tool_uuid             VARCHAR(45)                                  COMMENT 'tool uuid',
          viewer_uuid           VARCHAR(45)                                  COMMENT 'viewer uuid',
          create_user           VARCHAR(50)                                  COMMENT 'db user that inserted record',
          create_date           TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
          update_user           VARCHAR(50)                                  COMMENT 'db user that last updated record',
          update_date           TIMESTAMP NULL DEFAULT NULL                  COMMENT 'date record last updated',
          PRIMARY KEY (tool_viewer_id),
            CONSTRAINT fk_tool_viewer_t FOREIGN KEY (tool_uuid) REFERENCES tool (tool_uuid) ON DELETE CASCADE ON UPDATE CASCADE,
            CONSTRAINT fk_tool_viewer_v FOREIGN KEY (viewer_uuid) REFERENCES viewer_store.viewer (viewer_uuid) ON DELETE CASCADE ON UPDATE CASCADE
         )COMMENT='Lists tool viewer incompatibilities';

        # Populate tool_viewer_incompatibility table
        insert into tool_shed.tool_viewer_incompatibility (tool_uuid, viewer_uuid) values ('b9560648-4057-11e5-83f1-001a4a81450b', '4221533e-865a-11e3-88bb-001a4a81450b'); # Dawnscanner / Code DX
        insert into tool_shed.tool_viewer_incompatibility (tool_uuid, viewer_uuid) values ('738b81f0-a828-11e5-865f-001a4a81450b', '4221533e-865a-11e3-88bb-001a4a81450b'); # RevealDroid / Code DX

        # New Package Types for Java 8
        # Android .apk Package Type
        delete from package_store.package_type where package_type_id in (12,13);
        update package_store.package_type set name = 'Java 7 Source Code' where package_type_id = 2;
        update package_store.package_type set name = 'Java 7 Bytecode' where package_type_id = 3;
        insert into package_store.package_type (package_type_id, name) values (12,  'Java 8 Source Code');
        insert into package_store.package_type (package_type_id, name) values (13,  'Java 8 Bytecode');

        # Mark tools as compatible with Java 8
          # Tool & Version                            Pkg Types
          # checkstyle  5.7                           2,12      Java 7 Source Code, Java 8 Source Code
          # checkstyle  6.17                          2,12      Java 7 Source Code, Java 8 Source Code
          # checkstyle  6.2                           2,12      Java 7 Source Code, Java 8 Source Code
          # error-prone 1.1.1                         2         Java 7 source code
          # error-prone 2.0.9                         2,12      Java 7 Source Code, Java 8 Source Code
          # Findbugs  2.0.2 (FindSecurityBugs 1.1.0)  2,3       Java 7 Source Code, Java 7 Bytecode
          # Findbugs  2.0.3 (FindSecurityBugs 1.2)    2,3       Java 7 Source Code, Java 7 Bytecode
          # Findbugs  3.0.0 (FindSecurityBugs 1.3)    2,3,12,13 Java 7 Source Code, Java 7 Bytecode, Java 8 Source Code, Java 8 Bytecode
          # Findbugs  3.0.1                           2,3,12,13 Java 7 Source Code, Java 7 Bytecode, Java 8 Source Code, Java 8 Bytecode
          # Parasoft Jtest  9.5.13                    2,12      Java 7 Source Code, Java 8 Source Code
          # Parasoft Jtest  9.5.14                    2,12      Java 7 Source Code, Java 8 Source Code
          # Parasoft Jtest  9.6.0                     2,12      Java 7 Source Code, Java 8 Source Code
          # PMD 5.0.4                                 2,12      Java 7 Source Code, Java 8 Source Code
          # PMD 5.1.0                                 2,12      Java 7 Source Code, Java 8 Source Code
          # PMD 5.2.3                                 2,12      Java 7 Source Code, Java 8 Source Code
          # PMD 5.4.1                                 2,12      Java 7 Source Code, Java 8 Source Code
        delete from tool_shed.tool_language where package_type_id = 12 and tool_version_uuid in
          ('09449DE5-8E63-44EA-8396-23C64525D57C',
           '0667d30a-a7f0-11e4-a335-001a4a81450b',
           '27ea7f63-a813-11e4-a335-001a4a81450b',
           '9c48c4ad-e098-11e5-ae56-001a4a81450b',
           '18532f08-6441-11e4-a282-001a4a81450b',
           '93334c42-e099-11e5-ae56-001a4a81450b',
           '16414980-156e-11e3-a239-001a4a81450b',
           'a2d949ef-cb53-11e3-8775-001a4a81450b',
           'bdaf4b93-a811-11e4-a335-001a4a81450b',
           '04be7ddc-e099-11e5-ae56-001a4a81450b');
        delete from tool_shed.tool_language where package_type_id = 13 and tool_version_uuid in
          ('27ea7f63-a813-11e4-a335-001a4a81450b',
           '9c48c4ad-e098-11e5-ae56-001a4a81450b');
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('992A48A5-62EC-4EE9-8429-45BB94275A41', '09449DE5-8E63-44EA-8396-23C64525D57C',12);  # checkstyle  5.7
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('992A48A5-62EC-4EE9-8429-45BB94275A41', '0667d30a-a7f0-11e4-a335-001a4a81450b',12);  # checkstyle  6.2
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('163d56a7-156e-11e3-a239-001a4a81450b', '27ea7f63-a813-11e4-a335-001a4a81450b',12);  # Findbugs  3.0.0 (FindSecurityBugs 1.3)
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('163d56a7-156e-11e3-a239-001a4a81450b', '9c48c4ad-e098-11e5-ae56-001a4a81450b',12);  # Findbugs  3.0.1
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('6197a593-6440-11e4-a282-001a4a81450b', '18532f08-6441-11e4-a282-001a4a81450b',12);  # Parasoft Jtest  9.5.13
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('6197a593-6440-11e4-a282-001a4a81450b', '93334c42-e099-11e5-ae56-001a4a81450b',12);  # Parasoft Jtest  9.5.14
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('163f2b01-156e-11e3-a239-001a4a81450b', '16414980-156e-11e3-a239-001a4a81450b',12);  # PMD 5.0.4
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('163f2b01-156e-11e3-a239-001a4a81450b', 'a2d949ef-cb53-11e3-8775-001a4a81450b',12);  # PMD 5.1.0
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('163f2b01-156e-11e3-a239-001a4a81450b', 'bdaf4b93-a811-11e4-a335-001a4a81450b',12);  # PMD 5.2.3
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('163f2b01-156e-11e3-a239-001a4a81450b', '04be7ddc-e099-11e5-ae56-001a4a81450b',12);  # PMD 5.4.1
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('163d56a7-156e-11e3-a239-001a4a81450b', '27ea7f63-a813-11e4-a335-001a4a81450b',13);  # Findbugs  3.0.0 (FindSecurityBugs 1.3)
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('163d56a7-156e-11e3-a239-001a4a81450b', '9c48c4ad-e098-11e5-ae56-001a4a81450b',13);  # Findbugs  3.0.1
        #insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('992A48A5-62EC-4EE9-8429-45BB94275A41', 'b5115bdd-e095-11e5-ae56-001a4a81450b',12); # checkstyle  6.17       # Aready done above
        #insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('56872C2E-1D78-4DB0-B976-83ACF5424C52', '4fcb04a8-e096-11e5-ae56-001a4a81450b',12); # error-prone 2.0.9      # Aready done above
        #insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('6197a593-6440-11e4-a282-001a4a81450b', 'd08f0ae9-f69b-11e5-ae56-001a4a81450b',12); # Parasoft Jtest  9.6.0  # Aready done above

        # update database version number
        delete from assessment.database_version where database_version_no = script_version_no;
        insert into assessment.database_version (database_version_no, description) values (script_version_no, 'upgrade to v1.25');

        commit;
      end;
    end if;
END
$$
DELIMITER ;
