DROP TABLE IF EXISTS dwh_2024_s010.etl.flights_i_00;
CREATE TABLE dwh_2024_s010.etl.flights_i_00 AS
SELECT
    MIN(loaded_ts) AS ts1,
    MAX(loaded_ts) AS ts2
FROM dwh_2024_s010.src.flights
WHERE loaded_ts > COALESCE((SELECT MAX(loaded_ts) FROM dwh_2024_s010.etl.flights_load), '1970-01-01');

DROP TABLE IF EXISTS dwh_2024_s010.etl.weather_i_00;
CREATE TABLE dwh_2024_s010.etl.weather_i_00 AS
SELECT
    MIN(loaded_ts) AS ts1,
    MAX(loaded_ts) AS ts2
FROM dwh_2024_s010.src.weather
WHERE loaded_ts > COALESCE((SELECT MAX(loaded_ts) FROM dwh_2024_s010.etl.weather_load), '1970-01-01');