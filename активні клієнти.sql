--База діючих клієнтів. 

/* 
В клієнтів існують абонименти які можуть діяти пвний проміжок часу, наприклад, абонемент клієнта починає діяти '03.02.2020', а закінчується '06.04.2020'. Отже цей клієнти є діючим протягом всього цього періоду часу. 

Для того щоб дізнатися загальну кількість діючих клієнтів станом на сьогодні потрібно використати  простий запит:
select count(order) 
from orders 
where started <= sysdate and finished >=sysdate
але якщо цей запит потрібно записати для тридцяти днів місяця, змінючи  sysdate на потнрібну дати, то простіше використати генератор чисел
*/


-- щоденна база. кількість клієнтів, які були активні в конкретний день 
with tab as (
    select 1, 'name1' as id, to_date('08.01.2020', 'dd.mm.yyyy') as started, to_date('23.01.2020', 'dd.mm.yyyy') as finished from dual union all
    select 2, 'name2' as id, to_date('15.01.2020', 'dd.mm.yyyy')  as started, to_date('22.01.2020', 'dd.mm.yyyy') as finished from dual union all
    select 3, 'name3'as id, to_date('03.02.2020', 'dd.mm.yyyy') as started, to_date('06.04.2020', 'dd.mm.yyyy') as finished from dual 
    )
    
, params as (
    select date'2020-01-01' from#, 20 days# from dual
)
select to_char (dd, 'DD.MM.YYYY') day, count (id)  as count
from (
    select trunc (from#, 'dd' ) + level-1 dd 
    from params connect by level<=days#)
left join tab on (tab.started <= dd +1 and tab.finished >= dd)   
group by dd
order by dd
;

-- тижднева база. кількість клієнтів, які були активні хоча б один день в тиждні
with tab as (
    select 1, 'name1' as id, to_date('08.01.2020', 'dd.mm.yyyy') as started, to_date('23.01.2020', 'dd.mm.yyyy') as finished from dual union all
    select 2, 'name2' as id, to_date('15.01.2020', 'dd.mm.yyyy')  as started, to_date('22.01.2020', 'dd.mm.yyyy') as finished from dual union all
    select 3, 'name3'as id, to_date('03.02.2020', 'dd.mm.yyyy') as started, to_date('05.02.2020', 'dd.mm.yyyy') as finished from dual 
    )
    
, params as (
    select date'2020-01-01' from#, 7*7 days# from dual
)
select  (to_char(trunc(week, 'DAY'), 'yyyy.mm.dd') || ' - ' ||to_char(trunc(week+7, 'DAY'), 'yyyy.mm.dd') )as week   , count (id)  as count
from (
    select  ( trunc (from#, 'DAY') + level-1 ) as  week 
    from params connect by level<=days#)
left join tab on (tab.started <= trunc(week, 'DAY')+7 and tab.finished >= trunc(week, 'DAY'))   
where week =trunc (week, 'day' )
group by week
order by week
;

-- місячна база. кількість клієнтів, які були активні хоча б один день в місяці
with tab as (
    select 1, 'name1' as id, to_date('08.01.2020', 'dd.mm.yyyy') as started, to_date('23.01.2020', 'dd.mm.yyyy') as finished from dual union all
    select 2, 'name2' as id, to_date('15.01.2020', 'dd.mm.yyyy')  as started, to_date('22.01.2020', 'dd.mm.yyyy') as finished from dual union all
    select 3, 'name3'as id, to_date('03.02.2020', 'dd.mm.yyyy') as started, to_date('06.04.2020', 'dd.mm.yyyy') as finished from dual 
    )
    
, params as (
    select date'2020-01-01' from#, 4 months# from dual
)
select  to_char (mon, 'MM.YYYY') month, count (id)  as count
from (
    select  add_months (trunc (from#, 'mm'),  level-1 ) mon 
    from params connect by level<=months#)
left join tab on (tab.started <= add_months(mon,1) and tab.finished >= mon)   
group by mon
order by mon

;
-- місячна база. кількість клієнтів на останній один день в місяці
with tab as (
    select 1, 'name1' as id, to_date('08.01.2020', 'dd.mm.yyyy') as started, to_date('23.01.2020', 'dd.mm.yyyy') as finished from dual union all
    select 2, 'name2' as id, to_date('15.01.2020', 'dd.mm.yyyy')  as started, to_date('22.01.2020', 'dd.mm.yyyy') as finished from dual union all
    select 3, 'name3'as id, to_date('03.02.2020', 'dd.mm.yyyy') as started, to_date('06.04.2020', 'dd.mm.yyyy') as finished from dual 
    )
    
, params as (
    select date'2020-01-01' from#, 4 months# from dual
)
select  to_char (add_months(mon,1)-1, 'dd.MM.YYYY') || '  23:59:59' last_day_of_month, count (id)  as count
from (
    select  add_months (trunc (from#, 'mm'),  level-1 ) mon 
    from params connect by level<=months#)
left join tab on (tab.started <= add_months(mon,1) and tab.finished >= add_months(mon,1))   
group by mon
order by mon

;

-- річна база. кількість клієнтів, які були активні хоча б один день в році
with tab as (
    select 1, 'name1' as id, to_date('08.01.2020', 'dd.mm.yyyy') as started, to_date('23.01.2020', 'dd.mm.yyyy') as finished from dual union all
    select 2, 'name2' as id, to_date('15.01.2020', 'dd.mm.yyyy')  as started, to_date('22.01.2020', 'dd.mm.yyyy') as finished from dual union all
    select 3, 'name3'as id, to_date('03.02.2020', 'dd.mm.yyyy') as started, to_date('06.04.2020', 'dd.mm.yyyy') as finished from dual 
    )
    
, params as (
    select date'2020-01-01' from#, 4 years# from dual
)
select to_char (yyyy, 'YYYY') years, count (id)  as count
from (
    select   add_months (trunc (from#, 'yyyy'),  12 *(level-1 )) yyyy 
    from params connect by level<=years#)
left join tab on (tab.started <= add_months(yyyy,12) and tab.finished >= yyyy)   
group by yyyy
order by yyyy
;