# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2020 Software Assurance Marketplace

use viewer_store;

# Native Viewer
insert into viewer (viewer_uuid, viewer_owner_uuid, name, viewer_sharing_status)
  values ('b7289170-5c46-11e3-9fa4-001a4a81450b', '80835e30-d527-11e2-8b8b-0800200c9a66', 'Native', 'PUBLIC');
insert into viewer_version (viewer_version_uuid, viewer_uuid,
                    version_string,
                    invocation_cmd, sign_in_cmd, add_user_cmd, add_result_cmd,
                    viewer_path, viewer_checksum,
                    viewer_db_path, viewer_db_checksum)
            values ('8f9213ef-5d04-11e3-9fa4-001a4a81450b', 'b7289170-5c46-11e3-9fa4-001a4a81450b',
                    '1',
                    'invocation_cmd', 'sign_in_cmd', 'add_user_cmd', 'add_result_cmd',
                    'viewer_path', 'viewer_checksum',
                    'viewer_db_path', 'viewer_db_checksum');

# Code DX
insert into viewer (viewer_uuid, viewer_owner_uuid, name, viewer_sharing_status)
  values ('4221533e-865a-11e3-88bb-001a4a81450b', '80835e30-d527-11e2-8b8b-0800200c9a66', 'CodeDX', 'PUBLIC');
insert into viewer_version (viewer_version_uuid, viewer_uuid,
                    version_string,
                    invocation_cmd, sign_in_cmd, add_user_cmd, add_result_cmd,
                    viewer_path, viewer_checksum,
                    viewer_db_path, viewer_db_checksum)
            values ('5d0fb63c-865a-11e3-88bb-001a4a81450b', '4221533e-865a-11e3-88bb-001a4a81450b',
                    '1',
                    'invocation_cmd', 'sign_in_cmd', 'add_user_cmd', 'add_result_cmd',
                    'viewer_path', 'viewer_checksum',
                    'viewer_db_path', 'viewer_db_checksum');
