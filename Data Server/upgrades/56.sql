# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2018 Software Assurance Marketplace

# v1.32
use assessment;
drop PROCEDURE if exists upgrade_56;
DELIMITER $$
CREATE PROCEDURE upgrade_56 ()
  BEGIN
    declare script_version_no int;
    declare cur_db_version_no int;
    declare system_type varchar(200);
    set script_version_no = 56;

    select max(database_version_no)
      into cur_db_version_no
      from assessment.database_version;

    if cur_db_version_no < script_version_no then
      begin

        # system_type
        if not exists (select * from assessment.system_setting where system_setting_code = 'SYSTEM_TYPE') then
            insert into assessment.system_setting (system_setting_code, system_setting_value) values ('SYSTEM_TYPE', 'SWAMP_IN_A_BOX');
        end if;
        select system_setting_value
          into system_type
          from assessment.system_setting
         where system_setting_code = 'SYSTEM_TYPE';

        # Add column to table
        if exists (select * from information_schema.columns
                    where table_schema = 'tool_shed'
                      and table_name = 'tool'
                      and column_name = 'exclude_when_user_selects_all') then
            alter table tool_shed.tool drop column exclude_when_user_selects_all;
        end if;
        alter TABLE tool_shed.tool add column exclude_when_user_selects_all tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Exclude when user selects all tools: 0=false 1=true' after policy_code;

        # Add column to table
        if exists (select * from information_schema.columns
                    where table_schema = 'assessment'
                      and table_name = 'assessment_result'
                      and column_name = 'tool_uuid') then
            alter table assessment.assessment_result drop column tool_uuid;
        end if;
        alter TABLE assessment.assessment_result add column tool_uuid VARCHAR(45) COMMENT 'tool uuid' after package_version_uuid;

        # populate new field
        update assessment.assessment_result
           set tool_uuid = case when tool_version_uuid = '142e9a79-4425-11e4-a4f3-001a4a81450b' then '0f668fb0-4421-11e4-a4f3-001a4a81450b'
                                when tool_version_uuid = '1e288d3e-de82-11e6-bf70-001a4a81450b' then '0f668fb0-4421-11e4-a4f3-001a4a81450b'
                                when tool_version_uuid = 'c9126789-71d7-11e5-865f-001a4a81450b' then '0f668fb0-4421-11e4-a4f3-001a4a81450b'
                                when tool_version_uuid = 'db7b246f-1a3d-11e7-be48-001a4a81450b' then '0f668fb0-4421-11e4-a4f3-001a4a81450b'
                                when tool_version_uuid = 'e3d93d73-1a3d-11e7-be48-001a4a81450b' then '0f668fb0-4421-11e4-a4f3-001a4a81450b'
                                when tool_version_uuid = 'eae185c9-1a3d-11e7-be48-001a4a81450b' then '0f668fb0-4421-11e4-a4f3-001a4a81450b'
                                when tool_version_uuid = '163fe1e7-156e-11e3-a239-001a4a81450b' then '163d56a7-156e-11e3-a239-001a4a81450b'
                                when tool_version_uuid = '27ea7f63-a813-11e4-a335-001a4a81450b' then '163d56a7-156e-11e3-a239-001a4a81450b'
                                when tool_version_uuid = '4c1ec754-cb53-11e3-8775-001a4a81450b' then '163d56a7-156e-11e3-a239-001a4a81450b'
                                when tool_version_uuid = '9c48c4ad-e098-11e5-ae56-001a4a81450b' then '163d56a7-156e-11e3-a239-001a4a81450b'
                                when tool_version_uuid = '1c9a1589-bf05-11e5-832a-001a4a81450b' then '163e5d8c-156e-11e3-a239-001a4a81450b'
                                when tool_version_uuid = '7b504c42-bf06-11e5-832a-001a4a81450b' then '163e5d8c-156e-11e3-a239-001a4a81450b'
                                when tool_version_uuid = '950734d0-f59b-11e3-8775-001a4a81450b' then '163e5d8c-156e-11e3-a239-001a4a81450b'
                                when tool_version_uuid = 'b82a731e-7b79-11e6-88bc-001a4a81450b' then '163e5d8c-156e-11e3-a239-001a4a81450b'
                                when tool_version_uuid = 'b9045569-16cc-11e6-807f-001a4a81450b' then '163e5d8c-156e-11e3-a239-001a4a81450b'
                                when tool_version_uuid = 'e9cea65f-833e-11e5-865f-001a4a81450b' then '163e5d8c-156e-11e3-a239-001a4a81450b'
                                when tool_version_uuid = 'edef671e-7b79-11e6-88bc-001a4a81450b' then '163e5d8c-156e-11e3-a239-001a4a81450b'
                                when tool_version_uuid = '04be7ddc-e099-11e5-ae56-001a4a81450b' then '163f2b01-156e-11e3-a239-001a4a81450b'
                                when tool_version_uuid = '16414980-156e-11e3-a239-001a4a81450b' then '163f2b01-156e-11e3-a239-001a4a81450b'
                                when tool_version_uuid = '6a2a40d8-e281-11e6-bf70-001a4a81450b' then '163f2b01-156e-11e3-a239-001a4a81450b'
                                when tool_version_uuid = 'a2d949ef-cb53-11e3-8775-001a4a81450b' then '163f2b01-156e-11e3-a239-001a4a81450b'
                                when tool_version_uuid = 'bdaf4b93-a811-11e4-a335-001a4a81450b' then '163f2b01-156e-11e3-a239-001a4a81450b'
                                when tool_version_uuid = 'd75e97eb-77be-11e7-8228-001a4a81450b' then '163f2b01-156e-11e3-a239-001a4a81450b'
                                when tool_version_uuid = '68b0cb72-b741-11e6-bf70-001a4a81450b' then '3309c1e0-b741-11e6-bf70-001a4a81450b'
                                when tool_version_uuid = '6ea71506-b741-11e6-bf70-001a4a81450b' then '39001e1f-b741-11e6-bf70-001a4a81450b'
                                when tool_version_uuid = '749d3edd-b741-11e6-bf70-001a4a81450b' then '3ef639d4-b741-11e6-bf70-001a4a81450b'
                                when tool_version_uuid = '7a93738b-b741-11e6-bf70-001a4a81450b' then '44ec433d-b741-11e6-bf70-001a4a81450b'
                                when tool_version_uuid = '808990dd-b741-11e6-bf70-001a4a81450b' then '4ae25a9c-b741-11e6-bf70-001a4a81450b'
                                when tool_version_uuid = '0b384dc1-6441-11e4-a282-001a4a81450b' then '4bb2644d-6440-11e4-a282-001a4a81450b'
                                when tool_version_uuid = '3be08dd0-ce26-11e7-ad4c-001a4a81450b' then '4bb2644d-6440-11e4-a282-001a4a81450b'
                                when tool_version_uuid = '53fc0641-e094-11e5-ae56-001a4a81450b' then '4bb2644d-6440-11e4-a282-001a4a81450b'
                                when tool_version_uuid = '92e94ec4-bf07-11e5-832a-001a4a81450b' then '4bb2644d-6440-11e4-a282-001a4a81450b'
                                when tool_version_uuid = '867fa2de-b741-11e6-bf70-001a4a81450b' then '50d8714c-b741-11e6-bf70-001a4a81450b'
                                when tool_version_uuid = '68f4a0c7-72b2-11e5-865f-001a4a81450b' then '5540d2be-72b2-11e5-865f-001a4a81450b'
                                when tool_version_uuid = '13a1ceb5-e280-11e6-bf70-001a4a81450b' then '56872C2E-1D78-4DB0-B976-83ACF5424C52'
                                when tool_version_uuid = '4fcb04a8-e096-11e5-ae56-001a4a81450b' then '56872C2E-1D78-4DB0-B976-83ACF5424C52'
                                when tool_version_uuid = '51f1ca20-77be-11e7-8228-001a4a81450b' then '56872C2E-1D78-4DB0-B976-83ACF5424C52'
                                when tool_version_uuid = '5230FE76-E658-4B3A-AD40-7D55F7A21955' then '56872C2E-1D78-4DB0-B976-83ACF5424C52'
                                when tool_version_uuid = '8c75d607-b741-11e6-bf70-001a4a81450b' then '56ce7899-b741-11e6-bf70-001a4a81450b'
                                when tool_version_uuid = '6b5624a0-0946-11e5-b6a7-001a4a81450b' then '59612f24-0946-11e5-b6a7-001a4a81450b'
                                when tool_version_uuid = 'af736728-2078-11e7-be48-001a4a81450b' then '59612f24-0946-11e5-b6a7-001a4a81450b'
                                when tool_version_uuid = '927193af-b741-11e6-bf70-001a4a81450b' then '5cc49bb0-b741-11e6-bf70-001a4a81450b'
                                when tool_version_uuid = '932a2260-d9d5-11e6-bf70-001a4a81450b' then '5cc49bb0-b741-11e6-bf70-001a4a81450b'
                                when tool_version_uuid = '6b06aaa6-4053-11e5-83f1-001a4a81450b' then '5cd726a5-4053-11e5-83f1-001a4a81450b'
                                when tool_version_uuid = '9dbed035-2076-11e7-be48-001a4a81450b' then '5cd726a5-4053-11e5-83f1-001a4a81450b'
                                when tool_version_uuid = '18532f08-6441-11e4-a282-001a4a81450b' then '6197a593-6440-11e4-a282-001a4a81450b'
                                when tool_version_uuid = '8208695d-ce26-11e7-ad4c-001a4a81450b' then '6197a593-6440-11e4-a282-001a4a81450b'
                                when tool_version_uuid = '93334c42-e099-11e5-ae56-001a4a81450b' then '6197a593-6440-11e4-a282-001a4a81450b'
                                when tool_version_uuid = 'd08f0ae9-f69b-11e5-ae56-001a4a81450b' then '6197a593-6440-11e4-a282-001a4a81450b'
                                when tool_version_uuid = '9867c824-b741-11e6-bf70-001a4a81450b' then '62babae5-b741-11e6-bf70-001a4a81450b'
                                when tool_version_uuid = '0a01266d-de92-11e6-bf70-001a4a81450b' then '63695cd8-a73e-11e4-a335-001a4a81450b'
                                when tool_version_uuid = '1ad625bd-71d5-11e5-865f-001a4a81450b' then '63695cd8-a73e-11e4-a335-001a4a81450b'
                                when tool_version_uuid = '1ea7c676-1a3b-11e7-be48-001a4a81450b' then '63695cd8-a73e-11e4-a335-001a4a81450b'
                                when tool_version_uuid = 'bfcd605c-1a3b-11e7-be48-001a4a81450b' then '63695cd8-a73e-11e4-a335-001a4a81450b'
                                when tool_version_uuid = 'd2f762a9-1a3b-11e7-be48-001a4a81450b' then '63695cd8-a73e-11e4-a335-001a4a81450b'
                                when tool_version_uuid = 'fe360cd7-a7e3-11e4-a335-001a4a81450b' then '63695cd8-a73e-11e4-a335-001a4a81450b'
                                when tool_version_uuid = '8666e176-a828-11e5-865f-001a4a81450b' then '738b81f0-a828-11e5-865f-001a4a81450b'
                                when tool_version_uuid = '325CA868-0D19-4B00-B034-3786887541AA' then '7A08B82D-3A3B-45CA-8644-105088741AF6'
                                when tool_version_uuid = '2a16b653-7449-11e5-865f-001a4a81450b' then '7fbfa454-8f9f-11e4-829b-001a4a81450b'
                                when tool_version_uuid = '5f258cae-de8e-11e6-bf70-001a4a81450b' then '7fbfa454-8f9f-11e4-829b-001a4a81450b'
                                when tool_version_uuid = 'b46fdde3-162c-11e7-be48-001a4a81450b' then '7fbfa454-8f9f-11e4-829b-001a4a81450b'
                                when tool_version_uuid = 'd0bc9cdf-162c-11e7-be48-001a4a81450b' then '7fbfa454-8f9f-11e4-829b-001a4a81450b'
                                when tool_version_uuid = '66aac010-2077-11e7-be48-001a4a81450b' then '8157e489-1fbc-11e5-b6a7-001a4a81450b'
                                when tool_version_uuid = '7059b296-4c14-11e5-83f1-001a4a81450b' then '8157e489-1fbc-11e5-b6a7-001a4a81450b'
                                when tool_version_uuid = 'bcbfc7d7-1fbc-11e5-b6a7-001a4a81450b' then '8157e489-1fbc-11e5-b6a7-001a4a81450b'
                                when tool_version_uuid = '2f314dde-2069-11e7-be48-001a4a81450b' then '9289b560-8f8b-11e4-829b-001a4a81450b'
                                when tool_version_uuid = 'dcbdab3c-4d8b-11e5-83f1-001a4a81450b' then '9289b560-8f8b-11e4-829b-001a4a81450b'
                                when tool_version_uuid = '0667d30a-a7f0-11e4-a335-001a4a81450b' then '992A48A5-62EC-4EE9-8429-45BB94275A41'
                                when tool_version_uuid = '09449DE5-8E63-44EA-8396-23C64525D57C' then '992A48A5-62EC-4EE9-8429-45BB94275A41'
                                when tool_version_uuid = '62b9998b-77bd-11e7-8228-001a4a81450b' then '992A48A5-62EC-4EE9-8429-45BB94275A41'
                                when tool_version_uuid = 'b5115bdd-e095-11e5-ae56-001a4a81450b' then '992A48A5-62EC-4EE9-8429-45BB94275A41'
                                when tool_version_uuid = 'dde35138-e275-11e6-bf70-001a4a81450b' then '992A48A5-62EC-4EE9-8429-45BB94275A41'
                                when tool_version_uuid = 'ca1608e1-4057-11e5-83f1-001a4a81450b' then 'b9560648-4057-11e5-83f1-001a4a81450b'
                                when tool_version_uuid = 'fb13245e-2076-11e7-be48-001a4a81450b' then 'b9560648-4057-11e5-83f1-001a4a81450b'
                                when tool_version_uuid = 'd15ed849-ce25-11e7-ad4c-001a4a81450b' then 'd032d8ec-9184-11e6-88bc-001a4a81450b'
                                when tool_version_uuid = 'f9c00dd6-82a4-11e7-9baa-001a4a81450b' then 'e7a00759-82a4-11e7-9baa-001a4a81450b'
                                when tool_version_uuid = '067047b5-2078-11e7-be48-001a4a81450b' then 'ebcab7f6-0935-11e5-b6a7-001a4a81450b'
                                when tool_version_uuid = 'ea1f9693-46ac-11e5-83f1-001a4a81450b' then 'ebcab7f6-0935-11e5-b6a7-001a4a81450b'
                                when tool_version_uuid = 'f5c26a51-0935-11e5-b6a7-001a4a81450b' then 'ebcab7f6-0935-11e5-b6a7-001a4a81450b'
                                when tool_version_uuid = '2942ac9e-ce27-11e7-ad4c-001a4a81450b' then 'ed42d79c-ce26-11e7-ad4c-001a4a81450b'
                                when tool_version_uuid = '8ec206ff-f59b-11e3-8775-001a4a81450b' then 'f212557c-3050-11e3-9a3e-001a4a81450b'
                                when tool_version_uuid = '90554576-81a0-11e5-865f-001a4a81450b' then 'f212557c-3050-11e3-9a3e-001a4a81450b'
                                when tool_version_uuid = 'ea38477e-16cc-11e6-807f-001a4a81450b' then 'f212557c-3050-11e3-9a3e-001a4a81450b'
                                when tool_version_uuid = '16dac397-4c2e-11e5-83f1-001a4a81450b' then '0fac7ff8-4c2e-11e5-83f1-001a4a81450b'
                                when tool_version_uuid = '16dac397-4c2e-11e5-83f1-001a4a81450b' then '0fac7ff8-4c2e-11e5-83f1-001a4a81450b'
                                when tool_version_uuid = '32eb19f7-8f8c-11e4-829b-001a4a81450b' then '9289b560-8f8b-11e4-829b-001a4a81450b'
                                when tool_version_uuid = '37565211-e27f-11e6-bf70-001a4a81450b' then 'd032d8ec-9184-11e6-88bc-001a4a81450b'
                                when tool_version_uuid = '6c745d22-c184-11e3-8775-001a4a81450b' then '3491d5e3-c184-11e3-8775-001a4a81450b'
                                when tool_version_uuid = '9cbd0e60-8f9f-11e4-829b-001a4a81450b' then '7fbfa454-8f9f-11e4-829b-001a4a81450b'
                                when tool_version_uuid = 'e3466345-9184-11e6-88bc-001a4a81450b' then 'd032d8ec-9184-11e6-88bc-001a4a81450b'
                                else null end;
        # User added tools will still be null. Run update for remaining null values.
        update assessment.assessment_result ar
           set ar.tool_uuid = (select tv.tool_uuid from tool_shed.tool_version tv where tv.tool_version_uuid = ar.tool_version_uuid)
         where ar.tool_uuid is null;

        if (system_type = 'MIR_SWAMP') then
          # Remove Threadfix
          delete from tool_shed.tool_viewer_incompatibility where viewer_uuid = 'a0e1d0fb-bfb2-11e5-bf72-001a4a814413';
          delete from viewer_store.viewer_version           where viewer_uuid = 'a0e1d0fb-bfb2-11e5-bf72-001a4a814413';
          delete from viewer_store.viewer                   where viewer_uuid = 'a0e1d0fb-bfb2-11e5-bf72-001a4a814413';
        end if;

        # update database version number
        delete from assessment.database_version where database_version_no = script_version_no;
        insert into assessment.database_version (database_version_no, description) values (script_version_no, 'upgrade to v1.32');

        commit;
      end;
    end if;
END
$$
DELIMITER ;
