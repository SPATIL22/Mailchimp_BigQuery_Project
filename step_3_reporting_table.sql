-- what should be the minimum and maximum dates of the reporting table?
-- ideally it should be till current_date, but just for the simplicity of this project, I am ending at the max end date.
-- -- Otherwise, we would have a lot of unneccessary records starting from 2017 till 2022 today.
-- select min(start_date), min(end_date), max(start_date), max(end_date) from eu_london_bicycles.updated_hire;
-- hence, min_date = "2015-01-04" and max_date = "2017-06-14" --

'''
* The table should have a record for every day and station and include the following aggregates:
    * # of rides (and bikes) that started at the station
    * # of rides (and bikes) that ended at the station
    * The total amount of time spent on a rides
    * The avg amount of time spent on a rides
    * The median amount of time spent on a rides
    * The most common station that people rode to from that station
    * The most common station that people rode from to that station
    * Any other useful stats you can think of (including from other datasets if you’re feeling adventurous) 
'''

-- day, station
-- no_of_rides_started (that started at the station)
-- no_of_rides_ended (that ended at the station)
-- no_of_bikes (that started at the station)
-- no_of_bikes (that ended at the station)
-- time_spent_on_rides (sum of duration)
-- avg_time_spent_on_rides (within the station) -- assumption
-- median_time_spent_on_rides (within the station) -- assumption
-- common_station_rode_to (max no of rides to which station?)
-- common_station_rode_from  (max no of rides from which station?)
--

create or replace table `mailchimp-bigquery-project-1.eu_london_bicycles.reporting_table` as
(

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
),

-- no_of_rides and bikes (that started at the station)
started as
(
select
g.station_id, g.dim_date
, count( distinct rental_id ) as no_of_rides_started
, count( distinct bike_id ) as no_of_bikes_started
, max(end_station_id) as common_station_id_rode_to

from reporting_grain g
left join eu_london_bicycles.updated_hire h on g.station_id = h.start_station_id and g.dim_date = date(h.start_date)
group by g.station_id, g.dim_date
),

-- no_of_rides and bikes (that ended at the station)
ended as
(
select
g.station_id, g.dim_date
, count( distinct rental_id ) as no_of_rides_ended
, count( distinct bike_id ) as no_of_bikes_ended
, max(start_station_id) as common_station_id_rode_from

from reporting_grain g
left join eu_london_bicycles.updated_hire h on g.station_id = h.end_station_id and g.dim_date = date(h.end_date)
group by g.station_id, g.dim_date
),

-- time_spent_on_rides (from the station *** ASSUMPTION *** )
-- select date_diff(timestamp('2016-06-26 15:13:00'), timestamp('2016-06-26 14:40:00'), second) from eu_london_bicycles.updated_hire limit 10;
time_spent_on_rides as -- that have started from the station.
(
select distinct
g.station_id, g.dim_date
, sum(duration) over() total_time_spent_on_rides
, avg(duration) over() avg_time_spent_on_rides
, percentile_disc(duration, 0.5) over() median_time_spent_on_rides

, sum(duration) over(partition by g.station_id) time_spent_on_rides_by_station
, avg(duration) over(partition by g.station_id) avg_time_spent_on_rides_by_station
, percentile_disc(duration, 0.5) over(partition by g.station_id) median_time_spent_on_rides_by_station

, sum(duration) over(partition by g.station_id, g.dim_date) time_spent_on_rides_by_station_by_day
, avg(duration) over(partition by g.station_id, g.dim_date) avg_time_spent_on_rides_by_station_by_day
, percentile_disc(duration, 0.5) over(partition by g.station_id, g.dim_date) median_time_spent_on_rides_by_station_by_day

from reporting_grain g
left join eu_london_bicycles.updated_hire h on g.station_id = h.start_station_id and g.dim_date = date(h.start_date)
)


select
b.station_id, b.dim_date

, b.no_of_rides_started
, b.no_of_bikes_started

, b.no_of_rides_ended
, b.no_of_bikes_ended

, b.common_station_id_rode_to
, b.common_station_id_rode_from

, ts.total_time_spent_on_rides
, round(ts.avg_time_spent_on_rides, 2) avg_time_spent_on_rides
, ts.median_time_spent_on_rides

, ts.time_spent_on_rides_by_station
, round(ts.avg_time_spent_on_rides_by_station, 2) avg_time_spent_on_rides_by_station
, ts.median_time_spent_on_rides_by_station

, ts.time_spent_on_rides_by_station_by_day
, round(ts.avg_time_spent_on_rides_by_station_by_day, 2) avg_time_spent_on_rides_by_station_by_day
, ts.median_time_spent_on_rides_by_station_by_day

from

(select
a.station_id, a.dim_date
, a.no_of_rides_started
, a.no_of_bikes_started
, a.common_station_id_rode_to
, e.no_of_rides_ended
, e.no_of_bikes_ended
, e.common_station_id_rode_from

from

(select g.station_id, g.dim_date
, no_of_rides_started
, no_of_bikes_started
, common_station_id_rode_to

from reporting_grain g left join started s on g.station_id = s.station_id and g.dim_date = s.dim_date) a
left join ended e on a.station_id = e.station_id and a.dim_date = e.dim_date) b
left join time_spent_on_rides ts on b.station_id = ts.station_id and b.dim_date = ts.dim_date

)
;
