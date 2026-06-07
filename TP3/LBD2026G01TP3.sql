-- Año: 2026 TP3
-- Grupo: 01
-- Integrantes: Apás David, Vargas Herrera Gerónimo
-- Tema: Fabrica de plastico
-- Nombre del Esquema: LBD2026G01CIBERPLAS
-- Plataforma (SO + Versión): Windows 10
-- Motor y Versión: MySQL Server 5.x (Community Edition)
-- GitHub Repositorio: LBD2026G01
-- GitHub Usuarios: davidApas, gerovargash

-- =========================================================================================================
-- 1. Trigger de inserción
-- =========================================================================================================
DROP TABLE IF EXISTS AuditoriaProductos;

CREATE TABLE AuditoriaProductos(
	Id INT NOT NULL AUTO_INCREMENT,
    IdProducto            INT,
    Nombre                VARCHAR(30)     NOT NULL,
    DescripcionGeneral    VARCHAR(255),
    Material              VARCHAR(30)     NOT NULL,
    Color                 VARCHAR(30)     NOT NULL,
    Capacidad             VARCHAR(30),
    Peso                  VARCHAR(30)     NOT NULL,
    UnidadesPorPaquete    SMALLINT CHECK (UnidadesPorPaquete>0), -- Controlamos cantidad mayor que cero
    Estado                CHAR(1) CHECK (Estado IN ('A','I'))	NOT NULL, -- Controlamos estado A= Activo o I=Inactivo ,
    Tipo CHAR(1) NOT NULL, -- tipo de operación (I: Inserción, B: Borrado, M: Modificación)
    Usuario VARCHAR(45) NOT NULL,  
    Maquina VARCHAR(45) NOT NULL,  
    Fecha DATETIME NOT NULL,
    PRIMARY KEY (Id)
)ENGINE = InnoDB;

DROP TRIGGER IF EXISTS Trig_Productos_Insercion;

DELIMITER //
CREATE TRIGGER Trig_Productos_Insercion 
AFTER INSERT ON Productos FOR EACH ROW
BEGIN
	INSERT INTO AuditoriaProductos VALUES (
		DEFAULT, 
		NEW.IDProducto,
		NEW.Nombre, 
        NEW.DescripcionGeneral,
        NEW.Material,
        NEW.Color,
        NEW.Capacidad,
        NEW.Peso,
        NEW.UnidadesPorPaquete,
        NEW.Estado,
		'I', 
		SUBSTRING_INDEX(USER(), '@', 1), 
		SUBSTRING_INDEX(USER(), '@', -1), 
		NOW()
  );
END //
DELIMITER ;

SELECT * FROM Productos;
SELECT * FROM AuditoriaProductos;

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
('Producto Prueba Insercion', 'Descripcion.', 'Reciclado', 'Varios', '1 L', '500 gr', 10, 'A');


SELECT * FROM Productos;
SELECT * FROM AuditoriaProductos;

-- =========================================================================================================
-- 2. Trigger de modificacion
-- =========================================================================================================

DROP TRIGGER IF EXISTS Trig_Productos_Modificacion;

DELIMITER //
CREATE TRIGGER Trig_Productos_Modificacion 
AFTER UPDATE ON Productos FOR EACH ROW
BEGIN
	-- valores viejos
	INSERT INTO AuditoriaProductos VALUES (
		DEFAULT, 
		OLD.IDProducto,
		OLD.Nombre, 
        OLD.DescripcionGeneral,
        OLD.Material,
        OLD.Color,
        OLD.Capacidad,
        OLD.Peso,
        OLD.UnidadesPorPaquete,
        OLD.Estado,
		'M', 
		SUBSTRING_INDEX(USER(), '@', 1), 
		SUBSTRING_INDEX(USER(), '@', -1), 
		NOW()
	);
    -- valores nuevos
	INSERT INTO AuditoriaProductos VALUES (
		DEFAULT, 
		NEW.IDProducto,
		NEW.Nombre, 
        NEW.DescripcionGeneral,
        NEW.Material,
        NEW.Color,
        NEW.Capacidad,
        NEW.Peso,
        NEW.UnidadesPorPaquete,
        NEW.Estado,
		'M', 
		SUBSTRING_INDEX(USER(), '@', 1), 
		SUBSTRING_INDEX(USER(), '@', -1), 
		NOW()
	);    
END //
DELIMITER ;

SELECT * FROM Productos;

UPDATE Productos 
SET Color = 'Verde'
WHERE IdProducto = 22;

SELECT * FROM Productos; 
SELECT * FROM AuditoriaProductos;


-- =========================================================================================================
-- 3. Trigger de borrado
-- =========================================================================================================
DROP TRIGGER IF EXISTS Trig_Productos_Borrado;

DELIMITER //
CREATE TRIGGER Trig_Productos_Borrado 
AFTER DELETE ON Productos FOR EACH ROW
BEGIN
    -- Guardamos la "foto" del producto justo después de ser borrado de Ciberplas S.A.
    INSERT INTO AuditoriaProductos VALUES (
        DEFAULT, 
        OLD.IDProducto,
        OLD.Nombre, 
        OLD.DescripcionGeneral,
        OLD.Material,
        OLD.Color,
        OLD.Capacidad,
        OLD.Peso,
        OLD.UnidadesPorPaquete,
        OLD.Estado,
        'B', -- 'B' indica que la operación fue un Borrado
        SUBSTRING_INDEX(USER(), '@', 1), 
        SUBSTRING_INDEX(USER(), '@', -1), 
        NOW()
    );
END //
DELIMITER ;

SELECT * FROM Productos;

DELETE FROM Productos
WHERE IdProducto=23;

SELECT * FROM AuditoriaProductos;
-- =========================================================================================================
-- 4. Creación de un producto.
-- =========================================================================================================

DROP PROCEDURE IF EXISTS AltaProducto;

DELIMITER //
CREATE PROCEDURE AltaProducto(pNombre VARCHAR(30), pDescripcionGeneral VARCHAR(255), pMaterial VARCHAR(30), pColor VARCHAR(30), pCapacidad VARCHAR(30), pPeso VARCHAR(30), pUnidadesPorPaquete SMALLINT, pEstado CHAR(1), OUT mensaje VARCHAR(100))
-- Crea un producto siempre y cuando Nombre,Material,Color,Peso y Estado sean NOT NULL
-- Ademas UnidadesPorPaquete sea > 0 y se verifica que el Estado sea el Activo o Inactivo
-- La cláusula LEAVE permite salir del flujo de control que tiene la etiqueta dada
-- Si la etiqueta es para el bloque más externo, se puede salir de todo el procedimiento.
SALIR: BEGIN  

	IF (pNombre IS NULL) OR (pMaterial IS NULL) OR (pColor IS NULL) OR (pPeso IS NULL) OR (pEstado IS NULL) THEN
		SET mensaje = 'Error en los datos del Producto, complete los campos nulos';
        LEAVE SALIR;
	ELSEIF (pUnidadesPorPaquete <= 0) THEN
		SET mensaje = 'Error en los datos del Producto, debe indicar una cantidad de unidades por paquete mayor a 0';
        LEAVE SALIR;
	ELSEIF (pEstado NOT IN ('A','I')) THEN
		SET mensaje = 'Error en los datos: El estado debe ser A (Activo) o I (Inactivo).';
        LEAVE SALIR;
	ELSE
		INSERT INTO Productos (
			Nombre, DescripcionGeneral, Material, Color, Capacidad, Peso, UnidadesPorPaquete, Estado
		) VALUES (pNombre, pDescripcionGeneral, pMaterial, pColor, pCapacidad, pPeso, pUnidadesPorPaquete, pEstado);
        SET mensaje = 'Producto creado con éxito';
    END IF;
END //
DELIMITER ;

-- Llamada 1: Salida correcta (Pasa todas las validaciones)
CALL AltaProducto('Contenedor 50L', 'Contenedor apilable', 'Plástico', 'Azul', '50 L', '2 kg', 5, 'A', @mensaje_alta);
SELECT @mensaje_alta AS 'Resultado 1 (Correcto)';

-- Llamada 2: Error lógico por campo NULO (Falla la primera validación, falta el Material)
CALL AltaProducto('Balde', 'Balde de limpieza', NULL, 'Rojo', '10 L', '500 gr', 10, 'A', @mensaje_alta);
SELECT @mensaje_alta AS 'Resultado 2 (Error Null)';

-- Llamada 3: Error lógico por cantidad (Falla la validación de unidades <= 0)
CALL AltaProducto('Silla Plástica', 'Uso exterior', 'PVC', 'Blanca', 'N/A', '1.5 kg', 0, 'A', @mensaje_alta);
SELECT @mensaje_alta AS 'Resultado 3 (Error Cantidad)';

-- Llamada 4: Error lógico por estado (Falla la validación del estado)
CALL AltaProducto('Mesa Plástica', 'Uso exterior', 'PVC', 'Blanca', 'N/A', '4 kg', 1, 'X', @mensaje_alta);
SELECT @mensaje_alta AS 'Resultado 4 (Error Estado)';

Select * FROM Productos;

-- =========================================================================================================
-- 5. Modificación de un producto.
-- =========================================================================================================

DROP PROCEDURE IF EXISTS ModificarProducto;

DELIMITER //
CREATE PROCEDURE ModificarProducto(pIdProducto INT, pNombre VARCHAR(30), pDescripcionGeneral VARCHAR(255), pMaterial VARCHAR(30), pColor VARCHAR(30), pCapacidad VARCHAR(30), pPeso VARCHAR(30), pUnidadesPorPaquete SMALLINT, pEstado CHAR(1), OUT mensaje VARCHAR(100))

BEGIN  
	-- Controlo que exista un producto con es ID
    IF NOT EXISTS (SELECT 1 FROM Productos  WHERE IdProducto=pIdProducto) THEN
		SET mensaje = 'Error: El ID de producto indicado no existe en el sistema.';
	-- Controlo los campos NOT NULL
	ELSEIF (pNombre IS NULL) OR (pMaterial IS NULL) OR (pColor IS NULL) OR (pPeso IS NULL) OR (pEstado IS NULL) THEN
		SET mensaje = 'Error en los datos del Producto, complete los campos nulos';
	-- Controlo UnidadesPorPaquete > 0
	ELSEIF (pUnidadesPorPaquete <= 0) THEN
		SET mensaje = 'Error en los datos del Producto, debe indicar una cantidad de unidades por paquete mayor a 0';
	-- Controlo valor Estado
	ELSEIF (pEstado NOT IN ('A','I')) THEN
		SET mensaje = 'Error en los datos: El estado debe ser A (Activo) o I (Inactivo).';
	-- Modifico
	ELSE
		UPDATE Productos SET
			Nombre = pNombre, 
            DescripcionGeneral = pDescripcionGeneral, 
            Material = pMaterial, 
            Color = pColor, 
            Capacidad = pCapacidad, 
            Peso = pPeso, 
            UnidadesPorPaquete = pUnidadesPorPaquete, 
            Estado = pEstado
		WHERE IdProducto=pIdProducto;
        SET mensaje = 'Producto modificado con éxito';
    END IF;
END //
DELIMITER ;

-- Llamada 1: Salida correcta (Modificamos el Bidón 20L para hacerlo "Reforzado" y cambiarle el color)
CALL ModificarProducto(19, 'Bidón 20L PEAD Reforzado', 'Bidón de alta capacidad para químicos', 'PEAD', 'Blanco', '20 L', '850 gr', 10, 'A', @mensaje_modificacion);
SELECT @mensaje_modificacion AS 'Resultado 1 (Correcto)';

-- Llamada 2: Error lógico por campo NULO (Falta el Material al querer actualizar una Manguera)
CALL ModificarProducto(12, 'Manguera 1 1/4 pulgada', 'Manguera de polietileno para riego', NULL, 'Negro', 'N/A', '5 kg', 1, 'A', @mensaje_modificacion);
SELECT @mensaje_modificacion AS 'Resultado 2 (Error Null)';

-- Llamada 3: Error lógico por cantidad (Intentamos dejar las unidades en 0 para el Envase PET)
CALL ModificarProducto(17, 'Envase 1L PET', 'Botella transparente multipropósito', 'PET', 'Cristal', '1 L', '35 gr', 0, 'A', @mensaje_modificacion);
SELECT @mensaje_modificacion AS 'Resultado 3 (Error Cantidad)';

-- Llamada 4: Error lógico por estado (Intentamos poner un estado inexistente en el Pote PP)
CALL ModificarProducto(18, 'Pote 500cc PP', 'Pote para dosificación y sólidos', 'PP', 'Blanco', '500 cc', '20 gr', 500, 'X', @mensaje_modificacion);
SELECT @mensaje_modificacion AS 'Resultado 4 (Error Estado)';

Select * FROM Productos;

-- =========================================================================================================
-- 5. Borrado de un producto.
-- =========================================================================================================

DROP PROCEDURE IF EXISTS BorrarProducto;

DELIMITER //
CREATE PROCEDURE BorrarProducto(IN pIdProducto INT, OUT mensaje VARCHAR(100))
BEGIN
	-- Controlo que ID del producto no sea nuelo
    IF (pIdProducto IS NULL) THEN
	SET mensaje = 'Error: Debe proporcionar un ID de producto válido, no puede ser nulo.';
        
    -- Controlo que ID del producto no sea ni cero o negativo
    ELSEIF (pIdProducto <= 0) THEN
	SET mensaje = 'Error: El ID del producto debe ser un número mayor a cero.';
        
    -- Verificamos si el producto realmente está en la fábrica
    ELSEIF NOT EXISTS (SELECT 1 FROM Productos WHERE IdProducto = pIdProducto) THEN
	SET mensaje = 'Error: El ID de producto indicado no existe en el sistema.';
	
    ELSE
		DELETE FROM LineaDeMovimientos WHERE idProducto = pIdProducto;
		DELETE FROM Existencias WHERE idProducto = pIdProducto;
		DELETE FROM Precios WHERE idProducto = pIdProducto;
		DELETE FROM Productos WHERE IdProducto=pIdProducto;
        
        SET mensaje = 'Operación exitosa: El producto y todo su historial de precios fueron eliminados.';
		
    END IF;
END  // 
DELIMITER 

-- Llamada 1: Salida correcta (Elimina el Macetín Autopoda 5L y sus precios)
CALL BorrarProducto(15, @mensaje_borrado);
SELECT @mensaje_borrado AS 'Resultado 1 (Correcto)';

-- Llamada 2: Error lógico por Nulo (No se envía ningún ID)
CALL BorrarProducto(NULL, @mensaje_borrado);
SELECT @mensaje_borrado AS 'Resultado 2 (Error Null)';

-- Llamada 3: Error lógico por número inválido (Se envía un ID negativo o cero)
CALL BorrarProducto(-5, @mensaje_borrado);
SELECT @mensaje_borrado AS 'Resultado 3 (Error ID Negativo o cero)';

-- Llamada 4: Error lógico por ID inexistente (Intentamos borrar un ID que no está en Ciberplas)
CALL BorrarProducto(9999, @mensaje_borrado);
SELECT @mensaje_borrado AS 'Resultado 4 (Error No Existe)';

-- =========================================================================================================
-- 6. Buscar un producto.
-- =========================================================================================================

DROP PROCEDURE IF EXISTS BuscarProducto;

DELIMITER //
CREATE PROCEDURE BuscarProducto(IN pIdProducto INT, OUT mensaje VARCHAR(100))
BEGIN
	-- Controlo que ID del producto no sea nuelo
    IF (pIdProducto IS NULL) THEN
	SET mensaje = 'Error: Debe proporcionar un ID de producto válido, no puede ser nulo.';
        
    -- Controlo que ID del producto no sea ni cero o negativo
    ELSEIF (pIdProducto <= 0) THEN
	SET mensaje = 'Error: El ID del producto debe ser un número mayor a cero.';
        
    -- Verificamos si el producto realmente está en la fábrica
    ELSEIF NOT EXISTS (SELECT 1 FROM Productos WHERE IdProducto = pIdProducto) THEN
	SET mensaje = 'Error: El ID de producto indicado no existe en el sistema.';
	
    ELSE
		SELECT * FROM Productos WHERE IdProducto=pIdProducto;
        SET mensaje = 'Operación exitosa: Se encontro el producto solicitado.';
		
    END IF;
END  // 
DELIMITER 

-- Llamada 1: Salida correcta (Busca y devuelve los datos del Macetín 1,7L)
CALL BuscarProducto(9, @mensaje_busqueda);
SELECT @mensaje_busqueda AS 'Resultado 1 (Correcto)';

-- Llamada 2: Error Logico Por Nulo (Intenta buscar sin pasar un ID)
CALL BuscarProducto(NULL, @mensaje_busqueda);
SELECT @mensaje_busqueda AS 'Resultado 2 (Error Null)';

-- Llamada 3: Error Logico por numero Invalido (Negativo o cero)
CALL BuscarProducto(-5, @mensaje_busqueda);
SELECT @mensaje_busqueda AS 'Resultado 3 (Error Negativo o cero)';

-- Llamada 4: Error Logico por ID Inexistente (No encuentra dicho ID en la tabla)
CALL BuscarProducto(12, @mensaje_busqueda);
SELECT @mensaje_busqueda AS 'Resultado 4 (Id Inexistente)';


/*
8. Listado de los movimientos, mostrando los depósitos de origen y destino.
Ordenados por fecha descendente. Mostrar los campos relevantes.
*/