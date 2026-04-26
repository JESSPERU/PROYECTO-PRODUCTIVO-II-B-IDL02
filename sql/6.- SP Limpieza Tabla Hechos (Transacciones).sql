CREATE OR REPLACE PROCEDURE silver.sp_transformar_hechos()
LANGUAGE plpgsql
AS $$
BEGIN
-- 1. Ventas Cabecera con validación de existencia de Canal
    INSERT INTO silver.sap_ventas_cabecera (id_venta, fecha_venta, id_cliente, id_canal)
    SELECT 
        id_transaccion, 
        -- (Aquí va tu lógica de CASE para fechas que ya funciona...)
        CASE 
            WHEN fecha_venta ~ '^\d{4}-\d{2}-\d{2}$' THEN TO_DATE(fecha_venta, 'YYYY-MM-DD')
            WHEN fecha_venta ~ '^\d{2}/\d{2}/\d{4}$' THEN TO_DATE(fecha_venta, 'DD/MM/YYYY')
            WHEN fecha_venta ~ '^\d{2}-\d{2}-\d{2}$' THEN TO_DATE(fecha_venta, 'MM-DD-YY')
            ELSE NULL 
        END,
        id_cliente, 
        -- Validamos: Si el canal no existe en el maestro, lo mandamos a 'CH_99'
        CASE 
            WHEN EXISTS (SELECT 1 FROM silver.sap_canales c WHERE c.id_canal = b.id_canal) 
            THEN b.id_canal 
            ELSE 'CH_99' 
        END
    FROM bronce.sap_ventas_cabecera b
    ON CONFLICT (id_venta) DO NOTHING;

    -- 2. Ventas Detalle
    TRUNCATE TABLE silver.sap_ventas_detalle;
    INSERT INTO silver.sap_ventas_detalle (id_venta, id_sku, cantidad, precio_unitario)
    SELECT id_transaccion, id_sku, CAST(cantidad_vendida AS INTEGER), COALESCE(CAST(precio_unitario_aplicado AS DECIMAL), 0)
    FROM bronce.sap_ventas_detalle;

    -- 3. Inventario Diario
    INSERT INTO silver.sap_inventario_diario (fecha, id_sku, stock_cierre)
    SELECT 
        CASE 
            WHEN fecha_foto ~ '^\d{4}-\d{2}-\d{2}$' THEN TO_DATE(fecha_foto, 'YYYY-MM-DD')
            WHEN fecha_foto ~ '^\d{2}-\d{2}-\d{2}$' THEN TO_DATE(fecha_foto, 'MM-DD-YY')
            ELSE NULL 
        END,
        id_sku, 
        CAST(stock_disponible_cierre AS INTEGER)
    FROM bronce.sap_inventario_diario
    ON CONFLICT (fecha, id_sku) DO UPDATE SET stock_cierre = EXCLUDED.stock_cierre;

    -- 4. Ads Insights
    INSERT INTO silver.ads_insights_diario (fecha, id_campana, inversion_usd, clics, impresiones)
    SELECT 
        CASE 
            WHEN fecha_metrica ~ '^\d{4}-\d{2}-\d{2}$' THEN TO_DATE(fecha_metrica, 'YYYY-MM-DD')
            ELSE CAST(fecha_metrica AS DATE)
        END,
        id_campana, 
        CAST(inversion_usd AS DECIMAL), 
        CAST(clics AS INTEGER), 
        CAST(impresiones AS INTEGER)
    FROM bronce.ads_insights_diario
    ON CONFLICT (fecha, id_campana) DO NOTHING;

END;
$$;