---------------------------------------------
---------- Validation of a updated_stations and updated_hire tables --
---------------------------------------------

-- validate updated_stations table
----------------------------------------------------
select * from eu_london_bicycles.updated_stations
where id in ('654', '744', '780')
order by id;
-- docks_count: 34 | 30 | 25

select * from eu_london_bicycles.cycle_stations
where id in (654, 744, 780)
order by id;
-- docks_count: 34 | 30 | 25

-- validate updated_hire table
----------------------------------------------------
select * from eu_london_bicycles.updated_hire
where rental_id in ('55699977', '43831498', '56155374')
order by rental_id;
-- end_station_id: 265 | 638 | 33

select * from eu_london_bicycles.cycle_hire
where rental_id in (55699977, 43831498, 56155374)
order by rental_id;
-- end_station_id: 265 | 638 | 33

---------------------------------------------
---------- Validation of a reporting_table --
-- assuming that the intermediate table are accurate and properly validated against raw data --
---------------------------------------------

---------------------------------------------
-- (1) Take an example station_id and an example day
---------------------------------------------
-- look into the raw data for total number of rides started on that day.
-- look into the raw data for total number of rides started on that day.
-- look for the common station rode to from this station on that day.

-- example 1. station_id = 435 and day = '2015-04-11'
----------------------------------------------------
-- Run the query against base tables
select
count( distinct rental_id ) as no_of_rides_started
, count( distinct bike_id ) as no_of_bikes_started
, max(end_station_id) as common_station_id_rode_to

from eu_london_bicycles.updated_hire h
where h.start_station_id = '435' and date(h.start_date) = '2015-04-11';
-- output is 14 | 14 | 756

-- Run the query against base transformed table.
select
no_of_rides_started
, no_of_bikes_started
, common_station_id_rode_to

from eu_london_bicycles.reporting_table r
where r.station_id = '435' and r.dim_date = '2015-04-11';
-- output is 14 | 14 | 756

-- example 2. station_id = 368 and day = '2016-06-26'
----------------------------------------------------
-- Run the query against base tables
select
count( distinct rental_id ) as no_of_rides_started
, count( distinct bike_id ) as no_of_bikes_started
, max(end_station_id) as common_station_id_rode_to

from eu_london_bicycles.updated_hire h
where h.start_station_id = '368' and date(h.start_date) = '2016-06-26';
-- output is 64 | 54 | 726

-- Run the query against base transformed table.
select
no_of_rides_started
, no_of_bikes_started
, common_station_id_rode_to

from eu_london_bicycles.reporting_table r
where r.station_id = '368' and r.dim_date = '2016-06-26';
-- output is 64 | 54 | 726

-- example 3. station_id = 248 and day = '2016-07-16'
----------------------------------------------------
-- Run the query against base tables
select
count( distinct rental_id ) as no_of_rides_started
, count( distinct bike_id ) as no_of_bikes_started
, max(end_station_id) as common_station_id_rode_to

from eu_london_bicycles.updated_hire h
where h.start_station_id = '248' and date(h.start_date) = '2016-07-16';
-- output is 406 | 333 | 781

-- Run the query against base transformed table.
select
no_of_rides_started
, no_of_bikes_started
, common_station_id_rode_to

from eu_london_bicycles.reporting_table r
where r.station_id = '248' and r.dim_date = '2016-07-16';
-- output is 406 | 333 | 781

-- some more examples to validate if time permits --
-- example 4. station_id = 534 and day = '2017-06-03'
----------------------------------------------------
-- example 5. station_id = 76 and day = '2016-07-14'
----------------------------------------------------

---------------------------------------------
-- (2) Take an example station_id and an example day
---------------------------------------------
-- look into the raw data for total number of rides ended on that day.
-- look into the raw data for total number of rides ended on that day.
-- look for the common station rode from to this station on that day.

-- example 1. station_id = 25 and day = '2016-06-26'
----------------------------------------------------
-- Run the query against base tables
select
count( distinct rental_id ) as no_of_rides_ended
, count( distinct bike_id ) as no_of_bikes_ended
, max(start_station_id) as common_station_id_rode_from

from eu_london_bicycles.updated_hire h
where h.end_station_id = '25' and date(h.end_date) = '2016-06-26';
-- output is 31 | 30 | 98

-- Run the query against base transformed table.
select
no_of_rides_ended
, no_of_bikes_ended
, common_station_id_rode_from

from eu_london_bicycles.reporting_table r
where r.station_id = '25' and r.dim_date = '2016-06-26';
-- output is 31 | 30 | 98

-- example 2. station_id = 233 and day = '2015-05-11'
----------------------------------------------------
-- Run the query against base tables
select
count( distinct rental_id ) as no_of_rides_ended
, count( distinct bike_id ) as no_of_bikes_ended
, max(start_station_id) as common_station_id_rode_from

from eu_london_bicycles.updated_hire h
where h.end_station_id = '233' and date(h.end_date) = '2015-05-11';
-- output is 104 | 101 | 94

-- Run the query against base transformed table.
select
no_of_rides_ended
, no_of_bikes_ended
, common_station_id_rode_from

from eu_london_bicycles.reporting_table r
where r.station_id = '233' and r.dim_date = '2015-05-11';
-- output is 104 | 101 | 94

-- example 3. station_id = 638 and day = '2016-07-08'
----------------------------------------------------
-- Run the query against base tables
select
count( distinct rental_id ) as no_of_rides_ended
, count( distinct bike_id ) as no_of_bikes_ended
, max(start_station_id) as common_station_id_rode_from

from eu_london_bicycles.updated_hire h
where h.end_station_id = '638' and date(h.end_date) = '2016-07-08';
-- output is 65 | 63 | 9

-- Run the query against base transformed table.
select
no_of_rides_ended
, no_of_bikes_ended
, common_station_id_rode_from

from eu_london_bicycles.reporting_table r
where r.station_id = '638' and r.dim_date = '2016-07-08';
-- output is 65 | 63 | 9

-- some more examples to validate if time permits --
-- example 4. station_id = 386 and day = '2016-07-14'
-- example 5. station_id = 692 and day = '2017-06-03'


---------------------------------------------
-- (3) Take an example station_id and an example day
---------------------------------------------
-- look into the raw data for time_spent_on_rides that started from this station on that day.
-- similaryly, look into the raw data for avg_time_spent_on_rides that started from this station on that day.
-- similaryly, look into the raw data for median_time_spent_on_rides that started from this station on that day.

-- example 1. overall aggregates
----------------------------------------------------
-- Run the query against base tables
with dim_date as
(
select day
from unnest(generate_date_array(date('2015-01-04'), date('2017-06-14'), interval 1 day)) as day
),

station as
(select id station_id from eu_london_bicycles.updated_stations),

-- day, station
reporting_grain as
(
select station_id, date(day) dim_date
from station cross join dim_date
order by station_id, dim_date
)

select distinct
sum(duration) over() total_time_spent_on_rides
, avg(duration) over() avg_time_spent_on_rides
, percentile_disc(duration, 0.5) over() median_time_spent_on_rides

from reporting_grain g
left join eu_london_bicycles.updated_hire h on g.station_id = h.start_station_id and g.dim_date = date(h.start_date);
-- output of the query is 31086965820 | 1314.09 | 840

-- Run the query against base transformed table.
select distinct
total_time_spent_on_rides
, avg_time_spent_on_rides
, median_time_spent_on_rides

from eu_london_bicycles.reporting_table;
-- output of the query is 31086965820 | 1314.09 | 840

-- example 2. station_id = 76
----------------------------------------------------
-- Run the query against base tables
with dim_date as
(
select day
from unnest(generate_date_array(date('2015-01-04'), date('2017-06-14'), interval 1 day)) as day
),

station as
(select id station_id from eu_london_bicycles.updated_stations),

-- day, station
reporting_grain as
(
select station_id, date(day) dim_date
from station cross join dim_date
order by station_id, dim_date
)

select distinct
sum(duration) over(partition by g.station_id) time_spent_on_rides_by_station
, avg(duration) over(partition by g.station_id) avg_time_spent_on_rides_by_station
, percentile_disc(duration, 0.5) over(partition by g.station_id) median_time_spent_on_rides_by_station

from reporting_grain g
left join eu_london_bicycles.updated_hire h on g.station_id = h.start_station_id and g.dim_date = date(h.start_date)
where g.station_id = '76';
-- output of the query is 30606840 | 1366.4987945352264 | 720

-- Run the query against base transformed table.
select distinct
time_spent_on_rides_by_station
, avg_time_spent_on_rides_by_station
, median_time_spent_on_rides_by_station

from eu_london_bicycles.reporting_table
where station_id = '76';
-- output of the query is 30606840 | 1366.5 | 720

-- example 3. station_id = 76 and day = '2016-07-14'
----------------------------------------------------

-- Run the query against base tables
with dim_date as
(
select day
from unnest(generate_date_array(date('2015-01-04'), date('2017-06-14'), interval 1 day)) as day
),

station as
(select id station_id from eu_london_bicycles.updated_stations),

-- day, station
reporting_grain as
(
select station_id, date(day) dim_date
from station cross join dim_date
order by station_id, dim_date
)

select distinct
sum(duration) over(partition by g.station_id, g.dim_date) time_spent_on_rides_by_station_by_day
, avg(duration) over(partition by g.station_id, g.dim_date) avg_time_spent_on_rides_by_station_by_day
, percentile_disc(duration, 0.5) over(partition by g.station_id, g.dim_date) median_time_spent_on_rides_by_station_by_day

from reporting_grain g
left join eu_london_bicycles.updated_hire h on g.station_id = h.start_station_id and g.dim_date = date(h.start_date)
where g.station_id = '76' and g.dim_date = '2016-07-14';
-- output of the query is 36000 | 1058.8235294117646 | 780

-- Run the query against base transformed table.
select distinct
time_spent_on_rides_by_station_by_day
, avg_time_spent_on_rides_by_station_by_day
, median_time_spent_on_rides_by_station_by_day

from eu_london_bicycles.reporting_table
where station_id = '76' and dim_date = '2016-07-14';
-- output of the query is 36000 | 1058.82 | 780
