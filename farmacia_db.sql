-- =========================================================
-- Script de Base de Datos: Sistema de Farmacia
-- Motor: MySQL 8+
-- Generado a partir del diagrama relacional (relaciones 1:N)
-- =========================================================

CREATE DATABASE IF NOT EXISTS farmacia_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE farmacia_db;

SET FOREIGN_KEY_CHECKS = 0;

-- Elimina tablas existentes (orden inverso por dependencias)
DROP TABLE IF EXISTS `detalle_metodos_pago`;
DROP TABLE IF EXISTS `metodos_pago`;
DROP TABLE IF EXISTS `detalle_ventas`;
DROP TABLE IF EXISTS `ventas`;
DROP TABLE IF EXISTS `usuarios`;
DROP TABLE IF EXISTS `roles`;
DROP TABLE IF EXISTS `clientes`;
DROP TABLE IF EXISTS `lotes`;
DROP TABLE IF EXISTS `detalle_compras`;
DROP TABLE IF EXISTS `medicamentos`;
DROP TABLE IF EXISTS `presentaciones`;
DROP TABLE IF EXISTS `compras`;
DROP TABLE IF EXISTS `proveedores`;
DROP TABLE IF EXISTS `casas_medicas`;

SET FOREIGN_KEY_CHECKS = 1;

-- -----------------------------------------------
-- Tabla: casas_medicas (CasaMedica)
-- -----------------------------------------------
CREATE TABLE `casas_medicas` (
  `id_casa_medica` INT NOT NULL AUTO_INCREMENT,
  `nombre_casa_medica` VARCHAR(150) NOT NULL,
  `estado_casa_medica` TINYINT(1) DEFAULT 1,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_casa_medica`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------
-- Tabla: proveedores (Proveedor)
-- -----------------------------------------------
CREATE TABLE `proveedores` (
  `id_proveedor` INT NOT NULL AUTO_INCREMENT,
  `nombre_proveedor` VARCHAR(150) NOT NULL,
  `estado_proveedor` TINYINT(1) DEFAULT 1,
  `telefono_proveedor` VARCHAR(150),
  `direccion_proveedor` VARCHAR(150),
  `correo_proveedor` VARCHAR(150),
  `total_adquirido_proveedor` DECIMAL(12,2) DEFAULT 0,
  `cantidad_adquirido_proveedor` INT DEFAULT 0,
  `id_casa_medica` INT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_proveedor`),
  CONSTRAINT `fk_proveedores_id_casa_medica` FOREIGN KEY (`id_casa_medica`) REFERENCES `casas_medicas` (`id_casa_medica`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------
-- Tabla: compras (Compra)
-- -----------------------------------------------
CREATE TABLE `compras` (
  `id_compra` INT NOT NULL AUTO_INCREMENT,
  `fecha_compra` DATE NOT NULL,
  `total_compra` DECIMAL(12,2) DEFAULT 0,
  `estado_compra` TINYINT(1) DEFAULT 1,
  `id_proveedor` INT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_compra`),
  CONSTRAINT `fk_compras_id_proveedor` FOREIGN KEY (`id_proveedor`) REFERENCES `proveedores` (`id_proveedor`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------
-- Tabla: presentaciones (Presentacion)
-- -----------------------------------------------
CREATE TABLE `presentaciones` (
  `id_presentacion` INT NOT NULL AUTO_INCREMENT,
  `nombre_presentacion` VARCHAR(150) NOT NULL,
  `estado_presentacion` TINYINT(1) DEFAULT 1,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_presentacion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------
-- Tabla: medicamentos (Medicamento)
-- -----------------------------------------------
CREATE TABLE `medicamentos` (
  `id_medicamento` INT NOT NULL AUTO_INCREMENT,
  `codigo_barras_medicamento` VARCHAR(150),
  `nombre_medicamento` VARCHAR(150) NOT NULL,
  `cantidad_por_paquete` INT DEFAULT 1,
  `precio_mayorista` DECIMAL(12,2) DEFAULT 0,
  `precio_minimo` DECIMAL(12,2) DEFAULT 0,
  `precio_venta` DECIMAL(12,2) DEFAULT 0,
  `componente_activo` VARCHAR(150),
  `estado_medicamento` TINYINT(1) DEFAULT 1,
  `venta_libre` TINYINT(1) DEFAULT 1,
  `existencia_total_medicamento` INT DEFAULT 0,
  `id_presentacion` INT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_medicamento`),
  CONSTRAINT `fk_medicamentos_id_presentacion` FOREIGN KEY (`id_presentacion`) REFERENCES `presentaciones` (`id_presentacion`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------
-- Tabla: detalle_compras (DetalleCompra)
-- -----------------------------------------------
CREATE TABLE `detalle_compras` (
  `id_detalle_compra` INT NOT NULL AUTO_INCREMENT,
  `cantidad_compra` INT NOT NULL,
  `subtotal_compra` DECIMAL(12,2) NOT NULL,
  `estado_compra` TINYINT(1) DEFAULT 1,
  `id_compra` INT NULL,
  `id_proveedor` INT NULL,
  `id_medicamento` INT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_detalle_compra`),
  CONSTRAINT `fk_detalle_compras_id_compra` FOREIGN KEY (`id_compra`) REFERENCES `compras` (`id_compra`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_detalle_compras_id_proveedor` FOREIGN KEY (`id_proveedor`) REFERENCES `proveedores` (`id_proveedor`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_detalle_compras_id_medicamento` FOREIGN KEY (`id_medicamento`) REFERENCES `medicamentos` (`id_medicamento`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------
-- Tabla: lotes (Lote)
-- -----------------------------------------------
CREATE TABLE `lotes` (
  `id_lote` INT NOT NULL AUTO_INCREMENT,
  `fecha_vencimiento` DATE NOT NULL,
  `fecha_produccion` DATE,
  `precio_lote` DECIMAL(12,2) DEFAULT 0,
  `estado_lote` TINYINT(1) DEFAULT 1,
  `existencia_lote` INT DEFAULT 0,
  `id_medicamento` INT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_lote`),
  CONSTRAINT `fk_lotes_id_medicamento` FOREIGN KEY (`id_medicamento`) REFERENCES `medicamentos` (`id_medicamento`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------
-- Tabla: clientes (Cliente)
-- -----------------------------------------------
CREATE TABLE `clientes` (
  `id_cliente` INT NOT NULL AUTO_INCREMENT,
  `nombre_cliente` VARCHAR(150) NOT NULL,
  `nit_cliente` VARCHAR(150),
  `estado_cliente` TINYINT(1) DEFAULT 1,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_cliente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------
-- Tabla: roles (Rol)
-- -----------------------------------------------
CREATE TABLE `roles` (
  `id_rol` INT NOT NULL AUTO_INCREMENT,
  `nombre_rol` VARCHAR(150) NOT NULL,
  `estado_rol` TINYINT(1) DEFAULT 1,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_rol`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------
-- Tabla: usuarios (Usuario)
-- -----------------------------------------------
CREATE TABLE `usuarios` (
  `id_usuario` INT NOT NULL AUTO_INCREMENT,
  `usuario` VARCHAR(150) NOT NULL UNIQUE,
  `password` VARCHAR(150) NOT NULL,
  `nombre_usuario` VARCHAR(150),
  `telefono_usuario` VARCHAR(150),
  `correo_usuario` VARCHAR(150),
  `dpi_usuario` VARCHAR(150),
  `estado_usuario` TINYINT(1) DEFAULT 1,
  `id_rol` INT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_usuario`),
  CONSTRAINT `fk_usuarios_id_rol` FOREIGN KEY (`id_rol`) REFERENCES `roles` (`id_rol`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------
-- Tabla: ventas (Venta)
-- -----------------------------------------------
CREATE TABLE `ventas` (
  `id_venta` INT NOT NULL AUTO_INCREMENT,
  `fecha_venta` DATETIME NOT NULL,
  `estado_venta` TINYINT(1) DEFAULT 1,
  `total_venta` DECIMAL(12,2) DEFAULT 0,
  `id_usuario` INT NULL,
  `id_cliente` INT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_venta`),
  CONSTRAINT `fk_ventas_id_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_ventas_id_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------
-- Tabla: detalle_ventas (DetalleVenta)
-- -----------------------------------------------
CREATE TABLE `detalle_ventas` (
  `id_detalle_venta` INT NOT NULL AUTO_INCREMENT,
  `cantidad_detalle_venta` INT NOT NULL,
  `subtotal_detalle_venta` DECIMAL(12,2) NOT NULL,
  `estado_detalle_venta` TINYINT(1) DEFAULT 1,
  `id_medicamento` INT NULL,
  `id_venta` INT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_detalle_venta`),
  CONSTRAINT `fk_detalle_ventas_id_medicamento` FOREIGN KEY (`id_medicamento`) REFERENCES `medicamentos` (`id_medicamento`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_detalle_ventas_id_venta` FOREIGN KEY (`id_venta`) REFERENCES `ventas` (`id_venta`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------
-- Tabla: metodos_pago (MetodoPago)
-- -----------------------------------------------
CREATE TABLE `metodos_pago` (
  `id_metodo_pago` INT NOT NULL AUTO_INCREMENT,
  `nombre_metodo_pago` VARCHAR(150) NOT NULL,
  `cuenta_metodo_pago` VARCHAR(150),
  `estado_metodo_pago` TINYINT(1) DEFAULT 1,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_metodo_pago`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------
-- Tabla: detalle_metodos_pago (DetalleMetodoPago)
-- -----------------------------------------------
CREATE TABLE `detalle_metodos_pago` (
  `id_detalle_metodos_pago` INT NOT NULL AUTO_INCREMENT,
  `cantidad_detalle_metodos_pago` DECIMAL(12,2) NOT NULL,
  `estado_detalle_metodos_pago` TINYINT(1) DEFAULT 1,
  `id_metodo_pago` INT NULL,
  `id_venta` INT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_detalle_metodos_pago`),
  CONSTRAINT `fk_detalle_metodos_pago_id_metodo_pago` FOREIGN KEY (`id_metodo_pago`) REFERENCES `metodos_pago` (`id_metodo_pago`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_detalle_metodos_pago_id_venta` FOREIGN KEY (`id_venta`) REFERENCES `ventas` (`id_venta`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =========================================================
-- Datos iniciales (seed)
-- =========================================================

INSERT INTO `roles` (`nombre_rol`, `estado_rol`) VALUES
  ('Administrador', 1),
  ('Vendedor', 1),
  ('Bodeguero', 1);

-- Usuario admin por defecto (usuario: admin / password: admin123 -> reemplazar hash real al crear vía API)
-- Se recomienda crear el usuario admin a través de POST /api/auth/register para que la contraseña se hashee correctamente.

INSERT INTO `metodos_pago` (`nombre_metodo_pago`, `cuenta_metodo_pago`, `estado_metodo_pago`) VALUES
  ('Efectivo', NULL, 1),
  ('Tarjeta de crédito', NULL, 1),
  ('Tarjeta de débito', NULL, 1),
  ('Transferencia bancaria', NULL, 1);

INSERT INTO `presentaciones` (`nombre_presentacion`, `estado_presentacion`) VALUES
  ('Tableta', 1),
  ('Jarabe', 1),
  ('Cápsula', 1),
  ('Inyectable', 1),
  ('Crema', 1);
