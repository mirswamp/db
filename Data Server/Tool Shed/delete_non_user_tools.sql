# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2020 Software Assurance Marketplace

# Delete all tool versions for all bundled tools. Treat deprecated add-on
# tools the same as bundled tools, because the use no longer has control over
# their installation.

delete from tool_shed.tool_version
where
  user_add_on_flag = 0
  or tool_uuid = 'd032d8ec-9184-11e6-88bc-001a4a81450b';  # OWASP Dependency Check

# Delete all tool records for which no versions remain.

delete from tool_shed.tool
where not exists
  (select * from tool_shed.tool_version tv where tv.tool_uuid = tool.tool_uuid);

# Delete all metric tools.

delete from metric.metric_tool_version;
delete from metric.metric_tool;
