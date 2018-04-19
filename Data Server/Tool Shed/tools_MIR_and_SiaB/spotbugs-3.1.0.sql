# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2018 Software Assurance Marketplace

set @tool_uuid = 'ed42d79c-ce26-11e7-ad4c-001a4a81450b';
set @tool_owner_uuid = '80835e30-d527-11e2-8b8b-0800200c9a66';
set @name = 'SpotBugs';
set @description = 'SpotBugs is a program which uses static analysis to look for bugs in Java code. <a href="https://spotbugs.github.io/">https://spotbugs.github.io/</a>';
set @tool_sharing_status = 'PUBLIC';
set @policy_code = null;
set @tool_version_uuid = '2942ac9e-ce27-11e7-ad4c-001a4a81450b';
set @version_no = '1';
set @version_string = '3.1.0';
set @notes = 'Spotbugs v3.1.0';
set @tool_path = '/swamp/store/SCATools/bundled/spotbugs-3.1.0.tar.gz';
set @checksum = 'fb8df9d4d21e48a808dd4716c7491d0f4f9a07fa2fec46b96ef17adbe521b337c9d9368ce9c42839b64103565f25de99043f8e125b7bdcc1bbf9ab3c6d5fba82';
set @user_add_on_flag = 0;

# set findbugs to not run when user runs all tools
update tool_shed.tool set exclude_when_user_selects_all = 1 where tool_uuid = '163d56a7-156e-11e3-a239-001a4a81450b';
