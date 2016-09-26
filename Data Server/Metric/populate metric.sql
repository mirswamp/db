# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2016 Software Assurance Marketplace

# populate Metrics DB
use metric;

# populate Metric Tools
        # Cloc - new metric tool. version 1.64: 1 version. Language = All, except "Android .apk" "Java 7 Bytecode" and "Java 8 Bytecode"
          # tool_uuid: 0726f1df-3e40-11e6-a6cc-001a4a81450b
          # tool_version_uuid: 129d61a0-3e40-11e6-a6cc-001a4a81450b
        # delete if exists
        delete from metric.metric_tool_language where metric_tool_uuid = '0726f1df-3e40-11e6-a6cc-001a4a81450b';
        delete from metric.metric_tool_version where metric_tool_uuid = '0726f1df-3e40-11e6-a6cc-001a4a81450b';
        delete from metric.metric_tool where metric_tool_uuid = '0726f1df-3e40-11e6-a6cc-001a4a81450b';

        insert into metric.metric_tool (
            metric_tool_uuid,
            metric_tool_owner_uuid,
            name,
            description,
            tool_sharing_status,
            is_build_needed)
          values (
            '0726f1df-3e40-11e6-a6cc-001a4a81450b',
            '80835e30-d527-11e2-8b8b-0800200c9a66',
            'cloc',
            'cloc counts blank lines, comment lines, and physical lines of source code in many programming languages. https://github.com/AlDanial/cloc',
            'PUBLIC',
            1);

        insert into metric.metric_tool_version
          (metric_tool_version_uuid, metric_tool_uuid, version_no, version_string, tool_path, checksum)
        values
        ('129d61a0-3e40-11e6-a6cc-001a4a81450b','0726f1df-3e40-11e6-a6cc-001a4a81450b', 1, '1.64', '/swamp/store/SCATools/cloc/cloc-1.64-3.tar',
        '30006a1eb5899ab9957010c3acf4c76715a6e4e8445ad8b6296a7e637d2e2f8d0359c39e21dd68c70d811610786b068f7204dbec59a5eb19c2be6c7f6fb65126');

        insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('0726f1df-3e40-11e6-a6cc-001a4a81450b', 1);  # C/C++
        insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('0726f1df-3e40-11e6-a6cc-001a4a81450b', 2);  # Java 7 Source Code
        #insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('0726f1df-3e40-11e6-a6cc-001a4a81450b', 3);  # Java 7 Bytecode
        insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('0726f1df-3e40-11e6-a6cc-001a4a81450b', 4);  # Python2
        insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('0726f1df-3e40-11e6-a6cc-001a4a81450b', 5);  # Python3
        insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('0726f1df-3e40-11e6-a6cc-001a4a81450b', 6);  # Android Java Source Code
        insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('0726f1df-3e40-11e6-a6cc-001a4a81450b', 7);  # Ruby
        insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('0726f1df-3e40-11e6-a6cc-001a4a81450b', 8);  # Ruby Sinatra
        insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('0726f1df-3e40-11e6-a6cc-001a4a81450b', 9);  # Ruby on Rails
        insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('0726f1df-3e40-11e6-a6cc-001a4a81450b', 10); # Ruby Padrino
        #insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('0726f1df-3e40-11e6-a6cc-001a4a81450b', 11); # Android .apk
        insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('0726f1df-3e40-11e6-a6cc-001a4a81450b', 12); # Java 8 Source Code
        #insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('0726f1df-3e40-11e6-a6cc-001a4a81450b', 13); # Java 8 Bytecode


        # Lizard - new metric tool. version 1.10.4: 1 version. Language = All, except "Android .apk" "Java 7 Bytecode" and "Java 8 Bytecode"
          # tool_uuid: 9692f64b-3e43-11e6-a6cc-001a4a81450b
          # tool_version_uuid: a6e4d49b-3e43-11e6-a6cc-001a4a81450b
        # delete if exists
        delete from metric.metric_tool_language where metric_tool_uuid = '9692f64b-3e43-11e6-a6cc-001a4a81450b';
        delete from metric.metric_tool_version where metric_tool_uuid = '9692f64b-3e43-11e6-a6cc-001a4a81450b';
        delete from metric.metric_tool where metric_tool_uuid = '9692f64b-3e43-11e6-a6cc-001a4a81450b';

        insert into metric.metric_tool (
            metric_tool_uuid,
            metric_tool_owner_uuid,
            name,
            description,
            tool_sharing_status,
            is_build_needed)
          values (
            '9692f64b-3e43-11e6-a6cc-001a4a81450b',
            '80835e30-d527-11e2-8b8b-0800200c9a66',
            'Lizard',
            'A code analyzer. https://pypi.python.org/pypi/lizard',
            'PUBLIC',
            1);

        insert into metric.metric_tool_version
          (metric_tool_version_uuid, metric_tool_uuid, version_no, version_string, tool_path, checksum)
        values
        ('a6e4d49b-3e43-11e6-a6cc-001a4a81450b','9692f64b-3e43-11e6-a6cc-001a4a81450b', 1, '1.10.4', '/swamp/store/SCATools/lizard/lizard-1.10.4-3.tar',
        '29c8691399e5fd56e8a460b32966f2d2264263da3cad0fe3e5b2dfcfe84061f70433c543183ce943f69c2c794011adb9739835c44ccba5cbcd23946f8b92a3c0');

        insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('9692f64b-3e43-11e6-a6cc-001a4a81450b', 1);  # C/C++
        insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('9692f64b-3e43-11e6-a6cc-001a4a81450b', 2);  # Java 7 Source Code
        #insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('9692f64b-3e43-11e6-a6cc-001a4a81450b', 3);  # Java 7 Bytecode
        insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('9692f64b-3e43-11e6-a6cc-001a4a81450b', 4);  # Python2
        insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('9692f64b-3e43-11e6-a6cc-001a4a81450b', 5);  # Python3
        insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('9692f64b-3e43-11e6-a6cc-001a4a81450b', 6);  # Android Java Source Code
        insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('9692f64b-3e43-11e6-a6cc-001a4a81450b', 7);  # Ruby
        insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('9692f64b-3e43-11e6-a6cc-001a4a81450b', 8);  # Ruby Sinatra
        insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('9692f64b-3e43-11e6-a6cc-001a4a81450b', 9);  # Ruby on Rails
        insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('9692f64b-3e43-11e6-a6cc-001a4a81450b', 10); # Ruby Padrino
        #insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('9692f64b-3e43-11e6-a6cc-001a4a81450b', 11); # Android .apk
        insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('9692f64b-3e43-11e6-a6cc-001a4a81450b', 12); # Java 8 Source Code
        #insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('9692f64b-3e43-11e6-a6cc-001a4a81450b', 13); # Java 8 Bytecode


