--pg数据库存储情况
SELECT
    relname AS table_name,
    pg_size_pretty(pg_total_relation_size(relid)) AS size
FROM
    pg_catalog.pg_statio_user_tables
ORDER BY
    pg_total_relation_size(relid) DESC;

--mysql数据库存储情况
SELECT
    table_schema AS '数据库',
    SUM(table_rows) AS '记录数',
    TRUNCATE(SUM(data_length)/1024/1024, 2) AS '数据容量(MB)',
    TRUNCATE(SUM(index_length)/1024/1024, 2) AS '索引容量(MB)'
FROM information_schema.TABLES
GROUP BY table_schema
ORDER BY SUM(data_length) DESC;


--oracle sql性能调优，代入sql_id，sql command执行，解释器将会给出执行建议
variable stmt_task VARCHAR2(64)
EXEC :stmt_task := DBMS_SQLTUNE.CREATE_TUNING_TASK(sql_id=>'75uw81x30k2d6',time_limit=>7200);
exec dbms_sqltune.execute_tuning_task(task_name =>:stmt_task);
SET LONG 10000000 LONGCHUNKSIZE 1000000 LINESIZE 180 pagesize 0 serveroutput on size 1000000
SELECT DBMS_SQLTUNE.REPORT_TUNING_TASK( :stmt_task) from dual;