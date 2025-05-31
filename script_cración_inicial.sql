USE [GD1C2025]
GO
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'MAND')
BEGIN 
	EXEC ('CREATE SCHEMA MAND')
END
GO

GO
-- ======================================================= DROP ESTRUCTURAS EXISTENTES =================================================================

-- ======================================================= DROP PROCEDURES =================================================================

DROP PROCEDURE IF EXISTS MAND.BORRAR_PROCEDURES_MIGRACION;
GO

CREATE PROCEDURE MAND.BORRAR_PROCEDURES_MIGRACION
AS
BEGIN
    SET NOCOUNT ON;

    DROP PROCEDURE IF EXISTS MAND.LIMPIAR_TABLAS;
    DROP PROCEDURE IF EXISTS MAND.MIGRAR_PROVINCIA;
    DROP PROCEDURE IF EXISTS MAND.MIGRAR_LOCALIDAD;
    DROP PROCEDURE IF EXISTS MAND.MIGRAR_DIRECCION;
    DROP PROCEDURE IF EXISTS MAND.MIGRAR_SUCURSALES;
    DROP PROCEDURE IF EXISTS MAND.migracion_proveedor;
    DROP PROCEDURE IF EXISTS MAND.migracion_compra;
    DROP PROCEDURE IF EXISTS MAND.migracion_cliente;
    DROP PROCEDURE IF EXISTS MAND.migracion_factura;
    DROP PROCEDURE IF EXISTS MAND.MIGRACION_FACTURA_DETALLE;
	DROP PROCEDURE IF EXISTS MAND.migracion_tipo_material;
    DROP PROCEDURE IF EXISTS MAND.migracion_material;
    DROP PROCEDURE IF EXISTS MAND.migracion_madera;
    DROP PROCEDURE IF EXISTS MAND.migracion_tela;
	DROP PROCEDURE IF EXISTS MAND.MIGRACION_SILLON;
    DROP PROCEDURE IF EXISTS MAND.migracion_relleno;
    DROP PROCEDURE IF EXISTS MAND.migracion_modelo;
    DROP PROCEDURE IF EXISTS MAND.migracion_medidas;
	DROP PROCEDURE IF EXISTS MAND.MIGRACION_SILLON_COMPOSICION;
	DROP PROCEDURE IF EXISTS MAND.MIGRACION_SILLON_DETALLE;
    DROP PROCEDURE IF EXISTS MAND.migrar_estado;
    DROP PROCEDURE IF EXISTS MAND.migrar_compra_detalle;
    DROP PROCEDURE IF EXISTS MAND.ejecutarMigracion;

END;
GO

-- ======================================================= DROP TABLES =================================================================

GO
CREATE PROCEDURE MAND.LIMPIAR_TABLAS
AS
BEGIN
    SET NOCOUNT ON;
	DROP TABLE IF EXISTS MAND.DETALLE_FACTURA;
	DROP TABLE IF EXISTS MAND.DETALLE_PEDIDO;
	DROP TABLE IF EXISTS MAND.CANCELACION_PEDIDO;
	DROP TABLE IF EXISTS MAND.PEDIDO;
	DROP TABLE IF EXISTS MAND.ESTADO;
	DROP TABLE IF EXISTS MAND.COMPRA_DETALLE;
	DROP TABLE IF EXISTS MAND.SILLON;
	DROP TABLE IF EXISTS MAND.SILLON_COMPOSICION;
	DROP TABLE IF EXISTS MAND.MEDIDA;
	DROP TABLE IF EXISTS MAND.MODELO;
	DROP TABLE IF EXISTS MAND.RELLENO;
	DROP TABLE IF EXISTS MAND.TELA;
	DROP TABLE IF EXISTS MAND.MADERA;
	DROP TABLE IF EXISTS MAND.MATERIAL;
	DROP TABLE IF EXISTS MAND.TIPO_MATERIAL;
	DROP TABLE IF EXISTS MAND.ENVIO;
	DROP TABLE IF EXISTS MAND.FACTURA;
	DROP TABLE IF EXISTS MAND.CLIENTE;
	DROP TABLE IF EXISTS MAND.COMPRA;
	DROP TABLE IF EXISTS MAND.PROVEEDOR;
    DROP TABLE IF EXISTS MAND.SUCURSAL;
    DROP TABLE IF EXISTS MAND.DIRECCION;
    DROP TABLE IF EXISTS MAND.LOCALIDAD;
    DROP TABLE IF EXISTS MAND.PROVINCIA;
END;
GO

-- ======================================================= DROP ESTRUCTURAS EXISTENTES - EXECS =================================================================

EXEC MAND.LIMPIAR_TABLAS;
EXEC MAND.BORRAR_PROCEDURES_MIGRACION;

-- ======================================================= TABLAS =================================================================
GO

CREATE TABLE MAND.PROVINCIA (
	prov_codigo BIGINT IDENTITY(1,1) PRIMARY KEY,
	prov_nombre NVARCHAR(255) 
)

CREATE TABLE MAND.LOCALIDAD (
	loc_codigo BIGINT IDENTITY(1,1) PRIMARY KEY,
	loc_nombre NVARCHAR(255) ,
	loc_provincia BIGINT -- FK PROVINCIA
)

CREATE TABLE MAND.DIRECCION (
	dir_codigo BIGINT IDENTITY(1,1) PRIMARY KEY,
	dir_nombre NVARCHAR(255) ,
	dir_localidad BIGINT--FK LOCALIDAD
)

CREATE TABLE MAND.SUCURSAL (
	sucursal_codigo BIGINT PRIMARY KEY,
	sucursal_mail NVARCHAR(255) ,
	sucursal_direccion BIGINT, -- FK DIRECCION
	sucursal_telefono NVARCHAR(255)
)

CREATE TABLE MAND.PROVEEDOR (
	prov_codigo BIGINT IDENTITY(1,1) PRIMARY KEY,
	prov_razon_social NVARCHAR(255),
	prov_cuit NVARCHAR(255),
	prov_direccion BIGINT, -- FK DIRECCION
	prov_telefono NVARCHAR(255) ,
	prov_mail NVARCHAR(255)
)



CREATE TABLE MAND.COMPRA (
	compra_numero decimal(18,0) PRIMARY KEY,
	compra_sucursal	bigint, -- FK SUCURSAL
	compra_proveedor bigint, -- FK PROVEEDOR
	compra_fecha datetime2(6),
	compra_total decimal(18,2),
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

CREATE TABLE MAND.FACTURA (
	factura_nro	bigint PRIMARY KEY,
	factura_cliente	nvarchar(255), --FK CLIENTE
	factura_sucursal bigint, --FK SUCURSAL
	factura_fecha_hora	datetime2(6),		
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

CREATE TABLE MAND.TIPO_MATERIAL (
    tipo_material_codigo bigint IDENTITY(1,1) PRIMARY KEY,
    tipo_material_nombre nvarchar(255),
    tipo_material_descripcion nvarchar(255),
    tipo_material_tipo nvarchar(255),
)

CREATE TABLE MAND.MATERIAL (
    material_codigo bigint IDENTITY(1,1) PRIMARY KEY,
    material_tipo_id bigint, --FK TIPO_MATERIAL
    material_precio decimal(38,2)
)

CREATE TABLE MAND.MADERA (	
    madera_id bigint IDENTITY(1,1) PRIMARY KEY,
    madera_dureza nvarchar(255),
    madera_color nvarchar(255),
    madera_tipo_material_id	bigint --FK TIPO_MATERIAL
)

CREATE TABLE MAND.TELA (	
    tela_id bigint IDENTITY(1,1) PRIMARY KEY,
    tela_teaxtura nvarchar(255),
    tela_color nvarchar(255),
    tela_tipo_material_id	bigint --FK TIPO_MATERIAL
)

CREATE TABLE MAND.RELLENO (	
    relleno_id bigint IDENTITY(1,1) PRIMARY KEY,
    relleno_densidad decimal(38,2),
    relleno_tipo_material_id	bigint --FK TIPO_MATERIAL
)

CREATE TABLE MAND.MODELO (	
    modelo_codigo bigint PRIMARY KEY,
    modelo_nombre nvarchar(255),
    modelo_descripcion	nvarchar(255),
	modelo_precio decimal(18,2)
)

CREATE TABLE MAND.MEDIDA (
   medidas_código bigint IDENTITY(1,1) PRIMARY KEY,
   medidas_altura decimal(18,2),		
   medidas_anchura	decimal(18,2),
   medidas_profundidad	decimal(18,2),
   medidas_precio decimal(18,2)
)

CREATE TABLE MAND.SILLON(
    sillon_codigo	bigint PRIMARY KEY,
    sillon_modelo bigint, --FK MODELO
    sillon_medida	bigint, --FK MEDIDA
	sillon_composicion bigint --FK SILLON
)

CREATE TABLE MAND.SILLON_COMPOSICION (
      sillon_comp_codigo bigint IDENTITY(1,1) PRIMARY KEY,
	  sillon_comp_madera bigint,
	  sillon_comp_relleno bigint,
	  sillon_comp_tela bigint
)

CREATE TABLE MAND.COMPRA_DETALLE (
	compra_det_cod bigint IDENTITY(1,1) PRIMARY KEY,
	compra_det_compra decimal(18,0), -- FK compra
	compra_det_material	bigint, -- FK material sillon
	compra_det_precio_unit decimal(18,2),
	compra_det_cant	decimal(18,0),
    compra_det_subtotal decimal(18,2)
)

CREATE TABLE MAND.ESTADO(
    estado_codigo	bigint IDENTITY(1,1)	PRIMARY KEY,
    estado_tipo	nvarchar(255) check (estado_tipo='ENTREGADO' OR estado_tipo='CANCELADO' OR estado_tipo='PENDIENTE')
)



CREATE TABLE MAND.PEDIDO (	
    pedido_nro	decimal(18,0) PRIMARY KEY,
    pedido_cliente 	nvarchar(255),-- FK CLIENTE	
    pedido_sucursal	bigint,	--FK SUCURSAL
    pedido_estado	bigint, --FK ESTADO
    pedido_fecha_hora	datetime2(6),
    pedido_total decimal(38,2)
)

CREATE TABLE MAND.CANCELACION_PEDIDO(
    canc_ped_codigo	bigint PRIMARY KEY,
    canc_ped_pedido	decimal(18,0), --FK PEDIDO
    canc_ped_motivo	nvarchar(255),
    canc_ped_fecha	datetime2(6)
)

CREATE TABLE MAND.DETALLE_PEDIDO(
    detalle_pedido_id	decimal(18,0) PRIMARY KEY,
    sillon_id	bigint, --FK SILLON
    pedido_det_precio	decimal(18,0),		
    pedido_det_cantidad	bigInt,
    pedido_id decimal(18,0), --FK PEDIDO
    pedido_det_subtotal decimal(18,2)
) 

CREATE TABLE MAND.DETALLE_FACTURA(
    detalle_factura_id	bigint IDENTITY(1,1) PRIMARY KEY,
    detalle_factura_factura	bigint, --FK factura	
    detalle_factura_pedido	decimal(18,0), --FK pedido
    detalle_factura_precio	decimal(18,2),
    detalle_factura_cantidad decimal(18,0),
    detalle_factura_subtotal decimal(18,2)
) 

-- ======================================================= FOREIGN KEYS =================================================================

ALTER TABLE MAND.LOCALIDAD
ADD CONSTRAINT FK_localidadProvincia
FOREIGN KEY (loc_provincia) REFERENCES MAND.PROVINCIA(prov_codigo)

ALTER TABLE MAND.DIRECCION
ADD CONSTRAINT FK_direccionLocalidad
FOREIGN KEY (dir_localidad) REFERENCES MAND.LOCALIDAD(loc_codigo)

ALTER TABLE MAND.SUCURSAL
ADD CONSTRAINT FK_sucursalDireccion
FOREIGN KEY (sucursal_direccion) REFERENCES MAND.DIRECCION(dir_codigo)

ALTER TABLE MAND.PROVEEDOR
ADD CONSTRAINT FK_proveedorDireccion
FOREIGN KEY (prov_direccion) REFERENCES MAND.DIRECCION(dir_codigo)

ALTER TABLE MAND.COMPRA
ADD CONSTRAINT FK_compraSucursal
FOREIGN KEY (compra_sucursal) REFERENCES MAND.SUCURSAL(sucursal_codigo)

ALTER TABLE MAND.COMPRA
ADD CONSTRAINT FK_compraProveedor
FOREIGN KEY (compra_proveedor) REFERENCES MAND.PROVEEDOR(prov_codigo)

ALTER TABLE MAND.CLIENTE
ADD CONSTRAINT FK_clienteDireccion
FOREIGN KEY (cliente_direccion) REFERENCES MAND.DIRECCION(dir_codigo)

ALTER TABLE MAND.FACTURA
ADD CONSTRAINT FK_facturaSucursal
FOREIGN KEY (factura_sucursal) REFERENCES MAND.SUCURSAL(sucursal_codigo)

ALTER TABLE MAND.FACTURA
ADD CONSTRAINT FK_facturaCliente
FOREIGN KEY (factura_cliente) REFERENCES MAND.CLIENTE(cliente_dni)

ALTER TABLE MAND.ENVIO
ADD CONSTRAINT FK_facturaEnvio
FOREIGN KEY (envio_factura) REFERENCES MAND.FACTURA(factura_nro)

ALTER TABLE MAND.TELA
ADD CONSTRAINT FK_telaTipoMaterial
FOREIGN KEY (tela_tipo_material_id) REFERENCES MAND.TIPO_MATERIAL(tipo_material_codigo)

ALTER TABLE MAND.MADERA
ADD CONSTRAINT FK_maderaTipoMaterial
FOREIGN KEY (madera_tipo_material_id) REFERENCES MAND.TIPO_MATERIAL(tipo_material_codigo)

ALTER TABLE MAND.RELLENO
ADD CONSTRAINT FK_rellenoTipoMaterial
FOREIGN KEY (relleno_tipo_material_id) REFERENCES MAND.TIPO_MATERIAL(tipo_material_codigo)

ALTER TABLE MAND.MATERIAL
ADD CONSTRAINT FK_materialTipoMaterial
FOREIGN KEY (material_tipo_id) REFERENCES MAND.TIPO_MATERIAL(tipo_material_codigo)

ALTER TABLE MAND.SILLON
ADD CONSTRAINT FK_sillonModelo
FOREIGN KEY (sillon_modelo) REFERENCES MAND.MODELO ( modelo_codigo)

ALTER TABLE MAND.SILLON
ADD CONSTRAINT FK_sillonMedida
FOREIGN KEY (sillon_medida) REFERENCES MAND.MEDIDA ( medidas_código)

ALTER TABLE MAND.SILLON
ADD CONSTRAINT FK_sillonComposicion
FOREIGN KEY (sillon_composicion) REFERENCES MAND.SILLON_COMPOSICION (sillon_comp_codigo)

ALTER TABLE MAND.SILLON_COMPOSICION
ADD CONSTRAINT FK_detalleSillonTela
FOREIGN KEY (sillon_comp_tela) REFERENCES MAND.TELA (tela_id)

ALTER TABLE MAND.SILLON_COMPOSICION
ADD CONSTRAINT FK_detalleSillonMadera
FOREIGN KEY ( sillon_comp_madera) REFERENCES MAND.MADERA(madera_id)

ALTER TABLE MAND.SILLON_COMPOSICION
ADD CONSTRAINT FK_detalleSillonRelleno
FOREIGN KEY ( sillon_comp_relleno) REFERENCES MAND.RELLENO(relleno_id)


ALTER TABLE MAND.COMPRA_DETALLE
ADD CONSTRAINT FK_compraDetalleCompra
FOREIGN KEY (compra_det_compra) REFERENCES MAND.COMPRA(compra_numero)

ALTER TABLE MAND.COMPRA_DETALLE
ADD CONSTRAINT FK_compraDetalleDetalleMaterial
FOREIGN KEY (compra_det_material) REFERENCES MAND.MATERIAL (material_codigo)

ALTER TABLE MAND.PEDIDO 
ADD CONSTRAINT FK_pedidoEstado
FOREIGN KEY (pedido_estado) REFERENCES MAND.ESTADO

ALTER TABLE MAND.PEDIDO 
ADD CONSTRAINT FK_pedidoSucursal
FOREIGN KEY (pedido_sucursal) REFERENCES MAND.SUCURSAL(sucursal_codigo)

ALTER TABLE MAND.PEDIDO 
ADD CONSTRAINT FK_pedidoCliente
FOREIGN KEY (pedido_cliente) REFERENCES  MAND.CLIENTE(cliente_dni)

ALTER TABLE MAND.CANCELACION_PEDIDO
ADD CONSTRAINT FK_cancelacionPedido
FOREIGN KEY (canc_ped_pedido) REFERENCES MAND.PEDIDO(pedido_nro)

ALTER TABLE MAND.DETALLE_PEDIDO
ADD CONSTRAINT FK_detallePedidoPedido
FOREIGN KEY (pedido_id) REFERENCES MAND.PEDIDO (pedido_nro)

ALTER TABLE MAND.DETALLE_PEDIDO
ADD CONSTRAINT FK_detallePedidoSillon
FOREIGN KEY ( sillon_id) REFERENCES MAND.SILLON (sillon_codigo)

ALTER TABLE MAND.DETALLE_FACTURA
ADD CONSTRAINT FK_detalleFacturaPedido
FOREIGN KEY (detalle_factura_pedido) REFERENCES MAND.DETALLE_PEDIDO (detalle_pedido_id)

ALTER TABLE MAND.DETALLE_FACTURA
ADD CONSTRAINT FK_detalleFacturaFactura
FOREIGN KEY (detalle_factura_factura) REFERENCES MAND.FACTURA (factura_nro)

-- ======================================================= STORE PROCEDURES =================================================================

-- ======================================================= SP PROVINCIAS =================================================================
GO
CREATE PROCEDURE MAND.MIGRAR_PROVINCIA
AS
BEGIN
	INSERT INTO MAND.PROVINCIA 
	SELECT DISTINCT REPLACE(Cliente_Provincia, ';', 'go')
	FROM gd_esquema.Maestra 
	WHERE Cliente_Provincia IS NOT NULL
END;
GO



-- ======================================================= SP LOCALIDAD =================================================================
GO
CREATE PROCEDURE MAND.MIGRAR_LOCALIDAD
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO MAND.LOCALIDAD

    SELECT DISTINCT 
		REPLACE(Cliente_Localidad, ';', 'Go') AS Localidad,
		p.prov_codigo as PROV_COD
    FROM gd_esquema.Maestra
	JOIN MAND.PROVINCIA as p
	ON p.prov_nombre = REPLACE(Cliente_Provincia, ';', 'Go')
    WHERE Cliente_Localidad IS NOT NULL

    UNION

    SELECT DISTINCT 
		REPLACE(Proveedor_Localidad, ';', 'Go') AS Localidad,
		p.prov_codigo as PROV_COD
    FROM gd_esquema.Maestra
	JOIN MAND.PROVINCIA as p
	ON p.prov_nombre = REPLACE(Proveedor_Provincia, ';', 'Go')
    WHERE Proveedor_Localidad IS NOT NULL

    UNION

    SELECT DISTINCT 
		REPLACE(Sucursal_Localidad, ';', 'Go') AS Localidad,
		p.prov_codigo as PROV_COD
    FROM gd_esquema.Maestra
	JOIN MAND.PROVINCIA as p
	ON p.prov_nombre = REPLACE(Sucursal_Provincia, ';', 'Go')
    WHERE Sucursal_Localidad IS NOT NULL
END;
GO


-- ======================================================= SP DIRECCION =================================================================
CREATE PROCEDURE MAND.MIGRAR_DIRECCION
AS
BEGIN

	INSERT INTO MAND.DIRECCION
	SELECT DISTINCT 
		REPLACE(Cliente_Direccion, ';', 'Go') AS DIRECCION,
		L.loc_codigo AS LOC_COD
	FROM gd_esquema.Maestra
	JOIN MAND.LOCALIDAD AS L
	ON L.loc_nombre = REPLACE(Cliente_Localidad, ';', 'Go')
	WHERE Cliente_Direccion IS NOT NULL

	UNION

	SELECT DISTINCT 
		REPLACE(Proveedor_Direccion, ';', 'Go') AS DIRECCION,
		L.loc_codigo AS LOC_COD
	FROM gd_esquema.Maestra
	JOIN MAND.LOCALIDAD AS L
	ON L.loc_nombre = REPLACE(Proveedor_Localidad, ';', 'Go')
	WHERE Proveedor_Direccion IS NOT NULL

	UNION

	SELECT DISTINCT 
		REPLACE(Sucursal_Direccion, ';', 'Go') AS DIRECCION,
		L.loc_codigo AS LOC_COD
	FROM gd_esquema.Maestra
	JOIN MAND.LOCALIDAD AS L
	ON L.loc_nombre = REPLACE(Sucursal_Localidad, ';', 'Go')
	WHERE Sucursal_Direccion IS NOT NULL

END

GO

-- ======================================================= SP SUCURSALES =================================================================
GO
create PROCEDURE MAND.MIGRAR_SUCURSALES
AS
BEGIN
	INSERT INTO MAND.SUCURSAL

	SELECT DISTINCT
		Sucursal_NroSucursal,
		Sucursal_mail,
		D.dir_codigo,
		Sucursal_telefono
	FROM gd_esquema.Maestra 
	JOIN MAND.DIRECCION AS D
	ON D.dir_nombre = REPLACE(Sucursal_Direccion, ';', 'Go')
	JOIN MAND.LOCALIDAD as L ON L.loc_codigo=D.dir_localidad AND L.loc_nombre=REPLACE(Sucursal_Localidad, ';', 'Go')
	JOIN MAND.PROVINCIA as p ON L.loc_provincia=p.prov_codigo AND p.prov_nombre=REPLACE(Sucursal_Provincia, ';', 'Go')
	WHERE Sucursal_NroSucursal IS NOT NULL
END

-- ======================================================= SP PROVEEDOR =================================================================

GO
	create PROCEDURE MAND.migracion_proveedor
	AS
	BEGIN
		INSERT INTO MAND.PROVEEDOR
		select distinct
		Proveedor_RazonSocial,Proveedor_Cuit,  D.dir_codigo, Proveedor_Telefono,REPLACE(Proveedor_Mail,' ','')
		from gd_esquema.Maestra
		join MAND.DIRECCION D ON D.dir_nombre = REPLACE(Proveedor_Direccion, ';', 'Go')
		JOIN MAND.LOCALIDAD as L ON L.loc_codigo=D.dir_localidad AND L.loc_nombre=REPLACE(Proveedor_Localidad, ';', 'Go')
	    JOIN MAND.PROVINCIA as p ON L.loc_provincia=p.prov_codigo AND p.prov_nombre=REPLACE(Proveedor_Provincia, ';', 'Go')
		where Proveedor_Cuit is not null
    END
GO

-- ======================================================= SP COMPRA =================================================================

GO
CREATE PROCEDURE MAND.migracion_compra
AS
    BEGIN
        INSERT INTO MAND.COMPRA
        select distinct
		Compra_Numero,
		Sucursal_NroSucursal, 
		P.prov_codigo ,
		Compra_Fecha,Compra_Total
        from gd_esquema.Maestra 
		join MAND.PROVEEDOR P ON
		    P.prov_razon_social=Proveedor_RazonSocial AND
			P.prov_cuit=Proveedor_Cuit and
			p.prov_telefono = Proveedor_Telefono and
			p.prov_mail=REPLACE(Proveedor_Mail,' ','')
        where Compra_Numero is not null
    END
GO

-- ======================================================= SP CLIENTE =================================================================

GO
CREATE PROCEDURE MAND.migracion_cliente as
BEGIN 

INSERT INTO MAND.CLIENTE
      SELECT distinct
	  M.Cliente_Dni,
	         replace(M.Cliente_Nombre,';','') as Cliente_Nombre,
			 replace(M.Cliente_Apellido,';','') as Cliente_Apellido,
			 replace(M.Cliente_Mail,';','') as Cliente_Mail,
			 D.dir_codigo,
			 M.Cliente_Telefono,
			 M.Cliente_FechaNacimiento
	  FROM gd_esquema.Maestra M 
	       join MAND.DIRECCION D ON D.dir_nombre = REPLACE(M.Cliente_Direccion, ';', 'Go')
		JOIN MAND.LOCALIDAD as L ON L.loc_codigo=D.dir_localidad AND L.loc_nombre=REPLACE(M.Cliente_Localidad, ';', 'Go')
	    JOIN MAND.PROVINCIA as p ON L.loc_provincia=p.prov_codigo AND p.prov_nombre=REPLACE(M.Cliente_Provincia, ';', 'Go')

UPDATE MAND.CLIENTE SET Cliente_Mail=replace(Cliente_Mail,' ','')
END
GO

-- ======================================================= SP FACTURA =================================================================

GO
CREATE PROCEDURE MAND.migracion_factura AS
BEGIN 
     
     INSERT INTO MAND.FACTURA 
     SELECT DISTINCT 
	 M.Factura_Numero,
	        M.Cliente_Dni,
			M.Sucursal_NroSucursal,
			M.Factura_Fecha,
			M.Factura_Total
	 FROM gd_esquema.Maestra M
     WHERE M.Factura_Fecha is not null and
	       M.Factura_Numero is not null and
		   M.Factura_Total is not null 


END
GO

-- ======================================================= SP FACTURA DETALLE =================================================================


CREATE PROCEDURE MAND.MIGRACION_FACTURA_DETALLE
AS
BEGIN
    INSERT INTO MAND.DETALLE_FACTURA

    SELECT DISTINCT m.Factura_Numero, m.Pedido_Numero, m.Detalle_Factura_Precio, m.Detalle_Factura_Cantidad, m.Detalle_Factura_SubTotal
    FROM gd_esquema.Maestra as m
	JOIN MAND.DETALLE_PEDIDO d
	ON d.sillon_id = m.Sillon_Codigo
		AND d.pedido_det_cantidad = m.Detalle_Pedido_Cantidad
		AND d.pedido_det_precio = m.Detalle_Pedido_Precio
		AND d.pedido_det_subtotal = m.Detalle_Pedido_SubTotal
		AND d.pedido_id = m.Pedido_Numero
    WHERE m.Factura_Numero IS NOT NULL
		AND m.Pedido_Numero IS NOT NULL
		AND m.Detalle_Factura_Cantidad IS NOT NULL
END

GO
CREATE TRIGGER MAND.migracion_envio on MAND.FACTURA  for insert 
AS

INSERT INTO MAND.ENVIO
SELECT DISTINCT
       M.Envio_Numero,
       M.Factura_Numero,
	   M.Envio_Fecha_Programada,
	   M.Envio_Fecha,
	   M.Envio_ImporteTraslado,
	   M.Envio_importeSubida
FROM gd_esquema.Maestra M
 where M.Envio_Numero is not null and
       M.Factura_Numero is not null and
	   M.Envio_Fecha_Programada is not null and
	   M.Envio_Fecha is not null and
	   M.Envio_ImporteTraslado is not null and
	   M.Envio_importeSubida is not null 


GO

-- ======================================================= SP TIPO MATERIAL =================================================================


go
CREATE PROCEDURE MAND.migracion_tipo_material
	AS
	BEGIN
		INSERT INTO	MAND.TIPO_MATERIAL
		select DISTINCT 
		     M.Material_Nombre,
			 M.Material_Descripcion,
			 M.Material_Tipo
		from gd_esquema.Maestra M
		where M.Material_Nombre is not null and 
			 M.Material_Descripcion is not null and 
			 M.Material_Tipo is not null 
		
	END
go

-- ======================================================= SP MATERIAL =================================================================

go
create PROCEDURE MAND.migracion_material
	AS

	
	BEGIN
		INSERT INTO	MAND.MATERIAL
		select DISTINCT 
		      tm.tipo_material_codigo,
		     M.Material_Precio
	
		from gd_esquema.Maestra M
		     join MAND.TIPO_MATERIAL TM ON 
	         M.Material_Nombre = TM.tipo_material_nombre AND
			 M.Material_Descripcion = TM.tipo_material_descripcion AND
			 M.Material_Tipo = TM.tipo_material_tipo
		where  M.Material_Precio is not null
		order by 2
	END
go

-- ======================================================= SP MADERA =================================================================


GO
CREATE PROCEDURE MAND.migracion_madera
	AS
	BEGIN
		INSERT INTO	MAND.MADERA
		 SELECT DISTINCT
		       M.Madera_Dureza,
			   m.Madera_Color,
			   TM.tipo_material_codigo
		 FROM gd_esquema.Maestra M 
		    JOIN MAND.TIPO_MATERIAL TM ON 
			   TM.tipo_material_nombre = M.Material_Nombre AND
			 TM.tipo_material_descripcion = M.Material_Descripcion AND
			 TM.tipo_material_tipo = 'Madera'
		
	END
GO

-- ======================================================= SP TELA =================================================================

GO
CREATE PROCEDURE MAND.migracion_tela
	AS
	BEGIN
		INSERT INTO	MAND.TELA
		 SELECT DISTINCT
		       M.Tela_Textura,
			   m.tela_Color,
			   TM.tipo_material_codigo
		 FROM gd_esquema.Maestra M 
		    JOIN MAND.TIPO_MATERIAL TM ON 
			   TM.tipo_material_nombre = M.Material_Nombre AND
			 TM.tipo_material_descripcion = M.Material_Descripcion AND
			 TM.tipo_material_tipo = 'Tela' 
		
	END
GO

-- ======================================================= SP RELLENO =================================================================

GO
CREATE PROCEDURE MAND.migracion_relleno
	AS
	BEGIN
		INSERT INTO	MAND.RELLENO
		 SELECT DISTINCT
		       M.Relleno_Densidad,
			   TM.tipo_material_codigo
		 FROM gd_esquema.Maestra M 
		    JOIN MAND.TIPO_MATERIAL TM ON 
			   TM.tipo_material_nombre = M.Material_Nombre AND
			 TM.tipo_material_descripcion = M.Material_Descripcion AND
			 TM.tipo_material_tipo = 'Relleno' 
		
	END
GO

-- ======================================================= SP MODELO SILLON =================================================================

GO
CREATE PROCEDURE MAND.migracion_modelo
AS
BEGIN

INSERT INTO MAND.MODELO 
   select DISTINCT m.Sillon_modelo_Codigo,
          REPLACE(m.sillon_modelo,':',''),
		  REPLACE(m.Sillon_Modelo_Descripcion,':',''),
		  m.Sillon_Modelo_Precio
   from gd_esquema.Maestra m
   WHERE m.Sillon_Modelo_Codigo IS NOT NULL AND
          m.sillon_modelo IS NOT NULL AND
		  m.Sillon_Modelo_Descripcion IS NOT NULL 
    
END
GO

-- ======================================================= SP MEDIDAS SILLON =================================================================

GO
CREATE PROCEDURE MAND.migracion_medidas
AS
BEGIN

INSERT INTO MAND.MEDIDA 
   select DISTINCT
      m.Sillon_Medida_Alto,
		  m.Sillon_Medida_Ancho,
		  m.Sillon_Medida_Profundidad,
		  m.Sillon_Medida_Precio
   from gd_esquema.Maestra m
   WHERE m.Sillon_Medida_Alto IS NOT NULL AND
          m.Sillon_Medida_Ancho IS NOT NULL AND
		  m.Sillon_Medida_Profundidad IS NOT NULL  and
		  m.Sillon_Medida_Precio IS NOT NULL
    
END
GO
-- ======================================================= SP SILLON COMPOSICION =================================================================

CREATE PROCEDURE MAND.MIGRACION_SILLON_COMPOSICION
AS
BEGIN
	
	INSERT INTO MAND.SILLON_COMPOSICION

	SELECT DISTINCT 
		m.madera_id,
		r.relleno_id,
		t.tela_id
	FROM gd_esquema.Maestra gt
	JOIN gd_esquema.Maestra gm
		ON gt.sillon_codigo = gm.sillon_codigo
		AND gt.Sillon_Modelo_Codigo = gm.Sillon_Modelo_Codigo
		AND gt.Tela_Color IS NOT NULL
		AND gm.Tela_Color IS NULL
		AND gm.Madera_Color IS NOT NULL
		AND gt.Sillon_Codigo IS NOT NULL
		AND gt.Sillon_Modelo_Codigo IS NOT NULL
	JOIN gd_esquema.Maestra gr
		ON gr.Relleno_Densidad IS NOT NULL
		AND gr.sillon_codigo = gm.sillon_codigo
		AND gr.Sillon_Modelo_Codigo = gm.Sillon_Modelo_Codigo
	JOIN MAND.TELA t
		ON t.tela_color = gt.Tela_Color
		AND t.tela_teaxtura = gt.Tela_Textura
	JOIN MAND.MADERA m
		ON m.madera_color = gm.Madera_Color
		AND m.madera_dureza = gm.Madera_Dureza
	JOIN MAND.RELLENO r
		ON r.relleno_densidad = gr.Relleno_Densidad
END
GO

-- ======================================================= SP SILLON =================================================================

CREATE PROCEDURE MAND.MIGRACION_SILLON
AS
BEGIN

	INSERT INTO MAND.SILLON 

    SELECT DISTINCT 
		gt.Sillon_Codigo, 
		gt.Sillon_Modelo_Codigo,
		med.medidas_código, 
		sp.sillon_comp_codigo,
	FROM gd_esquema.Maestra gt
    JOIN gd_esquema.Maestra gm
		ON gt.sillon_codigo = gm.sillon_codigo
		AND gt.Sillon_Modelo_Codigo = gm.Sillon_Modelo_Codigo
		AND gt.Tela_Color IS NOT NULL
		AND gm.Tela_Color IS NULL
		AND gm.Madera_Color IS NOT NULL
		AND gt.Sillon_Codigo IS NOT NULL
		AND gt.Sillon_Modelo_Codigo IS NOT NULL
	JOIN gd_esquema.Maestra gr
		ON gr.Relleno_Densidad IS NOT NULL
		AND gr.sillon_codigo = gm.sillon_codigo
		AND gr.Sillon_Modelo_Codigo = gm.Sillon_Modelo_Codigo
	JOIN MAND.TELA t
		ON t.tela_color = gt.Tela_Color
		AND t.tela_teaxtura = gt.Tela_Textura
	JOIN MAND.MADERA m
		ON m.madera_color = gm.Madera_Color
		AND m.madera_dureza = gm.Madera_Dureza
	JOIN MAND.RELLENO r
		ON r.relleno_densidad = gr.Relleno_Densidad
	JOIN MAND.SILLON_COMPOSICION sp
		ON sp.sillon_comp_madera = m.madera_id
		AND sp.sillon_comp_relleno = r.relleno_id
		AND sp.sillon_comp_tela = t.tela_id
	JOIN MAND.MEDIDA med
		ON gt.Sillon_Medida_Ancho = med.medidas_anchura
	   	AND gt.Sillon_Medida_Profundidad = med.medidas_profundidad
		AND gt.Sillon_Medida_Precio = med.medidas_precio
		AND gt.Sillon_Medida_Alto = med.medidas_altura
	WHERE 
		gt.Sillon_Medida_Alto IS NOT NULL
		AND gt.Sillon_Modelo_Codigo IS NOT NULL
		AND gt.Tela_Color IS NOT NULL
		AND gm.Madera_Color IS NOT NULL
		AND gr.Relleno_Densidad IS NOT NULL

END
GO

-- ======================================================= SP SILLON DETALLE =================================================================
GO
CREATE PROCEDURE MAND.MIGRACION_SILLON_DETALLE
AS
BEGIN

	SELECT DISTINCT G.Sillon_Codigo, t.tipo_material_codigo
	FROM gd_esquema.Maestra g
	JOIN MAND.TIPO_MATERIAL t
	ON g.Material_Nombre = t.tipo_material_nombre
		AND g.Material_Descripcion = t.tipo_material_descripcion
		AND g.Material_Tipo = t.tipo_material_tipo
	WHERE g.Sillon_Codigo IS NOT NULL
END

-- ======================================================= SP ESTADO PEDIDO =================================================================

GO
CREATE PROCEDURE MAND.migrar_estado 
AS
BEGIN
IF NOT EXISTS (SELECT estado_tipo from MAND.ESTADO WHERE estado_tipo='ENTREGADO')
  INSERT INTO MAND.ESTADO
    VALUES('ENTREGADO')
IF NOT EXISTS (SELECT estado_tipo from MAND.ESTADO WHERE estado_tipo='CANCELADO')
   INSERT INTO MAND.ESTADO
     VALUES('CANCELADO')
IF NOT EXISTS (SELECT estado_tipo from MAND.ESTADO WHERE estado_tipo='PENDIENTE')
    INSERT INTO MAND.ESTADO (estado_tipo)
     VALUES ('PENDIENTE')

END
GO

-- ======================================================= SP COMPRA DETALLE =================================================================

GO
create PROCEDURE MAND.migrar_compra_detalle
AS
BEGIN
INSERT INTO MAND.COMPRA_DETALLE
  SELECT DISTINCT 
      M.Compra_Numero,
	  Ma.material_codigo,
	  M.Detalle_Compra_Precio,
	  M.Detalle_Compra_Cantidad,
	  M.Detalle_Compra_SubTotal
  FROM gd_esquema.Maestra m
	JOIN MAND.TIPO_MATERIAL Tm on 
	 Tm.tipo_material_descripcion=m.Material_Descripcion 
	and Tm.tipo_material_tipo=m.Material_Tipo
	and Tm.tipo_material_nombre=m.Material_Nombre
    JOIN MAND.MATERIAL Ma ON  Ma.material_tipo_id=Tm.tipo_material_codigo
  WHERE M.Compra_Numero IS NOT NULL AND
	  M.Detalle_Compra_Precio IS NOT NULL AND
	  M.Detalle_Compra_Cantidad IS NOT NULL AND
	  M.Detalle_Compra_SubTotal IS NOT NULL 

END
GO

-- ======================================================= SP MIGRACION =================================================================

go
CREATE PROCEDURE MAND.ejecutarMigracion 
as 
BEGIN
PRINT '';
EXEC MAND.MIGRAR_PROVINCIA;
EXEC MAND.MIGRAR_LOCALIDAD;
EXEC MAND.MIGRAR_DIRECCION;
EXEC MAND.MIGRAR_SUCURSALES;
EXEC MAND.migracion_proveedor;
EXEC MAND.migracion_compra;
EXEC MAND.migracion_cliente;
EXEC MAND.migracion_factura;
EXEC MAND.MIGRACION_FACTURA_DETALLE;
EXEC MAND.migracion_tipo_material;
EXEC MAND.migracion_material;
EXEC MAND.migracion_madera;
EXEC MAND.migracion_tela;
EXEC MAND.migracion_relleno;
EXEC MAND.migracion_modelo;
EXEC MAND.migracion_medidas;
PRINT 'SILLON COMPOSICION';
EXEC MAND.MIGRACION_SILLON_COMPOSICION;
PRINT 'SILLON';
EXEC MAND.MIGRACION_SILLON;
EXEC MAND.migrar_compra_detalle;
EXEC MAND.migrar_estado;
END

go
exec  MAND.ejecutarMigracion
go

-- ======================================================= PRUEBAS =================================================================

	SELECT DISTINCT 
		m.madera_id,
		r.relleno_id,
		t.tela_id
	FROM gd_esquema.Maestra gt
	JOIN gd_esquema.Maestra gm
		ON gt.sillon_codigo = gm.sillon_codigo
		AND gt.Sillon_Modelo_Codigo = gm.Sillon_Modelo_Codigo
		AND gt.Tela_Color IS NOT NULL
		AND gm.Tela_Color IS NULL
		AND gm.Madera_Color IS NOT NULL
		AND gt.Sillon_Codigo IS NOT NULL
		AND gt.Sillon_Modelo_Codigo IS NOT NULL
	JOIN gd_esquema.Maestra gr
		ON gr.Relleno_Densidad IS NOT NULL
		AND gr.sillon_codigo = gm.sillon_codigo
		AND gr.Sillon_Modelo_Codigo = gm.Sillon_Modelo_Codigo
	JOIN MAND.TELA t
		ON t.tela_color = gt.Tela_Color
		AND t.tela_teaxtura = gt.Tela_Textura
	JOIN MAND.MADERA m
		ON m.madera_color = gm.Madera_Color
		AND m.madera_dureza = gm.Madera_Dureza
	JOIN MAND.RELLENO r
		ON r.relleno_densidad = gr.Relleno_Densidad



	SELECT DISTINCT 
		gt.Tela_Color,
		gt.Tela_Textura,
		t.tela_id,
		t.tela_color,
		t.tela_teaxtura,
		gm.Madera_Dureza,
		gm.Madera_Color,
		m.madera_id,
		m.madera_color,
		m.madera_dureza,
		gr.Relleno_Densidad,
		r.relleno_id,
		r.relleno_densidad
	FROM gd_esquema.Maestra gt
	JOIN gd_esquema.Maestra gm
		ON gt.sillon_codigo = gm.sillon_codigo
		AND gt.Sillon_Modelo_Codigo = gm.Sillon_Modelo_Codigo
		AND gt.Tela_Color IS NOT NULL
		AND gm.Tela_Color IS NULL
		AND gm.Madera_Color IS NOT NULL
		AND gt.Sillon_Codigo IS NOT NULL
		AND gt.Sillon_Modelo_Codigo IS NOT NULL
	JOIN gd_esquema.Maestra gr
		ON gr.Relleno_Densidad IS NOT NULL
		AND gr.sillon_codigo = gm.sillon_codigo
		AND gr.Sillon_Modelo_Codigo = gm.Sillon_Modelo_Codigo
	JOIN MAND.TELA t
		ON t.tela_color = gt.Tela_Color
		AND t.tela_teaxtura = gt.Tela_Textura
	JOIN MAND.MADERA m
		ON m.madera_color = gm.Madera_Color
		AND m.madera_dureza = gm.Madera_Dureza
	JOIN MAND.RELLENO r
		ON r.relleno_densidad = gr.Relleno_Densidad

	SELECT DISTINCT g.Sillon_Codigo, tm.tipo_material_codigo
	FROM gd_esquema.Maestra g
	JOIN MAND.TIPO_MATERIAL tm
	ON tm.tipo_material_descripcion = g.Material_Descripcion
	WHERE g.Material_Descripcion IS NOT NULL
		AND g.Sillon_Codigo IS NOT NULL
	ORDER BY 1

	SELECT * FROM MAND.MADERA m
	JOIN MAND.TIPO_MATERIAL t
	ON m.madera_tipo_material_id = t.tipo_material_codigo