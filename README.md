# Proyecto Fase 1

    * Douglas Darío Rivera Ojeda
    * 201122881
    * Sharon Estefany Tagual Godoy
    * 201906173


## Descripción general del problema

El análisis de grandes volúmenes de datos se ha convertido en un desafío crítico para las organizaciones. Cuando los datos no están optimizados, las consultas pueden resultar lentas y costosas, dificultando la toma de decisiones en tiempo real. En este proyecto, los estudiantes deberán abordar este reto utilizando el dataset público NYC Taxi Trips 2022 en BigQuery, que contiene más de 100 millones de registros de viajes. La tarea consiste en aplicar consultas SQL y técnicas de optimización (particiones y clustering) para transformar los datos en información útil, identificar patrones significativos y generar visualizaciones que apoyen un análisis exploratorio claro y efectivo.

## Dataset utilizado:

    * bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022.


Se utilizó el dataset público bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022, el cual contiene los registros de viajes realizados en taxis amarillos en Nueva York durante el año 2022. Incluye información sobre fechas y horas de inicio y fin del viaje, ubicaciones de recogida y destino, distancia, tipo de pago, montos de tarifa y propinas, lo que permite realizar análisis de movilidad, demanda y comportamiento de los usuarios.

## Consutas realizadas:

### Creación de una tabla auxiliar

Esta tabla toma los primeros 10,000 registros del data set y ordenados por la columna pickup_datetime para poder ser utilizados para crear una tabla derivada con optimizaciones.

```sql
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
```

### Creación de la tabla con partición y clusterización

La tabla taxi_trips_partition_cluster fue creada a partir del dataset público bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022. Esta tabla incluye todas las columnas originales y se enriqueció mediante la unión (JOIN) con la tabla de zonas geográficas (taxi_zone_geom), lo que permite asociar cada viaje con el nombre de la zona, el borough correspondiente y la geometría espacial de las ubicaciones de origen y destino.


```sql
CREATE OR REPLACE TABLE engaged-yen-472401-q2.datasetFase1.taxi_trips_partition_cluster
PARTITION BY RANGE_BUCKET(data_file_month, GENERATE_ARRAY(1,12))
CLUSTER BY pickup_location_id, dropoff_location_id 
AS
SELECT * FROM engaged-yen-472401-q2.datasetFase1.taxi_trips_temp;
```

### Métricas descriptivas

```sql
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
```

### Distribución de variables categóricas

```sql
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
```

### Patrones temporales

```sql
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
```
