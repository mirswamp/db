# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2020 Software Assurance Marketplace

use assessment;

####################
## Views

CREATE OR REPLACE VIEW result_grid as
select pu.user_uid,
       er.execution_record_uuid, er.assessment_run_uuid, er.status, er.complete_flag, er.create_date,
       ar.assessment_result_uuid,
       ar.weakness_cnt,
       er.project_uuid, proj.full_name as project_name,
       pkg.package_uuid, ifnull(pkg.name,ar.package_name) as pkg_name,
       pkg_ver.package_version_uuid, ifnull(pkg_ver.version_string,ar.package_version) as pkg_version_name,
       tool.tool_uuid, ifnull(tool.name,ar.tool_name) as tool_name,
       tool_ver.tool_version_uuid, ifnull(tool_ver.version_string,ar.tool_version) as tool_version_name,
       plat.platform_uuid, ifnull(plat.name,ar.platform_name) as platform_name,
       plat_ver.platform_version_uuid, ifnull(plat_ver.version_string,ar.platform_version) as platform_version_name,
       tool.policy_code,
       case when tool.policy_code is null then 'tool_has_no_policy'
            when up.user_policy_uid is not null then 'tool_policy_signed'
            else 'tool_policy_unsigned' end as tool_policy_check,
       er.vm_hostname, er.vm_username, er.vm_password, er.vm_ip_address
  from project.project_user pu
 inner join project.project proj on pu.project_uid = proj.project_uid
 inner join assessment.execution_record er on er.project_uuid = proj.project_uid and er.delete_date is null
  left outer join assessment.assessment_result ar on er.execution_record_uuid = ar.execution_record_uuid
  left outer join package_store.package_version pkg_ver on pkg_ver.package_version_uuid = er.package_version_uuid
  left outer join package_store.package pkg on pkg.package_uuid = pkg_ver.package_uuid
  left outer join tool_shed.tool_version tool_ver on tool_ver.tool_version_uuid = er.tool_version_uuid
  left outer join tool_shed.tool on tool.tool_uuid = tool_ver.tool_uuid
  left outer join platform_store.platform_version plat_ver on plat_ver.platform_version_uuid = er.platform_version_uuid
  left outer join platform_store.platform plat on plat.platform_uuid = plat_ver.platform_uuid
  left outer join project.user_policy up on pu.user_uid = up.user_uid and tool.policy_code = up.policy_code;

CREATE OR REPLACE VIEW assessment_run_events as
  select lower(er.status) as event_type,
         ifnull(er.update_date,er.create_date) event_date,
         er.execution_record_uuid, er.project_uuid, a.assessment_result_uuid,
         pl.name as platform_name, plv.version_string as platform_version,
         t.name  as tool_name,     tv.version_string  as tool_version,
         pa.name as package_name,  pav.version_string as package_version
    from assessment.execution_record er
   inner join platform_store.platform_version plv on plv.platform_version_uuid = er.platform_version_uuid
   inner join platform_store.platform pl on pl.platform_uuid = plv.platform_uuid
   inner join tool_shed.tool_version tv on tv.tool_version_uuid = er.tool_version_uuid
   inner join tool_shed.tool t on t.tool_uuid = tv.tool_uuid
   inner join package_store.package_version pav on pav.package_version_uuid = er.package_version_uuid
   inner join package_store.package pa on pa.package_uuid = pav.package_uuid
   left outer join assessment_result a on er.execution_record_uuid = a.execution_record_uuid
union
  select 'created' as event_type,
         er.create_date event_date,
         er.execution_record_uuid, er.project_uuid, a.assessment_result_uuid,
         pl.name as platform_name, plv.version_string as platform_version,
         t.name  as tool_name,     tv.version_string  as tool_version,
         pa.name as package_name,  pav.version_string as package_version
    from assessment.execution_record er
   inner join platform_store.platform_version plv on plv.platform_version_uuid = er.platform_version_uuid
   inner join platform_store.platform pl on pl.platform_uuid = plv.platform_uuid
   inner join tool_shed.tool_version tv on tv.tool_version_uuid = er.tool_version_uuid
   inner join tool_shed.tool t on t.tool_uuid = tv.tool_uuid
   inner join package_store.package_version pav on pav.package_version_uuid = er.package_version_uuid
   inner join package_store.package pa on pa.package_uuid = pav.package_uuid
   left outer join assessment_result a on er.execution_record_uuid = a.execution_record_uuid;

CREATE OR REPLACE VIEW exec_run_view as
select
er.execution_record_uuid,
er.launch_counter,
er.project_uuid,
er.user_uuid,
pkg.name as package_name,
pkg_ver.version_string as package_version,
pkg.package_language,
pkg_type.name as package_type,
pkg_ver.package_path,
pkg_ver.checksum as pkg_checksum,
pkg_ver.source_path,
pkg_ver.build_file,
pkg_ver.build_system,
pkg_ver.build_cmd,
pkg_ver.build_target,
pkg_ver.build_dir,
pkg_ver.build_opt,
pkg_ver.config_cmd,
pkg_ver.config_opt,
pkg_ver.config_dir,
pkg_ver.bytecode_class_path,
pkg_ver.bytecode_aux_class_path,
pkg_ver.bytecode_source_path,
pkg_ver.android_sdk_target,
pkg_ver.android_lint_target,
pkg_ver.android_redo_build,
pkg_ver.use_gradle_wrapper,
pkg_ver.language_version,
pkg_ver.maven_version,
pkg_ver.android_maven_plugin,
pkg_ver.exclude_paths,
pkg_ver.package_build_settings,
pkg_ver.package_info,
tool.name as tool_name,
tool_ver.version_string,
tool_ver.tool_path,
tool_ver.checksum as tool_checksum,
plt_ver.platform_identifier,
pvd.dependency_list,
case when tool_ver.tool_version_uuid = 'a6d2a89e-4a1c-11e7-a337-001a4a81450b'
     then (select up.meta_information from project.user_permission up where up.user_uid = er.user_uuid and up.permission_code = 'sonatype-user')
     else null end as user_cnf,
er.notify_when_complete_flag
from assessment.execution_record er
inner join package_store.package_version pkg_ver on pkg_ver.package_version_uuid = er.package_version_uuid
inner join package_store.package pkg on pkg.package_uuid = pkg_ver.package_uuid
inner join package_store.package_type pkg_type on pkg.package_type_id = pkg_type.package_type_id
inner join tool_shed.tool_version tool_ver on tool_ver.tool_version_uuid = er.tool_version_uuid
inner join tool_shed.tool on tool.tool_uuid = tool_ver.tool_uuid
inner join platform_store.platform_version plt_ver on plt_ver.platform_version_uuid = er.platform_version_uuid
left outer join package_store.package_version_dependency pvd on er.package_version_uuid = pvd.package_version_uuid and er.platform_version_uuid = pvd.platform_version_uuid
where er.complete_flag = 0
union
select
mr.metric_run_uuid as execution_record_uuid,
mr.launch_counter,
'METRIC' as project_uuid,
'METRIC' as user_uuid,
pkg.name as package_name,
pkg_ver.version_string as package_version,
pkg.package_language,
pkg_type.name as package_type,
pkg_ver.package_path,
pkg_ver.checksum as pkg_checksum,
pkg_ver.source_path,
pkg_ver.build_file,
pkg_ver.build_system,
pkg_ver.build_cmd,
pkg_ver.build_target,
pkg_ver.build_dir,
pkg_ver.build_opt,
pkg_ver.config_cmd,
pkg_ver.config_opt,
pkg_ver.config_dir,
pkg_ver.bytecode_class_path,
pkg_ver.bytecode_aux_class_path,
pkg_ver.bytecode_source_path,
pkg_ver.android_sdk_target,
pkg_ver.android_lint_target,
pkg_ver.android_redo_build,
pkg_ver.use_gradle_wrapper,
pkg_ver.language_version,
pkg_ver.maven_version,
pkg_ver.android_maven_plugin,
pkg_ver.exclude_paths,
pkg_ver.package_build_settings,
pkg_ver.package_info,
mt.name as tool_name,
mtv.version_string,
mtv.tool_path,
mtv.checksum as tool_checksum,
plt_ver.platform_identifier,
pvd.dependency_list,
null as user_cnf,
0 as notify_when_complete_flag
from metric.metric_run mr
inner join package_store.package_version pkg_ver on pkg_ver.package_version_uuid = mr.package_version_uuid
inner join package_store.package pkg on pkg.package_uuid = pkg_ver.package_uuid
inner join package_store.package_type pkg_type on pkg.package_type_id = pkg_type.package_type_id
inner join metric.metric_tool_version mtv on mtv.metric_tool_version_uuid = mr.tool_version_uuid
inner join metric.metric_tool mt on mt.metric_tool_uuid = mtv.metric_tool_uuid
inner join platform_store.platform_version plt_ver on plt_ver.platform_version_uuid = mr.platform_version_uuid
left outer join package_store.package_version_dependency pvd on mr.package_version_uuid = pvd.package_version_uuid and mr.platform_version_uuid = pvd.platform_version_uuid
where mr.complete_flag = 0
;

####################
## Stored Procedures
drop PROCEDURE if exists select_execution_record;
DELIMITER $$
########################################
CREATE PROCEDURE select_execution_record (
    IN execution_record_uuid_in VARCHAR(45)
  )
  BEGIN
    if execution_record_uuid_in like 'M-%'
      then
        select metric_run_uuid as execution_record_uuid,
               platform_version_uuid,
               tool_version_uuid,
               package_version_uuid,
               'METRIC' as project_uuid,
               status,
               run_date,
               completion_date,
               execute_node_architecture_id,
               total_lines,
               cpu_utilization,
               'METRIC' as user_uuid
          from metric.metric_run
         where metric_run_uuid = execution_record_uuid_in;
       else
        select execution_record_uuid,
               platform_version_uuid,
               tool_version_uuid,
               package_version_uuid,
               project_uuid,
               status,
               run_date,
               completion_date,
               execute_node_architecture_id,
               total_lines,
               cpu_utilization,
               user_uuid
          from execution_record
         where execution_record_uuid = execution_record_uuid_in;
    end if;
  END
  $$
  DELIMITER ;

# create execution record
  # Lookup latest & greatest versions
  # insert execution_record
drop PROCEDURE if exists create_execution_record;
DELIMITER $$
########################################
CREATE PROCEDURE create_execution_record (
    IN assessment_run_uuid_in VARCHAR(45),
    IN run_request_uuid_in VARCHAR(45),
    IN notify_when_complete_flag_in tinyint(1),
    IN user_uuid_in VARCHAR(45),
    OUT return_string varchar(100)
  )
  BEGIN
    DECLARE assessment_row_count_int int;
    DECLARE platform_row_count_int int;
    DECLARE platform_version_row_count_int int;
    DECLARE tool_row_count_int int;
    DECLARE package_row_count_int int;
    DECLARE platform_uuid_var VARCHAR(45);
    DECLARE tool_uuid_var VARCHAR(45);
    DECLARE package_uuid_var VARCHAR(45);
    DECLARE platform_version_uuid_var VARCHAR(45);
    DECLARE tool_version_uuid_var VARCHAR(45);
    DECLARE package_version_uuid_var VARCHAR(45);
    DECLARE platform_version_id_var INT;
    DECLARE tool_version_id_var INT;
    DECLARE package_version_id_var INT;
    DECLARE assessment_run_id_var INT;
    DECLARE project_uuid_var VARCHAR(45);
    DECLARE run_request_id_var INT;
    DECLARE notify_when_complete_flag_var tinyint(1);
    set return_string = 'ERROR';

    # verify assessment exists
    select count(1)
      into assessment_row_count_int
      from assessment.assessment_run
     where assessment_run_uuid = assessment_run_uuid_in;

    if assessment_row_count_int > 1 then
      set return_string = 'ERROR: MULTIPLE ASSESSMENTS FOUND';
    elseif assessment_row_count_int = 0 then
      set return_string = 'ERROR: ASSESSMENT NOT FOUND';
    elseif assessment_row_count_int = 1 then
      BEGIN

        # get platform, tool and package etc from assessment record
        select platform_uuid, tool_uuid, package_uuid,
               platform_version_uuid, tool_version_uuid, package_version_uuid,
               project_uuid, assessment_run_id
          into platform_uuid_var, tool_uuid_var, package_uuid_var,
               platform_version_uuid_var, tool_version_uuid_var, package_version_uuid_var,
               project_uuid_var, assessment_run_id_var
          from assessment.assessment_run
         where assessment_run_uuid = assessment_run_uuid_in;

        # if platform null, get default
        if platform_uuid_var is null then begin
          select count(1)
            into platform_row_count_int
            from package_store.package_type pkg_t
           inner join package_store.package pkg on pkg.package_type_id = pkg_t.package_type_id
           inner join assessment.assessment_run ar on ar.package_uuid = pkg.package_uuid
           where ar.assessment_run_uuid = assessment_run_uuid_in;
           if platform_row_count_int > 0 then
              select pkg_t.default_platform_uuid, pkg_t.default_platform_version_uuid
                into platform_uuid_var, platform_version_uuid_var
                from package_store.package_type pkg_t
               inner join package_store.package pkg on pkg.package_type_id = pkg_t.package_type_id
               inner join assessment.assessment_run ar on ar.package_uuid = pkg.package_uuid
               where ar.assessment_run_uuid = assessment_run_uuid_in;
           end if;
         end;
        end if;

        # if platform version null, get latest version
        if platform_version_uuid_var is null then begin
          select count(1)
            into platform_version_row_count_int
            from platform_store.platform_version
           where platform_uuid = platform_uuid_var
             and version_no = (select max(version_no)
                                 from platform_store.platform_version
                                where platform_uuid = platform_uuid_var);
           if platform_version_row_count_int > 0 then
              select max(platform_version_uuid)
                into platform_version_uuid_var
                from platform_store.platform_version
               where platform_uuid = platform_uuid_var
                 and version_no = (select max(version_no)
                                     from platform_store.platform_version
                                    where platform_uuid = platform_uuid_var);
           end if;
         end;
        end if;

        # if tool version null, get latest version compatible with package_type
        if tool_version_uuid_var is null then begin
           select count(1)
            into tool_row_count_int
            from tool_shed.tool_version
           where tool_uuid = tool_uuid_var
             and version_no = (select max(version_no)
                                 from tool_shed.tool_version
                                where tool_uuid = tool_uuid_var);
           if tool_row_count_int > 0 then
             # If compatible user add on version exists, then get latest user add on
             if exists (select *
                         from tool_shed.tool_version tv
                        inner join tool_shed.tool_language tl on tv.tool_version_uuid = tl.tool_version_uuid
                        where tv.tool_uuid = tool_uuid_var
                          and tv.user_add_on_flag = 1
                          and tl.package_type_id = (select package_type_id from package_store.package where package_uuid = package_uuid_var))
               then
                 select max(tool_version_uuid)
                    into tool_version_uuid_var
                    from tool_shed.tool_version
                   where tool_uuid = tool_uuid_var
                     and user_add_on_flag = 1
                     and version_no = (select max(tv.version_no)
                                                 from tool_shed.tool_version tv
                                                inner join tool_shed.tool_language tl on tv.tool_version_uuid = tl.tool_version_uuid
                                                where tv.tool_uuid = tool_uuid_var
                                                  and tv.user_add_on_flag = 1
                                                  and tl.package_type_id = (select package_type_id from package_store.package where package_uuid = package_uuid_var)
                                       );
             # Otherwise, get latest version
             else
             select max(tool_version_uuid)
                into tool_version_uuid_var
                from tool_shed.tool_version
               where tool_uuid = tool_uuid_var
                 and version_no = (select max(tv.version_no)
                                     from tool_shed.tool_version tv
                                    inner join tool_shed.tool_language tl on tv.tool_version_uuid = tl.tool_version_uuid
                                    where tv.tool_uuid = tool_uuid_var
                                      and tl.package_type_id = (select package_type_id from package_store.package where package_uuid = package_uuid_var)
                                   );
             end if;
           end if;
         end;
        end if;

        # if package version null, get latest version visible to that project
        if package_version_uuid_var is null then begin
          select count(1)
            into package_row_count_int
            from package_store.package_version
           where package_uuid = package_uuid_var
             and version_no = (select max(version_no)
                                 from package_store.package_version pv
                                where pv.package_uuid = package_uuid_var
                                  and (upper(pv.version_sharing_status) = 'PUBLIC'
                                       or (upper(pv.version_sharing_status) = 'PROTECTED'
                                           and exists (select 1 from package_store.package_version_sharing pvs
                                                       where pvs.package_version_uuid = pv.package_version_uuid
                                                         and pvs.project_uuid = project_uuid_var)
                                           )

                                      )
                               )
             ;
           if package_row_count_int > 0 then
              select package_version_uuid
                into package_version_uuid_var
                from package_store.package_version
               where package_uuid = package_uuid_var
                 and version_no = (select max(version_no)
                                     from package_store.package_version pv
                                    where pv.package_uuid = package_uuid_var
                                      and (upper(pv.version_sharing_status) = 'PUBLIC'
                                           or (upper(pv.version_sharing_status) = 'PROTECTED'
                                               and exists (select 1 from package_store.package_version_sharing pvs
                                                           where pvs.package_version_uuid = pv.package_version_uuid
                                                             and pvs.project_uuid = project_uuid_var)
                                               )

                                          )
                                   )
                 ;
           end if;
         end;
        end if;

        if platform_uuid_var is null then
          set return_string = 'ERROR: DEFAULT PLATFORM FOR PKG TYPE NOT FOUND';
        elseif platform_version_uuid_var is null then
          set return_string = 'ERROR: LATEST PLATFORM VERSION NOT FOUND';
        elseif tool_version_uuid_var is null then
          set return_string = 'ERROR: LATEST TOOL VERSION NOT FOUND';
        elseif package_version_uuid_var is null then
          set return_string = 'ERROR: LATEST PACKAGE VERSION NOT FOUND';
        else begin
          # status will default to 'WAITING TO START'
          insert into execution_record (
              execution_record_uuid,
              assessment_run_uuid,
              run_request_uuid,
              user_uuid,
              notify_when_complete_flag,
              project_uuid,
              platform_version_uuid,
              tool_version_uuid,
              package_version_uuid
              )
            values (
              uuid(),                    # execution_record_uuid,
              assessment_run_uuid_in,    # assessment_run_uuid,
              run_request_uuid_in,       # run_request_uuid,
              user_uuid_in,              # user_uuid,
              notify_when_complete_flag_in, # notify_when_complete_flag,
              project_uuid_var,          # project_uuid,
              platform_version_uuid_var, # platform_version_uuid,
              tool_version_uuid_var,     # tool_version_uuid,
              package_version_uuid_var   # package_version_uuid
              );
          set return_string = 'SUCCESS';
          end;
        end if;
      END;
    end if;

END
$$
DELIMITER ;

# Validate execution_record
  # verify project has access to tool/package/platform
  # return Y/N
drop PROCEDURE if exists validate_execution_record;
DELIMITER $$
##########################################
CREATE PROCEDURE validate_execution_record (
    IN execution_record_uuid_in VARCHAR(45),
    OUT return_code VARCHAR(100)
  )
  sp_label:BEGIN
    DECLARE project_uuid_var          VARCHAR(45);
    DECLARE platform_version_uuid_var VARCHAR(45);
    DECLARE tool_version_uuid_var     VARCHAR(45);
    DECLARE package_version_uuid_var  VARCHAR(45);
    DECLARE user_uuid_var             VARCHAR(45);
    DECLARE user_ok CHAR(1);
    DECLARE project_ok CHAR(1);
    DECLARE platform_ok CHAR(1);
    DECLARE tool_ok     CHAR(1);
    DECLARE package_ok  CHAR(1);
    DECLARE parasoft_ok  CHAR(1);
    DECLARE grammatech_ok  CHAR(1);
    DECLARE coverity_ok  CHAR(1);

    DECLARE tool_uuid_var           VARCHAR(45);
    DECLARE tool_sharing_status_var VARCHAR(25);
    DECLARE policy_code_var         VARCHAR(100);
    DECLARE permission_code_var     VARCHAR(100);
    DECLARE grant_date_var      DATETIME;
    DECLARE delete_date_var     DATETIME;
    DECLARE expiration_date_var DATETIME;

    # get info from execution_record
    select project_uuid, platform_version_uuid, tool_version_uuid, package_version_uuid, user_uuid
      into project_uuid_var, platform_version_uuid_var, tool_version_uuid_var, package_version_uuid_var, user_uuid_var
      from execution_record
     where execution_record_uuid = execution_record_uuid_in;

    # verify user account is valid
    select 'Y'
      into user_ok
      from project.user_account
     where user_uid = user_uuid_var
       and enabled_flag = 1;

    # verify project is valid.
    select 'Y'
      into project_ok
      from project.project
     where project_uid = project_uuid_var
       and denial_date is null
       and deactivation_date is null;

    # verify platform is public or shared with project
    select 'Y'
      into platform_ok
      from platform_store.platform_version pv
     inner join platform_store.platform p on p.platform_uuid = pv.platform_uuid
     where pv.platform_version_uuid = platform_version_uuid_var
       and (upper(p.platform_sharing_status) = 'PUBLIC'
            or
            (upper(p.platform_sharing_status) = 'PROTECTED'
             and exists (select 1 from platform_store.platform_sharing ps
                          where ps.platform_uuid = p.platform_uuid and ps.project_uuid = project_uuid_var)
            )
           );

    # verify tool
    select t.tool_uuid, t.tool_sharing_status, pol.policy_code, per.permission_code
      into tool_uuid_var, tool_sharing_status_var, policy_code_var, permission_code_var
      from tool_shed.tool_version tv
     inner join tool_shed.tool t on t.tool_uuid = tv.tool_uuid
     left outer join project.policy pol on t.policy_code = pol.policy_code
     left outer join project.permission per on t.policy_code = per.policy_code
     where tv.tool_version_uuid = tool_version_uuid_var;

    # Verify tool sharing status: Public, Protected, Private
      # If PROTECTED then verify tool is shared with project
      # Any other status than 'PUBLIC' is considered 'PRIVATE'
    if upper(tool_sharing_status_var) = 'PROTECTED'
       and not exists (select *
                         from tool_shed.tool_sharing ts
                        where tool_uuid = tool_uuid_var
                          and project_uuid = project_uuid_var)
      then
      set return_code = 'Error: tool not shared with project';
      leave sp_label;
    elseif upper(tool_sharing_status_var) != 'PUBLIC' then
      set return_code = 'Error: tool is private';
      leave sp_label;
    end if;

    # If tool has a policy, verify user agreed to it.
    if policy_code_var is not null
       and not exists (select * from project.user_policy up where up.policy_code = policy_code_var and up.user_uid = user_uuid_var and up.accept_flag = 1)
      then
      set return_code = 'Error: user has not agreed to tool policy';
      leave sp_label;
    end if;

    # If tool has a permission, verify user has permission
    if permission_code_var is not null then
      select grant_date, delete_date, expiration_date
        into grant_date_var, delete_date_var, expiration_date_var
        from project.user_permission
       where permission_code = permission_code_var
         and user_uid = user_uuid_var;
      if grant_date_var is null then set return_code = 'Error: need permission to use this tool'; leave sp_label;
      elseif delete_date_var is not null then set return_code = 'Error: permission to use this tool has been revoked'; leave sp_label;
      elseif (expiration_date_var is not null and expiration_date_var < now()) then set return_code = 'Error: permission to use this tool has expired'; leave sp_label;
      end if;
    end if;

    # verify package
      # package is public or shared with project
    select 'Y'
      into package_ok
      from package_store.package_version pv
     where pv.package_version_uuid = package_version_uuid_var
       and (upper(pv.version_sharing_status) = 'PUBLIC'
            or (upper(pv.version_sharing_status) = 'PROTECTED'
                and exists (select 1
                              from package_store.package_version_sharing pvs
                             where pvs.package_version_uuid = package_version_uuid_var
                               and pvs.project_uuid = project_uuid_var)
               )
           );

    if (user_ok = 'Y' and project_ok = 'Y' and platform_ok = 'Y' and package_ok = 'Y')
      then set return_code = 'Y';
    elseif user_ok       is null then set return_code = 'FAILED TO VALIDATE ASSESSMENT DATA: USER ACCT DISABLED';
    elseif project_ok    is null then set return_code = 'FAILED TO VALIDATE ASSESSMENT DATA: PROJECT DISABLED';
    elseif platform_ok   is null then set return_code = 'FAILED TO VALIDATE ASSESSMENT DATA: PLATFORM NOT AVAILABLE';
    elseif package_ok    is null then set return_code = 'FAILED TO VALIDATE ASSESSMENT DATA: PACKAGE NOT AVAILABLE';
    else                             set return_code = 'FAILED TO VALIDATE ASSESSMENT DATA';
    end if;


END
$$
DELIMITER ;

# execute_execution_record
  # send command to OS
drop PROCEDURE if exists execute_execution_record;
DELIMITER $$
#########################################
CREATE PROCEDURE execute_execution_record (
    IN execution_record_uuid_in VARCHAR(45),
    OUT return_code INT
  )
  BEGIN
    #DECLARE return_code INT;
    DECLARE cmd VARCHAR(100);

    set cmd = CONCAT('/usr/local/bin/execute_execution_record ', execution_record_uuid_in);
    # Verbose Logging
      # insert into sys_exec_cmd_log (cmd, caller) values (cmd, 'execute_execution_record');
    # call external process
    set return_code = sys_exec(cmd);

END
$$
DELIMITER ;

# scheduler
  # called by event
  # Find all scheduled runs to be executed
  # call create_execution_record
drop PROCEDURE if exists scheduler;
DELIMITER $$
##########################
CREATE PROCEDURE scheduler ()
  BEGIN
    DECLARE assessment_run_id_var INT;
    DECLARE run_request_id_var INT;
    DECLARE assessment_run_uuid_var VARCHAR(45);
    DECLARE run_request_uuid_var VARCHAR(45);
    DECLARE user_uuid_var VARCHAR(45);
    DECLARE notify_when_complete_flag_var tinyint(1);
    DECLARE return_var VARCHAR(100);
    DECLARE end_of_loop BOOL;
    DECLARE currently_running_scheduler VARCHAR(1);
    DECLARE currently_running_scheduler_update_date TIMESTAMP;
    DECLARE cur1 CURSOR FOR
    select distinct ar.assessment_run_uuid, rr.run_request_uuid, arra.user_uuid, arra.notify_when_complete_flag
      from run_request_schedule rss
     inner join run_request rr on rr.run_request_uuid = rss.run_request_uuid
     inner join assessment_run_request arra on arra.run_request_id = rr.run_request_id
     inner join assessment_run ar on ar.assessment_run_id = arra.assessment_run_id
     where rss.time_of_day >= DATE_SUB(time(NOW()),INTERVAL 30 SECOND)
       and rss.time_of_day < time(NOW())
       and (upper(rss.recurrence_type) = 'DAILY' or
            (upper(rss.recurrence_type) = 'WEEKLY' and rss.recurrence_day = DAYOFWEEK(now())) or
            (upper(rss.recurrence_type) = 'MONTHLY' and rss.recurrence_day = DAYOFMONTH(now()))
            );

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET end_of_loop = TRUE;

    DECLARE CONTINUE handler for sqlexception
      BEGIN
        insert into scheduler_log
        (msg, assessment_run_uuid, run_request_uuid, notify_when_complete_flag, user_uuid, return_msg)
        values
        ('Encountered Exception', assessment_run_uuid_var, run_request_uuid_var, notify_when_complete_flag_var, user_uuid_var, return_var);
         commit;
    END;

    DECLARE CONTINUE handler for sqlwarning
      BEGIN
        insert into scheduler_log
        (msg, assessment_run_uuid, run_request_uuid, notify_when_complete_flag, user_uuid, return_msg)
        values
        ('Encountered Warning', assessment_run_uuid_var, run_request_uuid_var, notify_when_complete_flag_var, user_uuid_var, return_var);
         commit;
    END;

      select value, update_date
        into currently_running_scheduler, currently_running_scheduler_update_date
        from system_status
       where status_key = 'CURRENTLY_RUNNING_SCHEDULER';

      if currently_running_scheduler = 'Y' and TIMEDIFF(now(),currently_running_scheduler_update_date) < '00:05:00' then
        BEGIN
          insert into scheduler_log (msg) values ('Scheduler skipped because procedure is currently running.'); commit;
        END;
      else
BEGIN
    if currently_running_scheduler = 'Y' and TIMEDIFF(now(),currently_running_scheduler_update_date) > '00:05:00' then
      insert into scheduler_log (msg) values ('Scheduler running longer than 5 minutes.');
     end if;

    # set flag CURRENTLY_RUNNING_SCHEDULER
    update system_status
       set value = 'Y'
      where status_key = 'CURRENTLY_RUNNING_SCHEDULER';
     commit;

    # if anything in cursor, go thru each record
    OPEN cur1;
    read_loop: LOOP
      FETCH cur1 INTO assessment_run_uuid_var, run_request_uuid_var, user_uuid_var, notify_when_complete_flag_var;
      IF end_of_loop IS TRUE THEN
        LEAVE read_loop;
      END IF;
      # Verbose logging for debugging
      # insert into scheduler_log (msg, assessment_run_uuid, run_request_uuid, notify_when_complete_flag, user_uuid, return_msg)
      #   values ('Calling', assessment_run_uuid_var, run_request_uuid_var, notify_when_complete_flag_var, user_uuid_var, null);
      call assessment.create_execution_record(assessment_run_uuid_var, run_request_uuid_var, notify_when_complete_flag_var, user_uuid_var, return_var);
      # Verbose logging for debugging
      # insert into scheduler_log (msg, assessment_run_uuid, run_request_uuid, notify_when_complete_flag, user_uuid, return_msg)
      #   values ('Called', assessment_run_uuid_var, run_request_uuid_var, notify_when_complete_flag_var, user_uuid_var, return_var);
    END LOOP;
    CLOSE cur1;

    # Verbose logging for debugging
    # insert into scheduler_log (msg) values ('End');  commit;

    # workaround for server bug
    DO (SELECT 'nothing' FROM execution_record WHERE FALSE);

    # set flag CURRENTLY_RUNNING_SCHEDULER
    update system_status
       set value = 'N'
      where status_key = 'CURRENTLY_RUNNING_SCHEDULER';
    commit;

END;
end if;

END
$$
DELIMITER ;

drop PROCEDURE if exists process_execution_records;
DELIMITER $$
##########################################
CREATE PROCEDURE process_execution_records ()
  BEGIN
    DECLARE execution_record_uuid_var VARCHAR(45);
    DECLARE launch_flag_var INT;
    DECLARE launch_counter_var INT;
    DECLARE launch_countdown_var INT;
    DECLARE launch_counter_limit INT;
    DECLARE validate_return_code VARCHAR(100);
    DECLARE exec_return_code INT;
    DECLARE end_of_loop BOOL;
    DECLARE launch_counter_rtn INT;
    DECLARE cur1 CURSOR FOR
    select execution_record_uuid
      from execution_record
     where launch_flag = 1;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET end_of_loop = TRUE;

    set launch_counter_limit = 15;

    # set flag currently_processing_execution_records
    update system_status
       set value = 'Y'
      where status_key = 'CURRENTLY_PROCESSING_EXECUTION_RECORDS';

    OPEN cur1;
    read_loop: LOOP
      FETCH cur1 INTO execution_record_uuid_var;
      IF end_of_loop IS TRUE THEN
        LEAVE read_loop;
      END IF;

      # Get run info
      select launch_flag, launch_counter, launch_countdown
        into launch_flag_var, launch_counter_var, launch_countdown_var
        from execution_record
       where execution_record_uuid = execution_record_uuid_var;

      # If launch_flag no longer 1, then iterate
      if launch_flag_var != 1 then
        iterate read_loop;
      end if;

      # If launch_counter limit reached, then kill assessment and iterate
      if launch_counter_var >= launch_counter_limit then
        update execution_record
           set launch_flag = 0,
               complete_flag = 1,
               status = 'Failed to launch'
         where execution_record_uuid = execution_record_uuid_var;
        iterate read_loop;
      end if;

      # If launch_countdown hasn't reached zero, then decrement and iterate
      if launch_countdown_var > 0 then
        update execution_record
           set launch_countdown = launch_countdown - 1
         where execution_record_uuid = execution_record_uuid_var;
        iterate read_loop;
      end if;

      # validate. If invalid, then kill assessment and iterate
      call assessment.validate_execution_record(execution_record_uuid_var, validate_return_code);
      if ifnull(validate_return_code,'N') != 'Y' then
        update execution_record
           set status = validate_return_code,
               launch_flag = 0,
               complete_flag = 1
         where execution_record_uuid = execution_record_uuid_var;
        iterate read_loop;
      end if;

      # Actively re-check parameters before running
      if (launch_flag_var = 1 and
          launch_counter_var < launch_counter_limit and
          launch_countdown_var = 0 and
          validate_return_code = 'Y') then
        # increment launch_counter & reset launch_countdown
        call assessment.increment_launch_counter(execution_record_uuid_var, launch_counter_var, launch_counter_rtn);
        if launch_counter_rtn != -1 then
          call assessment.execute_execution_record(execution_record_uuid_var, exec_return_code);
          if exec_return_code = 0 then
            update execution_record
               set status = 'SUBMITTING TO HTCONDOR'
             where execution_record_uuid = execution_record_uuid_var;
          end if;
        else
          update execution_record
             set status = 'FAILURE TO INCREMENT LAUNCH COUNTER'
           where execution_record_uuid = execution_record_uuid_var;
        end if;
      end if;

    END LOOP;
    CLOSE cur1;
    # workaround for server bug
    DO (SELECT 'nothing' FROM execution_record WHERE FALSE);

    # set flag currently_processing_execution_records
    update system_status
       set value = 'N'
      where status_key = 'CURRENTLY_PROCESSING_EXECUTION_RECORDS';
END
$$
DELIMITER ;

drop PROCEDURE if exists insert_results;
DELIMITER $$
###############################
CREATE PROCEDURE insert_results (
    IN execution_record_uuid_in VARCHAR(45),
    IN assessment_result_uuid_in VARCHAR(45),
    IN result_path_in VARCHAR(200),
    IN result_checksum_in VARCHAR(200),
    IN source_archive_path_in VARCHAR(200),
    IN source_archive_checksum_in VARCHAR(200),
    IN log_path_in VARCHAR(200),
    IN log_checksum_in VARCHAR(200),
    IN weakness_cnt_in INT,
    IN lines_of_code_in INT,
    IN status_out_in VARCHAR(3000),
    IN status_out_error_msg_in VARCHAR(200),
    OUT return_string varchar(100)
  )
  BEGIN
    DECLARE metric_return_string VARCHAR(100);
    DECLARE row_count_int int;
    DECLARE project_uuid_var VARCHAR(45);
    DECLARE platform_version_uuid_var VARCHAR(45);
    DECLARE tool_version_uuid_var VARCHAR(45);
    DECLARE package_version_uuid_var VARCHAR(45);
    DECLARE notify_when_complete_flag_var tinyint(1);
    DECLARE user_uuid_var VARCHAR(45);
    DECLARE platform_name_var VARCHAR(100);
    DECLARE platform_version_var VARCHAR(100);
    DECLARE tool_name_var VARCHAR(100);
    DECLARE tool_version_var VARCHAR(100);
    DECLARE policy_code_var VARCHAR(100);
    DECLARE package_name_var VARCHAR(100);
    DECLARE package_version_var VARCHAR(100);
    DECLARE run_date_var TIMESTAMP;
    DECLARE execute_node_architecture_id_var VARCHAR(128);
    DECLARE vm_hostname_var VARCHAR(100);
    DECLARE vm_ip_address_var VARCHAR(50);

    if execution_record_uuid_in like 'M-%'
      then
        call metric.insert_results (execution_record_uuid_in,
                                    result_path_in,
                                    result_checksum_in,
                                    source_archive_path_in,
                                    source_archive_checksum_in,
                                    log_path_in,
                                    log_checksum_in,
                                    weakness_cnt_in,
                                    status_out_in,
                                    status_out_error_msg_in,
                                    metric_return_string);
        set return_string = metric_return_string;
    else

    set return_string = 'ERROR';

    # verify exists 1 matching execution_record
    select count(1)
      into row_count_int
      from assessment.execution_record
     where execution_record_uuid = execution_record_uuid_in;

    if row_count_int = 1 then
      BEGIN
        # lookup execution record details
        select project_uuid, platform_version_uuid, tool_version_uuid, package_version_uuid, notify_when_complete_flag, user_uuid,
               run_date, execute_node_architecture_id, vm_hostname, vm_ip_address
          into project_uuid_var, platform_version_uuid_var, tool_version_uuid_var, package_version_uuid_var, notify_when_complete_flag_var, user_uuid_var,
               run_date_var, execute_node_architecture_id_var, vm_hostname_var, vm_ip_address_var
          from assessment.execution_record
         where execution_record_uuid = execution_record_uuid_in;

        # lookup platform details
        select p.name, v.version_string
          into platform_name_var, platform_version_var
          from platform_store.platform_version v
         inner join platform_store.platform p on p.platform_uuid = v.platform_uuid
         where platform_version_uuid = platform_version_uuid_var;

        # lookup tool details
        select p.name, v.version_string, p.policy_code
          into tool_name_var, tool_version_var, policy_code_var
          from tool_shed.tool_version v
         inner join tool_shed.tool p on p.tool_uuid = v.tool_uuid
         where tool_version_uuid = tool_version_uuid_var;

        # lookup package details
        select p.name, v.version_string
          into package_name_var, package_version_var
          from package_store.package_version v
         inner join package_store.package p on p.package_uuid = v.package_uuid
         where package_version_uuid = package_version_uuid_var;

        insert into assessment_result (
          assessment_result_uuid, execution_record_uuid, project_uuid, weakness_cnt,
          file_host, file_path, checksum, source_archive_path, source_archive_checksum, log_path, log_checksum, status_out, status_out_error_msg,
          platform_name, platform_version, tool_name, tool_version, package_name, package_version,
          platform_version_uuid, tool_version_uuid, package_version_uuid, policy_code,
          run_date, execute_node_architecture_id, vm_hostname, vm_ip_address)
        values (
          assessment_result_uuid_in,   # assessment_result_uuid,
          execution_record_uuid_in,    # execution_record_uuid,
          project_uuid_var,            # project_uuid,
          case weakness_cnt_in when -1 then null else weakness_cnt_in end, # weakness_cnt,
          'SWAMP',                     # file_host,
          result_path_in,              # file_path,
          result_checksum_in,          # checksum,
          source_archive_path_in,      # source_archive_path,
          source_archive_checksum_in,  # source_archive_checksum,
          log_path_in,                 # log_path
          log_checksum_in,             # log_checksum
          status_out_in,               # status_out
          status_out_error_msg_in,     # status_out_error_msg
          platform_name_var,           # platform_name,
          platform_version_var,        # platform_version,
          tool_name_var,               # tool_name,
          tool_version_var,            # tool_version,
          package_name_var,            # package_name,
          package_version_var,         # package_version,
          platform_version_uuid_var,   # platform_version_uuid,
          tool_version_uuid_var,       # tool_version_uuid,
          package_version_uuid_var,    # package_version_uuid
          policy_code_var,             # policy_code
          run_date_var, execute_node_architecture_id_var, vm_hostname_var, vm_ip_address_var
          );

        if lines_of_code_in is not null then
          update assessment.execution_record
             set code_lines = lines_of_code_in
            where execution_record_uuid = execution_record_uuid_in;
        end if;


        set return_string = 'SUCCESS';
      END;
    else
      set return_string = 'ERROR: Record Not Found';
    end if;
    end if;

END
$$
DELIMITER ;

drop PROCEDURE if exists update_execution_run_status;
DELIMITER $$
############################################
CREATE PROCEDURE update_execution_run_status (
    IN execution_record_uuid_in VARCHAR(45),
    IN field_name_in VARCHAR(45),
    IN field_value_in VARCHAR(128),
    OUT return_string varchar(100)
  )
  BEGIN
    DECLARE row_count_int int;

    # Metric Runs
    if execution_record_uuid_in like 'M-%'
      then
        # verify exists 1 matching metric_run
        select count(1)
          into row_count_int
          from metric.metric_run
         where metric_run_uuid = execution_record_uuid_in;
        if row_count_int = 1 then
          begin
            case
            when field_name_in = 'status'                       then update metric.metric_run set status                       = field_value_in where metric_run_uuid = execution_record_uuid_in;
            when field_name_in = 'execute_node_architecture_id' then update metric.metric_run set execute_node_architecture_id = field_value_in where metric_run_uuid = execution_record_uuid_in;
            when field_name_in = 'lines_of_code'                then update metric.metric_run set code_lines                   = field_value_in where metric_run_uuid = execution_record_uuid_in;
            when field_name_in = 'cpu_utilization'              then update metric.metric_run set cpu_utilization              = field_value_in where metric_run_uuid = execution_record_uuid_in;
            when field_name_in = 'vm_password'                  then update metric.metric_run set vm_password                  = field_value_in where metric_run_uuid = execution_record_uuid_in;
            when field_name_in = 'vm_hostname'                  then update metric.metric_run set vm_hostname                  = field_value_in where metric_run_uuid = execution_record_uuid_in;
            when field_name_in = 'vm_username'                  then update metric.metric_run set vm_username                  = field_value_in where metric_run_uuid = execution_record_uuid_in;
            when field_name_in = 'vm_image'                     then update metric.metric_run set vm_image                     = field_value_in where metric_run_uuid = execution_record_uuid_in;
            when field_name_in = 'vm_ip_address'                then update metric.metric_run set vm_ip_address                = field_value_in where metric_run_uuid = execution_record_uuid_in;
            when field_name_in = 'tool_filename'                then update metric.metric_run set tool_filename                = field_value_in where metric_run_uuid = execution_record_uuid_in;
            when field_name_in = 'run_date'                     then update metric.metric_run set run_date                     = field_value_in, queued_duration = timediff(field_value_in, create_date) where metric_run_uuid = execution_record_uuid_in;
            when field_name_in = 'completion_date'              then update metric.metric_run set completion_date              = field_value_in, execution_duration = timediff(field_value_in, run_date) where metric_run_uuid = execution_record_uuid_in;
            when field_name_in = 'slot_size_start'              then update metric.metric_run set slot_size_start              = field_value_in where metric_run_uuid = execution_record_uuid_in;
            when field_name_in = 'slot_size_end'                then update metric.metric_run set slot_size_end                = field_value_in where metric_run_uuid = execution_record_uuid_in;
            end case;
            set return_string = 'SUCCESS';
          end;
        else
          set return_string = 'ERROR: Record Not Found';
        end if;
    # Assessment Runs
    else
      # verify exists 1 matching execution_record
      select count(1)
        into row_count_int
        from assessment.execution_record
       where execution_record_uuid = execution_record_uuid_in;
      if row_count_int = 1 then
        case
        when field_name_in = 'status'                       then update assessment.execution_record set status                       = field_value_in where execution_record_uuid = execution_record_uuid_in;
        when field_name_in = 'execute_node_architecture_id' then update assessment.execution_record set execute_node_architecture_id = field_value_in where execution_record_uuid = execution_record_uuid_in;
        when field_name_in = 'lines_of_code'                then update assessment.execution_record set code_lines                   = field_value_in where execution_record_uuid = execution_record_uuid_in;
        when field_name_in = 'cpu_utilization'              then update assessment.execution_record set cpu_utilization              = field_value_in where execution_record_uuid = execution_record_uuid_in;
        when field_name_in = 'vm_password'                  then update assessment.execution_record set vm_password                  = field_value_in where execution_record_uuid = execution_record_uuid_in;
        when field_name_in = 'vm_hostname'                  then update assessment.execution_record set vm_hostname                  = field_value_in where execution_record_uuid = execution_record_uuid_in;
        when field_name_in = 'vm_username'                  then update assessment.execution_record set vm_username                  = field_value_in where execution_record_uuid = execution_record_uuid_in;
        when field_name_in = 'vm_image'                     then update assessment.execution_record set vm_image                     = field_value_in where execution_record_uuid = execution_record_uuid_in;
        when field_name_in = 'vm_ip_address'                then update assessment.execution_record set vm_ip_address                = field_value_in where execution_record_uuid = execution_record_uuid_in;
        when field_name_in = 'tool_filename'                then update assessment.execution_record set tool_filename                = field_value_in where execution_record_uuid = execution_record_uuid_in;
        when field_name_in = 'run_date'                     then update assessment.execution_record set run_date                     = field_value_in, queued_duration = timediff(field_value_in, create_date) where execution_record_uuid = execution_record_uuid_in;
        when field_name_in = 'completion_date'              then update assessment.execution_record set completion_date              = field_value_in, execution_duration = timediff(field_value_in, run_date) where execution_record_uuid = execution_record_uuid_in;
        when field_name_in = 'slot_size_start'              then update assessment.execution_record set slot_size_start              = field_value_in where execution_record_uuid = execution_record_uuid_in;
        when field_name_in = 'slot_size_end'                then update assessment.execution_record set slot_size_end                = field_value_in where execution_record_uuid = execution_record_uuid_in;
        end case;
        update assessment.execution_record set vm_password = null where status like 'Finished%' and execution_record_uuid = execution_record_uuid_in;
        set return_string = 'SUCCESS';
      else
        set return_string = 'ERROR: Record Not Found';
      end if;
    end if;

END
$$
DELIMITER ;

drop PROCEDURE if exists launch_viewer;
DELIMITER $$
############################################
CREATE PROCEDURE launch_viewer (
    IN assessment_result_uuid_in VARCHAR(5000),
    IN user_uuid_in VARCHAR(45),
    IN viewer_version_uuid_in VARCHAR(45),
    IN project_uuid_in VARCHAR(45),
    IN destination_base_path_in VARCHAR(45),
	IN results_type_in VARCHAR(45),
    OUT return_path varchar(200),
    OUT return_string varchar(100),
    OUT viewer_instance_uuid_out varchar(45)
  )
  BEGIN
    DECLARE user_account_valid_flag CHAR(1);
    DECLARE project_user_valid_flag CHAR(1);
    DECLARE row_count_viewer_ver_int INT;
    DECLARE row_count_project_int INT;

    DECLARE row_count_result_int INT;
    DECLARE row_count_sys_set_int INT;
    DECLARE package_type_id_var INT;
    DECLARE platform_name_var VARCHAR(100);
    DECLARE platform_version_var VARCHAR(100);
    DECLARE tool_name_var VARCHAR(100);
    DECLARE tool_version_var VARCHAR(100);
    DECLARE package_name_var VARCHAR(100);
    DECLARE package_version_var VARCHAR(100);
    DECLARE execution_record_uuid_var VARCHAR(45);
    DECLARE start_time_var VARCHAR(100);
    DECLARE end_date_var VARCHAR(100);
    DECLARE result_file_full_source_path VARCHAR(200);
    DECLARE result_file_parent_dir VARCHAR(200);
    DECLARE result_file_filename VARCHAR(200);
    DECLARE cmd VARCHAR(5000);
    DECLARE xfm_return VARCHAR(500);

    DECLARE viewer_name_var VARCHAR(100);
    DECLARE source_archive_path_var VARCHAR(200);
    DECLARE invocation_cmd_var VARCHAR(200);
    DECLARE sign_in_cmd_var VARCHAR(200);
    DECLARE add_user_cmd_var VARCHAR(200);
    DECLARE add_result_cmd_var VARCHAR(200);
    DECLARE viewer_path_var VARCHAR(200);
    DECLARE viewer_checksum_var VARCHAR(200);
    DECLARE viewer_instance_count_int INT;
    DECLARE viewer_instance_uuid_var VARCHAR(45);
    DECLARE viewer_db_path_var VARCHAR(200);
    DECLARE viewer_db_checksum_var VARCHAR(200);
    DECLARE launch_viewer_return VARCHAR(500);
    DECLARE position_of_next_comma INT;
    DECLARE first_assessment_result_uuid VARCHAR(50);
    DECLARE next_assessment_result_uuid  VARCHAR(50);
    DECLARE remaining_assessment_result_uuid VARCHAR(5000);
    DECLARE proxy_url VARCHAR(100);
    DECLARE vm_ip_address VARCHAR(50);

    # check user is valid in user_account table
    select distinct 'Y'
      into user_account_valid_flag
      from project.user_account ua
     where ua.user_uid = user_uuid_in
       and ua.enabled_flag = 1;

    # check user is member of the project
    select distinct 'Y'
      into project_user_valid_flag
      from project.project_user pu
     where pu.project_uid = project_uuid_in
       and pu.user_uid = user_uuid_in
       and pu.delete_date is null
       and (pu.expire_date > now() or pu.expire_date is null);

    # verify exists 1 matching viewer_version
    select count(1)
      into row_count_viewer_ver_int
      from viewer_store.viewer_version
     where viewer_version_uuid = viewer_version_uuid_in;

    # verify exists 1 matching project
    select count(1)
      into row_count_project_int
      from project.project
     where project_uid = project_uuid_in;

    if project_user_valid_flag = 'Y'
       and user_account_valid_flag = 'Y'
       and row_count_viewer_ver_int = 1
       and row_count_project_int = 1
    then
      BEGIN
        ### Native Viewer START
        if viewer_version_uuid_in = '8f9213ef-5d04-11e3-9fa4-001a4a81450b'
        then

          # verify exists 1 matching assessment_result
          select count(1)
            into row_count_result_int
           from assessment.assessment_result
           where assessment_result_uuid = assessment_result_uuid_in;

          if row_count_result_int = 1
          then
            BEGIN
              # lookup result details
              select file_path,
                     platform_name, platform_version, tool_name, tool_version, package_name, package_version,
                     execution_record_uuid
                into result_file_full_source_path,
                     platform_name_var, platform_version_var, tool_name_var, tool_version_var, package_name_var, package_version_var,
                     execution_record_uuid_var
                from assessment.assessment_result
               where assessment_result_uuid = assessment_result_uuid_in;

              # lookup start/end times
              select run_date, completion_date
                into start_time_var, end_date_var
                from assessment.execution_record
               where execution_record_uuid = execution_record_uuid_var;

              # lookup package type
              select p.package_type_id
                into package_type_id_var
                from package_store.package p
               inner join package_store.package_version pv on p.package_uuid = pv.package_uuid
               inner join assessment.assessment_result ar on ar.package_version_uuid = pv.package_version_uuid
               where ar.assessment_result_uuid = assessment_result_uuid_in;

              # Get parent dir and filename
              set result_file_parent_dir = substring_index(substring_index(result_file_full_source_path,'/',-2),'/',1);
              set result_file_filename = substring_index(result_file_full_source_path,'/',-1);

              # call transform script
              set cmd = null;
              set cmd = CONCAT(' /usr/local/bin/launch_viewer',
                               ' --viewer_name \'Native\'',
                               ifnull(concat(' --results_type \'', results_type_in,'\''),''),
                               ifnull(concat(' --package_type \'', package_type_id_var,'\''),''),
                               ifnull(concat(' --file_path \'', result_file_full_source_path,'\''),''),
                               ifnull(concat(' --outdir \'', destination_base_path_in, assessment_result_uuid_in,'\''),''),
                               ifnull(concat(' --package_name \'', package_name_var,'\''),''),
                               ifnull(concat(' --package_version \'', package_version_var,'\''),''),
                               ifnull(concat(' --tool_name \'', tool_name_var,'\''),''),
                               ifnull(concat(' --tool_version \'', tool_version_var,'\''),''),
                               ifnull(concat(' --platform_name \'', platform_name_var,'\''),''),
                               ifnull(concat(' --platform_version \'', platform_version_var,'\''),''),
                               ifnull(concat(' --start_date \'', start_time_var,'\''),''),
                               ifnull(concat(' --end_date \'', end_date_var,'\''),''),
                               ifnull(concat(' --user_uuid \'', user_uuid_in,'\''),''),
                               '');

              # Verbose Logging
                #insert into sys_exec_cmd_log (cmd, caller) values (cmd, 'launch_viewer');
              SELECT sys_eval(cmd) into xfm_return;

              # insert into viewer_launch_history
              insert into viewer_store.viewer_launch_history (viewer_version_uuid, project_uuid, viewer_instance_uuid, assessment_result_uuid, user_uuid, run_date)
                values (viewer_version_uuid_in, project_uuid_in, 'NATIVE', assessment_result_uuid_in, user_uuid_in, now());

              if xfm_return is null or xfm_return like '%ERROR%' then set return_string = 'ERROR FILE XFM';
              else set return_string = 'SUCCESS', return_path = concat(destination_base_path_in,result_file_parent_dir,'/',xfm_return);
              end if;

            END;
          elseif row_count_result_int  != 1 THEN set return_string = 'ERROR: RESULT NOT FOUND';
          else set return_string = 'ERROR: UNSPECIFIED ERROR';
          end if;
        ### Native Viewer END
        ### CodeDX Viewer START
            # Threadfix works the same as CodeDx
        elseif viewer_version_uuid_in in ('5d0fb63c-865a-11e3-88bb-001a4a81450b', 'b0e931d7-bfb2-11e5-bf72-001a4a814413')
        then

          # set viewer name
          if viewer_version_uuid_in = '5d0fb63c-865a-11e3-88bb-001a4a81450b'
             then set viewer_name_var = 'CodeDX';
          elseif viewer_version_uuid_in = 'b0e931d7-bfb2-11e5-bf72-001a4a814413'
             then set viewer_name_var = 'ThreadFix';
          else set return_string = 'ERROR: Unknown Viewer';
          end if;

          # lookup viewer data
          select invocation_cmd, sign_in_cmd, add_user_cmd, add_result_cmd, viewer_path, viewer_checksum
            into invocation_cmd_var, sign_in_cmd_var, add_user_cmd_var, add_result_cmd_var, viewer_path_var, viewer_checksum_var
            from viewer_store.viewer_version
           where viewer_version_uuid = viewer_version_uuid_in;

          # See if a viewer_instance already exists for this viewer and project
          select count(1)
            into viewer_instance_count_int
           from viewer_store.viewer_instance
           where viewer_version_uuid = viewer_version_uuid_in
             and project_uuid = project_uuid_in;

          # Fetch/Create Viewer Instance
          if viewer_instance_count_int = 1
          then
            select viewer_instance_uuid, viewer_db_path, viewer_db_checksum
              into viewer_instance_uuid_var, viewer_db_path_var, viewer_db_checksum_var
             from viewer_store.viewer_instance
             where viewer_version_uuid = viewer_version_uuid_in
               and project_uuid = project_uuid_in;
          elseif viewer_instance_count_int = 0
          then
            begin
              # create viewer_instance record
              set viewer_instance_uuid_var = uuid();
              insert into viewer_store.viewer_instance
                (viewer_instance_uuid, viewer_version_uuid, project_uuid)
                values
                (viewer_instance_uuid_var, viewer_version_uuid_in, project_uuid_in);
            end;
          else set return_string = 'ERROR: Viewer Instance Error';
          end if;

          # start to build cmd to call Perl script
          set cmd = null;
          set cmd = CONCAT(' /usr/local/bin/launch_viewer',
                           ifnull(concat(' --viewer_name \'', viewer_name_var,'\''),''),
                           ifnull(concat(' --project \'', project_uuid_in,'\''),''),
                           #ifnull(concat(' --invocation_cmd \'', invocation_cmd_var,'\''),''),
                           #ifnull(concat(' --sign_in_cmd \'', sign_in_cmd_var,'\''),''),
                           #ifnull(concat(' --add_user_cmd \'', add_user_cmd_var,'\''),''),
                           #ifnull(concat(' --add_result_cmd \'', add_result_cmd_var,'\''),''),
                           #ifnull(concat(' --viewer_path \'', viewer_path_var,'\''),''),
                           #ifnull(concat(' --viewer_checksum \'', viewer_checksum_var,'\''),''),
                           ifnull(concat(' --viewer_db_path \'', viewer_db_path_var,'\''),''),
                           ifnull(concat(' --viewer_db_checksum \'', viewer_db_checksum_var,'\''),''),
                           ifnull(concat(' --viewer_uuid \'', viewer_instance_uuid_var,'\''),''),
                           ifnull(concat(' --user_uuid \'', user_uuid_in,'\''),''),
                           '');

          # if there is one or more assessment_result_uuid's then append to cmd
          if assessment_result_uuid_in is not null
          then
            # add trailing comma to incoming uuid if there isn't one already
            if(right(assessment_result_uuid_in,1) <> ',' and length(assessment_result_uuid_in)>0)
              then set assessment_result_uuid_in = concat(assessment_result_uuid_in,',');
            end if;

            # strip off first uuid
            set position_of_next_comma = instr(assessment_result_uuid_in, ',');
            set first_assessment_result_uuid = substring(assessment_result_uuid_in, 1, position_of_next_comma - 1);
            set remaining_assessment_result_uuid = substring(assessment_result_uuid_in, position_of_next_comma + 1, length(assessment_result_uuid_in) - position_of_next_comma);

            # verify exists 1 matching assessment_result to first_assessment_result_uuid
            select count(1)
              into row_count_result_int
             from assessment.assessment_result
             where assessment_result_uuid = first_assessment_result_uuid;

            if row_count_result_int = 1
            then
              # lookup result path and tool name
              select package_name, tool_name, file_path, source_archive_path
                into package_name_var, tool_name_var, result_file_full_source_path, source_archive_path_var
                from assessment.assessment_result
               where assessment_result_uuid = first_assessment_result_uuid;

              # lookup package type
              select p.package_type_id
                into package_type_id_var
                from package_store.package p
               inner join package_store.package_version pv on p.package_uuid = pv.package_uuid
               inner join assessment.assessment_result ar on ar.package_version_uuid = pv.package_version_uuid
               where ar.assessment_result_uuid = first_assessment_result_uuid;

              set cmd = CONCAT(cmd, ifnull(concat(' --package \'', package_name_var,'\''),''),
                                    ifnull(concat(' --tool_name \'', tool_name_var,'\''),''),
                                    ifnull(concat(' --source_archive_path \'', source_archive_path_var,'\''),''),
                                    ifnull(concat(' --package_type \'', package_type_id_var,'\''),''),
                                    ifnull(concat(' --file_path \'', result_file_full_source_path,'\''),''),
                                    '');

              # insert into viewer_launch_history
              insert into viewer_store.viewer_launch_history (viewer_version_uuid, project_uuid, viewer_instance_uuid, assessment_result_uuid, user_uuid, run_date)
                values (viewer_version_uuid_in, project_uuid_in, viewer_instance_uuid_var, assessment_result_uuid_in, user_uuid_in, now());

              # if there are additional uuids, loop thru, fetch result file, append to cmd
              while length(remaining_assessment_result_uuid) > 0 DO
                begin
                  set position_of_next_comma = instr(remaining_assessment_result_uuid, ',');
                  if position_of_next_comma > 0
                  then
                    begin
                      set next_assessment_result_uuid = substring(remaining_assessment_result_uuid, 1, position_of_next_comma - 1);
                      set remaining_assessment_result_uuid = substring(remaining_assessment_result_uuid, position_of_next_comma + 1, length(remaining_assessment_result_uuid) - position_of_next_comma);
                      # get result file
                      select file_path
                        into result_file_full_source_path
                        from assessment.assessment_result
                       where assessment_result_uuid = next_assessment_result_uuid;
                      # append to cmd
                      set cmd = CONCAT(cmd, ifnull(concat(' --file_path \'', result_file_full_source_path,'\''),''));
                      # insert into viewer_launch_history
                      insert into viewer_store.viewer_launch_history (viewer_version_uuid, project_uuid, viewer_instance_uuid, assessment_result_uuid, user_uuid, run_date)
                        values (viewer_version_uuid_in, project_uuid_in, viewer_instance_uuid_var, next_assessment_result_uuid, user_uuid_in, now());
                    end;
                  end if;
                end;
              end while;

            else set return_string = 'ERROR: RESULT NOT FOUND';
            end if;

          end if;

          # Call Perl Script
            # Verbose Logging
              # insert into sys_exec_cmd_log (cmd, caller) values (cmd, 'launch_viewer');
              # insert into viewer_store.viewer_launch_time_history (viewer_instance_uuid, event, description)
              # values (viewer_instance_uuid_var, 'launch_viewer Start', null);
          SELECT sys_eval(cmd) into launch_viewer_return;
            # Verbose Logging
              # insert into viewer_store.viewer_launch_time_history (viewer_instance_uuid, event, description)
              # values (viewer_instance_uuid_var, 'launch_viewer End', launch_viewer_return);

          # Tell Web if Perl reports error or not
          if upper(launch_viewer_return) like '%ERROR%' then set return_string = launch_viewer_return;
          elseif launch_viewer_return is null then set return_string = 'Error Launching Viewer';
          else set return_string = 'SUCCESS';
          end if;

          # Give Web viewer_instance_uuid
          set viewer_instance_uuid_out = viewer_instance_uuid_var;

        ### CodeDX Viewer END
        else set return_string = 'ERROR: INVALID VIEWER VERSION UUID';
        end if;
      END;
    elseif row_count_viewer_ver_int            != 1   THEN set return_string = 'ERROR: VIEWER VERSION NOT FOUND';
    elseif row_count_project_int               != 1   THEN set return_string = 'ERROR: PROJECT NOT FOUND';
    elseif ifnull(user_account_valid_flag,'N') != 'Y' THEN set return_string = 'ERROR: USER ACCOUNT NOT VALID';
    elseif ifnull(project_user_valid_flag,'N') != 'Y' THEN set return_string = 'ERROR: USER PROJECT PERMISSION NOT VALID';
    else set return_string = 'ERROR: UNSPECIFIED ERROR';
    end if;

END
$$
DELIMITER ;

drop PROCEDURE if exists download;
DELIMITER $$
############################################
CREATE PROCEDURE download (
    IN source_file_full_path_in VARCHAR(200),
    OUT return_url varchar(200),
    OUT return_success_flag char(1),
    OUT return_msg varchar(100)
  )
  BEGIN
    DECLARE destination_base_path VARCHAR(50);
    DECLARE return_url_base VARCHAR(100);
    DECLARE destination_parent_dir VARCHAR(45);
    DECLARE destination_filename VARCHAR(200);
    DECLARE destination_full_path VARCHAR(200);

    DECLARE cmd VARCHAR(500);
    DECLARE mkdir_return_code INT;
    DECLARE copy_return_code INT;
    DECLARE chmod_return_code INT;

    select system_setting_value
      into return_url_base
      from system_setting
     where system_setting_code = 'OUTGOING_BASE_URL';

    set destination_base_path = '/swamp/outgoing/';
    set destination_parent_dir = uuid();
    set destination_filename = substring_index(source_file_full_path_in,'/',-1);
    set destination_full_path = concat(destination_base_path,destination_parent_dir,'/',destination_filename);
    set return_url = concat(return_url_base,destination_parent_dir,'/',destination_filename);

    # mkdir for destination
    set cmd = null;
    set cmd = CONCAT('mkdir -p ', destination_base_path, destination_parent_dir);
    set mkdir_return_code = sys_exec(cmd);

    # copy result file
    set cmd = null;
    set cmd = CONCAT('cp ', source_file_full_path_in, ' ', destination_full_path);
    set copy_return_code = sys_exec(cmd);

    # chmod
    set cmd = null;
    set cmd = CONCAT('chmod -R 777 ', CONCAT(destination_base_path, destination_parent_dir));
    set chmod_return_code = sys_exec(cmd);

    if mkdir_return_code     != 0 then set return_success_flag = 'N', return_msg = 'ERROR MKDIR';
    elseif copy_return_code  != 0 then set return_success_flag = 'N', return_msg = 'ERROR COPYING FILE';
    elseif chmod_return_code != 0 then set return_success_flag = 'N', return_msg = 'ERROR SETTING PERMISSIONS';
    else set return_success_flag = 'Y', return_msg    = 'SUCCESS';
    end if;

END
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS `download_results`;
DELIMITER $$
############################################
CREATE PROCEDURE `download_results`(
    IN assessment_result_uuid_in VARCHAR(5000),
    IN user_uuid_in VARCHAR(45),
    In return_type VARCHAR(10),     -- One of 'scarf' (default), 'source', or 'log'.
    OUT return_url VARCHAR(200),    -- Full URL for downloading
    OUT return_file VARCHAR(200),   -- Full path filename of downloadable file
    OUT return_string VARCHAR(100)  -- Result, either 'SUCCESS' or 'ERROR: <errormsg>'
  )
  COMMENT 'Given an assessment_result_uuid and a user_uuid, copy asssessment results to a download folder and return its full filepath and download URL. Assessemnt results type can be one of "scarf", "source", or "log".'
  BEGIN
    DECLARE project_uuid_in VARCHAR(45);
    DECLARE user_account_valid_flag CHAR(1);
    DECLARE project_user_valid_flag CHAR(1);
    DECLARE row_count_project_int INT;
    DECLARE row_count_result_int INT;
    DECLARE result_file_full_source_path VARCHAR(200);
    DECLARE return_success_flag CHAR(1);
    DECLARE return_msg VARCHAR(100);

    DECLARE return_url_base VARCHAR(100);
    DECLARE destination_base_path VARCHAR(50);
    DECLARE destination_parent_dir VARCHAR(45);
    DECLARE destination_filename VARCHAR(200);
    DECLARE destination_full_path VARCHAR(200);

    DECLARE cmd VARCHAR(500);
    DECLARE mkdir_return_code INT;
    DECLARE copy_return_code INT;
    DECLARE chmod_return_code INT;

    select project_uuid
      into project_uuid_in
      from assessment.assessment_result
     where assessment_result_uuid = assessment_result_uuid_in;

    select distinct 'Y'
      into user_account_valid_flag
      from project.user_account ua
     where ua.user_uid = user_uuid_in
       and ua.enabled_flag = 1;

    select distinct 'Y'
      into project_user_valid_flag
      from project.project_user pu
     where pu.project_uid = project_uuid_in
       and pu.user_uid = user_uuid_in
       and pu.delete_date is null
       and (pu.expire_date > now() or pu.expire_date is null);

    select count(1)
      into row_count_project_int
      from project.project
     where project_uid = project_uuid_in;

    if project_user_valid_flag = 'Y'
       and user_account_valid_flag = 'Y'
       and row_count_project_int = 1
    then
      BEGIN

        select count(1)
          into row_count_result_int
          from assessment.assessment_result
         where assessment_result_uuid = assessment_result_uuid_in;

        if row_count_result_int = 1
        then
          BEGIN

            if return_type = 'source'
            then
              select source_archive_path
                into result_file_full_source_path
                from assessment.assessment_result
               where assessment_result_uuid = assessment_result_uuid_in;
            elseif return_type = 'log'
            then
              select log_path
                into result_file_full_source_path
                from assessment.assessment_result
               where assessment_result_uuid = assessment_result_uuid_in;
            else -- 'scarf'
              select file_path
                into result_file_full_source_path
                from assessment.assessment_result
               where assessment_result_uuid = assessment_result_uuid_in;
            end if;

            set destination_base_path = '/swamp/outgoing/';
            set destination_parent_dir = uuid();
            set destination_filename = substring_index(result_file_full_source_path,'/',-1);
            set destination_full_path = concat(destination_base_path,destination_parent_dir,'/',destination_filename);

            set cmd = null;
            set cmd = CONCAT('[ -d ', destination_base_path, destination_parent_dir, ' ] || mkdir -p ', destination_base_path, destination_parent_dir);
            set mkdir_return_code = sys_exec(cmd);

            set cmd = null;
            set cmd = CONCAT('cp -n ', result_file_full_source_path, ' ', destination_full_path);
            set copy_return_code = sys_exec(cmd);

            set cmd = null;
            set cmd = CONCAT('chmod -R 777 ', CONCAT(destination_base_path, destination_parent_dir));
            set chmod_return_code = sys_exec(cmd);

            if mkdir_return_code     != 0 then set return_string = 'ERROR: MKDIR FAILED';
            elseif copy_return_code  != 0 then set return_string = 'ERROR: COPY FILE FAILED';
            elseif chmod_return_code != 0 then set return_string = 'ERROR: SET PERMISSIONS FAILED';
            else set return_string = 'SUCCESS';
            end if;

          END;
        else set return_string = 'ERROR: RESULT NOT FOUND';
        end if;

      END;
    elseif row_count_project_int                != 1   then set return_string = 'ERROR: PROJECT NOT FOUND';
    elseif ifnull(user_account_valid_flag,'N')  != 'Y' then set return_string = 'ERROR: USER ACCOUNT NOT VALID';
    elseif ifnull(project_user_valid_flag,'N')  != 'Y' then set return_string = 'ERROR: USER PROJECT PERMISSION NOT VALID';
    else set return_string = 'ERROR: UNSPECIFIED ERROR';
    end if;

    if return_string = 'SUCCESS'
    then
      BEGIN

        select system_setting_value
          into return_url_base
          from system_setting
         where system_setting_code = 'OUTGOING_BASE_URL';

        set return_url  = concat(return_url_base,destination_parent_dir,'/',destination_filename);
        set return_file = destination_full_path;

      END;
    end if;

END
$$
DELIMITER ;

drop PROCEDURE if exists kill_assessment_run;
DELIMITER $$
############################################
## This procedure will pass along any kind of uuid. It doesn't care if it's an A-Run, M-Run, V-Run or bogus.
CREATE PROCEDURE kill_assessment_run (
    IN execution_record_uuid_in VARCHAR(45),
    IN hard_kill_flag_in VARCHAR(45),
    OUT return_string varchar(100)
  )
  BEGIN
    DECLARE cmd VARCHAR(500);
    DECLARE cmd_return VARCHAR(100);

    # Call Perl Script
    set cmd = null;
    set cmd = CONCAT(' /usr/local/bin/kill_run',
                     ifnull(concat(' --execution_record_uuid \'', execution_record_uuid_in,'\''),''),
                     ifnull(concat(' --hard \'', hard_kill_flag_in,'\''),''),
                     '');
    insert into sys_exec_cmd_log (cmd, caller) values (cmd, 'kill_assessment_run');
    set cmd_return = sys_exec(cmd);

    # Report if system call sent sucessfully or not. Doesn't mean perl script succeded.
    if cmd_return != 0 then set return_string = 'ERROR';
    else                    set return_string = 'SUCCESS';
    end if;


END
$$
DELIMITER ;

drop PROCEDURE if exists select_system_setting;
DELIMITER $$
############################################
CREATE PROCEDURE select_system_setting (
    IN system_setting_code_in VARCHAR(25),
    OUT system_setting_value_out  VARCHAR(200)
  )
  BEGIN
    DECLARE row_count_int int;

    # verify exists 1 matching record
    select count(1)
      into row_count_int
      from assessment.system_setting
     where system_setting_code = system_setting_code_in;

    if row_count_int = 1 then
      select system_setting_value
        into system_setting_value_out
        from assessment.system_setting
       where system_setting_code = system_setting_code_in;
    end if;

END
$$
DELIMITER ;

drop PROCEDURE if exists set_system_status;

drop PROCEDURE if exists increment_launch_counter;
DELIMITER $$
############################################
CREATE PROCEDURE increment_launch_counter (
    IN execution_record_uuid_in VARCHAR(45),
    IN launch_counter_in INT(1),
    OUT launch_counter_out  INT(1)
  )
  BEGIN
    DECLARE row_count_int int;

    # verify exists 1 matching record
    select count(1)
      into row_count_int
      from assessment.execution_record
     where execution_record_uuid = execution_record_uuid_in;

    if row_count_int = 1 then
      update assessment.execution_record
         set launch_counter = launch_counter_in + 1,
             launch_countdown = 20
       where execution_record_uuid = execution_record_uuid_in;
      select launch_counter
        into launch_counter_out
        from assessment.execution_record
       where execution_record_uuid = execution_record_uuid_in;
    else
      set launch_counter_out = -1;
    end if;

END
$$
DELIMITER ;

drop PROCEDURE if exists populate_usage_stats;
DELIMITER $$
############################################
CREATE PROCEDURE populate_usage_stats ()
  BEGIN
    DECLARE enabled_users_var    int;
    DECLARE package_uploads_var int;
    DECLARE assessments_var     int;
    DECLARE loc_var             int;

    # enabled users
    select count(1)
      into enabled_users_var
      from project.user_account
     where (user_type is null or user_type != 'test')
       #and hibernate_flag = 0
       and enabled_flag = 1;

    # Pkg uploads - excludes test users
    select count(distinct pv.package_version_uuid)
      into package_uploads_var
      from package_store.package p
     inner join package_store.package_version pv on p.package_uuid = pv.package_uuid
     where p.package_owner_uuid != '80835e30-d527-11e2-8b8b-0800200c9a66'
       and p.package_owner_uuid not in (select user_uid from project.user_account where user_type = 'test')
       and pv.create_date > DATE_SUB(now(), INTERVAL 1 YEAR);

    # assessments, loc - excludes test users
    select count(1) as arun_cnt, sum(ifnull(x.max_mr_pkg_total_lines, x.er_total_lines))
      into assessments_var, loc_var
    from (
    select er.execution_record_uuid, er.total_lines as er_total_lines, max(mr.pkg_total_lines) as max_mr_pkg_total_lines
      from assessment.execution_record er
     left outer join metric.metric_run mr on er.package_version_uuid = mr.package_version_uuid
     where er.user_uuid not in (select user_uid from project.user_account where user_type = 'test')
       and er.create_date > DATE_SUB(now(), INTERVAL 1 YEAR)
    group by er.execution_record_uuid
     ) x;

    insert into assessment.usage_stats (enabled_users, package_uploads, assessments, loc) values (enabled_users_var, package_uploads_var, assessments_var, loc_var);
END
$$
DELIMITER ;

###################
## Triggers

#DROP TRIGGER IF EXISTS execution_record_AINS;
#DROP TRIGGER IF EXISTS execution_record_AUPD;
DROP TRIGGER IF EXISTS assessment_run_BINS;
DROP TRIGGER IF EXISTS assessment_run_BUPD;
DROP TRIGGER IF EXISTS run_request_BINS;
DROP TRIGGER IF EXISTS run_request_BUPD;
DROP TRIGGER IF EXISTS run_request_schedule_BINS;
DROP TRIGGER IF EXISTS run_request_schedule_BUPD;
DROP TRIGGER IF EXISTS assessment_run_request_BINS;
DROP TRIGGER IF EXISTS assessment_run_request_BUPD;
DROP TRIGGER IF EXISTS execution_record_BINS;
DROP TRIGGER IF EXISTS execution_record_BUPD;
DROP TRIGGER IF EXISTS assessment_result_BINS;
DROP TRIGGER IF EXISTS assessment_result_BUPD;
DROP TRIGGER IF EXISTS assessment_result_viewer_history_BINS;
DROP TRIGGER IF EXISTS assessment_result_viewer_history_BUPD;
DROP TRIGGER IF EXISTS sys_exec_cmd_log_BINS;
DROP TRIGGER IF EXISTS sys_exec_cmd_log_BUPD;
DROP TRIGGER IF EXISTS system_setting_BINS;
DROP TRIGGER IF EXISTS system_setting_BUPD;
DROP TRIGGER IF EXISTS database_version_BINS;
DROP TRIGGER IF EXISTS database_version_BUPD;
DROP TRIGGER IF EXISTS group_list_BINS;
DROP TRIGGER IF EXISTS group_list_BUPD;
DROP TRIGGER IF EXISTS notification_BINS;
DROP TRIGGER IF EXISTS notification_BUPD;
DROP TRIGGER IF EXISTS system_status_BUPD;
DROP TRIGGER IF EXISTS ssh_request_BINS;
DROP TRIGGER IF EXISTS ssh_request_BUPD;

DELIMITER $$
CREATE TRIGGER assessment_run_BINS BEFORE INSERT ON assessment_run FOR EACH ROW SET NEW.create_user = user(), NEW.create_date = now();
$$
CREATE TRIGGER assessment_run_BUPD BEFORE UPDATE ON assessment_run FOR EACH ROW SET NEW.update_user = user(), NEW.update_date = now();
$$
CREATE TRIGGER run_request_BINS BEFORE INSERT ON run_request FOR EACH ROW SET NEW.create_user = user(), NEW.create_date = now();
$$
CREATE TRIGGER run_request_BUPD BEFORE UPDATE ON run_request FOR EACH ROW SET NEW.update_user = user(), NEW.update_date = now();
$$
CREATE TRIGGER run_request_schedule_BINS BEFORE INSERT ON run_request_schedule FOR EACH ROW SET NEW.create_user = user(), NEW.create_date = now();
$$
CREATE TRIGGER run_request_schedule_BUPD BEFORE UPDATE ON run_request_schedule FOR EACH ROW SET NEW.update_user = user(), NEW.update_date = now();
$$
#CREATE TRIGGER assessment_run_request_BINS BEFORE INSERT ON assessment_run_request FOR EACH ROW SET NEW.create_user = user(), NEW.create_date = now();
$$
CREATE TRIGGER assessment_run_request_BUPD BEFORE UPDATE ON assessment_run_request FOR EACH ROW SET NEW.update_user = user(), NEW.update_date = now();
$$
CREATE TRIGGER execution_record_BINS BEFORE INSERT ON execution_record FOR EACH ROW SET NEW.create_user = user(), NEW.create_date = now();
$$
#CREATE TRIGGER execution_record_BUPD BEFORE UPDATE ON execution_record FOR EACH ROW SET NEW.update_user = user(), NEW.update_date = now();
#$$
CREATE TRIGGER assessment_result_BINS BEFORE INSERT ON assessment_result FOR EACH ROW SET NEW.create_user = user(), NEW.create_date = now(), NEW.tool_uuid = (select tv.tool_uuid from tool_shed.tool_version tv where tv.tool_version_uuid = NEW.tool_version_uuid);
$$
CREATE TRIGGER assessment_result_BUPD BEFORE UPDATE ON assessment_result FOR EACH ROW SET NEW.update_user = user(), NEW.update_date = now();
$$
CREATE TRIGGER assessment_result_viewer_history_BINS BEFORE INSERT ON assessment_result_viewer_history FOR EACH ROW SET NEW.create_user = user(), NEW.create_date = now();
$$
CREATE TRIGGER assessment_result_viewer_history_BUPD BEFORE UPDATE ON assessment_result_viewer_history FOR EACH ROW SET NEW.update_user = user(), NEW.update_date = now();
$$
CREATE TRIGGER sys_exec_cmd_log_BINS BEFORE INSERT ON sys_exec_cmd_log FOR EACH ROW SET NEW.create_user = user(), NEW.create_date = now();
$$
CREATE TRIGGER sys_exec_cmd_log_BUPD BEFORE UPDATE ON sys_exec_cmd_log FOR EACH ROW SET NEW.update_user = user(), NEW.update_date = now();
$$
CREATE TRIGGER system_setting_BINS BEFORE INSERT ON system_setting FOR EACH ROW SET NEW.create_user = user(), NEW.create_date = now();
$$
CREATE TRIGGER system_setting_BUPD BEFORE UPDATE ON system_setting FOR EACH ROW SET NEW.update_user = user(), NEW.update_date = now();
$$
CREATE TRIGGER database_version_BINS BEFORE INSERT ON database_version FOR EACH ROW SET NEW.create_user = user(), NEW.create_date = now();
$$
CREATE TRIGGER database_version_BUPD BEFORE UPDATE ON database_version FOR EACH ROW SET NEW.update_user = user(), NEW.update_date = now();
$$
CREATE TRIGGER group_list_BINS BEFORE INSERT ON group_list FOR EACH ROW SET NEW.create_user = user(), NEW.create_date = now();
$$
CREATE TRIGGER group_list_BUPD BEFORE UPDATE ON group_list FOR EACH ROW SET NEW.update_user = user(), NEW.update_date = now();
$$
CREATE TRIGGER notification_BINS BEFORE INSERT ON notification FOR EACH ROW SET NEW.create_user = user(), NEW.create_date = now();
$$
CREATE TRIGGER notification_BUPD BEFORE UPDATE ON notification FOR EACH ROW SET NEW.update_user = user(), NEW.update_date = now();
$$
CREATE TRIGGER system_status_BUPD BEFORE UPDATE ON system_status FOR EACH ROW SET NEW.update_date = now();
$$
CREATE TRIGGER ssh_request_BINS BEFORE INSERT ON ssh_request FOR EACH ROW SET NEW.create_user = user(), NEW.create_date = now();
$$
CREATE TRIGGER ssh_request_BUPD BEFORE UPDATE ON ssh_request FOR EACH ROW SET NEW.update_user = user(), NEW.update_date = now();
$$
DELIMITER ;

# run now trigger
# if "run now" job is scheduled, then create execution record
#DROP TRIGGER IF EXISTS assessment_run_request_BINS;
DELIMITER $$
CREATE TRIGGER assessment_run_request_BINS BEFORE INSERT ON assessment_run_request FOR EACH ROW
  BEGIN
    DECLARE assessment_run_uuid_var VARCHAR(45);
    DECLARE run_request_uuid_var VARCHAR(45);
    DECLARE return_string varchar(100);

    # set create user and date
    SET NEW.create_user = user(), NEW.create_date = now();

    # if run request id is NOW
    if (NEW.run_request_id = 1)
      then
        # get assessment_run_uuid
        select assessment_run_uuid
          into assessment_run_uuid_var
         from assessment_run
        where assessment_run_id = NEW.assessment_run_id;

        # get run_request_uuid
        select run_request_uuid
          into run_request_uuid_var
         from run_request
        where run_request_id = NEW.run_request_id;

        # call stored procedure to create ER
        call assessment.create_execution_record(assessment_run_uuid_var, run_request_uuid_var, NEW.notify_when_complete_flag, NEW.user_uuid, return_string);
        if (return_string = 'SUCCESS')
          then
            # mark record as "deleted"
            set NEW.delete_date = now();
        end if;
    end if;

END;
$$
DELIMITER ;

# notify user trigger
DROP TRIGGER IF EXISTS notification_AINS;

#CREATE TRIGGER execution_record_BUPD BEFORE UPDATE ON execution_record FOR EACH ROW SET NEW.update_user = user(), NEW.update_date = now();
# kill A-Run trigger
DROP TRIGGER IF EXISTS execution_record_BUPD;
DELIMITER $$
CREATE TRIGGER execution_record_BUPD BEFORE UPDATE ON execution_record FOR EACH ROW
  BEGIN
    DECLARE return_string VARCHAR(100);

    SET NEW.update_user = user(), NEW.update_date = now();

    # if execution_record is being deleted and it's still running, then kill it
    if OLD.delete_date is null
       and NEW.delete_date is not null
       and NEW.complete_flag = 0
       then
         set NEW.launch_flag = 0;
         call assessment.kill_assessment_run (NEW.execution_record_uuid, 1, return_string);
    end if;

END;
$$
DELIMITER ;

###################
## Events
##  Events in assessment_tables.sql will only be created on install, but untouched during upgrades.
##  Events in assessment_procs.sql will created on installs, as well as dropped and recreated during upgrades.
SET GLOBAL event_scheduler = ON;

drop EVENT if exists process_execution_records;
DELIMITER $$
CREATE EVENT process_execution_records
  ON SCHEDULE EVERY 3 SECOND
  DO
    BEGIN
      DECLARE currently_processing_execution_records VARCHAR(1);
      DECLARE currently_processing_execution_records_update_date TIMESTAMP;

      select value, update_date
        into currently_processing_execution_records, currently_processing_execution_records_update_date
        from system_status
       where status_key = 'CURRENTLY_PROCESSING_EXECUTION_RECORDS';

      if currently_processing_execution_records = 'Y' and TIMEDIFF(now(),currently_processing_execution_records_update_date) < '00:05:00' then
        insert into sys_exec_cmd_log (cmd, caller) values ('Call to procedure process_execution_records skipped because procedure is currently running.', 'process_execution_records');
      elseif currently_processing_execution_records = 'Y' and TIMEDIFF(now(),currently_processing_execution_records_update_date) > '00:05:00' then
        begin
          insert into sys_exec_cmd_log (cmd, caller) values ('process_execution_records running longer than 5 minutes.', 'process_execution_records');
          update system_status set value = 'N' where status_key = 'CURRENTLY_PROCESSING_EXECUTION_RECORDS';
          CALL assessment.process_execution_records();
        end;
      else
        CALL assessment.process_execution_records();
      end if;

END
$$
DELIMITER ;

drop EVENT if exists populate_usage_stats;
CREATE EVENT populate_usage_stats
  ON SCHEDULE EVERY 1 DAY
  DO CALL assessment.populate_usage_stats();



###################
## Grants

# 'web'@'%'
GRANT SELECT, INSERT, UPDATE ON assessment.* TO 'web'@'%';
GRANT DELETE ON assessment.assessment_run TO 'web'@'%';
GRANT DELETE ON assessment.run_request TO 'web'@'%';
GRANT DELETE ON assessment.run_request_schedule TO 'web'@'%';
GRANT DELETE ON assessment.assessment_run_request TO 'web'@'%';
GRANT DELETE ON assessment.group_list TO 'web'@'%';
GRANT DELETE ON assessment.execution_record     TO 'web'@'%';
GRANT EXECUTE ON PROCEDURE assessment.launch_viewer TO 'web'@'%';
GRANT EXECUTE ON PROCEDURE assessment.kill_assessment_run TO 'web'@'%';
GRANT EXECUTE ON PROCEDURE assessment.select_system_setting TO 'web'@'%';
GRANT EXECUTE ON PROCEDURE assessment.download_results TO 'web'@'%';

# 'java_agent'@'%'
GRANT EXECUTE ON PROCEDURE assessment.select_execution_record TO 'java_agent'@'%';
GRANT EXECUTE ON PROCEDURE assessment.insert_results TO 'java_agent'@'%';
GRANT EXECUTE ON PROCEDURE assessment.update_execution_run_status TO 'java_agent'@'%';
GRANT EXECUTE ON PROCEDURE assessment.increment_launch_counter TO 'java_agent'@'%';
GRANT SELECT ON assessment.exec_run_view TO 'java_agent'@'%';
GRANT SELECT ON assessment.database_version TO 'java_agent'@'%';
GRANT SELECT, UPDATE ON assessment.execution_record TO 'java_agent'@'%';

# 'java_agent'@'localhost'
GRANT EXECUTE ON PROCEDURE assessment.select_execution_record TO 'java_agent'@'localhost';
GRANT EXECUTE ON PROCEDURE assessment.insert_results TO 'java_agent'@'localhost';
GRANT EXECUTE ON PROCEDURE assessment.update_execution_run_status TO 'java_agent'@'localhost';
GRANT EXECUTE ON PROCEDURE assessment.increment_launch_counter TO 'java_agent'@'localhost';
GRANT SELECT ON assessment.exec_run_view TO 'java_agent'@'localhost';
GRANT SELECT ON assessment.database_version TO 'java_agent'@'localhost';
GRANT SELECT, UPDATE ON assessment.execution_record TO 'java_agent'@'localhost';
