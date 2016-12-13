# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2016 Software Assurance Marketplace

use metric;

####################
## Stored Procedures

# Create & Execute M-Run's for a given package_version
drop PROCEDURE if exists create_metric_run;
DELIMITER $$
#########################################
CREATE PROCEDURE create_metric_run (
    IN package_uuid_in VARCHAR(45),
    IN package_version_uuid_in VARCHAR(45),
    IN package_type_id_in INT,
    OUT return_string varchar(100)
  )
  BEGIN
    DECLARE metric_run_uuid_var VARCHAR(45);
    DECLARE metric_tool_uuid_var VARCHAR(45);
    DECLARE metric_tool_version_uuid_var VARCHAR(45);
    DECLARE platform_uuid_var VARCHAR(45);
    DECLARE platform_version_uuid_var VARCHAR(45);
    DECLARE platform_row_count_int INT;
    DECLARE package_owner_uuid_var VARCHAR(45);
    DECLARE cmd VARCHAR(100);
    DECLARE cmd_return_code INT;
    DECLARE end_of_loop BOOL;
    # Cursor of Metric Tools and their latest version, compatible with incoming package type
    DECLARE cur1 CURSOR FOR
    select mt.metric_tool_uuid, mtv.metric_tool_version_uuid
      from metric.metric_tool mt
     inner join metric.metric_tool_version mtv on mt.metric_tool_uuid = mtv.metric_tool_uuid
     inner join metric.metric_tool_language mtl on mtl.metric_tool_uuid = mtv.metric_tool_uuid
     where mtl.package_type_id = package_type_id_in
       and mtv.version_no = (select max(version_no)
                               from metric.metric_tool_version
                              where metric_tool_uuid = mt.metric_tool_uuid);
    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET end_of_loop = TRUE;

    # Initialize return_string
    set return_string = '';

    # Get Metric Platform
    select default_platform_uuid
      into platform_uuid_var
      from package_store.package_type
     where package_type_id = package_type_id_in;

    # Verify platform exists & Get latest version
    select count(1)
      into platform_row_count_int
      from platform_store.platform_version
     where platform_uuid = platform_uuid_var
       and version_no = (select max(version_no)
                           from platform_store.platform_version
                          where platform_uuid = platform_uuid_var);
    if platform_row_count_int > 0
      then
        select max(platform_version_uuid)
          into platform_version_uuid_var
          from platform_store.platform_version
         where platform_uuid = platform_uuid_var
           and version_no = (select max(version_no)
                               from platform_store.platform_version
                              where platform_uuid = platform_uuid_var);
      else set return_string = 'ERROR: PLATFORM NOT FOUND';
    end if;

    # Get package_owner_uuid
    select package_owner_uuid
      into package_owner_uuid_var
      from package_store.package
     where package_uuid = package_uuid_in;


    # Loop thru all compatible metric tools
    # if anything in cursor, go thru each record
    OPEN cur1;
    read_loop: LOOP
      FETCH cur1 INTO metric_tool_uuid_var, metric_tool_version_uuid_var;
      IF end_of_loop IS TRUE THEN
        LEAVE read_loop;
      END IF;
      # Create metric_run_uuid
      select concat('M-',uuid())
        into metric_run_uuid_var;

      # Create M-Run record
      insert into metric.metric_run (
          metric_run_uuid,
          package_uuid,
          package_version_uuid,
          tool_uuid,
          tool_version_uuid,
          platform_uuid,
          platform_version_uuid,
          package_owner_uuid)
        values (
          metric_run_uuid_var,          # metric_run_uuid,
          package_uuid_in,              # package_uuid,
          package_version_uuid_in,      # package_version_uuid,
          metric_tool_uuid_var,         # tool_uuid,
          metric_tool_version_uuid_var, # tool_version_uuid,
          platform_uuid_var,            # platform_uuid,
          platform_version_uuid_var,    # platform_version_uuid
          package_owner_uuid_var        # package_owner_uuid
          );

      # Execute M-Run
      set cmd = CONCAT('/usr/local/bin/execute_execution_record ', metric_run_uuid_var);
      # Verbose Logging
      insert into assessment.sys_exec_cmd_log (cmd, caller) values (cmd, 'create_metric_run');
      # call external process
      set cmd_return_code = sys_exec(cmd);
      if cmd_return_code = 0
        then set return_string = concat(return_string,'SUCCESS');
        else set return_string = concat(return_string,'ERROR');
      end if;

    END LOOP;
    CLOSE cur1;

    # workaround for server bug
    DO (SELECT 'nothing' FROM metric.metric_run WHERE FALSE);

END
$$
DELIMITER ;

drop PROCEDURE if exists insert_results;
DELIMITER $$
###############################
CREATE PROCEDURE insert_results (
    IN metric_run_uuid_in VARCHAR(45),
    IN result_path_in VARCHAR(200),
    IN result_checksum_in VARCHAR(200),
    IN source_archive_path_in VARCHAR(200),
    IN source_archive_checksum_in VARCHAR(200),
    IN log_path_in VARCHAR(200),
    IN log_checksum_in VARCHAR(200),
    IN weakness_cnt_in INT,
    OUT return_string varchar(100)
  )
  BEGIN
    DECLARE row_count_int int;
    DECLARE result_filename VARCHAR(200);
    DECLARE log_filename VARCHAR(200);
    DECLARE result_incoming_dir VARCHAR(200);
    DECLARE result_dest_path VARCHAR(200);
    DECLARE log_dest_path VARCHAR(200);
    DECLARE cmd VARCHAR(500);
    DECLARE result_mkdir_return_code INT;
    DECLARE result_mv_return_code INT;
    DECLARE result_chmod_return_code INT;
    DECLARE log_move_return_code INT;
    DECLARE log_chmod_return_code INT;

    set return_string = 'ERROR';
    #set assessment_result_uuid = uuid();


    # verify exists 1 matching execution_record
    select count(1)
      into row_count_int
      from metric.metric_run
     where metric_run_uuid = metric_run_uuid_in;

    if row_count_int = 1 then
      BEGIN

        # Get filenames from incoming paths
        set result_filename         = substring_index(result_path_in,'/',-1);
        set log_filename            = substring_index(log_path_in,'/',-1);
        set result_incoming_dir     = concat('/swamp/working/results/',metric_run_uuid_in);

        # mkdir metric result dir
        set result_dest_path = concat('/swamp/store/SCAPackages/Metrics/',metric_run_uuid_in,'/');
        set cmd = null;
        set cmd = CONCAT('mkdir -p ', result_dest_path);
        set result_mkdir_return_code = sys_exec(cmd);

        # cp and chmod result file
        set cmd = null;
        set cmd = CONCAT('cp ', result_path_in, ' ', concat(result_dest_path,result_filename));
        set result_mv_return_code = sys_exec(cmd);
        set cmd = null;
        set cmd = CONCAT('chmod 444 ', concat(result_dest_path,result_filename));
        set result_chmod_return_code = sys_exec(cmd);

        # cp and chmod log file
        #set cmd = null;
        #set cmd = CONCAT('cp ', log_path_in, ' ', concat(result_dest_path,log_filename));
        #set log_move_return_code = sys_exec(cmd);
        #set cmd = null;
        #set cmd = CONCAT('chmod 444 ', concat(result_dest_path,log_filename));
        #set log_chmod_return_code = sys_exec(cmd);

        # Confirm file moves, then insert result record and return success.
        if result_mkdir_return_code     != 0 then set return_string = 'ERROR MKDIR RESULT FILE';
        elseif result_mv_return_code    != 0 then set return_string = 'ERROR MOVING RESULT FILE';
        elseif result_chmod_return_code != 0 then set return_string = 'ERROR CHMOD RESULT FILE';
        #elseif log_move_return_code     != 0 then set return_string = 'ERROR MOVING LOG FILE';
        #elseif log_chmod_return_code    != 0 then set return_string = 'ERROR CHMOD LOG FILE';
        else begin
          update metric.metric_run
             set file_host = 'SWAMP',
                 result_path = concat(result_dest_path,result_filename),
                 result_checksum = result_checksum_in
                 #,log_path = concat(result_dest_path,log_filename),
                 #log_checksum = log_checksum_in
            where metric_run_uuid = metric_run_uuid_in;
            set return_string = 'SUCCESS';
          end;
        end if;
      END;
    else
      set return_string = 'ERROR: Record Not Found';
    end if;

END
$$
DELIMITER ;

drop PROCEDURE if exists initiate_metric_runs;
DELIMITER $$
##########################################
CREATE PROCEDURE initiate_metric_runs ()
  BEGIN
    DECLARE package_uuid_var VARCHAR(45);
    DECLARE package_version_uuid_var VARCHAR(45);
    DECLARE package_type_id_var INT;
    DECLARE return_string VARCHAR(100);
    DECLARE end_of_loop BOOL;
    DECLARE cur1 CURSOR FOR
    select p.package_uuid, pv.package_version_uuid, p.package_type_id
      from package_store.package p
     inner join package_store.package_version pv on p.package_uuid = pv.package_uuid
     where pv.create_date > DATE_SUB(now(), INTERVAL 1 MINUTE);

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET end_of_loop = TRUE;

    OPEN cur1;
    read_loop: LOOP
      FETCH cur1 INTO package_uuid_var, package_version_uuid_var, package_type_id_var;
      IF end_of_loop IS TRUE THEN
        LEAVE read_loop;
      END IF;

      call metric.create_metric_run(package_uuid_var, package_version_uuid_var, package_type_id_var, return_string);

    END LOOP;
    CLOSE cur1;
    # workaround for server bug
    DO (SELECT 'nothing' FROM metric.metric_run WHERE FALSE);

END
$$
DELIMITER ;

###################
## Events
SET GLOBAL event_scheduler = ON;

drop EVENT if exists initiate_metric_runs;
CREATE EVENT initiate_metric_runs
  ON SCHEDULE EVERY 1 MINUTE
  DO CALL metric.initiate_metric_runs();

###################
## Triggers

DROP TRIGGER IF EXISTS metric_tool_BINS;
DROP TRIGGER IF EXISTS metric_tool_BUPD;
DROP TRIGGER IF EXISTS metric_tool_version_BINS;
DROP TRIGGER IF EXISTS metric_tool_version_BUPD;
DROP TRIGGER IF EXISTS metric_tool_language_BINS;
DROP TRIGGER IF EXISTS metric_tool_language_BUPD;
DROP TRIGGER IF EXISTS metric_run_BINS;
DROP TRIGGER IF EXISTS metric_run_BUPD;

DELIMITER $$
CREATE TRIGGER metric_tool_BINS BEFORE INSERT ON metric_tool FOR EACH ROW SET NEW.create_user = user(), NEW.create_date = now();
$$
CREATE TRIGGER metric_tool_BUPD BEFORE UPDATE ON metric_tool FOR EACH ROW SET NEW.update_user = user(), NEW.update_date = now();
$$
#CREATE TRIGGER metric_tool_version_BINS BEFORE INSERT ON metric_tool_version FOR EACH ROW SET NEW.create_user = user(), NEW.create_date = now();
#$$
CREATE TRIGGER metric_tool_version_BUPD BEFORE UPDATE ON metric_tool_version FOR EACH ROW SET NEW.update_user = user(), NEW.update_date = now();
$$
CREATE TRIGGER metric_tool_language_BINS BEFORE INSERT ON metric_tool_language FOR EACH ROW SET NEW.create_user = user(), NEW.create_date = now();
$$
CREATE TRIGGER metric_tool_language_BUPD BEFORE UPDATE ON metric_tool_language FOR EACH ROW SET NEW.update_user = user(), NEW.update_date = now();
$$
CREATE TRIGGER metric_run_BINS BEFORE INSERT ON metric_run FOR EACH ROW SET NEW.create_user = user(), NEW.create_date = now();
$$
CREATE TRIGGER metric_run_BUPD BEFORE UPDATE ON metric_run FOR EACH ROW SET NEW.update_user = user(), NEW.update_date = now();
$$

CREATE TRIGGER metric_tool_version_BINS BEFORE INSERT ON metric_tool_version FOR EACH ROW
  begin
    declare max_version_no INT;
    select max(version_no) into max_version_no
      from metric_tool_version where metric_tool_uuid = NEW.metric_tool_uuid;
    set NEW.create_user = user(),
        NEW.create_date = now(),
        NEW.version_no = ifnull(max_version_no,0)+1;
  end;
$$

DELIMITER ;

###################
## Grants

# 'web'@'%'
GRANT SELECT ON metric.* TO 'web'@'%';

# 'java_agent'@'%'
GRANT EXECUTE ON PROCEDURE metric.insert_results TO 'java_agent'@'%';

# 'java_agent'@'localhost'
GRANT EXECUTE ON PROCEDURE metric.insert_results TO 'java_agent'@'localhost';
