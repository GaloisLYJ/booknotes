create table bi_yy_0007
(
    set_date_y    varchar(200),
    emp_syq_zz    varchar(200),
    emp_syb_zz    varchar(200),
    org_sort_zz   varchar(200),
    zp_type       varchar(200),
    edu_type      varchar(200),
    need_count    bigint,
    signing_count bigint,
    entry_count   bigint,
    plan_subject  varchar
)
    with (orientation = row, compression = no, fillfactor = 80);

comment on table bi_yy_0007 is '��Ƹ�����ܣ�';

comment on column bi_yy_0007.set_date_y is '����(��)';

comment on column bi_yy_0007.emp_syq_zz is '��������(����)';

comment on column bi_yy_0007.emp_syb_zz is '�������(����) ';

comment on column bi_yy_0007.org_sort_zz is '����';

comment on column bi_yy_0007.zp_type is '��Ƹ����';

comment on column bi_yy_0007.edu_type is 'ѧ������';

comment on column bi_yy_0007.need_count is '��������';

comment on column bi_yy_0007.signing_count is 'ǩԼ����';

comment on column bi_yy_0007.entry_count is '��ְ����';

comment on column bi_yy_0007.plan_subject is 'Ӧ������Ƹ����';

alter table bi_yy_0007
    owner to hr;

grant select on bi_yy_0007 to dev_bi;



--Դ��
select * from ehr_bi.bi_yy_0007 where set_date_y = '2024' and zp_type='У��';

--��洢�ṹ
--emp_syq_zz is not null��emp_syb_zz is not null��������ҵ���㼶��¼
--emp_syq_zz is not null��emp_syb_zz is null��������ҵȺ�㼶��¼
--emp_syq_zz is null��emp_syb_zz is null��������ǵϲ㼶��¼

--��һ������͸�ӱ�д����case when + group by
--��ҵ��
select emp_syq_zz as syq,emp_syb_zz as syb,
       sum(case when t.edu_type = '����' then nvl(t.signing_count,0) else 0 end) as bk_signing_count,
       sum(case when t.edu_type = '����' then nvl(t.entry_count,0) else 0 end) as bk_entry_count,
       sum(case when t.edu_type = '˶ʿ' then nvl(t.signing_count,0) else 0 end) as ss_signing_count,
       sum(case when t.edu_type = '˶ʿ' then nvl(t.entry_count,0) else 0 end) as ss_entry_count,
       sum(case when t.edu_type = '��ʿ' then nvl(t.signing_count,0) else 0 end) as bs_signing_count,
       sum(case when t.edu_type = '��ʿ' then nvl(t.entry_count,0) else 0 end) as bs_entry_count
from ehr_bi.bi_yy_0007 t
where emp_syq_zz is not null
and emp_syb_zz is not null
and t.set_date_y='2024'
and zp_type='У��'
group by emp_syq_zz,emp_syb_zz;
--��Ҫ��ת�еĶ����ֶξ�д�����ֶε�case when

--���ϲ�ͬ�㼶�ĺϼƵ�д�� ����ĺϼ�=��ת�е��ֶεĺϼ�
select coalesce(emp_syq_zz,'���ǵ�') as syq,
       coalesce(emp_syb_zz,'�ϼ�') as syb,
       sum(case when t.edu_type = '����' then nvl(t.signing_count,0) else 0 end) as bk_signing_count,
       sum(case when t.edu_type = '����' then nvl(t.entry_count,0) else 0 end) as bk_entry_count,
       sum(case when t.edu_type = '˶ʿ' then nvl(t.signing_count,0) else 0 end) as ss_signing_count,
       sum(case when t.edu_type = '˶ʿ' then nvl(t.entry_count,0) else 0 end) as ss_entry_count,
       sum(case when t.edu_type = '��ʿ' then nvl(t.signing_count,0) else 0 end) as bs_signing_count,
       sum(case when t.edu_type = '��ʿ' then nvl(t.entry_count,0) else 0 end) as bs_entry_count
from ehr_bi.bi_yy_0007 t
where emp_syq_zz is not null
and emp_syb_zz is not null
and t.set_date_y='2024'
and zp_type='У��'
group by rollup(emp_syq_zz,emp_syb_zz);
--ʹ��rollup�������Ժܷ�������ɲ�ͬ��ε�С�ơ��ϼ��Լ��ܼƣ�coalesce���ںϼ��������չʾ��Ĭ��Ϊnull�����ֺϼ�д�����ϼ�=����+˶ʿ+��ʿ

select coalesce(emp_syq_zz,'���ǵ�') as syq,
       coalesce(emp_syb_zz,'�ϼ�') as syb,
       sum(case when t.edu_type = '����' then nvl(t.signing_count,0) else 0 end) as bk_signing_count,
       sum(case when t.edu_type = '˶ʿ' then nvl(t.signing_count,0) else 0 end) as ss_signing_count,
       sum(case when t.edu_type = '��ʿ' then nvl(t.signing_count,0) else 0 end) as bs_signing_count,
       sum(t.signing_count) as total_signing_count,
       sum(case when t.edu_type = '����' then nvl(t.entry_count,0) else 0 end) as bk_entry_count,
       sum(case when t.edu_type = '˶ʿ' then nvl(t.entry_count,0) else 0 end) as ss_entry_count,
       sum(case when t.edu_type = '��ʿ' then nvl(t.entry_count,0) else 0 end) as bs_entry_count,
       sum(t.entry_count) as enntry_signing_count
from ehr_bi.bi_yy_0007 t
where emp_syq_zz is not null
and emp_syb_zz is not null
and t.set_date_y='2024'
and zp_type='У��'
group by emp_syq_zz,emp_syb_zz;
--����һ���µĺϼ�д�������ֺϼ�д�����ϼ�=����+˶ʿ+��ʿ+����(���ݿ�Դ��Ϊnull)

--�ܽ����ջ�
--��rollup�ۺ����������ܵõ�������ά�Ⱥϼƶ����е�����͸�ӱ��е��ֶκϼ�Ϊ�����ײ�������ϣ�����+˶ʿ+��ʿ+�������ĺϼƣ��м�¼�ĺϼ�Ϊ����Ҫ��ͳ�Ƶ��ֶΣ�����+˶ʿ+��ʿ���ĺϼƣ�����=��ר������+null
select coalesce(emp_syq_zz,'���ǵ�') as syq,
       coalesce(emp_syb_zz,'�ϼ�') as syb,
       sum(case when t.edu_type = '����' then nvl(t.signing_count,0) else 0 end) as bk_signing_count,
       sum(case when t.edu_type = '˶ʿ' then nvl(t.signing_count,0) else 0 end) as ss_signing_count,
       sum(case when t.edu_type = '��ʿ' then nvl(t.signing_count,0) else 0 end) as bs_signing_count,
       sum(t.signing_count) as total_signing_count,
       sum(case when t.edu_type = '����' then nvl(t.entry_count,0) else 0 end) as bk_entry_count,
       sum(case when t.edu_type = '˶ʿ' then nvl(t.entry_count,0) else 0 end) as ss_entry_count,
       sum(case when t.edu_type = '��ʿ' then nvl(t.entry_count,0) else 0 end) as bs_entry_count,
       sum(t.entry_count) as total_enntry_count
from ehr_bi.bi_yy_0007 t
where emp_syq_zz is not null
and emp_syb_zz is not null
and t.set_date_y='2024'
and zp_type='У��'
group by rollup(emp_syq_zz,emp_syb_zz);
--����д�������û�еļ�¼��������ֱӪ��û��˶ʿ��¼���ֶ���ss_signing_count��ss_entry_count��Ϊ0��ʾ�������pivot����null��ʾ




--�ڶ�������͸�ӱ��д����aggregate_function(<expression>) FILTER (where <condition>)
--aggregate_function����������ľۺϺ������ߴ��ں�����FILTER�Ӿ�����ָ��һ�������������ֻ����������������ݲŻ�������
--���﷨oracle12��ʼ��֧�֣�Vastbase��PG����ģʽ�£��ۺϺ�����֧��FILTER���˵Ĺ��ܣ����ǵ�ǰ��vastbase����ģʽ��Oracle�ģ���������sql�ݲ���ִ�У�ʵ���ǿ��Ե�
--https://docs.vastdata.com.cn/zh/docs/VastbaseG100Ver2.2.10/doc/%E5%85%BC%E5%AE%B9%E6%80%A7%E6%89%8B%E5%86%8C/PostgreSQL%E5%85%BC%E5%AE%B9%E6%80%A7/%E8%81%9A%E5%90%88%E5%87%BD%E6%95%B0%E6%94%AF%E6%8C%81FILTER%E8%BF%87%E6%BB%A4.html
select coalesce(emp_syq_zz,'���ǵ�') as syq,
       coalesce(emp_syb_zz,'�ϼ�') as syb,
       sum( nvl(t.signing_count,0) ) filter(where t.edu_type = '����') as bk_signing_count,
       sum( nvl(t.signing_count,0) ) filter(where t.edu_type = '˶ʿ') as ss_signing_count,
       sum( nvl(t.signing_count,0) ) filter(where t.edu_type = '��ʿ') as bs_signing_count,
       sum( nvl(t.signing_count,0) ) as total_signing_count,
       sum( nvl(t.entry_count,0) ) filter(where t.edu_type = '����') as bk_entry_count,
       sum( nvl(t.entry_count,0) ) filter(where t.edu_type = '˶ʿ') as ss_entry_count,
       sum( nvl(t.entry_count,0) ) filter(where t.edu_type = '��ʿ') as bs_entry_count,
       sum( nvl(t.entry_count,0) ) as total_enntry_count
from ehr_bi.bi_yy_0007 t
where emp_syq_zz is not null
and emp_syb_zz is not null
and t.set_date_y='2024'
and zp_type='У��' --���õ�ɸѡ����д���⣬�ԾۺϺ���ʹ�õ�ɸѡ����д��filter��
group by rollup(emp_syq_zz,emp_syb_zz);



--����������͸�ӱ��д��
--postgresql ��չģ�� tablefunc�ṩ����෵�ؽ��Ϊ���ݱ�ĺ���������crosstab������������ʵ�����ݵ�����ת��
--create extension if not exists tablefunc
--sudo yum install postgrelsql12-contrib
--http://www.mark-to-win.com/tutorial/51611.html
--�����﷨ֻʹ��
select * from pg_extension where extname like '%table%';



--����������͸�ӱ��д������Ϊ��ǰ��vastbase���ݵ���oracle�����ˣ���Ҳ����vastbase��pg���ݿ���
--pivot д������Դ��oracle
--https://docs.vastdata.com.cn/zh/docs/VastbaseG100Ver2.2.10/doc/%E5%85%BC%E5%AE%B9%E6%80%A7%E6%89%8B%E5%86%8C/Oracle%E5%85%BC%E5%AE%B9%E6%80%A7/PIVOT.html
with t as(
    --��ҵ��
    select t.emp_syq_zz,t.emp_syb_zz,t.edu_type,
           coalesce(t.signing_count,'0') as signing_count,
           coalesce(t.entry_count,'0') as entry_count
    from ehr_bi.bi_yy_0007 t
    where emp_syq_zz is not null
    and emp_syb_zz is not null
    and t.set_date_y='2024'
    and zp_type='У��'
    and t.edu_type is not null --��Ҫ��͸����ȥ�գ������in�Ӿ��޷��Զ��˵�null������һ�м�¼
)
select *
from t
pivot(
    SUM(signing_count) as signing_count,SUM(entry_count) as entry_count
    for edu_type in ('����' as bk,'˶ʿ' as ss,'��ʿ' as bs)
);
--��oracle���в�ͬ������Ҫʹ�� as ָ������������ʡ�Է������﷨����
--����д�������û�еļ�¼��������ֱӪ��û��˶ʿ��¼���ֶ���ss_signing_count��ss_entry_count��Ϊnull��ʾ�������sum case whenд������0��ʾ
--���о����֣�pivotд����Ҫע��ĵط��࣬һ�����ṹ�˿գ������ܼ��ֶ��е�д���������Ҫ����ܼƣ�д�����ӣ���Ҫ���⿼��rollup��ʵ�ֺ��ܼ��еı����߼�ʵ��
--���ۣ�pivot �����ڲ���Ҫ�ܼ��С��ܼ���ά�ȵ����������дsum case when���rollup������


with t as(
    --��ҵ��
    select t.emp_syq_zz,t.emp_syb_zz,t.edu_type,
           coalesce(t.signing_count,'0') as signing_count,
           coalesce(t.entry_count,'0') as entry_count
    from ehr_bi.bi_yy_0007 t
    where emp_syq_zz is not null
    and emp_syb_zz is not null
    and t.set_date_y='2024'
    and zp_type='У��'
    and t.edu_type is not null --��Ҫ��͸����ȥ�գ������in�Ӿ��޷��Զ��˵�null������һ�м�¼
),
t2 as(
    select *
    from t
    pivot(
        SUM(signing_count) as signing_count,SUM(entry_count) as entry_count
        for edu_type in ('����' as bk,'˶ʿ' as ss,'��ʿ' as bs)
    )
)
select coalesce(emp_syq_zz,'���ǵ�') as syq,
       coalesce(emp_syb_zz,'�ϼ�') as syb,
       sum(coalesce(bk_signing_count,0)) as bk_signing_count,
       sum(coalesce(bk_entry_count,0)) as bk_entry_count,
       sum(coalesce(ss_signing_count,0)) as ss_signing_count,
       sum(coalesce(ss_entry_count,0)) as ss_entry_count,
       sum(coalesce(bs_signing_count,0)) as bs_signing_count,
       sum(coalesce(bs_entry_count,0)) as bs_entry_count
from t2 group by rollup(emp_syq_zz,emp_syb_zz);
--���ﲻ��coalesce����Ϊ�գ������Ѿ��õ��˵ڶ���͸�ӱ�д���У���һ���sqlһ�µĽ��