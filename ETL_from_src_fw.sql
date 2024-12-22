DROP TABLE IF EXISTS dwh_2024_s010.etl.flights_i_01;
CREATE TABLE
    dwh_2024_s010.etl.flights_i_01 AS
SELECT DISTINCT
    ON (
        fl_date,
        op_carrier_fl_num,
        origin,
        dest,
        crs_dep_time
    ) year,
    quarter,
    month,
    fl_date,
    op_unique_carrier,
    tail_num,
    op_carrier_fl_num,
    origin,
    dest,
    crs_dep_time,
    dep_time,
    dep_delay_new,
    cancelled,
    cancellation_code,
    air_time,
    distance,
    weather_delay,
    loaded_ts
FROM
    dwh_2024_s010.src.flights,
    dwh_2024_s010.etl.flights_i_00
WHERE
    loaded_ts BETWEEN ts1 AND ts2
ORDER BY
    fl_date,
    op_carrier_fl_num,
    origin,
    dest,
    crs_dep_time,
    loaded_ts DESC;

DROP TABLE IF EXISTS dwh_2024_s010.etl.weather_i_01;
CREATE TABLE
    dwh_2024_s010.etl.weather_i_01 AS
select distinct
    on (local_datetime) local_datetime,
    t_air_temperature,
    p0_sea_lvl,
    p_station_lvl,
    u_humidity,
    dd_wind_direction,
    ff_wind_speed,
    ff10_max_gust_value,
    ww_present,
    ww_recent,
    c_total_clouds,
    vv_horizontal_visibility,
    td_temperature_dewpoint,
    loaded_ts
FROM
    dwh_2024_s010.src.weather,
    dwh_2024_s010.etl.weather_i_00
WHERE
    loaded_ts >= ts1
    AND loaded_ts <= ts2
ORDER BY
    local_datetime,
    loaded_ts desc;