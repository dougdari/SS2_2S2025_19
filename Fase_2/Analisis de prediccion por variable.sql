
-- Analizar en qué escenarios el modelo predice mejor o peor


--Análisis de errores por hora del día
SELECT
  pickup_hour,
  COUNT(*) AS viajes,
  ROUND(AVG(tip_real), 2) AS propina_real_promedio,
  ROUND(AVG(tip_predicho), 2) AS propina_predicha_promedio,
  ROUND(AVG(error_absoluto), 2) AS error_promedio,
  ROUND(SQRT(AVG(error_cuadrado)), 2) AS RMSE_por_hora
FROM `engaged-yen-472401-q2.datasetFase2.predicciones_propina_test`
GROUP BY pickup_hour
ORDER BY pickup_hour;

-- Análisis de errores por borough (zona)

SELECT
  pickupBorough,
  COUNT(*) AS viajes,
  ROUND(AVG(tip_real), 2) AS propina_real_promedio,
  ROUND(AVG(tip_predicho), 2) AS propina_predicha_promedio,
  ROUND(AVG(error_absoluto), 2) AS error_promedio,
  ROUND(SQRT(AVG(error_cuadrado)), 2) AS RMSE_por_borough
FROM `engaged-yen-472401-q2.datasetFase2.predicciones_propina_test`
GROUP BY pickupBorough
ORDER BY RMSE_por_borough;