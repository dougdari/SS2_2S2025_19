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

![tabla](assets/imagen1.png)

### Creación de la tabla con partición y clusterización

La tabla taxi_trips_partition_cluster fue creada a partir del dataset público bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022. Esta tabla incluye todas las columnas originales y se enriqueció mediante la unión (JOIN) con la tabla de zonas geográficas (taxi_zone_geom), lo que permite asociar cada viaje con el nombre de la zona, el borough correspondiente y la geometría espacial de las ubicaciones de origen y destino.


```sql
CREATE OR REPLACE TABLE engaged-yen-472401-q2.datasetFase1.taxi_trips_partition_cluster
PARTITION BY RANGE_BUCKET(data_file_month, GENERATE_ARRAY(1,12))
CLUSTER BY pickup_location_id, dropoff_location_id 
AS
SELECT * FROM engaged-yen-472401-q2.datasetFase1.taxi_trips_temp;
```

Ejecución de la query para la creación:

![tabla](assets/imagen2.png)

Tabla creada:

![cubo](assets/imagen3.png)


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

## Comparación de ejecución para las querys

### Distancia promedio de viajes mayores a 1 km (DATASET PUBLICO)

Rendimiento:

![query](assets/imagen4.png)

Resultado:

![query](assets/imagen5.png)

### Distancia promedio de viajes mayores a 1 km (TABLA PARTICIONADA Y CLUSTERIZADA)

Rendimiento:

![query](assets/imagen6.png)

Resultado:

![query](assets/imagen7.png)

### Duración promedio de los viajes en minutos (solo enero 2022) (DATASET PUBLICO)

Rendimiento:

![query](assets/imagen8.png)

Resultado:

![query](assets/imagen9.png)

### Duración promedio de los viajes en minutos (solo enero 2022) (TABLA PARTICIONADA Y CLUSTERIZADA)


Rendimiento:

![query](assets/imagen10.png)

Resultado:

![query](assets/imagen11.png)


### Promedio de tarifa y propina para viajes con más de un pasajero (DATASET PUBLICO)

Rendimiento:

![query](assets/imagen12.png)

Resultado:

![query](assets/imagen13.png)

### Promedio de tarifa y propina para viajes con más de un pasajero (TABLA PARTICIONADA Y CLUSTERIZADA)

Rendimiento:

![query](assets/imagen14.png)

Resultado:

![query](assets/imagen15.png)

## Distribución de variables categoricas

### Distribución de viajes por método de pago en el primer trimestre 2022 (DATASET PUBLICO)

Rendimiento:

![query](assets/imagen16.png)

Resultado:

![query](assets/imagen17.png)

### Distribución de viajes por método de pago en el primer trimestre 2022 (TABLA PARTICIONADA Y CLUSTERIZADA)

Rendimiento:

![query](assets/imagen18.png)

Resultado:

![query](assets/imagen19.png)


### Distribución de viajes por cantidad de pasajeros (viajes con menos de 7 pasajeros) (DATASET PUBLICO)

Rendimiento:

![query](assets/imagen20.png)

Resultado:

![query](assets/imagen21.png)

### Distribución de viajes por cantidad de pasajeros (viajes con menos de 7 pasajeros) (TABLA PARTICIONADA Y CLUSTERIZADA)

Rendimiento:

![query](assets/imagen22.png)

Resultado:

![query](assets/imagen23.png)


## Patrones temporales

### Viajes por mes (solo viajes con propina mayor a 0) (DATASET PUBLICO)

Rendimiento:

![query](assets/imagen24.png)

Resultado:

![query](assets/imagen25.png)

### Viajes por mes (solo viajes con propina mayor a 0) (TABLA PARTICIONADA Y CLUSTERIZADA)

Rendimiento:

![query](assets/imagen26.png)

Resultado:

![query](assets/imagen27.png)

### Viajes por día de la semana (enero 2022, pasajeros > 1) (DATASET PUBLICO)

Rendimiento:

![query](assets/imagen28.png)

Resultado:

![query](assets/imagen29.png)

### Viajes por día de la semana (enero 2022, pasajeros > 1) (TABLA PARTICIONADA Y CLUSTERIZADA)

Rendimiento:

![query](assets/imagen30.png)

Resultado:

![query](assets/imagen31.png)


### Viajes por hora del día (solo sábados) (DATASET PUBLICO)

Rendimiento:

![query](assets/imagen32.png)

Resultado:

![query](assets/imagen33.png)


### Viajes por hora del día (solo sábados) (TABLA PARTICIONADA Y CLUSTERIZADA)

Rendimiento:

![query](assets/imagen34.png)

Resultado:

![query](assets/imagen35.png)




## Visualizaciones en Looker Studio
Como parte de la Fase 1 del proyecto, se generaron tres visualizaciones en Looker Studio conectadas directamente a la tabla optimizada taxi_trips_partition_cluster en BigQuery. Estas gráficas permiten evidenciar los hallazgos principales del análisis exploratorio, cumpliendo con el requisito de mostrar entre 2 y 3 reportes basados en los datos.

1. Viajes por mes en 2022
- Tipo de gráfico: Serie temporal (línea).
- Dimensión: Mes de pickup_datetime.
- Métrica: Conteo de registros (número de viajes).
- Hallazgo: Se observa variación en la demanda de taxis a lo largo del año, con meses de mayor volumen y otros con caídas. Esto refleja - - patrones estacionales que pueden relacionarse con factores externos (clima, turismo, festividades).



2. Distribución de métodos de pago
- Tipo de gráfico: Circular (dona).
- Dimensión: payment_type.
- Métrica: Conteo de registros (número de viajes).
- Hallazgo: El 71% de los viajes se pagó con tarjeta, mientras que el 23% se realizó en efectivo y el resto con otros métodos. Esto muestra una clara preferencia por medios electrónicos en el servicio de taxi durante 2022.

3. Tarifa promedio por mes en 2022

- Tipo de gráfico: Barras verticales.
- Dimensión: Mes de pickup_datetime.
- Métrica: Promedio de total_amount.
- Hallazgo: La tarifa promedio mensual se mantiene en un rango entre $15 y $25 USD. Se identifican picos en agosto y diciembre, lo cual puede asociarse a temporadas de alta demanda, como vacaciones de verano y fin de año.