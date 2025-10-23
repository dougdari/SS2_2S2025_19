CREATE OR REPLACE TABLE `engaged-yen-472401-q2.datasetFase2.dashboard_predicciones` AS
SELECT
  tip_real,
  tip_predicho,
  error_absoluto,
  categoria_error,
  pickup_hour,
  pickup_dayofweek,
  pickupBorough,
  dropoffBorough,
  fare_amount,
  trip_distance,
  passenger_count,
  
  -- Campos calculados para visualización
  CASE pickup_dayofweek
    WHEN 1 THEN 'Domingo'
    WHEN 2 THEN 'Lunes'
    WHEN 3 THEN 'Martes'
    WHEN 4 THEN 'Miércoles'
    WHEN 5 THEN 'Jueves'
    WHEN 6 THEN 'Viernes'
    WHEN 7 THEN 'Sábado'
  END AS dia_nombre,
  
  CASE 
    WHEN pickup_hour BETWEEN 6 AND 11 THEN 'Mañana'
    WHEN pickup_hour BETWEEN 12 AND 17 THEN 'Tarde'
    WHEN pickup_hour BETWEEN 18 AND 23 THEN 'Noche'
    ELSE 'Madrugada'
  END AS periodo_dia

FROM `engaged-yen-472401-q2.datasetFase2.predicciones_propina_test`;