CREATE DATABASE IF NOT EXISTS megamarket;
USE megamarket;

CREATE TABLE usuario (
  id_usuario UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email STRING NOT NULL UNIQUE,
  password_hash STRING NOT NULL,
  nombre STRING NOT NULL,
  region STRING NOT NULL CHECK (region IN ('AMERICA', 'EUROPA'))
);

CREATE TABLE producto (
  id_producto UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nombre STRING NOT NULL,
  descripcion STRING,
  precio DECIMAL(12,2) NOT NULL,
  activo BOOL NOT NULL DEFAULT TRUE
);

CREATE TABLE pedido (
  id_pedido UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  id_usuario UUID NOT NULL REFERENCES usuario(id_usuario),
  fecha_pedido TIMESTAMP NOT NULL DEFAULT now(),
  total DECIMAL(12,2) NOT NULL,
  region STRING NOT NULL CHECK (region IN ('AMERICA', 'EUROPA')),
  estado STRING NOT NULL DEFAULT 'pendiente'
);

CREATE TABLE detalle_pedido (
  id_detalle UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  id_pedido UUID NOT NULL REFERENCES pedido(id_pedido),
  id_producto UUID NOT NULL REFERENCES producto(id_producto),
  cantidad INT NOT NULL,
  precio_unitario DECIMAL(12,2) NOT NULL
);
