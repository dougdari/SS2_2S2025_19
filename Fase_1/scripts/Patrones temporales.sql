-- PATRONES TEMPORALES
-- SUBCONJUNTO CONSISTENTE DE 100 FILAS

-- 1️ Viajes por mes (solo viajes con propina mayor a 0)

-- PUBLICO
SELECT 
  EXTRACT(MONTH FROM pickup_datetime) AS mes,
  COUNT(*) AS total_viajes
FROM (
  SELECT *
  FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022`
  WHERE tip_amount > 0
  ORDER BY pickup_datetime
  LIMIT 100
)
GROUP BY mes
ORDER BY mes;

-- TABLA
SELECT 
  EXTRACT(MONTH FROM pickup_datetime) AS mes,
  COUNT(*) AS total_viajes
FROM (
  SELECT *
  FROM `engaged-yen-472401-q2.datasetFase1.taxi_trips_partition_cluster`
  WHERE tip_amount > 0
  ORDER BY pickup_datetime
  LIMIT 100
)
GROUP BY mes
ORDER BY mes;

-- 2️ Viajes por día de la semana (enero 2022, pasajeros > 1)

-- PUBLICO
SELECT 
  EXTRACT(DAYOFWEEK FROM pickup_datetime) AS dia_semana,
  COUNT(*) AS total_viajes
FROM (
  SELECT *
  FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022`
  WHERE EXTRACT(MONTH FROM pickup_datetime) = 1
    AND passenger_count > 1
  ORDER BY pickup_datetime
  LIMIT 100
)
GROUP BY dia_semana
ORDER BY dia_semana;

-- TABLA
SELECT 
  EXTRACT(DAYOFWEEK FROM pickup_datetime) AS dia_semana,
  COUNT(*) AS total_viajes
FROM (
  SELECT *
  FROM `engaged-yen-472401-q2.datasetFase1.taxi_trips_partition_cluster`
  WHERE EXTRACT(MONTH FROM pickup_datetime) = 1
    AND passenger_count > 1
  ORDER BY pickup_datetime
  LIMIT 100
)
GROUP BY dia_semana
ORDER BY dia_semana;

-- 3️ Viajes por hora del día (solo sábados)

-- PUBLICO
SELECT 
  EXTRACT(HOUR FROM pickup_datetime) AS hora,
  COUNT(*) AS total_viajes
FROM (
  SELECT *
  FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022`
  WHERE EXTRACT(DAYOFWEEK FROM pickup_datetime) = 7
  ORDER BY pickup_datetime
  LIMIT 100
)
GROUP BY hora
ORDER BY hora;

-- TABLA
SELECT 
  EXTRACT(HOUR FROM pickup_datetime) AS hora,
  COUNT(*) AS total_viajes
FROM (
  SELECT *
  FROM `engaged-yen-472401-q2.datasetFase1.taxi_trips_partition_cluster`
  WHERE EXTRACT(DAYOFWEEK FROM pickup_datetime) = 7
  ORDER BY pickup_datetime
  LIMIT 100
)
GROUP BY hora
ORDER BY hora;
