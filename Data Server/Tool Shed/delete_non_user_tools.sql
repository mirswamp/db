# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2017 Software Assurance Marketplace

# During an upgrade of Swamp in a Box, this script can be used to delete all non-user-installed tools so they can be reinstalled, while leaving user-installed tools untouched.
delete from tool_shed.tool where tool_uuid not in (
            '5540d2be-72b2-11e5-865f-001a4a81450b', # Code Sonar
            'e7a00759-82a4-11e7-9baa-001a4a81450b'  # Coverity
            );
delete from tool_shed.tool_version where tool_uuid not in (
            '5540d2be-72b2-11e5-865f-001a4a81450b', # Code Sonar
            'e7a00759-82a4-11e7-9baa-001a4a81450b'  # Coverity
            );