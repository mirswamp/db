# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2020 Software Assurance Marketplace

use project;

# linked_account_provider
insert into linked_account_provider (linked_account_provider_code, title, description, enabled_flag) values ('github', 'GitHub', 'The GitHub git repository service.', 1);

# Permission
insert into permission (permission_code, title, description, admin_only_flag, auto_approve_flag, policy_code, user_info, user_info_policy_text) values (
                        'ssh-access', 'SSH Access', 'Permission to log in to assessment virtual machines using SSH.', 1,0, null,null,null);
insert into permission (permission_code, title, description, admin_only_flag, auto_approve_flag, policy_code, user_info, user_info_policy_text) values (
                        'codesonar-user', 'CodeSonar User', 'GrammaTech CodeSonar User', 0,0, 'codesonar-user-policy',
                        '{\n \"name\": {\n           \"type\": \"text\",\n           \"placeholder\": \"First Last\",\n              \"help\": \"Your full name for tool usage.\",\n         \"required\": true\n    },\n\n  \"email\": {\n          \"type\": \"text\",\n           \"placeholder\": \"name@domain\",\n             \"help\": \"The email address that you would like to use with this tool.\",\n           \"required\": true\n    },\n\n  \"organization\": {\n           \"type\": \"text\",\n           \"placeholder\": \"Your organization here\",\n          \"help\": \"This is the name of the organization, university, or company that you are affiliated with.\",\n             \"required\": true\n    },\n\n  \"project url\": {\n            \"type\": \"text\",\n           \"placeholder\": \"http://\",\n         \"help\": \"A URL to a web page about the project that you wish to use this tool for.\",\n              \"required\": false\n   },\n\n  \"user type\": {\n              \"type\":       \"enum\",\n             \"values\": [\"open source\", \"educational\", \"government\", \"commercial\"],\n        \"help\": \"The category of user that you belong to.\"\n        }\n}',
                        'I understand that if I am a Commercial user, Government user or I cannot be sufficiently vetted as an Education User or Open Source Developer, my name and contact information will be shared with Grammatech for approval purposes only.');
insert into permission (permission_code, title, description, admin_only_flag, auto_approve_flag, policy_code, user_info, user_info_policy_text)
                values ('parasoft-user-c-test', 'Parasoft C/C++test User', 'Permission to access and use the C/C++test static analysis tool for C/C++ from Parasoft.', 0,0, 'parasoft-user-c-test-policy',
                        '{\r\n  \"name\": {\r\n            \"type\": \"text\",\r\n            \"placeholder\": \"First Last\",\r\n               \"help\": \"Your full name for tool usage.\",\r\n          \"required\": true\r\n     },\r\n \r\n   \"email\": {\r\n           \"type\": \"text\",\r\n            \"placeholder\": \"name@domain\",\r\n              \"help\": \"The email address that you would like to use with this tool.\",\r\n            \"required\": true\r\n     },\r\n \r\n   \"organization\": {\r\n            \"type\": \"text\",\r\n            \"placeholder\": \"Your organization here\",\r\n           \"help\": \"This is the name of the organization, university, or company that you are affiliated with.\",\r\n              \"required\": true\r\n     },\r\n \r\n   \"project url\": {\r\n             \"type\": \"text\",\r\n            \"placeholder\": \"http://\",\r\n          \"help\": \"A URL to a web page about the project that you wish to use this tool for.\",\r\n               \"required\": false\r\n    },\r\n \r\n   \"user type\": {\r\n               \"type\":       \"enum\",\r\n              \"values\": [\"open source\", \"educational\", \"government\", \"commercial\"],\r\n         \"help\": \"The category of user that you belong to.\"\r\n         }\r\n }',
                        'I understand that if I am a Commercial user, Government user or I cannot be sufficiently vetted as an Education User or Open Source Developer, my name and contact information will be shared with Parasoft for approval purposes only.');
insert into permission (permission_code, title, description, admin_only_flag, auto_approve_flag, policy_code, user_info, user_info_policy_text)
                values ('parasoft-user-j-test', 'Parasoft Jtest User', 'Permission to access and use the Jtest static analysis tool for Java from Parasoft.', 0,0, 'parasoft-user-j-test-policy',
                        '{\r\n  \"name\": {\r\n            \"type\": \"text\",\r\n            \"placeholder\": \"First Last\",\r\n               \"help\": \"Your full name for tool usage.\",\r\n          \"required\": true\r\n     },\r\n \r\n   \"email\": {\r\n           \"type\": \"text\",\r\n            \"placeholder\": \"name@domain\",\r\n              \"help\": \"The email address that you would like to use with this tool.\",\r\n            \"required\": true\r\n     },\r\n \r\n   \"organization\": {\r\n            \"type\": \"text\",\r\n            \"placeholder\": \"Your organization here\",\r\n           \"help\": \"This is the name of the organization, university, or company that you are affiliated with.\",\r\n              \"required\": true\r\n     },\r\n \r\n   \"project url\": {\r\n             \"type\": \"text\",\r\n            \"placeholder\": \"http://\",\r\n          \"help\": \"A URL to a web page about the project that you wish to use this tool for.\",\r\n               \"required\": false\r\n    },\r\n \r\n   \"user type\": {\r\n               \"type\":       \"enum\",\r\n              \"values\": [\"open source\", \"educational\", \"government\", \"commercial\"],\r\n         \"help\": \"The category of user that you belong to.\"\r\n         }\r\n }',
                        'I understand that if I am a Commercial user, Government user or I cannot be sufficiently vetted as an Education User or Open Source Developer, my name and contact information will be shared with Parasoft for approval purposes only.');
insert into project.permission (permission_code, title, description, admin_only_flag, auto_approve_flag,
                                user_info,
                                user_info_policy_text,
                                policy_code)
                        values ('sonatype-user', 'Sonatype User', 'Permission to access and use the Application Health Check analysis tool of Java from Sonatype.', 0, 1,
                                '{\n \"name\": {\n           \"type\": \"text\",\n           \"placeholder\": \"First Last\",\n              \"help\": \"Your full name for tool usage.\",\n         \"required\": true\n    },\n\n  \"email\": {\n          \"type\": \"text\",\n           \"placeholder\": \"name@domain\",\n             \"help\": \"The email address that you would like to use with this tool.\",\n           \"required\": true\n    },\n\n  \"organization\": {\n           \"type\": \"text\",\n           \"placeholder\": \"Your organization here\",\n          \"help\": \"This is the name of the organization, university, or company that you are affiliated with.\",\n             \"required\": true\n    },\n\n  \"project url\": {\n            \"type\": \"text\",\n           \"placeholder\": \"http://\",\n         \"help\": \"A URL to a web page about the project that you wish to use this tool for.\",\n              \"required\": false\n   },\n\n  \"user type\": {\n              \"type\":       \"enum\",\n             \"values\": [\"open source\", \"educational\", \"government\", \"commercial\"],\n        \"help\": \"The category of user that you belong to.\"\n        }\n}',
                                'I understand that my contact information will be sent to Sonatype.',
                                'sonatype-user-policy');

# policy
insert into project.policy (policy_code, description, policy) values ('codesonar-user-policy', 'GrammaTech CodeSonar EULA', '<div style=\"white-space: pre-wrap;\">\r\n\r\nSOFTWARE END USER LICENCE TERMS\r\n\r\nOpen Source Developers: <a href=\"https://www.swampinabox.org/doc/eula_codesonar_oss.pdf\" target=\"_blank\">https://www.swampinabox.org/doc/eula_codesonar_oss.pdf</a>\r\n\r\nAcademic Users: <a href=\"https://www.swampinabox.org/doc/eula_codesonar_academic.pdf\" target=\"_blank\">https://www.swampinabox.org/doc/eula_codesonar_academic.pdf</a></div>');
insert into project.policy (policy_code, description, policy) values ('parasoft-user-c-test-policy', 'Parasoft C-Test EULA', '<div style=\"white-space: pre-wrap;\">\r\n\r\nSOFTWARE END USER LICENCE TERMS\r\n\r\n<a href="https://www.swampinabox.org/doc/eula_parasoft_ctest.pdf" target="_blank">https://www.swampinabox.org/doc/eula_parasoft_ctest.pdf</a></div>');
insert into project.policy (policy_code, description, policy) values ('parasoft-user-j-test-policy', 'Parasoft J-Test EULA', '<div style=\"white-space: pre-wrap;\">\r\n\r\nSOFTWARE END USER LICENCE TERMS\r\n\r\n<a href="https://www.swampinabox.org/doc/eula_parasoft_jtest.pdf" target="_blank">https://www.swampinabox.org/doc/eula_parasoft_jtest.pdf</a></div>');
insert into project.policy (policy_code, description, policy) values ('sonatype-user-policy', 'Sonatype Application Health Check EULA', '<div style=\"white-space: pre-wrap;\">\r\n\r\nSOFTWARE END USER LICENCE TERMS\r\n\r\n<a href="https://www.swampinabox.org/doc/eula_sonatype.pdf" target="_blank">https://www.swampinabox.org/doc/eula_sonatype.pdf</a></div>');

# Admin User
insert into user_account (user_uid, enabled_flag, admin_flag, email_verified_flag) values ('80835e30-d527-11e2-8b8b-0800200c9a66', 1, 1, 1);
insert into email_verification (user_uid, verification_key, email, create_date, verify_date) VALUES ('80835e30-d527-11e2-8b8b-0800200c9a66', '6a9550f3-0086-9da9-dcc1-4056f8739c52', 'email_address', now(), now());
insert into user_permission (user_permission_uid, permission_code, user_uid, request_date, grant_date)
  select uuid(), permission_code, '80835e30-d527-11e2-8b8b-0800200c9a66', now(), now() from project.permission;
insert into user_policy (user_policy_uid, user_uid, policy_code, accept_flag)
  select uuid(), '80835e30-d527-11e2-8b8b-0800200c9a66', policy_code, 1 from project.policy;
commit;

INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('AF', 'Afghanistan', 'AFG', '4', '93');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('AL', 'Albania', 'ALB', '8', '355');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('DZ', 'Algeria', 'DZA', '12', '213');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('AS', 'American Samoa', 'ASM', '16', '1684');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('AD', 'Andorra', 'AND', '20', '376');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('AO', 'Angola', 'AGO', '24', '244');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('AI', 'Anguilla', 'AIA', '660', '1264');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('AQ', 'Antarctica', null, null, '0');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('AG', 'Antigua and Barbuda', 'ATG', '28', '1268');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('AR', 'Argentina', 'ARG', '32', '54');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('AM', 'Armenia', 'ARM', '51', '374');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('AW', 'Aruba', 'ABW', '533', '297');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('AU', 'Australia', 'AUS', '36', '61');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('AT', 'Austria', 'AUT', '40', '43');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('AZ', 'Azerbaijan', 'AZE', '31', '994');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('BS', 'Bahamas', 'BHS', '44', '1242');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('BH', 'Bahrain', 'BHR', '48', '973');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('BD', 'Bangladesh', 'BGD', '50', '880');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('BB', 'Barbados', 'BRB', '52', '1246');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('BY', 'Belarus', 'BLR', '112', '375');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('BE', 'Belgium', 'BEL', '56', '32');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('BZ', 'Belize', 'BLZ', '84', '501');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('BJ', 'Benin', 'BEN', '204', '229');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('BM', 'Bermuda', 'BMU', '60', '1441');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('BT', 'Bhutan', 'BTN', '64', '975');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('BO', 'Bolivia', 'BOL', '68', '591');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('BA', 'Bosnia and Herzegovina', 'BIH', '70', '387');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('BW', 'Botswana', 'BWA', '72', '267');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('BV', 'Bouvet Island', null, null, '0');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('BR', 'Brazil', 'BRA', '76', '55');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('IO', 'British Indian Ocean Territory', null, null, '246');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('BN', 'Brunei Darussalam', 'BRN', '96', '673');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('BG', 'Bulgaria', 'BGR', '100', '359');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('BF', 'Burkina Faso', 'BFA', '854', '226');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('BI', 'Burundi', 'BDI', '108', '257');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('KH', 'Cambodia', 'KHM', '116', '855');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('CM', 'Cameroon', 'CMR', '120', '237');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('CA', 'Canada', 'CAN', '124', '1');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('CV', 'Cape Verde', 'CPV', '132', '238');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('KY', 'Cayman Islands', 'CYM', '136', '1345');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('CF', 'Central African Republic', 'CAF', '140', '236');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('TD', 'Chad', 'TCD', '148', '235');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('CL', 'Chile', 'CHL', '152', '56');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('CN', 'China', 'CHN', '156', '86');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('CX', 'Christmas Island', null, null, '61');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('CC', 'Cocos (Keeling) Islands', null, null, '672');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('CO', 'Colombia', 'COL', '170', '57');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('KM', 'Comoros', 'COM', '174', '269');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('CG', 'Congo', 'COG', '178', '242');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('CD', 'Congo, the Democratic Republic of the', 'COD', '180', '242');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('CK', 'Cook Islands', 'COK', '184', '682');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('CR', 'Costa Rica', 'CRI', '188', '506');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('CI', 'Cote D''Ivoire', 'CIV', '384', '225');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('HR', 'Croatia', 'HRV', '191', '385');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('CU', 'Cuba', 'CUB', '192', '53');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('CY', 'Cyprus', 'CYP', '196', '357');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('CZ', 'Czech Republic', 'CZE', '203', '420');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('DK', 'Denmark', 'DNK', '208', '45');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('DJ', 'Djibouti', 'DJI', '262', '253');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('DM', 'Dominica', 'DMA', '212', '1767');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('DO', 'Dominican Republic', 'DOM', '214', '1809');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('EC', 'Ecuador', 'ECU', '218', '593');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('EG', 'Egypt', 'EGY', '818', '20');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('SV', 'El Salvador', 'SLV', '222', '503');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('GQ', 'Equatorial Guinea', 'GNQ', '226', '240');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('ER', 'Eritrea', 'ERI', '232', '291');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('EE', 'Estonia', 'EST', '233', '372');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('ET', 'Ethiopia', 'ETH', '231', '251');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('FK', 'Falkland Islands (Malvinas)', 'FLK', '238', '500');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('FO', 'Faroe Islands', 'FRO', '234', '298');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('FJ', 'Fiji', 'FJI', '242', '679');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('FI', 'Finland', 'FIN', '246', '358');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('FR', 'France', 'FRA', '250', '33');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('GF', 'French Guiana', 'GUF', '254', '594');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('PF', 'French Polynesia', 'PYF', '258', '689');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('TF', 'French Southern Territories', null, null, '0');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('GA', 'Gabon', 'GAB', '266', '241');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('GM', 'Gambia', 'GMB', '270', '220');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('GE', 'Georgia', 'GEO', '268', '995');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('DE', 'Germany', 'DEU', '276', '49');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('GH', 'Ghana', 'GHA', '288', '233');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('GI', 'Gibraltar', 'GIB', '292', '350');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('GR', 'Greece', 'GRC', '300', '30');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('GL', 'Greenland', 'GRL', '304', '299');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('GD', 'Grenada', 'GRD', '308', '1473');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('GP', 'Guadeloupe', 'GLP', '312', '590');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('GU', 'Guam', 'GUM', '316', '1671');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('GT', 'Guatemala', 'GTM', '320', '502');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('GN', 'Guinea', 'GIN', '324', '224');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('GW', 'Guinea-Bissau', 'GNB', '624', '245');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('GY', 'Guyana', 'GUY', '328', '592');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('HT', 'Haiti', 'HTI', '332', '509');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('HM', 'Heard Island and Mcdonald Islands', null, null, '0');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('VA', 'Holy See (Vatican City State)', 'VAT', '336', '39');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('HN', 'Honduras', 'HND', '340', '504');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('HK', 'Hong Kong', 'HKG', '344', '852');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('HU', 'Hungary', 'HUN', '348', '36');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('IS', 'Iceland', 'ISL', '352', '354');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('IN', 'India', 'IND', '356', '91');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('ID', 'Indonesia', 'IDN', '360', '62');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('IR', 'Iran, Islamic Republic of', 'IRN', '364', '98');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('IQ', 'Iraq', 'IRQ', '368', '964');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('IE', 'Ireland', 'IRL', '372', '353');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('IL', 'Israel', 'ISR', '376', '972');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('IT', 'Italy', 'ITA', '380', '39');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('JM', 'Jamaica', 'JAM', '388', '1876');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('JP', 'Japan', 'JPN', '392', '81');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('JO', 'Jordan', 'JOR', '400', '962');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('KZ', 'Kazakhstan', 'KAZ', '398', '7');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('KE', 'Kenya', 'KEN', '404', '254');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('KI', 'Kiribati', 'KIR', '296', '686');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('KP', 'Korea, Democratic People''s Republic of', 'PRK', '408', '850');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('KR', 'Korea, Republic of', 'KOR', '410', '82');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('KW', 'Kuwait', 'KWT', '414', '965');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('KG', 'Kyrgyzstan', 'KGZ', '417', '996');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('LA', 'Lao People''s Democratic Republic', 'LAO', '418', '856');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('LV', 'Latvia', 'LVA', '428', '371');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('LB', 'Lebanon', 'LBN', '422', '961');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('LS', 'Lesotho', 'LSO', '426', '266');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('LR', 'Liberia', 'LBR', '430', '231');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('LY', 'Libyan Arab Jamahiriya', 'LBY', '434', '218');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('LI', 'Liechtenstein', 'LIE', '438', '423');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('LT', 'Lithuania', 'LTU', '440', '370');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('LU', 'Luxembourg', 'LUX', '442', '352');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('MO', 'Macao', 'MAC', '446', '853');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('MK', 'Macedonia, the Former Yugoslav Republic of', 'MKD', '807', '389');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('MG', 'Madagascar', 'MDG', '450', '261');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('MW', 'Malawi', 'MWI', '454', '265');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('MY', 'Malaysia', 'MYS', '458', '60');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('MV', 'Maldives', 'MDV', '462', '960');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('ML', 'Mali', 'MLI', '466', '223');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('MT', 'Malta', 'MLT', '470', '356');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('MH', 'Marshall Islands', 'MHL', '584', '692');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('MQ', 'Martinique', 'MTQ', '474', '596');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('MR', 'Mauritania', 'MRT', '478', '222');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('MU', 'Mauritius', 'MUS', '480', '230');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('YT', 'Mayotte', null, null, '269');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('MX', 'Mexico', 'MEX', '484', '52');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('FM', 'Micronesia, Federated States of', 'FSM', '583', '691');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('MD', 'Moldova, Republic of', 'MDA', '498', '373');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('MC', 'Monaco', 'MCO', '492', '377');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('MN', 'Mongolia', 'MNG', '496', '976');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('MS', 'Montserrat', 'MSR', '500', '1664');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('MA', 'Morocco', 'MAR', '504', '212');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('MZ', 'Mozambique', 'MOZ', '508', '258');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('MM', 'Myanmar', 'MMR', '104', '95');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('NA', 'Namibia', 'NAM', '516', '264');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('NR', 'Nauru', 'NRU', '520', '674');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('NP', 'Nepal', 'NPL', '524', '977');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('NL', 'Netherlands', 'NLD', '528', '31');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('AN', 'Netherlands Antilles', 'ANT', '530', '599');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('NC', 'New Caledonia', 'NCL', '540', '687');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('NZ', 'New Zealand', 'NZL', '554', '64');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('NI', 'Nicaragua', 'NIC', '558', '505');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('NE', 'Niger', 'NER', '562', '227');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('NG', 'Nigeria', 'NGA', '566', '234');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('NU', 'Niue', 'NIU', '570', '683');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('NF', 'Norfolk Island', 'NFK', '574', '672');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('MP', 'Northern Mariana Islands', 'MNP', '580', '1670');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('NO', 'Norway', 'NOR', '578', '47');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('OM', 'Oman', 'OMN', '512', '968');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('PK', 'Pakistan', 'PAK', '586', '92');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('PW', 'Palau', 'PLW', '585', '680');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('PS', 'Palestinian Territory, Occupied', null, null, '970');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('PA', 'Panama', 'PAN', '591', '507');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('PG', 'Papua New Guinea', 'PNG', '598', '675');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('PY', 'Paraguay', 'PRY', '600', '595');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('PE', 'Peru', 'PER', '604', '51');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('PH', 'Philippines', 'PHL', '608', '63');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('PN', 'Pitcairn', 'PCN', '612', '0');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('PL', 'Poland', 'POL', '616', '48');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('PT', 'Portugal', 'PRT', '620', '351');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('PR', 'Puerto Rico', 'PRI', '630', '1787');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('QA', 'Qatar', 'QAT', '634', '974');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('RE', 'Reunion', 'REU', '638', '262');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('RO', 'Romania', 'ROM', '642', '40');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('RU', 'Russian Federation', 'RUS', '643', '70');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('RW', 'Rwanda', 'RWA', '646', '250');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('SH', 'Saint Helena', 'SHN', '654', '290');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('KN', 'Saint Kitts and Nevis', 'KNA', '659', '1869');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('LC', 'Saint Lucia', 'LCA', '662', '1758');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('PM', 'Saint Pierre and Miquelon', 'SPM', '666', '508');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('VC', 'Saint Vincent and the Grenadines', 'VCT', '670', '1784');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('WS', 'Samoa', 'WSM', '882', '684');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('SM', 'San Marino', 'SMR', '674', '378');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('ST', 'Sao Tome and Principe', 'STP', '678', '239');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('SA', 'Saudi Arabia', 'SAU', '682', '966');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('SN', 'Senegal', 'SEN', '686', '221');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('CS', 'Serbia and Montenegro', null, null, '381');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('SC', 'Seychelles', 'SYC', '690', '248');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('SL', 'Sierra Leone', 'SLE', '694', '232');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('SG', 'Singapore', 'SGP', '702', '65');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('SK', 'Slovakia', 'SVK', '703', '421');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('SI', 'Slovenia', 'SVN', '705', '386');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('SB', 'Solomon Islands', 'SLB', '90', '677');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('SO', 'Somalia', 'SOM', '706', '252');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('ZA', 'South Africa', 'ZAF', '710', '27');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('GS', 'South Georgia and the South Sandwich Islands', null, null, '0');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('ES', 'Spain', 'ESP', '724', '34');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('LK', 'Sri Lanka', 'LKA', '144', '94');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('SD', 'Sudan', 'SDN', '736', '249');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('SR', 'Suriname', 'SUR', '740', '597');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('SJ', 'Svalbard and Jan Mayen', 'SJM', '744', '47');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('SZ', 'Swaziland', 'SWZ', '748', '268');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('SE', 'Sweden', 'SWE', '752', '46');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('CH', 'Switzerland', 'CHE', '756', '41');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('SY', 'Syrian Arab Republic', 'SYR', '760', '963');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('TW', 'Taiwan, Province of China', 'TWN', '158', '886');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('TJ', 'Tajikistan', 'TJK', '762', '992');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('TZ', 'Tanzania, United Republic of', 'TZA', '834', '255');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('TH', 'Thailand', 'THA', '764', '66');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('TL', 'Timor-Leste', null, null, '670');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('TG', 'Togo', 'TGO', '768', '228');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('TK', 'Tokelau', 'TKL', '772', '690');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('TO', 'Tonga', 'TON', '776', '676');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('TT', 'Trinidad and Tobago', 'TTO', '780', '1868');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('TN', 'Tunisia', 'TUN', '788', '216');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('TR', 'Turkey', 'TUR', '792', '90');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('TM', 'Turkmenistan', 'TKM', '795', '7370');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('TC', 'Turks and Caicos Islands', 'TCA', '796', '1649');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('TV', 'Tuvalu', 'TUV', '798', '688');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('UG', 'Uganda', 'UGA', '800', '256');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('UA', 'Ukraine', 'UKR', '804', '380');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('AE', 'United Arab Emirates', 'ARE', '784', '971');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('GB', 'United Kingdom', 'GBR', '826', '44');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('US', 'United States', 'USA', '840', '1');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('UM', 'United States Minor Outlying Islands', null, null, '1');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('UY', 'Uruguay', 'URY', '858', '598');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('UZ', 'Uzbekistan', 'UZB', '860', '998');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('VU', 'Vanuatu', 'VUT', '548', '678');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('VE', 'Venezuela', 'VEN', '862', '58');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('VN', 'Viet Nam', 'VNM', '704', '84');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('VG', 'Virgin Islands, British', 'VGB', '92', '1284');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('VI', 'Virgin Islands, U.s.', 'VIR', '850', '1340');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('WF', 'Wallis and Futuna', 'WLF', '876', '681');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('EH', 'Western Sahara', 'ESH', '732', '212');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('YE', 'Yemen', 'YEM', '887', '967');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('ZM', 'Zambia', 'ZMB', '894', '260');
INSERT INTO countries (iso, name, iso3, num_code, phone_code) VALUES ('ZW', 'Zimbabwe', 'ZWE', '716', '263');
commit;