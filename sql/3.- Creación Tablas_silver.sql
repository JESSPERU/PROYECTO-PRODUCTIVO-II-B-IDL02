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

-- 4. Maestro de Campañas Ads
CREATE TABLE IF NOT EXISTS silver.ads_campanas (
    id_campana TEXT PRIMARY KEY,
    nombre_campana TEXT,
    plataforma TEXT, -- Meta, Google, TikTok
    etl_fecha_carga TIMESTAMP DEFAULT NOW()
);

-- 5. Cabecera de Ventas
CREATE TABLE IF NOT EXISTS silver.sap_ventas_cabecera (
    id_venta TEXT PRIMARY KEY,
    fecha_venta DATE,
    id_cliente TEXT REFERENCES silver.sap_clientes(id_cliente),
    id_canal TEXT REFERENCES silver.sap_canales(id_canal),
    etl_fecha_carga TIMESTAMP DEFAULT NOW()
);

-- 6. Detalle de Ventas (Relacionado a Cabecera y Productos)
CREATE TABLE IF NOT EXISTS silver.sap_ventas_detalle (
    id_venta TEXT,
    id_sku TEXT REFERENCES silver.sap_productos(id_sku),
    cantidad INTEGER,
    precio_unitario DECIMAL(12,2),
    etl_fecha_carga TIMESTAMP DEFAULT NOW()
);

-- 7. Inventario Diario (Clave para predecir stock)
CREATE TABLE IF NOT EXISTS silver.sap_inventario_diario (
    fecha DATE,
    id_sku TEXT REFERENCES silver.sap_productos(id_sku),
    stock_cierre INTEGER,
    etl_fecha_carga TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (fecha, id_sku)
);

-- 8. Insights de Publicidad (Marketing)
CREATE TABLE IF NOT EXISTS silver.ads_insights_diario (
    fecha DATE,
    id_campana TEXT REFERENCES silver.ads_campanas(id_campana),
    inversion_usd DECIMAL(12,2),
    clics INTEGER,
    impresiones INTEGER,
    etl_fecha_carga TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (fecha, id_campana)
);

-- 9. Log de Clima (Incluimos todas las métricas del CSV)
CREATE TABLE IF NOT EXISTS silver.clima_diario_log (
    fecha DATE,
    ciudad TEXT,
    temp_max DECIMAL(5,2),
    temp_min DECIMAL(5,2),
    lluvia_mm DECIMAL(5,2),
    etl_fecha_carga TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (fecha, ciudad)
);