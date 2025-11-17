# 🗄️ Base de Datos Distribuida - Megamarket

## 🧩 Cluster CockroachDB en Docker (4 Nodos, Master-Master)

Este proyecto implementa una base de datos distribuida usando CockroachDB ejecutado en un cluster Docker con 4 nodos: dos asignados a América y dos a Europa.  
Todos los nodos aceptan lectura y escritura (master–master) y los datos se replican automáticamente entre ellos.

---

## 🚀 Puesta en marcha

### 1️⃣ Resetear el entorno (opcional)

```bash
docker compose down -v
```

### 2️⃣ Levantar el cluster

```bash
docker compose up -d
```

### 3️⃣ Verificar nodos activos

```bash
docker ps
```

---

## 🏗️ Inicialización del cluster

Ejecutar **solo una vez**:

```bash
docker exec -it america1 cockroach init --insecure
```

---

## 🧠 Conexión al SQL

Entrar al shell interactivo:

```bash
docker exec -it america1 cockroach sql --insecure
```

Salir del modo interactivo:

```text
\q
```

---

## 📦 Operaciones ABM (Alta, Baja, Modificación)

> Todas estas operaciones se pueden ejecutar desde **cualquier nodo**, demostrando la replicación automática.

### ➕ Crear (INSERT)

```bash
docker exec -it america1 cockroach sql --insecure -e \
"INSERT INTO megamarket.usuario (email, password_hash, nombre, region)
 VALUES ('cliente_usa@test.com', 'hash', 'Juan USA', 'AMERICA');"
```

---

### 📖 Leer (SELECT)

Ver todos los usuarios:

```bash
docker exec -it america1 cockroach sql --insecure -e \
"SELECT * FROM megamarket.usuario;"
```

Obtener IDs para luego modificar:

```bash
docker exec -it america1 cockroach sql --insecure -e \
"SELECT id_usuario, email, nombre FROM megamarket.usuario;"
```

---

### ✏️ Modificar (UPDATE)

> Reemplazar `AQUI_EL_UUID` por un identificador real obtenido del `SELECT` anterior.

```bash
docker exec -it america1 cockroach sql --insecure -e \
"UPDATE megamarket.usuario
  SET nombre = 'USUARIO EDITADO',
      password_hash = 'updated'
 WHERE id_usuario = 'AQUI_EL_UUID';"
```

---

### 🗑️ Eliminar (DELETE)

```bash
docker exec -it europa1 cockroach sql --insecure -e \
"DELETE FROM megamarket.usuario
  WHERE nombre = 'USUARIO EDITADO';"
```

---

## 🛠️ Validación de replicación

Después de insertar, actualizar o eliminar datos, ejecutar en otro nodo (por ejemplo, `europa1`):

```bash
docker exec -it europa1 cockroach sql --insecure -e \
"SELECT * FROM megamarket.usuario;"
```

Si los resultados coinciden en los distintos nodos, la replicación está funcionando correctamente.

---

## 🧪 Extra: Simulación de caída de nodo (opcional)

Pausar nodo:

```bash
docker pause europa2
```

Reanudar nodo:

```bash
docker unpause europa2
```

Luego, validar que los datos sigan sincronizados tras el retorno del nodo (por ejemplo, con otro `SELECT`):

```bash
docker exec -it europa1 cockroach sql --insecure -e \
"SELECT * FROM megamarket.usuario;"
```
