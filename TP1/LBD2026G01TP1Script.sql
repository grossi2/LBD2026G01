-- Año: 2026
-- Grupo: 01
-- Integrantes: Apás David, Vargas Herrera Gerónimo
-- Tema: Fabrica de plastico
-- Nombre del Esquema: LBD2026G01CIBERPLAS
-- Plataforma (SO + Versión): Windows 10
-- Motor y Versión: MySQL Server 5.x (Community Edition)
-- GitHub Repositorio: LBD2026G01
-- GitHub Usuarios: davidApas, gerovargash

-- =========================================================================================================
-- Generar BD
-- =========================================================================================================

DROP SCHEMA IF EXISTS LBD2026G01CIBERPLAS;

CREATE SCHEMA IF NOT EXISTS LBD2026G01CIBERPLAS;

USE LBD2026G01CIBERPLAS;

DROP TABLE IF EXISTS Clientes;
DROP TABLE IF EXISTS Depositos;
DROP TABLE IF EXISTS Existencias;
DROP TABLE IF EXISTS LineaDeMovimientos;
DROP TABLE IF EXISTS ListaPrecio;
DROP TABLE IF EXISTS MovimientoDeProductos;
DROP TABLE IF EXISTS Precios;
DROP TABLE IF EXISTS Productos;
DROP TABLE IF EXISTS Sucursales;
DROP TABLE IF EXISTS Usuarios;
-- 
-- TABLE: Clientes 
--

CREATE TABLE Clientes(
    IdCliente    INT             AUTO_INCREMENT,
    Cuit         CHAR(13) UNIQUE        NOT NULL, -- Controlamos que sea unico
    Apellidos    VARCHAR(50) CHECK (Apellidos REGEXP '^[A-ZÁÉÍÓÚÑ][a-zA-ZáéíóúñÁÉÍÓÚÑ ]+$'), -- Controlamos que Empiece con Mayuscula y no con un numero/simbolo
    Nombres      VARCHAR(30) CHECK (Nombres REGEXP '^[A-ZÁÉÍÓÚÑ][a-zA-ZáéíóúñÁÉÍÓÚÑ ]+$'), -- Controlamos que Empiece con Mayuscula y no con un numero/simbolo
    Correo       VARCHAR(60),
    Direccion    VARCHAR(100),
    Estado       CHAR(1) CHECK (Estado IN ('A','I'))         NOT NULL, -- Controlamos estado A= Activo o I=Inactivo
    PRIMARY KEY (IdCliente)
)ENGINE=INNODB
;



-- 
-- TABLE: Depositos 
--

CREATE TABLE Depositos(
    IdDeposito     INT             AUTO_INCREMENT,
    IdSucursal     INT             NOT NULL,
    Nombre         VARCHAR(30)     NOT NULL,
    Descripcion    VARCHAR(255),
    Estado         CHAR(1) CHECK (Estado IN ('A','I'))	NOT NULL, -- Controlamos estado A= Activo o I=Inactivo
    PRIMARY KEY (IdDeposito)
)ENGINE=INNODB
;



-- 
-- TABLE: Existencias 
--

CREATE TABLE Existencias(
    IdProducto    INT    NOT NULL,
    IdDeposito    INT    NOT NULL,
    Cantidad      INT    NOT NULL,
    PRIMARY KEY (IdProducto, IdDeposito)
)ENGINE=INNODB
;



-- 
-- TABLE: LineaDeMovimientos 
--

CREATE TABLE LineaDeMovimientos(
    IdMovimiento       INT               NOT NULL,
    IdProducto         INT               NOT NULL,
    CantidadOrigen     SMALLINT          NOT NULL,
    CantidadDestino    SMALLINT          NOT NULL,
    PrecioFinal        DECIMAL(12, 2) CHECK (PrecioFinal>0 or NULL), -- Controlamos que el precio sea mayor que cero
    PRIMARY KEY (IdMovimiento, IdProducto)
)ENGINE=INNODB
;



-- 
-- TABLE: ListaPrecio 
--

CREATE TABLE ListaPrecio(
    idListaPrecio    INT         AUTO_INCREMENT,
    Desde            DATETIME DEFAULT now()    NOT NULL, -- Default fecha actual
    PRIMARY KEY (idListaPrecio)
)ENGINE=INNODB
;



-- 
-- TABLE: MovimientoDeProductos 
--

CREATE TABLE MovimientoDeProductos(
    IdMovimiento         INT         AUTO_INCREMENT,
    IdCliente            INT		 NULL,
    IdDepositoOrigen     INT         NOT NULL,
    IdDepositoDestino    INT         NOT NULL,
    IdUsuario            INT         NOT NULL,
    FechaHora            DATETIME DEFAULT now()    NOT NULL, -- Default fecha actual
    Estado               CHAR(1) CHECK (Estado IN ('P','F'))     NOT NULL, -- Controlamos estado P= Pendiente o F=Finalizado
    PRIMARY KEY (IdMovimiento)
)ENGINE=INNODB
;



-- 
-- TABLE: Precios 
--

CREATE TABLE Precios(
    IdProducto       INT               NOT NULL,
    idListaPrecio    INT               NOT NULL,
    Precio           DECIMAL(12, 2) CHECK (Precio>0)    NOT NULL, -- Controlamos que el precio sea mayor que cero
    PRIMARY KEY (IdProducto, idListaPrecio)
)ENGINE=INNODB
;



-- 
-- TABLE: Productos 
--

CREATE TABLE Productos(
    IdProducto            INT             AUTO_INCREMENT,
    Nombre                VARCHAR(30)     NOT NULL,
    DescripcionGeneral    VARCHAR(255),
    Material              VARCHAR(30)     NOT NULL,
    Color                 VARCHAR(30)     NOT NULL,
    Capacidad             VARCHAR(30),
    Peso                  VARCHAR(30)     NOT NULL,
    UnidadesPorPaquete    SMALLINT CHECK (UnidadesPorPaquete>0), -- Controlamos cantidad mayor que cero
    Estado                CHAR(1) CHECK (Estado IN ('A','I'))	NOT NULL, -- Controlamos estado A= Activo o I=Inactivo ,
    PRIMARY KEY (IdProducto)
)ENGINE=INNODB
;



-- 
-- TABLE: Sucursales 
--

CREATE TABLE Sucursales(
    IdSucursal     INT             AUTO_INCREMENT,
    Direccion      VARCHAR(100)    NOT NULL,
    Descripcion    VARCHAR(255),
    Estado         CHAR(1) CHECK (Estado IN ('A','I'))	NOT NULL, -- Controlamos estado A= Activo o I=Inactivo         ,
    PRIMARY KEY (IdSucursal)
)ENGINE=INNODB
;



-- 
-- TABLE: Usuarios 
--

CREATE TABLE Usuarios(
    IdUsuario      INT            AUTO_INCREMENT,
    Documento      INT            NOT NULL,
    Apellidos      VARCHAR(40) CHECK (Apellidos REGEXP '^[A-ZÁÉÍÓÚÑ][a-záéíóúñ]+$'), -- Controlamos que Empiece con Mayuscula y no con un numero/simbolo    NOT NULL,
    Nombres        VARCHAR(30) CHECK (Nombres REGEXP '^[A-ZÁÉÍÓÚÑ][a-záéíóúñ]+$'), -- Controlamos que Empiece con Mayuscula y no con un numero/simbolo    NOT NULL,
    Contrasenia    VARCHAR(30)    NOT NULL,
    Rol            VARCHAR(30)    NOT NULL,
    Estado         CHAR(1) CHECK (Estado IN ('A','I'))         NOT NULL,	 -- Controlamos estado A= Activo o I=Inactivo 
    PRIMARY KEY (IdUsuario)
)ENGINE=INNODB
;



-- 
-- INDEX: UI_Cuit 
--

CREATE UNIQUE INDEX UI_Cuit ON Clientes(Cuit)
;
-- 
-- INDEX: Ref18 
--

CREATE INDEX Ref18 ON Depositos(IdSucursal)
;
-- 
-- INDEX: Ref55 
--

CREATE INDEX Ref55 ON Existencias(IdProducto)
;
-- 
-- INDEX: Ref26 
--

CREATE INDEX Ref26 ON Existencias(IdDeposito)
;
-- 
-- INDEX: Ref33 
--

CREATE INDEX Ref33 ON LineaDeMovimientos(IdMovimiento)
;
-- 
-- INDEX: Ref54 
--

CREATE INDEX Ref54 ON LineaDeMovimientos(IdProducto)
;
-- 
-- INDEX: I_Ventas 
--

CREATE INDEX I_Ventas ON MovimientoDeProductos(IdDepositoOrigen)
;
-- 
-- INDEX: I_Entradas 
--

CREATE INDEX I_Entradas ON MovimientoDeProductos(IdDepositoDestino)
;
-- 
-- INDEX: I_Movimientos 
--

CREATE INDEX I_Movimientos ON MovimientoDeProductos(IdDepositoOrigen, IdDepositoDestino)
;
-- 
-- INDEX: I_Fechas 
--

CREATE INDEX I_Fechas ON MovimientoDeProductos(FechaHora)
;
-- 
-- INDEX: Ref67 
--

CREATE INDEX Ref67 ON MovimientoDeProductos(IdUsuario)
;
-- 
-- INDEX: Ref911 
--

CREATE INDEX Ref911 ON MovimientoDeProductos(IdCliente)
;
-- 
-- INDEX: Ref213 
--

CREATE INDEX Ref213 ON MovimientoDeProductos(IdDepositoOrigen)
;
-- 
-- INDEX: Ref215 
--

CREATE INDEX Ref215 ON MovimientoDeProductos(IdDepositoDestino)
;
-- 
-- INDEX: Ref1018 
--

CREATE INDEX Ref1018 ON Precios(idListaPrecio)
;
-- 
-- INDEX: Ref521 
--

CREATE INDEX Ref521 ON Precios(IdProducto)
;
-- 
-- TABLE: Depositos 
--

ALTER TABLE Depositos ADD CONSTRAINT RefSucursales8 
    FOREIGN KEY (IdSucursal)
    REFERENCES Sucursales(IdSucursal)
;


-- 
-- TABLE: Existencias 
--

ALTER TABLE Existencias ADD CONSTRAINT RefProductos5 
    FOREIGN KEY (IdProducto)
    REFERENCES Productos(IdProducto)
;

ALTER TABLE Existencias ADD CONSTRAINT RefDepositos6 
    FOREIGN KEY (IdDeposito)
    REFERENCES Depositos(IdDeposito)
;


-- 
-- TABLE: LineaDeMovimientos 
--

ALTER TABLE LineaDeMovimientos ADD CONSTRAINT RefMovimientoDeProductos3 
    FOREIGN KEY (IdMovimiento)
    REFERENCES MovimientoDeProductos(IdMovimiento)
;

ALTER TABLE LineaDeMovimientos ADD CONSTRAINT RefProductos4 
    FOREIGN KEY (IdProducto)
    REFERENCES Productos(IdProducto)
;


-- 
-- TABLE: MovimientoDeProductos 
--

ALTER TABLE MovimientoDeProductos ADD CONSTRAINT RefUsuarios7 
    FOREIGN KEY (IdUsuario)
    REFERENCES Usuarios(IdUsuario)
;

ALTER TABLE MovimientoDeProductos ADD CONSTRAINT RefClientes11 
    FOREIGN KEY (IdCliente)
    REFERENCES Clientes(IdCliente)
;

ALTER TABLE MovimientoDeProductos ADD CONSTRAINT RefDepositos13 
    FOREIGN KEY (IdDepositoOrigen)
    REFERENCES Depositos(IdDeposito)
;

ALTER TABLE MovimientoDeProductos ADD CONSTRAINT RefDepositos15 
    FOREIGN KEY (IdDepositoDestino)
    REFERENCES Depositos(IdDeposito)
;


-- 
-- TABLE: Precios 
--

ALTER TABLE Precios ADD CONSTRAINT RefListaPrecio18 
    FOREIGN KEY (idListaPrecio)
    REFERENCES ListaPrecio(idListaPrecio)
;

ALTER TABLE Precios ADD CONSTRAINT RefProductos21 
    FOREIGN KEY (IdProducto)
    REFERENCES Productos(IdProducto)
;


-- =========================================================================================================
-- Poblar tablas
-- =========================================================================================================

-- Tabla Usuarios
INSERT INTO Usuarios (Documento, Apellidos, Nombres, Contrasenia, Rol, Estado) VALUES
(12345678, 'Apas',    	 'David',     'TYSONKING', 'Dueño',                 'A'),
(12345678, 'Apas',    	 'Alberto',   'pass1234',  'Dueño',                 'A'),
(23456789, 'Martinez',   'Ana',       'mart5678',  'Encargado de Planta',   'A'),
(34567890, 'Lopez',      'Luis',      'lop9012',   'Vendedor',              'A'),
(11223344, 'Fernandez',  'Maria',     'fern3456',  'Encargado de Deposito', 'I'),
(22334455, 'Rodriguez',  'Jose',      'rod7890',   'Vendedor',              'A'),
(33445566, 'Sanchez',    'Laura',     'san1234',   'Encargado de Planta',   'A'),
(44556677, 'Perez',      'Ricardo',   'per5678',   'Vendedor',              'I'),
(10203040, 'Gomez',      'Patricia',  'gom9012',   'Encargado de Deposito', 'A'),
(20304050, 'Herrera',    'Miguel',    'her3456',   'Vendedor',              'A'),
(30405060, 'Jimenez',    'Claudia',   'jim7890',   'Encargado de Planta',   'I'),
(40506070, 'Morales',    'Diego',     'mor1234',   'Vendedor',              'A'),
(15253545, 'Vargas',     'Sofia',     'var5678',   'Encargado de Deposito', 'A'),
(25354555, 'Romero',     'Pablo',     'rom9012',   'Vendedor',              'A'),
(35455565, 'Torres',     'Natalia',   'tor3456',   'Encargado de Planta',   'I'),
(45556575, 'Diaz',       'Fernando',  'dia7890',   'Vendedor',              'A'),
(14243444, 'Ruiz',       'Valentina', 'rui1234',   'Encargado de Deposito', 'A'),
(24344454, 'Flores',     'Sebastian', 'flo5678',   'Vendedor',              'A'),
(38291011, 'Castro',     'Gabriela',  'cas9012',   'Encargado de Planta',   'I'),
(29381012, 'Mendoza',    'Andres',    'men3456',   'Vendedor',              'A'),
(39481013, 'Ramos',      'Carolina',  'ram7890',   'Encargado de Deposito', 'A');


-- Tabla Productos
INSERT INTO Productos (
    Nombre, 
    DescripcionGeneral, 
    Material, 
    Color, 
    Capacidad, 
    Peso, 
    UnidadesPorPaquete, 
    Estado
) VALUES
('Bandeja Cosechera', 'Bandeja ideal para recolección de frutas y verduras.', 'Reciclado', 'Varios', '20 L', '500 gr', 10, 'A'),
('Cajón Cosechero 45L', 'Cajón resistente para cosecha agrícola intensiva.', 'Reciclado', 'Negro', '45 L', '1.5 kg', 5, 'A'),
('Cajón Organizador 45L', 'Cajón para organización de herramientas e insumos.', 'Polietileno', 'Verde', '45 L', '1.5 kg', 5, 'A'),
('Embudo de Plástico', 'Embudo resistente para líquidos y productos sin derrames.', 'PEAD', 'Varios', NULL, '50 gr', 50, 'A'),
('Envase 1,08L PEAD APM', 'Envase con tapa precinto para productos químicos.', 'PEAD APM', 'Blanco', '1.08 L', '100 gr', 100, 'A'),
('Envase 10L PEAD', 'Bidón para agroquímicos y líquidos en general.', 'Polietileno', 'Natural', '10 L', '400 gr', 20, 'A'),
('Envase 10L Reciclado', 'Bidón ecológico para uso multipropósito.', 'Reciclado', 'Blanco', '10 L', '400 gr', 20, 'A'),
('Envase 5,08L PEAD APM', 'Envase con precinto apto para sellado por ultrasonido.', 'PEAD APM', 'Blanco', '5.08 L', '250 gr', 40, 'A'),
('Macetín 1,7L PEAD', 'Macetín para viveros, favorece el buen drenaje.', 'PEAD', 'Negro', '1.7 L', '80 gr', 100, 'A'),
('Macetín 5L PEAD', 'Macetín para plantas en desarrollo, alta resistencia.', 'PEAD', 'Varios', '5 L', '150 gr', 50, 'A'),
('Macetín Autopoda 5L', 'Diseño que promueve la autopoda radicular en viveros.', 'PEAD', 'Negro', '5 L', '160 gr', 50, 'A'),
('Manguera 1 1/4 pulgada K4', 'Manguera de polietileno para riego, medida 1 1/4 K4.', 'Polietileno', 'Negro', NULL, '5 kg', 1, 'A'),
('Manguera 1 1/4 pulgada K6', 'Manguera de polietileno para riego pesado, 1 1/4 K6.', 'Polietileno', 'Negro', NULL, '6 kg', 1, 'A'),
('Manguera 1 pulgada K4', 'Manguera estándar para riego agrícola.', 'Polietileno', 'Negro', NULL, '4 kg', 1, 'A'),
('Manguera 1 pulgada K6', 'Manguera resistente para riego agrícola.', 'Polietileno', 'Negro', NULL, '5 kg', 1, 'I'),
('Manguera 1/2 pulgada K4', 'Manguera liviana para uso en jardinería y huertas.', 'Polietileno', 'Negro', NULL, '2 kg', 1, 'A'),
('Envase 1L PET', 'Botella transparente para líquidos multipropósito.', 'PET', 'Cristal', '1 L', '35 gr', 200, 'A'),
('Pote 500cc PP', 'Pote de polipropileno para dosificación y sólidos.', 'PP', 'Blanco', '500 cc', '20 gr', 500, 'A'),
('Bidón 20L PEAD', 'Bidón de alta capacidad para líquidos industriales.', 'PEAD', 'Natural', '20 L', '800 gr', 10, 'A'),
('Tubo PVC Construcción', 'Tubo de PVC para instalaciones y sistemas de drenajes.', 'PVC', 'Gris', NULL, '1 kg', 10, 'I');


-- Tabla Sucursales
INSERT INTO Sucursales (
    Direccion, 
    Descripcion, 
    Estado
) VALUES
('RP314 km 2,3, T4101 Tafí Viejo, Tucumán', 'Fábrica principal y planta de producción.', 'A'),
('Av. República de Siria 1662, San Miguel de Tucumán', 'Punto de venta oficial y atención minorista.', 'A'),
('Av. Juan B. Justo 3450, CABA', 'Centro de distribución y ventas CABA.', 'A'),
('Ruta Nacional 9 Km 700, Córdoba', 'Depósito logístico región Centro.', 'A'),
('Av. Circunvalación 25 de Mayo 1200, Rosario, Santa Fe', 'Sucursal comercial y ventas mayoristas.', 'A'),
('Ruta Nacional 40 Km 3200, Mendoza', 'Punto de venta y distribución región Cuyo.', 'A'),
('Av. Paraguay 2500, Salta', 'Sucursal de atención al agro e industrias locales.', 'A'),
('Ruta 11 Km 1005, Resistencia, Chaco', 'Centro de distribución para el NEA.', 'A'),
('Av. Independencia 4000, Mar del Plata, Buenos Aires', 'Atención comercial costa atlántica.', 'A'),
('Calle 44 Nro 1500, La Plata, Buenos Aires', 'Oficina comercial y depósito.', 'I'),
('Ruta 22 Km 1200, Neuquén', 'Distribución para industria petrolera y agro de la Patagonia.', 'A'),
('Av. Facundo Zuviría 6500, Santa Fe', 'Sucursal comercial región Litoral.', 'A'),
('Av. San Martín 150, Ushuaia, Tierra del Fuego', 'Punto de venta austral.', 'I'),
('Ruta Nacional 3 Km 2900, Río Gallegos, Santa Cruz', 'Depósito logístico región Patagonia Sur.', 'A'),
('Av. Belgrano 2000, San Miguel de Tucumán', 'Oficinas administrativas centrales.', 'A'),
('Ruta 38 Km 15, Concepción, Tucumán', 'Punto de venta para el interior tucumano.', 'A'),
('Av. España 1050, San Juan', 'Atención comercial y depósito sector minero-agrícola.', 'A'),
('Calle Güemes 800, San Salvador de Jujuy', 'Distribuidora oficial norte.', 'A'),
('Ruta 12 Km 5.5, Posadas, Misiones', 'Centro logístico fronterizo para el Mercosur.', 'A'),
('Parque Industrial Pilar, Lote 14, Buenos Aires', 'Nueva planta de inyección y matricería en construcción.', 'I');


-- Tabla Depositos
INSERT INTO Depositos (
    IdSucursal, 
    Nombre, 
    Descripcion, 
    Estado
) VALUES
(1, 'Nave 1 - Materia Prima', 'Almacenamiento de pellets, resinas y material reciclado.', 'A'),
(1, 'Nave 2 - Producto Terminado', 'Acopio principal de productos plásticos listos para despacho.', 'A'),
(1, 'Nave 3 - Matricería', 'Depósito de moldes, repuestos e inyectoras en mantenimiento.', 'A'),
(2, 'Depósito Minorista', 'Stock rotativo para abastecer las ventas en mostrador.', 'A'),
(3, 'Centro Logístico CABA', 'Punto de distribución de envases multipropósito y cajones.', 'A'),
(4, 'Almacén Agro Centro', 'Stock enfocado en macetines y cajones cosecheros.', 'A'),
(5, 'Depósito Puerto', 'Almacenamiento temporal para logística y distribución fluvial.', 'A'),
(6, 'Galpón Cuyo', 'Acopio de cajones para vendimia y mangueras de riego.', 'A'),
(7, 'Depósito Agro Salta', 'Productos de dosificación y envases químicos para el agro.', 'A'),
(8, 'Almacén NEA', 'Centro de acopio de envases PEAD y productos reciclados.', 'A'),
(9, 'Depósito Pesquero', 'Almacén de cajones plásticos pesados para la costa atlántica.', 'A'),
(10, 'Galpón La Plata 1', 'Depósito general, actualmente sin operaciones.', 'I'),
(11, 'Nave Patagonia Norte', 'Stock de tuberías PVC y envases APM para industria.', 'A'),
(11, 'Almacén Secundario Sur', 'Apoyo logístico de envases industriales para Neuquén.', 'A'),
(12, 'Depósito Litoral', 'Almacenamiento de productos multipropósito y agroquímicos.', 'A'),
(14, 'Depósito Austral', 'Almacén especializado en mangueras K4 y K6 de alta resistencia.', 'A'),
(16, 'Depósito Interior Sur', 'Stock para atención rápida a clientes del interior tucumano.', 'A'),
(17, 'Galpón Minero', 'Acopio de envases de alta resistencia para uso industrial minero.', 'A'),
(19, 'Depósito Frontera', 'Punto de acopio para exportación a países del Mercosur.', 'A'),
(20, 'Nave Pilar (En Obra)', 'Futuro depósito centralizado de inyección, en construcción.', 'I');


-- Tabla Clientes
INSERT INTO Clientes (
	Cuit, 
    Apellidos, 
    Nombres, 
    Correo, 
    Direccion, 
    Estado
) VALUES
('20-11111111-1', 'Lopez', 'Juan', 'jlopez@agro.com', 'Av. San Martin 123, Tucumán', 'A'),
('27-22222222-2', 'Garcia', 'Maria', 'mgarcia@finca.com', 'Ruta 9 km 10, Tafí Viejo', 'A'),
('20-33333333-3', 'Perez', 'Carlos', 'cperez@industria.com', 'Calle Mitre 450, San Miguel', 'A'),
('23-44444444-4', 'Martinez', 'Laura', 'lmartinez@campo.com', 'Ruta 38 Sur, Concepción', 'A'),
('20-55555555-5', 'Gomez', 'Pedro', 'pgomez@distribuidora.net', 'Av. Belgrano 2100, CABA', 'A'),
('27-66666666-6', 'Fernandez', 'Ana', 'afernandez@vivero.com.ar', 'San Martin 50, Rosario', 'A'),
('20-77777777-7', 'Diaz', 'Diego', 'ddiaz@agropecuaria.com', 'Ruta 11 Km 50, Chaco', 'A'),
('23-88888888-8', 'Rodriguez', 'Sofia', 'srodriguez@logistica.com', 'Av. Pellegrini 900, Santa Fe', 'I'),
('20-99999999-9', 'Gonzalez', 'Luis', 'lgonzalez@limonera.com', 'Ruta 304 Km 20, Alderetes', 'A'),
('27-10101010-0', 'Sanchez', 'Elena', 'esanchez@quimicos.com', 'Parque Industrial, Pilar', 'A'),
('20-12121212-1', 'Romero', 'Jorge', 'jromero@servicios.com.ar', 'Av. Mitre 120, Mendoza', 'A'),
('27-13131313-3', 'Rojas', 'Lucia', 'lrojas@constructora.com', 'Calle España 330, Salta', 'I'),
('20-14141414-4', 'Sosa', 'Pablo', 'psosa@distribucion.com', 'Ruta 22 Km 100, Neuquén', 'A'),
('23-15151515-5', 'Ruiz', 'Paula', 'pruiz@pesquera.com', 'Av. Independencia 500, Mar del Plata', 'A'),
('20-16161616-6', 'Torres', 'Mario', 'mtorres@tuberias.com', 'Ruta 40 Km 100, San Juan', 'A'),
('27-17171717-7', 'Suarez', 'Rosa', 'rsuarez@vivero.com', 'Calle French 220, Yerba Buena', 'A'),
('20-18181818-8', 'Castro', 'Raul', 'rcastro@industrias.com', 'Av. Perón 1500, Córdoba', 'A'),
('23-19191919-9', 'Gimenez', 'Clara', 'cgimenez@logistica.com.ar', 'Ruta 12 Km 5, Posadas', 'A'),
('20-20202020-2', 'Silva', 'Hugo', 'hsilva@construcciones.com', 'Av. Colón 4000, Córdoba', 'I'),
('27-21212121-1', 'Vargas', 'Marta', 'mvargas@agro.com', 'Ruta 3 Km 500, Rio Gallegos', 'A');


-- Tabla Existencias
INSERT INTO Existencias (
    IdProducto, 
    IdDeposito, 
    Cantidad
) VALUES
(1, 2, 2500),  -- Bandejas Cosecheras en Nave 2 (Producto Terminado)
(1, 4, 300),   -- Bandejas Cosecheras en Depósito Minorista
(2, 6, 500),   -- Cajón Cosechero 45L en Almacén Agro Centro
(3, 5, 1200),  -- Cajón Organizador 45L en Centro Logístico CABA
(4, 2, 8500),  -- Embudos en Nave 2 (Producto Terminado)
(5, 9, 4000),  -- Envase 1,08L PEAD APM en Depósito Agro Salta
(6, 10, 1500), -- Envase 10L PEAD en Almacén NEA
(7, 15, 2200), -- Envase 10L Reciclado en Depósito Litoral
(8, 2, 3000),  -- Envase 5,08L PEAD APM en Nave 2 (Producto Terminado)
(9, 6, 6000),  -- Macetín 1,7L en Almacén Agro Centro
(10, 8, 1200), -- Macetín 5L PEAD en Galpón Cuyo
(11, 6, 800),  -- Macetín Autopoda en Almacén Agro Centro
(12, 13, 250), -- Manguera 1 1/4 K4 en Nave Patagonia Norte
(13, 16, 100), -- Manguera 1 1/4 K6 en Depósito Austral
(14, 8, 400),  -- Manguera 1 pulgada K4 en Galpón Cuyo
(16, 4, 150),  -- Manguera 1/2 pulgada K4 en Depósito Minorista
(17, 5, 12000),-- Envase 1L PET en Centro Logístico CABA
(18, 5, 5500), -- Pote 500cc PP en Centro Logístico CABA
(19, 18, 600), -- Bidón 20L PEAD en Galpón Minero
(20, 13, 800); -- Tubo PVC Construcción en Nave Patagonia Norte


-- Tabla Movimientos
INSERT INTO MovimientoDeProductos (
    IdCliente, 
    IdDepositoOrigen, 
    IdDepositoDestino, 
    IdUsuario, 
    Estado
) VALUES
(1, 2, 4, 1, 'F'),  -- Despacho al cliente 1 (Juan Lopez)
(2, 2, 6, 2, 'F'),  -- Envío al cliente 2 (Maria Garcia)
(NULL, 1, 2, 1, 'F'), -- Transferencia interna
(4, 2, 16, 3, 'P'), -- Envío al cliente 4 (Laura Martinez)
(5, 2, 5, 1, 'F'),  -- Despacho al cliente 5 (Pedro Gomez)
(NULL, 3, 2, 5, 'F'), 
(7, 5, 12, 2, 'P'), 
(8, 2, 15, 4, 'F'), 
(NULL, 2, 5, 1, 'F'), 
(10, 8, 11, 3, 'P'), 
(11, 2, 9, 2, 'F'), 
(12, 4, 6, 1, 'F'), 
(NULL, 15, 16, 5, 'F'), 
(14, 2, 13, 10, 'P'), 
(15, 18, 19, 2, 'F'),
(NULL, 1, 2, 11, 'F'), 
(17, 2, 17, 13, 'P'), 
(18, 5, 8, 12, 'F'), 
(NULL, 19, 14, 14, 'P'), 
(20, 2, 18, 15, 'F');


-- Tabla Linea de Movimiento
INSERT INTO LineaDeMovimientos (
    IdMovimiento, 
    IdProducto, 
    CantidadOrigen, 
    CantidadDestino, 
    PrecioFinal
) VALUES
(1, 1, 100, 100, 1500.50),   -- Despacho a cliente 1: Bandejas Cosecheras
(2, 2, 50, 50, 3200.00),     -- Despacho a cliente 2: Cajones Cosecheros 45L
(3, 4, 500, 500, NULL),      -- Transferencia interna: Embudos (sin precio)
(4, 13, 10, 10, 12000.00),   -- Despacho a cliente 4: Mangueras pesadas
(5, 17, 1000, 1000, 250.75), -- Despacho a cliente 5: Envases 1L PET
(6, 18, 2000, 2000, NULL),   -- Transferencia interna: Potes PP
(7, 8, 300, 300, 650.00),    -- Despacho a cliente 7: Envases 5L
(8, 19, 100, 100, 4500.00),  -- Despacho a cliente 8: Bidones 20L
(9, 3, 200, 198, NULL),      -- Transferencia interna: Cajones (2 rotos en viaje)
(10, 5, 500, 500, 300.00),   -- Despacho a cliente 10: Envases 1.08L
(11, 19, 150, 150, 4500.00), -- Despacho a cliente 11: Bidones 20L
(12, 9, 1000, 1000, 120.00), -- Despacho a cliente 12: Macetines 1.7L
(13, 12, 50, 50, NULL),      -- Transferencia interna: Mangueras estándar
(14, 14, 20, 20, 8500.00),   -- Despacho a cliente 14: Manguera 1 pulgada
(15, 20, 100, 95, 3800.00),  -- Despacho a cliente 15: Tubos PVC (5 mermas en frontera)
(16, 1, 500, 500, NULL),     -- Transferencia interna: Bandejas cosecheras
(17, 19, 200, 200, 4400.00), -- Despacho a cliente 17: Bidones 20L (Precio preferencial)
(18, 6, 400, 400, 1100.00),  -- Despacho a cliente 18: Envases 10L PEAD
(19, 10, 800, 800, NULL),    -- Transferencia interna: Macetín 5L
(20, 2, 300, 300, 3100.00);  -- Despacho a cliente 20: Cajones Cosecheros


-- Tabla de Lista de Precios
INSERT INTO ListaPrecio (
    Desde
) VALUES
('2024-01-01 08:00:00'), -- Lista 1 (Ajuste anual)
('2024-03-15 08:30:00'), -- Lista 2 (Ajuste por materia prima)
('2024-05-01 09:00:00'), -- Lista 3
('2024-07-10 10:15:00'), -- Lista 4
('2024-09-01 08:00:00'), -- Lista 5
('2024-11-15 11:00:00'), -- Lista 6
('2025-01-02 08:00:00'), -- Lista 7 (Ajuste anual)
('2025-02-20 09:45:00'), -- Lista 8
('2025-04-01 08:00:00'), -- Lista 9
('2025-06-15 14:30:00'), -- Lista 10
('2025-08-01 08:00:00'), -- Lista 11
('2025-10-05 10:00:00'), -- Lista 12
('2025-12-01 08:00:00'), -- Lista 13
('2026-01-02 08:30:00'), -- Lista 14 (Ajuste anual)
('2026-01-15 09:00:00'), -- Lista 15
('2026-02-01 08:00:00'), -- Lista 16
('2026-03-01 10:30:00'), -- Lista 17
('2026-03-15 11:00:00'), -- Lista 18
('2026-04-01 08:00:00'), -- Lista 19 (Lista vigente de principio de mes)
(DEFAULT);               -- Lista 20 (Lista nueva, tomará la fecha/hora de tu PC)


-- Tabla Precios
INSERT INTO Precios (
    IdProducto, 
    idListaPrecio, 
    Precio
) VALUES
-- Evolución de precio del Producto 1 (Bandeja Cosechera)
(1, 1, 1000.00),  -- Precio inicial (Enero 2024)
(1, 5, 1200.00),  -- Ajuste (Septiembre 2024)
(1, 10, 1500.00), -- Ajuste (Junio 2025)
(1, 15, 1800.00), -- Ajuste (Enero 2026)
(1, 20, 2100.00), -- Precio vigente actual

-- Evolución de precio del Producto 2 (Cajón Cosechero 45L)
(2, 1, 2500.00),  
(2, 5, 2800.00),  
(2, 10, 3200.00), 
(2, 15, 3600.00), 
(2, 20, 4000.00), 

-- Evolución de precio del Producto 5 (Envase 1,08L PEAD APM)
(5, 1, 800.00),   
(5, 5, 950.00),   
(5, 10, 1200.00), 
(5, 15, 1400.00), 
(5, 20, 1650.00), 

-- Evolución de precio del Producto 19 (Bidón 20L PEAD)
(19, 1, 3000.00), 
(19, 5, 3500.00), 
(19, 10, 4500.00), 
(19, 15, 5200.00), 
(19, 20, 6000.00);
