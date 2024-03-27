select * from dba_objects where OBJECT_NAME = 'VW_PERSON_INFO';
select * from dba_objects where OBJECT_NAME = 'VW_PERSON_INFO_N';--drop掉的用这语句就查不出来记录了
select * from dba_objects where OBJECT_NAME = 'VW_PERSON_INFO_NEW';--发现MATERIALIZED VIEW行的status是INVALID 无效

/*通常，物化视图的状态会变为无效的原因可能包括：

与物化视图相关的基础表或索引发生了结构性变化，如添加、修改或删除了列，导致物化视图无法正常工作。
物化视图的定义发生了变化，如修改了查询语句或其他属性，但未进行重新编译。
物化视图依赖的对象状态发生了变化，如依赖的函数被修改或重新编译。*/

ALTER MATERIALIZED VIEW VW_PERSON_INFO_NEW COMPILE;--执行这句重新编译后变为有效


--查询对象依赖关系 DBA_DEPENDENCIES
select * from DBA_DEPENDENCIES where NAME = 'VW_PERSON_INFO';
select * from DBA_DEPENDENCIES where NAME = 'VW_PERSON_INFO_N';

--查看物化视图的最后一次刷新时间
SELECT mview_name, owner, last_refresh_date
FROM DBA_MVIEWS where MVIEW_NAME = 'VW_PERSON_INFO_NEW';

SELECT owner, mview_name, query, container_name, updatable, refresh_mode, refresh_method, build_mode, last_refresh_type, STALENESS
FROM all_mviews where MVIEW_NAME in ('VW_PERSON_INFO_NEW');
--VALID：物化视图是有效的，可以使用。
--INVALID：物化视图是无效的，可能需要重新编译或者修复。
--NEEDS_COMPILE：物化视图需要重新编译。
--COMPILE_ERROR：编译过程中出现错误。
--STALE：物化视图需要刷新以保持数据的一致性。
--UNUSABLE：物化视图不可用，通常是因为与其相关联的对象发生了变化。

DROP MATERIALIZED VIEW VW_PERSON_INFO_NEW;
SELECT * FROM V$VERSION;

--强制终止正在使用物化视图的会话
ALTER SYSTEM KILL SESSION 'sid,serial#';

--在Oracle中，您可以通过查询数据字典视图DBA_MVIEWS来找出物化视图状态
select * from DBA_MVIEWS where MVIEW_NAME = 'VW_PERSON_INFO_NEW';

--在Oracle中，您可以通过查询数据字典视图DBA_MVIEWS来找出当前正在使用物化视图的会话。
SELECT s.sid, s.serial#, s.username, s.osuser, s.machine, s.program, m.owner, m.mview_name
FROM V$SESSION s
JOIN DBA_MVIEWS m ON s.username = m.owner
WHERE s.username IS NOT NULL and m.MVIEW_NAME = 'VW_PERSON_INFO_NEW';

--拼接出可执行的语句
SELECT
    'alter system kill session ''' || s.sid || ',' || s.serial# || '''' || ' IMMEDIATE;',
    s.sid, s.serial#, s.username, s.osuser, s.machine, s.program, m.owner, m.mview_name
FROM V$SESSION s
JOIN DBA_MVIEWS m ON s.username = m.owner
WHERE s.username IS NOT NULL and OSUSER = 'liu.yujian1' and m.MVIEW_NAME = 'VW_PERSON_INFO_NEW';
--找到自己名字操作该视图的sid 全删掉只剩一个当前会话即可删除 DROP MATERIALIZED VIEW VW_PERSON_INFO;

alter system kill session '7232,55176' IMMEDIATE;
alter system kill session '7232,55176' IMMEDIATE;
--IMMEDIATE 可以用于一些难以杀死的会话



/*在 Oracle 中，创建物化视图时，可以使用不同的刷新方式来更新物化视图中的数据。以下是常见的物化视图刷新方式：

手动刷新（MANUAL）：

手动刷新意味着物化视图不会自动更新，而是需要手动触发刷新操作。这可以通过用户或者应用程序来执行，例如使用 DBMS_MVIEW.REFRESH 过程来手动刷新物化视图。
完全刷新（COMPLETE）：

完全刷新会重新执行物化视图的查询，并且从基表中获取全部数据，以确保物化视图中的数据与基表保持一致。这通常是使用 DBMS_MVIEW.REFRESH 过程并指定 method => 'C' 参数来执行的。
快速刷新（FAST）：

快速刷新是通过比较物化视图与基表之间的变化来更新物化视图中的数据，而不是重新执行查询。这要求基表上有适当的日志或者已启用了适当的基表级别的高级日志或者行级别的触发器。可以使用 DBMS_MVIEW.REFRESH 过程并指定 method => 'F' 参数来执行快速刷新。
强制刷新（FORCE）：

强制刷新会强制执行刷新操作，无论物化视图的状态如何。可以使用 REFRESH FORCE ON DEMAND 语法来创建物化视图并指定强制刷新方式。
定期刷新（ON COMMIT、ON DEMAND、ON COMMIT REFRESH）：

定期刷新是根据特定的触发器或者条件来自动触发刷新操作。例如，ON COMMIT 表示在每次提交事务时刷新物化视图，ON DEMAND 表示只有在需要时才刷新物化视图，ON COMMIT REFRESH 表示在每次提交事务时根据事务提交时所做的更改来刷新物化视图*/

--物化视图定期刷新的方式
/*ON COMMIT：

在事务提交时立即刷新物化视图。当事务提交时，Oracle 将自动更新物化视图的数据，以反映基础表的最新更改。
这种刷新方式适用于那些需要实时反映基础表更改的物化视图，但可能会对系统性能产生一定影响。
ON DEMAND：

在需要时手动执行刷新物化视图。这意味着物化视图的刷新不会自动发生，而是需要显式调用 DBMS_MVIEW 包中的刷新过程或者使用 REFRESH 命令来触发。
这种刷新方式适用于那些不需要实时更新的物化视图，或者需要在特定时间点手动执行刷新操作的场景。
ON COMMIT REFRESH：

在事务提交时立即刷新物化视图，但只会刷新那些受到事务更改影响的部分。这种刷新方式相对于完全刷新（Full Refresh）可以减少刷新的数据量，提高效率。
在 CREATE MATERIALIZED VIEW 语句中，你可以指定 ON COMMIT REFRESH 并选择 FAST 或者 COMPLETE 模式。FAST 模式只刷新受影响的部分，而 COMPLETE 模式将刷新整个物化视图。*/

--重新创建物化视图  结合定时任务 刷新即可
--查询job
select * from dba_jobs where what like '%VW_PERSON_INFO_NEW%';--job 72961
select * from BYDHRZS.VW_PERSON_INFO_NEW;
--定义job
declare job number;
    begin dbms_job.submit(job, 'DBMS_MVIEW.refresh(''BYDHRZS.VW_PERSON_INFO_NEW'',''C'');',TRUNC(SYSDATE + 1) + (23*60+5)/(24*60),   'sysdate + 2');commit;
end;
--两天刷一次


--在Oracle中，您可以通过查询数据字典视图DBA_MVIEWS来找出物化视图状态
select STALENESS,COMPILE_STATE from DBA_MVIEWS where MVIEW_NAME = 'VW_PERSON_INFO_NEW';
--状态为 NEEDS_COMPILE：物化视图需要重新编译。
ALTER MATERIALIZED VIEW VW_PERSON_INFO_NEW REFRESH COMPLETE;
--编译状态:compile_state为VALID有效
--过时性:staleness 为 UNUSABLE

/*compile_state（编译状态）：compile_state 描述了物化视图是否需要重新编译。可能的取值包括：

UNUSABLE：表示物化视图不可用，通常是因为与其相关的表或索引发生了结构性的变化，需要重新编译以使其有效。
NEEDS_COMPILE：表示物化视图需要重新编译，可能是因为与其相关的对象发生了变化，或者物化视图本身的定义发生了变化。
VALID：表示物化视图是有效的，不需要重新编译。
staleness（过时性）：staleness 描述了物化视图数据是否过时。可能的取值包括：

STALE：表示物化视图的数据已经过时，需要刷新以反映最新的基础表数据。
FRESH：表示物化视图的数据是最新的，不需要刷新。*/

begin
    DBMS_MVIEW.refresh('BYDHRZS.VW_PERSON_INFO_NEW','C');
end;
--此调用之后，视图处于fresh状态，但在对基础表执行任何DDL操作之后，视图将变为needs_compile状态









