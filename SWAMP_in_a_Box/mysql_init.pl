#!/usr/bin/env perl

# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2017 Software Assurance Marketplace

use strict;
use warnings;
use 5.010;

use English qw( -no_match_vars );

my $debug = 0;

#
# Test for whether `systemctl` is available.
#
print "Testing for systemctl\n";

my $is_systemctl_avail = (0 == system 'which', 'systemctl');

if ($is_systemctl_avail) {
    print "Found systemctl\n";
}
else {
    print "Did not find systemctl\n";
}

#
# Query or control a service using `service` or `systemctl`.
#
sub tell_service { my ($service, $command) = @_ ;
    my $system_command;

    if ($is_systemctl_avail) {
        $system_command = "systemctl $command $service";
    }
    else {
        $system_command = "service $service $command";
    }

    print "Calling: $system_command\n" if $debug;
    return (`$system_command` || q{});
}

#
# Determine whether a service is "stopped" or "running".
# WARNING: Might not work in all contexts or for all services.
#
sub get_status { my ($service) = @_ ;
    my $command = $is_systemctl_avail ? 'show --property ActiveState' : 'status';
    my $status = tell_service($service, $command);

    given ($status) {
        when (/MySQL running|is running|=active/sm) { $status = 'running'; }
        when (/not running|stopped|=inactive/sm)    { $status = 'stopped'; }
        default                                     { $status = 'error'; }
    }

    print "status $service: $status\n" if $debug;
    return $status;
}

#
# Start or stop a service.
#
sub toggle_service { my ($service, $command, $old_state, $new_state) = @_;
    my $status = get_status($service);

    if ($status eq $new_state) {
        print "$command $service: already $new_state\n" if $debug;
        return 1;
    }

    if ($status eq $old_state) {
        tell_service($service, $command);
        $status = get_status($service);
        if ($status eq $new_state) {
            print "$command $service: succeeded\n" if $debug;
            return 1;
        }
    }

    print "$command $service: failed, status: $status\n" if $debug;
    return 0;
}

sub start_service { my ($service) = @_ ;
    print "Starting service: $service\n";
    return toggle_service($service, 'start', 'stopped', 'running');
}

sub stop_service { my ($service) = @_ ;
    print "Stopping service: $service\n";
    return toggle_service($service, 'stop', 'running', 'stopped');
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
