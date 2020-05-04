# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2020 Software Assurance Marketplace

use viewer_store;

####################
## Views


###################
## Triggers

DROP TRIGGER IF EXISTS viewer_BINS;
DROP TRIGGER IF EXISTS viewer_BUPD;
DROP TRIGGER IF EXISTS viewer_version_BINS;
DROP TRIGGER IF EXISTS viewer_version_BUPD;
DROP TRIGGER IF EXISTS project_default_viewer_BINS;
DROP TRIGGER IF EXISTS project_default_viewer_BUPD;
DROP TRIGGER IF EXISTS viewer_instance_BINS;
DROP TRIGGER IF EXISTS viewer_instance_BUPD;
DROP TRIGGER IF EXISTS viewer_sharing_BINS;
DROP TRIGGER IF EXISTS viewer_sharing_BUPD;
DROP TRIGGER IF EXISTS viewer_launch_history_BINS;
DROP TRIGGER IF EXISTS viewer_launch_history_BUPD;
DROP TRIGGER IF EXISTS viewer_launch_time_history_BINS;
DROP TRIGGER IF EXISTS viewer_launch_time_history_BUPD;

DELIMITER $$

CREATE TRIGGER viewer_BINS BEFORE INSERT ON viewer FOR EACH ROW SET NEW.create_user = user(), NEW.create_date = now();
$$
#CREATE TRIGGER viewer_BUPD BEFORE UPDATE ON viewer FOR EACH ROW SET NEW.update_user = user(), NEW.update_date = now();
#$$
#CREATE TRIGGER viewer_version_BINS BEFORE INSERT ON viewer_version FOR EACH ROW SET NEW.create_user = user(), NEW.create_date = now();
#$$
CREATE TRIGGER viewer_version_BUPD BEFORE UPDATE ON viewer_version FOR EACH ROW SET NEW.update_user = user(), NEW.update_date = now();
$$
CREATE TRIGGER project_default_viewer_BINS BEFORE INSERT ON project_default_viewer FOR EACH ROW SET NEW.create_user = user(), NEW.create_date = now();
$$
CREATE TRIGGER project_default_viewer_BUPD BEFORE UPDATE ON project_default_viewer FOR EACH ROW SET NEW.update_user = user(), NEW.update_date = now();
$$
CREATE TRIGGER viewer_instance_BINS BEFORE INSERT ON viewer_instance FOR EACH ROW SET NEW.create_user = user(), NEW.create_date = now();
$$
CREATE TRIGGER viewer_instance_BUPD BEFORE UPDATE ON viewer_instance FOR EACH ROW SET NEW.update_user = user(), NEW.update_date = now();
$$
CREATE TRIGGER viewer_sharing_BINS BEFORE INSERT ON viewer_sharing FOR EACH ROW SET NEW.create_user = user(), NEW.create_date = now();
$$
CREATE TRIGGER viewer_sharing_BUPD BEFORE UPDATE ON viewer_sharing FOR EACH ROW SET NEW.update_user = user(), NEW.update_date = now();
$$
CREATE TRIGGER viewer_launch_history_BINS BEFORE INSERT ON viewer_launch_history FOR EACH ROW SET NEW.create_user = user(), NEW.create_date = now();
$$
CREATE TRIGGER viewer_launch_history_BUPD BEFORE UPDATE ON viewer_launch_history FOR EACH ROW SET NEW.update_user = user(), NEW.update_date = now();
$$
CREATE TRIGGER viewer_launch_time_history_BINS BEFORE INSERT ON viewer_launch_time_history FOR EACH ROW SET NEW.create_user = user(), NEW.create_date = now();
$$
CREATE TRIGGER viewer_launch_time_history_BUPD BEFORE UPDATE ON viewer_launch_time_history FOR EACH ROW SET NEW.update_user = user(), NEW.update_date = now();
$$


# view owner history trigger
CREATE TRIGGER viewer_BUPD BEFORE UPDATE ON viewer FOR EACH ROW
  BEGIN
    SET NEW.update_user = user(),
        NEW.update_date = now();
    IF IFNULL(NEW.viewer_owner_uuid,'') != IFNULL(OLD.viewer_owner_uuid,'')
      THEN
        insert into viewer_owner_history (viewer_uuid, old_viewer_owner_uuid, new_viewer_owner_uuid)
        values (NEW.viewer_uuid, OLD.viewer_owner_uuid, NEW.viewer_owner_uuid);
    END IF;
  END;
$$

# version number auto-populate
CREATE TRIGGER viewer_version_BINS BEFORE INSERT ON viewer_version FOR EACH ROW
  begin
    declare max_version_no INT;
    select max(version_no) into max_version_no
      from viewer_version where viewer_uuid = NEW.viewer_uuid;
    set NEW.create_user = user(),
        NEW.create_date = now(),
        NEW.version_no = ifnull(max_version_no,0)+1;
  end;
$$

# Verbose Logging: record changes to viewer_instance in viewer_launch_time_history
# CREATE TRIGGER viewer_instance_BUPD BEFORE UPDATE ON viewer_instance FOR EACH ROW
#   BEGIN
#     SET NEW.update_user = user(),
#         NEW.update_date = now();
#     IF IFNULL(NEW.status,'') != IFNULL(OLD.status,'')
#       THEN
#         insert into viewer_launch_time_history (viewer_instance_uuid, event, description)
#         values (NEW.viewer_instance_uuid, 'Status Change',
#           concat('From: ', IFNULL(OLD.status,'NULL'), ' To: ',IFNULL(NEW.status,'NULL'))
#   );
#     END IF;
#     IF IFNULL(NEW.status_code,'') != IFNULL(OLD.status_code,'')
#       THEN
#         insert into viewer_launch_time_history (viewer_instance_uuid, event, description)
#         values (NEW.viewer_instance_uuid, 'Status Code Change',
#     concat('From: ', IFNULL(OLD.status_code,'NULL'), ' To: ',IFNULL(NEW.status_code,'NULL'))
#   );
#     END IF;
#     IF IFNULL(NEW.vm_ip_address,'') != IFNULL(OLD.vm_ip_address,'')
#       THEN
#         insert into viewer_launch_time_history (viewer_instance_uuid, event, description)
#         values (NEW.viewer_instance_uuid, 'VM IP Address Change',
#     concat('From: ', IFNULL(OLD.vm_ip_address,'NULL'), ' To: ',IFNULL(NEW.vm_ip_address,'NULL'))
#   );
#     END IF;
#     IF IFNULL(NEW.proxy_url,'') != IFNULL(OLD.proxy_url,'')
#       THEN
#         insert into viewer_launch_time_history (viewer_instance_uuid, event, description)
#         values (NEW.viewer_instance_uuid, 'Proxy URL Change',
#     concat('From: ', IFNULL(OLD.proxy_url,'NULL'), ' To: ',IFNULL(NEW.proxy_url,'NULL'))
#   );
#     END IF;
#     IF (IFNULL(NEW.viewer_db_path,'') != IFNULL(OLD.viewer_db_path,'') or IFNULL(NEW.viewer_db_checksum,'') != IFNULL(OLD.viewer_db_checksum,''))
#       THEN
#         insert into viewer_launch_time_history (viewer_instance_uuid, event, description)
#         values (NEW.viewer_instance_uuid, 'DB Path or Cksum Change', null);
#     END IF;
#   END;
# $$

DELIMITER ;

####################################################
## Stored Procedures

drop PROCEDURE if exists store_viewer;
DELIMITER $$
###############################
CREATE PROCEDURE store_viewer (
    IN viewer_instance_uuid_in VARCHAR(45),
    IN viewer_db_path_in VARCHAR(200),
    IN viewer_db_checksum_in VARCHAR(200),
    IN platform_image_in VARCHAR(100),
    IN code_dx_version_in VARCHAR(100),
    OUT return_string varchar(100)
  )
  BEGIN
    DECLARE row_count_int int;

    # verify exists 1 matching viewer_instance
    select count(1)
      into row_count_int
      from viewer_store.viewer_instance
     where viewer_instance_uuid = viewer_instance_uuid_in;

    if row_count_int = 1 then
      update viewer_instance
         set viewer_db_path = viewer_db_path_in,
             viewer_db_checksum = viewer_db_checksum_in,
             platform_image = platform_image_in,
             code_dx_version = code_dx_version_in
        where viewer_instance_uuid = viewer_instance_uuid_in;
        set return_string = 'SUCCESS';
    else
      set return_string = 'ERROR: Viewer Instance Not Found';
    end if;

END
$$
DELIMITER ;

drop PROCEDURE if exists update_viewer_instance;
DELIMITER $$
###############################
CREATE PROCEDURE update_viewer_instance (
    IN viewer_instance_uuid_in VARCHAR(45),
    IN status_in VARCHAR(100),
    IN status_code_in INT,
    IN vm_ip_address_in VARCHAR(50),
    IN proxy_url_in VARCHAR(100),
    OUT return_string varchar(100)
  )
  BEGIN
    DECLARE row_count_int int;

    # verify exists 1 matching viewer_instance
    select count(1)
      into row_count_int
      from viewer_store.viewer_instance
     where viewer_instance_uuid = viewer_instance_uuid_in;

    if row_count_int = 1 then
      BEGIN
        update viewer_store.viewer_instance
           set status = status_in,
               status_code = status_code_in,
               vm_ip_address = vm_ip_address_in,
               proxy_url = proxy_url_in
         where viewer_instance_uuid = viewer_instance_uuid_in;

        set return_string = 'SUCCESS';
      END;
    else
      set return_string = 'ERROR: Record Not Found';
    end if;

END
$$
DELIMITER ;

###################
## Grants

# 'web'@'%'
GRANT SELECT, INSERT, UPDATE ON viewer_store.* TO 'web'@'%';

# 'java_agent'@'%'
GRANT EXECUTE ON PROCEDURE viewer_store.store_viewer TO 'java_agent'@'%';
GRANT EXECUTE ON PROCEDURE viewer_store.update_viewer_instance TO 'java_agent'@'%';

# 'java_agent'@'localhost'
GRANT EXECUTE ON PROCEDURE viewer_store.store_viewer TO 'java_agent'@'localhost';
GRANT EXECUTE ON PROCEDURE viewer_store.update_viewer_instance TO 'java_agent'@'localhost';
