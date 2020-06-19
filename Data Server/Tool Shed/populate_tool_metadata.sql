# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2020 Software Assurance Marketplace

delete from tool_shed.tool_language;
delete from tool_shed.tool_platform;
delete from tool_shed.tool_viewer_incompatibility;
delete from metric.metric_tool_language;

###############################
# tool_language table inserts #
###############################
# The tool_language table is used to link tool_version records to package_type records.
# tool_language records are used to determine which tools are available to assess a given package.
# tool_language records are used primarily when adding new assessment records (assessment.assessment_run)
# tool_language records are also used, in conjunction with tool_platform records to update the package_store.package_type table when a new platform is added to a SWAMP-in-a-Box installation.
# tool_language metadata is not needed for deprecated tool versions.
# Note that for add-on tools in a SWAMP-in-a-Box, there will be separate tool_language_version records linking user-specific tool_version records to package_type records.

# tool_language inserts for C/C++ tools
#
# Clang Static Analyzer (f212557c-3050-11e3-9a3e-001a4a81450b) to package_type C/C++ (1)
# version 3.8 (ea38477e-16cc-11e6-807f-001a4a81450b)
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('f212557c-3050-11e3-9a3e-001a4a81450b','ea38477e-16cc-11e6-807f-001a4a81450b',1);
#
# cppcheck (163e5d8c-156e-11e3-a239-001a4a81450b) to package_type C/C++ (1)
# version 1.75 (edef671e-7b79-11e6-88bc-001a4a81450b)
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('163e5d8c-156e-11e3-a239-001a4a81450b','edef671e-7b79-11e6-88bc-001a4a81450b',1);
#
# GCC (7A08B82D-3A3B-45CA-8644-105088741AF6) to package_type C/C++ (1)
# version current (325CA868-0D19-4B00-B034-3786887541AA)
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('7A08B82D-3A3B-45CA-8644-105088741AF6','325CA868-0D19-4B00-B034-3786887541AA',1);
#
# GrammaTech CodeSonar (5540d2be-72b2-11e5-865f-001a4a81450b) to package_type C/C++ (1)
# version 4.4 (68f4a0c7-72b2-11e5-865f-001a4a81450b)
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('5540d2be-72b2-11e5-865f-001a4a81450b','68f4a0c7-72b2-11e5-865f-001a4a81450b',1);
#
# Parasoft C/C++test (4bb2644d-6440-11e4-a282-001a4a81450b) to package_type C/C++ (1)
# version 10.4.2 (90214418-ac9e-11e9-ac7a-001a4a81450b)
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('4bb2644d-6440-11e4-a282-001a4a81450b','90214418-ac9e-11e9-ac7a-001a4a81450b',1);

# tool_language inserts for Java tools
#
# checkstyle (992A48A5-62EC-4EE9-8429-45BB94275A41) to package_type Java 7 Source Code (2), Java 8 Source Code (12), Android Java Source Code (6)
# version 8.20 (4bd668fc-6ddd-11e9-919e-001a4a81450b)
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('992A48A5-62EC-4EE9-8429-45BB94275A41','4bd668fc-6ddd-11e9-919e-001a4a81450b',2);
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('992A48A5-62EC-4EE9-8429-45BB94275A41','4bd668fc-6ddd-11e9-919e-001a4a81450b',6);
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('992A48A5-62EC-4EE9-8429-45BB94275A41','4bd668fc-6ddd-11e9-919e-001a4a81450b',12);
#
# error-prone 2.x (56872C2E-1D78-4DB0-B976-83ACF5424C52) to package_type Java 7 Source Code (2), Java 8 Source Code (12), Android Java Source Code (6)
# version 2.3.1 (8d86df85-6dd8-11e9-919e-001a4a81450b)
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('56872C2E-1D78-4DB0-B976-83ACF5424C52','8d86df85-6dd8-11e9-919e-001a4a81450b',2);
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('56872C2E-1D78-4DB0-B976-83ACF5424C52','8d86df85-6dd8-11e9-919e-001a4a81450b',6);
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('56872C2E-1D78-4DB0-B976-83ACF5424C52','8d86df85-6dd8-11e9-919e-001a4a81450b',12);
# error-prone 1.x (56872C2E-1D78-4DB0-B976-83ACF5424C52) to package_type Java 7 Source Code (2), Android Java Source Code (6)
# version 1.1.1 (5230FE76-E658-4B3A-AD40-7D55F7A21955)
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('56872C2E-1D78-4DB0-B976-83ACF5424C52','5230FE76-E658-4B3A-AD40-7D55F7A21955',2);
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('56872C2E-1D78-4DB0-B976-83ACF5424C52','5230FE76-E658-4B3A-AD40-7D55F7A21955',6);
#
# OWASP Dependency Check (d032d8ec-9184-11e6-88bc-001a4a81450b) to package_type Java 7 Source Code (2), Java 7 Bytecode (3), Java 8 Source Code (12), Java 8 Bytecode (13), Android Java Source Code (6), Android .apk (11)
# version 2.1.1 (d15ed849-ce25-11e7-ad4c-001a4a81450b)
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('d032d8ec-9184-11e6-88bc-001a4a81450b','d15ed849-ce25-11e7-ad4c-001a4a81450b',2);
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('d032d8ec-9184-11e6-88bc-001a4a81450b','d15ed849-ce25-11e7-ad4c-001a4a81450b',3);
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('d032d8ec-9184-11e6-88bc-001a4a81450b','d15ed849-ce25-11e7-ad4c-001a4a81450b',6);
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('d032d8ec-9184-11e6-88bc-001a4a81450b','d15ed849-ce25-11e7-ad4c-001a4a81450b',11);
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('d032d8ec-9184-11e6-88bc-001a4a81450b','d15ed849-ce25-11e7-ad4c-001a4a81450b',12);
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('d032d8ec-9184-11e6-88bc-001a4a81450b','d15ed849-ce25-11e7-ad4c-001a4a81450b',13);
#
# PMD (163f2b01-156e-11e3-a239-001a4a81450b) to package_type Java 7 Source Code (2), Java 8 Source Code (12), Android Java Source Code (6)
# version 6.14.0 (57a9f78b-acab-11e9-ac7a-001a4a81450b)
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('163f2b01-156e-11e3-a239-001a4a81450b','57a9f78b-acab-11e9-ac7a-001a4a81450b',2);
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('163f2b01-156e-11e3-a239-001a4a81450b','57a9f78b-acab-11e9-ac7a-001a4a81450b',6);
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('163f2b01-156e-11e3-a239-001a4a81450b','57a9f78b-acab-11e9-ac7a-001a4a81450b',12);
#
# SpotBugs (ed42d79c-ce26-11e7-ad4c-001a4a81450b) to package_type Java 7 Source Code (2), Java 7 Bytecode (3), Java 8 Source Code (12), Java 8 Bytecode (13), Android Java Source Code (6)
# version 3.1.12 (7fb41eb3-6784-11e9-919e-001a4a81450b)
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('ed42d79c-ce26-11e7-ad4c-001a4a81450b','7fb41eb3-6784-11e9-919e-001a4a81450b',2);
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('ed42d79c-ce26-11e7-ad4c-001a4a81450b','7fb41eb3-6784-11e9-919e-001a4a81450b',3);
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('ed42d79c-ce26-11e7-ad4c-001a4a81450b','7fb41eb3-6784-11e9-919e-001a4a81450b',6);
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('ed42d79c-ce26-11e7-ad4c-001a4a81450b','7fb41eb3-6784-11e9-919e-001a4a81450b',12);
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('ed42d79c-ce26-11e7-ad4c-001a4a81450b','7fb41eb3-6784-11e9-919e-001a4a81450b',13);
#
# Parasoft Jtest (6197a593-6440-11e4-a282-001a4a81450b) to package_type Java 7 Source Code (2), Java 8 Source Code (12), Android Java Source Code (6)
# version 10.4.2 (1b1c2e25-ac9f-11e9-ac7a-001a4a81450b)
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('6197a593-6440-11e4-a282-001a4a81450b','1b1c2e25-ac9f-11e9-ac7a-001a4a81450b',2);
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('6197a593-6440-11e4-a282-001a4a81450b','1b1c2e25-ac9f-11e9-ac7a-001a4a81450b',6);
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('6197a593-6440-11e4-a282-001a4a81450b','1b1c2e25-ac9f-11e9-ac7a-001a4a81450b',12);

# tool_language inserts for Android tools
#
# Android lint (9289b560-8f8b-11e4-829b-001a4a81450b) to package_type Android Java Source Code (6)
# version 0.1.5 (2f314dde-2069-11e7-be48-001a4a81450b)
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('9289b560-8f8b-11e4-829b-001a4a81450b','2f314dde-2069-11e7-be48-001a4a81450b',6);

# tool_language inserts for Python tools
#
# Bandit (7fbfa454-8f9f-11e4-829b-001a4a81450b) to package_type Python3 (5)
# version 1.3.0 for Python3 (5f258cae-de8e-11e6-bf70-001a4a81450b)
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('7fbfa454-8f9f-11e4-829b-001a4a81450b','5f258cae-de8e-11e6-bf70-001a4a81450b',5);
# Bandit (7fbfa454-8f9f-11e4-829b-001a4a81450b) to package_type Python2 (4)
# version 1.3.0 for Python2 (b46fdde3-162c-11e7-be48-001a4a81450b)
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('7fbfa454-8f9f-11e4-829b-001a4a81450b','b46fdde3-162c-11e7-be48-001a4a81450b',4);
#
# Flake8 (63695cd8-a73e-11e4-a335-001a4a81450b) to package_type Python3 (5)
# version 3.2.1 for Python3 (0a01266d-de92-11e6-bf70-001a4a81450b)
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('63695cd8-a73e-11e4-a335-001a4a81450b','0a01266d-de92-11e6-bf70-001a4a81450b',5);
# Flake8 (63695cd8-a73e-11e4-a335-001a4a81450b) to package_type Python2 (4)
# version 3.2.1 for Python2 (d2f762a9-1a3b-11e7-be48-001a4a81450b)
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('63695cd8-a73e-11e4-a335-001a4a81450b','d2f762a9-1a3b-11e7-be48-001a4a81450b',4);
#
# Pylint (0f668fb0-4421-11e4-a4f3-001a4a81450b) to package_type Python3 (5)
# version 1.6.4 for Python3 (1e288d3e-de82-11e6-bf70-001a4a81450b)
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('0f668fb0-4421-11e4-a4f3-001a4a81450b','1e288d3e-de82-11e6-bf70-001a4a81450b',5);
# Pylint (0f668fb0-4421-11e4-a4f3-001a4a81450b) to package_type Python2 (4)
# version 1.6.4 for Python2 (eae185c9-1a3d-11e7-be48-001a4a81450b)
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('0f668fb0-4421-11e4-a4f3-001a4a81450b','eae185c9-1a3d-11e7-be48-001a4a81450b',4);

# tool_language inserts for Ruby tools
#
# Brakeman (5cd726a5-4053-11e5-83f1-001a4a81450b) to package _type Ruby on Rails (9)
# version 3.4.1 (9dbed035-2076-11e7-be48-001a4a81450b)
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('5cd726a5-4053-11e5-83f1-001a4a81450b','9dbed035-2076-11e7-be48-001a4a81450b',9);
#
# Dawn (b9560648-4057-11e5-83f1-001a4a81450b) to package_type Ruby Sinatra (8), Ruby on Rails (9), Ruby Padrino (10)
# version 1.6.7 (fb13245e-2076-11e7-be48-001a4a81450b)
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('b9560648-4057-11e5-83f1-001a4a81450b','fb13245e-2076-11e7-be48-001a4a81450b',8);
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('b9560648-4057-11e5-83f1-001a4a81450b','fb13245e-2076-11e7-be48-001a4a81450b',9);
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('b9560648-4057-11e5-83f1-001a4a81450b','fb13245e-2076-11e7-be48-001a4a81450b',10);
#
# Reek (8157e489-1fbc-11e5-b6a7-001a4a81450b) to package _type Ruby (7), Ruby Sinatra (8), Ruby on Rails (9), Ruby Padrino (10)
# version 4.5.4 (66aac010-2077-11e7-be48-001a4a81450b)
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('8157e489-1fbc-11e5-b6a7-001a4a81450b','66aac010-2077-11e7-be48-001a4a81450b',7);
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('8157e489-1fbc-11e5-b6a7-001a4a81450b','66aac010-2077-11e7-be48-001a4a81450b',8);
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('8157e489-1fbc-11e5-b6a7-001a4a81450b','66aac010-2077-11e7-be48-001a4a81450b',9);
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('8157e489-1fbc-11e5-b6a7-001a4a81450b','66aac010-2077-11e7-be48-001a4a81450b',10);
#
# RuboCop (ebcab7f6-0935-11e5-b6a7-001a4a81450b) to package_type Ruby (7), Ruby Sinatra (8), Ruby on Rails (9), Ruby Padrino (10)
# version 0.47 (067047b5-2078-11e7-be48-001a4a81450b)
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('ebcab7f6-0935-11e5-b6a7-001a4a81450b','067047b5-2078-11e7-be48-001a4a81450b',7);
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('ebcab7f6-0935-11e5-b6a7-001a4a81450b','067047b5-2078-11e7-be48-001a4a81450b',8);
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('ebcab7f6-0935-11e5-b6a7-001a4a81450b','067047b5-2078-11e7-be48-001a4a81450b',9);
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('ebcab7f6-0935-11e5-b6a7-001a4a81450b','067047b5-2078-11e7-be48-001a4a81450b',10);

# tool_language inserts for Web Scripting tools
#
# CSS Lint (4ae25a9c-b741-11e6-bf70-001a4a81450b) to package_type Web Scripting (14)
# version 1.0.4 (808990dd-b741-11e6-bf70-001a4a81450b)
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('4ae25a9c-b741-11e6-bf70-001a4a81450b','808990dd-b741-11e6-bf70-001a4a81450b',14);
#
# ESLint (3309c1e0-b741-11e6-bf70-001a4a81450b) to package_type Web Scripting (14)
# version 6.4.0 (77bdaf61-dfdb-11e9-ac7a-001a4a81450b)
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('3309c1e0-b741-11e6-bf70-001a4a81450b','77bdaf61-dfdb-11e9-ac7a-001a4a81450b',14);
#
# Flow (3ef639d4-b741-11e6-bf70-001a4a81450b) to package_type Web Scripting (14)
# version 0.112.0 (de77cea5-1d0b-11ea-844c-001a4a81450b)
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('3ef639d4-b741-11e6-bf70-001a4a81450b','de77cea5-1d0b-11ea-844c-001a4a81450b',14);
#
# HTML Tidy (44ec433d-b741-11e6-bf70-001a4a81450b) to package_type Web Scripting (14)
# version 5.2.0 (7a93738b-b741-11e6-bf70-001a4a81450b)
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('44ec433d-b741-11e6-bf70-001a4a81450b','7a93738b-b741-11e6-bf70-001a4a81450b',14);
#
# JSHint (39001e1f-b741-11e6-bf70-001a4a81450b) to package_type Web Scripting (14)
# version 2.9.4 (6ea71506-b741-11e6-bf70-001a4a81450b)
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('39001e1f-b741-11e6-bf70-001a4a81450b','6ea71506-b741-11e6-bf70-001a4a81450b',14);
#
# PHPMD (56ce7899-b741-11e6-bf70-001a4a81450b) to package_type Web Scripting (14)
# version 2.6.0-SWAMP (7a78b463-6778-11e9-919e-001a4a81450b)
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('56ce7899-b741-11e6-bf70-001a4a81450b','7a78b463-6778-11e9-919e-001a4a81450b',14);
#
# PHP_CodeSniffer (5cc49bb0-b741-11e6-bf70-001a4a81450b) to package_type Web Scripting (14)
# version 3.0.0 (932a2260-d9d5-11e6-bf70-001a4a81450b)
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('5cc49bb0-b741-11e6-bf70-001a4a81450b','932a2260-d9d5-11e6-bf70-001a4a81450b',14);
#
# Retire.js (62babae5-b741-11e6-bf70-001a4a81450b) to package_type Web Scripting (14)
# version 2.0.3 (0fe959e8-46b5-11ea-844c-001a4a81450b)
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('62babae5-b741-11e6-bf70-001a4a81450b','0fe959e8-46b5-11ea-844c-001a4a81450b',14);
#
# XML Lint (50d8714c-b741-11e6-bf70-001a4a81450b) to package_type Web Scripting (14)
# version 2.9.4 (867fa2de-b741-11e6-bf70-001a4a81450b)
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('50d8714c-b741-11e6-bf70-001a4a81450b','867fa2de-b741-11e6-bf70-001a4a81450b',14);

# tool_language inserts for .NET tools
#
# Code Cracker (7ae10625-cbf4-11e8-919e-001a4a81450b) to package_type .NET (15)
# version 1.1.0 (d01c25be-cbf4-11e8-919e-001a4a81450b)
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('7ae10625-cbf4-11e8-919e-001a4a81450b','d01c25be-cbf4-11e8-919e-001a4a81450b',15);
#
# DevSkim (9bf55860-cbf4-11e8-919e-001a4a81450b) to package_type .NET (15)
# version 0.1.10 (c4dbea7b-cbf4-11e8-919e-001a4a81450b)
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('9bf55860-cbf4-11e8-919e-001a4a81450b','c4dbea7b-cbf4-11e8-919e-001a4a81450b',15);
#
# Security Code Scan (82bc205f-cbf7-11e8-919e-001a4a81450b) to package_type .NET (15)
# version 2.7.1 (6f2981fa-cbf7-11e8-919e-001a4a81450b)
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('82bc205f-cbf7-11e8-919e-001a4a81450b','6f2981fa-cbf7-11e8-919e-001a4a81450b',15);

###############################
# tool_platform table inserts #
###############################
# The tool_platform table is used to link tool records to platform records.
# tool_platform records are used to determine which platforms are available for assessment of a given package with a given tool.
# tool_platform records are used primarily when adding new assessment records (assessment.assessment_run)
# tool_platform records are also used, in conjunction with tool_language records to update the package_store.package_type table when a new platform is added to a SWAMP-in-a-Box installation.
# tool_platform metadata is not needed for deprecated tools nor for deprecated platforms.
#
# For reference:
#
# Current Platforms:
# Android Platform (48f9a9b0-976f-11e4-829b-001a4a81450b)
# CentOS Platform (071890c4-7c3b-11e6-88bc-001a4a81450b)
# Debian Platform (ee2c1193-209b-11e3-9a3e-001a4a81450b)
# Fedora Platform (8a51ecea-209d-11e3-9a3e-001a4a81450b)
# Scientific Platform (d95fcb5f-209d-11e3-9a3e-001a4a81450b)
# Ubuntu Platform (1088c3ce-20aa-11e3-9a3e-001a4a81450b)

# tool_platform inserts for C/C++ tools
# C/C++ tools run on all platforms except for Android
#
# Clang Static Analyzer (f212557c-3050-11e3-9a3e-001a4a81450b)
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('f212557c-3050-11e3-9a3e-001a4a81450b','071890c4-7c3b-11e6-88bc-001a4a81450b');
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('f212557c-3050-11e3-9a3e-001a4a81450b','1088c3ce-20aa-11e3-9a3e-001a4a81450b');
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('f212557c-3050-11e3-9a3e-001a4a81450b','8a51ecea-209d-11e3-9a3e-001a4a81450b');
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('f212557c-3050-11e3-9a3e-001a4a81450b','d95fcb5f-209d-11e3-9a3e-001a4a81450b');
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('f212557c-3050-11e3-9a3e-001a4a81450b','ee2c1193-209b-11e3-9a3e-001a4a81450b');
#
# cppcheck (163e5d8c-156e-11e3-a239-001a4a81450b)
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('163e5d8c-156e-11e3-a239-001a4a81450b','071890c4-7c3b-11e6-88bc-001a4a81450b');
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('163e5d8c-156e-11e3-a239-001a4a81450b','1088c3ce-20aa-11e3-9a3e-001a4a81450b');
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('163e5d8c-156e-11e3-a239-001a4a81450b','8a51ecea-209d-11e3-9a3e-001a4a81450b');
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('163e5d8c-156e-11e3-a239-001a4a81450b','d95fcb5f-209d-11e3-9a3e-001a4a81450b');
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('163e5d8c-156e-11e3-a239-001a4a81450b','ee2c1193-209b-11e3-9a3e-001a4a81450b');
#
# GCC (7A08B82D-3A3B-45CA-8644-105088741AF6)
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('7A08B82D-3A3B-45CA-8644-105088741AF6','071890c4-7c3b-11e6-88bc-001a4a81450b');
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('7A08B82D-3A3B-45CA-8644-105088741AF6','1088c3ce-20aa-11e3-9a3e-001a4a81450b');
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('7A08B82D-3A3B-45CA-8644-105088741AF6','8a51ecea-209d-11e3-9a3e-001a4a81450b');
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('7A08B82D-3A3B-45CA-8644-105088741AF6','d95fcb5f-209d-11e3-9a3e-001a4a81450b');
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('7A08B82D-3A3B-45CA-8644-105088741AF6','ee2c1193-209b-11e3-9a3e-001a4a81450b');
#
# GrammaTech CodeSonar (5540d2be-72b2-11e5-865f-001a4a81450b)
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('5540d2be-72b2-11e5-865f-001a4a81450b','071890c4-7c3b-11e6-88bc-001a4a81450b');
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('5540d2be-72b2-11e5-865f-001a4a81450b','1088c3ce-20aa-11e3-9a3e-001a4a81450b');
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('5540d2be-72b2-11e5-865f-001a4a81450b','8a51ecea-209d-11e3-9a3e-001a4a81450b');
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('5540d2be-72b2-11e5-865f-001a4a81450b','d95fcb5f-209d-11e3-9a3e-001a4a81450b');
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('5540d2be-72b2-11e5-865f-001a4a81450b','ee2c1193-209b-11e3-9a3e-001a4a81450b');
#
# Parasoft C/C++test (4bb2644d-6440-11e4-a282-001a4a81450b)
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('4bb2644d-6440-11e4-a282-001a4a81450b','071890c4-7c3b-11e6-88bc-001a4a81450b');
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('4bb2644d-6440-11e4-a282-001a4a81450b','1088c3ce-20aa-11e3-9a3e-001a4a81450b');
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('4bb2644d-6440-11e4-a282-001a4a81450b','8a51ecea-209d-11e3-9a3e-001a4a81450b');
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('4bb2644d-6440-11e4-a282-001a4a81450b','d95fcb5f-209d-11e3-9a3e-001a4a81450b');
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('4bb2644d-6440-11e4-a282-001a4a81450b','ee2c1193-209b-11e3-9a3e-001a4a81450b');
#
#Synopsis Static Analysis (Coverity) (e7a00759-82a4-11e7-9baa-001a4a81450b) DEPRECATED in mir-swamp.org, potential add-on in SWAMP-in-a-Box
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('e7a00759-82a4-11e7-9baa-001a4a81450b','071890c4-7c3b-11e6-88bc-001a4a81450b');
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('e7a00759-82a4-11e7-9baa-001a4a81450b','1088c3ce-20aa-11e3-9a3e-001a4a81450b');
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('e7a00759-82a4-11e7-9baa-001a4a81450b','8a51ecea-209d-11e3-9a3e-001a4a81450b');
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('e7a00759-82a4-11e7-9baa-001a4a81450b','d95fcb5f-209d-11e3-9a3e-001a4a81450b');
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('e7a00759-82a4-11e7-9baa-001a4a81450b','ee2c1193-209b-11e3-9a3e-001a4a81450b');

# tool_platform inserts for Java and Android tools
# Java packages are assessed on Ubuntu (16.04); Android packages are assessed on Android
#
# Android lint (9289b560-8f8b-11e4-829b-001a4a81450b) Android Only
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('9289b560-8f8b-11e4-829b-001a4a81450b','48f9a9b0-976f-11e4-829b-001a4a81450b');
#
# checkstyle (992A48A5-62EC-4EE9-8429-45BB94275A41)
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('992A48A5-62EC-4EE9-8429-45BB94275A41','1088c3ce-20aa-11e3-9a3e-001a4a81450b');
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('992A48A5-62EC-4EE9-8429-45BB94275A41','48f9a9b0-976f-11e4-829b-001a4a81450b');
#
# error-prone (56872C2E-1D78-4DB0-B976-83ACF5424C52)
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('56872C2E-1D78-4DB0-B976-83ACF5424C52','1088c3ce-20aa-11e3-9a3e-001a4a81450b');
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('56872C2E-1D78-4DB0-B976-83ACF5424C52','48f9a9b0-976f-11e4-829b-001a4a81450b');
#
# OWASP Dependency Check (d032d8ec-9184-11e6-88bc-001a4a81450b)
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('d032d8ec-9184-11e6-88bc-001a4a81450b','1088c3ce-20aa-11e3-9a3e-001a4a81450b');
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('d032d8ec-9184-11e6-88bc-001a4a81450b','48f9a9b0-976f-11e4-829b-001a4a81450b');
#
# PMD (163f2b01-156e-11e3-a239-001a4a81450b)
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('163f2b01-156e-11e3-a239-001a4a81450b','1088c3ce-20aa-11e3-9a3e-001a4a81450b');
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('163f2b01-156e-11e3-a239-001a4a81450b','48f9a9b0-976f-11e4-829b-001a4a81450b');
#
# SpotBugs (ed42d79c-ce26-11e7-ad4c-001a4a81450b)
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('ed42d79c-ce26-11e7-ad4c-001a4a81450b','1088c3ce-20aa-11e3-9a3e-001a4a81450b');
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('ed42d79c-ce26-11e7-ad4c-001a4a81450b','48f9a9b0-976f-11e4-829b-001a4a81450b');
#
# Parasoft Jtest (6197a593-6440-11e4-a282-001a4a81450b)
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('6197a593-6440-11e4-a282-001a4a81450b','1088c3ce-20aa-11e3-9a3e-001a4a81450b');
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('6197a593-6440-11e4-a282-001a4a81450b','48f9a9b0-976f-11e4-829b-001a4a81450b');

# tool_platform inserts for Python tools
# Python packages are assessed on Ubuntu (16.04)
#
# Bandit (7fbfa454-8f9f-11e4-829b-001a4a81450b)
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('7fbfa454-8f9f-11e4-829b-001a4a81450b','1088c3ce-20aa-11e3-9a3e-001a4a81450b');
#
# Flake8 (63695cd8-a73e-11e4-a335-001a4a81450b)
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('63695cd8-a73e-11e4-a335-001a4a81450b','1088c3ce-20aa-11e3-9a3e-001a4a81450b');
#
# Pylint (0f668fb0-4421-11e4-a4f3-001a4a81450b)
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('0f668fb0-4421-11e4-a4f3-001a4a81450b','1088c3ce-20aa-11e3-9a3e-001a4a81450b');

# tool_platform inserts for Ruby tools
# Ruby packages are assessed on Ubuntu (16.04)
#
# Current Platforms:
# Ubuntu Platform (1088c3ce-20aa-11e3-9a3e-001a4a81450b)
#
# Brakeman (5cd726a5-4053-11e5-83f1-001a4a81450b)
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('5cd726a5-4053-11e5-83f1-001a4a81450b','1088c3ce-20aa-11e3-9a3e-001a4a81450b');
#
# Dawn (b9560648-4057-11e5-83f1-001a4a81450b)
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('b9560648-4057-11e5-83f1-001a4a81450b','1088c3ce-20aa-11e3-9a3e-001a4a81450b');
#
# Reek (8157e489-1fbc-11e5-b6a7-001a4a81450b)
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('8157e489-1fbc-11e5-b6a7-001a4a81450b','1088c3ce-20aa-11e3-9a3e-001a4a81450b');
#
# RuboCop (ebcab7f6-0935-11e5-b6a7-001a4a81450b)
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('ebcab7f6-0935-11e5-b6a7-001a4a81450b','1088c3ce-20aa-11e3-9a3e-001a4a81450b');
#
# ruby-lint (59612f24-0946-11e5-b6a7-001a4a81450b)
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('59612f24-0946-11e5-b6a7-001a4a81450b','1088c3ce-20aa-11e3-9a3e-001a4a81450b');

# tool_platform inserts for Web Scripting tools
# Web Scripting packages are assessed on Ubuntu (16.04)
#
# CSS Lint (4ae25a9c-b741-11e6-bf70-001a4a81450b)
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('4ae25a9c-b741-11e6-bf70-001a4a81450b','1088c3ce-20aa-11e3-9a3e-001a4a81450b');
#
# ESLint (3309c1e0-b741-11e6-bf70-001a4a81450b)
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('3309c1e0-b741-11e6-bf70-001a4a81450b','1088c3ce-20aa-11e3-9a3e-001a4a81450b');
#
# Flow (3ef639d4-b741-11e6-bf70-001a4a81450b)
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('3ef639d4-b741-11e6-bf70-001a4a81450b','1088c3ce-20aa-11e3-9a3e-001a4a81450b');
#
# HTML Tidy (44ec433d-b741-11e6-bf70-001a4a81450b)
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('44ec433d-b741-11e6-bf70-001a4a81450b','1088c3ce-20aa-11e3-9a3e-001a4a81450b');
#
# JSHint (39001e1f-b741-11e6-bf70-001a4a81450b)
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('39001e1f-b741-11e6-bf70-001a4a81450b','1088c3ce-20aa-11e3-9a3e-001a4a81450b');
#
# PHP_CodeSniffer (5cc49bb0-b741-11e6-bf70-001a4a81450b)
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('5cc49bb0-b741-11e6-bf70-001a4a81450b','1088c3ce-20aa-11e3-9a3e-001a4a81450b');
#
# PHPMD (56ce7899-b741-11e6-bf70-001a4a81450b)
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('56ce7899-b741-11e6-bf70-001a4a81450b','1088c3ce-20aa-11e3-9a3e-001a4a81450b');
#
# Retire.js (62babae5-b741-11e6-bf70-001a4a81450b)
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('62babae5-b741-11e6-bf70-001a4a81450b','1088c3ce-20aa-11e3-9a3e-001a4a81450b');
#
# XML Lint (50d8714c-b741-11e6-bf70-001a4a81450b)
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('50d8714c-b741-11e6-bf70-001a4a81450b','1088c3ce-20aa-11e3-9a3e-001a4a81450b');

# tool_platform inserts for .NET tools
# .NET packages are assessed on Ubuntu (16.04)
#
# Code Cracker (7ae10625-cbf4-11e8-919e-001a4a81450b)
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('7ae10625-cbf4-11e8-919e-001a4a81450b','1088c3ce-20aa-11e3-9a3e-001a4a81450b');
#
# DevSkim (9bf55860-cbf4-11e8-919e-001a4a81450b)
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('9bf55860-cbf4-11e8-919e-001a4a81450b','1088c3ce-20aa-11e3-9a3e-001a4a81450b');
#
# Security Code Scan (82bc205f-cbf7-11e8-919e-001a4a81450b)
insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values ('82bc205f-cbf7-11e8-919e-001a4a81450b','1088c3ce-20aa-11e3-9a3e-001a4a81450b');

#############################################
# tool_viewer_incompatibility table inserts #
#############################################
# The tool_viewer_incompatibility table is used to link tool records to viewers that are not able to parse their output.
# tool_viewer_incompatibility are used to determine which viewers are available to view results for a given assessment.
# tool_viewer_incompatibility metadata is not needed for deprecated viewers.
# tool_viewer_incompatibility metadata should be maintained for deprecated tools for which there may still be existing assessments with resutls.
#
# No tools are incompatible with the Native viewer (b7289170-5c46-11e3-9fa4-001a4a81450b)

# tool_viewer_incompatibility inserts for Code Dx (4221533e-865a-11e3-88bb-001a4a81450b):
#
# Dawn (b9560648-4057-11e5-83f1-001a4a81450b)
insert into tool_shed.tool_viewer_incompatibility (tool_uuid, viewer_uuid) values ('b9560648-4057-11e5-83f1-001a4a81450b','4221533e-865a-11e3-88bb-001a4a81450b');
#
# RevealDroid (738b81f0-a828-11e5-865f-001a4a81450b) DEPRECATED
insert into tool_shed.tool_viewer_incompatibility (tool_uuid, viewer_uuid) values ('738b81f0-a828-11e5-865f-001a4a81450b','4221533e-865a-11e3-88bb-001a4a81450b');
#
# Sonatype Application Health Check (1297b728-4a1c-11e7-a337-001a4a81450b) DEPRECATED
insert into tool_shed.tool_viewer_incompatibility (tool_uuid, viewer_uuid) values ('1297b728-4a1c-11e7-a337-001a4a81450b','4221533e-865a-11e3-88bb-001a4a81450b');

######################################
# metric_tool_language table inserts #
######################################
# The metric_tool_language table is used to link metric_tool records to package_type records.
# metric_tool_language records are used to determine which metric tools are used to assess newly created package versions.
# metric_tool_language records are used internally to launch metric analysis runs when a new package/package version is generated.
# metric_tool_language metadata is not needed for deprecated metric tools.
# Currently each Metric Tool is linked to all package_types except Java 7 Bytecode (3), Java 8 Bytecode (13), Android .apk (11)

# metric_tool_language inserts
#
# cloc (0726f1df-3e40-11e6-a6cc-001a4a81450b)
insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('0726f1df-3e40-11e6-a6cc-001a4a81450b',1);
insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('0726f1df-3e40-11e6-a6cc-001a4a81450b',2);
insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('0726f1df-3e40-11e6-a6cc-001a4a81450b',4);
insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('0726f1df-3e40-11e6-a6cc-001a4a81450b',5);
insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('0726f1df-3e40-11e6-a6cc-001a4a81450b',6);
insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('0726f1df-3e40-11e6-a6cc-001a4a81450b',7);
insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('0726f1df-3e40-11e6-a6cc-001a4a81450b',8);
insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('0726f1df-3e40-11e6-a6cc-001a4a81450b',9);
insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('0726f1df-3e40-11e6-a6cc-001a4a81450b',10);
insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('0726f1df-3e40-11e6-a6cc-001a4a81450b',12);
insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('0726f1df-3e40-11e6-a6cc-001a4a81450b',14);
insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('0726f1df-3e40-11e6-a6cc-001a4a81450b',15);
#
# Lizard (9692f64b-3e43-11e6-a6cc-001a4a81450b)
insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('9692f64b-3e43-11e6-a6cc-001a4a81450b',1);
insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('9692f64b-3e43-11e6-a6cc-001a4a81450b',2);
insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('9692f64b-3e43-11e6-a6cc-001a4a81450b',4);
insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('9692f64b-3e43-11e6-a6cc-001a4a81450b',5);
insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('9692f64b-3e43-11e6-a6cc-001a4a81450b',6);
insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('9692f64b-3e43-11e6-a6cc-001a4a81450b',7);
insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('9692f64b-3e43-11e6-a6cc-001a4a81450b',8);
insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('9692f64b-3e43-11e6-a6cc-001a4a81450b',9);
insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('9692f64b-3e43-11e6-a6cc-001a4a81450b',10);
insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('9692f64b-3e43-11e6-a6cc-001a4a81450b',12);
insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('9692f64b-3e43-11e6-a6cc-001a4a81450b',14);
insert into metric.metric_tool_language (metric_tool_uuid, package_type_id) values ('9692f64b-3e43-11e6-a6cc-001a4a81450b',15);
