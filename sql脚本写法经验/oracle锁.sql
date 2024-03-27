--查询表上是否发生了死锁
select object_name, s.sid, s.serial#
from v$locked_object l,
     dba_objects o,
     v$session s
where l.object_id = o.object_id
  and l.session_id = s.sid;

--如果有 kill掉 进程
alter system kill session 'sid,serial#';
alter system kill session '2197,50178' immediate;

--如果没有发生死锁，优先考虑是否有进程占用或挂起的情况，查询正在执行的sql语句
SELECT b.sid      oracleID,
       b.username 登录Oracle用户名,
       b.serial#,
       spid       操作系统ID,
       paddr,
       c.sql_text   正在执行的SQL
FROM v$process a,
     v$session b,
     v$sqlarea c
WHERE a.addr = b.paddr
  AND b.sql_hash_value = c.hash_value
  and c.sql_text like '%VW_PERSON_INFO%';

drop materialized view VW_PERSON_INFO;

select * from V$MYSTAT;--查询当前sid
select sid from V$MYSTAT where rownum=1;--6275

select * from V$SESSION where sid = '5454';
alter system kill session '5454,53104' immediate ;

grant select on V$MYSTAT to hr; --把某个系统视图的查看权限赋给用户hr

--事务 事务的撤销段号，事务的槽位号，事务的序列号，事务的状态
select XIDUSN,XIDSLOT,XIDSQN,STATUS from V$TRANSACTION;

--查询这个sid上的锁 TYPE：TX 事务锁，TM 表锁，AE 物化视图锁
select sid,type,id1,id2,decode(lmode,0,'None',1,'Null',2,'Row share',3,'Row Exclusive',4,'Share',5,'Share Row Exclusive',6,'Exclusive') lock_mode,
                        decode(request,0,'None',1,'Null',2,'Row share',3,'Row Exclusive',4,'Share',5,'Share Row Exclusive',6,'Exclusive') request_mode,block
from V$LOCK where TYPE = 'AE' and sid = '5454';
--block 为2说明阻塞了2个别的sid任务

/*
ID1 字段：
对于数据行级锁定 (DML Lock)，ID1 可能是表或表分区的对象号。
对于表级锁定 (DDL Lock)，ID1 可能是受锁定影响的表的对象号。
对于库级锁定 (Library Lock)，ID1 可能是受锁定影响的库对象的对象号。

ID2 字段：
对于数据行级锁定 (DML Lock)，ID2 可能是受锁定影响的数据行的数据块号（block number）。
对于表级锁定 (DDL Lock)，ID2 可能是锁定的资源类型。不同类型的DDL锁可能会有不同的ID2值，如锁定类型（例如，DDL_LOCK_TYPE）。
对于库级锁定 (Library Lock)，ID2 可能是锁定的资源类型或其他标识符。
*/

--将上述查到的锁区域信息id1\id2代入得到受影响的sid
select sid,type,id1,id2,decode(lmode,0,'None',1,'Null',2,'Row share',3,'Row Exclusive',4,'Share',5,'Share Row Exclusive',6,'Exclusive') lock_mode,
                        decode(request,0,'None',1,'Null',2,'Row share',3,'Row Exclusive',4,'Share',5,'Share Row Exclusive',6,'Exclusive') request_mode,block
from V$LOCK where ID1='133' and ID2 = '0' and sid = '5454';

--查询v$enqueue_lock来获得锁定队列中的session信息 查出来的东西都在请求AE物化视图锁，而且获得锁的关系有队列的顺序关系
select sid,type,decode(request,0,'None',1,'Null',2,'Row share',3,'Row Exclusive',4,'Share',5,'Share Row Exclusive',6,'Exclusive') request_mode
from V$ENQUEUE_LOCK where SID in (
    select sid
    from V$LOCK where ID1='133' and ID2 = '0' and SID = '5454'
);

--查询锁的持有等待时间，有了时间就能判断锁有没有问题
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

--删掉最初始的导致ae锁的sid回话后重新执行物化视图语句，已经可以成功获得锁了，顺利秒级执行完毕，至此问题解决
drop materialized view VW_PERSON_INFO;

--写成批量执行的脚本 杀死等待的sid
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

--得到最初的阻塞的sid4466,查询这个session的信息 5545 23849
select * from V$SESSION where sid = '5545';
select 'kill -9 '|| p.spid from v$session s, v$process p
where s.paddr = p.addr and s.SID='5545' and s.SERIAL#='23849';

--通过锁找问题sql
select * from dba_ddl_locks where OWNER = 'BYDHRZS' and NAME not in ('BYDHRZS');
select * from v$session where sid in ('5545');--问题sql_id 2wgravju950ss
select * from v$sql where SQL_ID = '2wgravju950ss';--找到问题sql
select * from V$SESSION where sid = '6588';
alter system kill session '6588,16322';
select * from V$SESSION where sid = '5545';
select 'kill -9 '|| p.spid from v$session s, v$process p
where s.paddr = p.addr and s.SID='6588' and s.SERIAL#='16322';

--对被锁对象进行查询
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


--查看表或物化视图上的索引
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



--定位问题sql
SELECT b.sid      oracleID,
       b.username 登录Oracle用户名,
       b.serial#,
       spid       操作系统ID,
       paddr,
       c.sql_text   正在执行的SQL
FROM v$process a,
     v$session b,
     v$sqlarea c
WHERE a.addr = b.paddr
  AND b.sql_hash_value = c.hash_value and b.SID = '6092' and b.SERIAL# = '6661';

--可以获得的TX锁定的总个数由初始化参数transactions决定，而可以获得等待TM锁定的个数则由初始化参数dml_locks决定
select name,value from V$PARAMETER where name in ('transactions','dml_locks');
--dml_locks 33440 对数据库来讲可以同时支持33440个锁
--transactions 8360 对数据库来讲可以同时支持8360个事务
select resource_name as "R_N",current_utilization as "C_U",max_utilization as "M_U",initial_allocation as "I_U"
from V$RESOURCE_LIMIT where RESOURCE_NAME in ('transactions','dml_locks');--C_U代表当前，M_U代表曾经达到过的最大值，I_U最大值，这句可以用来排除资源问题


--业务sql 因为在别的control就是别的sid了
drop materialized view VW_PERSON_INFO;

--顽固 会话，批量 kill
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

--如果打印台还是没打印语句，在左边的sql文件上右击点击enabled DBMSOUTPUT

--如果session无法kill，则kill线程
select 'kill -9 '|| p.spid
from v$session s, v$process p
where s.paddr = p.addr
and s.SID='' and s.SERIAL#='';

--业务域临时
select * from SYS_PARAMETER where PARA_KEY like '%PEOPLE_ARCHIVES_%';

