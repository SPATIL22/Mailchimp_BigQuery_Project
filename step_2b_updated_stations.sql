---------------------------------------------
---------------------- Update tables --------
---------------------------------------------

-- Update the table by using union all and without using DML:

-- stations --

create or replace table `mailchimp-bigquery-project-1.eu_london_bicycles.updated_stations` as
(
with stations_without_gcs_records as
(
select
cast(id as string) id,
cast(name	as string) name,
cast(latitude as int) latitude,
cast(longitude as int) longitude,

cast(temporary as boolean) temporary,
cast(installed as boolean) installed,
cast(locked as boolean) locked,

cast(terminal_name as string) terminal_name,
cast(install_date as timestamp) install_date,
cast(removal_date as timestamp) removal_date,

cast(bikes_count as int) bikes_count,
cast(docks_count as int) docks_count,
cast(nbEmptyDocks as int) nbEmptyDocks

from `mailchimp-bigquery-project-1.eu_london_bicycles.cycle_stations` s
where cast(s.id as string) not in (select cast(su.id as string) from `mailchimp-bigquery-project-1.eu_london_bicycles.cycle_stations_update` su)
),

stations_gcs_records as
(select
cast(id as string) id,
cast(name	as string) name,
cast(latitude as int) latitude,
cast(longitude as int) longitude,

cast(temporary as boolean) temporary,
cast(installed as boolean) installed,
cast(locked as boolean) locked,

cast(terminal_name as string) terminal_name,
cast(install_date as timestamp) install_date,
cast(removal_date as timestamp) removal_date,

cast(bikes_count as int) bikes_count,
cast(docks_count as int) docks_count,
cast(nbEmptyDocks as int) nbEmptyDocks
from `mailchimp-bigquery-project-1.eu_london_bicycles.cycle_stations_update`)

select * from stations_without_gcs_records
union all
select * from stations_gcs_records
);
