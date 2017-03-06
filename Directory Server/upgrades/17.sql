# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2017 Software Assurance Marketplace

# v1.26
use project;
drop PROCEDURE if exists upgrade_17;
DELIMITER $$
CREATE PROCEDURE upgrade_17 ()
  BEGIN
    declare script_version_no int;
    declare cur_db_version_no int;
    set script_version_no = 17;

    select max(database_version_no)
      into cur_db_version_no
      from project.database_version;

    if cur_db_version_no < script_version_no then
      begin

        # Ensure all membership records have UUID
        update project.project_user set membership_uid = uuid() where membership_uid is null;

        # update database version number
        insert into project.database_version (database_version_no, description) values (script_version_no, 'upgrade to v1.26');
        commit;
      end;
    end if;
END
$$
DELIMITER ;
