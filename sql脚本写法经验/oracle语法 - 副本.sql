--�ﻯ��ͼ
select * from MV_CQ_RATE_DAY;
drop materialized view MV_CQ_RATE_DAY;
create materialized view MV_CQ_RATE_DAY
as
select sys_guid() as subId, --����
       businessGroup,
       businessDept,
       factory,
       dept,
       province,
       city,
       workPlace,
       empLevel,
       signInTime,
       count(1)                                                                                                      as payrolls,
       sum(case when atttype IN ('����', '�װ�') then 1 else 0 end)                                                   as dayattendanceNum,
       sum(case when atttype IN ('ҹ��') then 1 else 0 end)                                                           as nightattendanceNum, --ҹ���������
       sum(case when isSingIn = '00901' then 1 else 0 end)                                                           as attendanceNum,
       to_char(round(sum(case when isSingIn = '00901' then 1 else 0 end) / count(1) * 100, 2), 'fm999990.00') ||
       '%'                                                                                                           as attendanceOfPercent
from (select B.EMP_CYQ                                                                   as businessGroup,
             B.EMP_SYB                                                                   as businessDept,
             B.EMP_GC                                                                    AS FACTORY,
             B.EMP_BM                                                                    AS DEPT,
             A.A318205                                                                   as workPlace,
             L1_CODE_ITEM_NAME                                                           as province,
             L2_CODE_ITEM_NAME                                                           as city,
             case when A.A318204 IN ('02608', '02609', 'I', 'H') then 'IH' else 'G��' end as empLevel,
             A.A318201                                                                   as signInTime,
             A.A318209                                                                   as isSingIn,
             A.A318208                                                                   As atttype
      FROM A318 A
               LEFT JOIN MV_B001_ALL B ON A.A318206 = B.MIX_ORGID
               LEFT JOIN V_RPT_GZAREA C ON A.A318205 = C.L3_CODE_ITEM_ID
               LEFT JOIN B001 C ON C.ID = B.EMP_SYB
      WHERE 1 = 1
        and A318207 not in
            ('0135402487', '��ǲԱ��', '0135600462', 'CJ', '0135000323', '����', '0135433707', '����Ա��', '0135402489',
             '����֧Ԯ��', '013513', '���Ա��', '0135402484', '��ʱ��')
        and A318201 >= to_char(sysdate,'yyyy-MM-dd')
        and A318201 <= to_char(sysdate,'yyyy-MM-dd'))
where 1 = 1
group by businessGroup, businessDept, factory, dept, province, city, workPlace, empLevel, signInTime
order by signInTime desc, businessGroup, businessDept, workPlace;

--�ֹ�ˢ����ͼ
ALTER MATERIALIZED VIEW MV_CQ_RATE_DAY REFRESH COMPLETE;

--��ѯjob
select * from dba_jobs where what like '%CQ_RATE%';

--����job
declare job number;
    begin dbms_job.submit(job, 'DBMS_MVIEW.refresh(''BYDHRCS.MV_CQ_RATE_DAY'',''C'');',TRUNC(SYSDATE + 1) + (23*60+5)/(24*60),   'sysdate + 1');commit;
end;

declare job number;
    begin dbms_job.submit(job, 'PROC_CQ_RATE_DAY(to_char(sysdate,''yyyy-MM-dd''));',TRUNC(SYSDATE) + (23*60+5)/(24*60),   'sysdate + 1');commit;
end;
--oracle job interval
--1 oracle��job����ִ�����ż�����һ��ʱ��ڵ����ڣ����Ի��ۼ��ӳ٣���Ҫ��interval�� 'interval = sysdate + 1' д����д���£�'trunc(sysdate) = 25/24'
--��Ҫ����trunc�ضϱ��ֵ���+���������ʱ��

--ɾ��job
declare
  job_number NUMBER;
begin
  job_number := 50061;-- ��Ҫɾ������ҵ����ҵ�Ÿ�ֵ������
  dbms_job.remove(job_number);
  commit;
end;

--����job
begin
    --DBMS_MVIEW.refresh('BYDHRCS.MV_CQ_RATE_DAY','C'); �ȼ������ܲ����������У�����Ļ���ʱ���񴴽��ᱨʧ��
    dbms_job.run(422);
end;

--���ó�ʼʱ��
SELECT TRUNC(SYSDATE + 1) + (23*60+5)/(24*60) FROM DUAL;

--�洢�����﷨
create or replace PROCEDURE PROC_CQ_RATE_DAY(set_date in varchar2) is
    setDate varchar2(40);
BEGIN
    setDate := nvl(set_date,to_char(sysdate,'yyyy-MM-dd'));
    execute immediate 'truncate table CQ_RATE_DAY';
    insert into CQ_RATE_DAY
    select sys_guid() as subid, --����
           businessGroup,   --��ҵȺ
           businessDept,    --��ҵ��
           factory, --����
           dept,    --����
           country,     --��
           province,    --ʡ
           city,        --��
           area,        --��
           workPlace,   --������
           empLevel,    --����(G����IH)
           signInTime,  --����
           count(1)                                                                                                      as payrolls, --��ְ����
           sum(case when atttype IN ('����', '�װ�') then 1 else 0 end)                                                    as dayattendanceNum, --�װ��������
           sum(case when atttype IN ('ҹ��') then 1 else 0 end)                                                           as nightattendanceNum, --ҹ���������
           sum(case when isSingIn = '00901' then 1 else 0 end)                                                           as attendanceNum, --�ܳ�������
           to_char(round(sum(case when isSingIn = '00901' then 1 else 0 end) / count(1) * 100, 2), 'fm999990.00') ||
           '%'                                                                                                           as attendanceOfPercent --������
    from (select B.EMP_CYQ                                                                   as businessGroup,
                 B.EMP_SYB                                                                   as businessDept,
                 B.EMP_GC                                                                    as factory,
                 B.EMP_BM                                                                    as dept,
                 C.L0_CODE_ITEM_NAME                                                         as country,
                 C.L1_CODE_ITEM_NAME                                                         as province,
                 C.L2_CODE_ITEM_NAME                                                         as city,
                 S2.CODE_ITEM_NAME                                                           as area,
                 A.A318205                                                                   as workPlace,
                 case when A.A318204 IN ('02608', '02609', 'I', 'H') then 'IH' else 'G��' end as empLevel,
                 A.A318201                                                                   as signInTime,
                 A.A318209                                                                   as isSingIn,
                 A.A318208                                                                   as atttype
          from A318 A
                   LEFT JOIN MV_B001_ALL B on A.A318206 = B.MIX_ORGID
                   LEFT JOIN V_RPT_GZAREA C on A.A318205 = C.L3_CODE_ITEM_ID
                   LEFT JOIN SYS_CODE_ITEM S on S.CODE_ITEM_ID = A.A318205 and S.CODE_SET_ID = '3146'
                   LEFT JOIN SYS_CODE_ITEM S2 on S2.CODE_ITEM_ID = S.SUPER_ID and S2.CODE_SET_ID = '3146' and S2.USER_ITEM_ID is null
                   LEFT JOIN B001 C on C.ID = B.EMP_SYB
          where 1 = 1
            and A318207 not in
                ('0135402487', '��ǲԱ��', '0135600462', 'CJ', '0135000323', '����', '0135433707', '����Ա��', '0135402489',
                 '����֧Ԯ��', '013513', '���Ա��', '0135402484', '��ʱ��')
            and A318201 = setDate)
    where 1 = 1
    group by businessGroup, businessDept, factory, dept, country, province, city, area, workPlace, empLevel, signInTime
    order by signInTime desc, businessGroup, businessDept, workPlace;

    delete from CQ_RATE_DAY_ALL where signInTime = setDate;
    insert into CQ_RATE_DAY_ALL select * from CQ_RATE_DAY;
END;

call PROC_CQ_RATE_DAY('2023-09-05');
call PROC_CQ_RATE_DAY(to_char(sysdate,'yyyy-MM-dd'));
drop PROCEDURE PROC_CQ_RATE_DAY;


select * from A001 where A001735 = '1177811';

select A001735 from A001 where A001001 = '�ӽ���';--6969363



select * from WAGE_JZ_ROSTER;

select * from SYS_CODE_ITEM where CODE_ITEM_ID = '70021001';
select * from SYS_CODE_SET where SET_ID = '7002';



select * from rpt_sales_volume;

select * from SYS_INFO_SET where SET_ID = 'B244';--����G����Ϣ�Ӽ�
select * from SYS_INFO_SET where SET_ID = 'A276';--����G������Ӽ�

select * from BYDHRZS.MV_RPT_A7040_BASIC;
select * from BYDHRZS.MV_RPT_A7040_GU_BASIC;
select * from BYDHRZS.MV_RPT_A7040_HI_BASIC;

select * from CQ_7REST1_RATE_ALL;
select * from ALL_SCHEDULER_JOBS;
select * from ALL_SCHEDULER_JOBS where JOB_NAME like '%7%';
select * from USER_JOBS where what like '%CQ_7REST1%';
select * from USER_JOBS where what like '%CQ_RATE_DAY%';

