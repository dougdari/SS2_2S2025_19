CREATE OR REPLACE TABLE engaged-yen-472401-q2.datasetFase1.taxi_trips_temp AS
SELECT 
  t.*,
  p.zone_name AS pickupZone,
  p.borough AS pickupBorough,
  p.zone_geom AS pickupGeom,
  d.zone_name AS dropoffZone,
  d.borough AS dropoffBorough,
  d.zone_geom AS dropoffGeom
FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022` AS t
LEFT JOIN `bigquery-public-data.new_york_taxi_trips.taxi_zone_geom`  AS p
  ON CAST(t.pickup_location_id AS INT64) = CAST(p.zone_id AS INT64)
LEFT JOIN `bigquery-public-data.new_york_taxi_trips.taxi_zone_geom` AS d
  ON CAST(t.dropoff_location_id AS INT64) = CAST(d.zone_id AS INT64)
ORDER BY t.pickup_datetime
LIMIT 10000;

CREATE OR REPLACE TABLE engaged-yen-472401-q2.datasetFase1.taxi_trips_partition_cluster
PARTITION BY RANGE_BUCKET(data_file_month, GENERATE_ARRAY(1,12))
CLUSTER BY pickup_location_id, dropoff_location_id 
AS
SELECT * FROM engaged-yen-472401-q2.datasetFase1.taxi_trips_temp;