--1�������Ҫ����ȫ�� DBLink������Ҫ��ȷ���û��д���dblink��Ȩ��
select *
from USER_SYS_PRIVS
where PRIVILEGE like upper('%DTABAASE LINK%');
select *
from USER_SYS_PRIVS
where PRIVILEGE like upper('%UNLIMITED TABLESPACE%');

--2�����û�У�����Ҫʹ��sysdba��ɫ���û���Ȩ
grant create public database link to dbusername;

--3��dblink
--�ڶ��ַ�����ֱ������
--�������dblink������ʹ��system��sys�û�����databaseǰ��public
create /*public*/ database link dblink1
    connect to dbusername identified by dbpassword
    using '(DESCRIPTION=(ADDRESS_LIST =(ADDRESS =(PROTOCOL = TCP)(HOST = 192.168.0.1)(PORT = 1521)))(CONNECT_DATA = (SERVICE_NAME = orcl)))';

--�ҿ�����Ҫ��˫������������
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


--���ݿ���� global_name=true ʱҪ�����ݿ��������Ƹ�Զ�����ݿ�����һ�������ݿ�ȫ�����ƿ���������������
select *
from global_name;

--4����ѯ����
--��ѯ��ɾ���Ͳ������ݺͲ������ص����ݿ���һ���ģ�ֻ����������Ҫд�� ����@dblink������ ����
--select * from ����@���ݿ�������

--5��ɾ��dblink
drop /*public*/ database link dblink1;

--ȫ��dblink
select *
from DBA_DB_LINKS
where DB_LINK = 'TMP';
--�û���dblink
select *
from USER_DB_LINKS
where DB_LINK = 'TMP';

--6����Ȩdblink
grant create public database link, create database link to myAccount;


--����
select * from DBA_DB_LINKS where DB_LINK like '%FR%';
select * from "ehr_rpt"."rpt_org_info"@FR;
drop public database link FR;