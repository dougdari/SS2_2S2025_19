-- Evaluar y comparar todos los modelos
-- Esta es la tabla MÁS IMPORTANTE para decidir cuál modelo es mejor

SELECT
  'model_linear_reg_tip' AS modelo,
  ROUND(mean_absolute_error, 4) AS MAE,
  ROUND(mean_squared_error, 4) AS MSE,
  ROUND(SQRT(mean_squared_error), 4) AS RMSE,
  ROUND(r2_score, 4) AS R2,
  ROUND(explained_variance, 4) AS explained_variance
FROM ML.EVALUATE(MODEL `engaged-yen-472401-q2.datasetFase2.model_linear_reg_tip`)
ORDER BY RMSE ASC;

SELECT
  'model_linear_reg_l2_tip',
  ROUND(mean_absolute_error, 4),
  ROUND(mean_squared_error, 4),
  ROUND(SQRT(mean_squared_error), 4) RMSE,
  ROUND(r2_score, 4),
  ROUND(explained_variance, 4)
FROM ML.EVALUATE(MODEL `engaged-yen-472401-q2.datasetFase2.model_linear_reg_l2_tip`)
ORDER BY RMSE ASC;

SELECT
  'model_boosted_tip',
  ROUND(mean_absolute_error, 4),
  ROUND(mean_squared_error, 4),
  ROUND(SQRT(mean_squared_error), 4) RMSE,
  ROUND(r2_score, 4),
  ROUND(explained_variance, 4)
FROM ML.EVALUATE(MODEL `engaged-yen-472401-q2.datasetFase2.model_boosted_tip`)
ORDER BY RMSE ASC;

SELECT
  'model_boosted_optimized_tip',
  ROUND(mean_absolute_error, 4),
  ROUND(mean_squared_error, 4),
  ROUND(SQRT(mean_squared_error), 4) RMSE,
  ROUND(r2_score, 4),
  ROUND(explained_variance, 4)
FROM ML.EVALUATE(MODEL `engaged-yen-472401-q2.datasetFase2.model_boosted_optimized_tip`)
ORDER BY RMSE ASC; 

 -- Ordenado por RMSE (menor = mejor)


-- ahora todos los modelos

SELECT
  'model_linear_reg_tip' AS modelo,
  ROUND(mean_absolute_error, 4) AS MAE,
  ROUND(mean_squared_error, 4) AS MSE,
  ROUND(SQRT(mean_squared_error), 4) AS RMSE,
  ROUND(r2_score, 4) AS R2,
  ROUND(explained_variance, 4) AS explained_variance
FROM ML.EVALUATE(MODEL `engaged-yen-472401-q2.datasetFase2.model_linear_reg_tip`)

UNION ALL

SELECT
  'model_linear_reg_l2_tip',
  ROUND(mean_absolute_error, 4),
  ROUND(mean_squared_error, 4),
  ROUND(SQRT(mean_squared_error), 4),
  ROUND(r2_score, 4),
  ROUND(explained_variance, 4)
FROM ML.EVALUATE(MODEL `engaged-yen-472401-q2.datasetFase2.model_linear_reg_l2_tip`)

UNION ALL

SELECT
  'model_boosted_tip',
  ROUND(mean_absolute_error, 4),
  ROUND(mean_squared_error, 4),
  ROUND(SQRT(mean_squared_error), 4),
  ROUND(r2_score, 4),
  ROUND(explained_variance, 4)
FROM ML.EVALUATE(MODEL `engaged-yen-472401-q2.datasetFase2.model_boosted_tip`)

UNION ALL

SELECT
  'model_boosted_optimized_tip',
  ROUND(mean_absolute_error, 4),
  ROUND(mean_squared_error, 4),
  ROUND(SQRT(mean_squared_error), 4),
  ROUND(r2_score, 4),
  ROUND(explained_variance, 4)
FROM ML.EVALUATE(MODEL `engaged-yen-472401-q2.datasetFase2.model_boosted_optimized_tip`)

ORDER BY RMSE ASC;

