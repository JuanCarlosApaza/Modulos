# Arquitectura del Proyecto — Guía Completa

> Documento de referencia para continuar el desarrollo en cualquier sesión.
> Última actualización: 2026-09-17

---

## 1. Estructura del Monorepo

```
github.com/tu-usuario/sistemas/
│
├── modulos/                          ← Módulos reutilizables
│   ├── modulo_clientes/
│   ├── modulo_productos/
│   ├── modulo_ventas/
│   ├── modulo_usuarios/
│   ├── modulo_inventario/
│   └── modulo_citas/
│
├── sistema_ventas/                   ← Proyecto independiente
│   ├── lib/
│   │   ├── main.dart
│   │   └── modules/
│   ├── backend/
│   ├── pubspec.yaml
│   └── android/
│
├── sistema_gimnasio/
├── sistema_peluqueria/
└── sistema_reportes/
```

**Reglas:**
- 1 solo repo de GitHub con todo
- Cada `sistema_X/` es un proyecto Flutter completo e independiente
- Los módulos en `modulos/` se comparten entre sistemas
- Cada sistema importa solo los módulos que necesita

---

## 2. Arquitectura de Módulos (Clean Architecture)

Cada módulo sigue la misma estructura interna:

```
modulo_X/
├── backend/src/
│   ├── datasources/
│   │   ├── x_datasource.dart              ← Interfaz abstracta
│   │   └── x_datasource_impl.dart         ← Implementación HTTP
│   ├── models/x_dto.dart                  ← Data Transfer Object
│   └── repositories/x_repository_impl.dart ← Mapeo DTO ↔ Entity
│
├── database/src/migrations/
│   └── 01_X.sql                           ← Schema PostgreSQL
│
├── frontend/src/
│   ├── controllers/x_controller.dart      ← ChangeNotifier
│   ├── screens/x_screen.dart              ← Layout/Composición
│   ├── widgets/
│   │   ├── x_table.dart                   ← Tabla de datos
│   │   ├── x_form.dart                    ← Formulario CRUD
│   │   └── x_actions.dart                 ← Diálogos de confirmación
│   └── routes/x_routes.dart               ← Definición de rutas
│
└── shared/src/domain/
    ├── entities/x.dart                    ← Entidad de dominio
    ├── repositories/iX_repository.dart     ← Interfaz del repositorio
    ├── usecases/x_usecases.dart            ← Casos de uso (Failure?, T?)
    └── failures/failure.dart               ← Server/Cache/Validation/NotFound
```

**Patrones clave:**
- **State management:** `ChangeNotifier` (Provider-style)
- **Data flow:** Screen → Controller → Datasource → HTTP → API → DTO
- **Domain layer:** Entities separadas de DTOs, use cases con `(Failure?, T?)` tuples
- **Repository pattern:** Interfaz abstracta en domain, implementación en backend
- **Sin barrel exports:** Cada archivo se importa directamente

---

## 3. Sistema de Licencias Offline

### Concepto
- Keys con fecha de expiración + firma digital (HMAC/RSA)
- Multi-dispositivo: una key válida para N dispositivos
- Device fingerprinting: lockea la key al hardware
- Sin servidor central necesario
- App móvil para generar keys

### Estructura de la Key
```
Key: A7X9-K2M4-P8L1-X5R3
├─ Client: Peluquería López
├─ System: ventas
├─ Devices: 4 (máximo)
├─ Expires: 2026-10-17
└─ Signature: (firma digital)
```

### Flujo
1. Vender sistema → generar key con 1 mes gratis
2. Cliente instala → ingresa key → se lockea al device_id
3. Pasa el mes → sistema bloqueado
4. Cliente paga → generar nueva key con nueva fecha
5. Cliente ingresa nueva key → se desbloquea

### license.json (en cada dispositivo)
```json
{
  "key": "A7X9-K2M4-P8L1-X5R3",
  "device_id": "PC-ABC-123",
  "device_slot": 1,
  "max_devices": 4,
  "expires_at": "2026-10-17"
}
```

### Control desde app móvil
- Lista de clientes con keys activas
- Dispositivos usados vs máximo
- Fecha de expiración
- Generar nueva key / extender licencia

---

## 4. Despliegue Dual

### Docker (PC del cliente)
- Backend corre como servidor con Docker
- Base de datos: PostgreSQL
- Múltiples dispositivos se conectan al servidor
- Instalación: `docker-compose up`

### Móvil (APK)
- Sin backend, sin servidor
- Base de datos: SQLite local en el teléfono
- Todo funciona offline
- Instalación: instalar APK

### Abstracción de base de datos
```dart
abstract class IDatabase {
  Future<List<Map>> query(String sql);
  Future<void> execute(String sql, [List params]);
}

class PostgresDatabase implements IDatabase { ... }  // Para Docker
class SqliteDatabase implements IDatabase { ... }     // Para móvil
```

### Tabla comparativa
| | Docker (PostgreSQL) | Móvil (SQLite) |
|---|---|---|
| Servidor | Sí, en la PC | No, todo local |
| Multi-dispositivo | Sí | No, solo ese celular |
| Internet | Necesario | No necesita |
| Instalación | Docker | APK |

---

## 5. Patrón de Herencia de Módulos

### Módulos compartidos vs customizados
- **Backend + domain layer:** Siempre compartidos (lógica de negocio idéntica)
- **Frontend (widgets, screens):** Personalizable por sistema

### Override por sistema
Cuando un sistema necesita algo diferente:
```
sistema_ventas/lib/modules/modulo_ventas/
└── frontend/src/widgets/venta_table.dart  ← Versión personalizada

modulos/modulo_ventas/
└── frontend/src/widgets/venta_table.dart  ← Versión base
```

El sistema usa su copia local. Si no tiene override, usa la base compartida.

### Cuándo copiar vs compartir
| Situación | Acción |
|---|---|
| Módulo igual en todos | Usar compartido |
| Cambio pequeño en UI | Override solo ese archivo |
| Cambio grande / lógica diferente | Copiar módulo completo al sistema |

---

## 6. Backend API

### Stack
- **Servidor:** Dart + Shelf + shelf_router
- **Puerto:** 8080
- **DB:** PostgreSQL (Docker) o SQLite (móvil)

### Endpoints
| Módulo | Endpoint | Métodos |
|---|---|---|
| Productos | `/api/productos` | GET, POST, PUT, DELETE |
| Ventas | `/api/ventas` | GET, POST, DELETE |
| Clientes | `/api/clientes` | GET, POST, PUT, DELETE |
| Usuarios | `/api/usuarios` | GET, POST, PUT, DELETE |
| Citas | `/api/citas` | GET, POST, PUT, DELETE |
| Inventario | `/api/inventario` | GET, PUT, DELETE |
| Notificaciones | `/api/notificaciones` | GET, POST, PUT, DELETE |
| Configuración | `/api/configuracion` | GET, POST, PUT, DELETE |

### Helpers multi-DB (IMPORTANT)
```dart
/// Convierte cualquier tipo de DB a double.
/// Compatible con PostgreSQL (String), MySQL (double), SQLite (int/double).
double _toDouble(dynamic value) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

/// Convierte cualquier tipo de DB a int.
int _toInt(dynamic value) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}
```

**Regla:** NO usar casts SQL de PostgreSQL (`::float8`). Siempre usar helpers Dart para compatibilidad multi-DB.

### Problema resuelto: numeric → double
PostgreSQL retorna columnas `numeric`/`DECIMAL` como `String` en Dart. Los helpers `_toDouble()` y `_toInt()` resuelven esto de forma compatible con cualquier DB.

---

## 7. Módulos Existentes y Sus Entidades

| Módulo | Entity | DTO | Use Cases | API |
|---|---|---|---|---|
| modulo_clientes | Cliente | ClienteDto | Obtener, Crear, Actualizar, Eliminar | /api/clientes |
| modulo_producto | Producto, Categoria | ProductoDto, CategoriaDto | Obtener, Crear, Actualizar, Eliminar | /api/productos |
| modulo_venta | Venta, VentaDetalle | VentaDto, VentaDetalleDto | Obtener, Crear, Eliminar | /api/ventas |
| modulo_usuarios | Usuario, Rol | UsuarioDto, RolDto | Obtener, Crear, Actualizar, Eliminar, Roles | /api/usuarios |
| modulo_citas | Cita | CitaDto | Obtener, Crear, Actualizar, Eliminar, PorCliente, PorFecha | /api/citas |
| modulo_inventario | Inventario, MovimientoInventario | InventarioDto, MovimientoInventarioDto | Obtener, StockBajo, Movimientos, Registrar | /api/inventario |
| modulo_notificaciones | Notificacion | NotificacionDto | Obtener, Crear, MarcarLeida, Eliminar | /api/notificaciones |
| modulo_configuracion | Configuracion | ConfiguracionDto | Obtener, Crear, Actualizar, Eliminar | /api/configuracion |

---

## 8. Sistemas Planificados

| Sistema | Módulos | Despliegue |
|---|---|---|
| **Ventas** | usuarios, clientes, productos, ventas, inventario | Docker + APK |
| **Gimnasio** | usuarios, clientes, citas, inventario | Docker + APK |
| **Peluquería** | usuarios, clientes, citas, inventario | Docker + APK |
| **Reportes** | usuarios, reportes, configuración | Docker + APK |

---

## 9. Pendiente / Próximos Pasos

- [ ] Crear estructura de los 4 sistemas (sistema_ventas/, sistema_gimnasio/, etc.)
- [ ] Implementar módulo `modulo_licencia` con key generation + device fingerprinting
- [ ] Crear app móvil para generar keys (Flutter)
- [ ] Implementar abstracción `IDatabase` (PostgreSQL + SQLite)
- [ ] Responsividad Android (conversación separada)
- [ ] Configurar Docker Compose para cada sistema
- [ ] Migrar módulos a la estructura de monorepo
