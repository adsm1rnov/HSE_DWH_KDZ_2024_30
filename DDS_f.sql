INSERT INTO
       dwh_2024_s010.dds.flights (
              "year",
              quarter,
              "month",
              flight_scheduled_date,
              flight_actual_date,
              flight_dep_scheduled_ts,
              flight_dep_actual_ts,
              report_airline,
              tail_number,
              flight_number_reporting_airline,
              airport_origin_dk,
              origin_code,
              airport_dest_dk,
              dest_code,
              dep_delay_minutes,
              cancelled,
              cancellation_code,
              weather_delay,
              air_time,
              distance,
              loaded_ts
       )
SELECT
       "year",
       quarter,
       "month",
       flight_scheduled_date,
       flight_actual_date,
       flight_dep_scheduled_ts,
       flight_dep_actual_ts,
       op_unique_carrier,
       tail_num,
       op_carrier_fl_num AS flight_number_reporting_airline,
       airport_origin_dk,
       origin_code,
       airport_dest_dk,
       dest_code,
       dep_delay_new AS dep_delay_minutes,
       cancelled,
       cancellation_code,
       weather_delay,
       air_time,
       distance,
       loaded_ts
FROM
       flights_for_dds f
WHERE
       tail_num IS NOT NULL ON CONFLICT (
              flight_dep_scheduled_ts,
              flight_number_reporting_airline,
              origin_code,
              dest_code
       ) DO
UPDATE
SET
       flight_scheduled_date = EXCLUDED.flight_scheduled_date,
       flight_actual_date = EXCLUDED.flight_actual_date,
       flight_dep_actual_ts = EXCLUDED.flight_dep_actual_ts,
       report_airline = EXCLUDED.report_airline,
       tail_number = EXCLUDED.tail_number,
       dep_delay_minutes = EXCLUDED.dep_delay_minutes,
       cancelled = EXCLUDED.cancelled,
       cancellation_code = EXCLUDED.cancellation_code,
       weather_delay = EXCLUDED.weather_delay,
       air_time = EXCLUDED.air_time,
       distance = EXCLUDED.distance,
       loaded_ts = EXCLUDED.loaded_ts;