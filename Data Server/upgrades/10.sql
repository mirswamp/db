# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2016 Software Assurance Marketplace

use assessment;
drop PROCEDURE if exists upgrade_10;
DELIMITER $$
CREATE PROCEDURE upgrade_10 ()
  BEGIN
    declare script_version_no int;
    declare cur_db_version_no int;
    set script_version_no = 10;

    select max(database_version_no)
      into cur_db_version_no
      from assessment.database_version;

    if cur_db_version_no < script_version_no then
      begin

        # make run_request_schedule.time_of_day not null
        alter table assessment.run_request_schedule change
          time_of_day
          time_of_day TIME NOT NULL DEFAULT '00:00:00' COMMENT 'time of day to run, HH:MM';

        # update database version number
        insert into assessment.database_version (database_version_no, description) values (script_version_no, 'upgrade');

        commit;
      end;
    end if;
END
$$
DELIMITER ;
