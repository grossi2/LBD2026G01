--
-- ER/Studio 8.0 SQL Code Generation
-- Company :      GeroSRL
-- Project :      ModeloLogicoFisico1B.DM1
-- Author :       Gero
--
-- Date Created : Saturday, April 18, 2026 16:34:10
-- Target DBMS : MySQL 5.x
--

DROP SCHEMA IF EXISTS LBD2026G01CIBERPLAS;

CREATE SCHEMA IF NOT EXISTS LBD2026G01CIBERPLAS;

USE LBD2026G01CIBERPLAS;

DROP TABLE IF EXISTS Clientes
;
DROP TABLE IF EXISTS Depositos
;
DROP TABLE IF EXISTS Existencias
;
DROP TABLE IF EXISTS LineaDeMovimientos
;
DROP TABLE IF EXISTS ListaPrecio
;
DROP TABLE IF EXISTS MovimientoDeProductos
;
DROP TABLE IF EXISTS Precios
;
DROP TABLE IF EXISTS Productos
;
DROP TABLE IF EXISTS Sucursales
;
DROP TABLE IF EXISTS Usuarios
;
-- 
-- TABLE: Clientes 
--

CREATE TABLE Clientes(
    IdCliente    CHAR(10)        NOT NULL,
    Cuit         CHAR(13) UNIQUE        NOT NULL, -- Controlamos que sea unico
    Apellidos    VARCHAR(50) CHECK (Apellidos REGEXP '^[A-ZÁÉÍÓÚÑ][a-záéíóúñ]+$'), -- Controlamos que Empiece con Mayuscula y no con un numero/simbolo
    Nombres      VARCHAR(30) CHECK (Nombres REGEXP '^[A-ZÁÉÍÓÚÑ][a-záéíóúñ]+$'), -- Controlamos que Empiece con Mayuscula y no con un numero/simbolo
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
    IdCliente            CHAR(10),
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

