/* Data cleaning */

select *
from realestate

---------------------------------------------

-- cleaning provider column --

update realestate
set provider = SUBSTRING(provider,1,CHARINDEX(' ',provider))
from realestate

update realestate
set provider = 'developer'
where provider = 'Застройщик' -- because (Застройщик) is a russian word means developer

-- getting rid of extra spaces in metro column

update realestate
set metro = trim(metro)

-- fixing total area column

update realestate
set total_area  = living_area + kitchen_area
where total_area <> living_area + kitchen_area

select *
from realestate
where total_area <> living_area + kitchen_area


-- trying to fix 'No data' records in metro column

update realestate
set metro = null
where metro = 'No data'

update a
set metro = ISNULL(a.metro,b.metro)
from realestate a
join realestate b
	on a.views = b.views
	and a.storeys = b.storeys
	and a.provider = b.provider
	and a.id <> b.id
where a.metro is null

-- showing duplicates

with dup_cte as (
select *,
ROW_NUMBER() over ( partition by  metro, price, way, views, provider, storeys, storey
				 order by id ) repetition
from realestate
)
select *
from dup_cte
where repetition > 1  -- most of records are duplicates :(

--

select *
from realestate



