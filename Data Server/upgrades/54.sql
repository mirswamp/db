# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2018 Software Assurance Marketplace

# v1.30
use assessment;
drop PROCEDURE if exists upgrade_54;
DELIMITER $$
CREATE PROCEDURE upgrade_54 ()
  BEGIN
    declare script_version_no int;
    declare cur_db_version_no int;
    declare system_type varchar(200);
    set script_version_no = 54;

    select max(database_version_no)
      into cur_db_version_no
      from assessment.database_version;

    if cur_db_version_no < script_version_no then
      begin

        # drop specialized_tool_version table
        drop table if exists tool_shed.specialized_tool_version;

        # drop foreign key constraints for tool (in)compatibility tables
        if exists (select * from information_schema.table_constraints
                      where table_schema = 'tool_shed'
                        and table_name = 'tool_platform'
                        and constraint_type = 'foreign key'
                        and constraint_name = 'fk_tool_platform_t')
        then
            alter table tool_shed.tool_platform drop foreign key fk_tool_platform_t;
        end if;
        if exists (select * from information_schema.table_constraints
                      where table_schema = 'tool_shed'
                        and table_name = 'tool_viewer_incompatibility'
                        and constraint_type = 'foreign key'
                        and constraint_name = 'fk_tool_viewer_t')
        then
            alter table tool_shed.tool_viewer_incompatibility drop foreign key fk_tool_viewer_t;
        end if;

        # update database version number
        delete from assessment.database_version where database_version_no = script_version_no;
        insert into assessment.database_version (database_version_no, description) values (script_version_no, 'upgrade to v1.30');

        commit;
      end;
    end if;
END
$$
DELIMITER ;
