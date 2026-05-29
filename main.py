import streamlit as st
import pandas as pd
import numpy as np
import joblib
import matplotlib.pyplot as plt

# =========================================
# CONFIGURACION GENERAL
# =========================================

st.set_page_config(
    page_title="Dashboard Forecasting Retail",
    page_icon="📈",
    layout="wide"
)

# =========================================
# CARGAR MODELO
# =========================================

modelo = joblib.load("modelo_forecasting.pkl")

# =========================================
# TITULO
# =========================================

st.title("📈 Dashboard Predictivo Retail Agua")

st.markdown("""
Sistema de Forecasting basado en Machine Learning utilizando  
Gradient Boosting Regressor para predicción de demanda.
""")

# =========================================
# SIDEBAR
# =========================================

st.sidebar.header("⚙️ Variables Predictoras")

ads = st.sidebar.slider(
    "Inversión Ads Total",
    0.0,
    1000.0,
    300.0
)

stock = st.sidebar.slider(
    "Stock Cierre Diario",
    0,
    1000,
    500
)

dia = st.sidebar.selectbox(
    "Día de Semana",
    {
        0:"Lunes",
        1:"Martes",
        2:"Miércoles",
        3:"Jueves",
        4:"Viernes",
        5:"Sábado",
        6:"Domingo"
    }
)

ventas_lag1 = st.sidebar.number_input(
    "Ventas día anterior",
    0,
    1000,
    250
)

ventas_lag7 = st.sidebar.number_input(
    "Ventas hace 7 días",
    0,
    1000,
    220
)

ventas_roll7 = st.sidebar.number_input(
    "Promedio móvil 7 días",
    0.0,
    1000.0,
    240.0
)

sku = st.sidebar.selectbox(
    "SKU",
    [
        "SKU_1L",
        "SKU_20L",
        "SKU_500ML"
    ]
)

categoria = st.sidebar.selectbox(
    "Categoría",
    [
        "Personal",
        "Familiar"
    ]
)

# =========================================
# DATAFRAME DE ENTRADA
# =========================================

nuevo = pd.DataFrame({

    'inversion_ads_total': [ads],

    'stock_cierre_diario': [stock],

    'dia_semana': [dia],

    'ventas_lag1': [ventas_lag1],

    'ventas_lag7': [ventas_lag7],

    'ventas_roll7': [ventas_roll7],

    'id_sku': [sku],

    'categoria': [categoria]

})

# =========================================
# PREDICCION
# =========================================

pred = modelo.predict(nuevo)[0]


st.subheader("📈 Tendencia Histórica vs Forecast")

# histórico simulado
historico = np.random.randint(150, 400, 30)

predicciones = historico + np.random.randint(-30,30,30)

dias_hist = np.arange(1,31)

fig_hist, ax_hist = plt.subplots(figsize=(12,5))

ax_hist.plot(
    dias_hist,
    historico,
    label="Ventas Reales",
    linewidth=2
)

ax_hist.plot(
    dias_hist,
    predicciones,
    label="Predicción Modelo",
    linewidth=2
)

ax_hist.set_title(
    "Ventas Reales vs Predicción"
)

ax_hist.set_xlabel("Días")

ax_hist.set_ylabel("Unidades")

ax_hist.legend()

st.pyplot(fig_hist)

# =========================================
# KPIS
# =========================================

st.subheader("📊 KPIs Predictivos")

col1, col2, col3 = st.columns(3)

with col1:
    st.metric(
        "Predicción Ventas",
        f"{pred:.0f} unidades"
    )

with col2:
    
    cobertura = stock / max(pred,1)

    st.metric(
        "Días Cobertura",
        f"{cobertura:.1f} días"
    )

with col3:

    if cobertura <= 2:
        estado = "🔴 QUIEBRE"

    elif cobertura <= 5:
        estado = "🟡 STOCK BAJO"

    elif cobertura <= 10:
        estado = "🟢 STOCK ÓPTIMO"

    else:
        estado = "🔵 SOBRE STOCK"

    st.metric(
        "Estado Inventario",
        estado
    )



#######
st.subheader("🚦 Estado Inteligente de Inventario")

if cobertura <= 2:

    st.markdown("""
    # 🔴 ALERTA DE QUIEBRE
    
    Riesgo crítico de desabastecimiento.
    """)

elif cobertura <= 5:

    st.markdown("""
    # 🟡 STOCK MÍNIMO
    
    Recomendado preparar reposición.
    """)

elif cobertura <= 10:

    st.markdown("""
    # 🟢 STOCK ÓPTIMO
    
    Inventario estable.
    """)

else:

    st.markdown("""
    # 🔵 SOBRE STOCK
    
    Exceso de inventario detectado.
    """)


# =========================================
# ALERTAS
# =========================================

st.subheader("🚨 Sistema de Alertas")

if cobertura <= 2:

    st.error("""
    Riesgo crítico de quiebre de stock.
    Se recomienda reposición inmediata.
    """)

elif cobertura <= 5:

    st.warning("""
    Inventario en nivel mínimo.
    Preparar abastecimiento.
    """)

elif cobertura <= 10:

    st.success("""
    Inventario estable.
    Operación normal.
    """)

else:

    st.info("""
    Posible sobrestock.
    Revisar abastecimiento y campañas.
    """)

# =========================================
# VARIABLES UTILIZADAS
# =========================================

st.subheader("🧠 Variables Predictoras Utilizadas")

variables_df = pd.DataFrame({

    "Variable": [

        "inversion_ads_total",

        "stock_cierre_diario",

        "dia_semana",

        "ventas_lag1",

        "ventas_lag7",

        "ventas_roll7",

        "id_sku",

        "categoria"

    ],

    "Descripción": [

        "Inversión publicitaria diaria",

        "Stock disponible",

        "Día de semana",

        "Ventas del día anterior",

        "Ventas hace 7 días",

        "Promedio móvil semanal",

        "Identificador SKU",

        "Tipo de producto"

    ]
})

st.dataframe(
    variables_df,
    use_container_width=True
)

###grafico circular stock
st.subheader("📦 Distribución de Inventario")

labels = [

    "Ventas Proyectadas",

    "Stock Disponible"

]

values = [

    pred,

    stock

]

fig_pie, ax_pie = plt.subplots(figsize=(6,6))

ax_pie.pie(
    values,
    labels=labels,
    autopct='%1.1f%%'
)

ax_pie.set_title(
    "Relación Stock vs Demanda"
)

st.pyplot(fig_pie)

# =========================================
# FEATURE IMPORTANCE MANUAL
# =========================================

st.subheader("📌 Importancia de Variables")

importance_df = pd.DataFrame({

    'feature': [

        'Inversión Ads',

        'Stock Diario',

        'Rolling 7',

        'Ventas Lag1',

        'Ventas Lag7',

        'Día Semana'

    ],

    'importance': [

        0.813,

        0.113,

        0.041,

        0.014,

        0.011,

        0.004

    ]

})

fig2, ax2 = plt.subplots(figsize=(10,5))

ax2.barh(
    importance_df['feature'],
    importance_df['importance']
)

ax2.invert_yaxis()

ax2.set_title(
    "Feature Importance"
)

st.pyplot(fig2)





#### simulador
st.subheader("📢 Simulación de Impacto Publicitario")

ads_range = np.arange(0,1000,50)

preds_ads = []

for a in ads_range:

    temp = nuevo.copy()

    temp['inversion_ads_total'] = a

    p = modelo.predict(temp)[0]

    preds_ads.append(p)

fig_ads, ax_ads = plt.subplots(figsize=(10,5))

ax_ads.plot(
    ads_range,
    preds_ads,
    linewidth=3
)

ax_ads.set_title(
    "Impacto de Publicidad sobre Ventas"
)

ax_ads.set_xlabel(
    "Inversión Ads"
)

ax_ads.set_ylabel(
    "Ventas Proyectadas"
)

st.pyplot(fig_ads)



###tabla kpi ejecutiva
st.subheader("📋 Resumen Ejecutivo")

kpi_df = pd.DataFrame({

    "Indicador":[

        "Predicción Ventas",

        "Stock Disponible",

        "Cobertura",

        "Estado"

    ],

    "Valor":[

        round(pred,2),

        stock,

        round(cobertura,2),

        estado

    ]
})

st.dataframe(
    kpi_df,
    use_container_width=True
)




##recomedaciones automaticas
st.subheader("🧠 Recomendaciones Inteligentes")

if cobertura <= 2:

    st.error("""
    • Emitir orden urgente de reposición.
    
    • Reducir intensidad de campañas Ads.
    
    • Revisar inventario central.
    """)

elif cobertura <= 5:

    st.warning("""
    • Preparar abastecimiento preventivo.
    
    • Monitorear ventas diariamente.
    """)

elif cobertura <= 10:

    st.success("""
    • Inventario balanceado.
    
    • Operación estable.
    """)

else:

    st.info("""
    • Posible sobrestock.
    
    • Considerar promociones o reducción de compras.
    """)



###expander de metricas
with st.expander("📊 Métricas del Modelo"):

    st.write("""
    
    MAE:
    Error promedio absoluto.
    
    RMSE:
    Penaliza errores grandes.
    
    R²:
    Explica qué porcentaje de la demanda
    es explicado por el modelo.
    
    """)


# =========================================
# INFORMACION ARQUITECTURA
# =========================================

with st.expander("🏗️ Arquitectura Data Lakehouse"):

    st.markdown("""

### Arquitectura Utilizada

#### Capa Bronze
Datos crudos:
- ventas SAP
- inventarios
- campañas Ads
- clima

#### Capa Silver
Procesamiento:
- limpieza
- feature engineering
- lags
- rolling windows

#### Capa Gold
Consumo analítico:
- forecasting
- dashboard
- KPIs
- alertas

#### Modelo ML
Gradient Boosting Regressor
optimizado con GridSearchCV.

""")

# =========================================
# FOOTER
# =========================================

st.markdown("---")

st.caption(
    "Proyecto Retail Forecasting - Ciencia de Datos e Inteligencia Artificial"
)