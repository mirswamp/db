# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2016 Software Assurance Marketplace

use assessment;
drop PROCEDURE if exists upgrade_25;
DELIMITER $$
CREATE PROCEDURE upgrade_25 ()
  BEGIN
    declare script_version_no int;
    declare cur_db_version_no int;
    set script_version_no = 25;

    select max(database_version_no)
      into cur_db_version_no
      from assessment.database_version;

    if cur_db_version_no < script_version_no then
      begin

        # add new column to assessment_run_request table
        ALTER TABLE viewer_store.viewer_instance ADD COLUMN status_code INT COMMENT 'status: 0=good nonzero=error' AFTER proxy_url;

        # update database version number
        insert into assessment.database_version (database_version_no, description) values (script_version_no, 'upgrade');

        commit;
      end;
    end if;
END
$$
DELIMITER ;
