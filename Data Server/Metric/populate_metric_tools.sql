# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2020 Software Assurance Marketplace

use metric;

# Add cloc
insert into metric_tool (
  metric_tool_uuid,
  metric_tool_owner_uuid,
  name,
  description,
  tool_sharing_status,
  is_build_needed)
values (
  '0726f1df-3e40-11e6-a6cc-001a4a81450b', # metric_tool_uuid
  '80835e30-d527-11e2-8b8b-0800200c9a66', # metric_tool_owner_uuid
  'cloc',                                 # name
  'cloc counts blank lines, comment lines, and physical lines of source code in many programming languages. https://github.com/AlDanial/cloc',
  'PUBLIC',                               # tool_sharing_status
  1                                       # is_build_needed
  );
insert into metric_tool_version (
  metric_tool_version_uuid,
  metric_tool_uuid,
  version_no,
  version_string,
  tool_path,
  checksum)
values (
  '336e327a-de98-11e6-bf70-001a4a81450b',
  '0726f1df-3e40-11e6-a6cc-001a4a81450b',
  2,
  '1.70',
  '/swamp/store/SCATools/cloc-1.70.tar.gz',
  '0548025672e536d2c03e385690bdab17d8ae25394581e5d1c821e30936dca21210491c1d9fed662ea732fd7ccea772b30db4717e74c5ab36096273d383a02ec7'
  );

# Add lizard
insert into metric_tool (
  metric_tool_uuid,
  metric_tool_owner_uuid,
  name,
  description,
  tool_sharing_status,
  is_build_needed)
values (
  '9692f64b-3e43-11e6-a6cc-001a4a81450b', # metric_tool_uuid
  '80835e30-d527-11e2-8b8b-0800200c9a66', # metric_tool_owner_uuid
  'Lizard',                               # name
  'A code analyzer. https://pypi.python.org/pypi/lizard', # description
  'PUBLIC',                               # tool_sharing_status
  1                                       # is_build_needed
  );
insert into metric_tool_version (
  metric_tool_version_uuid,
  metric_tool_uuid,
  version_no,
  version_string,
  tool_path,
  checksum)
values (
  '3bd56e00-de98-11e6-bf70-001a4a81450b',
  '9692f64b-3e43-11e6-a6cc-001a4a81450b',
  2,
  '1.12.7',
  '/swamp/store/SCATools/lizard-1.12.7.tar.gz',
  'b71c323e52b5bf665b9b0596bc709da3ec82c0c64c3836148f987b704947fbb5bea892a30e712533391168fc061a61b7e76d7e554a2103a4b507bf2c620b7fb7'
  );