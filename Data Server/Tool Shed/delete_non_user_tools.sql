# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2018 Software Assurance Marketplace

# During an upgrade of Swamp in a Box, this script can be used to delete all non-user-installed tools so they can be reinstalled, while leaving user-installed tools untouched.
delete from tool_shed.tool_version where user_add_on_flag = 0;

# delete tool if no versions remain
delete from tool_shed.tool
 where not exists (select * from tool_shed.tool_version tv where tv.tool_uuid = tool.tool_uuid);
