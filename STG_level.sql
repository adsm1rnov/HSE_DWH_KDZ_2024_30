DROP TABLE IF EXISTS dwh_2024_s010.stg.weather;

CREATE TABLE
    dwh_2024_s010.stg.weather (
        local_datetime varchar(25) NOT NULL,
        t_air_temperature numeric(3, 1) NOT NULL,
        p0_sea_lvl numeric(4, 1) NOT NULL,
        p_station_lvl numeric(4, 1) NOT NULL,
        u_humidity int4 NOT NULL,
        dd_wind_direction varchar(100) NULL,
        ff_wind_speed int4 NULL,
        ff10_max_gust_value int4 NULL,
        ww_present varchar(100) NULL,
        ww_recent varchar(50) NULL,
        c_total_clouds varchar(200) NOT NULL,
        vv_horizontal_visibility numeric(3, 1) NOT NULL,
        td_temperature_dewpoint numeric(3, 1) NOT NULL,
        processed_dttm timestamp NOT NULL DEFAULT now (),
        PRIMARY KEY (local_datetime)
    );

DROP TABLE IF EXISTS dwh_2024_s010.stg.flights;

CREATE TABLE
    dwh_2024_s010.stg.flights (
        year int NOT NULL,
        quarter int NULL,
        month int NOT NULL,
        fl_date varchar(30) NOT NULL,
        op_unique_carrier varchar(10) NULL,
        tail_num varchar(10) NULL,
        op_carrier_fl_num varchar(15) NOT NULL,
        origin varchar(10) NULL,
        dest varchar(10) NULL,
        crs_dep_time time NOT NULL,
        dep_time time NULL,
        dep_delay_new float NULL,
        cancelled float NOT NULL,
        cancellation_code char(1) NULL,
        air_time float NULL,
        distance float NULL,
        weather_delay float NULL,
        loaded_ts timestamp DEFAULT now (),
        CONSTRAINT flights_pkey PRIMARY KEY (
            fl_date,
            op_carrier_fl_num,
            origin,
            dest,
            crs_dep_time
        )
    );