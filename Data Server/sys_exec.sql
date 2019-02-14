# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2019 Software Assurance Marketplace

DROP FUNCTION IF EXISTS sys_exec;
CREATE FUNCTION sys_exec RETURNS INT SONAME 'lib_mysqludf_sys.so';
DROP FUNCTION IF EXISTS sys_eval;
CREATE FUNCTION sys_eval RETURNS string SONAME 'lib_mysqludf_sys.so';
