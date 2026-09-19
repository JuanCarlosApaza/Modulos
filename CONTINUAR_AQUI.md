# Guía de Continuidad - Sistema Modular Dart/Flutter

## Estado Actual del Proyecto

### Completado ✓

| Componente | Estado | Ubicación |
|------------|--------|-----------|
| Arquitectura Clean | ✓ | `modulos_base/` |
| SQL Migrations | ✓ | 9 módulos (usuarios, producto, cliente, venta, citas, inventario, reportes, notificaciones, configuración) |
| Domain Layer (shared/) | ✓ | Entidades, interfaces, use cases, failures |
| Data Layer (backend/) | ✓ | Datasources, DTOs, repository implementations |
| Database Connection | ✓ | PostgreSQL con `postgres` v3.x |
| Backend API Server | ✓ | `backend/` con shelf + shelf_router |
| Frontend Dashboard | ✓ | `lib/` con diseño AeuxGlobal |
| Integración Frontend-Backend | ✓ | HTTP requests desde Flutter al backend |

### Pendiente

| Componente | Estado | Notas |
|------------|--------|-------|
| CRUD completo (formularios) | ✗ | Solo lectura por ahora |
| State Management | ✗ | Usando setState, falta Riverpod/Bloc |
| Tests | ✗ | Unit y widget tests |
| Autenticación | ✗ | Login/JWT pendiente |

---

## Estructura del Proyecto

```
modulos/
├── lib/                          # Flutter app (frontend)
│   ├── main.dart                 # Entry point
│   ├── screens/                  # Pantallas
│   │   ├── dashboard_screen.dart
│   │   ├── usuarios_screen.dart
│   │   ├── productos_screen.dart
│   │   ├── clientes_screen.dart
│   │   └── ventas_screen.dart
│   ├── widgets/                  # Widgets reutilizables
│   ├── theme/                    # Colores y estilos
│   ├── datasources/              # Conexión HTTP al backend
│   │   ├── interfaces/           # Contratos abstractos
│   │   ├── usuario_datasource_impl.dart
│   │   ├── cliente_datasource_impl.dart
│   │   ├── producto_datasource_impl.dart
│   │   └── venta_datasource_impl.dart
│   ├── models/                   # DTOs para HTTP
│   └── core/                     # Config DB (para scripts)
│
├── backend/                      # Servidor Dart API
│   ├── bin/server.dart           # Entry point del servidor
│   ├── lib/
│   │   ├── src/
│   │   │   ├── config/server_config.dart  # Config (host, port, db)
│   │   │   └── database.dart              # Conexión PostgreSQL
│   │   └── routes/               # Endpoints REST
│   │       ├── usuarios_routes.dart
│   │       ├── productos_routes.dart
│   │       ├── clientes_routes.dart
│   │       └── ventas_routes.dart
│   └── pubspec.yaml
│
├── modulos_base/                 # Módulos reutilizables (Domain)
│   ├── modulo_usuarios/
│   │   ├── shared/src/domain/    # Entidades, interfaces, use cases
│   │   └── backend/              # DTOs, datasources, repos
│   ├── modulo_producto/
│   ├── modulo_cliente/
│   └── modulo_venta/
│
├── core/                         # Infraestructura compartida
│   └── database_core/            # Config PostgreSQL, migraciones
│
└── scripts/                      # Scripts de utilidad
    ├── run_migrations.dart
    ├── reset_migrations.dart
    └── check_tables.dart
```

---

## Cómo Ejecutar

### 1. Base de Datos PostgreSQL

```bash
# Asegurar que PostgreSQL esté corriendo en localhost:5432
# Base de datos: Modulos_dev
# Usuario: postgres
# Password: carlos2026
```

### 2. Ejecutar Migraciones

```bash
dart run scripts/run_migrations.dart
```

### 3. Iniciar Backend API

```bash
cd backend
dart pub get
dart run bin/server.dart
```

El servidor corre en `http://localhost:8080`

### 4. Iniciar Frontend Flutter

```bash
flutter pub get
flutter run -d edge --web-port=9090
```

La app corre en `http://localhost:9090`

---

## API Endpoints

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | /api/usuarios | Listar usuarios |
| GET | /api/usuarios/:id | Obtener usuario por ID |
| POST | /api/usuarios | Crear usuario |
| PUT | /api/usuarios/:id | Actualizar usuario |
| DELETE | /api/usuarios/:id | Eliminar usuario |
| GET | /api/productos | Listar productos |
| POST | /api/productos | Crear producto |
| GET | /api/clientes | Listar clientes |
| POST | /api/clientes | Crear cliente |
| GET | /api/ventas | Listar ventas |
| POST | /api/ventas | Crear venta |

---

## Datos de Conexión PostgreSQL

```dart
// backend/lib/src/config/server_config.dart
host: 'localhost'
port: 5432
database: 'Modulos_dev'
username: 'postgres'
password: 'carlos2026'
```

---

## Tablas en PostgreSQL

```sql
-- Creadas por migraciones en modulos_base/*/database/src/migrations/
roles, usuarios, categorias, productos, clientes, ventas, venta_detalles, citas, inventario, movimientos_inventario, notificaciones, configuracion, _migrations
```

---

## Dependencias Clave

### Flutter (pubspec.yaml)
```yaml
dependencies:
  postgres: ^3.0.0    # PostgreSQL (para scripts)
  http: ^1.2.0        # Cliente HTTP
```

### Backend (backend/pubspec.yaml)
```yaml
dependencies:
  shelf: ^1.4.0
  shelf_router: ^1.1.4
  postgres: ^3.0.0
```

---

## Arquitectura Clean Architecture

```
Domain (shared/) ← Data (backend/) ← Presentation (frontend/)
     ↑                  ↑
   Entidades         Datasources
   Interfaces        Repositories
   Use Cases         DTOs
   Failures
```

**Reglas de dependencia:**
- Domain no importa nada externo
- Data importa Domain
- Frontend importa Domain y hace HTTP a Backend
- Backend importa PostgreSQL

---

## Próximos Pasos Recomendados

1. **CRUD Completo** — Agregar formularios de creación/edición
2. **State Management** — Migrar a Riverpod o Bloc
3. **Tests** — Unit tests para use cases, widget tests para pantallas
4. **Autenticación** — Login con JWT
5. **Validación** — Formularios con validación de campos
6. **Paginación** — Para listas grandes de datos
7. **Búsqueda** — Filtrado en tiempo real

## Módulos Implementados

| Módulo | Descripción | Estado |
|--------|-------------|--------|
| `modulo_inventario` | Control de stock, movimientos (entradas/salidas), alertas de stock bajo | ✓ |
| `modulo_reportes` | Dashboard con métricas, ventas por período, productos más vendidos | ✓ |
| `modulo_notificaciones` | Alertas de sistema, notificaciones push, historial | ✓ |
| `modulo_configuracion` | Configuración general del sistema, parámetros de negocio | ✓ |

## Próximos Módulos Recomendados

| Módulo | Descripción | Prioridad |
|--------|-------------|-----------|
| `moduloProveedor` | Gestión de proveedores, órdenes de compra | Alta |
| `moduloCotizaciones` | Crear y gestionar cotizaciones para clientes | Media |
| `moduloDevoluciones` | Gestión de devoluciones y notas de crédito | Media |
| `moduloAuditoria` | Log de acciones del sistema, trazabilidad | Baja |

---

## Notas Importantes

- El frontend **NO** puede conectarse directamente a PostgreSQL desde el navegador
- Siempre pasar por el backend API (`http://localhost:8080`)
- Los módulos en `modulos_base/` son domain puro (Dart sin Flutter)
- El frontend usa imports relativos (`../models/...`) porque los archivos están en `lib/`
- CORS está habilitado en el backend para desarrollo
