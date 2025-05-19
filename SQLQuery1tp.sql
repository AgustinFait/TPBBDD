CREATE SCHEMA MAND

-- CREAR TABLAS
-- CONSTRAINS
--========================================

-- STORE PROCEDURE

-- GENERAL
-- >> SP DROP AND CREATE TABLAS

-- SP: SUCURSALES

GO

select * from gd_esquema.Maestra

-- SUCURSAL

-------SP SUCURSAL--------------------------------------------------------------------------
CREATE TABLE MAND.PROVINCIA (
	prov_codigo BIGINT PRIMARY KEY,
	prov_nombre NVARCHAR(255)
)

CREATE TABLE MAND.LOCALIDAD (
	loc_codigo BIGINT PRIMARY KEY,
	loc_nombre NVARCHAR(255),
	loc_provincia BIGINT, -- FK PROVINCIA
)

CREATE TABLE MAND.DIRECCION (
	dir_codigo BIGINT PRIMARY KEY,
	dir_nombre NVARCHAR(255),
	dir_localidad BIGINT --FK LOCALIDAD
)

CREATE TABLE MAND.SUCURSAL (
	sucursal_codigo BIGINT PRIMARY KEY,
	sucursal_mail NVARCHAR(255),
	sucursal_direccion BIGINT, -- FK DIRECCION
	sucursal_telefono NVARCHAR(255)
)

----------------------------------------------------------------------

-- COMPRAS

CREATE TABLE MAND.PROVEEDOR (
	prov_codigo BIGINT PRIMARY KEY,
	prov_razon_social NVARCHAR(255),
	prov_cuit NVARCHAR(255),
	prov_direccion BIGINT, -- FK DIRECCION
	prov_telefono NVARCHAR(255),
	prov_mail NVARCHAR(255)
)

CREATE TABLE MAND.COMPRA (
	compra_numero decimal(18,0) PRIMARY KEY,
	compra_sucursal	bigint, -- FK SUCURSAL
	compra_proveedor bigint, -- FK PROVEEDOR
	compra_fecha datetime2(6),
	compra_total decimal(18,2)
)

CREATE TABLE MAND.COMPRA_DETALLE (
	compra_det_cod bigint PRIMARY KEY,
	compra_det_compra decimal(18,0), -- FK compra
	compra_det_material	bigint, -- FK material detalle
	compra_det_precio_unit decimal(18,2),
	compra_det_cant	decimal(18,0)
)

-- FACTURAS

CREATE TABLE MAND.FACTURA (
	factura_nro	bigint PRIMARY KEY,
	factura_cliente	nvarchar(255), --FK CLIENTE
	factura_sucursal nvarchar(255), --FK SUCURSAL
	factura_fecha_hora	datetiem2(6),		
	factura_total	decimal(38,2)
)

CREATE TABLE MAND.ENVIO (
	envio_numero decimal(18,0) PRIMARY KEY,
	envio_factura bigint,	--FK FACTURA
	envio_fecha_programada	datetime2(6),	
    envio_fecha_entrega	datetime2(6),
    envio_importe_traslado	decimal(18,2),		
    envio_importe_subida	decimal(18,2)
)

CREATE TABLE MAND.CLIENTE(
    cliente_dni	nvarchar(255) PRIMARY KEY,	
    cliente_nombre nvarchar(255),
    cliente_apellido nvarchar(255),
    cliente_mail nvarchar(255),
    cliente_direccion bigint, --FK DIRECCION
    cliente_telefono nvarchar(255),
    cliente_fechaNacimieto	dateTime
)

-- MATERIALES 

CREATE TABLE MAND.MATERIAL_DETALLE(
    material_codigo	bigint 	PRIMARY KEY,
    material_precio	decimal(38,2),
    material_descripcion nvarchar(255)
)

CREATE TABLE MAND.MADERA (	
    madera_id bigint PRIMARY KEY,
    madera_dureza nvarchar(255),
    madera_color nvarchar(255),
    material_id	bigint, -- FK MATERIAL_DETALLE
)

CREATE TABLE MAND.TELA (	
    tela_id bigint PRIMARY KEY,
    tela_teaxtura nvarchar(255),
    tela_color nvarchar(255),
    material	bigint, -- FK MATERIAL_DETALLE
)

CREATE TABLE MAND.RELLENO (	
    tela_id bigint PRIMARY KEY,
    tela_teaxtura nvarchar(255),
    tela_color nvarchar(255),
    material	bigint, -- FK MATERIAL_DETALLE
)

-- SILLONES 

CREATE TABLE MAND.SILLON_COMPOSICIÓN (
    sillon_comp_codigo	bigint PRIMARY KEY,
    sillon_comp_tela bigint, --FK TELA
    sillon_comp_madera	bigint, --FK MADERA
    sillon_comp_elleno	bigint --FK RELLENO
)

CREATE TABLE MAND.SILLON(
    sillon_codigo	bigint PRIMARY KEY,
    sillon__modelo, --FK MODELO
    sillon_MEDIDA	bigint, --FK MEDIDA
    sillon_composicion	bigint --FK MODELO
)

CREATE TABLE MAND.MEDIDA (
   medidas_código bigint PRIMARY KEY,
   medidas_altura decimal(18,2),		
   medidas_anchura	decimal(18,2),
   medidas_profundidad	decimal(18,2)
)

CREATE TABLE MAND.MODELO (	
    modelo_codigo bigint PRIMARY KEY,
    modelo_nombre nvarchar(255),
    modelo_descripcion	nvarchar(255)
)

-- PEDIDO

CREATE TABLE MAND.PEDIDO (	
    pedido_nro	decimal(18,0) PRIMARY KEY,
    pedido_cliente 	nvarchar(255),-- FK CLIENTE	
    pedido_sucursal	bigint,	--FK SUCURSAL
    pedido_estado	bigint, --FK ESTADO
    pedido_fecha_hora	datetime2(6),
    pedido_total decimal(38,2)
)

CREATE TABLE MAND.ESTADO(
    estado_codigo	bigint 	PRIMARY KEY,
    estado_tipo	nvarchar(255)
)

CREATE TABLE MAND.CANCELACION_PEDIDO(
    canc_ped_codigo	bigint PRIMARY KEY,
    canc_ped_pedido	decimal(18), --FK PEDIDO
    canc_ped_motivo	nvarchar(255),
    canc_ped_fecha	datetime2(6)
)

CREATE TABLE MAND.DETALLE_PEDIDO(
    detalle_id	decimal(18,0) PRIMARY KEY,
    sillon_id	bigint, --FK SILLON
    pedido_det_subtotal	decimal(18,0),		
    pedido_det_cantidad	bigInt,
    pedido_id decimal(18,0) --FK PEDIDO
) 

--CLAVES FORANEAS

ALTER TABLE MAND.Localidad
ADD CONSTRAINT FK_localidadProvincia
FOREIGN KEY (loc_provincia) REFERENCES MAND.Provincia(prov_codigo);