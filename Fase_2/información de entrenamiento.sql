
--  OBTENER INFORMACIÓN DE ENTRENAMIENTO (ML.TRAINING_INFO)
-- Ver información de entrenamiento de todos los modelos
-- Esto muestra cómo el modelo mejoró en cada iteración

SELECT
  'model_linear_reg_tip' AS modelo,
  iteration,
  loss AS training_loss,
  eval_loss AS validation_loss,
  learning_rate,
  duration_ms / 1000 AS duration_seconds
FROM ML.TRAINING_INFO(MODEL `engaged-yen-472401-q2.datasetFase2.model_linear_reg_tip`)
ORDER BY modelo, iteration;

SELECT
  'model_linear_reg_l2_tip' AS modelo, 
  iteration,
  loss,
  eval_loss,
  learning_rate,
  duration_ms / 1000
FROM ML.TRAINING_INFO(MODEL `engaged-yen-472401-q2.datasetFase2.model_linear_reg_l2_tip`)
ORDER BY modelo, iteration;

SELECT
  'model_boosted_tip' AS modelo,
  iteration,
  loss,
  eval_loss,
  learning_rate,
  duration_ms / 1000
FROM ML.TRAINING_INFO(MODEL `engaged-yen-472401-q2.datasetFase2.model_boosted_tip`)
ORDER BY modelo, iteration;

SELECT
  'model_boosted_optimized_tip' AS modelo,
  iteration,
  loss,
  eval_loss,
  learning_rate,
  duration_ms / 1000
FROM ML.TRAINING_INFO(MODEL `engaged-yen-472401-q2.datasetFase2.model_boosted_optimized_tip`)
ORDER BY modelo, iteration;

