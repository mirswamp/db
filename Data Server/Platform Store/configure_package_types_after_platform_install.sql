# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2020 Software Assurance Marketplace

set @android_uuid = '48f9a9b0-976f-11e4-829b-001a4a81450b';
set @android_version_uuid = '8f4878ec-976f-11e4-829b-001a4a81450b';
set @centos_uuid = '071890c4-7c3b-11e6-88bc-001a4a81450b';
set @debian_uuid = 'ee2c1193-209b-11e3-9a3e-001a4a81450b';
set @fedora_uuid = '8a51ecea-209d-11e3-9a3e-001a4a81450b';
set @scientific_uuid = 'd95fcb5f-209d-11e3-9a3e-001a4a81450b';
set @ubuntu_uuid = '1088c3ce-20aa-11e3-9a3e-001a4a81450b';
set @ubuntu_version_uuid = '03b18efe-7c41-11e6-88bc-001a4a81450b';

# Disable all package types, and reset the default platforms.

update package_store.package_type
set
  package_type_enabled = 0,
  platform_user_selectable = 0,
  default_platform_uuid = @ubuntu_uuid;

update package_store.package_type
set default_platform_uuid = @android_uuid
where package_type_id in (6, 11);

# Enable those package types for which assessments can be run successfully.
#
# Ideally, we would have data indicating precisely the combinations of
# package types, tool versions, and platform versions for which assessments
# can be run successfully. Instead, we have the 'tool_platform' table and
# outside knowledge that for all but one of the package types, there is only
# one viable platform version.

update package_store.package_type pt
set package_type_enabled = 1
where
  exists (select *
    from platform_store.platform_version pv
    inner join platform_store.platform p on pv.platform_uuid = p.platform_uuid
    inner join tool_shed.tool_platform tp on p.platform_uuid = tp.platform_uuid
    inner join tool_shed.tool t on tp.tool_uuid = t.tool_uuid
    inner join tool_shed.tool_language tl on t.tool_uuid = tl.tool_uuid
    where pt.package_type_id = tl.package_type_id)
  and package_type_id = 1;

update package_store.package_type pt
set package_type_enabled = 1
where
  exists (select *
    from platform_store.platform_version pv
    inner join platform_store.platform p on pv.platform_uuid = p.platform_uuid
    inner join tool_shed.tool_platform tp on p.platform_uuid = tp.platform_uuid
    inner join tool_shed.tool t on tp.tool_uuid = t.tool_uuid
    inner join tool_shed.tool_language tl on t.tool_uuid = tl.tool_uuid
    where pt.package_type_id = tl.package_type_id
      and pv.platform_uuid = @ubuntu_uuid
      and pv.platform_version_uuid = @ubuntu_version_uuid)
  and package_type_id not in (1, 6, 11);

update package_store.package_type pt
set package_type_enabled = 1
where
  exists (select *
    from platform_store.platform_version pv
    inner join platform_store.platform p on pv.platform_uuid = p.platform_uuid
    inner join tool_shed.tool_platform tp on p.platform_uuid = tp.platform_uuid
    inner join tool_shed.tool t on tp.tool_uuid = t.tool_uuid
    inner join tool_shed.tool_language tl on t.tool_uuid = tl.tool_uuid
    where pt.package_type_id = tl.package_type_id
      and pv.platform_uuid = @android_uuid
      and pv.platform_version_uuid = @android_version_uuid)
  and package_type_id in (6, 11);

update package_store.package_type pt
set platform_user_selectable = 1
where
  (select count(distinct pv.platform_version_uuid)
    from platform_store.platform_version pv
    inner join platform_store.platform p on pv.platform_uuid = p.platform_uuid
    inner join tool_shed.tool_platform tp on p.platform_uuid = tp.platform_uuid
    inner join tool_shed.tool t on tp.tool_uuid = t.tool_uuid
    inner join tool_shed.tool_language tl on t.tool_uuid = tl.tool_uuid
    where pt.package_type_id = tl.package_type_id) > 1
  and package_type_enabled = 1
  and package_type_id = 1;

update package_store.package_type pt
set default_platform_uuid =
  (select p.platform_uuid
    from platform_store.platform_version pv
    inner join platform_store.platform p on pv.platform_uuid = p.platform_uuid
    inner join tool_shed.tool_platform tp on p.platform_uuid = tp.platform_uuid
    inner join tool_shed.tool t on tp.tool_uuid = t.tool_uuid
    inner join tool_shed.tool_language tl on t.tool_uuid = tl.tool_uuid
    where pt.package_type_id = tl.package_type_id
    order by case p.platform_uuid
                when @ubuntu_uuid then 1
                when @centos_uuid then 2
                when @fedora_uuid then 3
                when @debian_uuid then 4
                when @scientific_uuid then 5
                else null
             end asc
    limit 1)
where
  package_type_enabled = 1
  and package_type_id = 1;
