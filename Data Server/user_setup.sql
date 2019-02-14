# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2019 Software Assurance Marketplace

# web user
CREATE USER 'web'@'%' IDENTIFIED BY 'password';

# java_agent executes procedures
CREATE USER 'java_agent'@'%' IDENTIFIED BY 'password';
CREATE USER 'java_agent'@'localhost' IDENTIFIED BY 'password';
