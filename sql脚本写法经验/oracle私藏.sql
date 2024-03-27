--1、如果需要创建全局 DBLink，则需要先确定用户有创建dblink的权限
select *
from USER_SYS_PRIVS
where PRIVILEGE like upper('%DTABAASE LINK%');
select *
from USER_SYS_PRIVS
where PRIVILEGE like upper('%UNLIMITED TABLESPACE%');

--2、如果没有，则需要使用sysdba角色给用户赋权
grant create public database link to dbusername;

--3、dblink
--第二种方法：直接配置
--如果创建dblink，必须使用system或sys用户，在database前加public
create /*public*/ database link dblink1
    connect to dbusername identified by dbpassword
    using '(DESCRIPTION=(ADDRESS_LIST =(ADDRESS =(PROTOCOL = TCP)(HOST = 192.168.0.1)(PORT = 1521)))(CONNECT_DATA = (SERVICE_NAME = orcl)))';

--我靠，需要用双引号引用密码
create public database link FR
    connect to hr identified by "Hr@2.13!1"
    using '(DESCRIPTION=(ADDRESS_LIST =(ADDRESS =(PROTOCOL = TCP)(HOST = 10.17.6.122)(PORT = 1521)))(CONNECT_DATA = (SERVICE_NAME = hrdb)))';
create public database link FR
    connect to dev identified by "ehr_pg#dev122"
    using '10.17.6.122/hrdb';
--create user dev with password 'ehr_pg#dev122';

create public database link FR
    connect to dev identified by "ehr_pg#dev122"
    using '(DESCRIPTION=(ADDRESS_LIST =(ADDRESS =(PROTOCOL = TCP)(HOST = 10.17.6.122)(PORT = 1521)))(CONNECT_DATA = (SERVICE_NAME = hrdb)))';


--数据库参数 global_name=true 时要求数据库链接名称跟远端数据库名称一样，数据库全局名称可以用以下命令查出
select *
from global_name;

--4、查询数据
--查询、删除和插入数据和操作本地的数据库是一样的，只不过表名需要写成 表名@dblink服务器 而已
--select * from 表名@数据库链接名

--5、删除dblink
drop /*public*/ database link dblink1;

--全局dblink
select *
from DBA_DB_LINKS
where DB_LINK = 'TMP';
--用户级dblink
select *
from USER_DB_LINKS
where DB_LINK = 'TMP';

--6、授权dblink
grant create public database link, create database link to myAccount;


--用例
select * from DBA_DB_LINKS where DB_LINK like '%FR%';
select * from "ehr_rpt"."rpt_org_info"@FR;
drop public database link FR;