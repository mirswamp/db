# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2018 Software Assurance Marketplace

# These users are for development only
# They should not be in the production installer

# swim_reader select all tables
CREATE USER 'swim_reader'@'localhost' IDENTIFIED BY 'password';
CREATE USER 'swim_reader'@'%' IDENTIFIED BY 'password';
GRANT SELECT ON *.* TO 'swim_reader'@'localhost';
GRANT SELECT ON *.* TO 'swim_reader'@'%';

# swim_dev all priveledges
CREATE USER 'swim_dev'@'localhost' IDENTIFIED BY 'password';
CREATE USER 'swim_dev'@'%' IDENTIFIED BY 'password';
#GRANT ALL PRIVILEGES ON *.* TO 'swim_dev'@'localhost' WITH GRANT OPTION;
#GRANT ALL PRIVILEGES ON *.* TO 'swim_dev'@'%' WITH GRANT OPTION;
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE ON *.* TO 'swim_dev'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE ON *.* TO 'swim_dev'@'localhost';

GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE, SHOW VIEW, LOCK TABLES ON *.* TO 'swim_dev'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE, SHOW VIEW, LOCK TABLES ON *.* TO 'swim_dev'@'localhost';
