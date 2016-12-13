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
        ('129d61a0-3e40-11e6-a6cc-001a4a81450b','0726f1df-3e40-11e6-a6cc-001a4a81450b', 1, '1.68', '/swamp/store/SCATools/cloc/cloc-1.68.tar',
        'c49769222abb157083256750ba4ece3b7040cee40ed046ec5b939fe351aab542fb5bbfead91161ccff9c5741449f6e344006b272583bbb13db708409cd27c6c0');

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
        ('a6e4d49b-3e43-11e6-a6cc-001a4a81450b','9692f64b-3e43-11e6-a6cc-001a4a81450b', 1, '1.12.6', '/swamp/store/SCATools/lizard/lizard-1.12.6.tar.gz',
        'ba04a305549e65d730890ca5a3db0677baa0f1a1a09eed4b0d2740ca79038c56fae5cfda0ff96424da66b801749084423b582cb415d9d2e79fbdeebd84866b47');

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


