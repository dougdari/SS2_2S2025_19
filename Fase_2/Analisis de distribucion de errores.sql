
-- qué tan distribuidos están los errores del modelo

-- Distribución de errores de predicción
SELECT
  categoria_error,
  COUNT(*) AS cantidad,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS porcentaje,
  ROUND(AVG(error_absoluto), 2) AS error_promedio
FROM `engaged-yen-472401-q2.datasetFase2.predicciones_propina_test`
GROUP BY categoria_error
ORDER BY 
  CASE categoria_error
    WHEN 'Excelente (<$1)' THEN 1
    WHEN 'Bueno ($1-$2)' THEN 2
    WHEN 'Aceptable ($2-$5)' THEN 3
    ELSE 4
  END;