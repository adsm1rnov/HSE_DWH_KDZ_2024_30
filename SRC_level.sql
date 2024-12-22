DROP TABLE IF EXISTS dwh_2024_s010.src.flights;
CREATE TABLE
    dwh_2024_s010.src.flights (
        year INT NOT NULL,
        quarter INT NULL,
        month INT NOT NULL,
        fl_date VARCHAR(30) NOT NULL,
        op_unique_carrier VARCHAR(10) NULL,
        tail_num VARCHAR(10) NULL,
        op_carrier_fl_num VARCHAR(15) NOT NULL,
        origin VARCHAR(10) NULL,
        dest VARCHAR(10) NULL,
        crs_dep_time TIME NOT NULL,
        dep_time TIME NULL,
        dep_delay_new FLOAT NULL,
        cancelled FLOAT NOT NULL,
        cancellation_code CHAR(1) NULL,
        air_time FLOAT NULL,
        distance FLOAT NULL,
        weather_delay FLOAT NULL,
        loaded_ts TIMESTAMP DEFAULT NOW ()
    );

DROP TABLE IF EXISTS dwh_2024_s010.src.weather;
CREATE TABLE
    dwh_2024_s010.src.weather (
        local_datetime VARCHAR(25) NOT NULL,
        t_air_temperature NUMERIC(3, 1) NULL,
        p0_sea_lvl NUMERIC(4, 1) NULL,
        p_station_lvl NUMERIC(4, 1) NULL,
        u_humidity INT4 NULL,
        dd_wind_direction VARCHAR(100) NULL,
        ff_wind_speed INT4 NULL,
        ff10_max_gust_value INT4 NULL,
        ww_present VARCHAR(100) NULL,
        ww_recent VARCHAR(50) NULL,
        c_total_clouds VARCHAR(200) NULL,
        vv_horizontal_visibility NUMERIC(3, 1) NULL,
        td_temperature_dewpoint NUMERIC(3, 1) NULL,
        loaded_ts TIMESTAMP NOT NULL DEFAULT NOW ()
    );