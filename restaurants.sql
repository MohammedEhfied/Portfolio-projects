-- data exploration

select *
from restaurants

---------------------------------------------------------------------

-- figuring out how many restaurant does every company have

with cte1 as
(select SUBSTRING(name, 1, 5) sub_name1, count(*) number_of_restaurants
from restaurants
group by SUBSTRING(name, 1, 5)
)
,cte2 as
(select SUBSTRING(name, 1, 5) sub_name2 ,*
from restaurants
)
select top 0 id, sub_name1, name, number_of_restaurants into #temp_restaurants
from cte1 a
join cte2 b
on a.sub_name1 = b.sub_name2;

with cte1 as
(select SUBSTRING(name, 1, 5) sub_name1, count(*) number_of_restaurants
from restaurants
group by SUBSTRING(name, 1, 5)
)
,cte2 as
(select SUBSTRING(name, 1, 5) sub_name2 ,*
from restaurants
)
Insert Into #temp_restaurants
select id, sub_name1, name, number_of_restaurants
from cte1 a
join cte2 b
on a.sub_name1 = b.sub_name2;

delete
from #temp_restaurants
where id NOT IN (
        select min(id) AS MinRecordID
        from #temp_restaurants
        group by sub_name1);

select case when name like '%(%' then substring(name ,1 ,charindex('(', name) -1)
	   else name
	   end restaurant_name,  number_of_restaurants
from #temp_restaurants
order by 2 desc


-- top 10 popular restaurants based on ratings and score 

select top 10 name, round(ratings / score, 2) popularity, ratings, score
from restaurants 
where ratings is not null and score is not null
order by 2 desc, 4 desc


-- number of restaurants in every state

with states_cte as (
select trim(value) abbreviation, count(value) num_of_restaurants
from restaurants 
CROSS APPLY string_split(full_address, ',')
group by value
having len(trim(value)) = 2 )
select a.abbreviation,  b.State, a.num_of_restaurants
from states_cte a
join master..states b
on a.abbreviation = b.Abbreviation
order by 3 desc


-- sort restaurants according to number of menus and low prices 

select name, count(menu_name) num_of_dishes
, round(AVG(cast(SUBSTRING(price,1,CHARINDEX(' ',price)) as float)),2) average_price
from restaurants a
join menus b
on a.id = b.restaurant_id
group by id, name
order by 2 desc, 3


-- top 10 categories based on number of repetitions and score 

select top 10 b.category, COUNT(b.category) num_of_category, AVG(a.score) average_score
from restaurants a
join menus b
on a.id = b.restaurant_id
where a.price_range = 'Very expensive'
group by b.category
order by 2 desc, 3 desc

