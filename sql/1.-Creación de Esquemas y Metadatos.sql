-- 1. Crear esquemas de la arquitectura medallón
CREATE SCHEMA IF NOT EXISTS bronce;
CREATE SCHEMA IF NOT EXISTS silver;
CREATE SCHEMA IF NOT EXISTS gold;
CREATE SCHEMA IF NOT EXISTS meta;

-- 2. Tabla de control de metadatos
CREATE TABLE IF NOT EXISTS meta.pipeline_config (
    id SERIAL PRIMARY KEY,
    nombre_tabla TEXT NOT NULL,
    metodo_carga TEXT DEFAULT 'DELTA', -- FULL o DELTA
    ultima_carga TIMESTAMP,
    estado TEXT DEFAULT 'ACTIVE'
);

-- 3. Registrar las 9 tablas en los metadatos
INSERT INTO meta.pipeline_config (nombre_tabla) VALUES 
('ads_campanas_maestro'), ('ads_insights_diario'), ('clima_diario_log'),
('sap_canales_maestro'), ('sap_clientes_maestro'), ('sap_inventario_diario'),
('sap_productos_maestro'), ('sap_ventas_cabecera'), ('sap_ventas_detalle')
ON CONFLICT DO NOTHING;

