# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2017 Software Assurance Marketplace

# During an upgrade of Swamp in a Box, this script can be used to delete all non-user-installed tools so they can be reinstalled, while leaving user-installed tools untouched.
# For v1.30, the only user installed tool is Code Sonar. For future releases, this script may need to be updated to accomodate other ways of identifying user-installed tools.
delete from tool_shed.tool         where tool_uuid != '5540d2be-72b2-11e5-865f-001a4a81450b';
delete from tool_shed.tool_version where tool_uuid != '5540d2be-72b2-11e5-865f-001a4a81450b';