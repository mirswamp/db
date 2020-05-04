# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2020 Software Assurance Marketplace

delete from platform_store.platform_version;
delete from platform_store.platform;

update package_store.package_type
    set platform_user_selectable = 0
    where package_type_id = 1;
