-- DISTRIBUCIÓN DE VARIABLES CATEGÓRICAS
-- SUBCONJUNTO CONSISTENTE DE 100 FILAS

-- 1️ Distribución de viajes por método de pago en el primer trimestre 2022

-- PUBLICO
SELECT payment_type, COUNT(*) AS total
FROM (
  SELECT *
  FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022`
  WHERE EXTRACT(MONTH FROM pickup_datetime) BETWEEN 1 AND 3
  ORDER BY pickup_datetime
  LIMIT 100
)
GROUP BY payment_type
ORDER BY total DESC;

-- TABLA
SELECT payment_type, COUNT(*) AS total
FROM (
  SELECT *
  FROM `engaged-yen-472401-q2.datasetFase1.taxi_trips_partition_cluster`
  WHERE EXTRACT(MONTH FROM pickup_datetime) BETWEEN 1 AND 3
  ORDER BY pickup_datetime
  LIMIT 100
)
GROUP BY payment_type
ORDER BY total DESC;

-- 2️ Distribución de viajes por cantidad de pasajeros (viajes con menos de 7 pasajeros)

-- PUBLICO
SELECT passenger_count, COUNT(*) AS total
FROM (
  SELECT *
  FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022`
  WHERE passenger_count < 7
  ORDER BY pickup_datetime
  LIMIT 100
)
GROUP BY passenger_count
ORDER BY total DESC;

-- TABLA
SELECT passenger_count, COUNT(*) AS total
FROM (
  SELECT *
  FROM `engaged-yen-472401-q2.datasetFase1.taxi_trips_partition_cluster`
  WHERE passenger_count < 7
  ORDER BY pickup_datetime
  LIMIT 100
)
GROUP BY passenger_count
ORDER BY total DESC;
