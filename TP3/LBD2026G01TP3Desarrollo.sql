-- Año: 2026 TP3
-- Grupo: 01
-- Integrantes: Apás David, Vargas Herrera Gerónimo
-- Tema: Fabrica de plastico
-- Nombre del Esquema: LBD2026G01CIBERPLAS
-- Plataforma (SO + Versión): Windows 10
-- Motor y Versión: MySQL Server 5.x (Community Edition)
-- GitHub Repositorio: LBD2026G01
-- GitHub Usuarios: davidApas, gerovargash

USE LBD2026G01CIBERPLAS;

-- =========================================================================================================
-- 1. Trigger de inserción
-- =========================================================================================================

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

SELECT * FROM Productos;

UPDATE Productos 
SET Color = 'Verde'
WHERE IdProducto = 2;

SELECT * FROM Productos; 
SELECT * FROM AuditoriaProductos;

-- =========================================================================================================
-- 3. Trigger de borrado
-- =========================================================================================================

INSERT INTO Productos (Nombre, DescripcionGeneral, Material, Color, Capacidad, Peso, UnidadesPorPaquete, Estado) VALUES
('Producto Prueba Insercion', 'Descripcion.', 'Reciclado', 'Varios', '1 L', '500 gr', 10, 'A');

SELECT * FROM Productos ORDER BY 1 DESC;

DELETE FROM Productos
WHERE IdProducto=last_insert_id();

SELECT * FROM Productos ORDER BY 1 DESC;
SELECT * FROM AuditoriaProductos;

-- =========================================================================================================
-- 4. Creación de un producto.
-- =========================================================================================================

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

SELECT * FROM Productos;

-- =========================================================================================================
-- 5. Modificación de un producto.
-- =========================================================================================================

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
-- 6. Borrado de un producto.
-- =========================================================================================================

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
-- 7. Buscar un producto
-- =========================================================================================================

-- Llamada 1: Salida correcta
CALL BuscarProducto(NULL, NULL, NULL, 'T');
CALL BuscarProducto('Cajon', NULL, NULL, 'T');
CALL BuscarProducto('Cajon', 'Reciclado', NULL, 'T');
CALL BuscarProducto(NULL, NULL, NULL, 'I');

-- Llamada 2: No se encontraron coincidencias (La busqueda se realiza exitosamente pero no se encuentran resultados)
CALL BuscarProducto('HOLAA', NULL, NULL, 'T');

-- Llamada 3: Estado ingresado invalido (Se viola el control interno que pide que el estado ingresado sea 'A', 'I' o 'T')
CALL BuscarProducto('HOLAA', NULL, NULL, 'G');

-- Llamada 4: Nombre ingresado invalido (Se ingresa una cadena superior a 30 caracteres para el nombre)
CALL BuscarProducto('GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG', NULL, NULL, 'T');

-- =========================================================================================================
-- 8. Listado de los movimientos, mostrando los depósitos de origen y destino.
-- Ordenados por fecha descendente. Mostrar los campos relevantes.
-- =========================================================================================================

-- Llamado 1: Salida correcta
CALL ListarMovimientos();

-- Llamado 2: Salida correcta
CALL ListarMovimientos;

-- Llamado 3: Fallo por cantidad de argumentos incorrecta
CALL ListarMovimientos('1');

-- No se pueden generar otros tipos de fallos por parte del usuario que llama al SP

-- =========================================================================================================
-- 9. Reporte por IdCliente
-- =========================================================================================================

-- Llamado 1: Salida correcta
CALL ReporteCliente(5);
CALL ReporteCliente(6);  -- Cliente sin movimientos asociados
CALL ReporteCliente(8);

-- Llamado 2: Usuario inexistente (fuera del rango de id usuarios existentes)
CALL ReporteCliente(9999);

-- Llamado 3: Usuario inexistente (id negativo)
CALL ReporteCliente(-6);

-- Llamado 4: Usuario inexistente (id nulo)
CALL ReporteCliente(NULL);

-- =========================================================================================================
-- 10. Actualizar precios por inflacion
-- Este SP debe tomar la ultima lista de precios y crear una nueva con los precios ajustados
-- a un porcentaje que se pasa como parametro, este porcentaje puede ser negativo
-- =========================================================================================================

-- Llamada 1: Salida correcta
CALL ActualizarPreciosPorcentaje(10.5, 0, @mensaje);
SELECT @mensaje;

CALL ActualizarPreciosPorcentaje(10.5, NULL, @mensaje);
SELECT @mensaje;

CALL ActualizarPreciosPorcentaje(10.5, 1000, @mensaje);
SELECT @mensaje;

CALL ActualizarPreciosPorcentaje(-99, 0, @mensaje);
SELECT @mensaje;

-- Llamada 2: Salida incorrecta, porcentaje fuera de rango
CALL ActualizarPreciosPorcentaje(-100, 0, @mensaje);
SELECT @mensaje;

-- Llamada 3: Salida incorrecta, esta variacion de precios genera precios negativos
CALL ActualizarPreciosPorcentaje(10.5, -9999999999999, @mensaje);
SELECT @mensaje;

-- Llamada 3: Salida incorrecta, porcentaje nulo
CALL ActualizarPreciosPorcentaje(NULL, 0, @mensaje);
SELECT @mensaje;

SELECT * FROM ListaPrecio ORDER BY 1 DESC;
SELECT * FROM Precios ORDER BY 2 DESC;


