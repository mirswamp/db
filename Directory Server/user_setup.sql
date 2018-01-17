# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2018 Software Assurance Marketplace

# web user
CREATE USER 'web'@'%' IDENTIFIED BY 'password';

# replication user slave to connect to master
CREATE USER 'replication_user'@'%' IDENTIFIED BY 'password';
