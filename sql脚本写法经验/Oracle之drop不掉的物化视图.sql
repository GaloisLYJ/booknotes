select * from dba_objects where OBJECT_NAME = 'VW_PERSON_INFO';
select * from dba_objects where OBJECT_NAME = 'VW_PERSON_INFO_N';--drop�����������Ͳ鲻������¼��
select * from dba_objects where OBJECT_NAME = 'VW_PERSON_INFO_NEW';--����MATERIALIZED VIEW�е�status��INVALID ��Ч

/*ͨ�����ﻯ��ͼ��״̬���Ϊ��Ч��ԭ����ܰ�����

���ﻯ��ͼ��صĻ���������������˽ṹ�Ա仯������ӡ��޸Ļ�ɾ�����У������ﻯ��ͼ�޷�����������
�ﻯ��ͼ�Ķ��巢���˱仯�����޸��˲�ѯ�����������ԣ���δ�������±��롣
�ﻯ��ͼ�����Ķ���״̬�����˱仯���������ĺ������޸Ļ����±��롣*/

ALTER MATERIALIZED VIEW VW_PERSON_INFO_NEW COMPILE;--ִ��������±�����Ϊ��Ч


--��ѯ����������ϵ DBA_DEPENDENCIES
select * from DBA_DEPENDENCIES where NAME = 'VW_PERSON_INFO';
select * from DBA_DEPENDENCIES where NAME = 'VW_PERSON_INFO_N';

--�鿴�ﻯ��ͼ�����һ��ˢ��ʱ��
SELECT mview_name, owner, last_refresh_date
FROM DBA_MVIEWS where MVIEW_NAME = 'VW_PERSON_INFO_NEW';

SELECT owner, mview_name, query, container_name, updatable, refresh_mode, refresh_method, build_mode, last_refresh_type, STALENESS
FROM all_mviews where MVIEW_NAME in ('VW_PERSON_INFO_NEW');
--VALID���ﻯ��ͼ����Ч�ģ�����ʹ�á�
--INVALID���ﻯ��ͼ����Ч�ģ�������Ҫ���±�������޸���
--NEEDS_COMPILE���ﻯ��ͼ��Ҫ���±��롣
--COMPILE_ERROR����������г��ִ���
--STALE���ﻯ��ͼ��Ҫˢ���Ա������ݵ�һ���ԡ�
--UNUSABLE���ﻯ��ͼ�����ã�ͨ������Ϊ����������Ķ������˱仯��

DROP MATERIALIZED VIEW VW_PERSON_INFO_NEW;
SELECT * FROM V$VERSION;

--ǿ����ֹ����ʹ���ﻯ��ͼ�ĻỰ
ALTER SYSTEM KILL SESSION 'sid,serial#';

--��Oracle�У�������ͨ����ѯ�����ֵ���ͼDBA_MVIEWS���ҳ��ﻯ��ͼ״̬
select * from DBA_MVIEWS where MVIEW_NAME = 'VW_PERSON_INFO_NEW';

--��Oracle�У�������ͨ����ѯ�����ֵ���ͼDBA_MVIEWS���ҳ���ǰ����ʹ���ﻯ��ͼ�ĻỰ��
SELECT s.sid, s.serial#, s.username, s.osuser, s.machine, s.program, m.owner, m.mview_name
FROM V$SESSION s
JOIN DBA_MVIEWS m ON s.username = m.owner
WHERE s.username IS NOT NULL and m.MVIEW_NAME = 'VW_PERSON_INFO_NEW';

--ƴ�ӳ���ִ�е����
SELECT
    'alter system kill session ''' || s.sid || ',' || s.serial# || '''' || ' IMMEDIATE;',
    s.sid, s.serial#, s.username, s.osuser, s.machine, s.program, m.owner, m.mview_name
FROM V$SESSION s
JOIN DBA_MVIEWS m ON s.username = m.owner
WHERE s.username IS NOT NULL and OSUSER = 'liu.yujian1' and m.MVIEW_NAME = 'VW_PERSON_INFO_NEW';
--�ҵ��Լ����ֲ�������ͼ��sid ȫɾ��ֻʣһ����ǰ�Ự����ɾ�� DROP MATERIALIZED VIEW VW_PERSON_INFO;

alter system kill session '7232,55176' IMMEDIATE;
alter system kill session '7232,55176' IMMEDIATE;
--IMMEDIATE ��������һЩ����ɱ���ĻỰ



/*�� Oracle �У������ﻯ��ͼʱ������ʹ�ò�ͬ��ˢ�·�ʽ�������ﻯ��ͼ�е����ݡ������ǳ������ﻯ��ͼˢ�·�ʽ��

�ֶ�ˢ�£�MANUAL����

�ֶ�ˢ����ζ���ﻯ��ͼ�����Զ����£�������Ҫ�ֶ�����ˢ�²����������ͨ���û�����Ӧ�ó�����ִ�У�����ʹ�� DBMS_MVIEW.REFRESH �������ֶ�ˢ���ﻯ��ͼ��
��ȫˢ�£�COMPLETE����

��ȫˢ�»�����ִ���ﻯ��ͼ�Ĳ�ѯ�����Ҵӻ����л�ȡȫ�����ݣ���ȷ���ﻯ��ͼ�е������������һ�¡���ͨ����ʹ�� DBMS_MVIEW.REFRESH ���̲�ָ�� method => 'C' ������ִ�еġ�
����ˢ�£�FAST����

����ˢ����ͨ���Ƚ��ﻯ��ͼ�����֮��ı仯�������ﻯ��ͼ�е����ݣ�����������ִ�в�ѯ����Ҫ����������ʵ�����־�������������ʵ��Ļ�����ĸ߼���־�����м���Ĵ�����������ʹ�� DBMS_MVIEW.REFRESH ���̲�ָ�� method => 'F' ������ִ�п���ˢ�¡�
ǿ��ˢ�£�FORCE����

ǿ��ˢ�»�ǿ��ִ��ˢ�²����������ﻯ��ͼ��״̬��Ρ�����ʹ�� REFRESH FORCE ON DEMAND �﷨�������ﻯ��ͼ��ָ��ǿ��ˢ�·�ʽ��
����ˢ�£�ON COMMIT��ON DEMAND��ON COMMIT REFRESH����

����ˢ���Ǹ����ض��Ĵ����������������Զ�����ˢ�²��������磬ON COMMIT ��ʾ��ÿ���ύ����ʱˢ���ﻯ��ͼ��ON DEMAND ��ʾֻ������Ҫʱ��ˢ���ﻯ��ͼ��ON COMMIT REFRESH ��ʾ��ÿ���ύ����ʱ���������ύʱ�����ĸ�����ˢ���ﻯ��ͼ*/

--�ﻯ��ͼ����ˢ�µķ�ʽ
/*ON COMMIT��

�������ύʱ����ˢ���ﻯ��ͼ���������ύʱ��Oracle ���Զ������ﻯ��ͼ�����ݣ��Է�ӳ����������¸��ġ�
����ˢ�·�ʽ��������Щ��Ҫʵʱ��ӳ��������ĵ��ﻯ��ͼ�������ܻ��ϵͳ���ܲ���һ��Ӱ�졣
ON DEMAND��

����Ҫʱ�ֶ�ִ��ˢ���ﻯ��ͼ������ζ���ﻯ��ͼ��ˢ�²����Զ�������������Ҫ��ʽ���� DBMS_MVIEW ���е�ˢ�¹��̻���ʹ�� REFRESH ������������
����ˢ�·�ʽ��������Щ����Ҫʵʱ���µ��ﻯ��ͼ��������Ҫ���ض�ʱ����ֶ�ִ��ˢ�²����ĳ�����
ON COMMIT REFRESH��

�������ύʱ����ˢ���ﻯ��ͼ����ֻ��ˢ����Щ�ܵ��������Ӱ��Ĳ��֡�����ˢ�·�ʽ�������ȫˢ�£�Full Refresh�����Լ���ˢ�µ������������Ч�ʡ�
�� CREATE MATERIALIZED VIEW ����У������ָ�� ON COMMIT REFRESH ��ѡ�� FAST ���� COMPLETE ģʽ��FAST ģʽֻˢ����Ӱ��Ĳ��֣��� COMPLETE ģʽ��ˢ�������ﻯ��ͼ��*/

--���´����ﻯ��ͼ  ��϶�ʱ���� ˢ�¼���
--��ѯjob
select * from dba_jobs where what like '%VW_PERSON_INFO_NEW%';--job 72961
select * from BYDHRZS.VW_PERSON_INFO_NEW;
--����job
declare job number;
    begin dbms_job.submit(job, 'DBMS_MVIEW.refresh(''BYDHRZS.VW_PERSON_INFO_NEW'',''C'');',TRUNC(SYSDATE + 1) + (23*60+5)/(24*60),   'sysdate + 2');commit;
end;
--����ˢһ��


--��Oracle�У�������ͨ����ѯ�����ֵ���ͼDBA_MVIEWS���ҳ��ﻯ��ͼ״̬
select STALENESS,COMPILE_STATE from DBA_MVIEWS where MVIEW_NAME = 'VW_PERSON_INFO_NEW';
--״̬Ϊ NEEDS_COMPILE���ﻯ��ͼ��Ҫ���±��롣
ALTER MATERIALIZED VIEW VW_PERSON_INFO_NEW REFRESH COMPLETE;
--����״̬:compile_stateΪVALID��Ч
--��ʱ��:staleness Ϊ UNUSABLE

/*compile_state������״̬����compile_state �������ﻯ��ͼ�Ƿ���Ҫ���±��롣���ܵ�ȡֵ������

UNUSABLE����ʾ�ﻯ��ͼ�����ã�ͨ������Ϊ������صı�����������˽ṹ�Եı仯����Ҫ���±�����ʹ����Ч��
NEEDS_COMPILE����ʾ�ﻯ��ͼ��Ҫ���±��룬��������Ϊ������صĶ������˱仯�������ﻯ��ͼ����Ķ��巢���˱仯��
VALID����ʾ�ﻯ��ͼ����Ч�ģ�����Ҫ���±��롣
staleness����ʱ�ԣ���staleness �������ﻯ��ͼ�����Ƿ��ʱ�����ܵ�ȡֵ������

STALE����ʾ�ﻯ��ͼ�������Ѿ���ʱ����Ҫˢ���Է�ӳ���µĻ��������ݡ�
FRESH����ʾ�ﻯ��ͼ�����������µģ�����Ҫˢ�¡�*/

begin
    DBMS_MVIEW.refresh('BYDHRZS.VW_PERSON_INFO_NEW','C');
end;
--�˵���֮����ͼ����fresh״̬�����ڶԻ�����ִ���κ�DDL����֮����ͼ����Ϊneeds_compile״̬









