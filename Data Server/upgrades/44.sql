# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2018 Software Assurance Marketplace

# v1.22
use assessment;
drop PROCEDURE if exists upgrade_44;
DELIMITER $$
CREATE PROCEDURE upgrade_44 ()
  BEGIN
    declare script_version_no int;
    declare cur_db_version_no int;
    set script_version_no = 44;

    select max(database_version_no)
      into cur_db_version_no
      from assessment.database_version;

    if cur_db_version_no < script_version_no then
      begin

        # Python Bandit - Update Existing Version
        update tool_shed.tool_version
           set tool_path = '/swamp/store/SCATools/bandit/bandit-8ba3536-2.tar.gz',
               checksum = 'd8fd1438bcac3618ed6c64ac360e0f9e598dde7d0ccf746e65c8cdbb4e86e6bb4ac5f063562ab36c8a4e377d45aa256d5269973f73a27213ee0db30f224208c7'
          where tool_version_uuid = '9cbd0e60-8f9f-11e4-829b-001a4a81450b';

        # Python Bandit - Add New Version
        # One tool version with two specialized tool versions for Python2 and Python3.
        insert into tool_shed.tool_version (tool_version_uuid, tool_uuid, version_string, release_date, comment_public, comment_private, tool_path, tool_executable, tool_arguments, tool_directory, checksum)
          values ('2a16b653-7449-11e5-865f-001a4a81450b','7fbfa454-8f9f-11e4-829b-001a4a81450b','0.14.0', now(), 'Bandit for Python 2 & 3', NULL, NULL, NULL, NULL, NULL, NULL);
        insert into tool_shed.specialized_tool_version
            (specialization_type, specialized_tool_version_uuid, tool_uuid, tool_version_uuid, package_type_id, tool_path, tool_executable, tool_arguments, tool_directory, checksum) values
            ('LANGUAGE', '7774f01a-7449-11e5-865f-001a4a81450b', '7fbfa454-8f9f-11e4-829b-001a4a81450b', '2a16b653-7449-11e5-865f-001a4a81450b', 4,
             '/swamp/store/SCATools/bandit/bandit-py2-0.14.0.tar.gz', 'bandit', '--format json --output ${REPORTS_DIR}/report.json', 'bandit-py2-0.14.0',
             'f193662f5fec827b16d4dab789ef05ca31d5d4aa830407e456e4e842dc7deec7977e4b284d0cd40abe485befa07c68bbffc98b5eda81271e5742b4d38358eae2'),
            ('LANGUAGE', '88be0c6b-7449-11e5-865f-001a4a81450b', '7fbfa454-8f9f-11e4-829b-001a4a81450b', '2a16b653-7449-11e5-865f-001a4a81450b', 5,
             '/swamp/store/SCATools/bandit/bandit-py3-0.14.0.tar.gz', 'bandit', '--format json --output ${REPORTS_DIR}/report.json', 'bandit-py3-0.14.0',
             '238cecb493838e00e66fff79414973e7921a7cd10c9a9902374366e02d70e9c4d17d993228fee602874a96d8222ba18eb07a5be54a6251a9ec326ef29a2ea41a');
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('7fbfa454-8f9f-11e4-829b-001a4a81450b', '2a16b653-7449-11e5-865f-001a4a81450b',4);
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('7fbfa454-8f9f-11e4-829b-001a4a81450b', '2a16b653-7449-11e5-865f-001a4a81450b',5);

        # Python Flake - Update Existing Version
        update tool_shed.specialized_tool_version
           set tool_path = '/swamp/store/SCATools/flake/flake8-py2-2.3.0-2.tar.gz',
               checksum = 'dbc0833312f801640762cd927d795c28661840de11acdaf4b43de6b93f47bff3993dcafa0c75be8adc4efc2a9147cf5a5efa96cb68fb51248ed9f40e646d6b9b'
          where specialized_tool_version_uuid = '134873d9-a7e4-11e4-a335-001a4a81450b';
        update tool_shed.specialized_tool_version
           set tool_path = '/swamp/store/SCATools/flake/flake8-py3-2.3.0-2.tar.gz',
               checksum = '81cfb2e63558cb8c7e469333eea2214e0f1d9546055a2e51703c54b413dca94080243c7eadf90a13b8300729b3781bc6505c2f776dcb13830ade354aa316c273'
          where specialized_tool_version_uuid = '1e58fe0c-a7e4-11e4-a335-001a4a81450b';

        # Python Flake - Add New Version
        # One tool version with two specialized tool versions for Python2 and Python3.
        insert into tool_shed.tool_version (tool_version_uuid, tool_uuid, version_string, release_date, comment_public, comment_private, tool_path, tool_executable, tool_arguments, tool_directory, checksum)
          values ('1ad625bd-71d5-11e5-865f-001a4a81450b','63695cd8-a73e-11e4-a335-001a4a81450b','2.4.1', now(), 'Flake8 v2.4.1 for Python 2 & 3', NULL, NULL, NULL, NULL, NULL, NULL);
        insert into tool_shed.specialized_tool_version
            (specialization_type, specialized_tool_version_uuid, tool_uuid, tool_version_uuid, package_type_id, tool_path, tool_executable, tool_arguments, tool_directory, checksum) values
            ('LANGUAGE', '5b7d6fde-71d5-11e5-865f-001a4a81450b', '63695cd8-a73e-11e4-a335-001a4a81450b', '1ad625bd-71d5-11e5-865f-001a4a81450b', 4,
             '/swamp/store/SCATools/flake/flake8-py2-2.4.1.tar.gz', 'flake8', '--verbose --exit-zero --format=pylint --output-file=${REPORTS_DIR}/report.txt', 'flake8-2.4.1',
             '1887b97c5cd05ce4b280f3bbb569eea775732a0c89031e4173616fbdf44935e3aef0d604234ed4b89f90eb2ee69e2dcb5ca6d88d4836d061b55dd5f6e8b9986e'),
            ('LANGUAGE', '813b30f3-71d5-11e5-865f-001a4a81450b', '63695cd8-a73e-11e4-a335-001a4a81450b', '1ad625bd-71d5-11e5-865f-001a4a81450b', 5,
             '/swamp/store/SCATools/flake/flake8-py3-2.4.1.tar.gz', 'flake8', '--verbose --exit-zero --format=pylint --output-file=${REPORTS_DIR}/report.txt', 'flake8-2.4.1',
             'a5b81d53b01aef9549f2c0a55e81561fa8d20034c02ae1ca6bc84725a896c8a1d1fd498124eb4cb5c441b5459434b69b52c91329b79473c269140839bbafab2e');
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('63695cd8-a73e-11e4-a335-001a4a81450b', '1ad625bd-71d5-11e5-865f-001a4a81450b',4);
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('63695cd8-a73e-11e4-a335-001a4a81450b', '1ad625bd-71d5-11e5-865f-001a4a81450b',5);

        # Pylint - Update Existing Version
        update tool_shed.specialized_tool_version
           set tool_path = '/swamp/store/SCATools/pylint/pylint-py2-1.3.1-2.tar.gz',
               tool_arguments = '-f parseable --disable=C --disable=R',
               checksum = 'd9168624d32f7988bd6c18e4d801888ce5e16298594dd3e7b01dec41f716bac05ec4014c58ea95e26f932284948a5c8e868ffbf4e824042ae49c4bd0c22a3e15'
          where specialized_tool_version_uuid = '364e8718-480a-11e4-a4f3-001a4a81450b';
        update tool_shed.specialized_tool_version
           set tool_path = '/swamp/store/SCATools/pylint/pylint-py3-1.3.1-2.tar.gz',
               tool_arguments = '-f parseable --disable=C --disable=R',
               checksum = '052cd5949c76f2823046a9e9ec6669d958d1b273159ffa88968d6c37a6389eefb08afae76d44db509fa72f1d85328fd72d39aa9e17180e6e6cb62e9844fba930'
          where specialized_tool_version_uuid = 'eccdd194-480a-11e4-a4f3-001a4a81450b';

        # Pylint - Add New Version
        # One tool version with two specialized tool versions for Python2 and Python3.
        insert into tool_shed.tool_version (tool_version_uuid, tool_uuid, version_string, release_date, comment_public, comment_private, tool_path, tool_executable, tool_arguments, tool_directory, checksum)
          values ('c9126789-71d7-11e5-865f-001a4a81450b','0f668fb0-4421-11e4-a4f3-001a4a81450b','1.4.4', now(), 'Pylint v1.4.4 for Python 2 & 3', NULL, NULL, NULL, NULL, NULL, NULL);
        insert into tool_shed.specialized_tool_version
            (specialization_type, specialized_tool_version_uuid, tool_uuid, tool_version_uuid, package_type_id, tool_path, tool_executable, tool_arguments, tool_directory, checksum) values
            ('LANGUAGE', 'dab2f27b-71d7-11e5-865f-001a4a81450b', '0f668fb0-4421-11e4-a4f3-001a4a81450b', 'c9126789-71d7-11e5-865f-001a4a81450b', 4,
             '/swamp/store/SCATools/pylint/pylint-py2-1.4.4.tar.gz', 'pylint', '-f parseable --disable=C --disable=R', 'pylint-py2-1.4.4',
             'c4528e3c77cd255ae702821758560ea3f16344d745648e4bcb6cc10d9d3c3f41950bf88d5d5ed3b524b600609303a3633b28f0933ccd9b517026652bcc510f45'),
            ('LANGUAGE', 'e4fb2c6f-71d7-11e5-865f-001a4a81450b', '0f668fb0-4421-11e4-a4f3-001a4a81450b', 'c9126789-71d7-11e5-865f-001a4a81450b', 5,
             '/swamp/store/SCATools/pylint/pylint-py3-1.4.4.tar.gz', 'pylint', '-f parseable --disable=C --disable=R', 'pylint-py3-1.4.4',
             'e26116f78b93cbfb16cab02a2779808b51d91587abb98cd56677eda6fc01d405e62c976cb00b43d3b3dd350b465fc8d4c8a247e3b977d7fe857190a841075929');
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('0f668fb0-4421-11e4-a4f3-001a4a81450b', 'c9126789-71d7-11e5-865f-001a4a81450b',4);
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('0f668fb0-4421-11e4-a4f3-001a4a81450b', 'c9126789-71d7-11e5-865f-001a4a81450b',5);

        # Moved to v1.23 # New Tool GrammaTechs CodeSonar 4.0p1: 1 tool with 1 version. Language = C/C++; Platform = All Platforms Except Android
        # Moved to v1.23   # tool_uuid: 5540d2be-72b2-11e5-865f-001a4a81450b
        # Moved to v1.23   # tool_version_uuid: 68f4a0c7-72b2-11e5-865f-001a4a81450b
        # Moved to v1.23 insert into tool_shed.tool
        # Moved to v1.23   (tool_uuid, tool_owner_uuid, name, description, tool_sharing_status, is_build_needed) values
        # Moved to v1.23   ('5540d2be-72b2-11e5-865f-001a4a81450b','80835e30-d527-11e2-8b8b-0800200c9a66','CodeSonar','CodeSonar, GrammaTech''s flagship static analysis software, identifies programming bugs that can result in system crashes, memory corruption, leaks, data races, and security vulnerabilities. <a href="http://www.grammatech.com/codesonar">http://www.grammatech.com/codesonar/</a>', 'PUBLIC',0);
        # Moved to v1.23 insert into tool_shed.tool_version
        # Moved to v1.23   (tool_version_uuid, tool_uuid, version_string, release_date, comment_public, comment_private,
        # Moved to v1.23   tool_path, tool_executable, tool_arguments, tool_directory, checksum)
        # Moved to v1.23 values
        # Moved to v1.23 ('68f4a0c7-72b2-11e5-865f-001a4a81450b','5540d2be-72b2-11e5-865f-001a4a81450b','4.0p1', now(), 'GrammaTech CodeSonar 4.0p1', NULL,
        # Moved to v1.23 '/swamp/store/SCATools/codesonar/gt-csonar-4.0p1.tar', 'codesonar/bin/codesonar', '', 'codesonar-4.0p1',
        # Moved to v1.23 '00311161bca0bb6863303d6fb56e4f7d6bacdc39fd7717f6037a72d5605837bf7bcb158417bc9e635e6df50a8c26c8d8ed55c38559be137611b9ccc4708a045a');
        # Moved to v1.23 insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('5540d2be-72b2-11e5-865f-001a4a81450b', '68f4a0c7-72b2-11e5-865f-001a4a81450b',1);
        # Moved to v1.23 #insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('5540d2be-72b2-11e5-865f-001a4a81450b', '48f9a9b0-976f-11e4-829b-001a4a81450b'); # Android
        # Moved to v1.23 insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('5540d2be-72b2-11e5-865f-001a4a81450b', 'ee2c1193-209b-11e3-9a3e-001a4a81450b'); # Debian Linux
        # Moved to v1.23 insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('5540d2be-72b2-11e5-865f-001a4a81450b', '8a51ecea-209d-11e3-9a3e-001a4a81450b'); # Fedora Linux
        # Moved to v1.23 insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('5540d2be-72b2-11e5-865f-001a4a81450b', 'd531f0f0-f273-11e3-8775-001a4a81450b'); # Red Hat Enterprise Linux 32-bit
        # Moved to v1.23 insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('5540d2be-72b2-11e5-865f-001a4a81450b', 'fc55810b-09d7-11e3-a239-001a4a81450b'); # Red Hat Enterprise Linux 64-bit
        # Moved to v1.23 insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('5540d2be-72b2-11e5-865f-001a4a81450b', 'a4f024eb-f317-11e3-8775-001a4a81450b'); # Scientific Linux 32-bit
        # Moved to v1.23 insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('5540d2be-72b2-11e5-865f-001a4a81450b', 'd95fcb5f-209d-11e3-9a3e-001a4a81450b'); # Scientific Linux 64-bit
        # Moved to v1.23 insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('5540d2be-72b2-11e5-865f-001a4a81450b', '1088c3ce-20aa-11e3-9a3e-001a4a81450b'); # Ubuntu Linux

        # Clang - Update Existing Version 3.3
          # New version does not require specialized_tool_version table
        delete from tool_shed.specialized_tool_version where tool_uuid = 'f212557c-3050-11e3-9a3e-001a4a81450b';
        update tool_shed.tool_version
           set tool_path = '/swamp/store/SCATools/clang/clang-sa-3.3.tar',
               tool_executable = 'bin/scan-build/scan-build',
               tool_arguments = '',
               tool_directory = 'clang-sa-3.3',
               checksum = 'a543093d7fca3d3de419f4a742dd48657268f4616c45e71732fa8e3bf7816b5ad08aabbf118c1147d10435541a04247df0c6ac58a29eb5eefdfd6bf92d2c5e12'
          where tool_version_uuid = '8ec206ff-f59b-11e3-8775-001a4a81450b';

        # New Version of Clang 3.7: 1 version. Not using the specialized tool table Language = C/C++; Platform = All Platforms Except Android
          # tool_uuid: f212557c-3050-11e3-9a3e-001a4a81450b
          # tool_version_uuid: 90554576-81a0-11e5-865f-001a4a81450b
          # tool_shed.tool_platform records already exist. They're for the tool, not specific to tool version.
        insert into tool_shed.tool_version
          (tool_version_uuid, tool_uuid, version_string, release_date, comment_public, comment_private,
          tool_path, tool_executable, tool_arguments, tool_directory, checksum)
        values
        ('90554576-81a0-11e5-865f-001a4a81450b','f212557c-3050-11e3-9a3e-001a4a81450b','3.7', now(), 'Clang Static Analyzer 3.7', NULL,
        '/swamp/store/SCATools/clang/clang-sa-3.7.0.tar', 'bin/scan-build/scan-build', '', 'clang-sa-3.7.0',
        '2416e3bd67816098a7dcb29a080d61622e975675166ca788b3f944f91c6ff43c37fec5557f077058aec3a62c10581523c9a88b54d9f165dabd46054af8089de2');
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('f212557c-3050-11e3-9a3e-001a4a81450b', '90554576-81a0-11e5-865f-001a4a81450b',1);

        # cppcheck - Update Existing Version 1.61
          # New version does not require specialized_tool_version table
        delete from tool_shed.specialized_tool_version where tool_uuid = '163e5d8c-156e-11e3-a239-001a4a81450b';
        update tool_shed.tool_version
           set tool_path = '/swamp/store/SCATools/cppcheck/cppcheck-1.61.tar',
               tool_executable = 'bin/cppcheck',
               tool_arguments = '',
               tool_directory = 'cppcheck-1.61',
               checksum = '7754de972e4489be2923269f06a875f55accceeb3a0eceb81a3ffbea49da3f032515447944595597dc20dea6b5e96164fed7740c4d9fff23fad27910899c999b'
          where tool_version_uuid = '950734d0-f59b-11e3-8775-001a4a81450b';

        # New Version of cppcheck 1.70: 1 version. Not using the specialized tool table Language = C/C++; Platform = All Platforms Except Android
          # tool_uuid: 163e5d8c-156e-11e3-a239-001a4a81450b
          # tool_version_uuid: e9cea65f-833e-11e5-865f-001a4a81450b
          # tool_shed.tool_platform records already exist. They're for the tool, not specific to tool version.
        insert into tool_shed.tool_version
          (tool_version_uuid, tool_uuid, version_string, release_date, comment_public, comment_private,
          tool_path, tool_executable, tool_arguments, tool_directory, checksum)
        values
        ('e9cea65f-833e-11e5-865f-001a4a81450b','163e5d8c-156e-11e3-a239-001a4a81450b','1.70', now(), 'Cppcheck 1.70', NULL,
        '/swamp/store/SCATools/cppcheck/cppcheck-1.70.tar', 'bin/cppcheck', '', 'cppcheck-1.70',
        '523d79429c87f5bde3c0eca8a4c641778860c32b0e8868adb104dcc28056d8d35524deadce9f19bf95f28cb8b92e1fbc4ec9a01b07d13e92f2bfcb06fbaf0751');
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('163e5d8c-156e-11e3-a239-001a4a81450b', 'e9cea65f-833e-11e5-865f-001a4a81450b',1);

        # GCC - Update Existing Version current
        update tool_shed.tool_version
           set tool_path = '/swamp/store/SCATools/gcc/gcc-warn-0.9.tar.gz',
               tool_executable = '',
               tool_arguments = '',
               tool_directory = '',
               checksum = 'd97c43bd44ca4ec9c58e7fba2baff0536261d633ad6d53f09f84aa4427cc5fae4f1d350c0de681b24d85f470c86b26dd812db0c41e9795729f1296cfae558d4d'
          where tool_version_uuid = '325CA868-0D19-4B00-B034-3786887541AA';

        # Moved to v1.23 # GrammaTech CodeSonar policy
        # Moved to v1.23 update tool_shed.tool set policy_code = 'codesonar-user-policy' where tool_uuid = '5540d2be-72b2-11e5-865f-001a4a81450b';

        # update database version number
        insert into assessment.database_version (database_version_no, description) values (script_version_no, 'upgrade to v1.22');

        commit;
      end;
    end if;
END
$$
DELIMITER ;
