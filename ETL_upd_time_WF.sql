DELETE FROM dwh_2024_s010.etl.flights_load
WHERE EXISTS (SELECT 1 FROM dwh_2024_s010.etl.flights_i_00);

INSERT INTO dwh_2024_s010.etl.flights_load (loaded_ts)
SELECT ts2
FROM dwh_2024_s010.etl.flights_i_00
WHERE ts2 IS NOT NULL;


DELETE FROM dwh_2024_s010.etl.weather_load
WHERE EXISTS (SELECT 1 FROM dwh_2024_s010.etl.weather_i_00);

INSERT INTO dwh_2024_s010.etl.weather_load (loaded_ts)
SELECT ts2
FROM dwh_2024_s010.etl.weather_i_00
WHERE ts2 IS NOT NULL;

