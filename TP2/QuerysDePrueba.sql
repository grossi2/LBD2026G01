-- =========================================================================================================
-- Consultas
-- =========================================================================================================

SELECT * FROM Depositos;
SELECT * FROM Clientes;

/*
1. Dado un rango de fechas, listar todos los movimientos de productos realizados indicando:
ID del movimiento, fecha, nombre y apellido del usuario que lo registró, y la descripción
general del movimiento.
*/

SELECT * FROM MovimientoDeProductos;

SELECT 
    m.IdMovimiento,
    m.FechaHora AS Fecha,
    u.Nombres AS NombreUsuario,
    u.Apellidos AS ApellidoUsuario,
    -- Aquí construimos la "descripción general" combinando los nombres de los depósitos
    CONCAT('Movimiento desde ', d_origen.Nombre, ' hacia ', d_destino.Nombre) AS DescripcionGeneral
FROM 
    MovimientoDeProductos m
INNER JOIN 
    Usuarios u ON m.IdUsuario = u.IdUsuario
INNER JOIN 
    Depositos d_origen ON m.IdDepositoOrigen = d_origen.IdDeposito
INNER JOIN 
    Depositos d_destino ON m.IdDepositoDestino = d_destino.IdDeposito
WHERE 
    m.FechaHora BETWEEN '2026-05-01 00:00:00' AND '2026-05-30 23:59:59'; -- Rango de fechas de ejemplo

/*
2. Mostrar un listado que incluya el nombre de la sucursal, el nombre del depósito
y el nombre de los productos que contiene, junto con su cantidad.
*/

SELECT
	s.IdSucursal,
    d.Nombre AS Deposito,
    e.Cantidad,
    p.Nombre AS Producto
    
FROM
	Sucursales s 
INNER JOIN
	Depositos d ON s.IdSucursal = d.IdSucursal
INNER JOIN
	Existencias e ON d.IdDeposito = e.IdDeposito
INNER JOIN
	Productos p ON e.IdProducto = p.idProducto
    
ORDER BY 1; -- No lo pide pero para que sea mas legible lo ordeno por sucursal

/*
3. Calcular la cantidad total de productos disponibles en la empresa agrupados por Material
(ej. cuántos productos hay de "Plástico", cuántos de "PVC", etc.). Solo mostrar aquellos
materiales cuya cantidad total supere las 500 unidades.
*/

SELECT * FROM existencias;

SELECT
	p.Material,
    SUM(e.Cantidad) AS CantidadTotal
FROM
	Productos p
INNER JOIN
	Existencias e ON p.IdProducto = e.IdProducto
GROUP BY
	p.Material
HAVING
 	CantidadTotal >= 500;
    
/*
4. Listar los movimientos donde el IdDepositoOrigen sea distinto al
IdDepositoDestino (transferencias). Mostrar el nombre de ambos depósitos y el nombre
del producto transferido.
*/

SELECT
	m.IdMovimiento,
    d_origen.Nombre AS DepositoOrigen,
    d_destino.Nombre AS DepositoDestino,
    p.Nombre
FROM
	MovimientoDeProductos m
INNER JOIN
	LineaDeMovimientos l ON m.IdMovimiento = l.IdMovimiento
INNER JOIN
	Productos p ON l.IdProducto = p.IdProducto
INNER JOIN
	Depositos d_origen ON m.IdDepositoOrigen = d_origen.IdDeposito
INNER JOIN
	Depositos d_destino ON m.IdDepositoDestino = d_destino.IdDeposito
WHERE m.IdDepositoOrigen <> m.IdDepositoDestino
ORDER BY 1; -- No lo pide pero para que sea mas legible lo ordeno por Movimiento

/*
5. Listar todos los productos registrados en el sistema que no han tenido ningún
movimiento (entradas ni salidas) en el último mes.
*/

SELECT
	p.IdProducto,
    p.Nombre AS Producto
FROM
	Productos p 
LEFT JOIN 
	LineaDeMovimientos l ON p.IdProducto = l.IdProducto
LEFT JOIN
	MovimientoDeProductos m ON l.IdMovimiento = m.IdMovimiento AND m.FechaHora BETWEEN '2026-05-01 10:11:00' AND '2026-05-31 23:59:59' -- Rango de fechas de ejemplo
GROUP BY p.IdProducto
HAVING MAX(m.FechaHora) IS NULL;

/*6. Realizar un ranking de los 5 clientes que más productos han recibido (sumando las
cantidades de sus movimientos de salida) en un periodo determinado.
*/

SELECT
	c.IdCliente,
    c.Apellidos,
    c.Nombres,
    SUM(l.CantidadDestino) AS CantidadTotalProductos
FROM
	Clientes c
INNER JOIN
	MovimientoDeProductos m ON c.IdCliente = m.idCliente
INNER JOIN
	LineaDeMovimientos l ON m.idMovimiento = l.idMovimiento
WHERE
	m.fechaHora BETWEEN '2026-01-01 18:11:00' AND '2026-05-31 23:59:59' -- Rango de fechas de ejemplo
GROUP BY
	c.IdCliente,
    c.Apellidos,
    c.Nombres
ORDER BY
	CantidadTotalProductos DESC
    LIMIT 5;
    
/*
7. Consultar el detalle de los movimientos (líneas) para un producto específico. El alumno
debe realizar correctamente el JOIN entre MovimientoDeProductos y
LineaDeMovimientos utilizando la clave compuesta si el modelo lo requiere
*/

SELECT mp.IdMovimiento, COALESCE(CONCAT(c.Nombres, ', ', c.Apellidos), '-') Cliente, COALESCE(depo.Nombre, '-') DepoOrigen,  COALESCE(depd.Nombre, '-') DepoDestino, p.Nombre Producto, lm.CantidadOrigen, lm.CantidadDestino, COALESCE(lm.PrecioFinal, '-') PrecioFinal
FROM MovimientoDeProductos mp
JOIN LineaDeMovimientos lm ON mp.IdMovimiento = lm.IdMovimiento
JOIN Productos p ON lm.IdProducto = p.IdProducto 
LEFT JOIN Clientes c ON mp.IdCliente = c.IdCliente
LEFT JOIN Depositos depo ON mp.IdDepositoOrigen = depo.IdDeposito
LEFT JOIN Depositos depd ON mp.IdDepositoDestino = depd.IdDeposito
WHERE lm.IdProducto = 17;

/*
8. Crear una vista llamada vw_RendimientoMensual que muestre, para cada mes y año,
la cantidad total de productos movilizados (sumatoria de Cantidad en las líneas de
movimiento). Luego, realizar una consulta sobre dicha vista para mostrar solo los meses
donde la actividad fue superior al promedio histórico de la empresa.
*/

DROP VIEW IF EXISTS vw_RendimientoMensual;
CREATE VIEW vw_RendimientoMensual (Año, Mes, ProductosMovilizados) 
AS 
	SELECT YEAR(mp.FechaHora) Año, MONTH(mp.FechaHora) Mes, SUM(lm.CantidadDestino)ProductosMovilizados
    FROM MovimientoDeProductos mp
    JOIN LineaDeMovimientos lm ON mp.IdMovimiento = lm.IdMovimiento
    GROUP BY Año, Mes
    ORDER BY 1, 2;

SELECT * FROM vw_RendimientoMensual;

-- Consulta sobre meses con mayor movimiento al promedio

SELECT * 
FROM vw_RendimientoMensual
WHERE ProductosMovilizados > (SELECT AVG(ProductosMovilizados) FROM vw_RendimientoMensual);

/*
9. Crear una tabla llamada Productos_Catalogo que sea copia de Productos pero
agregue una columna tipo JSON llamada Especificaciones. Migrar los datos y guardar
en el JSON el "Color" y el "Peso". Luego, realizar una consulta que devuelva solo los
productos cuyo color sea "Azul" extrayendo el dato directamente desde el campo JSON.
*/

DROP TABLE IF EXISTS Productos_Catalogo;
CREATE TABLE Productos_Catalogo(
    IdProducto            INT             AUTO_INCREMENT,
    Nombre                VARCHAR(30)     NOT NULL,
    DescripcionGeneral    VARCHAR(255),
    Material              VARCHAR(30)     NOT NULL,
    Capacidad             VARCHAR(30),
    UnidadesPorPaquete    SMALLINT CHECK (UnidadesPorPaquete>0), -- Controlamos cantidad mayor que cero
    Especificaciones	  JSON			  NOT NULL,
    Estado                CHAR(1) CHECK (Estado IN ('A','I'))	NOT NULL, -- Controlamos estado A= Activo o I=Inactivo ,
    PRIMARY KEY (IdProducto)
)ENGINE=INNODB;

INSERT INTO Productos_Catalogo (
	IdProducto,
    Nombre, 
    DescripcionGeneral, 
    Material,
    -- COLOR
    Capacidad, 
    -- PESO
    UnidadesPorPaquete, 
    Especificaciones,
    Estado
)
SELECT IdProducto, Nombre, DescripcionGeneral, Material, Capacidad, UnidadesPorPaquete, JSON_OBJECT('Color', Color, 'Peso', Peso), Estado 
FROM Productos;

-- Justo no hay productos de color azul
SELECT Nombre, Especificaciones ->> '$.Color' Color
FROM Productos_Catalogo
WHERE Especificaciones ->> '$.Color' = 'Azul';

-- Por eso probamos con otros colores
SELECT Nombre, Especificaciones ->> '$.Color' Color
FROM Productos_Catalogo
WHERE Especificaciones ->> '$.Color' = 'Blanco';

/*
10. Realizar una vista que considere importante para su modelo. También dejar escrito el
enunciado de la misma:
	Se necesita una vista para ver las ventas historicas de la empresa con los detalles
    de la venta como ser la fecha, sucursal, vendedor, cliente, y cantidad de productos
    vendidos en cada venta
*/

DROP VIEW IF EXISTS vw_VentasHistorico;
CREATE VIEW vw_VentasHistorico (IdMovimiento, FechaHora, Sucursal, Vendedor, Cliente, CantidadDeProductos) 
AS 
	SELECT mp.IdMovimiento, mp.FechaHora, s.Direccion Sucursal, CONCAT(u.Nombres, ', ', u.Apellidos) Vendedor, CONCAT(c.Nombres, ', ', c.Apellidos) Cliente, SUM(lm.CantidadDestino) CantidadDeProductos
    FROM MovimientoDeProductos mp
    JOIN LineaDeMovimientos lm ON mp.IdMovimiento = lm.IdMovimiento
    JOIN Clientes c ON mp.IdCliente = c.IdCliente
    JOIN Usuarios u ON mp.IdUsuario = u.IdUsuario
    JOIN Depositos d ON mp.IdDepositoOrigen = d.IdDeposito
    JOIN Sucursales s ON d.IdSucursal = s.IdSucursal
    WHERE mp.IdDepositoDestino <=> NULL
    GROUP BY mp.IdMovimiento
    ORDER BY mp.FechaHora DESC;

SELECT * FROM vw_VentasHistorico;
