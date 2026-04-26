-- Tablas Maestro
CREATE TABLE bronce.ads_campanas_maestro (id TEXT, plataforma TEXT, nombre_campana TEXT, etl_fecha_carga TIMESTAMP);
CREATE TABLE bronce.sap_canales_maestro (id TEXT, nombre_canal TEXT, comision TEXT, etl_fecha_carga TIMESTAMP);
CREATE TABLE bronce.sap_clientes_maestro (id TEXT, nombre_cliente TEXT, tipo_cliente TEXT, ubicacion TEXT, etl_fecha_carga TIMESTAMP);
CREATE TABLE bronce.sap_productos_maestro (id TEXT, nombre_producto TEXT, categoria TEXT, formato TEXT, lead_time_dias TEXT, etl_fecha_carga TIMESTAMP);

-- Tablas Transaccionales
CREATE TABLE bronce.ads_insights_diario (fecha TEXT, id_campana TEXT, impresiones TEXT, clics TEXT, inversion_usd TEXT, etl_fecha_carga TIMESTAMP);
CREATE TABLE bronce.clima_diario_log (fecha TEXT, ciudad TEXT, temp_max TEXT, temp_min TEXT, lluvia_mm TEXT, etl_fecha_carga TIMESTAMP);
CREATE TABLE bronce.sap_inventario_diario (fecha TEXT, id_producto TEXT, stock_cierre TEXT, etl_fecha_carga TIMESTAMP);
CREATE TABLE bronce.sap_ventas_cabecera (id_venta TEXT, fecha TEXT, id_cliente TEXT, id_canal TEXT, etl_fecha_carga TIMESTAMP);
CREATE TABLE bronce.sap_ventas_detalle (id_venta TEXT, id_producto TEXT, cantidad TEXT, precio_unitario TEXT, etl_fecha_carga TIMESTAMP);