CREATE OR REPLACE PROCEDURE gold.sp_generar_ml_feature_set()
LANGUAGE plpgsql
AS $$
BEGIN
    -- Limpiamos el dataset de entrenamiento
    TRUNCATE TABLE gold.ml_feature_set;

    INSERT INTO gold.ml_feature_set (
        fecha, id_sku, nombre_producto, categoria, 
        cantidad_vendida_total, precio_unitario_promedio, 
        temperatura_promedio, inversion_ads_total, stock_cierre_diario
    )
    SELECT 
        vc.fecha_venta,
        v.id_sku,
        p.nombre_producto,
        p.categoria,
        SUM(v.cantidad),
        AVG(v.precio_unitario),
        -- Clima: Promedio diario
        COALESCE(MAX(cli.temp_promedio), 20.0),
        -- Publicidad: Inversión total del día
        COALESCE(SUM(ads.inversion_usd), 0.0),
        -- Inventario: Stock de cierre
        MAX(inv.stock_cierre)
    FROM silver.sap_ventas_detalle v
    JOIN silver.sap_ventas_cabecera vc ON v.id_venta = vc.id_venta
    JOIN silver.sap_productos p ON v.id_sku = p.id_sku
    LEFT JOIN silver.clima_diario_log cli ON vc.fecha_venta = cli.fecha
    LEFT JOIN silver.ads_insights_diario ads ON vc.fecha_venta = ads.fecha
    LEFT JOIN silver.sap_inventario_diario inv ON vc.fecha_venta = inv.fecha AND v.id_sku = inv.id_sku
    WHERE vc.fecha_venta IS NOT NULL -- <--- FILTRO VITAL: Solo data con fecha válida
    GROUP BY vc.fecha_venta, v.id_sku, p.nombre_producto, p.categoria;
END;
$$;