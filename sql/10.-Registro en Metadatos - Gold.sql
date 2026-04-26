-- Registramos el motor de la capa Gold
INSERT INTO meta.pipeline_config (nombre_tabla, estado, sp_name)
VALUES ('ml_feature_set', 'ACTIVE', 'gold.sp_generar_ml_feature_set')
ON CONFLICT (nombre_tabla) 
DO UPDATE SET sp_name = EXCLUDED.sp_name;