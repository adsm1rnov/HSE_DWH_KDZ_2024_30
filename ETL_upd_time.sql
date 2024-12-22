DROP TABLE IF EXISTS dwh_2024_s010.etl.flights_load;
CREATE TABLE
    IF NOT EXISTS dwh_2024_s010.etl.flights_load (loaded_ts TIMESTAMP NOT NULL PRIMARY KEY);

DROP TABLE IF EXISTS dwh_2024_s010.etl.weather_load;
CREATE TABLE
    IF NOT EXISTS dwh_2024_s010.etl.weather_load (loaded_ts TIMESTAMP NOT NULL PRIMARY KEY);