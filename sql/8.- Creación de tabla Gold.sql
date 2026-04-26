-- 1. Crear esquema Gold si no existe
CREATE SCHEMA IF NOT EXISTS gold;

-- 2. Crear la tabla de características para ML
-- Usamos 'id_sku' y 'fecha' como granuralidad base
CREATE TABLE IF NOT EXISTS gold.ml_feature_set (
    fecha DATE,
    id_sku TEXT,
    nombre_producto TEXT,
    categoria TEXT,
    cantidad_vendida_total INTEGER,
    precio_unitario_promedio DECIMAL(12,2),
    temperatura_promedio DECIMAL(5,2),
    inversion_ads_total DECIMAL(12,2),
    stock_cierre_diario INTEGER,
    etl_fecha_carga TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (fecha, id_sku)
);