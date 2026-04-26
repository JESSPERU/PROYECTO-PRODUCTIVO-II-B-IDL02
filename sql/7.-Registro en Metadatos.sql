-- Agregamos una columna para los SPs si no la tienes
ALTER TABLE meta.pipeline_config ADD COLUMN IF NOT EXISTS sp_name TEXT;

-- Registramos los procesos
UPDATE meta.pipeline_config SET sp_name = 'silver.sp_transformar_maestros' WHERE nombre_tabla IN ('sap_clientes_maestro', 'sap_productos_maestro', 'sap_canales_maestro', 'ads_campanas_maestro');
UPDATE meta.pipeline_config SET sp_name = 'silver.sp_transformar_hechos' WHERE nombre_tabla IN ('sap_ventas_cabecera', 'sap_ventas_detalle', 'sap_inventario_diario', 'clima_diario_log', 'ads_insights_diario');