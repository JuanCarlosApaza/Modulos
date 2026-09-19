# 📱 Módulos

[![CI](https://github.com/<tu-usuario>/modulos/actions/workflows/ci.yml/badge.svg)](https://github.com/<tu-usuario>/modulos/actions/workflows/ci.yml)
[![Deploy](https://github.com/<tu-usuario>/modulos/actions/workflows/deploy-web.yml/badge.svg)](https://github.com/<tu-usuario>/modulos/actions/workflows/deploy-web.yml)

Sistema de gestión modular con Flutter y backend Dart.

## 🚀 Funcionalidades

- **Frontend**: Aplicación Flutter multiplataforma (Web, Android, iOS, Windows, Linux)
- **Backend**: API REST con Dart Shelf
- **Base de datos**: PostgreSQL
- **CI/CD**: GitHub Actions automatizado

## 📦 Estructura del Proyecto

```
modulos/
├── lib/                    # Código fuente Flutter
├── backend/                # Backend Dart
│   ├── bin/               # Punto de entrada
│   └── lib/               # Lógica del servidor
├── test/                   # Tests
├── scripts/               # Scripts de utilidad
├── .github/workflows/     # CI/CD GitHub Actions
└── pubspec.yaml           # Dependencias Flutter
```

## 🔧 Requisitos

- Flutter SDK 3.27.x o superior
- Dart SDK 3.13.3 o superior
- Backend: Dart SDK 3.13.3+

## 🏃‍♂️ Inicio Rápido

### Frontend
```bash
# Instalar dependencias
flutter pub get

# Ejecutar en desarrollo
flutter run -d chrome    # Web
flutter run -d windows   # Windows
flutter run -d linux     # Linux

# Build
flutter build web --release
flutter build apk --release
```

### Backend
```bash
cd backend

# Instalar dependencias
dart pub get

# Ejecutar servidor
dart run bin/server.dart
```

## 🧪 Tests

```bash
# Ejecutar todos los tests
flutter test

# Con cobertura
flutter test --coverage

# Analizar código
flutter analyze
```

## 🚀 CI/CD

### Pipelines Automáticos

| Pipeline | Trigger | Descripción |
|----------|---------|-------------|
| **CI** | Push/PR a main/develop | Lint, Tests, Builds |
| **Deploy** | Push a main | Deploy automático a GitHub Pages |
| **Release** | Tag v* | Build completo + GitHub Release |

### Deploy Web
La app se despliega automáticamente a:
```
https://<tu-usuario>.github.io/modulos/
```

### Crear Release
```bash
git tag v1.0.0
git push origin v1.0.0
```

Esto generará:
- APK Android
- App Bundle Android
- Build Web (zip)
- Build Windows (zip)
- Build Linux (zip)

Ver [CICD.md](CICD.md) para más detalles.

## 📝 Scripts Utilitarios

```bash
# Verificar conexión a BD
dart run scripts/test_connection.dart

# Ejecutar migraciones
dart run scripts/run_migrations.dart

# Resetear migraciones
dart run scripts/reset_migrations.dart

# Verificar tablas
dart run scripts/check_tables.dart
```

## 📚 Documentación

- [Guía de Arquitectura](ARCHITECTURE_GUIDE.md)
- [CI/CD](CICD.md)
- [Continuar Aquí](CONTINUAR_AQUI.md)

## 🤝 Contribuir

1. Crea una branch para tu feature (`git checkout -b feature/nueva-funcionalidad`)
2. Commit tus cambios (`git commit -m 'Add nueva funcionalidad'`)
3. Push a la branch (`git push origin feature/nueva-funcionalidad`)
4. Abre un Pull Request

## 📄 Licencia

Licencia privada. Todos los derechos reservados.
