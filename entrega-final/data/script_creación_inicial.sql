USE [GD1C2025]
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'MAND')
BEGIN 
	EXEC ('CREATE SCHEMA MAND')
END
GO

-- ============================================================ DROP ESTRUCTURAS EXISTENTES ============================================================

-- ------------------------------------------------------------------ DROP PROCEDURES ------------------------------------------------------------------

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
    DROP PROCEDURE IF EXISTS MAND.MIGRACION_MATERIAL;
    DROP PROCEDURE IF EXISTS MAND.MIGRACION_MADERA_CARACTERISTICA;
    DROP PROCEDURE IF EXISTS MAND.MIGRACION_TELA_CARACTERISTICA;
    DROP PROCEDURE IF EXISTS MAND.MIGRACION_RELLENO_CARACTERISTICA;
    DROP PROCEDURE IF EXISTS MAND.migracion_modelo;
    DROP PROCEDURE IF EXISTS MAND.migracion_medidas;
	DROP PROCEDURE IF EXISTS MAND.MIGRACION_SILLON_MATERIAL;
	DROP PROCEDURE IF EXISTS MAND.MIGRACION_SILLON_DETALLE;
	DROP PROCEDURE IF EXISTS MAND.MIGRACION_SILLON;
    DROP PROCEDURE IF EXISTS MAND.migrar_estado;
    DROP PROCEDURE IF EXISTS MAND.migrar_compra_detalle;
	DROP PROCEDURE IF EXISTS MAND.migracion_pedido;
	DROP PROCEDURE IF EXISTS MAND.migracion_detalle_pedido;
	DROP PROCEDURE IF EXISTS MAND.migracion_cancelacion_pedido;
    DROP PROCEDURE IF EXISTS MAND.ejecutarMigracion;

END;
GO

EXEC MAND.BORRAR_PROCEDURES_MIGRACION;
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
	DROP TABLE IF EXISTS MAND.SILLON_MATERIAL;
	DROP TABLE IF EXISTS MAND.SILLON;
	DROP TABLE IF EXISTS MAND.MEDIDA;
	DROP TABLE IF EXISTS MAND.MODELO;
	DROP TABLE IF EXISTS MAND.RELLENO_CARACTERISTICA;
	DROP TABLE IF EXISTS MAND.TELA_CARACTERISTICA;
	DROP TABLE IF EXISTS MAND.MADERA_CARACTERISTICA;
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

EXEC MAND.LIMPIAR_TABLAS;
GO

-- ======================================================= TABLAS =================================================================

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
	compra_total decimal(18,2)
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
    tipo_material_detalle nvarchar(255),
)

CREATE TABLE MAND.MATERIAL (
    material_id bigint IDENTITY(1,1) PRIMARY KEY,
	material_nombre	nvarchar(255),
	material_descripcion nvarchar(255),
	material_tipo bigint, --FK TIPO MATERIAL
    material_precio decimal(38,2)
)

CREATE TABLE MAND.MADERA_CARACTERISTICA (	
    madera_id bigint IDENTITY(1,1) PRIMARY KEY,
	madera_material_id bigint, --FK MATERIAL
    madera_dureza nvarchar(255),
    madera_color nvarchar(255)
)

CREATE TABLE MAND.TELA_CARACTERISTICA (	
    tela_id bigint IDENTITY(1,1) PRIMARY KEY,
	tela_material_id bigint, --FK MATERIAL
    tela_textura nvarchar(255),
    tela_color nvarchar(255)
)

CREATE TABLE MAND.RELLENO_CARACTERISTICA (	
    relleno_id bigint IDENTITY(1,1) PRIMARY KEY,
	relleno_material_id bigint, --FK MATERIAL
    relleno_densidad decimal(38,2)
)

CREATE TABLE MAND.MODELO (	
    modelo_codigo bigint PRIMARY KEY,
    modelo_nombre nvarchar(255),
    modelo_descripcion	nvarchar(255),
	modelo_precio decimal(18,2)
)

CREATE TABLE MAND.MEDIDA (
   medidas_codigo bigint IDENTITY(1,1) PRIMARY KEY,
   medidas_altura decimal(18,2),		
   medidas_anchura	decimal(18,2),
   medidas_profundidad	decimal(18,2),
   medidas_precio decimal(18,2)
)

CREATE TABLE MAND.SILLON(
    sillon_codigo	bigint PRIMARY KEY,
    sillon_modelo bigint, --FK MODELO
    sillon_medida	bigint --FK MEDIDA
)

CREATE TABLE MAND.SILLON_MATERIAL (
    sillon_mat_codigo bigint IDENTITY(1,1) PRIMARY KEY,
	sillon_mat_sillon bigint, --FK SILLON
	sillon_mat_material bigint --FK MATERIAL
)

CREATE TABLE MAND.COMPRA_DETALLE (
	compra_det_cod bigint IDENTITY(1,1) PRIMARY KEY,
	compra_det_compra decimal(18,0), -- FK compra
	compra_det_material	bigint, -- FK MATERIAL
	compra_det_precio_unit decimal(18,2),
	compra_det_cant	decimal(18,0),
    compra_det_subtotal decimal(18,2)
)

-- ARREGLAR
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
    pedido_total decimal(18,2)
)

CREATE TABLE MAND.CANCELACION_PEDIDO(
    canc_ped_codigo	bigint IDENTITY(1,1) PRIMARY KEY,
    canc_ped_pedido	decimal(18,0), --FK PEDIDO
    canc_ped_motivo	nvarchar(255),
    canc_ped_fecha	datetime2(6)
)

CREATE TABLE MAND.DETALLE_PEDIDO(
    detalle_pedido_id bigint IDENTITY(1,1) PRIMARY KEY,
    sillon_id	bigint, --FK SILLON
    pedido_det_precio	decimal(18,2),		
    pedido_det_cantidad	bigInt,
    pedido_id decimal(18,0), --FK PEDIDO
    pedido_det_subtotal decimal(18,2)
) 

CREATE TABLE MAND.DETALLE_FACTURA(
    detalle_factura_id	bigint IDENTITY(1,1) PRIMARY KEY,
    detalle_factura_factura	bigint, --FK factura	
    detalle_factura_detalle_pedido bigint, --FK pedido
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

ALTER TABLE MAND.TELA_CARACTERISTICA
ADD CONSTRAINT FK_material
FOREIGN KEY (tela_material_id) REFERENCES MAND.MATERIAL(material_id)

ALTER TABLE MAND.MADERA_CARACTERISTICA
ADD CONSTRAINT FK_maderaTipoMaterial
FOREIGN KEY (madera_material_id) REFERENCES MAND.MATERIAL(material_id)

ALTER TABLE MAND.RELLENO_CARACTERISTICA
ADD CONSTRAINT FK_rellenoTipoMaterial
FOREIGN KEY (relleno_material_id) REFERENCES MAND.MATERIAL(material_id)

ALTER TABLE MAND.MATERIAL
ADD CONSTRAINT FK_materialTipoMaterial
FOREIGN KEY (material_tipo) REFERENCES MAND.TIPO_MATERIAL(tipo_material_codigo)

ALTER TABLE MAND.SILLON
ADD CONSTRAINT FK_sillonModelo
FOREIGN KEY (sillon_modelo) REFERENCES MAND.MODELO (modelo_codigo)

ALTER TABLE MAND.SILLON
ADD CONSTRAINT FK_sillonMedida
FOREIGN KEY (sillon_medida) REFERENCES MAND.MEDIDA (medidas_codigo)

ALTER TABLE MAND.SILLON_MATERIAL
ADD CONSTRAINT FK_SILLON_MAT_MATERIAL
FOREIGN KEY (sillon_mat_material) REFERENCES MAND.MATERIAL (material_id)

ALTER TABLE MAND.SILLON_MATERIAL
ADD CONSTRAINT FK_SILLON_MAT_SILLON
FOREIGN KEY (sillon_mat_sillon) REFERENCES MAND.SILLON(sillon_codigo)

ALTER TABLE MAND.COMPRA_DETALLE
ADD CONSTRAINT FK_compraDetalleCompra
FOREIGN KEY (compra_det_compra) REFERENCES MAND.COMPRA(compra_numero)

ALTER TABLE MAND.COMPRA_DETALLE
ADD CONSTRAINT FK_compraDetalleDetalleMaterial
FOREIGN KEY (compra_det_material) REFERENCES MAND.MATERIAL (material_id)

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
FOREIGN KEY (detalle_factura_detalle_pedido) REFERENCES MAND.DETALLE_PEDIDO (detalle_pedido_id)

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

GO
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
GO

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

GO
CREATE PROCEDURE MAND.MIGRACION_FACTURA_DETALLE
AS
BEGIN
    INSERT INTO MAND.DETALLE_FACTURA

    SELECT DISTINCT m.Factura_Numero, d.detalle_pedido_id, m.Detalle_Factura_Precio, m.Detalle_Factura_Cantidad, m.Detalle_Factura_SubTotal
    FROM gd_esquema.Maestra as m
	JOIN MAND.DETALLE_PEDIDO d
	ON  d.pedido_det_cantidad = m.Detalle_Pedido_Cantidad
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
CREATE PROCEDURE MAND.MIGRACION_TIPO_MATERIAL
	AS
	BEGIN
		INSERT INTO	MAND.TIPO_MATERIAL
		SELECT DISTINCT 
			 M.Material_Tipo
		FROM gd_esquema.Maestra M
		WHERE M.Material_Tipo is not null 
		
	END
go

-- ======================================================= SP MATERIAL =================================================================

go
create PROCEDURE MAND.MIGRACION_MATERIAL
	AS
	BEGIN
		INSERT INTO	MAND.MATERIAL
		SELECT DISTINCT 
			g.Material_Nombre,
			g.Material_Descripcion,
			tm.tipo_material_codigo,
			g.Material_Precio
		FROM gd_esquema.Maestra g
		JOIN MAND.TIPO_MATERIAL tm
			ON tm.tipo_material_detalle = g.Material_Tipo
		WHERE g.Material_Descripcion IS NOT NULL
	END
go

-- ======================================================= SP MADERA =================================================================

GO
CREATE PROCEDURE MAND.MIGRACION_MADERA_CARACTERISTICA
	AS
	BEGIN
		INSERT INTO	MAND.MADERA_CARACTERISTICA
		
		SELECT DISTINCT
			m.material_id,
			g.Madera_Dureza,
			g.Madera_Color
		FROM gd_esquema.Maestra g
		JOIN MAND.MATERIAL m
			ON m.material_descripcion = g.Material_Descripcion
		WHERE g.Madera_Color IS NOT NULL
			AND g.Madera_Dureza IS NOT NULL
	END
GO

-- ======================================================= SP TELA =================================================================

GO
CREATE PROCEDURE MAND.MIGRACION_TELA_CARACTERISTICA
	AS
	BEGIN
		INSERT INTO	MAND.TELA_CARACTERISTICA
		 SELECT DISTINCT
		 	m.material_id,
			g.Tela_Textura,
		 	g.tela_color
		FROM gd_esquema.Maestra g
		JOIN MAND.MATERIAL m
			ON m.material_descripcion = g.Material_Descripcion
		where g.Tela_Textura is not null and g.tela_color is not null		
	END
GO

-- ======================================================= SP RELLENO =================================================================

GO
CREATE PROCEDURE MAND.MIGRACION_RELLENO_CARACTERISTICA
	AS
	BEGIN
		INSERT INTO	MAND.RELLENO_CARACTERISTICA

		SELECT DISTINCT
			m.material_id,
		    g.Relleno_Densidad
		 FROM gd_esquema.Maestra g
		 JOIN MAND.MATERIAL m
		 	ON m.material_descripcion = g.Material_Descripcion
		WHERE g.Relleno_Densidad IS NOT NULL

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

-- ======================================================= SP SILLON MATERIAL =================================================================

GO
CREATE PROCEDURE MAND.MIGRACION_SILLON_MATERIAL
AS
BEGIN
	
	INSERT INTO MAND.SILLON_MATERIAL

	SELECT DISTINCT 
		g.Sillon_Codigo,
		m.material_id
	FROM gd_esquema.Maestra g
	JOIN MAND.MATERIAL m
		ON g.Material_Descripcion = m.material_descripcion
	WHERE g.Sillon_Codigo IS NOT NULL
END
GO

-- ======================================================= SP SILLON =================================================================

GO
CREATE PROCEDURE MAND.MIGRACION_SILLON
AS
BEGIN

	INSERT INTO MAND.SILLON 

    SELECT DISTINCT 
		g.Sillon_Codigo, 
		g.Sillon_Modelo_Codigo,
		med.medidas_codigo
	FROM gd_esquema.Maestra g
	JOIN MAND.MEDIDA med
		ON g.Sillon_Medida_Ancho = med.medidas_anchura
	   	AND g.Sillon_Medida_Profundidad = med.medidas_profundidad
		AND g.Sillon_Medida_Precio = med.medidas_precio
		AND g.Sillon_Medida_Alto = med.medidas_altura
	WHERE 
		g.Sillon_Medida_Alto IS NOT NULL
		AND g.Sillon_Modelo_Codigo IS NOT NULL
		AND g.Tela_Color IS NOT NULL

END
GO

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
	g.Compra_Numero,
	m.material_id,
	g.Detalle_Compra_Precio,
	g.Detalle_Compra_Cantidad,
	g.Detalle_Compra_SubTotal
  FROM gd_esquema.Maestra g
  JOIN MAND.MATERIAL m
  	ON m.material_descripcion = g.Material_Descripcion
  WHERE g.Detalle_Compra_Cantidad IS NOT NULL
END
GO

-- ======================================================= SP PEDIDO =================================================================

GO
CREATE PROCEDURE MAND.migracion_pedido
AS
BEGIN
    INSERT INTO MAND.PEDIDO
    select distinct
		M.Pedido_Numero,		-- pedido_nro
		M.Cliente_Dni,			-- pedido_cliente (FK)
		M.Sucursal_NroSucursal,	-- pedido_sucursal (FK)
		E.estado_codigo,		-- pedido_estado (FK) egwasg
		M.Pedido_Fecha,			-- pedido_fecha_hora
		M.Pedido_Total			-- pedido_total
	from gd_esquema.Maestra M
	join MAND.ESTADO E on M.Pedido_Estado = E.estado_tipo
	where Pedido_Numero is not null
END
GO

-- ======================================================= SP DETALLE PEDIDO =================================================================

GO
CREATE PROCEDURE MAND.migracion_detalle_pedido
AS
BEGIN
    INSERT INTO MAND.DETALLE_PEDIDO
    select distinct
		s.sillon_codigo,			-- sillon_id (FK)
		M.Detalle_Pedido_Precio,	-- pedido_det_precio
		M.Detalle_Pedido_Cantidad,	-- pedido_det_cantidad
		M.Pedido_Numero,			-- pedido_id (FK)
		M.Detalle_Pedido_SubTotal	-- pedido_det_subtotal
	from gd_esquema.Maestra M
	join MAND.PEDIDO p on M.Pedido_Numero = p.pedido_nro
	join MAND.SILLON s on M.Sillon_Codigo = s.sillon_codigo
	where Pedido_Numero is not null
END
GO

-- ======================================================= SP CANCELACION PEDIDO =================================================================

GO
CREATE PROCEDURE MAND.migracion_cancelacion_pedido
AS
BEGIN
	INSERT INTO MAND.CANCELACION_PEDIDO
	select distinct
		p.pedido_nro,					-- canc_ped_pedido
		M.Pedido_Cancelacion_Motivo,	-- canc_ped_motivo
		M.Pedido_Cancelacion_Fecha		-- canc_ped_fecha
	from gd_esquema.Maestra M
	join MAND.PEDIDO p on M.Pedido_Numero = p.pedido_nro
	where Pedido_Cancelacion_Motivo is not null
		and Pedido_Cancelacion_Fecha is not null
END
GO

-- ======================================================= SP MIGRACION =================================================================

go
CREATE PROCEDURE MAND.ejecutarMigracion 
as 
BEGIN
	PRINT 'INICIO DE LA MIGRACION...';
	PRINT '=================================';
	PRINT 'PROVINCIA';
	EXEC MAND.MIGRAR_PROVINCIA;
	PRINT '=================================';
	PRINT 'LOCALIDAD';
	EXEC MAND.MIGRAR_LOCALIDAD;
	PRINT '=================================';
	PRINT 'DIRECCION';
	EXEC MAND.MIGRAR_DIRECCION;
	PRINT '=================================';
	PRINT 'SUCURSALES';
	EXEC MAND.MIGRAR_SUCURSALES;
	PRINT '=================================';
	PRINT 'PROVEEDOR';
	EXEC MAND.migracion_proveedor;
	PRINT '=================================';
	PRINT 'COMPRA';
	EXEC MAND.migracion_compra;
	PRINT '=================================';
	PRINT 'CLIENTE';
	EXEC MAND.migracion_cliente;
	PRINT '=================================';
	PRINT 'FACTURA';
	EXEC MAND.migracion_factura;
	PRINT '=================================';
	PRINT 'TIPO MATERIAL';
	EXEC MAND.migracion_tipo_material;
	PRINT '=================================';
	PRINT 'MATERIAL';
	EXEC MAND.migracion_material;
	PRINT '=================================';
	PRINT 'MADERA CARACTERISTICA';
	EXEC MAND.MIGRACION_MADERA_CARACTERISTICA;
	PRINT '=================================';
	PRINT 'TELA CARACTERISTICA';
	EXEC MAND.MIGRACION_TELA_CARACTERISTICA;
	PRINT '=================================';
	PRINT 'RELLENO CARACTERISTICA';
	EXEC MAND.MIGRACION_RELLENO_CARACTERISTICA;
	PRINT '=================================';
	PRINT 'MODELO';
	EXEC MAND.migracion_modelo;
	PRINT '=================================';
	PRINT 'MEDIDA';
	EXEC MAND.migracion_medidas;
	PRINT '=================================';
	PRINT 'SILLON';
	EXEC MAND.MIGRACION_SILLON;
	PRINT '=================================';
	PRINT 'SILLON MATERIAL';
	EXEC MAND.MIGRACION_SILLON_MATERIAL;
	PRINT '=================================';
	PRINT 'COMPRA DETALLE';
	EXEC MAND.migrar_compra_detalle;
	PRINT '=================================';
	PRINT 'ESTADO';
	EXEC MAND.migrar_estado;
	PRINT '=================================';
	PRINT 'PEDIDO';
	EXEC MAND.migracion_pedido;
	PRINT '=================================';
	PRINT 'DETALLE PEDIDO';
	EXEC MAND.migracion_detalle_pedido;
	PRINT '=================================';
	PRINT 'CANCELACION PEDIDO';
	EXEC MAND.migracion_cancelacion_pedido;
	PRINT '=================================';
	PRINT 'FACTURA_DETALLE';
	EXEC MAND.MIGRACION_FACTURA_DETALLE;
	PRINT '=================================';
	PRINT 'FIN DE LA MIGRACION';
	PRINT '=================================';
END

go
exec  MAND.ejecutarMigracion
go

-- ======================================================= PRUEBAS =================================================================

