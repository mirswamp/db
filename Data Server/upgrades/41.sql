# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2019 Software Assurance Marketplace

# v1.19
use assessment;
drop PROCEDURE if exists upgrade_41;
DELIMITER $$
CREATE PROCEDURE upgrade_41 ()
  BEGIN
    declare script_version_no int;
    declare cur_db_version_no int;
    set script_version_no = 41;

    select max(database_version_no)
      into cur_db_version_no
      from assessment.database_version;

    if cur_db_version_no < script_version_no then
      begin

        # No v1.19 updates
        ALTER TABLE assessment.execution_record ADD COLUMN vm_ip_address VARCHAR(50) COMMENT 'vm ip address' AFTER vm_password;

        # Ruby Package Type
        insert into package_store.package_type (package_type_id, name) values (7, 'Ruby');

        # Add New Tool RuboCop 0.31 for Ruby: 1 tool with 1 version. Language = Ruby; Platform = Scientific Linux 64-bit
        insert into tool_shed.tool
          (tool_uuid, tool_owner_uuid, name, description, tool_sharing_status, is_build_needed) values
          ('ebcab7f6-0935-11e5-b6a7-001a4a81450b','80835e30-d527-11e2-8b8b-0800200c9a66','RuboCop','A Ruby static code analyzer, based on the community Ruby style guide. <a href="https://github.com/bbatsov/rubocop">https://github.com/bbatsov/rubocop</a>', 'PUBLIC',0);
        insert into tool_shed.tool_version
          (tool_version_uuid, tool_uuid, version_string, release_date, comment_public, comment_private,
          tool_path, tool_executable, tool_arguments, tool_directory, checksum)
        values
        ('f5c26a51-0935-11e5-b6a7-001a4a81450b','ebcab7f6-0935-11e5-b6a7-001a4a81450b','0.31', now(), 'RuboCop 0.31 for Ruby', NULL,
        '/swamp/store/SCATools/rubocop/rubocop-0.31.0.tar.gz', 'rubocop', '', 'rubocop-0.31.0',
        'ee27f42b8d1b09269089dbf5d9329701e4a215c5ea6a452971900b43dc74cf7438976e968df57a471200e320a4adc7ea2e756836dc1f174a174223121cffa845');
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('ebcab7f6-0935-11e5-b6a7-001a4a81450b', 'f5c26a51-0935-11e5-b6a7-001a4a81450b',7);
        insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values
          ('ebcab7f6-0935-11e5-b6a7-001a4a81450b', 'd95fcb5f-209d-11e3-9a3e-001a4a81450b'); # Scientific Linux 64-bit

        # Add New Tool ruby-lint 2.0.4 for Ruby: 1 tool with 1 version. Language = Ruby; Platform = Scientific Linux 64-bit
        insert into tool_shed.tool
          (tool_uuid, tool_owner_uuid, name, description, tool_sharing_status, is_build_needed)
           values
          ('59612f24-0946-11e5-b6a7-001a4a81450b','80835e30-d527-11e2-8b8b-0800200c9a66','ruby-lint','A linter and static code analysis tool for Ruby. <a href="https://rubygems.org/gems/ruby-lint">https://rubygems.org/gems/ruby-lint</a>', 'PUBLIC',0);
        insert into tool_shed.tool_version
          (tool_version_uuid, tool_uuid, version_string, release_date, comment_public, comment_private,
          tool_path, tool_executable, tool_arguments, tool_directory, checksum)
        values
        ('6b5624a0-0946-11e5-b6a7-001a4a81450b','59612f24-0946-11e5-b6a7-001a4a81450b','2.0.4', now(), 'ruby-lint 2.0.4 for Ruby', NULL,
        '/swamp/store/SCATools/ruby-lint/ruby-lint-2.0.4.tar.gz', 'ruby-lint', '', 'ruby-lint-2.0.4',
        'f2138e205bccca09e54baabea5f83dd230ea6e827f98bb7dd222605bad439de71d3375666c101ad7500c41f0734e876af936db46d7ab5849cebe1e484195d77c');
        insert into tool_shed.tool_language (tool_uuid, tool_version_uuid, package_type_id) values ('59612f24-0946-11e5-b6a7-001a4a81450b', '6b5624a0-0946-11e5-b6a7-001a4a81450b',7);
        insert into tool_shed.tool_platform (tool_uuid, platform_uuid) values
          ('59612f24-0946-11e5-b6a7-001a4a81450b', 'd95fcb5f-209d-11e3-9a3e-001a4a81450b'); # Scientific Linux 64-bit

        # Mark public package ddf as private
        update package_store.package set package_sharing_status = 'PRIVATE' where package_uuid = 'bd6ab38e-8a27-11e3-88bb-001a4a81450b';
        update package_store.package_version set version_sharing_status = 'PRIVATE' where package_uuid = 'bd6ab38e-8a27-11e3-88bb-001a4a81450b';

        # Assessment run status log table
        CREATE TABLE assessment.execution_run_status_log (
          execution_run_status_log_id  INT  NOT NULL AUTO_INCREMENT COMMENT 'internal id',
          execution_record_uuid        VARCHAR(45),
          status                       VARCHAR(25),
          run_start_time               DATETIME,
          run_end_time                 DATETIME,
          exec_node_architecture_id    VARCHAR(128),
          lines_of_code                INT,
          cpu_utilization              VARCHAR(32),
          vm_hostname                  VARCHAR(100),
          vm_username                  VARCHAR(50),
          vm_password                  VARCHAR(50),
          vm_ip_address                VARCHAR(50),
          create_date                  TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'date record inserted',
          PRIMARY KEY (execution_run_status_log_id),
            CONSTRAINT fk_execution_run_status_log FOREIGN KEY (execution_record_uuid) REFERENCES execution_record (execution_record_uuid) ON DELETE SET NULL ON UPDATE CASCADE
         );

        # update database version number
        insert into assessment.database_version (database_version_no, description) values (script_version_no, 'upgrade to v1.19');

        commit;
      end;
    end if;
END
$$
DELIMITER ;
