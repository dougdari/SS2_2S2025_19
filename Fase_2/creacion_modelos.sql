-- MODELO 1: Crear modelo de Regresión Lineal básica
-- Este es el modelo más simple, servirá como baseline

CREATE OR REPLACE MODEL `engaged-yen-472401-q2.datasetFase2.model_linear_reg_tip`
OPTIONS(
  model_type = 'linear_reg',              -- Tipo: Regresión Lineal
  input_label_cols = ['tip_amount'],      -- Variable a predecir
  data_split_col = 'split',               -- Columna para dividir train/test
  data_split_method = 'CUSTOM'            -- Usar nuestra división personalizada
) AS
SELECT * 
FROM `engaged-yen-472401-q2.datasetFase2.train_test_data`;


-- MODELO 2: Crear modelo de Regresión Lineal con regularización L2
-- L2_REG = 0.1 ayuda a prevenir overfitting

CREATE OR REPLACE MODEL `engaged-yen-472401-q2.datasetFase2.model_linear_reg_l2_tip`
OPTIONS(
  model_type = 'linear_reg',
  input_label_cols = ['tip_amount'],
  data_split_col = 'split',
  data_split_method = 'CUSTOM',
  l2_reg = 0.1                            -- Regularización L2 (Ridge)
) AS
SELECT * 
FROM `engaged-yen-472401-q2.datasetFase2.train_test_data`;

-- MODELO 3: Crear modelo Boosted Tree básico
-- Este modelo puede capturar patrones no lineales

CREATE OR REPLACE MODEL `engaged-yen-472401-q2.datasetFase2.model_boosted_tip`
OPTIONS(
  model_type = 'boosted_tree_regressor',  -- Árbol potenciado para regresión
  input_label_cols = ['tip_amount'],
  data_split_col = 'split',
  data_split_method = 'CUSTOM',
  max_iterations = 20                     -- Número de árboles a construir
) AS
SELECT * 
FROM `engaged-yen-472401-q2.datasetFase2.train_test_data`;


-- MODELO 4: Crear modelo Boosted Tree optimizado
-- Este modelo tiene hiperparámetros ajustados para mejor desempeño

CREATE OR REPLACE MODEL `engaged-yen-472401-q2.datasetFase2.model_boosted_optimized_tip`
OPTIONS(
  model_type = 'boosted_tree_regressor',
  input_label_cols = ['tip_amount'],
  data_split_col = 'split',
  data_split_method = 'CUSTOM',
  max_iterations = 50,                    -- Más iteraciones
  learn_rate = 0.1,                       -- Tasa de aprendizaje
  max_tree_depth = 8,                     -- Profundidad de árboles
  subsample = 0.8,                        -- Submuestreo
  min_tree_child_weight = 5               -- Peso mínimo por hoja
) AS
SELECT * 
FROM `engaged-yen-472401-q2.datasetFase2.train_test_data`;