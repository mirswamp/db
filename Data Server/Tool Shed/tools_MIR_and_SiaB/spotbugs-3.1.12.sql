# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2019 Software Assurance Marketplace

set @tool_uuid = 'ed42d79c-ce26-11e7-ad4c-001a4a81450b';
set @tool_owner_uuid = '80835e30-d527-11e2-8b8b-0800200c9a66';
set @name = 'SpotBugs';
set @description = 'SpotBugs is a program which uses static analysis to look for bugs in Java code. <a href="https://spotbugs.github.io/">https://spotbugs.github.io/</a>';
set @tool_sharing_status = 'PUBLIC';
set @policy_code = null;
set @tool_version_uuid = '7fb41eb3-6784-11e9-919e-001a4a81450b';
set @version_no = '2';
set @version_string = '3.1.12';
set @notes = 'Spotbugs v3.1.12';
set @tool_path = '/swamp/store/SCATools/bundled/spotbugs-3.1.12.tar.gz';
set @checksum = '28167e5f31fd181c592ac05eb3ef7525437a180a46e360c41e36b4bbf7ae3203835073718a28268d18bb1ce403e19f03091f139acf4920d60ef9b4755ca2b7a7';
set @user_add_on_flag = 0;

# set findbugs to not run when user runs all tools
update tool_shed.tool set exclude_when_user_selects_all = 1 where tool_uuid = '163d56a7-156e-11e3-a239-001a4a81450b';
