# Fábrica de Sillones: base de datos y Business Intelligence

![SQL Server](https://img.shields.io/badge/SQL%20Server-CC2927?style=flat-square&logo=microsoftsqlserver&logoColor=white)
![T-SQL](https://img.shields.io/badge/T--SQL-555?style=flat-square)
![Data Warehouse](https://img.shields.io/badge/Data%20Warehouse-555?style=flat-square)

Trabajo práctico de Gestión de Datos (UTN-FRBA, 2025), hecho en un equipo de 4. Partimos de los datos de una fábrica de sillones con varias sucursales, que venían todos mezclados en una única tabla maestra desnormalizada: clientes, pedidos, facturas, envíos, compras a proveedores y los materiales de cada sillón (tela, madera y relleno). Primero **diseñamos un modelo relacional normalizado de 24 tablas en SQL Server** y lo justificamos en un documento de estrategia. Después **migramos todos los datos con 26 procedimientos almacenados en T-SQL**, que eliminan duplicados y respetan la integridad entre tablas, y sumamos triggers y constraints para mantener los datos consistentes. Por último **construimos un Data Warehouse en esquema estrella**, con 8 dimensiones y 4 tablas de hechos, y **10 vistas que responden preguntas de negocio**: cuánto gana cada sucursal, qué modelos rinden mejor, qué porcentaje de pedidos se concreta, cuánto tarda la fabricación y qué localidades pagan más por los envíos.

📂 Scripts en [`entrega-final/data`](entrega-final/data) · Decisiones de diseño en [`Estrategia.pdf`](entrega-final/Estrategia.pdf)

**Equipo:** Agustín Fait, Mateo Spadoni, Nicolás Romero y Daniel Aizcorbe.

## Estructura

```
entrega-final/        ← versión final entregada
├── data/             ← scripts SQL (modelo + migración y BI)
├── DER.png           ← modelo relacional
├── DER_BI.png        ← modelo de BI
└── Estrategia.pdf    ← decisiones de diseño
versiones-viejas/     ← borradores y primera entrega
```
