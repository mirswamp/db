# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2020 Software Assurance Marketplace

# Remove ssh access
delete from project.permission where permission_code = 'ssh-access';

# Remove Code Dx
delete from viewer_store.viewer_version where viewer_uuid = '4221533e-865a-11e3-88bb-001a4a81450b';
delete from viewer_store.viewer where viewer_uuid = '4221533e-865a-11e3-88bb-001a4a81450b';

# Remove ThreadFix
delete from viewer_store.viewer_version where viewer_uuid = 'a0e1d0fb-bfb2-11e5-bf72-001a4a814413';
delete from viewer_store.viewer where viewer_uuid = 'a0e1d0fb-bfb2-11e5-bf72-001a4a814413';

# Remove Android Lint
delete from tool_shed.tool_version where tool_uuid = '9289b560-8f8b-11e4-829b-001a4a81450b';
delete from tool_shed.tool where tool_uuid = '9289b560-8f8b-11e4-829b-001a4a81450b';

# Remove RevealDroid
delete from tool_shed.tool_version where tool_uuid = '738b81f0-a828-11e5-865f-001a4a81450b';
delete from tool_shed.tool where tool_uuid = '738b81f0-a828-11e5-865f-001a4a81450b';

# Remove Extra Permissions & Policies
delete from project.permission where permission_code = 'ssh-access';
delete from project.permission where permission_code = 'codesonar-user';
delete from project.permission where permission_code = 'parasoft-user-c-test';
delete from project.permission where permission_code = 'parasoft-user-j-test';
delete from project.permission where permission_code = 'coverity-user';
delete from project.permission where permission_code = 'sonatype-user';
delete from project.policy where policy_code = 'codesonar-user-policy';
delete from project.policy where policy_code = 'parasoft-user-c-test-policy';
delete from project.policy where policy_code = 'parasoft-user-j-test-policy';
delete from project.policy where policy_code = 'coverity-user-policy';
delete from project.policy where policy_code = 'sonatype-user-policy';
delete from project.user_permission where permission_code = 'ssh-access';
delete from project.user_permission where permission_code = 'codesonar-user';
delete from project.user_permission where permission_code = 'parasoft-user-c-test';
delete from project.user_permission where permission_code = 'parasoft-user-j-test';
delete from project.user_permission where permission_code = 'coverity-user';
delete from project.user_permission where permission_code = 'sonatype-user';
delete from project.user_policy where policy_code = 'codesonar-user-policy';
delete from project.user_policy where policy_code = 'parasoft-user-c-test-policy';
delete from project.user_policy where policy_code = 'parasoft-user-j-test-policy';
delete from project.user_policy where policy_code = 'coverity-user-policy';
delete from project.user_policy where policy_code = 'sonatype-user-policy';

# Disable metric runs
ALTER EVENT metric.initiate_metric_runs DISABLE; # disables M-Runs

# system_type
insert into assessment.system_setting (system_setting_code, system_setting_value) values ('SYSTEM_TYPE', 'SWAMP_IN_A_BOX');

