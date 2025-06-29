# 🛒 Data Project 3: Plataforma E-commerce con Replicación en Tiempo Real

Este proyecto desarrolla una plataforma de e-commerce que opera en una arquitectura **multi-nube híbrida** (AWS + Google Cloud), con replicación de datos en tiempo real entre servicios críticos. La solución permite gestionar productos, procesar compras y analizar datos de ventas de forma eficiente.

---

## 🧬 Descripción General

El sistema integra diferentes servicios en la nube para brindar una solución escalable, altamente disponible y lista para análisis en tiempo real:

- **Backend sin servidor** con funciones Lambda en AWS.
- **Frontend containerizado** desplegado en Google Cloud Run.
- **Base de datos transaccional** PostgreSQL (AWS RDS).
- **Replicación continua** de datos hacia BigQuery mediante Google Cloud DataStream.
- **Infraestructura como código** con Terraform.

---

## 🔧 Componentes del Sistema

### 🔹 Backend (AWS Lambda)
- Desarrollado en Python 3.x.
- Funciones:
  - `getProducts`: Lista todos los productos.
  - `addproduct`: Agrega nuevos productos con validación.
  - `buyproduct`: Registra compras y ajusta inventario.
- Conectado a RDS PostgreSQL.
- Desplegado dentro de una VPC con subredes segregadas.

### 🔸 Frontend (Google Cloud Run)
- Aplicación web construida con Flask.
- Interfaz simple para agregar productos y realizar compras.
- Comunica con AWS Lambda.

### 🔁 Sincronización de Datos
- Google Cloud DataStream sincroniza datos desde PostgreSQL hacia BigQuery.
- Tablas replicadas automáticamente para mantener datos actualizados para análisis.

### 📊 Almacén de Datos (BigQuery)
- Dataset: `moviesdb`.


---


