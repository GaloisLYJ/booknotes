--��ѯ�����Ƿ���������
select object_name, s.sid, s.serial#
from v$locked_object l,
     dba_objects o,
     v$session s
where l.object_id = o.object_id
  and l.session_id = s.sid;

--����� kill�� ����
alter system kill session 'sid,serial#';
alter system kill session '2197,50178' immediate;

--���û�з������������ȿ����Ƿ��н���ռ�û������������ѯ����ִ�е�sql���
SELECT b.sid      oracleID,
       b.username ��¼Oracle�û���,
       b.serial#,
       spid       ����ϵͳID,
       paddr,
       c.sql_text   ����ִ�е�SQL
FROM v$process a,
     v$session b,
     v$sqlarea c
WHERE a.addr = b.paddr
  AND b.sql_hash_value = c.hash_value
  and c.sql_text like '%VW_PERSON_INFO%';

drop materialized view VW_PERSON_INFO;

select * from V$MYSTAT;--��ѯ��ǰsid
select sid from V$MYSTAT where rownum=1;--6275

select * from V$SESSION where sid = '5454';
alter system kill session '5454,53104' immediate ;

grant select on V$MYSTAT to hr; --��ĳ��ϵͳ��ͼ�Ĳ鿴Ȩ�޸����û�hr

--���� ����ĳ����κţ�����Ĳ�λ�ţ���������кţ������״̬
select XIDUSN,XIDSLOT,XIDSQN,STATUS from V$TRANSACTION;

--��ѯ���sid�ϵ��� TYPE��TX ��������TM ������AE �ﻯ��ͼ��
select sid,type,id1,id2,decode(lmode,0,'None',1,'Null',2,'Row share',3,'Row Exclusive',4,'Share',5,'Share Row Exclusive',6,'Exclusive') lock_mode,
                        decode(request,0,'None',1,'Null',2,'Row share',3,'Row Exclusive',4,'Share',5,'Share Row Exclusive',6,'Exclusive') request_mode,block
from V$LOCK where TYPE = 'AE' and sid = '5454';
--block Ϊ2˵��������2�����sid����

/*
ID1 �ֶΣ�
���������м����� (DML Lock)��ID1 �����Ǳ�������Ķ���š�
���ڱ����� (DDL Lock)��ID1 ������������Ӱ��ı�Ķ���š�
���ڿ⼶���� (Library Lock)��ID1 ������������Ӱ��Ŀ����Ķ���š�

ID2 �ֶΣ�
���������м����� (DML Lock)��ID2 ������������Ӱ��������е����ݿ�ţ�block number����
���ڱ����� (DDL Lock)��ID2 ��������������Դ���͡���ͬ���͵�DDL�����ܻ��в�ͬ��ID2ֵ�����������ͣ����磬DDL_LOCK_TYPE����
���ڿ⼶���� (Library Lock)��ID2 ��������������Դ���ͻ�������ʶ����
*/

--�������鵽����������Ϣid1\id2����õ���Ӱ���sid
select sid,type,id1,id2,decode(lmode,0,'None',1,'Null',2,'Row share',3,'Row Exclusive',4,'Share',5,'Share Row Exclusive',6,'Exclusive') lock_mode,
                        decode(request,0,'None',1,'Null',2,'Row share',3,'Row Exclusive',4,'Share',5,'Share Row Exclusive',6,'Exclusive') request_mode,block
from V$LOCK where ID1='133' and ID2 = '0' and sid = '5454';

--��ѯv$enqueue_lock��������������е�session��Ϣ ������Ķ�����������AE�ﻯ��ͼ�������һ�����Ĺ�ϵ�ж��е�˳���ϵ
select sid,type,decode(request,0,'None',1,'Null',2,'Row share',3,'Row Exclusive',4,'Share',5,'Share Row Exclusive',6,'Exclusive') request_mode
from V$ENQUEUE_LOCK where SID in (
    select sid
    from V$LOCK where ID1='133' and ID2 = '0' and SID = '5454'
);

--��ѯ���ĳ��еȴ�ʱ�䣬����ʱ������ж�����û������
select a.sid blocker_sid,a.serial#,a.username as blocker_username,b.type,
       decode(b.lmode,0,'None',1,'Null',2,'Row share',3,'Row Exclusive',4,'Share',5,'Share Row Exclusive',6,'Exclusive') lock_mode,
       b.ctime as time_held,c.sid as watier_sid,
       decode(c.request,0,'None',1,'Null',2,'Row share',3,'Row Exclusive',4,'Share',5,'Share Row Exclusive',6,'Exclusive') request_mode,
       c.ctime time_waited
from V$LOCK b,V$ENQUEUE_LOCK c,V$SESSION a
where a.sid = b.sid and b.id1 = c.id1(+) and b.id2 = c.id2(+) and c.type(+)='AE' and b.type='AE' and b.block>0
and a.sid = '5454'
order by time_held desc,time_waited desc;

alter system kill session 'sid,serial';
alter system kill session '6749,27695' immediate ;
alter system kill session '1774,2677';

--ɾ�����ʼ�ĵ���ae����sid�ػ�������ִ���ﻯ��ͼ��䣬�Ѿ����Գɹ�������ˣ�˳���뼶ִ����ϣ�����������
drop materialized view VW_PERSON_INFO;

--д������ִ�еĽű� ɱ���ȴ���sid
select 'alter system kill session ''' || t1.watier_sid || ',' || t2.SERIAL# || '''' || ' IMMEDIATE;' from
(select a.sid blocker_sid,a.serial#,a.username as blocker_username,b.type,
       decode(b.lmode,0,'None',1,'Null',2,'Row share',3,'Row Exclusive',4,'Share',5,'Share Row Exclusive',6,'Exclusive') lock_mode,
       b.ctime as time_held,c.sid as watier_sid,
       decode(c.request,0,'None',1,'Null',2,'Row share',3,'Row Exclusive',4,'Share',5,'Share Row Exclusive',6,'Exclusive') request_mode,
       c.ctime time_waited
from V$LOCK b,V$ENQUEUE_LOCK c,V$SESSION a
where a.sid = b.sid and b.id1 = c.id1(+) and b.id2 = c.id2(+) and c.type(+)='AE' and b.type='AE' and b.block>0
and a.sid = c.sid
order by time_held desc,time_waited desc) t1
left join V$SESSION t2
on t1.watier_sid = t2.sid;

--�õ������������sid4466,��ѯ���session����Ϣ 5545 23849
select * from V$SESSION where sid = '5545';
select 'kill -9 '|| p.spid from v$session s, v$process p
where s.paddr = p.addr and s.SID='5545' and s.SERIAL#='23849';

--ͨ����������sql
select * from dba_ddl_locks where OWNER = 'BYDHRZS' and NAME not in ('BYDHRZS');
select * from v$session where sid in ('5545');--����sql_id 2wgravju950ss
select * from v$sql where SQL_ID = '2wgravju950ss';--�ҵ�����sql
select * from V$SESSION where sid = '6588';
alter system kill session '6588,16322';
select * from V$SESSION where sid = '5545';
select 'kill -9 '|| p.spid from v$session s, v$process p
where s.paddr = p.addr and s.SID='6588' and s.SERIAL#='16322';

--�Ա���������в�ѯ
select l.session_id sid,
       s.serial#,
       l.locked_mode,
       l.oracle_username,
       l.os_user_name,
       s.machine,
       s.terminal,
       o.object_name,
       s.logon_time
from V$LOCKED_OBJECT l,all_objects o,V$SESSION s
where l.OBJECT_ID = o.OBJECT_ID and l.SESSION_ID = s.sid
order by sid,s.SERIAL#;
alter system kill session '2387,34354' immediate;


--�鿴����ﻯ��ͼ�ϵ�����
select *
    from ALL_IND_COLUMNS
where TABLE_OWNER='BYDHRZS'
    and TABLE_NAME='VW_PERSON_INFO'
order by INDEX_NAME, COLUMN_POSITION;
--INSERT INTO MY_TABLE(INDEX_OWNER, INDEX_NAME, TABLE_OWNER, TABLE_NAME, COLUMN_NAME, COLUMN_POSITION, COLUMN_LENGTH, CHAR_LENGTH, DESCEND) VALUES ('BYDHRZS', 'VW_PERSON_INFO', 'BYDHRZS', 'VW_PERSON_INFO', 'SYS_NC00075$', 1, 22, 0, 'ASC');
--INSERT INTO MY_TABLE(INDEX_OWNER, INDEX_NAME, TABLE_OWNER, TABLE_NAME, COLUMN_NAME, COLUMN_POSITION, COLUMN_LENGTH, CHAR_LENGTH, DESCEND) VALUES ('BYDHRZS', 'VW_PRS_A001001', 'BYDHRZS', 'VW_PERSON_INFO', 'A001001', 1, 1000, 1000, 'ASC');
--INSERT INTO MY_TABLE(INDEX_OWNER, INDEX_NAME, TABLE_OWNER, TABLE_NAME, COLUMN_NAME, COLUMN_POSITION, COLUMN_LENGTH, CHAR_LENGTH, DESCEND) VALUES ('BYDHRZS', 'VW_PRS_A001077', 'BYDHRZS', 'VW_PERSON_INFO', 'A001077', 1, 200, 200, 'ASC');
--INSERT INTO MY_TABLE(INDEX_OWNER, INDEX_NAME, TABLE_OWNER, TABLE_NAME, COLUMN_NAME, COLUMN_POSITION, COLUMN_LENGTH, CHAR_LENGTH, DESCEND) VALUES ('BYDHRZS', 'VW_PRS_A001214', 'BYDHRZS', 'VW_PERSON_INFO', 'A001214', 1, 200, 200, 'ASC');
--INSERT INTO MY_TABLE(INDEX_OWNER, INDEX_NAME, TABLE_OWNER, TABLE_NAME, COLUMN_NAME, COLUMN_POSITION, COLUMN_LENGTH, CHAR_LENGTH, DESCEND) VALUES ('BYDHRZS', 'VW_PRS_A001219', 'BYDHRZS', 'VW_PERSON_INFO', 'A001219', 1, 200, 200, 'ASC');
--INSERT INTO MY_TABLE(INDEX_OWNER, INDEX_NAME, TABLE_OWNER, TABLE_NAME, COLUMN_NAME, COLUMN_POSITION, COLUMN_LENGTH, CHAR_LENGTH, DESCEND) VALUES ('BYDHRZS', 'VW_PRS_A001705', 'BYDHRZS', 'VW_PERSON_INFO', 'A001705', 1, 200, 200, 'ASC');
--INSERT INTO MY_TABLE(INDEX_OWNER, INDEX_NAME, TABLE_OWNER, TABLE_NAME, COLUMN_NAME, COLUMN_POSITION, COLUMN_LENGTH, CHAR_LENGTH, DESCEND) VALUES ('BYDHRZS', 'VW_PRS_A001710', 'BYDHRZS', 'VW_PERSON_INFO', 'A001710', 1, 400, 400, 'ASC');
--INSERT INTO MY_TABLE(INDEX_OWNER, INDEX_NAME, TABLE_OWNER, TABLE_NAME, COLUMN_NAME, COLUMN_POSITION, COLUMN_LENGTH, CHAR_LENGTH, DESCEND) VALUES ('BYDHRZS', 'VW_PRS_A001730', 'BYDHRZS', 'VW_PERSON_INFO', 'A001730', 1, 200, 200, 'ASC');
--INSERT INTO MY_TABLE(INDEX_OWNER, INDEX_NAME, TABLE_OWNER, TABLE_NAME, COLUMN_NAME, COLUMN_POSITION, COLUMN_LENGTH, CHAR_LENGTH, DESCEND) VALUES ('BYDHRZS', 'VW_PRS_A001735', 'BYDHRZS', 'VW_PERSON_INFO', 'A001735', 1, 200, 200, 'ASC');
--INSERT INTO MY_TABLE(INDEX_OWNER, INDEX_NAME, TABLE_OWNER, TABLE_NAME, COLUMN_NAME, COLUMN_POSITION, COLUMN_LENGTH, CHAR_LENGTH, DESCEND) VALUES ('BYDHRZS', 'VW_PRS_A001735_FUN', 'BYDHRZS', 'VW_PERSON_INFO', 'SYS_NC00068$', 1, 22, 0, 'ASC');



--��λ����sql
SELECT b.sid      oracleID,
       b.username ��¼Oracle�û���,
       b.serial#,
       spid       ����ϵͳID,
       paddr,
       c.sql_text   ����ִ�е�SQL
FROM v$process a,
     v$session b,
     v$sqlarea c
WHERE a.addr = b.paddr
  AND b.sql_hash_value = c.hash_value and b.SID = '6092' and b.SERIAL# = '6661';

--���Ի�õ�TX�������ܸ����ɳ�ʼ������transactions�����������Ի�õȴ�TM�����ĸ������ɳ�ʼ������dml_locks����
select name,value from V$PARAMETER where name in ('transactions','dml_locks');
--dml_locks 33440 �����ݿ���������ͬʱ֧��33440����
--transactions 8360 �����ݿ���������ͬʱ֧��8360������
select resource_name as "R_N",current_utilization as "C_U",max_utilization as "M_U",initial_allocation as "I_U"
from V$RESOURCE_LIMIT where RESOURCE_NAME in ('transactions','dml_locks');--C_U����ǰ��M_U���������ﵽ�������ֵ��I_U���ֵ�������������ų���Դ����


--ҵ��sql ��Ϊ�ڱ��control���Ǳ��sid��
drop materialized view VW_PERSON_INFO;

--��� �Ự������ kill
declare
    begin
        for temp in (
            select a.sid blocker_sid,a.username as blocker_username,b.type,
                   decode(b.lmode,0,'None',1,'Null',2,'Row share',3,'Row Exclusive',4,'Share',5,'Share Row Exclusive',6,'Exclusive') lock_mode,
                   b.ctime as time_held,c.sid as watier_sid,d.SERIAL#,
                   decode(c.request,0,'None',1,'Null',2,'Row share',3,'Row Exclusive',4,'Share',5,'Share Row Exclusive',6,'Exclusive') request_mode,
                   c.ctime time_waited
            from V$LOCK b,V$ENQUEUE_LOCK c,V$SESSION a, V$SESSION d
            where a.username = 'BYDHRZS' and a.sid = b.sid and b.id1 = c.id1(+) and b.id2 = c.id2(+) and c.type(+)='AE' and b.type='AE' and b.block>0
            and a.sid = '6092' and c.SID = d.SID
            order by time_held desc,time_waited desc)
        loop
            DBMS_OUTPUT.put_line('alter system kill session '''||to_char(temp.watier_sid)||','||to_char(temp.SERIAL#)||''''||';');
        end loop;
end;

--�����ӡ̨����û��ӡ��䣬����ߵ�sql�ļ����һ����enabled DBMSOUTPUT

--���session�޷�kill����kill�߳�
select 'kill -9 '|| p.spid
from v$session s, v$process p
where s.paddr = p.addr
and s.SID='' and s.SERIAL#='';

--ҵ������ʱ
select * from SYS_PARAMETER where PARA_KEY like '%PEOPLE_ARCHIVES_%';

