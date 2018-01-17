# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2018 Software Assurance Marketplace

# During an upgrade of Swamp in a Box, this script can be used to delete all non-user-installed tools so they can be reinstalled, while leaving user-installed tools untouched.
delete from tool_shed.tool where tool_uuid not in (
            '5540d2be-72b2-11e5-865f-001a4a81450b', # Code Sonar
            'e7a00759-82a4-11e7-9baa-001a4a81450b', # Coverity
            'd032d8ec-9184-11e6-88bc-001a4a81450b', # OWASP Dependency Check
            '4bb2644d-6440-11e4-a282-001a4a81450b', # Parasoft C/C++test
            '6197a593-6440-11e4-a282-001a4a81450b'  # Parasoft Jtest
            );
delete from tool_shed.tool_version where tool_uuid not in (
            '5540d2be-72b2-11e5-865f-001a4a81450b', # Code Sonar
            'e7a00759-82a4-11e7-9baa-001a4a81450b', # Coverity
            'd032d8ec-9184-11e6-88bc-001a4a81450b', # OWASP Dependency Check
            '4bb2644d-6440-11e4-a282-001a4a81450b', # Parasoft C/C++test
            '6197a593-6440-11e4-a282-001a4a81450b'  # Parasoft Jtest
            );

# OWASP dependency check was a bundled tool, then became a user add-on tool.
# delete old bundled versions
delete from tool_shed.tool_version where tool_version_uuid in (
  'e3466345-9184-11e6-88bc-001a4a81450b', # OWASP Dependency Check 1.4.3
  '37565211-e27f-11e6-bf70-001a4a81450b'  # OWASP Dependency Check 1.4.4
  );
# delete tool if no versions remain
    delete from tool_shed.tool
     where tool_uuid = 'd032d8ec-9184-11e6-88bc-001a4a81450b'
       and not exists (select * from tool_shed.tool_version where tool_uuid = 'd032d8ec-9184-11e6-88bc-001a4a81450b');


