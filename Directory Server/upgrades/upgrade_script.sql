# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2018 Software Assurance Marketplace

source 1.sql
call project.upgrade_1 ();
drop PROCEDURE if exists project.upgrade_1;

source 2.sql
call project.upgrade_2 ();
drop PROCEDURE if exists project.upgrade_2;

source 3.sql
call project.upgrade_3 ();
drop PROCEDURE if exists project.upgrade_3;

source 4.sql
call project.upgrade_4 ();
drop PROCEDURE if exists project.upgrade_4;

source 5.sql
call project.upgrade_5 ();
drop PROCEDURE if exists project.upgrade_5;

source 6.sql
call project.upgrade_6 ();
drop PROCEDURE if exists project.upgrade_6;

source 7.sql
call project.upgrade_7 ();
drop PROCEDURE if exists project.upgrade_7;

source 8.sql
call project.upgrade_8 ();
drop PROCEDURE if exists project.upgrade_8;

source 9.sql
call project.upgrade_9 ();
drop PROCEDURE if exists project.upgrade_9;

source 10.sql
call project.upgrade_10 ();
drop PROCEDURE if exists project.upgrade_10;

source 11.sql
call project.upgrade_11 ();
drop PROCEDURE if exists project.upgrade_11;

source 12.sql
call project.upgrade_12 ();
drop PROCEDURE if exists project.upgrade_12;

source 13.sql
call project.upgrade_13 ();
drop PROCEDURE if exists project.upgrade_13;

source 14.sql
call project.upgrade_14 ();
drop PROCEDURE if exists project.upgrade_14;

source 15.sql
call project.upgrade_15 ();
drop PROCEDURE if exists project.upgrade_15;

source 16.sql
call project.upgrade_16 ();
drop PROCEDURE if exists project.upgrade_16;

source 17.sql
call project.upgrade_17 ();
drop PROCEDURE if exists project.upgrade_17;

source 18.sql
call project.upgrade_18 ();
drop PROCEDURE if exists project.upgrade_18;

source 19.sql
call project.upgrade_19 ();
drop PROCEDURE if exists project.upgrade_19;

source 20.sql
call project.upgrade_20 ();
drop PROCEDURE if exists project.upgrade_20;

source 21.sql
call project.upgrade_21 ();
drop PROCEDURE if exists project.upgrade_21;

source 22.sql
call project.upgrade_22 ();
drop PROCEDURE if exists project.upgrade_22;

source 23.sql
call project.upgrade_23 ();
drop PROCEDURE if exists project.upgrade_23;

source 24.sql
call project.upgrade_24 ();
drop PROCEDURE if exists project.upgrade_24;
