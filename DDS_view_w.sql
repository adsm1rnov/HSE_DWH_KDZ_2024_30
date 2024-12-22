-- вспомогательный view для weather
create or replace temp view stage_weather_by_types as
select
w.local_datetime,
case
when w.ww_present like '%rain%' or w.ww_recent like '%rain%' then 1
else 0
end as rain,
case
when w.ww_present like '%snow%' or w.ww_recent like '%snow%' then 1
else 0
end as snow,
case
when w.ww_present like '%thunderstorm%' or w.ww_recent like '%thunderstorm%'
then 1
else 0
end as thunderstorm,
case
when w.ww_present like '%fog%' or w.ww_recent like '%fog%' or w.ww_present like
'%mist%' or w.ww_recent like '%mist%' then 1
else 0
end as fog_mist,
case
when w.ww_present like '%drizzle%' or w.ww_recent like '%drizzle%' then 1
else 0
end as drizzle,
case
when w.t_air_temperature<0 then 1
else 0
end as cold
from dwh_2024_s010.stg.weather w;

--  view для загрузки в weather
create or replace temp view weather_for_dds as
select 19929 as airport_dk,
concat(qwe.cold, qwe.rain, qwe.snow, qwe.thunderstorm, qwe.drizzle, qwe.fog_mist) as
weather_type_dk,
qwe.cold,
qwe.rain,
qwe.snow,
qwe.thunderstorm,
qwe.drizzle,
qwe.fog_mist,
w.t_air_temperature as t,
w.ff10_max_gust_value as max_gws,
w.ff_wind_speed as w_speed,
w.local_datetime::timestamp as date_start,
COALESCE((lead(w.local_datetime) over (order by
w.local_datetime))::timestamp,w.local_datetime::timestamp+interval '1 minute') as date_end,
now() as loaded_ts
from dwh_2024_s010.stg.weather w
inner join (select * from stage_weather_by_types) as qwe on w.local_datetime = qwe.local_datetime;

