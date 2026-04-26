CREATE OR REPLACE PROCEDURE silver.sp_transformar_maestros()
LANGUAGE plpgsql
AS $$
BEGIN
    -- 1. Clientes (CSV tiene: id_cliente, nombre_empresa...)
    INSERT INTO silver.sap_clientes (id_cliente, nombre_cliente, tipo_cliente, ubicacion)
    SELECT id_cliente, nombre_empresa, tipo_cliente, ubicacion
    FROM bronce.sap_clientes_maestro
    ON CONFLICT (id_cliente) DO UPDATE SET
        nombre_cliente = EXCLUDED.nombre_cliente,
        ubicacion = EXCLUDED.ubicacion;

    -- 2. Productos (CSV tiene: id_sku, descripcion, categoria, lead_time_dias)
    INSERT INTO silver.sap_productos (id_sku, nombre_producto, categoria, lead_time_dias)
    SELECT id_sku, descripcion, categoria, CAST(lead_time_dias AS INTEGER)
    FROM bronce.sap_productos_maestro
    ON CONFLICT (id_sku) DO UPDATE SET
        nombre_producto = EXCLUDED.nombre_producto,
        lead_time_dias = EXCLUDED.lead_time_dias;

    -- 3. Canales (CSV tiene: id_canal, nombre_canal, comision_porcentaje)
    INSERT INTO silver.sap_canales (id_canal, nombre_canal, comision_porcentaje)
    SELECT id_canal, nombre_canal, CAST(comision_porcentaje AS DECIMAL)
    FROM bronce.sap_canales_maestro
    ON CONFLICT (id_canal) DO NOTHING;

    -- 4. Campañas (CSV tiene: id_campana, nombre_campana, plataforma_origen...)
    INSERT INTO silver.ads_campanas (id_campana, nombre_campana, plataforma)
    SELECT id_campana, nombre_campana, plataforma_origen
    FROM bronce.ads_campanas_maestro
    ON CONFLICT (id_campana) DO NOTHING;

END;
$$;