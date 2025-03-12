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

comment on table bi_yy_0007 is '招聘（珍总）';

comment on column bi_yy_0007.set_date_y is '账期(年)';

comment on column bi_yy_0007.emp_syq_zz is '机构分类(珍总)';

comment on column bi_yy_0007.emp_syb_zz is '机构简称(珍总) ';

comment on column bi_yy_0007.org_sort_zz is '排序';

comment on column bi_yy_0007.zp_type is '招聘类型';

comment on column bi_yy_0007.edu_type is '学历类型';

comment on column bi_yy_0007.need_count is '需求人数';

comment on column bi_yy_0007.signing_count is '签约人数';

comment on column bi_yy_0007.entry_count is '入职人数';

comment on column bi_yy_0007.plan_subject is '应届生招聘主题';

alter table bi_yy_0007
    owner to hr;

grant select on bi_yy_0007 to dev_bi;



--源表
select * from ehr_bi.bi_yy_0007 where set_date_y = '2024' and zp_type='校招';

--表存储结构
--emp_syq_zz is not null、emp_syb_zz is not null，代表事业部层级记录
--emp_syq_zz is not null、emp_syb_zz is null，代表事业群层级记录
--emp_syq_zz is null、emp_syb_zz is null，代表比亚迪层级记录

--第一种数据透视表写法：case when + group by
--事业部
select emp_syq_zz as syq,emp_syb_zz as syb,
       sum(case when t.edu_type = '本科' then nvl(t.signing_count,0) else 0 end) as bk_signing_count,
       sum(case when t.edu_type = '本科' then nvl(t.entry_count,0) else 0 end) as bk_entry_count,
       sum(case when t.edu_type = '硕士' then nvl(t.signing_count,0) else 0 end) as ss_signing_count,
       sum(case when t.edu_type = '硕士' then nvl(t.entry_count,0) else 0 end) as ss_entry_count,
       sum(case when t.edu_type = '博士' then nvl(t.signing_count,0) else 0 end) as bs_signing_count,
       sum(case when t.edu_type = '博士' then nvl(t.entry_count,0) else 0 end) as bs_entry_count
from ehr_bi.bi_yy_0007 t
where emp_syq_zz is not null
and emp_syb_zz is not null
and t.set_date_y='2024'
and zp_type='校招'
group by emp_syq_zz,emp_syb_zz;
--需要行转列的多少字段就写多少字段的case when

--带上不同层级的合计的写法 这里的合计=行转列的字段的合计
select coalesce(emp_syq_zz,'比亚迪') as syq,
       coalesce(emp_syb_zz,'合计') as syb,
       sum(case when t.edu_type = '本科' then nvl(t.signing_count,0) else 0 end) as bk_signing_count,
       sum(case when t.edu_type = '本科' then nvl(t.entry_count,0) else 0 end) as bk_entry_count,
       sum(case when t.edu_type = '硕士' then nvl(t.signing_count,0) else 0 end) as ss_signing_count,
       sum(case when t.edu_type = '硕士' then nvl(t.entry_count,0) else 0 end) as ss_entry_count,
       sum(case when t.edu_type = '博士' then nvl(t.signing_count,0) else 0 end) as bs_signing_count,
       sum(case when t.edu_type = '博士' then nvl(t.entry_count,0) else 0 end) as bs_entry_count
from ehr_bi.bi_yy_0007 t
where emp_syq_zz is not null
and emp_syb_zz is not null
and t.set_date_y='2024'
and zp_type='校招'
group by rollup(emp_syq_zz,emp_syb_zz);
--使用rollup函数可以很方便地生成不同层次的小计、合计以及总计，coalesce用于合计项的文字展示，默认为null，这种合计写法：合计=本科+硕士+博士

select coalesce(emp_syq_zz,'比亚迪') as syq,
       coalesce(emp_syb_zz,'合计') as syb,
       sum(case when t.edu_type = '本科' then nvl(t.signing_count,0) else 0 end) as bk_signing_count,
       sum(case when t.edu_type = '硕士' then nvl(t.signing_count,0) else 0 end) as ss_signing_count,
       sum(case when t.edu_type = '博士' then nvl(t.signing_count,0) else 0 end) as bs_signing_count,
       sum(t.signing_count) as total_signing_count,
       sum(case when t.edu_type = '本科' then nvl(t.entry_count,0) else 0 end) as bk_entry_count,
       sum(case when t.edu_type = '硕士' then nvl(t.entry_count,0) else 0 end) as ss_entry_count,
       sum(case when t.edu_type = '博士' then nvl(t.entry_count,0) else 0 end) as bs_entry_count,
       sum(t.entry_count) as enntry_signing_count
from ehr_bi.bi_yy_0007 t
where emp_syq_zz is not null
and emp_syb_zz is not null
and t.set_date_y='2024'
and zp_type='校招'
group by emp_syq_zz,emp_syb_zz;
--这是一种新的合计写法，这种合计写法：合计=本科+硕士+博士+其他(数据库源表为null)

--总结与收获：
--和rollup综合起来，就能得到，两种维度合计都含有的数据透视表，列的字段合计为真正底层表意义上（本科+硕士+博士+其他）的合计，行记录的合计为你需要做统计的字段（本科+硕士+博士）的合计，其他=大专及以下+null
select coalesce(emp_syq_zz,'比亚迪') as syq,
       coalesce(emp_syb_zz,'合计') as syb,
       sum(case when t.edu_type = '本科' then nvl(t.signing_count,0) else 0 end) as bk_signing_count,
       sum(case when t.edu_type = '硕士' then nvl(t.signing_count,0) else 0 end) as ss_signing_count,
       sum(case when t.edu_type = '博士' then nvl(t.signing_count,0) else 0 end) as bs_signing_count,
       sum(t.signing_count) as total_signing_count,
       sum(case when t.edu_type = '本科' then nvl(t.entry_count,0) else 0 end) as bk_entry_count,
       sum(case when t.edu_type = '硕士' then nvl(t.entry_count,0) else 0 end) as ss_entry_count,
       sum(case when t.edu_type = '博士' then nvl(t.entry_count,0) else 0 end) as bs_entry_count,
       sum(t.entry_count) as total_enntry_count
from ehr_bi.bi_yy_0007 t
where emp_syq_zz is not null
and emp_syb_zz is not null
and t.set_date_y='2024'
and zp_type='校招'
group by rollup(emp_syq_zz,emp_syb_zz);
--这种写法，会把没有的记录，如两网直营，没有硕士记录，字段列ss_signing_count、ss_entry_count会为0显示，下面的pivot是以null显示




--第二种数据透视表的写法：aggregate_function(<expression>) FILTER (where <condition>)
--aggregate_function可以是任意的聚合函数或者窗口函数；FILTER子句用于指定一个额外的条件，只有满足该条件的数据才会参与计算
--此语法oracle12开始才支持，Vastbase在PG兼容模式下，聚合函数才支持FILTER过滤的功能，我们当前的vastbase兼容模式是Oracle的，所以以下sql暂不能执行，实际是可以的
--https://docs.vastdata.com.cn/zh/docs/VastbaseG100Ver2.2.10/doc/%E5%85%BC%E5%AE%B9%E6%80%A7%E6%89%8B%E5%86%8C/PostgreSQL%E5%85%BC%E5%AE%B9%E6%80%A7/%E8%81%9A%E5%90%88%E5%87%BD%E6%95%B0%E6%94%AF%E6%8C%81FILTER%E8%BF%87%E6%BB%A4.html
select coalesce(emp_syq_zz,'比亚迪') as syq,
       coalesce(emp_syb_zz,'合计') as syb,
       sum( nvl(t.signing_count,0) ) filter(where t.edu_type = '本科') as bk_signing_count,
       sum( nvl(t.signing_count,0) ) filter(where t.edu_type = '硕士') as ss_signing_count,
       sum( nvl(t.signing_count,0) ) filter(where t.edu_type = '博士') as bs_signing_count,
       sum( nvl(t.signing_count,0) ) as total_signing_count,
       sum( nvl(t.entry_count,0) ) filter(where t.edu_type = '本科') as bk_entry_count,
       sum( nvl(t.entry_count,0) ) filter(where t.edu_type = '硕士') as ss_entry_count,
       sum( nvl(t.entry_count,0) ) filter(where t.edu_type = '博士') as bs_entry_count,
       sum( nvl(t.entry_count,0) ) as total_enntry_count
from ehr_bi.bi_yy_0007 t
where emp_syq_zz is not null
and emp_syb_zz is not null
and t.set_date_y='2024'
and zp_type='校招' --公用的筛选条件写在这，对聚合函数使用的筛选条件写在filter里
group by rollup(emp_syq_zz,emp_syb_zz);



--第三种数据透视表的写法
--postgresql 扩展模块 tablefunc提供了许多返回结果为数据表的函数，其中crosstab函数可以用于实现数据的行列转换
--create extension if not exists tablefunc
--sudo yum install postgrelsql12-contrib
--http://www.mark-to-win.com/tutorial/51611.html
--此种语法只使用
select * from pg_extension where extname like '%table%';



--第四种数据透视表的写法，因为当前的vastbase兼容的是oracle，哭了，再也不叫vastbase是pg数据库了
--pivot 写法，来源于oracle
--https://docs.vastdata.com.cn/zh/docs/VastbaseG100Ver2.2.10/doc/%E5%85%BC%E5%AE%B9%E6%80%A7%E6%89%8B%E5%86%8C/Oracle%E5%85%BC%E5%AE%B9%E6%80%A7/PIVOT.html
with t as(
    --事业部
    select t.emp_syq_zz,t.emp_syb_zz,t.edu_type,
           coalesce(t.signing_count,'0') as signing_count,
           coalesce(t.entry_count,'0') as entry_count
    from ehr_bi.bi_yy_0007 t
    where emp_syq_zz is not null
    and emp_syb_zz is not null
    and t.set_date_y='2024'
    and zp_type='校招'
    and t.edu_type is not null --需要把透视列去空，下面的in子句无法自动滤掉null，会多出一行记录
)
select *
from t
pivot(
    SUM(signing_count) as signing_count,SUM(entry_count) as entry_count
    for edu_type in ('本科' as bk,'硕士' as ss,'博士' as bs)
);
--跟oracle略有不同，必须要使用 as 指定别名，不能省略否则有语法错误
--这种写法，会把没有的记录，如两网直营，没有硕士记录，字段列ss_signing_count、ss_entry_count会为null显示，上面的sum case when写法是以0显示
--经研究发现，pivot写法需要注意的地方多，一是主结构滤空，二是总计字段列的写法，如果需要兼顾总计，写法复杂，需要另外考虑rollup的实现和总计列的本身逻辑实现
--结论：pivot 适用于不需要总计列、总计行维度的情况，否则写sum case when结合rollup更方便


with t as(
    --事业部
    select t.emp_syq_zz,t.emp_syb_zz,t.edu_type,
           coalesce(t.signing_count,'0') as signing_count,
           coalesce(t.entry_count,'0') as entry_count
    from ehr_bi.bi_yy_0007 t
    where emp_syq_zz is not null
    and emp_syb_zz is not null
    and t.set_date_y='2024'
    and zp_type='校招'
    and t.edu_type is not null --需要把透视列去空，下面的in子句无法自动滤掉null，会多出一行记录
),
t2 as(
    select *
    from t
    pivot(
        SUM(signing_count) as signing_count,SUM(entry_count) as entry_count
        for edu_type in ('本科' as bk,'硕士' as ss,'博士' as bs)
    )
)
select coalesce(emp_syq_zz,'比亚迪') as syq,
       coalesce(emp_syb_zz,'合计') as syb,
       sum(coalesce(bk_signing_count,0)) as bk_signing_count,
       sum(coalesce(bk_entry_count,0)) as bk_entry_count,
       sum(coalesce(ss_signing_count,0)) as ss_signing_count,
       sum(coalesce(ss_entry_count,0)) as ss_entry_count,
       sum(coalesce(bs_signing_count,0)) as bs_signing_count,
       sum(coalesce(bs_entry_count,0)) as bs_entry_count
from t2 group by rollup(emp_syq_zz,emp_syb_zz);
--这里不加coalesce就是为空，至此已经得到了第二种透视表写法中：第一句的sql一致的结果