# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2020 Software Assurance Marketplace

use assessment;

insert into database_version (database_version_no, description) values (63, 'setup 1.35');
commit;

insert into run_request (run_request_uuid, project_uuid, hidden_flag, name, description) values ('6bef7825-1b2d-11e3-af14-001a4a81450b', null, 1, 'One-time', 'Run once as soon as possible');
insert into run_request (run_request_uuid, project_uuid, hidden_flag, name, description) values ('f18550dd-fdca-11e3-8775-001a4a81450b', null, 0, 'On push', 'Run when creation of a new package version is triggered by a GitHub Webhook');
commit;

insert into assessment.system_status (status_key, value) values ('CURRENTLY_PROCESSING_EXECUTION_RECORDS', 'N');
insert into assessment.system_status (status_key, value) values ('CURRENTLY_RUNNING_SCHEDULER', 'N');
commit;
