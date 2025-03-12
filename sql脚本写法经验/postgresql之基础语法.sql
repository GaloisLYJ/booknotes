
--coalesce 判空
select coalesce(null,0) as collect_result from dual;

--select to_char(add_months(sysdate, -1), 'YYYY-MM') from dual;
select to_char(add_months(current_date, -1), 'YYYY-MM') from dual;

--切换模式schema
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

--job定时任务
select CURRENT_TIMESTAMP;
select CURRENT_DATE;
select dbms_job.submit((select max(job_id)+1 from pg_job),'REFRESH MATERIALIZED VIEW ehr_sync.mv_cq_rate_day_tj',TRUNC(CURRENT_DATE + 1) + (1*60+5)/(24*60),'''1minute''::interval');
select dbms_job.run(1019);
select dbms_job.remove(1019);
select TRUNC(CURRENT_DATE) + (1*60+5)/(24*60) from dual;--用这个的时候dbms_job定的是当前时间，奇怪
select TRUNC(CURRENT_DATE + 1) + (1*60+5)/(24*60) from dual;
select dbms_job.submit((select max(job_id)+1 from pg_job),'select backup() from dual',TRUNC(CURRENT_DATE+2) + (23*60+5)/(24*60),'''7day''::interval');
SET search_path TO ehr_bak;
select backup_all_tables_in_schema('ehr_rpt','null') from dual;
select backup_all_tables_in_schema('ehr_sync','') from dual;
select backup() from dual;
select backup_table('rpt_emp_cq_rate_tj_rate','rpt_emp_cq_rate_tj_rate','ehr_rpt') from dual;
select trim('') from dual;
select schema_name from information_schema.schemata;

--预编译语句，动态传参调用
prepare bak_schema_sql(text) as select backup_all_tables_in_schema($1,$2) from dual;
execute bak_schema_sql('ehr_rpt','');
deallocate bak_schema_sql;

--job定时任务执行情况
select * from pg_job where job_id in ('1019');
--根据模式和执行的sql语句查询job定时任务执行情况
select * from pg_job where job_id in (
    select distinct job_id from pg_job_proc g
    where 1=1
    --and what like '%MATER%'
    --and what like '%cq%'
    and exists(select 1 from pg_job p where p.job_id = g.job_id and p.nspname in ('ehr_rpt'))
);
select * from pg_job_proc where job_id in (1025,1026,1030,1031,1032,1033);
--根据模式查询job定时任务执行情况
select * from pg_job_proc where job_id in (select distinct pg_job.job_id from pg_job where nspname in ('ehr_bak'));
--interval 是数据类型，时间段

--vastbase
--停止定时任务
select dbms_job.broken(1,true);
--修改定时任务 10补丁版本和13版本支持
--select dbms_job.change(1,true);
--vastbase

--让job立即执行，手工调用的立即执行不会更新pg_job的时间信息
select dbms_job.run(1020) from dual;
select * from ehr_bak.sync_log order by create_time desc;
--1、在job里面使用函数传递执行过程不能带上参数，即使外层嵌套函数也没用
--2、在job里面使用函数传递执行过程不能用变量拼接sql执行，只能执行直接的sql
--结论：job不能使用需要传参的函数!!!job中不能使用变量拼接的sql!!!job中不能嵌套函数调用!!!也不能用drop\create等显示ddl语句，而turncate\insert可以

--移除job
select dbms_job.remove(1020) from dual;

--查询字段注释SQL
SELECT c.oid,col.table_schema, col.table_name, col.column_name, col.ordinal_position AS order, d.description
FROM information_schema.columns col
JOIN pg_class c ON c.relname = col.table_name
LEFT JOIN pg_description d ON d.objoid = c.oid AND d.objsubid = col.ordinal_position
WHERE 1=1
AND col.table_schema = 'ehr_mid'
AND d.description is not null
AND col.table_name in ('mv_org_info')
ORDER BY col.table_name, col.ordinal_position;

--查询表名注释SQL 根据模式、表查询，r代表表，mv代表视图 (优化后的查询语句，能保证表的变更后还能查询出结果)
select relname as tablename,coalesce( cast(obj_description(relfilenode,'pg_class') as varchar),g.description) as comment
from pg_class c join pg_namespace pn on c.relnamespace = pn.oid
left join pg_catalog.pg_description g on c.oid = g.objoid and g.objsubid = 0
where relkind in ('r','mv') and relname not like 'pg_%' and relname not like 'sql_%'
and relchecks = '0' --过滤掉分表
and pn.nspname in ('ehr_mid') --过滤schema
and relname not in ('sync_log') --过滤不需要显示的表
order by relname;
--优化前的注释查询语句，使用这句会在表变更的时候查不出部分注释
/*select relname as tablename,cast(obj_description(relfilenode,'pg_class') as varchar) as comment
from pg_class c join pg_namespace pn on c.relnamespace = pn.oid
where relkind = 'r' and relname not like 'pg_%' and relname not like 'sql_%'
and relchecks = '0' --过滤掉分表
and pn.nspname in ('ehr_rpt') --过滤schema
and relname not in ('sync_log') --过滤不需要显示的表
order by relname;*/

--在存储过程、函数里面不宜使用ddl语句，如drop，会把注释信息也删掉
--使用truncate清空数据比delete快，因为truncate是ddl语句，在ddl的层级去清空数据，并保留ddl的结构，所以注释还在

--时区偏移
select '2023-09-06 02:35:00.733852' at time zone '-8:00' from dual;

select CURRENT_TIMESTAMP;
select CURRENT_TIMESTAMP at time zone '-08:00' from dual;
select substr(CURRENT_TIMESTAMP at time zone '-08:00',0,19) from dual;
select * from pg_job_proc where what ~~ '%cq%';
select * from pg_job where job_id in ('1030','1031');




--查询对象标识符oid为1259的表是哪一张
select 1259::regclass;--pg_class


--postgresql是基于插入实现的事务多版本控制，和oracle、mysql的回滚段不同，不会删除旧的事务数据，空间也没有立即释放，而是交给vaccum进程类似于java的垃圾回收去回收
--好处
--1、事务的回滚可以立即完成，无论事务进行了多少操作
--2、数据可以进行很多更新，不会产生ORA-1555的错误困扰
--劣势
--1、旧版本数据需要清理
--2、旧版本的数据会导致查询更慢一些



--数据库性能视图 可以查询出当前正在运行的SQL
select * from pg_stat_activity;
--用户表
select * from pg_stat_user_tables;
select * from pg_stat_user_functions;

--下面的规则可以指导索引的创建
--1、特别小的表可以没有索引，但超过300行的表就应该有索引
--2、经常与其他表进行连接的表，在连接的字段上应该建立索引
--3、经常出现在where字句中的大表字段应该建立索引
--4、经常出现在order by子句中的字段，应该建立索引
--5、经常出现在group by字句中的字段，应该建立索引
--6、联合索引应尽量要求where联合出现，否则尽量考虑单字段索引
--7、如果已经建立了（A、B)的联合索引，通常就不要再建A的单字段索引了

--SQL优化
--通常应该安装pg_stat_statementschaj ,记录了所有SQL语句的执行统计信息，安装此插件需要重启一次数据库，最好在建数据库之初就安装
--select max_time,query from pg_stat_statements order by max_time desc limit 10;
--找出执行时间最长的10条SQL语句
--select max_time,query from pg_stat_statements order by max_time desc limit 10;
--找出执行次数最频繁的10条SQL语句


--postgresql的reutrning 语法可以返回任何列
--create table test(id serial primary key, t text, tm timestamptz default now());
--insert into test(t) values('1111') returning id, tm;


--on duplicate key update 代替oracle mssyql中的 merge into 语法 P440

--数据抽样大表数据，抽样比例是0.1%，效率高
select * from ehr_sync.bak_a001_history tablesample system(0.1);
--select * from test01 where id%1000 = 1 效率低


--主备库 主从复制
--如果流复制是同步的
select application_name,client_addr,state,sync_priority,sync_state from pg_stat_replication;
--如果流复制是异步的
select pid,state,client_addr,sync_priority,sync_state from pg_stat_replication;

select * from pg_stat_wal_receiver;


-----------------------------------------------------------start
--用户管理
select current_database;
select current_user;
select current_schema;

--创建新用户(新用户自带登录权限，新角色不带登录权限，除此之外没有任何区别)
create user dev with password 'ehr_pg#dev122';
create role dev_role with password 'ehr_pg#dev122';



--权限管理
--为已创建用户授予database操作权限 grant是赋予 revoke是收回
--grant {{create|connect|temporary|temp}|all[ privileges]} on database hrdb to dev|public [with grant option];
grant all privileges on database hrdb to dev;
revoke all privileges on database hrdb from dev_bi2;
--为已创建用户授予schema操作权限
--grant all privileges on schema ehr_rpt to dev;
grant select on all tables in schema ehr_rpt to dev;
grant select on all tables in schema ehr_mid to dev;
grant create on schema ehr_mid to dev;
--为已创建用户授予hrdb的连接权限
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

--人力数据中心开发 dev_ehr ehr_pg#dev122
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
--为已创建用户授予hrdb的连接权限
grant connect on database hrdb to dev_ehr;
alter database hrdb owner to grantor;

--删除一个用户
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

--实际不生效 实际赋权 要么用这个
grant select,update on all tables in schema ehr_bi to dev_bi;
grant select,update on all tables in schema ehr_mid to dev_bi;
grant select,update on all tables in schema ehr_sync to dev_bi;

--实际能生效 实际赋权 要么用这个
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

------------ 权限赋予、回收实例 ------------start
SELECT grantee, table_schema, table_name, string_agg(privilege_type, ', ') as privilege_type
FROM information_schema.role_table_grants
WHERE grantee = 'dev_bi' and privilege_type like '%SELECT%'
group by grantee, table_schema, table_name;

--收回update权限
revoke update on table ehr_mid.mv_cq_rate_tj_month_group_by_jt from dev_bi;

--收回select权限
revoke select on ehr_bi.bi_xc_0014 from dev_bi;

--赋予权限
grant select on ehr_bi.bi_xc_0023 to dev_bi;
grant select,update on ehr_bi.bi_xc_0006 to dev_bi;
revoke select on ehr_bi.bi_xc_0006 from dev_bi;

--批量回收权限，右下角选择CSV，复制黏贴可以拿出来脚本
SELECT 'revoke update on table ' || table_schema || '.' || table_name || ' from dev_bi;'
FROM information_schema.role_table_grants
WHERE grantee = 'dev_bi' and privilege_type like '%UPDATE%'
group by grantee, table_schema, table_name;

--如果提示没有schema权限，需要单独赋予使用权限
grant usage on schema ehr_sync to dev_bi;
------------ 权限赋予、回收实例 ------------end


--能操作ehr_sync、ehr_mid、ehr_bi、ehr_bak四个schema
--jdbc:postgresql://10.17.6.122/hrdb
--账号：dev_bi
--密码：dev_bi#ehr122

--如果显示账户被锁定，则需要解锁
--alter user dev_bi account unlock;
-----------------------------------------------------------end


---------------------start------------------------
--人力数据中心开发 dev_ehr ehr_pg#dev122
create user dev_bi with password 'dev_bi#ehr122';
--能操作ehr_sync、ehr_mid、ehr_bi、ehr_bak四个schema
--jdbc:postgresql://10.17.6.122/hrdb
--账号：dev_bi
--密码：dev_bi#ehr122

--按表授权给指定用户，如dev_bi
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
--回收指定表的所有权限
revoke all privileges on ehr_bi.bi_yy_0001 from dev_bi;

--为已创建用户授予hrdb的连接权限
grant connect on database hrdb to dev_bi;
alter database hrdb owner to grantor;
---------------------end---------------------------








-----------------------------------------------------------dblink
SELECT * FROM pg_extension WHERE extname = 'dblink';

SELECT version();
set search_path = hr;
SELECT dblink_get_connections();--postgresql数据库才有

--创建扩展
CREATE EXTENSION dblink;
--先执行dblink_connect保持连接
SELECT dblink_connect('mycoon','hostaddr=172.16.103.92 port=6036 dbname=vastbase user=lst password=Bigdata@123');
--执行BEGIN命令
SELECT dblink_exec('mycoon', 'BEGIN');
--执行数据操作
SELECT dblink_exec('mycoon', 'create table people(id int,info varchar(10))');
SELECT dblink_exec('mycoon', 'insert into people values(1,''foo'')');
SELECT dblink_exec('mycoon', 'insert into people values(2,''foo'')');
SELECT dblink_exec('mycoon', 'update people set info=''bar'' where id=1');
--执行事务提交
SELECT dblink_exec('mycoon', 'COMMIT');
--执行查询
SELECT * FROM dblink('mycoon','SELECT * FROM people') as testTable (id int,info varchar(10));
--解除连接
SELECT dblink_disconnect('mycoon');

set search_path = hr;
create  public  database  link  oradb2  connect  to  SYSTEM  identified  by  'root'
using  jdbc_fdw(
url  'jdbc:oracle:thin:@//172.16.103.104:1521/orcl',
jarfile  '/home/vastbase2/ojdbc7.jar'
);


-----------------------------------------------------------
--为已创建用户授予schema操作权限
--grant all privileges on schema ehr_rpt to dev;
grant select on all tables in schema ehr_rpt to hr;
grant select on all tables in schema ehr_mid to hr;
grant select on all tables in schema ehr_sync to hr;
-----------------------------------------------------------


-----------------------------------------------------------
--id自增序列相关操作
select * from ehr_rpt.rpt_role_user order by id desc;
delete from ehr_rpt.rpt_role_user where id = 54;
INSERT INTO ehr_rpt.rpt_role_user (emp_no, emp_name, role_id, role_name, pms_level, fr_role_name, create_time, last_update_time, pms_flag, last_operator) VALUES ('551023', '刘丹', 'FD5F84B9387902B6E0535B14090A0A6E', '(新)事业部人事经理:一类(菜单)', '事业部', '事业部人事经理', '2023-10-18 15:40:01', '2023-10-18 15:40:01', 'eHR', 'admin');
alter table ehr_rpt.rpt_role_user add column id integer;
alter table ehr_rpt.rpt_role_user add CONSTRAINT role_user_id primary key (id);
create sequence role_user_id_seq start 54;
alter sequence role_user_id_seq start 54;
alter table ehr_rpt.rpt_role_user alter column id set default nextval('role_user_id_seq'::regclass);
-----------------------------------------------------------



--uuid支持 和兼容性------------------------------------------
select sys_guid();
select sys_guid() from dual;
select uuid() from dual;
-----------------------------------------------------------
select * from pg_job_proc where job_id = '1059';

select * from pg_job where job_id = '1059';
select dbms_job.remove(1059) from dual;

--终止pid任务
SELECT pg_cancel_backend(47734391117568)
FROM pg_stat_activity
WHERE state = 'active';



---索引重建---
alter index idx_row rebuild concurrently;
reindex index concurrently idx_row;

select * from pg_job_proc where what like '%%';

--回收存储空间
--https://docs.vastdata.com.cn/zh/docs/VastbaseG100Ver2.2.10/doc/%E5%BC%80%E5%8F%91%E8%80%85%E6%8C%87%E5%8D%97/VACUUM.html
VACUUM;
--第一次执行时间 1h23m160ms



-- 外接库配置 相关排查sql
-- SHOW VARIABLES LIKE 'character%';
-- show engines;
-- SHOW VARIABLES LIKE 'collation_%';
-- 28:把collation_database设置为utf8_general_ci即可(默认的)
-- 29:把collation_database设置为utf8_bin即可
-- INSERT INTO MY_TABLE(Variable_name, Value) VALUES ('collation_connection', 'utf8mb4_general_ci');
-- INSERT INTO MY_TABLE(Variable_name, Value) VALUES ('collation_database', 'utf8_bin');
-- INSERT INTO MY_TABLE(Variable_name, Value) VALUES ('collation_server', 'utf8_general_ci');
-- 当出现大小写数据的时候，需要特殊配置排序规则，右击整个frdb29库，设置为：utf8_bin
-- 因为28没有出现这种特殊数据，所以utf8_general_ci可以成功
-- mysql rds 这边，可以从数据库软件层面、数据库层面、表层面分别去设置编码和排序规则


select version();


--hr用户有权限使用以下sql，查询指定用户dev_bi有哪些表权限
SELECT grantee,table_schema,table_name,string_agg( privilege_type,', ' ) as privilege_type FROM information_schema.role_table_grants WHERE grantee='dev_bi' group by grantee,table_schema,table_name;


--检查数据库兼容模式
select datname,datcompatibility from pg_database;
--PG 是postgresql
--B 是mysql
--A 是oracle