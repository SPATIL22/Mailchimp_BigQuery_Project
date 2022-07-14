---------------------------------------------
---------------------- Initial Exploration --
---------------------------------------------

-- 1. Quick counts check and making sure the keys are unique.
SELECT count(*), count(distinct id) FROM `mailchimp-bigquery-project-1.eu_london_bicycles.cycle_stations`; -- 788 records
SELECT count(*), count(distinct id) FROM `mailchimp-bigquery-project-1.eu_london_bicycles.cycle_stations_update`; -- 791 records

SELECT count(*), count(distinct rental_id) FROM `mailchimp-bigquery-project-1.eu_london_bicycles.cycle_hire`; -- ~ 24.4M records
SELECT count(*), count(distinct rental_id) FROM `mailchimp-bigquery-project-1.eu_london_bicycles.cycle_hire_update`; -- 1.2M records

-- 2. making sure that the records in update tables are present in the base tables.
select count(*), count(distinct s.id)
from `mailchimp-bigquery-project-1.eu_london_bicycles.cycle_stations` s
inner join `mailchimp-bigquery-project-1.eu_london_bicycles.cycle_stations_update` su on cast(s.id as string) = cast(su.id as string); -- 783 records

select count(*), count(distinct h.rental_id)
from `mailchimp-bigquery-project-1.eu_london_bicycles.cycle_hire` h
inner join `mailchimp-bigquery-project-1.eu_london_bicycles.cycle_hire_update` hu on cast(h.rental_id as string) = hu.rental_id; -- 1.2M records (exact match)

-- 3. In Stations table, find records that are not matching.
-- how many records do not need update?
select count(distinct id) from eu_london_bicycles.cycle_stations
where id not in (select id from eu_london_bicycles.cycle_stations_update);

-- how many records do need update?
select count(distinct id) from eu_london_bicycles.cycle_stations
where id in (select id from eu_london_bicycles.cycle_stations_update);

-- how many records are not present in the base table?
select count(distinct id) from eu_london_bicycles.cycle_stations_update
where id not in (select id from eu_london_bicycles.cycle_stations);
-- In case of a real life project, I would have investigated more on these records on - why they are missing?

-- 8 records missing in the base station table -
-- just an example for the above case (to cross-check again that they are actually missing and not the human error from query writing perspective):
-- 95, 112, 240, 366, 489, 591, 713, 716
select * from `mailchimp-bigquery-project-1.eu_london_bicycles.cycle_stations` s
where s.id in (95, 112, 240, 366, 489, 591, 713, 716);

-- check the data for same records in the stations_update table -
select * from `mailchimp-bigquery-project-1.eu_london_bicycles.cycle_stations_update` su
where su.id in (95, 112, 240, 366, 489, 591, 713, 716);

-- 4. In hire table, find records that are not matching.
-- how many records do not need update?
select count(distinct rental_id) from eu_london_bicycles.cycle_hire
where rental_id not in (select rental_id from eu_london_bicycles.cycle_hire_update);

-- how many records do need update?
select count(distinct rental_id) from eu_london_bicycles.cycle_hire
where rental_id in (select rental_id from eu_london_bicycles.cycle_hire_update);

-- how many records are not present in the base table?
select count(distinct rental_id) from eu_london_bicycles.cycle_hire_update
where rental_id not in (select rental_id from eu_london_bicycles.cycle_hire);
