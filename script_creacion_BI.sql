USE [GD1C2025]
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'MAND')
BEGIN 
	EXEC ('CREATE SCHEMA MAND')
END
GO

--======================================================= TABLAS DIMENSIONES INGRESOS EGRESOS========================================================================

go
CREATE TABLE MAND.DIMENSION_MODELO(
    modelo_codigo bigint PRIMARY KEY,
    modelo_nombre VARCHAR(255),
    modelo_descripcion VARCHAR(255),
    modelo_precio DECIMAL(18,2)
)

go
CREATE table MAND.DIMENSION_TIPO_MATERIAL (
    tipo_material bigint primary key,
    tipo_material_detalle nvarchar(255)
)

go
CREATE table MAND.DIMENSION_RANGO_ETARIO (
    rango_etario_codigo bigint IDENTITY(1,1) primary key,
    rango_etario_detalle nvarchar(255)
)



--======================================================= TABLAS DIMENSIONES COMPARTIDAS========================================================================

GO
CREATE table MAND.DIMENSION_SUCURSAL (
    sucursal_id bigint primary key
)

go
CREATE table MAND.DIMENSION_UBICACION(
    ubicacion_codigo  bigint IDENTITY(1,1) primary key,
    ubicacion_provincia nvarchar(255),
    ubicacion_locaclidad NVARCHAR(255)
)

GO
CREATE table MAND.DIMENSION_TIEMPO(
	tiempo_codigo bigint IDENTITY(1,1) PRIMARY KEY,
	tiempo_año int,
	tiempo_cuatrimestre int,
	tiempo_mes int
)

--======================================================= TABLAS DIMENSIONES PEDIDOS ENVIOS========================================================================

GO
CREATE table MAND.DIMENSION_TURNO_PEDIDO (
    turno_codigo bigint IDENTITY(1,1) primary key,
    turno_detalle nvarchar(255)
)
go
alter table MAND.DIMENSION_TURNO_PEDIDO
add CONSTRAINT chk_turno_detalle CHECK (turno_detalle IN ('08:00 a 14:00','14:00 a 20:00'))

go
CREATE table MAND.DIMENSION_ESTADO_PEDIDO(
    estado_pedido_codigo bigint IDENTITY(1,1) primary KEY,
    estado_pedido_detalle nvarchar(255)
)
go

--======================================================= TABLAS HECHOS ========================================================================

CREATE TABLE MAND.HECHOS_INGRESOS_EGRESOS (
    dimension_tiempo bigint,
    dimension_sucursal bigint,
    dimension_rango_etario bigint,
    dimension_modelo bigint,
    dimension_tipo_material bigint,
    dimension_ubicacion bigint,
    ingreso decimal(38,2),
    egreso decimal(38,2),
    cant_facturas bigint,
    cantidad_sillones bigint,
    promedio_fabricacion datetime,
    PRIMARY KEY (
        dimension_tiempo,
        dimension_sucursal,
        dimension_rango_etario,
        dimension_modelo,
        dimension_tipo_material,
        dimension_ubicacion
    )
)

CREATE TABLE MAND.HECHOS_PEDIDOS_ENVIOS (
    dimension_tiempo bigint,
    dimension_sucursal bigint,
    dimension_ubicacion bigint,
    dimension_turno_pedido bigint,
    dimension_estado_pedido bigint,
    cant_pedidos decimal(12,2),
    promedio_fabricacion decimal(12,2),
    envios_cumplidos int,
    envios_totales int,
    promedio_envio decimal(12,2),
    PRIMARY KEY (
        dimension_tiempo,
        dimension_sucursal,
        dimension_ubicacion,
        dimension_turno_pedido,
        dimension_estado_pedido
    )
)

--======================================================= FK INGRESO_EGRESO ========================================================================

ALTER TABLE MAND.HECHOS_INGRESOS_EGRESOS
ADD CONSTRAINT FK_ingresoModelo
FOREIGN KEY (dimension_modelo) REFERENCES MAND.DIMENSION_MODELO(modelo_codigo)

ALTER TABLE MAND.HECHOS_INGRESOS_EGRESOS
ADD CONSTRAINT FK_ingresoTipoMaterial
FOREIGN KEY (dimension_rango_etario) REFERENCES MAND.DIMENSION_TIPO_MATERIAL(tipo_material)

ALTER TABLE MAND.HECHOS_INGRESOS_EGRESOS
ADD CONSTRAINT FK_ingresoRango
FOREIGN KEY (dimension_rango_etario) REFERENCES MAND.DIMENSION_RANGO_ETARIO(rango_etario_codigo)

ALTER TABLE MAND.HECHOS_INGRESOS_EGRESOS
ADD CONSTRAINT FK_ingresoEgresoTiempo
FOREIGN KEY (dimension_tiempo) REFERENCES MAND.DIMENSION_TIEMPO(tiempo_codigo)

ALTER TABLE MAND.HECHOS_INGRESOS_EGRESOS
ADD CONSTRAINT FK_ingresoEgresoUbicacion
FOREIGN KEY (dimension_ubicacion) REFERENCES MAND.DIMENSION_UBICACION(ubicacion_codigo)

ALTER TABLE MAND.HECHOS_INGRESOS_EGRESOS
ADD CONSTRAINT FK_ingresoEgresoSucursal
FOREIGN KEY (dimension_sucursal) REFERENCES MAND.DIMENSION_SUCURSAL(sucursal_id)

--======================================================= FK PEDIDOS_ENVIOS  ========================================================================

ALTER TABLE MAND.HECHOS_PEDIDOS_ENVIOS
ADD CONSTRAINT FK_pedidoEnviosTiempo
FOREIGN KEY (dimension_tiempo) REFERENCES MAND.DIMENSION_TIEMPO(tiempo_codigo)

ALTER TABLE MAND.HECHOS_PEDIDOS_ENVIOS
ADD CONSTRAINT FK_pedidoEnviosUbicacion
FOREIGN KEY (dimension_ubicacion) REFERENCES MAND.DIMENSION_UBICACION(ubicacion_codigo)

ALTER TABLE MAND.HECHOS_PEDIDOS_ENVIOS
ADD CONSTRAINT FK_pedidoEnviosTurno
FOREIGN KEY (dimension_sucursal) REFERENCES MAND.DIMENSION_TURNO_PEDIDO(turno_codigo)

ALTER TABLE MAND.HECHOS_PEDIDOS_ENVIOS
ADD CONSTRAINT FK_pedidoEnviosSucursal
FOREIGN KEY (dimension_sucursal) REFERENCES MAND.DIMENSION_SUCURSAL(sucursal_id)

ALTER TABLE MAND.HECHOS_PEDIDOS_ENVIOS
ADD CONSTRAINT FK_pedidoEnviosPedidoEstado
FOREIGN KEY (dimension_estado_pedido) REFERENCES MAND.DIMENSION_ESTADO_PEDIDO(estado_pedido_codigo)

--======================================================= CHE ===================================================================


alter table MAND.DIMENSION_RANGO_ETARIO
add CONSTRAINT chk_rango_etario_detalle CHECK (rango_etario_detalle IN ('< 25','25 - 35','35 - 50', '> 50'))

alter table MAND.DIMENSION_TURNO_PEDIDO
add CONSTRAINT chk_turno_detalle CHECK (turno_detalle IN ('08:00 a 14:00','14:00 a 20:00'))
--======================================================= PROCEDURES MIGRACION DIMENSIONES ===================================================================


--======================================================= SP TIEMPO ========================================================================

GO
CREATE FUNCTION MAND.getCuatrimestre(@fecha DATETIME2)
RETURNS INT
AS
BEGIN
    RETURN ((MONTH(@fecha) - 1) / 4) + 1;
END

go


GO
CREATE PROCEDURE MAND.MIGRACION_DIM_TIEMPO
AS
BEGIN

    INSERT INTO MAND.DIMENSION_TIEMPO
    select DISTINCT YEAR(factura_fecha_hora), MAND.getCuatrimestre(factura_fecha_hora), MONTH(factura_fecha_hora) from MAND.factura
    UNION
    select DISTINCT YEAR(compra_fecha),MAND.getCuatrimestre(compra_fecha), MONTH(compra_fecha) from MAND.COMPRA
    UNION 
    select DISTINCT year(pedido_fecha_hora),MAND.getCuatrimestre(pedido_fecha_hora), MONTH(pedido_fecha_hora) from MAND.pedido
    UNION 
    select DISTINCT year(canc_ped_fecha),MAND.getCuatrimestre(canc_ped_fecha), month(canc_ped_fecha) from MAND.CANCELACION_PEDIDO
    UNION
    select DISTINCT YEAR(envio_fecha_entrega),MAND.getCuatrimestre(envio_fecha_entrega), MONTH(envio_fecha_entrega) from MAND.envio
    
END

--======================================================= SP UBICACION ========================================================================
GO

CREATE PROCEDURE MAND.MIGRACION_DIM_UBICACION
AS 
BEGIN
    INSERT INTO MAND.DIMENSION_UBICACION
    
    SELECT p.prov_nombre, l.loc_nombre
    FROM MAND.PROVINCIA p
    JOIN MAND.LOCALIDAD l on l.loc_provincia =p.prov_codigo
END

GO

--======================================================= SP TURNO PEDIDO ========================================================================
GO

CREATE PROCEDURE MAND.MIGRACION_DIM_TURNO_PEDIDO
AS 
BEGIN
    INSERT INTO MAND.DIMENSION_TURNO_PEDIDO
    VALUES ('08:00 a 14:00'),
		   ('14:00 a 20:00')
END

GO

--======================================================= SP ESTADO PEDIDO ========================================================================

GO
CREATE PROCEDURE MAND.MIGRACION_DIM_ESTADO_PEDIDO
AS
BEGIN
    
    INSERT INTO MAND.DIMENSION_ESTADO_PEDIDO
    SELECT * FROM MAND.ESTADO
    
    
END

--======================================================= SP SUCURSAL ========================================================================

GO
CREATE PROCEDURE MAND.MIGRACION_DIM_SUCURSAL
AS
BEGIN
    
    INSERT INTO MAND.DIMENSION_SUCURSAL
    SELECT DISTINCT sucursal_codigo FROM MAND.SUCURSAL
    
    
END

--======================================================= SP RANGO ETARIO ========================================================================
GO

CREATE PROCEDURE MAND.MIGRACION_DIM_RANGO_ETARIO
AS 
BEGIN
    INSERT INTO MAND.DIMENSION_RANGO_ETARIO
    VALUES ('< 25'),
		   ('25 - 35'),
		   ('35 - 50'),
		   ('> 50')
END

GO
--======================================================= SP MODELO ========================================================================
GO

CREATE PROCEDURE MAND.MIGRACION_DIM_MODELO
AS 
BEGIN
    INSERT INTO MAND.DIMENSION_MODELO
    select * from MAND.MODELO
END

GO

--======================================================= SP TIPO MATERIAL ========================================================================

GO
CREATE PROCEDURE MAND.MIGRACION_DIM_TIPO_MATERIAL
AS
BEGIN
    
    INSERT INTO MAND.DIMENSION_TIPO_MATERIAL
    SELECT * FROM MAND.TIPO_MATERIAL
    
END
go

--======================================================= PROCEDURES MIGRACION DIMENSIONES ===================================================================

GO
create procedure MAND.MIGRACION_DIMENSIONES
as
BEGIN
	EXEC MAND.MIGRACION_DIM_TIEMPO
	EXEC MAND.MIGRACION_DIM_UBICACION
	EXEC MAND.MIGRACION_DIM_TURNO_PEDIDO
	EXEC MAND.MIGRACION_DIM_ESTADO_PEDIDO
	EXEC MAND.MIGRACION_DIM_SUCURSAL
	EXEC MAND.MIGRACION_DIM_RANGO_ETARIO
	EXEC MAND.MIGRACION_DIM_MODELO
	EXEC MAND.MIGRACION_DIM_TIPO_MATERIAL
END
GO

--======================================================= SP INGRESOS EGRESOS ========================================================================

GO
CREATE PROCEDURE MAND.MIGRACION_HECHOS_ING_EGR
AS
BEGIN
    -- ARREGLAR subselects

    -- SELECT SUM(factural_total), SUM(compra_total), COUNT(factura_codigo),
	--		(select sum(compra_total) from MAND.COMPRA where year(compra_fecha) = year(factura_fecha_hora) and month(compra_fecha) = month(factura_fecha_hora))
    -- FROM MAND.FACTURA F
    -- JOIN MAND.DETALLE_FACTURA DF ON DF.factura_numero=f.factura_nro
    -- JOIN MAND.DETALLE_PEDIDO
    -- JOIN MAND.PEDIDO
END

--======================================================= SP PEDIDOS ENVIOS =======================================================================
GO
create procedure MAND.MIGRAR_PEDIDOS_ENVIOS
AS
BEGIN





END
GO
