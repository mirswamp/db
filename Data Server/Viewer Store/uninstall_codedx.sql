# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2018 Software Assurance Marketplace

use viewer_store;

delete from viewer_store.viewer_version where viewer_uuid = '4221533e-865a-11e3-88bb-001a4a81450b';
delete from viewer_store.viewer where viewer_uuid = '4221533e-865a-11e3-88bb-001a4a81450b';

commit;
