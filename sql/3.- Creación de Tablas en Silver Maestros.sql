-- 1. Maestro de Clientes
CREATE TABLE IF NOT EXISTS silver.sap_clientes (
    id_cliente TEXT PRIMARY KEY,
    nombre_cliente TEXT,
    tipo_cliente TEXT,
    ubicacion TEXT,
    etl_fecha_carga TIMESTAMP DEFAULT NOW()
);

-- 2. Maestro de Productos (Incluimos Formato y Lead Time)
CREATE TABLE IF NOT EXISTS silver.sap_productos (
    id_sku TEXT PRIMARY KEY,
    nombre_producto TEXT,
    categoria TEXT,
    formato TEXT, -- Ej: 500ml, 1L, 20L
    lead_time_dias INTEGER,
    etl_fecha_carga TIMESTAMP DEFAULT NOW()
);

-- 3. Maestro de Canales
CREATE TABLE IF NOT EXISTS silver.sap_canales (
    id_canal TEXT PRIMARY KEY,
    nombre_canal TEXT,
    comision_porcentaje DECIMAL(5,2),
    etl_fecha_carga TIMESTAMP DEFAULT NOW()
);

INSERT INTO silver.sap_canales (id_canal, nombre_canal, comision_porcentaje)
VALUES ('CH_99', 'Canal No Identificado / Otros', 0.00)
ON CONFLICT (id_canal) DO NOTHING;

-- 4. Maestro de Campañas Ads
CREATE TABLE IF NOT EXISTS silver.ads_campanas (
    id_campana TEXT PRIMARY KEY,
    nombre_campana TEXT,
    plataforma TEXT, -- Meta, Google, TikTok
    etl_fecha_carga TIMESTAMP DEFAULT NOW()
);
