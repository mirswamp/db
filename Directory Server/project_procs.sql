# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2019 Software Assurance Marketplace

use project;

####################
## Views
CREATE OR REPLACE VIEW project_events as
  select full_name, short_name,
         'created' as event_type,
         create_date as event_date,
         project_uid
    from project
   where trial_project_flag = 0
  union
  select full_name, short_name,
         'revoked' as event_type,
         denial_date as event_date,
         project_uid
    from project
   where denial_date is not null and trial_project_flag = 0
  union
  select full_name, short_name,
         'deleted' as event_type,
         deactivation_date as event_date,
         project_uid
    from project
   where deactivation_date is not null and trial_project_flag = 0;

CREATE OR REPLACE VIEW personal_events as
  select user_uid, 'registered' as event_type,
         create_date as event_date
    from user_account
  union
  select user_uid, 'last_login' as event_type,
         penultimate_login_date as event_date
    from user_account where penultimate_login_date is not null
  union
  select user_uid, 'last_profile_update' as event_type,
         ldap_profile_update_date as event_date
    from user_account where ldap_profile_update_date is not null;

drop VIEW if exists project_invitation_events;

CREATE OR REPLACE VIEW user_project_events as
  select pu.user_uid, pu.create_date as event_date, 'Join' as event_type, p.project_uid
    from project.project_user pu inner join project.project p on p.project_uid = pu.project_uid
    where p.trial_project_flag = 0
  union
  select pu.user_uid, pu.delete_date as event_date, 'Leave' as event_type, p.project_uid
    from project.project_user pu inner join project.project p on p.project_uid = pu.project_uid
   where pu.delete_date is not null or pu.expire_date < now() and p.trial_project_flag = 0;

###################
## Triggers
DROP TRIGGER IF EXISTS project_BUPD;
#DROP TRIGGER IF EXISTS project_BINS;
DROP TRIGGER IF EXISTS database_version_BINS;
DROP TRIGGER IF EXISTS database_version_BUPD;
DROP TRIGGER IF EXISTS user_account_BINS;
DROP TRIGGER IF EXISTS user_account_BUPD;
DROP TRIGGER IF EXISTS user_event_BINS;
DROP TRIGGER IF EXISTS user_event_BUPD;
DROP TRIGGER IF EXISTS permission_BINS;
DROP TRIGGER IF EXISTS permission_BUPD;
DROP TRIGGER IF EXISTS user_permission_BINS;
DROP TRIGGER IF EXISTS user_permission_BUPD;
DROP TRIGGER IF EXISTS user_permission_BDEL;
DROP TRIGGER IF EXISTS user_permission_project_BINS;
DROP TRIGGER IF EXISTS user_permission_project_BUPD;
DROP TRIGGER IF EXISTS user_permission_package_BINS;
DROP TRIGGER IF EXISTS user_permission_package_BUPD;
DROP TRIGGER IF EXISTS policy_BINS;
DROP TRIGGER IF EXISTS policy_BUPD;
DROP TRIGGER IF EXISTS user_policy_BINS;
DROP TRIGGER IF EXISTS user_policy_BUPD;
DROP TRIGGER IF EXISTS promo_code_BINS;
DROP TRIGGER IF EXISTS promo_code_BUPD;
DROP TRIGGER IF EXISTS linked_account_provider_BINS;
DROP TRIGGER IF EXISTS linked_account_provider_BUPD;
DROP TRIGGER IF EXISTS linked_account_BINS;
DROP TRIGGER IF EXISTS linked_account_BUPD;
DROP TRIGGER IF EXISTS app_passwords_BUPD;
DROP TRIGGER IF EXISTS class_BINS;
DROP TRIGGER IF EXISTS class_BUPD;
DROP TRIGGER IF EXISTS class_user_BINS;
DROP TRIGGER IF EXISTS class_user_BUPD;
DROP TRIGGER IF EXISTS class_user_BDEL;


DELIMITER $$

CREATE TRIGGER project_BUPD BEFORE UPDATE ON project FOR EACH ROW
  BEGIN
    IF NEW.project_owner_uid != OLD.project_owner_uid
      THEN
        insert into project_owner_history (project_id, old_project_owner_uid, new_project_owner_uid)
        values (NEW.project_id, OLD.project_owner_uid, NEW.project_owner_uid);
    END IF;
  END;
$$

CREATE TRIGGER user_account_BINS BEFORE INSERT ON user_account FOR EACH ROW
  BEGIN
    DECLARE new_project_uuid_var VARCHAR(45);
    set new_project_uuid_var = uuid();
    SET NEW.create_user = user(), NEW.create_date = now();
    insert into project.project (project_uid, project_owner_uid, full_name, short_name, description, affiliation, trial_project_flag)
      values (new_project_uuid_var, NEW.user_uid, 'MyProject', 'MyProject', 'Starter project for running assessments.', null, 1);
    insert into project.project_user (project_uid, user_uid, membership_uid, admin_flag)
      values (new_project_uuid_var, NEW.user_uid, uuid(), 1);
  END;
$$

CREATE TRIGGER user_account_BUPD BEFORE UPDATE ON user_account FOR EACH ROW
  BEGIN
    SET NEW.update_user = user(), NEW.update_date = now();
    IF NEW.forcepwreset_flag != OLD.forcepwreset_flag
      THEN
        insert into user_forcepwreset_history (user_uid, old_forcepwreset_flag, new_forcepwreset_flag)
        values (NEW.user_uid, OLD.forcepwreset_flag, NEW.forcepwreset_flag);
    END IF;
  END;
$$

CREATE TRIGGER user_permission_BINS BEFORE INSERT ON user_permission FOR EACH ROW
  BEGIN
    DECLARE auto_approve_flag_var tinyint(1);
    SET NEW.create_user = user(), NEW.create_date = now(), NEW.request_date = now();
    # check auto_approve_flag
    select auto_approve_flag into auto_approve_flag_var from permission where permission_code = NEW.permission_code;
    if auto_approve_flag_var = 1 then
      SET NEW.grant_date = now(), NEW.admin_comment = 'auto-approved';
    end if;
  END;
$$

CREATE TRIGGER user_permission_BUPD BEFORE UPDATE ON user_permission FOR EACH ROW
  BEGIN
    SET NEW.update_user = user(), NEW.update_date = now();
    insert into user_permission_history (user_permission_uid, permission_code, user_uid, user_comment,
      admin_comment, meta_information, request_date, grant_date, denial_date, expiration_date, delete_date)
      values (OLD.user_permission_uid, OLD.permission_code, OLD.user_uid, OLD.user_comment,
      OLD.admin_comment, OLD.meta_information, OLD.request_date, OLD.grant_date, OLD.denial_date, OLD.expiration_date, OLD.delete_date);
  END;
$$

CREATE TRIGGER user_permission_BDEL BEFORE DELETE ON user_permission FOR EACH ROW
  BEGIN
    insert into user_permission_history (user_permission_uid, permission_code, user_uid, user_comment,
      admin_comment, meta_information, request_date, grant_date, denial_date, expiration_date, delete_date)
      values (OLD.user_permission_uid, OLD.permission_code, OLD.user_uid, OLD.user_comment,
      OLD.admin_comment, OLD.meta_information, OLD.request_date, OLD.grant_date, OLD.denial_date, OLD.expiration_date, OLD.delete_date);
  END;
$$

CREATE TRIGGER class_user_BINS BEFORE INSERT ON class_user FOR EACH ROW
  BEGIN
    #DECLARE commercial_tool_access_var tinyint(1);
    #DECLARE end_date_var DATETIME;
    SET NEW.create_user = user(), NEW.create_date = now();
    # check commercial_tool_access and class end_date
    #select commercial_tool_access, end_date
    #  into commercial_tool_access_var, end_date_var
    #  from project.class where class_code = NEW.class_code;
    #if commercial_tool_access_var = 1 then
    if NEW.class_code = 'PSU447SW' then
      delete from project.user_permission
       where permission_code = 'codesonar-user'
         and user_uid = NEW.user_uid;
      delete from project.user_policy
       where policy_code = 'codesonar-user-policy'
         and user_uid = NEW.user_uid;
      insert into project.user_permission (
           user_permission_uid,
           permission_code,
           user_uid,
           user_comment,
           admin_comment,
           meta_information,
           request_date,
           grant_date,
           expiration_date)
         values (
           uuid(), #user_permission_uid,
           'codesonar-user', #permission_code,
           NEW.user_uid, #user_uid,
           'Student in Penn State (PSU), CMPSC 447 Software Security, Dr. Gang (Gary) Tan', #user_comment,
           'auto-approved for class enrollment', #admin_comment,
           '{"user_type":"educational","name":"Gang Tan","email":"gangtan@gmail.com","organization":"Penn State University","project_url":"http://www.cse.psu.edu/~gxt29/teaching/cs447s19/index.html"}', #meta_information,
           now(), #request_date,
           now(), #grant_date,
           #end_date_var #expiration_date
           STR_TO_DATE('10,05,2019 06:00','%d,%m,%Y %H:%i')  #expiration_date
           );
      insert into project.user_policy (
          user_policy_uid,
          user_uid,
          policy_code,
          accept_flag)
        values (
          uuid(), #user_policy_uid,
          NEW.user_uid, #user_uid,
          'codesonar-user-policy', #policy_code,
          1 #accept_flag
          );
    end if;

    if NEW.class_code = 'UWCS639SW' then
      delete from project.user_permission
       where permission_code = 'parasoft-user-j-test'
         and user_uid = NEW.user_uid;
      delete from project.user_policy
       where policy_code = 'parasoft-user-j-test-policy'
         and user_uid = NEW.user_uid;
      insert into project.user_permission (
           user_permission_uid,
           permission_code,
           user_uid,
           user_comment,
           admin_comment,
           meta_information,
           request_date,
           grant_date,
           expiration_date)
         values (
           uuid(), #user_permission_uid,
           'parasoft-user-j-test', #permission_code,
           NEW.user_uid, #user_uid,
           'Student in UW CS 639 Introduction to Software Security, Professors Bart Miller and Elisa Heymann', #user_comment,
           'auto-approved for class enrollment', #admin_comment,
           '{"user_type":"educational","name":"Bart Miller","email":"bart@cs.wisc.edu","organization":"University of Wisconsin","project_url":"http://pages.cs.wisc.edu/~bart/cs639.html"}', #meta_information,
           now(), #request_date,
           now(), #grant_date,
           #end_date_var #expiration_date
           STR_TO_DATE('24,05,2019 05:00','%d,%m,%Y %H:%i')  #expiration_date
           );
      insert into project.user_policy (
          user_policy_uid,
          user_uid,
          policy_code,
          accept_flag)
        values (
          uuid(), #user_policy_uid,
          NEW.user_uid, #user_uid,
          'parasoft-user-j-test-policy', #policy_code,
          1 #accept_flag
          );
    end if;

    if NEW.class_code = 'UQ2019' then
      delete from project.user_permission
       where permission_code = 'parasoft-user-j-test'
         and user_uid = NEW.user_uid;
      delete from project.user_policy
       where policy_code = 'parasoft-user-j-test-policy'
         and user_uid = NEW.user_uid;
      insert into project.user_permission (
           user_permission_uid,
           permission_code,
           user_uid,
           user_comment,
           admin_comment,
           meta_information,
           request_date,
           grant_date,
           expiration_date)
         values (
           uuid(), #user_permission_uid,
           'parasoft-user-j-test', #permission_code,
           NEW.user_uid, #user_uid,
           'Student in University of Queensland, Professors Bart Miller and Elisa Heymann', #user_comment,
           'auto-approved for class enrollment', #admin_comment,
           '{"user_type":"educational","name":"Bart Miller","email":"bart@cs.wisc.edu","organization":"University of Wisconsin","project_url":"http://pages.cs.wisc.edu/~bart/cs639.html"}', #meta_information,
           now(), #request_date,
           now(), #grant_date,
           #end_date_var #expiration_date
           STR_TO_DATE('30,05,2019 14:00','%d,%m,%Y %H:%i')  #expiration_date
           );
      insert into project.user_policy (
          user_policy_uid,
          user_uid,
          policy_code,
          accept_flag)
        values (
          uuid(), #user_policy_uid,
          NEW.user_uid, #user_uid,
          'parasoft-user-j-test-policy', #policy_code,
          1 #accept_flag
          );
    end if;

  END;
$$

CREATE TRIGGER class_user_BDEL BEFORE DELETE ON class_user FOR EACH ROW
  BEGIN
    if OLD.class_code = 'PSU447SW' then
      update project.user_permission
         set delete_date = now()
       where permission_code = 'codesonar-user'
         and user_uid = OLD.user_uid;
      delete from project.user_policy
       where policy_code = 'codesonar-user-policy'
         and user_uid = OLD.user_uid;
    end if;
    if OLD.class_code = 'UWCS639SW' then
      update project.user_permission
         set delete_date = now()
       where permission_code = 'parasoft-user-j-test'
         and user_uid = OLD.user_uid;
      delete from project.user_policy
       where policy_code = 'parasoft-user-j-test-policy'
         and user_uid = OLD.user_uid;
    end if;
    if OLD.class_code = 'UQ2019' then
      update project.user_permission
         set delete_date = now()
       where permission_code = 'parasoft-user-j-test'
         and user_uid = OLD.user_uid;
      delete from project.user_policy
       where policy_code = 'parasoft-user-j-test-policy'
         and user_uid = OLD.user_uid;
    end if;
  END;
$$

#CREATE TRIGGER project_BINS BEFORE INSERT ON project FOR EACH ROW SET NEW.accept_date = now();
#$$
CREATE TRIGGER database_version_BINS BEFORE INSERT ON database_version FOR EACH ROW SET NEW.create_user = user(), NEW.create_date = now();
$$
CREATE TRIGGER database_version_BUPD BEFORE UPDATE ON database_version FOR EACH ROW SET NEW.update_user = user(), NEW.update_date = now();
$$
#CREATE TRIGGER user_account_BINS BEFORE INSERT ON user_account FOR EACH ROW SET NEW.create_user = user(), NEW.create_date = now();
#$$
#CREATE TRIGGER user_account_BUPD BEFORE UPDATE ON user_account FOR EACH ROW SET NEW.update_user = user(), NEW.update_date = now();
#$$
CREATE TRIGGER user_event_BINS BEFORE INSERT ON user_event FOR EACH ROW SET NEW.create_user = user(), NEW.create_date = now();
$$
CREATE TRIGGER user_event_BUPD BEFORE UPDATE ON user_event FOR EACH ROW SET NEW.update_user = user(), NEW.update_date = now();
$$
CREATE TRIGGER permission_BINS BEFORE INSERT ON permission FOR EACH ROW SET NEW.create_user = user(), NEW.create_date = now();
$$
CREATE TRIGGER permission_BUPD BEFORE UPDATE ON permission FOR EACH ROW SET NEW.update_user = user(), NEW.update_date = now();
$$
#CREATE TRIGGER user_permission_BINS BEFORE INSERT ON user_permission FOR EACH ROW SET NEW.create_user = user(), NEW.create_date = now(), NEW.request_date = now();
#$$
#CREATE TRIGGER user_permission_BUPD BEFORE UPDATE ON user_permission FOR EACH ROW SET NEW.update_user = user(), NEW.update_date = now();
#$$
CREATE TRIGGER user_permission_project_BINS BEFORE INSERT ON user_permission_project FOR EACH ROW SET NEW.create_user = user(), NEW.create_date = now();
$$
CREATE TRIGGER user_permission_project_BUPD BEFORE UPDATE ON user_permission_project FOR EACH ROW SET NEW.update_user = user(), NEW.update_date = now();
$$
CREATE TRIGGER user_permission_package_BINS BEFORE INSERT ON user_permission_package FOR EACH ROW SET NEW.create_user = user(), NEW.create_date = now();
$$
CREATE TRIGGER user_permission_package_BUPD BEFORE UPDATE ON user_permission_package FOR EACH ROW SET NEW.update_user = user(), NEW.update_date = now();
$$
CREATE TRIGGER policy_BINS BEFORE INSERT ON policy FOR EACH ROW SET NEW.create_user = user(), NEW.create_date = now();
$$
CREATE TRIGGER policy_BUPD BEFORE UPDATE ON policy FOR EACH ROW SET NEW.update_user = user(), NEW.update_date = now();
$$
CREATE TRIGGER user_policy_BINS BEFORE INSERT ON user_policy FOR EACH ROW SET NEW.create_user = user(), NEW.create_date = now();
$$
CREATE TRIGGER user_policy_BUPD BEFORE UPDATE ON user_policy FOR EACH ROW SET NEW.update_user = user(), NEW.update_date = now();
$$
CREATE TRIGGER promo_code_BINS BEFORE INSERT ON promo_code FOR EACH ROW SET NEW.create_user = user(), NEW.create_date = now();
$$
CREATE TRIGGER promo_code_BUPD BEFORE UPDATE ON promo_code FOR EACH ROW SET NEW.update_user = user(), NEW.update_date = now();
$$
CREATE TRIGGER linked_account_provider_BINS BEFORE INSERT ON linked_account_provider FOR EACH ROW SET NEW.create_user = user(), NEW.create_date = now();
$$
CREATE TRIGGER linked_account_provider_BUPD BEFORE UPDATE ON linked_account_provider FOR EACH ROW SET NEW.update_user = user(), NEW.update_date = now();
$$
CREATE TRIGGER linked_account_BINS BEFORE INSERT ON linked_account FOR EACH ROW SET NEW.create_user = user(), NEW.create_date = now();
$$
CREATE TRIGGER linked_account_BUPD BEFORE UPDATE ON linked_account FOR EACH ROW SET NEW.update_user = user(), NEW.update_date = now();
$$
CREATE TRIGGER app_passwords_BUPD BEFORE UPDATE ON app_passwords FOR EACH ROW SET NEW.update_date = now();
$$
CREATE TRIGGER class_BINS BEFORE INSERT ON class FOR EACH ROW SET NEW.create_user = user(), NEW.create_date = now();
$$
CREATE TRIGGER class_BUPD BEFORE UPDATE ON class FOR EACH ROW SET NEW.update_user = user(), NEW.update_date = now();
$$
#CREATE TRIGGER class_user_BINS BEFORE INSERT ON class_user FOR EACH ROW SET NEW.create_user = user(), NEW.create_date = now();
#$$
CREATE TRIGGER class_user_BUPD BEFORE UPDATE ON class_user FOR EACH ROW SET NEW.update_user = user(), NEW.update_date = now();
$$

DELIMITER ;

####################################################
## Stored Procedures

####################################################
drop PROCEDURE if exists list_projects_by_member;
DELIMITER $$
CREATE PROCEDURE list_projects_by_member (
    IN user_uuid_in VARCHAR(45),
    OUT return_string varchar(100)
)
  BEGIN
    /*------------------------------------------
      Lists all projects of which the specifed user is a member (or owner.)
       - User must be enabled_flag in the user_account table.
       - User must be a current member of the project(s) listed in the project_user table.
           Note that this includes project owners.
       - Only lists active projects: not revoked or deactivated ones.
    /*------------------------------------------*/
    DECLARE user_account_valid_flag CHAR(1);

    # check user is valid in user_account table
    select distinct 'Y'
      into user_account_valid_flag
      from project.user_account
     where user_uid = user_uuid_in
       and enabled_flag = 1;

    if user_account_valid_flag = 'Y'
    then
      begin
        select p.project_uid,
               p.project_owner_uid,
               p.full_name,
               p.short_name,
               p.description,
               p.affiliation,
               p.create_date,
               p.denial_date,
               p.deactivation_date,
               pu.admin_flag
          from project p
         inner join project_user pu on p.project_uid = pu.project_uid
         where p.project_uid = pu.project_uid
           and pu.user_uid = user_uuid_in
           and pu.delete_date is null #user membership is active
           and (pu.expire_date > now() or pu.expire_date is null) #user membership is active
           and p.denial_date is null # project isn't revoked
           and p.deactivation_date is null; #project is active

        set return_string = 'SUCCESS';
      end;
    elseif ifnull(user_account_valid_flag,'N') != 'Y' THEN set return_string = 'ERROR: USER ACCOUNT NOT VALID';
    else set return_string = 'ERROR: UNSPECIFIED ERROR';
    end if;
END
$$
DELIMITER ;

drop PROCEDURE if exists list_projects_by_owner;
DELIMITER $$
CREATE PROCEDURE list_projects_by_owner (
    IN user_uuid_in VARCHAR(45),
    OUT return_string varchar(100)
)
  BEGIN
    /*------------------------------------------
      Lists all projects of which the specifed user is the owner.
       - User must be enabled_flag in the user_account table.
       - User must be the current owner of the project(s) listed in the project table.
       - Only lists active projects: not revoked or deactivated ones.
    /*------------------------------------------*/
    DECLARE user_account_valid_flag CHAR(1);

    # check user is valid in user_account table
    select distinct 'Y'
      into user_account_valid_flag
      from project.user_account
     where user_uid = user_uuid_in
       and enabled_flag = 1;

    if user_account_valid_flag = 'Y'
    then
      begin
        select p.project_uid,
               p.project_owner_uid,
               p.full_name,
               p.short_name,
               p.description,
               p.affiliation,
               p.create_date,
               p.denial_date,
               p.deactivation_date
          from project p
         where p.project_owner_uid = user_uuid_in
           and p.denial_date is null # project isn't revoked
           and p.deactivation_date is null; #project is active

        set return_string = 'SUCCESS';
      end;
    elseif ifnull(user_account_valid_flag,'N') != 'Y' THEN set return_string = 'ERROR: USER ACCOUNT NOT VALID';
    else set return_string = 'ERROR: UNSPECIFIED ERROR';
    end if;
END
$$
DELIMITER ;
drop PROCEDURE if exists deactivate_test_projects;

drop PROCEDURE if exists remove_user_from_all_projects;
DELIMITER $$
CREATE PROCEDURE remove_user_from_all_projects (
    IN user_uuid_in VARCHAR(45),
    OUT return_string varchar(100)
)
  BEGIN
    update project.project_user
       set delete_date = now()
     where user_uid = user_uuid_in
       and delete_date is null;
    set return_string = 'SUCCESS';
END
$$
DELIMITER ;

###################
## Grants

# 'web'@'%'
GRANT SELECT, INSERT, UPDATE ON project.* TO 'web'@'%';
GRANT DELETE ON project.admin_invitation   TO 'web'@'%';
GRANT DELETE ON project.restricted_domains TO 'web'@'%';
GRANT DELETE ON project.app_passwords      TO 'web'@'%';
GRANT DELETE ON project.email_verification TO 'web'@'%';
GRANT DELETE ON project.linked_account     TO 'web'@'%';
GRANT DELETE ON project.password_reset     TO 'web'@'%';
GRANT DELETE ON project.class_user         TO 'web'@'%';
GRANT DELETE ON project.project_invitation TO 'web'@'%';
GRANT DELETE ON project.project_user       TO 'web'@'%';
GRANT DELETE ON project.sessions           TO 'web'@'%';
GRANT EXECUTE ON PROCEDURE project.list_projects_by_member TO 'web'@'%';
GRANT EXECUTE ON PROCEDURE project.remove_user_from_all_projects TO 'web'@'%';


# 'replication_user'@'%'
GRANT REPLICATION SLAVE ON *.* TO replication_user;
