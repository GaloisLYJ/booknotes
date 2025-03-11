
--coalesce �п�
select coalesce(null,0) as collect_result from dual;

--select to_char(add_months(sysdate, -1), 'YYYY-MM') from dual;
select to_char(add_months(current_date, -1), 'YYYY-MM') from dual;

--�л�ģʽschema
SET search_path TO ehr_sync;

--
set search_path  = ehr_rpt;

set search_path = ehr_sync;

set search_path = ehr_mid;
select sync_kb_wage_g_summary() from dual;
set search_path = ehr_rpt;
select sync_rpt_e0070() from dual;


select * from ehr_rpt.rpt_data_pms;
select count(1) from ehr_sync.bak_a001_history where set_date = '2024-01';
select * from pg_job;
select * from pg_job_proc;

--job��ʱ����
select CURRENT_TIMESTAMP;
select CURRENT_DATE;
select dbms_job.submit((select max(job_id)+1 from pg_job),'REFRESH MATERIALIZED VIEW ehr_sync.mv_cq_rate_day_tj',TRUNC(CURRENT_DATE + 1) + (1*60+5)/(24*60),'''1minute''::interval');
select dbms_job.run(1019);
select dbms_job.remove(1019);
select TRUNC(CURRENT_DATE) + (1*60+5)/(24*60) from dual;--�������ʱ��dbms_job�����ǵ�ǰʱ�䣬���
select TRUNC(CURRENT_DATE + 1) + (1*60+5)/(24*60) from dual;
select dbms_job.submit((select max(job_id)+1 from pg_job),'select backup() from dual',TRUNC(CURRENT_DATE+2) + (23*60+5)/(24*60),'''7day''::interval');
SET search_path TO ehr_bak;
select backup_all_tables_in_schema('ehr_rpt','null') from dual;
select backup_all_tables_in_schema('ehr_sync','') from dual;
select backup() from dual;
select backup_table('rpt_emp_cq_rate_tj_rate','rpt_emp_cq_rate_tj_rate','ehr_rpt') from dual;
select trim('') from dual;
select schema_name from information_schema.schemata;

--Ԥ������䣬��̬���ε���
prepare bak_schema_sql(text) as select backup_all_tables_in_schema($1,$2) from dual;
execute bak_schema_sql('ehr_rpt','');
deallocate bak_schema_sql;

--job��ʱ����ִ�����
select * from pg_job where job_id in ('1019');
--����ģʽ��ִ�е�sql����ѯjob��ʱ����ִ�����
select * from pg_job where job_id in (
    select distinct job_id from pg_job_proc g
    where 1=1
    --and what like '%MATER%'
    --and what like '%cq%'
    and exists(select 1 from pg_job p where p.job_id = g.job_id and p.nspname in ('ehr_rpt'))
);
select * from pg_job_proc where job_id in (1025,1026,1030,1031,1032,1033);
--����ģʽ��ѯjob��ʱ����ִ�����
select * from pg_job_proc where job_id in (select distinct pg_job.job_id from pg_job where nspname in ('ehr_bak'));
--interval ���������ͣ�ʱ���

--vastbase
--ֹͣ��ʱ����
select dbms_job.broken(1,true);
--�޸Ķ�ʱ���� 10�����汾��13�汾֧��
--select dbms_job.change(1,true);
--vastbase

--��job����ִ�У��ֹ����õ�����ִ�в������pg_job��ʱ����Ϣ
select dbms_job.run(1020) from dual;
select * from ehr_bak.sync_log order by create_time desc;
--1����job����ʹ�ú�������ִ�й��̲��ܴ��ϲ�������ʹ���Ƕ�׺���Ҳû��
--2����job����ʹ�ú�������ִ�й��̲����ñ���ƴ��sqlִ�У�ֻ��ִ��ֱ�ӵ�sql
--���ۣ�job����ʹ����Ҫ���εĺ���!!!job�в���ʹ�ñ���ƴ�ӵ�sql!!!job�в���Ƕ�׺�������!!!Ҳ������drop\create����ʾddl��䣬��turncate\insert����

--�Ƴ�job
select dbms_job.remove(1020) from dual;

--��ѯ�ֶ�ע��SQL
SELECT c.oid,col.table_schema, col.table_name, col.column_name, col.ordinal_position AS order, d.description
FROM information_schema.columns col
JOIN pg_class c ON c.relname = col.table_name
LEFT JOIN pg_description d ON d.objoid = c.oid AND d.objsubid = col.ordinal_position
WHERE 1=1
AND col.table_schema = 'ehr_mid'
AND d.description is not null
AND col.table_name in ('mv_org_info')
ORDER BY col.table_name, col.ordinal_position;

--��ѯ����ע��SQL ����ģʽ�����ѯ��r�����mv������ͼ (�Ż���Ĳ�ѯ��䣬�ܱ�֤��ı�����ܲ�ѯ�����)
select relname as tablename,coalesce( cast(obj_description(relfilenode,'pg_class') as varchar),g.description) as comment
from pg_class c join pg_namespace pn on c.relnamespace = pn.oid
left join pg_catalog.pg_description g on c.oid = g.objoid and g.objsubid = 0
where relkind in ('r','mv') and relname not like 'pg_%' and relname not like 'sql_%'
and relchecks = '0' --���˵��ֱ�
and pn.nspname in ('ehr_mid') --����schema
and relname not in ('sync_log') --���˲���Ҫ��ʾ�ı�
order by relname;
--�Ż�ǰ��ע�Ͳ�ѯ��䣬ʹ�������ڱ�����ʱ��鲻������ע��
/*select relname as tablename,cast(obj_description(relfilenode,'pg_class') as varchar) as comment
from pg_class c join pg_namespace pn on c.relnamespace = pn.oid
where relkind = 'r' and relname not like 'pg_%' and relname not like 'sql_%'
and relchecks = '0' --���˵��ֱ�
and pn.nspname in ('ehr_rpt') --����schema
and relname not in ('sync_log') --���˲���Ҫ��ʾ�ı�
order by relname;*/

--�ڴ洢���̡��������治��ʹ��ddl��䣬��drop�����ע����ϢҲɾ��
--ʹ��truncate������ݱ�delete�죬��Ϊtruncate��ddl��䣬��ddl�Ĳ㼶ȥ������ݣ�������ddl�Ľṹ������ע�ͻ���

--ʱ��ƫ��
select '2023-09-06 02:35:00.733852' at time zone '-8:00' from dual;

select CURRENT_TIMESTAMP;
select CURRENT_TIMESTAMP at time zone '-08:00' from dual;
select substr(CURRENT_TIMESTAMP at time zone '-08:00',0,19) from dual;
select * from pg_job_proc where what ~~ '%cq%';
select * from pg_job where job_id in ('1030','1031');




--��ѯ�����ʶ��oidΪ1259�ı�����һ��
select 1259::regclass;--pg_class


--postgresql�ǻ��ڲ���ʵ�ֵ������汾���ƣ���oracle��mysql�Ļع��β�ͬ������ɾ���ɵ��������ݣ��ռ�Ҳû�������ͷţ����ǽ���vaccum����������java����������ȥ����
--�ô�
--1������Ļع�����������ɣ�������������˶��ٲ���
--2�����ݿ��Խ��кܶ���£��������ORA-1555�Ĵ�������
--����
--1���ɰ汾������Ҫ����
--2���ɰ汾�����ݻᵼ�²�ѯ����һЩ



--���ݿ�������ͼ ���Բ�ѯ����ǰ�������е�SQL
select * from pg_stat_activity;
--�û���
select * from pg_stat_user_tables;
select * from pg_stat_user_functions;

--����Ĺ������ָ�������Ĵ���
--1���ر�С�ı����û��������������300�еı��Ӧ��������
--2��������������������ӵı������ӵ��ֶ���Ӧ�ý�������
--3������������where�־��еĴ���ֶ�Ӧ�ý�������
--4������������order by�Ӿ��е��ֶΣ�Ӧ�ý�������
--5������������group by�־��е��ֶΣ�Ӧ�ý�������
--6����������Ӧ����Ҫ��where���ϳ��֣����������ǵ��ֶ�����
--7������Ѿ������ˣ�A��B)������������ͨ���Ͳ�Ҫ�ٽ�A�ĵ��ֶ�������

--SQL�Ż�
--ͨ��Ӧ�ð�װpg_stat_statementschaj ,��¼������SQL����ִ��ͳ����Ϣ����װ�˲����Ҫ����һ�����ݿ⣬����ڽ����ݿ�֮���Ͱ�װ
--select max_time,query from pg_stat_statements order by max_time desc limit 10;
--�ҳ�ִ��ʱ�����10��SQL���
--select max_time,query from pg_stat_statements order by max_time desc limit 10;
--�ҳ�ִ�д�����Ƶ����10��SQL���


--postgresql��reutrning �﷨���Է����κ���
--create table test(id serial primary key, t text, tm timestamptz default now());
--insert into test(t) values('1111') returning id, tm;


--on duplicate key update ����oracle mssyql�е� merge into �﷨ P440

--���ݳ���������ݣ�����������0.1%��Ч�ʸ�
select * from ehr_sync.bak_a001_history tablesample system(0.1);
--select * from test01 where id%1000 = 1 Ч�ʵ�


--������ ���Ӹ���
--�����������ͬ����
select application_name,client_addr,state,sync_priority,sync_state from pg_stat_replication;
--������������첽��
select pid,state,client_addr,sync_priority,sync_state from pg_stat_replication;

select * from pg_stat_wal_receiver;


-----------------------------------------------------------start
--�û�����
select current_database;
select current_user;
select current_schema;

--�������û�(���û��Դ���¼Ȩ�ޣ��½�ɫ������¼Ȩ�ޣ�����֮��û���κ�����)
create user dev with password 'ehr_pg#dev122';
create role dev_role with password 'ehr_pg#dev122';



--Ȩ�޹���
--Ϊ�Ѵ����û�����database����Ȩ�� grant�Ǹ��� revoke���ջ�
--grant {{create|connect|temporary|temp}|all[ privileges]} on database hrdb to dev|public [with grant option];
grant all privileges on database hrdb to dev;
revoke all privileges on database hrdb from dev_bi2;
--Ϊ�Ѵ����û�����schema����Ȩ��
--grant all privileges on schema ehr_rpt to dev;
grant select on all tables in schema ehr_rpt to dev;
grant select on all tables in schema ehr_mid to dev;
grant create on schema ehr_mid to dev;
--Ϊ�Ѵ����û�����hrdb������Ȩ��
grant connect on database hrdb to dev;

create user dev_ehr with password 'ehr_pg#dev122';
grant select,update on all tables in schema ehr_rpt to dev_ehr;
grant select,update on all tables in schema ehr_mid to dev_ehr;
grant select,update on all tables in schema ehr_sync to dev_ehr;
grant select,update on all tables in schema ehr_bak to dev_ehr;

grant create on schema ehr_rpt to dev_ehr;
grant create on schema ehr_mid to dev_ehr;
grant create on schema ehr_sync to dev_ehr;
grant create on schema ehr_bak to dev_ehr;

grant create on schema ehr_rpt to dev_ehr;
grant create on schema ehr_mid to dev_ehr;
grant create on schema ehr_sync to dev_ehr;
grant create on schema ehr_bak to dev_ehr;

grant all on schema ehr_rpt to dev_ehr;
grant all on schema ehr_mid to dev_ehr;
grant all on schema ehr_sync to dev_ehr;
grant all on schema ehr_bak to dev_ehr;

drop user dev_ehr;

alter user dev_bi superuser createrole createdb replication;


grant delete on all tables in schema ehr_rpt to dev_ehr;
grant delete on all tables in schema ehr_mid to dev_ehr;
grant delete on all tables in schema ehr_sync to dev_ehr;
grant delete on all tables in schema ehr_bak to dev_ehr;

--�����������Ŀ��� dev_ehr ehr_pg#dev122
create user dev_bi with password 'dev_bi#ehr122';
grant select,update on all tables in schema ehr_bi to dev_ehr;
grant select,update on all tables in schema ehr_mid to dev_ehr;
grant select,update on all tables in schema ehr_sync to dev_ehr;
grant select,update on all tables in schema ehr_bak to dev_ehr;
revoke all privileges on database hrdb from dev_bi;
grant connect on database hrdb to dev_bi;
--
ALTER ROLE dev_ehr WITH NOSUPERUSER NOCREATEDB;

grant select on all tables in schema ehr_bi to dev_ehr;
grant select on all tables in schema ehr_mid to dev_ehr;
--Ϊ�Ѵ����û�����hrdb������Ȩ��
grant connect on database hrdb to dev_ehr;
alter database hrdb owner to grantor;

--ɾ��һ���û�
drop user dev_ehr;
select relname,relacl from pg_class where relname = 'rpt_c0011';
select nspname,nspacl from pg_namespace where nspname = 'ehr_bak';
revoke select on table ehr_bak.rpt_c0011 from dev_ehr;
revoke select on all tables in schema ehr_mid from dev_bi;
revoke all privileges on database "hrdb" from dev_ehr;

revoke usage on schema grantor from test1;
revoke select on pg_catalog.pg_roles from dev_ehr;
revoke select on pg_catalog.pg_database from dev_ehr;

reassign owned by dev_ehr to hr_test;
revoke all on schema ehr_bak from dev_ehr;

--ʵ�ʲ���Ч ʵ�ʸ�Ȩ Ҫô�����
grant select,update on all tables in schema ehr_bi to dev_bi;
grant select,update on all tables in schema ehr_mid to dev_bi;
grant select,update on all tables in schema ehr_sync to dev_bi;

--ʵ������Ч ʵ�ʸ�Ȩ Ҫô�����
grant all on schema ehr_bi to dev_bi;
grant all on schema ehr_mid to dev_bi;
grant all on schema ehr_sync to dev_bi;
grant all on schema ehr_bak to dev_bi;
grant usage on schema ehr_rpt to dev_bi;
revoke all on schema ehr_bi from dev_bi;

grant all on schema ehr_bi to hr;
grant all on schema ehr_mid to hr;
grant all on schema ehr_sync to hr;
grant all on schema ehr_bak to hr;

------------ Ȩ�޸��衢����ʵ�� ------------start
SELECT grantee, table_schema, table_name, string_agg(privilege_type, ', ') as privilege_type
FROM information_schema.role_table_grants
WHERE grantee = 'dev_bi' and privilege_type like '%SELECT%'
group by grantee, table_schema, table_name;

--�ջ�updateȨ��
revoke update on table ehr_mid.mv_cq_rate_tj_month_group_by_jt from dev_bi;

--�ջ�selectȨ��
revoke select on ehr_bi.bi_xc_0014 from dev_bi;

--����Ȩ��
grant select on ehr_bi.bi_xc_0023 to dev_bi;
grant select,update on ehr_bi.bi_xc_0006 to dev_bi;
revoke select on ehr_bi.bi_xc_0006 from dev_bi;

--��������Ȩ�ޣ����½�ѡ��CSV��������������ó����ű�
SELECT 'revoke update on table ' || table_schema || '.' || table_name || ' from dev_bi;'
FROM information_schema.role_table_grants
WHERE grantee = 'dev_bi' and privilege_type like '%UPDATE%'
group by grantee, table_schema, table_name;

--�����ʾû��schemaȨ�ޣ���Ҫ��������ʹ��Ȩ��
grant usage on schema ehr_sync to dev_bi;
------------ Ȩ�޸��衢����ʵ�� ------------end


--�ܲ���ehr_sync��ehr_mid��ehr_bi��ehr_bak�ĸ�schema
--jdbc:postgresql://10.17.6.122/hrdb
--�˺ţ�dev_bi
--���룺dev_bi#ehr122

--�����ʾ�˻�������������Ҫ����
--alter user dev_bi account unlock;
-----------------------------------------------------------end


---------------------start------------------------
--�����������Ŀ��� dev_ehr ehr_pg#dev122
create user dev_bi with password 'dev_bi#ehr122';
--�ܲ���ehr_sync��ehr_mid��ehr_bi��ehr_bak�ĸ�schema
--jdbc:postgresql://10.17.6.122/hrdb
--�˺ţ�dev_bi
--���룺dev_bi#ehr122

--������Ȩ��ָ���û�����dev_bi
grant select on ehr_bi.bi_h0001 to dev_bi;
grant select on ehr_bi.bi_xc_0002 to dev_bi;
grant select on ehr_bi.bi_xc_0003 to dev_bi;
grant select on ehr_bi.bi_h0001 to dev_bi;
grant select on ehr_bi.bi_h0002 to dev_bi;
grant select on ehr_bi.bi_h0003 to dev_bi;
grant select on ehr_bi.bi_yy_0002 to dev_bi;
grant select on ehr_bi.bi_yy_0003 to dev_bi;
grant select on ehr_bi.bi_yy_0004 to dev_bi;
grant select on ehr_bi.bi_yy_0005 to dev_bi;
grant select on ehr_bi.bi_xc_0005 to dev_bi;
grant select on ehr_bi.bi_yy_0006 to dev_bi;
grant select on ehr_bi.bi_yy_0006_01 to dev_bi;
grant select on ehr_bi.bi_yy_0007 to dev_bi;
grant select on ehr_bi.bi_yy_0008 to dev_bi;
grant select on ehr_bi.bi_org_flag_zz to dev_bi;

grant select on ehr_bi.bi_h0003 to dev_bi;
grant select on ehr_bi.bi_pms_org to dev_bi;
grant select on ehr_bi.bi_a0020 to dev_bi;
grant select on ehr_mid.mv_org_info to dev_bi;
grant select on ehr_rpt.rpt_emp_per_count_tj_rate to dev_bi;
grant select on ehr_mid.kb_work_area_info to dev_bi;
grant select on ehr_rpt.rpt_emp_per_count_tj_trend to dev_bi;
grant select,insert on ehr_bi.bi_yy_0008 to dev_bi;
--����ָ���������Ȩ��
revoke all privileges on ehr_bi.bi_yy_0001 from dev_bi;

--Ϊ�Ѵ����û�����hrdb������Ȩ��
grant connect on database hrdb to dev_bi;
alter database hrdb owner to grantor;
---------------------end---------------------------








-----------------------------------------------------------dblink
SELECT * FROM pg_extension WHERE extname = 'dblink';

SELECT version();
set search_path = hr;
SELECT dblink_get_connections();--postgresql���ݿ����

--������չ
CREATE EXTENSION dblink;
--��ִ��dblink_connect��������
SELECT dblink_connect('mycoon','hostaddr=172.16.103.92 port=6036 dbname=vastbase user=lst password=Bigdata@123');
--ִ��BEGIN����
SELECT dblink_exec('mycoon', 'BEGIN');
--ִ�����ݲ���
SELECT dblink_exec('mycoon', 'create table people(id int,info varchar(10))');
SELECT dblink_exec('mycoon', 'insert into people values(1,''foo'')');
SELECT dblink_exec('mycoon', 'insert into people values(2,''foo'')');
SELECT dblink_exec('mycoon', 'update people set info=''bar'' where id=1');
--ִ�������ύ
SELECT dblink_exec('mycoon', 'COMMIT');
--ִ�в�ѯ
SELECT * FROM dblink('mycoon','SELECT * FROM people') as testTable (id int,info varchar(10));
--�������
SELECT dblink_disconnect('mycoon');

set search_path = hr;
create  public  database  link  oradb2  connect  to  SYSTEM  identified  by  'root'
using  jdbc_fdw(
url  'jdbc:oracle:thin:@//172.16.103.104:1521/orcl',
jarfile  '/home/vastbase2/ojdbc7.jar'
);


-----------------------------------------------------------
--Ϊ�Ѵ����û�����schema����Ȩ��
--grant all privileges on schema ehr_rpt to dev;
grant select on all tables in schema ehr_rpt to hr;
grant select on all tables in schema ehr_mid to hr;
grant select on all tables in schema ehr_sync to hr;
-----------------------------------------------------------


-----------------------------------------------------------
--id����������ز���
select * from ehr_rpt.rpt_role_user order by id desc;
delete from ehr_rpt.rpt_role_user where id = 54;
INSERT INTO ehr_rpt.rpt_role_user (emp_no, emp_name, role_id, role_name, pms_level, fr_role_name, create_time, last_update_time, pms_flag, last_operator) VALUES ('551023', '����', 'FD5F84B9387902B6E0535B14090A0A6E', '(��)��ҵ�����¾���:һ��(�˵�)', '��ҵ��', '��ҵ�����¾���', '2023-10-18 15:40:01', '2023-10-18 15:40:01', 'eHR', 'admin');
alter table ehr_rpt.rpt_role_user add column id integer;
alter table ehr_rpt.rpt_role_user add CONSTRAINT role_user_id primary key (id);
create sequence role_user_id_seq start 54;
alter sequence role_user_id_seq start 54;
alter table ehr_rpt.rpt_role_user alter column id set default nextval('role_user_id_seq'::regclass);
-----------------------------------------------------------



--uuid֧�� �ͼ�����------------------------------------------
select sys_guid();
select sys_guid() from dual;
select uuid() from dual;
-----------------------------------------------------------
select * from pg_job_proc where job_id = '1059';

select * from pg_job where job_id = '1059';
select dbms_job.remove(1059) from dual;

--��ֹpid����
SELECT pg_cancel_backend(47734391117568)
FROM pg_stat_activity
WHERE state = 'active';



---�����ؽ�---
alter index idx_row rebuild concurrently;
reindex index concurrently idx_row;

select * from pg_job_proc where what like '%%';

--���մ洢�ռ�
--https://docs.vastdata.com.cn/zh/docs/VastbaseG100Ver2.2.10/doc/%E5%BC%80%E5%8F%91%E8%80%85%E6%8C%87%E5%8D%97/VACUUM.html
VACUUM;
--��һ��ִ��ʱ�� 1h23m160ms



-- ��ӿ����� ����Ų�sql
-- SHOW VARIABLES LIKE 'character%';
-- show engines;
-- SHOW VARIABLES LIKE 'collation_%';
-- 28:��collation_database����Ϊutf8_general_ci����(Ĭ�ϵ�)
-- 29:��collation_database����Ϊutf8_bin����
-- INSERT INTO MY_TABLE(Variable_name, Value) VALUES ('collation_connection', 'utf8mb4_general_ci');
-- INSERT INTO MY_TABLE(Variable_name, Value) VALUES ('collation_database', 'utf8_bin');
-- INSERT INTO MY_TABLE(Variable_name, Value) VALUES ('collation_server', 'utf8_general_ci');
-- �����ִ�Сд���ݵ�ʱ����Ҫ����������������һ�����frdb29�⣬����Ϊ��utf8_bin
-- ��Ϊ28û�г��������������ݣ�����utf8_general_ci���Գɹ�
-- mysql rds ��ߣ����Դ����ݿ�������桢���ݿ���桢�����ֱ�ȥ���ñ�����������


select version();


--hr�û���Ȩ��ʹ������sql����ѯָ���û�dev_bi����Щ��Ȩ��
SELECT grantee,table_schema,table_name,string_agg( privilege_type,', ' ) as privilege_type FROM information_schema.role_table_grants WHERE grantee='dev_bi' group by grantee,table_schema,table_name;


--������ݿ����ģʽ
select datname,datcompatibility from pg_database;
--PG ��postgresql
--B ��mysql
--A ��oracle