#!/usr/bin/env perl

# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2018 Software Assurance Marketplace

use strict;
use warnings;
use 5.010;

use English qw( -no_match_vars );

my $debug = 0;
my $service_cmd = '/opt/swamp/sbin/swamp_manage_service';

if (!-x $service_cmd) {
    die "Error: $PROGRAM_NAME: Not executable: $service_cmd\n";
}

sub start_service { my ($service) = @_ ;
    print qx("$service_cmd" "$service" start);
    return;
}

sub stop_service { my ($service) = @_ ;
    print qx("$service_cmd" "$service" stop);
    return;
}

#
# Remove data files.
#
sub remove_mysql {
    print "Removing /var/lib/mysql/*\n";

    my $result = `\\rm -rf /var/lib/mysql/* 2>&1` || q{};
    my $success = (0 == $CHILD_ERROR);

    if (!$success) {
        print "Error: rm -rf /var/lib/mysql/*: $result\n";
        exit 1;
    }

    print "rm -rf /var/lib/mysql/*: $result\n" if $debug;
    return;
}

#
# Initialize data files.
#
sub install_mysql {
    print "Initializing MySQL data directory\n";

    my $result = `mysql_install_db --user=mysql 2>&1` || q{};
    my $success = (0 == $CHILD_ERROR);

    if (!$success) {
        print "Error: mysql_install_db --user=mysql: $result\n";
        exit 1;
    }

    print "mysql_install_db --user=mysql: $result\n" if $debug;
    return;
}

#
# Secure the installation.
#
sub secure_mysql {
    print "Securing MySQL installation\n";

    my $old_password = q{};
    my $new_password = `openssl enc -d -aes-256-cbc -in /etc/.mysql_root -pass pass:swamp` || q{};
    my $success      = (0 == $CHILD_ERROR);

    if (!$success) {
        print "Error: Unable to determine new database root password\n";
        exit 1;
    }

    #
    # Strip off trailing new line character. Escape special characters.
    #

    chomp $new_password;
    $new_password =~ s{\\}{\\\\}smg;
    $new_password =~ s{\'}{\'\'}smg;

    if (open my $fh, '|-', 'mysql -u root') {
        print {$fh} <<"END_OF_INTERACTIVE_INPUT";
# SELECT User, Host, Password FROM mysql.user;
# SELECT '';
# SELECT Host, Db, User FROM mysql.db;
# SELECT '';

UPDATE mysql.user SET PASSWORD = password('$new_password') WHERE user = 'root';
DELETE FROM mysql.user WHERE user = 'root' AND host NOT IN ('localhost', '127.0.0.1', '::1');
DELETE FROM mysql.user WHERE user = '';
DELETE FROM mysql.db WHERE db = 'test' OR db = 'test\\_%';
FLUSH PRIVILEGES;

# SELECT User, Host, Password FROM mysql.user;
# SELECT '';
# SELECT Host, Db, User FROM mysql.db;
# SELECT '';
END_OF_INTERACTIVE_INPUT
        close $fh;
    }
    else {
        print "Error: Could not invoke `mysql -u root`?\n";
        exit 1;
    }

    $success = (0 == $CHILD_ERROR);

    if (!$success) {
        print "Error: Failed to secure MySQL installation?\n";
        exit 1;
    }
}

#
# Determine the name of the MySQL service and initialize it.
#
my $mysql = 'mysql';
$mysql = $ARGV[0] if defined $ARGV[0];

stop_service($mysql);
remove_mysql();
install_mysql();
start_service($mysql);
secure_mysql();
exit 0;
