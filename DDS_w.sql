insert into
dwh_2024_s010.dds.airport_weather(airport_dk,weather_type_dk,cold,rain,snow,thunderstorm,drizzle,fog_mist,t,max_gws,w_speed,date_start,date_end,loaded_ts)
select * from weather_for_dds;