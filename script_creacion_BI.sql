USE [GD1C2025]
GO

IF NOT EXISTS (SELECT *
FROM sys.schemas
WHERE name = 'MAND')
BEGIN
    EXEC ('CREATE SCHEMA MAND')
END
GO

--======================================================= TABLAS DIMENSIONES INGRESOS EGRESOS========================================================================

go
CREATE TABLE MAND.DIMENSION_MODELO
(
    modelo_codigo bigint PRIMARY KEY,
    modelo_nombre VARCHAR(255),
    modelo_descripcion VARCHAR(255),
    modelo_precio DECIMAL(18,2)
)

go
CREATE table MAND.DIMENSION_TIPO_MATERIAL
(
    tipo_material bigint primary key,
    tipo_material_detalle nvarchar(255)
)

go
CREATE table MAND.DIMENSION_RANGO_ETARIO
(
    rango_etario_codigo bigint IDENTITY(1,1) primary key,
    rango_etario_detalle nvarchar(255)
)



--======================================================= TABLAS DIMENSIONES COMPARTIDAS========================================================================

GO
CREATE table MAND.DIMENSION_SUCURSAL
(
    sucursal_id bigint primary key
)

go
CREATE table MAND.DIMENSION_UBICACION
(
    ubicacion_codigo bigint IDENTITY(1,1) primary key,
    ubicacion_provincia nvarchar(255),
    ubicacion_locaclidad NVARCHAR(255)
)

GO
CREATE table MAND.DIMENSION_TIEMPO
(
    tiempo_codigo bigint IDENTITY(1,1) PRIMARY KEY,
    tiempo_año int,
    tiempo_cuatrimestre int,
    tiempo_mes int
)

--======================================================= TABLAS DIMENSIONES PEDIDOS ENVIOS========================================================================

GO
CREATE table MAND.DIMENSION_TURNO_PEDIDO
(
    turno_codigo bigint IDENTITY(1,1) primary key,
    turno_detalle nvarchar(255)
)
go
alter table MAND.DIMENSION_TURNO_PEDIDO
add CONSTRAINT chk_turno_detalle CHECK (turno_detalle IN ('08:00 a 14:00','14:00 a 20:00'))

go
CREATE table MAND.DIMENSION_ESTADO_PEDIDO
(
    estado_pedido_codigo bigint IDENTITY(1,1) primary KEY,
    estado_pedido_detalle nvarchar(255)
)
go

--======================================================= TABLAS HECHOS ========================================================================

CREATE TABLE MAND.HECHOS_INGRESOS_EGRESOS
(
    dimension_tiempo bigint NOT NULL,
    dimension_sucursal bigint NOT NULL,
    dimension_rango_etario bigint NOT NULL,
    dimension_modelo bigint NOT NULL,
    dimension_ubicacion bigint NOT NULL,
    ingreso decimal(38,2) NOT NULL,
    egreso decimal(38,2) NOT NULL,
    cant_facturas bigint NOT NULL,
    cantidad_sillones bigint NOT NULL,
    promedio_fabricacion datetime NOT NULL,
    PRIMARY KEY (
        dimension_tiempo,
        dimension_sucursal,
        dimension_rango_etario,
        dimension_modelo,
        dimension_ubicacion
    )
)

CREATE TABLE MAND.HECHOS_PEDIDOS
(
    dimension_tiempo bigint,
    dimension_sucursal bigint,
    dimension_ubicacion bigint,
    dimension_turno_pedido bigint,
    dimension_estado_pedido bigint,
    cant_pedidos decimal(12,2),
    PRIMARY KEY (
        dimension_tiempo,
        dimension_sucursal,
        dimension_ubicacion,
        dimension_turno_pedido,
        dimension_estado_pedido
    )
)

CREATE TABLE MAND.HECHOS_COMPRAS_MATERIAL(
    dimension_tiempo bigint NOT NULL,
    dimension_sucursal bigint NOT NULL,
    dimension_tipo_material bigint NOT NULL,
    importe_total decimal(38,2) NOT NULL,
    cant_compras bigint NOT NULL
    PRIMARY KEY(
        dimension_tiempo,
        dimension_sucursal,
        dimension_tipo_material
    )
)

create table MAND.Hechos_ENVIOS(
    dimension_tiempo bigint,
    dimension_ubicacion bigint,
    envios_cumplidos int,	
    envios_totales	int,		
    promedio_envio	decimal(12,2)
    PRIMARY KEY(
        dimension_tiempo,
        dimension_ubicacion
    )
)

--======================================================= FK COMPRAS MATERIAL ========================================================================
ALTER TABLE MAND.HECHOS_COMPRAS_MATERIAL
ADD CONSTRAINT FK_ComprasMaterialTiempo
FOREIGN KEY (dimension_tiempo) REFERENCES MAND.DIMENSION_TIEMPO(tiempo_codigo)

ALTER TABLE MAND.HECHOS_COMPRAS_MATERIAL
ADD CONSTRAINT FK_ComprasMateriallUbicacion
FOREIGN KEY (dimension_ubicacion) REFERENCES MAND.DIMENSION_UBICACION(ubicacion_codigo)

ALTER TABLE MAND.HECHOS_COMPRAS_MATERIAL
ADD CONSTRAINT FK_ComprasMaterialTipoMaterial
FOREIGN KEY (dimension_tipo_material) REFERENCES MAND.DIMENSION_TIPO_MATERIAL(tipo_material)

--======================================================= FK ENVIOS  ==================================================================-

ALTER TABLE MAND.Hechos_ENVIOS
ADD CONSTRAINT FK_enviosTiempo
FOREIGN KEY (dimension_tiempo) REFERENCES MAND.DIMENSION_TIEMPO(tiempo_codigo)

ALTER TABLE MAND.Hechos_ENVIOS
ADD CONSTRAINT FK_enviosUbicacion
FOREIGN KEY (dimension_ubicacion) REFERENCES MAND.DIMENSION_UBICACION(ubicacion_codigo)

--======================================================= FK INGRESO_EGRESO ========================================================================

ALTER TABLE MAND.HECHOS_INGRESOS_EGRESOS
ADD CONSTRAINT FK_ingresoModelo
FOREIGN KEY (dimension_modelo) REFERENCES MAND.DIMENSION_MODELO(modelo_codigo)

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

--======================================================= FK PEDIDOS  ========================================================================

ALTER TABLE MAND.HECHOS_PEDIDOS
ADD CONSTRAINT FK_pedidoEnviosTiempo
FOREIGN KEY (dimension_tiempo) REFERENCES MAND.DIMENSION_TIEMPO(tiempo_codigo)

ALTER TABLE MAND.HECHOS_PEDIDOS
ADD CONSTRAINT FK_pedidoEnviosUbicacion
FOREIGN KEY (dimension_ubicacion) REFERENCES MAND.DIMENSION_UBICACION(ubicacion_codigo)

ALTER TABLE MAND.HECHOS_PEDIDOS
ADD CONSTRAINT FK_pedidoEnviosTurno
FOREIGN KEY (dimension_sucursal) REFERENCES MAND.DIMENSION_TURNO_PEDIDO(turno_codigo)

ALTER TABLE MAND.HECHOS_PEDIDOS
ADD CONSTRAINT FK_pedidoEnviosSucursal
FOREIGN KEY (dimension_sucursal) REFERENCES MAND.DIMENSION_SUCURSAL(sucursal_id)

ALTER TABLE MAND.HECHOS_PEDIDOS
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
                        select DISTINCT YEAR(factura_fecha_hora), MAND.getCuatrimestre(factura_fecha_hora), MONTH(factura_fecha_hora)
        from MAND.factura
    UNION
        select DISTINCT YEAR(compra_fecha), MAND.getCuatrimestre(compra_fecha), MONTH(compra_fecha)
        from MAND.COMPRA
    UNION
        select DISTINCT year(pedido_fecha_hora), MAND.getCuatrimestre(pedido_fecha_hora), MONTH(pedido_fecha_hora)
        from MAND.pedido
    UNION
        select DISTINCT year(canc_ped_fecha), MAND.getCuatrimestre(canc_ped_fecha), month(canc_ped_fecha)
        from MAND.CANCELACION_PEDIDO
    UNION
        select DISTINCT YEAR(envio_fecha_entrega), MAND.getCuatrimestre(envio_fecha_entrega), MONTH(envio_fecha_entrega)
        from MAND.envio

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
    VALUES
        ('08:00 a 14:00'),
        ('14:00 a 20:00')
END

GO

--======================================================= SP ESTADO PEDIDO ========================================================================

GO
CREATE PROCEDURE MAND.MIGRACION_DIM_ESTADO_PEDIDO
AS
BEGIN

    INSERT INTO MAND.DIMENSION_ESTADO_PEDIDO
    SELECT *
    FROM MAND.ESTADO


END

--======================================================= SP SUCURSAL ========================================================================

GO
CREATE PROCEDURE MAND.MIGRACION_DIM_SUCURSAL
AS
BEGIN

    INSERT INTO MAND.DIMENSION_SUCURSAL
    SELECT DISTINCT sucursal_codigo
    FROM MAND.SUCURSAL


END

--======================================================= SP RANGO ETARIO ========================================================================
GO

CREATE PROCEDURE MAND.MIGRACION_DIM_RANGO_ETARIO
AS
BEGIN
    INSERT INTO MAND.DIMENSION_RANGO_ETARIO
    VALUES
        ('< 25'),
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
    select *
    from MAND.MODELO
END

GO

--======================================================= SP TIPO MATERIAL ========================================================================

GO
CREATE PROCEDURE MAND.MIGRACION_DIM_TIPO_MATERIAL
AS
BEGIN

    INSERT INTO MAND.DIMENSION_TIPO_MATERIAL
    SELECT *
    FROM MAND.TIPO_MATERIAL

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

create function MAND.rango_etario_id(@fecha datetime)
returns bigint
AS
BEGIN
    DECLARE @edad BIGINT = DATEDIFF(year,@fecha,getdate());
    return (CASE 
        when @edad < 25 THEN 1
        when @edad between 25 and 35 THEN 2
        when @edad between 35 and 45 THEN 3
        ELSE 4
    END)
end 

GO

CREATE PROCEDURE MAND.MIGRACION_HECHOS_ING_EGR
AS
BEGIN
    INSERT INTO MAND.HECHOS_INGRESOS_EGRESOS

    SELECT
        dt.tiempo_codigo AS [TIEMPO ID], -- TIEMPO
        f.factura_sucursal AS [SUCURSAL], -- SUCURSAL
        s.sillon_modelo AS [MODELO], -- MODELO
        MAND.rango_etario_id(c.cliente_fechaNacimieto) AS [RANGO ETARIO], -- RANGO ETARIO
        du.ubicacion_codigo AS [UBICACION], -- UBICACION
        ISNULL(SUM(df.detalle_factura_subtotal),0) AS [INGRESOS], -- DATA INGRESOS
        COUNT(DISTINCT f.factura_nro) AS [CANT FACTURAS], -- DATA CANT FACTURAS
        (select isnull(sum(compra_total),0)
        from MAND.COMPRA
        where YEAR(compra_fecha) = dt.tiempo_año and MONTH(compra_fecha) = dt.tiempo_mes and compra_sucursal = f.factura_sucursal ) AS [EGRESOS], -- EGRESOS
        avg(datediff(day,ped.pedido_fecha_hora,f.factura_fecha_hora)) AS [PROMEDIO FABRICACION], -- PROMEDIO FABRICACION
        ISNULL(SUM(dp.pedido_det_cantidad),0) AS [CANT SILLONES]-- CANT SILLONES (?)
    FROM MAND.FACTURA f
        JOIN MAND.DIMENSION_TIEMPO dt
        ON YEAR(f.factura_fecha_hora) = dt.tiempo_año
            AND MONTH(f.factura_fecha_hora) = dt.tiempo_mes
            AND MAND.getCuatrimestre(factura_fecha_hora) = dt.tiempo_cuatrimestre
        JOIN MAND.DETALLE_FACTURA df
        ON df.detalle_factura_factura = f.factura_nro
        JOIN MAND.DETALLE_PEDIDO dp
        ON df.detalle_factura_detalle_pedido = dp.detalle_pedido_id
        JOIN MAND.SILLON s
        ON dp.sillon_id = s.sillon_codigo
        JOIN MAND.CLIENTE c
        ON f.factura_cliente = c.cliente_dni
        JOIN MAND.SUCURSAL suc
        ON suc.sucursal_codigo = f.factura_sucursal
        JOIN MAND.DIRECCION d
        ON suc.sucursal_direccion = d.dir_codigo
        JOIN MAND.LOCALIDAD l
        ON d.dir_localidad = l.loc_codigo
        JOIN MAND.PROVINCIA p
        ON l.loc_provincia = p.prov_codigo
        JOIN MAND.DIMENSION_UBICACION du
        ON p.prov_nombre = du.ubicacion_provincia
            AND l.loc_nombre = du.ubicacion_locaclidad
        JOIN MAND.PEDIDO ped
        ON dp.pedido_id = ped.pedido_nro
    GROUP BY 
    dt.tiempo_año,
    dt.tiempo_mes,
    dt.tiempo_cuatrimestre, 
    dt.tiempo_codigo,
    f.factura_sucursal,
    s.sillon_modelo,
    du.ubicacion_codigo,
    MAND.rango_etario_id(c.cliente_fechaNacimieto)
    ORDER BY 1
END

--======================================================= SP PEDIDOS ENVIOS =======================================================================
GO

create function MAND.turno(@horario datetime2)
returns bigint

as
BEGIN
    if( DATEPART(hh,@horario) > 14)
    begin
        return 2
    end 
    return 1
end 

--DROP FUNCTION MAND.turno
GO
create procedure MAND.MIGRAR_PEDIDOS
AS
BEGIN
    -- TIEMPO, SUCURSAL, UBICACION, estado_pedido, turno_pedido
    -- cant_pedidos
    insert into MAND.HECHOS_PEDIDOS
    select 
    dt.tiempo_codigo as [DIMENSION_TIEMPO],
    ped.pedido_sucursal as [DIMENSION_SUCURSAL],
    du.ubicacion_codigo as [DIMENSION_UBICACION],
    MAND.turno(ped.pedido_fecha_hora) as [DIMENSION_TURNO],
    ped.pedido_estado as [DIMENSION_ESTADO_PEDIDO],
    count(DISTINCT ped.pedido_nro) as [CANT_PEDIDOS]
    from MAND.PEDIDO as ped
        join MAND.DETALLE_PEDIDO as det_ped
        on det_ped.pedido_id = ped.pedido_nro      
        join MAND.ESTADO as est
        on ped.pedido_estado = est.estado_codigo
        JOIN MAND.SUCURSAL as suc
        ON suc.sucursal_codigo = ped.pedido_sucursal
        JOIN MAND.DIRECCION as d
        ON suc.sucursal_direccion = d.dir_codigo
        JOIN MAND.LOCALIDAD as l
        ON d.dir_localidad = l.loc_codigo
        JOIN MAND.PROVINCIA as p
        ON l.loc_provincia = p.prov_codigo
        JOIN MAND.DIMENSION_UBICACION as du
        ON p.prov_nombre = du.ubicacion_provincia
            AND l.loc_nombre = du.ubicacion_locaclidad
        JOIN MAND.DIMENSION_TIEMPO dt
        ON YEAR(ped.pedido_fecha_hora) = dt.tiempo_año
            AND MONTH(ped.pedido_fecha_hora) = dt.tiempo_mes
            AND MAND.getCuatrimestre(ped.pedido_fecha_hora) = dt.tiempo_cuatrimestre
    GROUP by dt.tiempo_codigo, 
    ped.pedido_sucursal, 
    du.ubicacion_codigo, 
    MAND.turno(ped.pedido_fecha_hora), 
    ped.pedido_estado
    
END
Go

--======================================================= SP COMPRAS TIPO MATERIAL =======================================================================


GO
CREATE PROCEDURE MAND.MIGRACION_HECHOS_COMPRA_MATERIAL
AS
BEGIN
    INSERT INTO MAND.HECHOS_COMPRAS_MATERIAL
    
    SELECT 
        c.compra_sucursal, 
        dt.tiempo_codigo,
        tm.tipo_material_codigo,
        SUM(cd.compra_det_subtotal) AS [COMPRA TOTAL],
        COUNT(DISTINCT c.compra_numero) AS [CANT COMPRAS]
    FROM MAND.COMPRA c  
        JOIN MAND.COMPRA_DETALLE cd
            ON c.compra_numero = cd.compra_det_compra
        JOIN MAND.DIMENSION_TIEMPO dt
            ON YEAR(c.compra_fecha) = dt.tiempo_año
            AND MONTH(c.compra_fecha) = dt.tiempo_mes
            AND MAND.getCuatrimestre(c.compra_fecha) = dt.tiempo_cuatrimestre
    JOIN MAND.MATERIAL m
        ON cd.compra_det_material = m.material_id
    JOIN MAND.TIPO_MATERIAL tm
        ON m.material_tipo = tm.tipo_material_codigo
    GROUP BY 
        c.compra_sucursal,
        dt.tiempo_codigo,
        dt.tiempo_año,
        dt.tiempo_mes,
        tm.tipo_material_codigo
END



--======================================================= SP ENVIOS=======================================================================

GO
create procedure MAND.MIGRACION_HECHOS_ENVIOS
AS 
 BEGIN

INSERT INTO MAND.HECHOS_ENVIOS
SELECT 
    dt.tiempo_codigo,
    u.ubicacion_codigo,
    COUNT(CASE WHEN e.envio_fecha_programada = e.envio_fecha_entrega THEN 1 end) AS [CANT_ENVIOS_COMPLETOS],
    COUNT(DISTINCT e.envio_numero) AS [CANT ENVIOS],
    AVG(e.envio_importe_subida+e.envio_importe_traslado) AS [PROMEDIO COSTO ENVIO]
   FROM MAND.ENVIO e 
    join MAND.factura f
     on f.factura_nro=e.envio_factura
    join MAND.cliente c
     on c.cliente_dni=f.factura_cliente
    join MAND.DIRECCION d 
     on d.dir_codigo=c.cliente_direccion
    join MAND.localidad l 
     on l.loc_codigo=d.dir_localidad
    join MAND.PROVINCIA p
     ON l.loc_provincia=p.prov_codigo
    join MAND.DIMENSION_UBICACION u
     on l.loc_nombre=u.ubicacion_locaclidad and p.prov_nombre=u.ubicacion_provincia
    JOIN MAND.DIMENSION_TIEMPO dt
        ON YEAR(e.envio_fecha_entrega) = dt.tiempo_año
            AND MONTH(e.envio_fecha_entrega) = dt.tiempo_mes
            AND MAND.getCuatrimestre(e.envio_fecha_entrega) = dt.tiempo_cuatrimestre
    group by 
            dt.tiempo_codigo,
            dt.tiempo_mes,
            dt.tiempo_año,
            l.loc_nombre,
            u.ubicacion_codigo
    ORDER BY 1
 END
GO


--======================================================= VIEWS =======================================================================

--======================================================= VIEW1 GANANCIAS =======================================================================

GO
CREATE VIEW MAND.GANANCIAS
AS
SELECT 
    ds.sucursal_id AS [SUCURSAL],
    dt.tiempo_mes AS [MES],
    dt.tiempo_año AS [AÑO],
    SUM(hie.ingreso) AS [INGRESO],
    MAX(hie.egreso) AS [EGRESO]
FROM MAND.HECHOS_INGRESOS_EGRESOS hie
    JOIN MAND.DIMENSION_TIEMPO dt
        ON hie.dimension_tiempo = dt.tiempo_codigo
    JOIN MAND.DIMENSION_SUCURSAL ds
        ON hie.dimension_sucursal = ds.sucursal_id
GROUP BY 
    dt.tiempo_mes,
    dt.tiempo_año,
    ds.sucursal_id
ORDER BY
    ds.sucursal_id,
    dt.tiempo_mes,
    dt.tiempo_año

--======================================================= VIEW2 FACTURA PROMEDIO MENSUAL =======================================================================

GO
CREATE VIEW MAND.FACTURA_PROMEDIO_MENSUAL
AS
SELECT 
    du.ubicacion_provincia AS [PROVINCIA],
    dt.tiempo_cuatrimestre AS [CUATRIMESTRE],
    dt.tiempo_año AS [AÑO],
    SUM(hie.ingreso) / SUM(hie.cant_facturas) AS [PROMEDIO MENSUAL]
FROM MAND.HECHOS_INGRESOS_EGRESOS hie
    JOIN MAND.DIMENSION_UBICACION du
        ON hie.dimension_ubicacion = du.ubicacion_codigo
    JOIN MAND.DIMENSION_TIEMPO dt
        ON dt.tiempo_codigo = hie.dimension_tiempo
GROUP BY 
    dt.tiempo_mes,
    dt.tiempo_cuatrimestre,
    dt.tiempo_año,
    du.ubicacion_provincia
ORDER BY 
    dt.tiempo_mes,
    dt.tiempo_cuatrimestre,
    dt.tiempo_año,
    du.ubicacion_provincia

--======================================================= VIEW3 RENDIMIENTO DE MODELOS =======================================================================

GO


create view MAND.RENDIMIENTO_DE_MODELOS
as
select top 3 m.modelo_nombre
from MAND.HECHOS_INGRESOS_EGRESOS as h
join MAND.DIMENSION_TIEMPO as t on t.tiempo_codigo = h.dimension_tiempo
join MAND.DIMENSION_MODELO as m on m.modelo_codigo = h.dimension_modelo
group by t.tiempo_año, t.tiempo_cuatrimestre, h.dimension_ubicacion,h.dimension_rango_etario
order by h.cantidad_sillones desc


--======================================================= VIEW4 RENDIMIENTO DE MODELOS =======================================================================
go

CREATE view MAND.VOLUMEN_DE_PEDIDOS
as
select sum(h.cant_pedidos) as cantidad, t.tiempo_año as anio, t.tiempo_mes as mes, turno_detalle as tur.turno, suc.sucursal_id as sucursal
from MAND.HECHOS_PEDIDOS as h
join MAND.DIMENSION_TIEMPO  as t on h.dimension_tiempo = t.tiempo_codigo
join MAND.DIMENSION_TURNO_PEDIDO as tur on h.dimension_turno_pedido = tur.turno_codigo
join MAND.DIMENSION_SUCURSAL as suc on h.dimension_sucursal = suc.sucursal_id
group by t.tiempo_año,t.tiempo_mes,suc.sucursal_id,tur.turno_detalle

--======================================================= VIEW5 RENDIMIENTO DE MODELOS =======================================================================
go

create view MAND.CONVERSION_DE_PEDIDOS
as
select sum(h.cant_pedidos) as cantidad,e.estado_pedido_detalle as estado, t.tiempo_año as anio, t.tiempo_cuatrimestre as cuatrimestre,s.sucursal_id as sucursal
from MAND.HECHOS_PEDIDOS as h
join MAND.DIMENSION_ESTADO_PEDIDO as e on e.estado_pedido_codigo = h.dimension_estado_pedido
join MAND.DIMENSION_TIEMPO as t on t.tiempo_codigo = h.dimension_tiempo
join MAND.DIMENSION_SUCURSAL as s on s.sucursal_id = h.dimension_sucursal
group by e.estado_pedido_detalle,t.tiempo_año,t.tiempo_cuatrimestre,s.sucursal_id

--======================================================= VIEW6 TIEMPO PROMEDIO FABRICACIÓN =======================================================================

GO
CREATE VIEW MAND.TIEMPO_PROMEDIO_FABRICACION
AS
SELECT
    ds.sucursal_id AS [SUCURSAL],
    dt.tiempo_año AS [AÑO],
    dt.tiempo_cuatrimestre AS [CUATRIMESTRE],
    AVG(hie.promedio_fabricacion) AS [TIEMPO PROMEDIO FABRICACION]
FROM MAND.HECHOS_INGRESOS_EGRESOS hie
JOIN MAND.DIMENSION_TIEMPO dt
    ON hie.dimension_tiempo = dt.tiempo_codigo
JOIN MAND.DIMENSION_SUCURSAL ds
    ON ds.sucursal_id = hie.dimension_sucursal
GROUP BY 
    dt.tiempo_año, 
    dt.tiempo_cuatrimestre, 
    ds.sucursal_id
ORDER BY dt.tiempo_año, dt.tiempo_cuatrimestre, ds.sucursal_id

--======================================================= VIEW7 PROMEDIO COMPRAS =======================================================================

GO
CREATE VIEW MAND.PROMEDIO_COMPRAS
AS
SELECT 
    dt.tiempo_año AS [AÑO],
    dt.tiempo_mes AS [MES],
    SUM(cm.importe_total) / SUM(cm.cant_compras) AS [PROMEDIO COMPRAS]
FROM MAND.HECHOS_COMPRAS_MATERIAL cm
JOIN MAND.DIMENSION_TIEMPO dt
    ON cm.dimension_tiempo = dt.tiempo_codigo
GROUP BY 
    dt.tiempo_año, 
    dt.tiempo_mes
ORDER BY 
    dt.tiempo_año, 
    dt.tiempo_mes

--======================================================= VIEW8 PROMEDIO COMPRAS =======================================================================
GO
CREATE VIEW MAND.COMPRAS_POR_TIPO_MATERIAL
AS
SELECT
    dt.tiempo_año AS [AÑO],
    dt.tiempo_cuatrimestre AS [CUATRIMESTRE],
    ds.sucursal_id AS [SUCURSAL],
    tm.tipo_material_detalle AS [TIPO MATERIAL],
    SUM(cm.importe_total) AS [IMPORTE TOTAL]
FROM MAND.HECHOS_COMPRAS_MATERIAL cm
    JOIN MAND.DIMENSION_TIPO_MATERIAL tm
        ON cm.dimension_tipo_material = tm.tipo_material
    JOIN MAND.DIMENSION_TIEMPO dt
        ON cm.dimension_tiempo = dt.tiempo_codigo
    JOIN MAND.DIMENSION_SUCURSAL ds
        ON cm.dimension_sucursal = cm.dimension_sucursal
GROUP BY 
    dt.tiempo_año,
    dt.tiempo_cuatrimestre,
    ds.sucursal_id,
    tm.tipo_material_detalle
--======================================================= VIEW9 PORCENTAJE CUMPLIMIENTO EMVIOS =======================================================================

GO
CREATE VIEW MAND.PORCENTAJE_CUMPLIMIENTO_EMVIOS 
AS
select dt.tiempo_año AS [AÑO] ,
dt.tiempo_mes AS [MES],
sum(he.envios_cumplidos)*100/sum(he.envios_totales) as [PORCENTAJE_DE_ENVIOS_CUMPLIDOS] 
FROM
MAND.HECHOS_ENVIOS he join MAND.DIMENSION_TIEMPO dt on dt.tiempo_codigo=he.dimension_tiempo
GROUP by dt.tiempo_mes,dt.tiempo_año

--======================================================= VIEW10 LOCALIDADES_QUE_PAGAN_MAYOR_COSTO_DE_ENVIO =======================================================================

GO
CREATE VIEW MAND.LOCALIDADES_QUE_PAGAN_MAYOR_COSTO_DE_ENVIO
AS
SELECT top 3 du.ubicacion_locaclidad as [LOCALIDAD] FROM
MAND.HECHOS_ENVIOS he JOIN MAND.DIMENSION_UBICACION du on du.ubicacion_codigo=he.dimension_ubicacion
group by du.ubicacion_locaclidad
order by sum(he.promedio_envio) desc




-- CREATE IF EXISTS Y DROPS TABLES, PROCEDURES Y FUNCTIOS
-- SP PARA EJECUTAR TODA LA MIGRACION
-- PROBAR LAS VIEWS
-- ACTUALIZAR LOS DER
-- ARMAR EL DOC DE ESTRATEGIA: EXPLICAR POR QUE HICIMOS CADA TABLA DE HECHOS Y A QUE VIEWS RESPONDEN, AGREGAMOS UNA DIM PARA SUCURSAL.