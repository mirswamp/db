# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2018 Software Assurance Marketplace

delete from tool_shed.tool_language where tool_version_uuid = @tool_version_uuid;
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values (@tool_uuid, @tool_version_uuid, 2);
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values (@tool_uuid, @tool_version_uuid, 3);
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values (@tool_uuid, @tool_version_uuid, 6);
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values (@tool_uuid, @tool_version_uuid, 11);
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values (@tool_uuid, @tool_version_uuid, 12);
insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values (@tool_uuid, @tool_version_uuid, 13);
