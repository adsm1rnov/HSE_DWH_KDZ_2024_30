DROP TABLE IF EXISTS mart.fact_departure;
CREATE TABLE mart.fact_departure (
   airport_origin_dk INT NOT NULL,
   airport_destination_dk INT NOT NULL,
   weather_type_dk INT,
   flight_scheduled_ts TIMESTAMP NOT NULL,
   flight_actual_time TIMESTAMP,
   flight_number INT NOT NULL,
   distance INT,
   tail_number VARCHAR(50),
   airline VARCHAR(50),
   dep_delay_min INT,
   cancelled BOOLEAN,
   cancellation_code VARCHAR(10),
   t TIMESTAMP,
   max_gws NUMERIC(10, 2),
   w_speed NUMERIC(10, 2),
   air_time INT,
   author INT,
   loaded_ts TIMESTAMP DEFAULT NOW(),
   PRIMARY KEY (airport_origin_dk, airport_destination_dk, flight_scheduled_ts, flight_number)
);
CREATE OR REPLACE TEMP VIEW data_for_mart_fact_dep AS (
 SELECT DISTINCT ON (f.flight_dep_scheduled_ts, f.flight_number_reporting_airline, f.tail_number)
   f.airport_origin_dk,
   f.airport_dest_dk AS airport_destination_dk,
   w.weather_type_dk,
   f.flight_dep_scheduled_ts AS flight_scheduled_ts,
   f.flight_dep_actual_ts AS flight_actual_time,
   f.flight_number_reporting_airline AS flight_number,
   f.distance,
   f.tail_number,
   f.report_airline AS airline,
   f.dep_delay_minutes AS dep_delay_min,
   f.cancelled,
   f.cancellation_code,
   w.t AS t,
   w.max_gws AS max_gust_wind_speed,
   w.w_speed AS wind_speed,
   f.air_time,
   30 AS author,
   NOW() AS loaded_ts
 FROM dds.flights f
 INNER JOIN dds.airport_weather w
   ON f.airport_origin_dk = w.airport_dk
   AND f.flight_dep_scheduled_ts::timestamp BETWEEN w.date_start::timestamp AND w.date_start::timestamp + INTERVAL '1 hour'
);
SELECT * FROM data_for_mart_fact_dep LIMIT 10;
INSERT INTO mart.fact_departure (
   airport_origin_dk,
   airport_destination_dk,
   weather_type_dk,
   flight_scheduled_ts,
   flight_actual_time,
   flight_number,
   distance,
   tail_number,
   airline,
   dep_delay_min,
   cancelled,
   cancellation_code,
   t,
   max_gws,
   w_speed,
   air_time,
   author,
   loaded_ts
)
SELECT
   airport_origin_dk,
   airport_destination_dk,
   CAST(weather_type_dk AS INTEGER) AS weather_type_dk,
   flight_scheduled_ts,
   flight_actual_time,
   CAST(flight_number AS INTEGER) AS flight_number,
   CAST(distance AS INTEGER) AS distance,
   tail_number,
   airline,
   dep_delay_min,
   cancelled::boolean AS cancelled,
   cancellation_code,
   TIMESTAMP '1970-01-01 00:00:00' + (t * INTERVAL '1 second') AS t,
   max_gust_wind_speed,
   wind_speed,
   air_time,
   author,
   loaded_ts
FROM data_for_mart_fact_dep
WHERE tail_number IS NOT NULL;