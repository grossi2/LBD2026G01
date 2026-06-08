-- =========================================================================================================
-- =========================================================================================================
	
	Antes de comenzar a correr los triggers y SPs en el script llamado "LBD2026G01TP3Desarrollo" se debe
correr todo el codigo presente en el script llamado "LBD2026G01TP3GeneracionDeLaBD"
-- _________________________________________________________________________________________________________


-- =========================================================================================================
	TRIGGERS:
-- =========================================================================================================
	
	1. Creacion:
		Para verificar este trigger se puede ejecutar el codigo presente entre las lineas 16 y 35 
	del script llamado "LBD2026G01TP3Desarrollo", aqui se observara como se agrega un producto a la
	tabla de "Productos" y en consecuencia como este tambien se agrega a la tabla "AuditoriaProductos"
	
	2. Modificacion:
		Similar al apartado anterior pero se debe ejecutar el codigo en las lineas 40 y 48

	3. Borrado:
		Similar al apartado 1. pero se debe ejecutar el codigo en las lineas 52 y 63


-- =========================================================================================================
	SPs:
-- =========================================================================================================

	4. Creación de un producto:
		Una vez se corre todo el codigo presente en "LBD2026G01TP3GeneracionDeLaBD" los SPs que
	se piden en el trabajo practico son creados, por lo que para probarlos se deja en el archivo
	"LBD2026G01TP3Desarrollo" llamados de prueba con distintos casos. Para este enunciado los llamados
	de prueba se encuentran entre las lineas 67 y 85.

	5. Modificación de un producto: 
		Llamadas de prueba entre las lineas 89 y 107

	6. Borrado de un producto: 
		Llamadas de prueba entre las lineas 111 y 127

	7. Búsqueda de un producto:
		Llamadas de prueba entre las lineas 131 y 146

	8. Listado de los movimientos, mostrando los depósitos de origen y destino. Ordenados por fecha 
	descendente. Mostrar los campos relevantes:
		Llamadas de prueba entre las lineas 151 y 162

	9. Implementar un procedimiento almacenado que, dado un IdCliente, devuelva un reporte consolidado 
	con:
	● Fecha, Usuario y nombres de los Depósitos (Origen/Destino).
	● Cantidad total de productos y monto total del movimiento
	● Orden Cronológico descendente por fecha.
		Se interpreta como deposito destino a la direccion del cliente. Llamadas de prueba entre 
	las lineas 166 y 180		

	10. Realizar un procedimiento almacenado con alguna funcionalidad que considere de interés:
		Se considera necesario para el sistema alguna manera rapida de actualizar la lista de 
	precios de manera general, para ello se crea un SP. Llamadas de prueba entre las lineas 186 y 208

















