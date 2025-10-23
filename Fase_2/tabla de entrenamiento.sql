--Crear tabla de entrenamiento y prueba
-- Esta query filtra datos limpios y crea la división 80/20 para train/test

CREATE OR REPLACE TABLE `engaged-yen-472401-q2.datasetFase2.train_test_data` AS
SELECT
  -- Variable objetivo (a predecir)
  tip_amount,
  
  -- Features numéricas
  fare_amount,
  total_amount,
  trip_distance,
  passenger_count,
  
  -- Features temporales (ingeniería de características)
  EXTRACT(HOUR FROM pickup_datetime) AS pickup_hour,
  EXTRACT(DAYOFWEEK FROM pickup_datetime) AS pickup_dayofweek,
  data_file_month,
  
  -- Features categóricas
  pickupBorough,
  dropoffBorough,
  payment_type,
  
  -- División train/test: TRUE = entrenamiento (80%), FALSE = prueba (20%)
  RAND() < 0.8 AS split
  
FROM `engaged-yen-472401-q2.datasetFase1.taxi_trips_partition_cluster`
WHERE
  -- Filtros de calidad de datos (evitar datos inválidos)
  tip_amount >= 0                    -- Propinas no pueden ser negativas
  AND fare_amount > 0                -- Tarifa debe ser positiva
  AND total_amount > 0               -- Total debe ser positivo
  AND trip_distance > 0              -- Distancia debe ser positiva
  AND passenger_count BETWEEN 1 AND 6  -- Rango válido de pasajeros
  AND pickupBorough IS NOT NULL      -- Debe tener origen
  AND dropoffBorough IS NOT NULL     -- Debe tener destino
  AND payment_type IS NOT NULL       -- Debe tener método de pago
  AND tip_amount <= fare_amount * 2; -- Propina no mayor a 2x la tarifa (outliers)