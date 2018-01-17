# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2018 Software Assurance Marketplace

# v1.18
use assessment;
drop PROCEDURE if exists upgrade_40;
DELIMITER $$
CREATE PROCEDURE upgrade_40 ()
  BEGIN
    declare script_version_no int;
    declare cur_db_version_no int;
    set script_version_no = 40;

    select max(database_version_no)
      into cur_db_version_no
      from assessment.database_version;

    if cur_db_version_no < script_version_no then
      begin

        # Foreign Key
        # project_uuid
        delete from assessment.assessment_run where project_uuid not in (select project_uid from project.project);
        ALTER TABLE assessment.assessment_run ADD CONSTRAINT fk_assessment_run_proj FOREIGN KEY (project_uuid) REFERENCES project.project (project_uid) ON DELETE CASCADE ON UPDATE CASCADE;
        # package_uuid
        delete from assessment.assessment_run where package_uuid not in (select package_uuid from package_store.package);
        ALTER TABLE assessment.assessment_run ADD CONSTRAINT fk_assessment_run_pkg FOREIGN KEY (package_uuid) REFERENCES package_store.package (package_uuid) ON DELETE CASCADE ON UPDATE CASCADE;
        # package_version_uuid
        delete from assessment.assessment_run where package_version_uuid is not null and package_version_uuid not in (select package_version_uuid from package_store.package_version);
        ALTER TABLE assessment.assessment_run ADD CONSTRAINT fk_assessment_run_pkg_ver FOREIGN KEY (package_version_uuid) REFERENCES package_store.package_version (package_version_uuid) ON DELETE CASCADE ON UPDATE CASCADE;

        # Remove unused fields
        ALTER TABLE viewer_store.viewer_instance DROP COLUMN reference_count;
        ALTER TABLE viewer_store.viewer_instance DROP COLUMN api_key;

        # update database version number
        insert into assessment.database_version (database_version_no, description) values (script_version_no, 'upgrade to v1.18');

        commit;
      end;
    end if;
END
$$
DELIMITER ;
