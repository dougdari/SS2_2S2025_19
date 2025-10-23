-- Generar predicciones con el mejor modelo
-- Esta tabla se usará para el dashboard de Looker Studio
-- mejor modelo 'model_boosted_optimized_tip'

CREATE OR REPLACE TABLE `engaged-yen-472401-q2.datasetFase2.predicciones_propina_test` AS
SELECT
  -- Valores reales del dataset de prueba
  actual.tip_amount AS tip_real,
  actual.fare_amount,
  actual.total_amount,
  actual.trip_distance,
  actual.passenger_count,
  actual.pickup_hour,
  actual.pickup_dayofweek,
  actual.pickupBorough,
  actual.dropoffBorough,
  actual.payment_type,
  
  -- Predicción del modelo
  predicted_tip_amount AS tip_predicho,
  
  -- Métricas de error individuales
  ABS(actual.tip_amount - predicted_tip_amount) AS error_absoluto,
  POWER(actual.tip_amount - predicted_tip_amount, 2) AS error_cuadrado,
  
  -- Clasificación del error (para análisis)
  CASE 
    WHEN ABS(actual.tip_amount - predicted_tip_amount) <= 1 THEN 'Excelente (<$1)'
    WHEN ABS(actual.tip_amount - predicted_tip_amount) <= 2 THEN 'Bueno ($1-$2)'
    WHEN ABS(actual.tip_amount - predicted_tip_amount) <= 5 THEN 'Aceptable ($2-$5)'
    ELSE 'Malo (>$5)'
  END AS categoria_error
  
FROM ML.PREDICT(
  MODEL `engaged-yen-472401-q2.datasetFase2.model_boosted_optimized_tip`, 
  (
    SELECT *
    FROM `engaged-yen-472401-q2.datasetFase2.train_test_data`
    WHERE split = FALSE  -- SOLO datos de TEST (20%)
  )
) AS pred
JOIN `engaged-yen-472401-q2.datasetFase2.train_test_data` AS actual
  USING(tip_amount, fare_amount, total_amount, trip_distance, passenger_count, 
        pickup_hour, pickup_dayofweek, pickupBorough, dropoffBorough, payment_type)
WHERE actual.split = FALSE;