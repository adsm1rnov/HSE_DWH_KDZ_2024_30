INSERT INTO
    dwh_2024_s010.stg.weather (
        local_datetime,
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
        processed_dttm
    )
SELECT
    local_datetime,
    COALESCE(t_air_temperature, 0) AS t_air_temperature,
    COALESCE(p0_sea_lvl, 0) AS p0_sea_lvl,
    p_station_lvl,
    COALESCE(u_humidity, 0) AS u_humidity,
    dd_wind_direction,
    ff_wind_speed,
    ff10_max_gust_value,
    ww_present,
    ww_recent,
    c_total_clouds,
    COALESCE(vv_horizontal_visibility, 0) AS vv_horizontal_visibility,
    COALESCE(td_temperature_dewpoint, 0) AS td_temperature_dewpoint,
    NOW ()
FROM
    dwh_2024_s010.etl.weather_i_01 ON CONFLICT (local_datetime) DO
UPDATE
SET
    t_air_temperature = COALESCE(EXCLUDED.t_air_temperature, 0),
    p0_sea_lvl = COALESCE(EXCLUDED.p0_sea_lvl, 0),
    p_station_lvl = EXCLUDED.p_station_lvl,
    u_humidity = COALESCE(EXCLUDED.u_humidity, 0),
    dd_wind_direction = EXCLUDED.dd_wind_direction,
    ff_wind_speed = EXCLUDED.ff_wind_speed,
    ff10_max_gust_value = EXCLUDED.ff10_max_gust_value,
    ww_present = EXCLUDED.ww_present,
    ww_recent = EXCLUDED.ww_recent,
    c_total_clouds = EXCLUDED.c_total_clouds,
    vv_horizontal_visibility = COALESCE(EXCLUDED.vv_horizontal_visibility, 0),
    td_temperature_dewpoint = COALESCE(EXCLUDED.td_temperature_dewpoint, 0),
    processed_dttm = NOW ();

INSERT INTO
    dwh_2024_s010.stg.flights (
        year,
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
    )
SELECT
    year,
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
    dwh_2024_s010.etl.flights_i_01 ON CONFLICT (
        fl_date,
        op_carrier_fl_num,
        origin,
        dest,
        crs_dep_time
    ) DO
UPDATE
SET
    year = EXCLUDED.year,
    quarter = EXCLUDED.quarter,
    month = EXCLUDED.month,
    dep_time = EXCLUDED.dep_time,
    dep_delay_new = EXCLUDED.dep_delay_new,
    cancelled = EXCLUDED.cancelled,
    cancellation_code = EXCLUDED.cancellation_code,
    air_time = EXCLUDED.air_time,
    distance = EXCLUDED.distance,
    weather_delay = EXCLUDED.weather_delay,
    loaded_ts = EXCLUDED.loaded_ts;