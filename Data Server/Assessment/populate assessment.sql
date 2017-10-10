# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2017 Software Assurance Marketplace

use assessment;

insert into database_version (database_version_no, description) values (55, 'setup 1.31');
commit;

insert into run_request (run_request_uuid, project_uuid, name, description) values ('6bef7825-1b2d-11e3-af14-001a4a81450b', ' ', 'One-time', 'Run once as soon as possible');
commit;

insert into assessment.system_status (status_key, value) values ('CURRENTLY_PROCESSING_EXECUTION_RECORDS', 'N');
insert into assessment.system_status (status_key, value) values ('CURRENTLY_RUNNING_SCHEDULER', 'N');
commit;
