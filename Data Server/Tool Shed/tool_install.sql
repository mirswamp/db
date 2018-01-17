# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2018 Software Assurance Marketplace

use tool_shed;
drop procedure if exists insert_tool;
delimiter //

create procedure insert_tool(
  IN tool_uuid_in VARCHAR(45),
  IN tool_owner_uuid_in VARCHAR(45),
  IN name_in VARCHAR(100),
  IN description_in VARCHAR(500),
  IN tool_sharing_status_in VARCHAR(25),
  IN policy_code_in VARCHAR(100),
  IN tool_version_uuid_in VARCHAR(45),
  IN version_no_in INT,
  IN version_string_in VARCHAR(100),
  IN notes_in VARCHAR(200),
  IN tool_path_in VARCHAR(200),
  IN checksum_in VARCHAR(200),
  IN metric_tool_in VARCHAR(12)
  )

begin

    if metric_tool_in = 'Y' then
      # insert or update metric tool
      insert into metric.metric_tool (metric_tool_uuid, metric_tool_owner_uuid, name, description, tool_sharing_status)
        values (tool_uuid_in,tool_owner_uuid_in,name_in,description_in,tool_sharing_status_in)
         on duplicate key update metric_tool_owner_uuid = tool_owner_uuid_in,
                                 name = name_in,
                                 description = description_in,
                                 tool_sharing_status = tool_sharing_status_in;

      insert into metric.metric_tool_version (metric_tool_version_uuid, metric_tool_uuid, version_no, version_string, tool_path, checksum)
        values (tool_version_uuid_in,tool_uuid_in,version_no_in,version_string_in,tool_path_in,checksum_in)
         on duplicate key update metric_tool_uuid = tool_uuid_in,
                                 version_no = version_no_in,
                                 version_string = version_string_in,
                                 tool_path = tool_path_in,
                                 checksum = checksum_in;
    else
      # insert or update tool
      insert into tool_shed.tool (tool_uuid, tool_owner_uuid, name, description, tool_sharing_status, policy_code)
        values (tool_uuid_in,tool_owner_uuid_in,name_in,description_in,tool_sharing_status_in,policy_code_in)
         on duplicate key update tool_owner_uuid = tool_owner_uuid_in,
                                 name = name_in,
                                 description = description_in,
                                 tool_sharing_status = tool_sharing_status_in,
                                 policy_code = policy_code_in;
      insert into tool_shed.tool_version (tool_version_uuid, tool_uuid, version_no, version_string, comment_public, tool_path, checksum)
        values (tool_version_uuid_in,tool_uuid_in,version_no_in,version_string_in,notes_in,tool_path_in,checksum_in)
         on duplicate key update tool_uuid = tool_uuid_in,
                                 version_no = version_no_in,
                                 version_string = version_string_in,
                                 comment_public = notes_in,
                                 tool_path = tool_path_in,
                                 checksum = checksum_in;
    end if;

end;

//

delimiter ;

-- Execute the procedure
call insert_tool(@tool_uuid,@tool_owner_uuid,@name,@description,@tool_sharing_status,@policy_code,@tool_version_uuid,@version_no,@version_string,@notes,@tool_path,@checksum,@metric_tool);

-- Drop the procedure
drop procedure insert_tool;
