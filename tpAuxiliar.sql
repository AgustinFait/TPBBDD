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
	prov_codigo BIGINT IDENTITY(1,1) PRIMARY KEY,
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


-- FACTURAS
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


-- MATERIALES 

/*CREATE TABLE MAND.MATERIAL_DETALLE(
    material_codigo	bigint IDENTITY(1,1) PRIMARY KEY,
    material_precio	decimal(38,2),
    material_descripcion nvarchar(255)
)

CREATE TABLE MAND.COMPRA_DETALLE (
	compra_det_cod bigint IDENTITY(1,1) PRIMARY KEY,
	compra_det_compra decimal(18,0), -- FK compra
	compra_det_material	bigint, -- FK material detalle
	compra_det_precio_unit decimal(18,2),
	compra_det_cant	decimal(18,0)
)*/

CREATE TABLE MAND.MATERIAL_SILLON (
      material_sillon_id bigint IDENTITY(1,1) PRIMARY KEY,
      material_sillon_sillon bigint, -- FK SILLON
      material_sillon_tipo bigint, --FK TIPO_MATERIAL
      material_sillon_precio decimal(38,2)
)

CREATE TABLE MAND.TIPO_MATERIAL (
    tipo_material_codigo bigint IDENTITY(1,1) PRIMARY KEY,
    tipo_material_nombre nvarchar(255),
    --tipo_material_descripcion nvarchar(255),
    tipo_material_tipo nvarchar(255)
)


CREATE TABLE MAND.MADERA (	
    madera_id bigint IDENTITY(1,1) PRIMARY KEY,
    madera_dureza nvarchar(255),
    madera_color nvarchar(255),
    material_id	bigint, -- FK TIPO_MATERIAL
)

CREATE TABLE MAND.TELA (	
    tela_id bigint IDENTITY(1,1) PRIMARY KEY,
    tela_teaxtura nvarchar(255),
    tela_color nvarchar(255),
    material	bigint, -- FK TIPO_MATERIAL
)

CREATE TABLE MAND.RELLENO (	
    relleno_id bigint IDENTITY(1,1) PRIMARY KEY,
    relleno_densidad decimal(38,2),
    material	bigint, -- FK MATERIAL_DETALLE
)



-- SILLONES 

/*CREATE TABLE MAND.SILLON_COMPOSICION (
    sillon_comp_codigo bigint IDENTITY(1,1) PRIMARY KEY,
    sillon_comp_tela bigint, --FK TELA
    sillon_comp_madera	bigint, --FK MADERA
    sillon_comp_elleno	bigint --FK RELLENO
)*/

CREATE TABLE MAND.SILLON(
    sillon_codigo	bigint PRIMARY KEY,
    sillon__modelo bigint, --FK MODELO
    sillon_MEDIDA	bigint, --FK MEDIDA
    sillon_composicion	bigint --FK COMPOSICION
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
    pedido_det_precio	decimal(18,0),		
    pedido_det_cantidad	bigInt,
    pedido_id decimal(18,0) --FK PEDIDO
) 

--CLAVES FORANEAS


/*ALTER TABLE MAND.Localidad
ADD CONSTRAINT FK_localidadProvincia
FOREIGN KEY (loc_provincia) REFERENCES MAND.Provincia(prov_codigo);*/


--Procedimientos


GO
	CREATE PROCEDURE MAND.migracion_proveedor
	AS
	BEGIN
		INSERT INTO MAND.PROVEEDOR
		select Proveedor_RazonSocial,Proveedor_Cuit,  Proveedor_Direccion, Proveedor_Telefono,Proveedor_Mail
		from gd_esquema.Maestra
		where Proveedor_Cuit is not null
		group by Proveedor_RazonSocial,Proveedor_Cuit,  Proveedor_Direccion, Proveedor_Telefono,Proveedor_Mail
    END
GO

GO
CREATE PROCEDURE MAND.migracion_compra
AS
    BEGIN
        INSERT INTO MAND.COMPRA
        select Compra_Numero, Sucursal_NroSucursal, prov_codigo ,Compra_Fecha,Compra_Total
        from gd_esquema.Maestra join MAND.Proveedor on Proveedor_Cuit = Proveedor.prov_cuit
        where Compra_Numero is not null
        group by Compra_Numero, Compra_Fecha, Compra_Total, Sucursal_NroSucursal
    END
GO


GO
CREATE PROCEDURE MAND.migracion_cliente as
BEGIN 

INSERT INTO MAND.CLIENTE
      SELECT M.Cliente_Dni,
	         M.Cliente_Nombre,
			 M.Cliente_Apellido,
			 M.Cliente_Mail,
			 D.dir_codigo,
			 M.Cliente_Telefono,
			 M.Cliente_FechaNacimiento
	  FROM gd_esquema.Maestra M 
	       JOIN MAND.DIRECCION D ON M.Cliente_Direccion=D.dir_nombre
	  GROUP BY M.Cliente_Dni,
	         M.Cliente_Nombre,
			 M.Cliente_Apellido,
			 M.Cliente_Mail,
			 D.dir_codigo,
			 M.Cliente_Telefono,
			 M.Cliente_FechaNacimiento
END
GO

GO
CREATE PROCEDURE MAND.migracion_factura AS
BEGIN 
     
     INSERT INTO MAND.FACTURA 
     SELECT M.Factura_Numero,
	        M.Cliente_Dni,
			M.Sucursal_NroSucursal,
			M.Factura_Fecha,
			M.Factura_Total
	 FROM gd_esquema.Maestra M
     WHERE M.Factura_Fecha is not null and
	       M.Factura_Numero is not null and
		   M.Factura_Total is not null 
	 GROUP BY M.Factura_Fecha,M.Factura_Numero, M.Factura_Total,M.Cliente_Dni,M.Sucursal_NroSucursal
END
GO

GO
CREATE PROCEDURE MAND.migracion_envio AS
BEGIN 
INSERT INTO MAND.ENVIO
SELECT M.Envio_Numero,
       M.Factura_Numero,
	   M.Envio_Fecha_Programada,
	   M.Envio_Fecha,
	   M.Envio_ImporteTraslado,
	   M.Envio_importeSubida
FROM gd_esquema.Maestra M
GROUP BY M.Envio_Numero,
       M.Factura_Numero,
	   M.Envio_Fecha_Programada,
	   M.Envio_Fecha,
	   M.Envio_ImporteTraslado,
	   M.Envio_importeSubida
HAVING M.Envio_Numero is not null and
       M.Factura_Numero is not null and
	   M.Envio_Fecha_Programada is not null and
	   M.Envio_Fecha is not null and
	   M.Envio_ImporteTraslado is not null and
	   M.Envio_importeSubida is not null 

END
GO


/*GO
	CREATE PROCEDURE MAND.migracion_material_detalle
	AS
	BEGIN
		INSERT INTO	MAND.MATERIAL_DETALLE
		select Material_Precio, Material_Descripcion
		from gd_esquema.Maestra
		where Compra_Numero is not null
	END
GO*/

GO
	CREATE PROCEDURE MAND.migracion_compra_detalle
	AS
	BEGIN
		INSERT INTO	MAND.COMPRA_DETALLE
		select compra_numero, material_nombre, Detalle_Compra_SubTotal/Detalle_Compra_Cantidad, Detalle_Compra_Cantidad
		from gd_esquema.Maestra AS M join MAND.COMPRA AS com on M.Compra_Numero = com.compra_numero join MAND.MATERIAL_DETALLE on M.Material_Descripcion = MAND.MATERIAL_DETALLE.material_descripcion
		where Compra_Numero is not null
		group by compra_numero,material_nombre, Detalle_Compra_SubTotal/Detalle_Compra_Cantidad, Detalle_Compra_Cantidad
	END
GO

GO
CREATE PROCEDURE MAND.migracion_tipo_material
	AS
	BEGIN
		INSERT INTO	MAND.TIPO_MATERIAL(tipo_material_nombre,tipo_material_tipo)
		SELECT M.Material_nombre,M.material_tipo FROM gd_esquema.Maestra M
        GROUP BY M.Material_nombre,M.material_tipo
        HAVING tipo_material_nombre IS NOT NULL AND 
               tipo_material_tipo IS NOT NULL

	END
GO

GO
CREATE PROCEDURE MAND.migracion_material_sillon
	AS
	BEGIN
		INSERT INTO	MAND.MATERIAL_SILLON(material_sillon_sillon,material_sillon_tipo, material_sillon_precio)
	    SELECT S.sillon_codigo,TM.tipo_material_codigo,M.Material_Precio FROM gd_esquema.Maestra M
                 join MAND.SILLON S ON S.sillon_codigo=M.Sillon_Codigo
				 JOIN MAND.TIPO_MATERIAL TM ON TM.tipo_material_nombre=M.Material_Nombre AND 
				                               TM.tipo_material_tipo=M.Material_Tipo
		GROUP BY S.sillon_codigo,TM.tipo_material_codigo,M.Material_Precio
	END

GO

GO
	CREATE PROCEDURE MAND.migracion_madera
	AS
	BEGIN
		INSERT INTO	MAND.MADERA
		select M.Madera_Dureza,M.Madera_Color, TM.tipo_material_codigo
		from gd_esquema.Maestra AS M join MAND.TIPO_MATERIAL TM on M.Material_nombre = TM.tipo_material_nombre AND TM.tipo_material_tipo='Madera'
		where M.Material_Descripcion is not null
		group by M.Madera_Dureza,M.Madera_Color,TM.tipo_material_codigo
	END
GO

GO
	CREATE PROCEDURE MAND.migracion_tela
	AS
	BEGIN
		INSERT INTO	MAND.MADERA
		select M.Tela_Textura,M.Tela_Color, M.material_codigo
		from gd_esquema.Maestra AS M join MAND.TIPO_MATERIAL TM on M.Material_nombre = TM.tipo_material_nombre AND TM.tipo_material_tipo='Tela'
		where M.Compra_Numero is not null 
		group by M.Tela_Textura,M.Tela_Color,TM.tipo_material_codigo
	END
GO

GO
	CREATE PROCEDURE MAND.migracion_relleno
	AS
	BEGIN
		INSERT INTO	MAND.MADERA
		select M.Relleno_Densidad, TM.tipo_material_codigo
		from gd_esquema.Maestra AS M join MAND.TIPO_MATERIAL TM on M.Material_nombre = TM.tipo_material_nombre AND TM.tipo_material_tipo='Relleno'
		where M.Compra_Numero is not null 
		group by M.Relleno_Densidad,TM.tipo_material_codigo
	END

/*GO
CREATE PROCEDURE MAND.migracion_sillon_composicion AS
BEGIN 

insert into MAND.SILLON_COMPOSICIÓN (sillon_comp_tela,sillon_comp_madera,sillon_comp_elleno)
SELECT T.tela_id,
       Ma.madera_id,
	   r.relleno_id
FROM gd_esquema.Maestra M
         JOIN MAND.TELA T on T.tela_color=M.Tela_Color AND T.tela_teaxtura=M.Tela_Textura
		 JOIN MAND.RELLENO R ON R.relleno_densidad=M.Relleno_Densidad
		 JOIN MAND.MADERA Ma on Ma.madera_dureza=m.Madera_Dureza and Ma.madera_color=M.Madera_Color
GROUP BY T.tela_id,
       Ma.madera_id,
	   r.relleno_id
*/

END
GO
CREATE PROCEDURE MAND.migracion_modelo
AS
BEGIN

INSERT INTO MAND.MODELO 
   select m.Sillon_modelo_Codigo,
          m.sillon_modelo,
		  m.Sillon_Modelo_Descripcion
   from gd_esquema.Maestra m
   group by m.Sillon_Modelo_Codigo,
          m.sillon_modelo,
		  m.Sillon_Modelo_Descripcion
   HAVING m.Sillon_Modelo_Codigo IS NOT NULL AND
          m.sillon_modelo IS NOT NULL AND
		  m.Sillon_Modelo_Descripcion IS NOT NULL 
    
END
GO
CREATE PROCEDURE MAND.migracion_medidas
AS
BEGIN

INSERT INTO MAND.MEDIDA (medidas_altura,medidas_anchura,medidas_profundidad,medidas_precio)
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
