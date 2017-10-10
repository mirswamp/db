# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2017 Software Assurance Marketplace

use project;

CREATE TABLE project.user (
  user_id int(11) unsigned NOT NULL AUTO_INCREMENT,
  user_uid varchar(36) DEFAULT NULL,
  username varchar(255) DEFAULT NULL,
  password varchar(255) DEFAULT NULL,
  first_name varchar(255) DEFAULT NULL,
  last_name varchar(255) DEFAULT NULL,
  preferred_name varchar(255) DEFAULT NULL,
  email varchar(255) DEFAULT NULL,
  affiliation varchar(255) DEFAULT NULL,
  admin tinyint(1) DEFAULT NULL,
  enabled_flag tinyint(1) DEFAULT NULL,
  create_date datetime DEFAULT NULL,
  update_date datetime DEFAULT NULL,
  delete_date datetime DEFAULT NULL,
  PRIMARY KEY (user_id)
);
