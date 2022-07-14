---------------------------------------------
---------------------- Update tables --------
---------------------------------------------

-- Update the table by using union all and without using DML:

-- hire --
create or replace table `mailchimp-bigquery-project-1.eu_london_bicycles.updated_hire` as
(
with hire_without_gcs_records as
(
select
  cast(rental_id as string) rental_id,
  cast(bike_id as string) bike_id,
  cast(duration as int) duration,

  cast(start_date as timestamp) start_date,
  cast(end_date as timestamp) end_date,
  cast(start_station_id as string) start_station_id,
  cast(end_station_id as string) end_station_id,
  cast(start_station_name as string) start_station_name,
  cast(end_station_name as string) end_station_name,
  cast(start_station_logical_terminal as string) start_station_logical_terminal,
  cast(end_station_logical_terminal as string) end_station_logical_terminal,
  cast(end_station_priority_id as string) end_station_priority_id

from `mailchimp-bigquery-project-1.eu_london_bicycles.cycle_hire` h
where cast(h.rental_id as string) not in (select cast(hu.rental_id as string) from `mailchimp-bigquery-project-1.eu_london_bicycles.cycle_hire_update` hu)
),

hire_gcs_records as
(select
  cast(rental_id as string) rental_id,
  cast(bike_id as string) bike_id,
  cast(duration as int) duration,

  cast(start_date as timestamp) start_date,
  cast(end_date as timestamp) end_date,
  cast(start_station_id as string) start_station_id,
  cast(end_station_id as string) end_station_id,
  cast(start_station_name as string) start_station_name,
  cast(end_station_name as string) end_station_name,
  cast(start_station_logical_terminal as string) start_station_logical_terminal,
  cast(end_station_logical_terminal as string) end_station_logical_terminal,
  cast(end_station_priority_id as string) end_station_priority_id
from `mailchimp-bigquery-project-1.eu_london_bicycles.cycle_hire_update`)

select * from hire_without_gcs_records
union all
select * from hire_gcs_records
);
