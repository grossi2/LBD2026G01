# Laboratorio de Bases de Datos — Trabajo Práctico N°2

**Universidad Nacional de Tucumán — Facultad de Ciencias Exactas y Tecnología**  
**Autores:** Apás, David · Vargas Herrera, Gerónimo  
**Fecha:** 01/06/2026

---

## Descripción del dominio

El sistema desarrollado está orientado a **Ciberplas S.A.**, una empresa productora de artículos plásticos con operaciones a nivel nacional e internacional. La empresa cuenta con una casa central en Tafí Viejo y una sucursal en San Miguel, cada una con sus propios depósitos.

El software centraliza la información que hasta el momento se registraba manualmente o en planillas Excel, y cubre los siguientes aspectos del negocio:

- **Gestión de productos**: caracterización completa (nombre, capacidad, material, color, peso, unidades por paquete, descripción).
- **Gestión de inventario**: seguimiento de existencias por depósito y por sucursal.
- **Gestión de movimientos**: registro de ingresos, egresos y traslados de productos entre depósitos, con trazabilidad del usuario responsable.
- **Gestión de ventas y clientes**: historial de ventas, precios (con listas de precios por fecha) y datos de clientes (nombre, CUIT, domicilio, teléfono, correo).
- **Gestión de usuarios**: control de acceso basado en roles (Dueño, Encargado de Planta, Encargado de Depósito, Vendedor).
- **Gestión de sucursales y depósitos**: alta, baja y modificación de las unidades operativas de la empresa.

---

## Herramienta de modelado

Los modelos lógico y físico de la base de datos fueron diseñados con **ER/Studio**.

---

## Requisitos previos

- **MySQL Workbench 8.0 CE** instalado.
- Acceso a una instancia de MySQL Server en ejecución.

---

## Cómo ejecutar el script SQL

1. Abrir **MySQL Workbench 8.0 CE**.
2. Conectarse a la instancia de MySQL Server deseada.
3. En el menú superior ir a **File → Open SQL Script...** y seleccionar el archivo `.sql` del proyecto.
4. Revisar que el script incluya la creación de la base de datos (o crearla manualmente con `CREATE DATABASE ciberplas;` y luego `USE ciberplas;`).
5. Ejecutar el script completo con el botón ⚡ (**Execute**) o con el atajo `Ctrl + Shift + Enter`.
6. Verificar en el panel **Schemas** que todas las tablas fueron creadas correctamente.

> **Nota:** El sistema se entrega con un usuario inicial con rol `Dueño` ya configurado. Se recomienda cambiar su contraseña al momento de poner el software en producción.

---

## Estructura del repositorio

```
/
├── README.md
├── script.sql          # Script de creación de la base de datos
└── LBD2026G01TP1Informe.pdf  # Informe del trabajo práctico
```
