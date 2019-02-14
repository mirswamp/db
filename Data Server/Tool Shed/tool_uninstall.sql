# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2019 Software Assurance Marketplace

use tool_shed;
drop procedure if exists remove_tool;
delimiter //

create procedure remove_tool(
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

    # delete tool_version
    delete from tool_shed.tool_version where tool_version_uuid = tool_version_uuid_in;

    # delete tool if no versions remain
    delete from tool_shed.tool
     where tool_uuid = tool_uuid_in
       and not exists (select * from tool_shed.tool_version where tool_uuid = tool_uuid_in);

    # if gt-csonar, then delete tool_language records
    if tool_uuid_in = '5540d2be-72b2-11e5-865f-001a4a81450b' then
      delete from tool_shed.tool_language where tool_version_uuid = tool_version_uuid_in;
    end if;

end;

//

delimiter ;

-- Execute the procedure
call remove_tool(@tool_uuid,@tool_owner_uuid,@name,@description,@tool_sharing_status,@policy_code,@tool_version_uuid,@version_no,@version_string,@notes,@tool_path,@checksum,@metric_tool);

-- Drop the procedure
drop procedure remove_tool;
