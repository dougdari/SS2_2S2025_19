-- METRICAS DESCRIPTIVAS
-- DESDE EL DATASET PUBLICO


-- 1 Distancia promedio de viajes mayores a 1 km

-- PUBLICO
SELECT AVG(trip_distance) AS distancia_promedio
FROM (
  SELECT trip_distance
  FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022`
  WHERE trip_distance > 1
  ORDER BY pickup_datetime
  LIMIT 100
);

-- TABLA
SELECT AVG(trip_distance) AS distancia_promedio
FROM (
  SELECT trip_distance
  FROM `engaged-yen-472401-q2.datasetFase1.taxi_trips_partition_cluster`
  WHERE trip_distance > 1
  ORDER BY pickup_datetime
  LIMIT 100
);

-- 2 Duración promedio de los viajes en minutos (solo enero 2022)

-- PUBLICO
SELECT AVG(TIMESTAMP_DIFF(dropoff_datetime, pickup_datetime, MINUTE)) AS duracion_promedio_min
FROM (
  SELECT *
  FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022`
  WHERE EXTRACT(MONTH FROM pickup_datetime) = 1
  ORDER BY pickup_datetime
  LIMIT 100
);

-- TABLA
SELECT AVG(TIMESTAMP_DIFF(dropoff_datetime, pickup_datetime, MINUTE)) AS duracion_promedio_min
FROM (
  SELECT *
  FROM `engaged-yen-472401-q2.datasetFase1.taxi_trips_partition_cluster`
  WHERE EXTRACT(MONTH FROM pickup_datetime) = 1
  ORDER BY pickup_datetime
  LIMIT 100
);

-- 3 Promedio de tarifa y propina para viajes con más de un pasajero

-- PUBLICO
SELECT 
  AVG(fare_amount) AS tarifa_promedio,
  AVG(tip_amount) AS propina_promedio
FROM (
  SELECT *
  FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022`
  WHERE passenger_count > 1
  ORDER BY pickup_datetime
  LIMIT 100
);

-- TABLA
SELECT 
  AVG(fare_amount) AS tarifa_promedio,
  AVG(tip_amount) AS propina_promedio
FROM (
  SELECT *
  FROM `engaged-yen-472401-q2.datasetFase1.taxi_trips_partition_cluster`
  WHERE passenger_count > 1
  ORDER BY pickup_datetime
  LIMIT 100
);
