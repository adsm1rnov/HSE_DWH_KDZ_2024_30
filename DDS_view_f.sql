-- Создаем представление time_flight
CREATE OR REPLACE TEMP VIEW time_flight AS
SELECT
   *,
   REPLACE(CONCAT(SPLIT_PART(SPLIT_PART(fl_date, ' ', 1), '/', 3), '/',
                  SPLIT_PART(SPLIT_PART(fl_date, ' ', 1), '/', 1), '/',
                  SPLIT_PART(SPLIT_PART(fl_date, ' ', 1), '/', 2),
                  ' ', crs_dep_time), '/', '-')::timestamp AS flight_dep_scheduled,
   CONCAT(SPLIT_PART(SPLIT_PART(fl_date, ' ', 1), '/', 3), '/',
          SPLIT_PART(SPLIT_PART(fl_date, ' ', 1), '/', 1), '/',
          SPLIT_PART(SPLIT_PART(fl_date, ' ', 1), '/', 2),
          ' ', crs_dep_time)::date AS flight_scheduled_date,
   REPLACE(CONCAT(SPLIT_PART(SPLIT_PART(fl_date, ' ', 1), '/', 3), '/',
                  SPLIT_PART(SPLIT_PART(fl_date, ' ', 1), '/', 1), '/',
                  SPLIT_PART(SPLIT_PART(fl_date, ' ', 1), '/', 2),
                  ' ', crs_dep_time), '/', '-')::timestamp +
          (dep_delay_new || ' minutes')::interval AS flight_dep_actual,
   (REPLACE(CONCAT(SPLIT_PART(SPLIT_PART(fl_date, ' ', 1), '/', 3), '/',
                  SPLIT_PART(SPLIT_PART(fl_date, ' ', 1), '/', 1), '/',
                  SPLIT_PART(SPLIT_PART(fl_date, ' ', 1), '/', 2),
                  ' ', crs_dep_time), '/', '-')::timestamp +
          (dep_delay_new || ' minutes')::interval)::date AS flight_actual_date
FROM
   dwh_2024_s010.stg.flights f;

-- Создаем представление flights_for_dds
CREATE OR REPLACE TEMP VIEW flights_for_dds AS
SELECT
  f."year",
  f.quarter,
  f."month",
  t.flight_scheduled_date,
  t.flight_actual_date,
  t.flight_dep_scheduled AS flight_dep_scheduled_ts,
  t.flight_dep_actual AS flight_dep_actual_ts,
  f.op_unique_carrier,
  f.tail_num,
  f.op_carrier_fl_num,
  (SELECT id AS airport_dk FROM dds.airport a2 WHERE a2.iata_code = f.origin) AS airport_origin_dk,
  f.origin AS origin_code,
  (SELECT id AS airport_dk FROM dds.airport a2 WHERE a2.iata_code = f.dest) AS airport_dest_dk,
  f.dest AS dest_code,
  f.dep_delay_new,
  f.cancelled,
  f.cancellation_code,
  f.weather_delay,
  f.air_time,
  f.distance,
  f.loaded_ts
FROM
  dwh_2024_s010.stg.flights f
INNER JOIN
  time_flight t
  ON f.fl_date = t.fl_date
  AND f.op_carrier_fl_num = t.op_carrier_fl_num
  AND f.crs_dep_time = t.crs_dep_time
  AND f.origin = t.origin
  AND f.dest = t.dest
  AND f.tail_num = t.tail_num;
-- Запрос для проверки данных во временном представлении flights_for_dds
SELECT *
FROM flights_for_dds;